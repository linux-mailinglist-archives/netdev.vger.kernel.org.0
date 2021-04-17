Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F3B363141
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 18:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhDQQt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 12:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbhDQQt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 12:49:28 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AF8C061574;
        Sat, 17 Apr 2021 09:49:01 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXo7p-0066DK-Ix; Sat, 17 Apr 2021 16:48:53 +0000
Date:   Sat, 17 Apr 2021 16:48:53 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
Message-ID: <YHsRdTqgurSCykt7@zeniv-ca.linux.org.uk>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com>
 <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
 <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
 <YHpeTKV2Y+sjuzbD@zeniv-ca.linux.org.uk>
 <CAADnVQLOZ7QL61_XPCSmxDfZ0OHX_pBOmpEWLjSUwqhLm_10Jw@mail.gmail.com>
 <20210417143639.kq3nafzlsridtbb6@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417143639.kq3nafzlsridtbb6@ast-mbp>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 07:36:39AM -0700, Alexei Starovoitov wrote:

> The kernel will perform the same work with FDs. The same locks are held
> and the same execution conditions are in both cases. The LSM hooks,
> fsnotify, etc will be called the same way.
> It's no different if new syscall was introduced "sys_foo(int num)" that
> would do { return close_fd(num); }.
> It would opearate in the same user context.

Hmm...  unless I'm misreading the code, one of the call chains would seem to
be sys_bpf() -> bpf_prog_test_run() -> ->test_run() -> ... -> bpf_sys_close().
OK, as long as you make sure bpf_prog_get() does fdput() (i.e. that we
don't have it restructured so that fdget()/fdput() pair would be lifted into
bpf_prog_test_run(), with fdput() moved in place of bpf_prog_put()).

Note that we *really* can not allow close_fd() on anything to be bracketed
by fdget()/fdput() pair; we had bugs of that sort and, as the matter of fact,
still have one in autofs_dev_ioctl().

The trouble happens if you have file F with 2 references, held by descriptor
tables of different processes.  Say, process A has descriptor 6 refering to
it, while B has descriptor 42 doing the same.  Descriptor tables of A and B
are not shared with anyone.

A: fdget(6) 	-> returns a reference to F, refcount _not_ touched
A: close_fd(6)	-> rips the reference to F from descriptor table, does fput(F)
		   refcount drops to 1.
B: close(42)	-> rips the reference to F from B's descriptor table, does fput(F)
		   This time refcount does reach 0 and we use task_work_add() to
		   make sure the destructor (__fput()) runs before B returns to
		   userland.  sys_close() returns and B goes off to userland.
		   On the way out __fput() is run, and among other things,
		   ->release() of F is executed, doing whatever it wants to do.
		   F is freed.
And at that point A, which presumably is using the guts of F, gets screwed.

In case of autofs_dev_ioctl(), it's possible for a thread to end up blocked
inside copy_to_user(), with autofs functions in call chains *AND* module
refcount of autofs not pinned by anything.  The effects of returning into a
function that used to reside in now unmapped page are obviously not pretty...

Basically, the rule is
	* never remove from descriptor table if you currently have an outstadning
fdget() (i.e. without having done the matching fdput() yet).

	That, obviously, covers all ioctls - there we have fdget() done
by sys_ioctl() on the issuing descriptor.  In your case you seem to be
safe, but it's a bloody dangerous minefield - you really need a big warning
in all call sites.  The worst part is that it won't happen with intended
use, so it doesn't show up in routine regression testing.  In particular,
for autofs the normal case is AUTOFS_DEV_IOCTL_CLOSEMOUNT getting passed
a file descriptor of something mounted and *not* the descriptor of
/dev/autofs we are holding fdget() on.  However, there's no way to prevent
a malicious call when we pass exactly that.

	So please, mark all call sites with "make very sure you never get
here with unpaired fdget()".

	BTW, if my reading (re ->test_run()) is correct, what limits the recursion
via bpf_sys_bpf()?
