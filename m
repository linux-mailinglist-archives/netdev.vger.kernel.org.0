Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C893E4DB5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhHIURC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:17:02 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:59044 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhHIURB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:17:01 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDBhJ-009Lr8-Ed; Mon, 09 Aug 2021 20:16:33 +0000
Date:   Mon, 9 Aug 2021 20:16:33 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
Message-ID: <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 08:04:40PM +0000, Al Viro wrote:
> On Mon, Aug 09, 2021 at 12:40:03PM -0700, Shoaib Rao wrote:
> 
> > Page faults occur all the time, the page may not even be in the cache or the
> > mapping is not there (mmap), so I would not consider this a bug. The code
> > should complain about all other calls as they are also copying  to user
> > pages. I must not be following some semantics for the code to be triggered
> > but I can not figure that out. What is the recommended interface to do user
> > copy from kernel?
> 
> 	What are you talking about?  Yes, page faults happen.  No, they
> must not be triggered in contexts when you cannot afford going to sleep.
> In particular, you can't do that while holding a spinlock.
> 
> 	There are things that can't be done under a spinlock.  If your
> commit is attempting that, it's simply broken.

... in particular, this

+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+               mutex_lock(&u->iolock);
+               unix_state_lock(sk);
+
+               err = unix_stream_recv_urg(state);
+
+               unix_state_unlock(sk);
+               mutex_unlock(&u->iolock);
+#endif

is 100% broken, since you *are* attempting to copy data to userland between
spin_lock(&unix_sk(s)->lock) and spin_unlock(&unix_sk(s)->lock).

You can't do blocking operations under a spinlock.  And copyout is inherently
a blocking operation - it can require any kind of IO to complete.  If you
have the destination (very much valid - no bad addresses there) in the middle
of a page mmapped from a file and currently not paged in, you *must* read
the current contents of the page, at least into the parts of page that
are not going to be overwritten by your copyout.  No way around that.  And
that can involve any kind of delays and any amount of disk/network/whatnot
traffic.

You fundamentally can not do that kind of thing without giving the CPU up.
And under a spinlock you are not allowed to do that.

In the current form that commit is obviously broken.
