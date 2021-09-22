Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E46414D96
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhIVP7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhIVP7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 11:59:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387A7C061574;
        Wed, 22 Sep 2021 08:58:02 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632326280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wi0PRAB6UmeIsO/wM+nnnFS+lDvKWvgCJyCvgt6O10=;
        b=gCaVRp/fbJrzW9MuaOCMbH65WV2UYLsXyY1RUz/9j2S5Nz6PM7ABOni1fY6m1vyiFloPkg
        DqqYnzqVogspwMU3P42y4tX1xCiF1Uth1nJrwABur0LN0X3NXzFSEwuNMAGCoNT5nlo3ux
        8JnpjZKwtdnRAwOIb3/WxZAtZolf0YEVDyMWxqX9v8mUO0uY/OZ8oKkgZJI8qWsmMp8nl2
        gdIw5GAHgDFw55SDSD5hiMwAtOKL8V5U+8N8/qP82zU1AmwdXG2b1KoXQAcFFGUIc83FeB
        RN4sxjFq4jPt4BWd0GUuhgkKuZYPlhZzYs/54+YviFOeWpuTFb0vza+VsNWEvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632326280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2wi0PRAB6UmeIsO/wM+nnnFS+lDvKWvgCJyCvgt6O10=;
        b=HjSscceYUWNsUDQnsorqiNOrRaPLu6+R8F62G3lY2Sztj0jMfgyddW4lHqYW9976kZ+Ixi
        zf2ec40LDfZKL9Ag==
To:     syzbot <syzbot+1dd53f7a89b299d59eaf@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [syzbot] possible deadlock in mptcp_close
In-Reply-To: <0000000000005183b005cc74779a@google.com>
References: <0000000000005183b005cc74779a@google.com>
Date:   Wed, 22 Sep 2021 17:57:59 +0200
Message-ID: <87zgs4habc.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20 2021 at 15:04, syzbot wrote:
> The issue was bisected to:
>
> commit 2dcb96bacce36021c2f3eaae0cef607b5bb71ede
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Sep 18 12:42:35 2021 +0000
>
>     net: core: Correct the sock::sk_lock.owned lockdep annotations

Shooting the messenger...

> MPTCP: kernel_bind error, err=-98
> ============================================
> WARNING: possible recursive locking detected
> 5.15.0-rc1-syzkaller #0 Not tainted
> --------------------------------------------
> syz-executor998/6520 is trying to acquire lock:
> ffff8880795718a0 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x267/0x7b0 net/mptcp/protocol.c:2738
>
> but task is already holding lock:
> ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1612 [inline]
> ffff8880787c8c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: mptcp_close+0x23/0x7b0 net/mptcp/protocol.c:2720

So this is a lock nesting issue and looking at the stack trace this
comes from:

>  lock_sock_fast+0x36/0x100 net/core/sock.c:3229

which does not support lockdep nesting. So from a lockdep POV this is
recursive locking the same lock class. And it's the case I was worried
about that lockdep testing never takes the slow path. The original
lockdep annotation would have produced exactly the same splat in the
slow path case.

So it's not a new problem. It's just visible by moving the lockdep
annotations to a place where they actually can detect issues which were
not reported before.

See also https://lore.kernel.org/lkml/874kacu248.ffs@tglx/

There are two ways to address this mptcp one:

  1) Teach lock_sock_fast() about lock nesting

  2) Use lock_sock_nested() in mptcp_close() as that should not be
     really a hotpath. See patch below.

Thanks,

        tglx
---

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2602f1386160..27ea5d4dfdf6 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2735,10 +2735,10 @@ static void mptcp_close(struct sock *sk, long timeout)
 	inet_csk(sk)->icsk_mtup.probe_timestamp = tcp_jiffies32;
 	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		bool slow = lock_sock_fast(ssk);
 
+		lock_sock_nested(ssk, SINGLE_DEPTH_NESTING);
 		sock_orphan(ssk);
-		unlock_sock_fast(ssk, slow);
+		unlock_sock(ssk);
 	}
 	sock_orphan(sk);
 
