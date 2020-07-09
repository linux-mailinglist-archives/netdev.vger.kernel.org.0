Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB8121A07F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgGINIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:08:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35601 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgGINIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:08:17 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jtWHd-0001Iq-Q4; Thu, 09 Jul 2020 13:08:13 +0000
Date:   Thu, 9 Jul 2020 15:08:11 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Matt Denton <mpdenton@google.com>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>,
        Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 6/7] seccomp: Introduce addfd ioctl to seccomp user
 notifier
Message-ID: <20200709130811.zjyn6ptsd3rss3j4@wittgenstein>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-7-keescook@chromium.org>
 <20200707133049.nfxc6vz6vcs26m3b@wittgenstein>
 <202007082307.EB5BAD3A0@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007082307.EB5BAD3A0@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 11:12:02PM -0700, Kees Cook wrote:
> On Tue, Jul 07, 2020 at 03:30:49PM +0200, Christian Brauner wrote:
> > Hm, maybe change that description to sm like:
> > 
> > [...]
> 
> Cool, yeah. Thanks! I've tweaked it a little more
> 
> > > +	/* 24 is original sizeof(struct seccomp_notif_addfd) */
> > > +	if (size < 24 || size >= PAGE_SIZE)
> > > +		return -EINVAL;
> > 
> > Hm, so maybe add the following:
> > 
> > #define SECCOMP_NOTIFY_ADDFD_VER0 24
> > #define SECCOMP_NOTIFY_ADDFD_LATEST SECCOMP_NOTIFY_ADDFD_VER0
> > 
> > and then place:
> > 
> > BUILD_BUG_ON(sizeof(struct seccomp_notify_addfd) < SECCOMP_NOTIFY_ADDFD_VER0);
> > BUILD_BUG_ON(sizeof(struct open_how) != SECCOMP_NOTIFY_ADDFD_LATEST);
> 
> Yes, good idea (BTW, did the EA syscall docs land?)

I'll be giving a kernel summit talk about extensible syscalls to come to
some agreement on a few things. After this we'll update the doc patch
we have now and merge it. :)

> 
> I've made these SECCOMP_NOTIFY_ADDFD_SIZE_* to match your examples below
> (i.e.  I added "SIZE" to what you suggested above).

Yup, sounds good!

> 
> > somewhere which is what we do for clone3(), openat2() and others to
> > catch build-time nonsense.
> > 
> > include/uapi/linux/perf_event.h:#define PERF_ATTR_SIZE_VER0     64      /* sizeof first published struct */
> > include/uapi/linux/sched.h:#define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
> > include/uapi/linux/sched/types.h:#define SCHED_ATTR_SIZE_VER0   48      /* sizeof first published struct */
> > include/linux/fcntl.h:#define OPEN_HOW_SIZE_VER0        24 /* sizeof first published struct */
> > include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER0
> 
> The ..._SIZE_VER0 and ...LATEST stuff doesn't seem useful to export via
> UAPI. Above, 2 of the 3 export to uapi. Is there a specific rationale
> for which should and which shouldn't?

I think openat2() just didn't think it was useful. I find them helpful
because I often update codebase to the newest struct I know about:

struct clone_args {
	__aligned_u64 flags;
	__aligned_u64 pidfd;
	__aligned_u64 child_tid;
	__aligned_u64 parent_tid;
	__aligned_u64 exit_signal;
	__aligned_u64 stack;
	__aligned_u64 stack_size;
	__aligned_u64 tls;
/* CLONE_ARGS_SIZE_VER0 64 */
	__aligned_u64 set_tid;
	__aligned_u64 set_tid_size;
/* CLONE_ARGS_SIZE_VER1 80 */
	__aligned_u64 cgroup;
/* CLONE_ARGS_SIZE_VER2 88 */
};

But bumping it means I can't use:

clone3(&clone_args, sizeof(clone));

everywhere in the codebase because I'm fscking over everyone on older
kernels now. :)

Soin various parts of the codebase I will just use:

clone3(&clone_args, CLONE_ARGS_SIZE_VER0);

because I don't care about any of the additional features and I don't
need the kernel to copy any of the other stuff. Then in other parts of
the codebase I want to set_tid so I use:

clone3(&clone_args, CLONE_ARGS_SIZE_VER1);

This way I can also set "templates", i.e.

struct clone_args clone_template1 = {
	.flags		|= CLONE_CLEAR_SIGHAND,
	.exit_signal	= SIGCHLD,
	.set_tid	= 1000,
	.set_tid_size	= 1,
};

and then use the same struct for:

clone3(&clone_template1, CLONE_ARGS_SIZE_VER0);
clone3(&clone_template1, CLONE_ARGS_SIZE_VER1);

Whereas sizeof(clone_template1) would always give me
CLONE_ARGS_SIZE_VER2.

Christian
