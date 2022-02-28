Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9404C65EE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiB1Jqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiB1Jqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:46:48 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B25694BD;
        Mon, 28 Feb 2022 01:46:06 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l2-20020a7bc342000000b0037fa585de26so6927538wmj.1;
        Mon, 28 Feb 2022 01:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQ+h1cU+uKWHVdXhKrvR//NlJMjix3kBk80whKwXXPA=;
        b=guSg6poWdMuA1G1XQlIccMwzP+cCtMrCmNBvp61qIFSDcdgQwCCgo7wg0CiFD7xjD5
         DoUpiJx2dbTPrRtIFFTxxOMxVJ2JUohemopuVcRHQCPEicSXKmi1qBdftLqSO6VyS2BE
         GAgbUbEP7iEet/huN1FyRzajkdqrVTfS/Cg86HAJ3N2Ys5P8olTIpEqt3g2UIvNc8qZh
         ksrw7BDp1tGS98QelO2Tt/H4GqyvuOe3Q4PbP0u+S/p7OnKIlpjdjsllWBdz2kXKkrbz
         /D/rlnghH1DjVVlIDIFnyfGJlU3Fs0aAfs5y8xYVXuylUMULnwYo9jb61ido9vxYvvFL
         dhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QQ+h1cU+uKWHVdXhKrvR//NlJMjix3kBk80whKwXXPA=;
        b=w4gWRpntM6IQ6bOr/kP7v+69zwmfG3MTcPMv4WYISCH/OzXCxOt13tT2wm6dl1KwGG
         5fvKd8FXmP6Ng9GclhtKbfGopNiJ5CjIhBeYYphDViCFeoVEybSr/pM1eLn2ylqdzcWd
         8HuX8E7PQSKsuCdthedVLDKyV5chRWll2NCQav0C2q+aIz6HAkkuB+vZT3u2yCXgax1z
         PJIZkyOrw6hO6ZRlkJv/K+L4eXzNyeQ0mnrYaa5/XtUoAW8h9L6dc01YVFY7aveTFGa1
         hBgtTr8Tu8LI4vGfpTX2vqc8RvqRlcHSa2BHk8CtpXukxjVW45qIvlsbX4VWUUjI3DxO
         G8BA==
X-Gm-Message-State: AOAM533kDIjmF3j+35dFgr96YlIXQ3Gdqe4icoVmopncgKJYQWkRXHMV
        XulfGDaYsloj5yNV79jCEAI=
X-Google-Smtp-Source: ABdhPJxGgmGpZEpvx00D21fufuoHydRi/6Sym+G4SrHsbK9vFoMF9kAYq4BipxIdbXUmjtLoh3c0wA==
X-Received: by 2002:a1c:a382:0:b0:381:cfd:5564 with SMTP id m124-20020a1ca382000000b003810cfd5564mr12306783wme.103.1646041564829;
        Mon, 28 Feb 2022 01:46:04 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id q23-20020a1cf317000000b003815206a638sm4468447wmq.15.2022.02.28.01.46.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 01:46:04 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        Elza Mathew <elza.mathew@intel.com>
Subject: [PATCH bpf v2] xsk: fix race at socket teardown
Date:   Mon, 28 Feb 2022 10:45:52 +0100
Message-Id: <20220228094552.10134-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a race in the xsk socket teardown code that can lead to a null
pointer dereference splat. The current xsk unbind code in
xsk_unbind_dev() starts by setting xs->state to XSK_UNBOUND, sets
xs->dev to NULL and then waits for any NAPI processing to terminate
using synchronize_net(). After that, the release code starts to tear
down the socket state and free allocated memory.

BUG: kernel NULL pointer dereference, address: 00000000000000c0
PGD 8000000932469067 P4D 8000000932469067 PUD 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 25 PID: 69132 Comm: grpcpp_sync_ser Tainted: G          I       5.16.0+ #2
Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2.10 03/09/2015
RIP: 0010:__xsk_sendmsg+0x2c/0x690
Code: 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 38 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 48 8b 87 08 03 00 00 <f6> 80 c0 00 00 00 01 >
RSP: 0018:ffffa2348bd13d50 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000040 RCX: ffff8d5fc632d258
RDX: 0000000000400000 RSI: ffffa2348bd13e10 RDI: ffff8d5fc5489800
RBP: ffffa2348bd13db0 R08: 0000000000000000 R09: 00007ffffffff000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8d5fc5489800
R13: ffff8d5fcb0f5140 R14: ffff8d5fcb0f5140 R15: 0000000000000000
FS:  00007f991cff9400(0000) GS:ffff8d6f1f700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000c0 CR3: 0000000114888005 CR4: 00000000001706e0
Call Trace:
<TASK>
? aa_sk_perm+0x43/0x1b0
xsk_sendmsg+0xf0/0x110
sock_sendmsg+0x65/0x70
__sys_sendto+0x113/0x190
? debug_smp_processor_id+0x17/0x20
? fpregs_assert_state_consistent+0x23/0x50
? exit_to_user_mode_prepare+0xa5/0x1d0
__x64_sys_sendto+0x29/0x30
do_syscall_64+0x3b/0xc0
entry_SYSCALL_64_after_hwframe+0x44/0xae

There are two problems with the current code. First, setting xs->dev
to NULL before waiting for all users to stop using the socket is not
correct. The entry to the data plane functions xsk_poll(),
xsk_sendmsg(), and xsk_recvmsg() are all guarded by a test that
xs->state is in the state XSK_BOUND and if not, it returns right
away. But one process might have passed this test but still have not
gotten to the point in which it uses xs->dev in the code. In this
interim, a second process executing xsk_unbind_dev() might have set
xs->dev to NULL which will lead to a crash for the first process. The
solution here is just to get rid of this NULL assignment since it is
not used anymore. Before commit 42fddcc7c64b ("xsk: use state member
for socket synchronization"), xs->dev was the gatekeeper to admit
processes into the data plane functions, but it was replaced with the
state variable xs->state in the aforementioned commit.

The second problem is that synchronize_net() does not wait for any
process in xsk_poll(), xsk_sendmsg(), or xsk_recvmsg() to complete,
which means that the state they rely on might be cleaned up
prematurely. This can happen when the notifier gets called (at driver
unload for example) as it uses xsk_unbind_dev(). Solve this by
extending the RCU critical region from just the ndo_xsk_wakeup to the
whole functions mentioned above, so that both the test of xs->state ==
XSK_BOUND and the last use of any member of xs is covered by the RCU
critical section. This will guarantee that when synchronize_net()
completes, there will be no processes left executing xsk_poll(),
xsk_sendmsg(), or xsk_recvmsg() and state can be cleaned up
safely. Note that we need to drop the RCU lock for the SKB xmit path
as it uses functions that might sleep. Due to this, we have to retest
the xs->state after we grab the mutex that protects the SKB xmit code
from, among a number of things, an xsk_unbind_dev() being executed
from the notifier at the same time.

v1 -> v2:
* Naming xsk_zc_xmit() -> xsk_wakeup() [Maciej]

Fixes: 42fddcc7c64b ("xsk: use state member for socket synchronization")
Reported-by: Elza Mathew <elza.mathew@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 69 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 19 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 28ef3f4465ae..ac343cd8ff3f 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -403,18 +403,8 @@ EXPORT_SYMBOL(xsk_tx_peek_release_desc_batch);
 static int xsk_wakeup(struct xdp_sock *xs, u8 flags)
 {
 	struct net_device *dev = xs->dev;
-	int err;
-
-	rcu_read_lock();
-	err = dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
-	rcu_read_unlock();
-
-	return err;
-}
 
-static int xsk_zc_xmit(struct xdp_sock *xs)
-{
-	return xsk_wakeup(xs, XDP_WAKEUP_TX);
+	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id, flags);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
@@ -533,6 +523,12 @@ static int xsk_generic_xmit(struct sock *sk)
 
 	mutex_lock(&xs->mutex);
 
+	/* Since we dropped the RCU read lock, the socket state might have changed. */
+	if (unlikely(!xsk_is_bound(xs))) {
+		err = -ENXIO;
+		goto out;
+	}
+
 	if (xs->queue_id >= xs->dev->real_num_tx_queues)
 		goto out;
 
@@ -596,16 +592,26 @@ static int xsk_generic_xmit(struct sock *sk)
 	return err;
 }
 
-static int __xsk_sendmsg(struct sock *sk)
+static int xsk_xmit(struct sock *sk)
 {
 	struct xdp_sock *xs = xdp_sk(sk);
+	int ret;
 
 	if (unlikely(!(xs->dev->flags & IFF_UP)))
 		return -ENETDOWN;
 	if (unlikely(!xs->tx))
 		return -ENOBUFS;
 
-	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
+	if (xs->zc)
+		return xsk_wakeup(xs, XDP_WAKEUP_TX);
+
+	/* Drop the RCU lock since the SKB path might sleep. */
+	rcu_read_unlock();
+	ret = xsk_generic_xmit(sk);
+	/* Reaquire RCU lock before going into common code. */
+	rcu_read_lock();
+
+	return ret;
 }
 
 static bool xsk_no_wakeup(struct sock *sk)
@@ -619,7 +625,7 @@ static bool xsk_no_wakeup(struct sock *sk)
 #endif
 }
 
-static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -639,11 +645,22 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
-		return __xsk_sendmsg(sk);
+		return xsk_xmit(sk);
 	return 0;
 }
 
-static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __xsk_sendmsg(sock, m, total_len);
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static int __xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
 {
 	bool need_wait = !(flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
@@ -669,6 +686,17 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	return 0;
 }
 
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = __xsk_recvmsg(sock, m, len, flags);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
@@ -679,8 +707,11 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 
 	sock_poll_wait(file, sock, wait);
 
-	if (unlikely(!xsk_is_bound(xs)))
+	rcu_read_lock();
+	if (unlikely(!xsk_is_bound(xs))) {
+		rcu_read_unlock();
 		return mask;
+	}
 
 	pool = xs->pool;
 
@@ -689,7 +720,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			xsk_wakeup(xs, pool->cached_need_wakeup);
 		else
 			/* Poll needs to drive Tx also in copy mode */
-			__xsk_sendmsg(sk);
+			xsk_xmit(sk);
 	}
 
 	if (xs->rx && !xskq_prod_is_empty(xs->rx))
@@ -697,6 +728,7 @@ static __poll_t xsk_poll(struct file *file, struct socket *sock,
 	if (xs->tx && xsk_tx_writeable(xs))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 
+	rcu_read_unlock();
 	return mask;
 }
 
@@ -728,7 +760,6 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 
 	/* Wait for driver to stop using the xdp socket. */
 	xp_del_xsk(xs->pool, xs);
-	xs->dev = NULL;
 	synchronize_net();
 	dev_put(dev);
 }

base-commit: 8940e6b669ca1196ce0a0549c819078096390f76
-- 
2.34.1

