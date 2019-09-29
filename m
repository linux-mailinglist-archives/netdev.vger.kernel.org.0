Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83241C146B
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfI2MKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 08:10:16 -0400
Received: from srv2.anyservers.com ([77.79.239.202]:46013 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfI2MKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 08:10:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=U0UHvodV6wMsJaXYpG4dlWbbwST4c6ovyGbYnF5bbKg=; b=lCzasngIf7SNjeCZs8tRM2sFSh
        1Y6y5PBj5SfjUDlGTt7X/l+SGMR7qPBh4TttJtpiNk9660Vx8JZuSJW9Erpg2k8ik5g6Hp32stcMD
        ui2cYFmmgPqoFuF0cuzLn5pxtHBrfjvxdV44HGRlVfx5WvKCyJYOJDpryjYKyTfeIED4CQsjwcJgL
        yRQmcsYYaAI7FiYhSiC1kQJWkdc3zlRN9KLQy1Qh4dMdRkakqvupu7Se9m+tEDaW2STYkdRFnMYSQ
        5LFnyoSzaJUFT+NuFoqxoxarTM39tIVoL+iTsuDc9Og+bJ6L7LFHorH8fE8vS1jwoFcFVB6t04FpM
        q0JG8Bmw==;
Received: from [5.174.236.109] (port=55200 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <amade@asmblr.net>)
        id 1iEX0U-003gdJ-TJ; Sun, 29 Sep 2019 13:04:51 +0200
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [RFC PATCH 2/2] net: tun: Fix incorrect memory access
Date:   Sun, 29 Sep 2019 13:05:02 +0200
Message-Id: <20190929110502.2284-3-amade@asmblr.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929110502.2284-1-amade@asmblr.net>
References: <20190929110502.2284-1-amade@asmblr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is equivalent commit to tap one, where we fix incorrect memory
access caused by sock_init_data being passed improper socket.

This happens due to the fact that if sock_init_data() is called with
sock argument being not NULL, it goes into path using SOCK_INODE macro.
SOCK_INODE itself is just a wrapper around
container_of(socket, struct socket_alloc, socket).

As can be seen from that flow sock_init_data, should be called with
sock, being part of struct socket_alloc, instead of being part of
struct tun_file.

Refactor code to follow flow similar in other places where sock is
allocated correctly.

Signed-off-by: Amadeusz Sławiński <amade@asmblr.net>
---
 drivers/net/tun.c | 92 +++++++++++++++++++++++++----------------------
 1 file changed, 50 insertions(+), 42 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aab0be40d443..60344794579c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -159,7 +159,7 @@ struct tun_pcpu_stats {
  */
 struct tun_file {
 	struct sock sk;
-	struct socket socket;
+	struct socket *socket;
 	struct tun_struct __rcu *tun;
 	struct fasync_struct *fasync;
 	/* only used for fasnyc */
@@ -753,14 +753,14 @@ static void tun_detach_all(struct net_device *dev)
 		tfile = rtnl_dereference(tun->tfiles[i]);
 		BUG_ON(!tfile);
 		tun_napi_disable(tfile);
-		tfile->socket.sk->sk_shutdown = RCV_SHUTDOWN;
-		tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+		tfile->socket->sk->sk_shutdown = RCV_SHUTDOWN;
+		tfile->socket->sk->sk_data_ready(tfile->socket->sk);
 		RCU_INIT_POINTER(tfile->tun, NULL);
 		--tun->numqueues;
 	}
 	list_for_each_entry(tfile, &tun->disabled, next) {
-		tfile->socket.sk->sk_shutdown = RCV_SHUTDOWN;
-		tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+		tfile->socket->sk->sk_shutdown = RCV_SHUTDOWN;
+		tfile->socket->sk->sk_data_ready(tfile->socket->sk);
 		RCU_INIT_POINTER(tfile->tun, NULL);
 	}
 	BUG_ON(tun->numqueues != 0);
@@ -794,7 +794,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 	struct net_device *dev = tun->dev;
 	int err;
 
-	err = security_tun_dev_attach(tfile->socket.sk, tun->security);
+	err = security_tun_dev_attach(tfile->socket->sk, tun->security);
 	if (err < 0)
 		goto out;
 
@@ -815,9 +815,9 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 	/* Re-attach the filter to persist device */
 	if (!skip_filter && (tun->filter_attached == true)) {
-		lock_sock(tfile->socket.sk);
-		err = sk_attach_filter(&tun->fprog, tfile->socket.sk);
-		release_sock(tfile->socket.sk);
+		lock_sock(tfile->socket->sk);
+		err = sk_attach_filter(&tun->fprog, tfile->socket->sk);
+		release_sock(tfile->socket->sk);
 		if (!err)
 			goto out;
 	}
@@ -830,7 +830,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 	}
 
 	tfile->queue_index = tun->numqueues;
-	tfile->socket.sk->sk_shutdown &= ~RCV_SHUTDOWN;
+	tfile->socket->sk->sk_shutdown &= ~RCV_SHUTDOWN;
 
 	if (tfile->detached) {
 		/* Re-attach detached tfile, updating XDP queue_index */
@@ -1086,8 +1086,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!check_filter(&tun->txflt, skb))
 		goto drop;
 
-	if (tfile->socket.sk->sk_filter &&
-	    sk_filter(tfile->socket.sk, skb))
+	if (tfile->socket->sk->sk_filter &&
+	    sk_filter(tfile->socket->sk, skb))
 		goto drop;
 
 	len = run_ebpf_filter(tun, skb, len);
@@ -1112,7 +1112,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
-	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+	tfile->socket->sk->sk_data_ready(tfile->socket->sk);
 
 	rcu_read_unlock();
 	return NETDEV_TX_OK;
@@ -1275,7 +1275,7 @@ static void __tun_xdp_flush_tfile(struct tun_file *tfile)
 	/* Notify and wake up reader process */
 	if (tfile->flags & TUN_FASYNC)
 		kill_fasync(&tfile->fasync, SIGIO, POLL_IN);
-	tfile->socket.sk->sk_data_ready(tfile->socket.sk);
+	tfile->socket->sk->sk_data_ready(tfile->socket->sk);
 }
 
 static int tun_xdp_xmit(struct net_device *dev, int n,
@@ -1415,7 +1415,7 @@ static void tun_net_init(struct net_device *dev)
 
 static bool tun_sock_writeable(struct tun_struct *tun, struct tun_file *tfile)
 {
-	struct sock *sk = tfile->socket.sk;
+	struct sock *sk = tfile->socket->sk;
 
 	return (tun->dev->flags & IFF_UP) && sock_writeable(sk);
 }
@@ -1433,7 +1433,7 @@ static __poll_t tun_chr_poll(struct file *file, poll_table *wait)
 	if (!tun)
 		return EPOLLERR;
 
-	sk = tfile->socket.sk;
+	sk = tfile->socket->sk;
 
 	tun_debug(KERN_INFO, tun, "tun_chr_poll\n");
 
@@ -1518,7 +1518,7 @@ static struct sk_buff *tun_alloc_skb(struct tun_file *tfile,
 				     size_t prepad, size_t len,
 				     size_t linear, int noblock)
 {
-	struct sock *sk = tfile->socket.sk;
+	struct sock *sk = tfile->socket->sk;
 	struct sk_buff *skb;
 	int err;
 
@@ -1585,7 +1585,7 @@ static bool tun_can_build_skb(struct tun_struct *tun, struct tun_file *tfile,
 	if ((tun->flags & TUN_TYPE_MASK) != IFF_TAP)
 		return false;
 
-	if (tfile->socket.sk->sk_sndbuf != INT_MAX)
+	if (tfile->socket->sk->sk_sndbuf != INT_MAX)
 		return false;
 
 	if (!noblock)
@@ -1612,7 +1612,7 @@ static struct sk_buff *__tun_build_skb(struct tun_file *tfile,
 
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
-	skb_set_owner_w(skb, tfile->socket.sk);
+	skb_set_owner_w(skb, tfile->socket->sk);
 
 	get_page(alloc_frag->page);
 	alloc_frag->offset += buflen;
@@ -2169,7 +2169,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 		goto out;
 	}
 
-	add_wait_queue(&tfile->socket.wq.wait, &wait);
+	add_wait_queue(&tfile->socket->wq.wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -2180,7 +2180,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 			error = -ERESTARTSYS;
 			break;
 		}
-		if (tfile->socket.sk->sk_shutdown & RCV_SHUTDOWN) {
+		if (tfile->socket->sk->sk_shutdown & RCV_SHUTDOWN) {
 			error = -EFAULT;
 			break;
 		}
@@ -2189,7 +2189,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	}
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tfile->socket.wq.wait, &wait);
+	remove_wait_queue(&tfile->socket->wq.wait, &wait);
 
 out:
 	*err = error;
@@ -2519,7 +2519,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	int ret, i;
-	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
+	struct tun_file *tfile = container_of(sock->sk, struct tun_file, sk);
 	struct tun_struct *tun = tun_get(tfile);
 	struct tun_msg_ctl *ctl = m->msg_control;
 	struct xdp_buff *xdp;
@@ -2565,7 +2565,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 		       int flags)
 {
-	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
+	struct tun_file *tfile = container_of(sock->sk, struct tun_file, sk);
 	struct tun_struct *tun = tun_get(tfile);
 	void *ptr = m->msg_control;
 	int ret;
@@ -2616,7 +2616,7 @@ static int tun_ptr_peek_len(void *ptr)
 
 static int tun_peek_len(struct socket *sock)
 {
-	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
+	struct tun_file *tfile = container_of(sock->sk, struct tun_file, sk);
 	struct tun_struct *tun;
 	int ret = 0;
 
@@ -2799,7 +2799,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		tun->align = NET_SKB_PAD;
 		tun->filter_attached = false;
-		tun->sndbuf = tfile->socket.sk->sk_sndbuf;
+		tun->sndbuf = tfile->socket->sk->sk_sndbuf;
 		tun->rx_batched = 0;
 		RCU_INIT_POINTER(tun->steering_prog, NULL);
 
@@ -2927,9 +2927,9 @@ static void tun_detach_filter(struct tun_struct *tun, int n)
 
 	for (i = 0; i < n; i++) {
 		tfile = rtnl_dereference(tun->tfiles[i]);
-		lock_sock(tfile->socket.sk);
-		sk_detach_filter(tfile->socket.sk);
-		release_sock(tfile->socket.sk);
+		lock_sock(tfile->socket->sk);
+		sk_detach_filter(tfile->socket->sk);
+		release_sock(tfile->socket->sk);
 	}
 
 	tun->filter_attached = false;
@@ -2942,9 +2942,9 @@ static int tun_attach_filter(struct tun_struct *tun)
 
 	for (i = 0; i < tun->numqueues; i++) {
 		tfile = rtnl_dereference(tun->tfiles[i]);
-		lock_sock(tfile->socket.sk);
-		ret = sk_attach_filter(&tun->fprog, tfile->socket.sk);
-		release_sock(tfile->socket.sk);
+		lock_sock(tfile->socket->sk);
+		ret = sk_attach_filter(&tun->fprog, tfile->socket->sk);
+		release_sock(tfile->socket->sk);
 		if (ret) {
 			tun_detach_filter(tun, i);
 			return ret;
@@ -2962,7 +2962,7 @@ static void tun_set_sndbuf(struct tun_struct *tun)
 
 	for (i = 0; i < tun->numqueues; i++) {
 		tfile = rtnl_dereference(tun->tfiles[i]);
-		tfile->socket.sk->sk_sndbuf = tun->sndbuf;
+		tfile->socket->sk->sk_sndbuf = tun->sndbuf;
 	}
 }
 
@@ -3109,7 +3109,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 
 		if (tfile->detached)
 			ifr.ifr_flags |= IFF_DETACH_QUEUE;
-		if (!tfile->socket.sk->sk_filter)
+		if (!tfile->socket->sk->sk_filter)
 			ifr.ifr_flags |= IFF_NOFILTER;
 
 		if (copy_to_user(argp, &ifr, ifreq_len))
@@ -3217,7 +3217,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case TUNGETSNDBUF:
-		sndbuf = tfile->socket.sk->sk_sndbuf;
+		sndbuf = tfile->socket->sk->sk_sndbuf;
 		if (copy_to_user(argp, &sndbuf, sizeof(sndbuf)))
 			ret = -EFAULT;
 		break;
@@ -3405,6 +3405,7 @@ static int tun_chr_fasync(int fd, struct file *file, int on)
 static int tun_chr_open(struct inode *inode, struct file * file)
 {
 	struct net *net = current->nsproxy->net_ns;
+	struct socket *sock;
 	struct tun_file *tfile;
 
 	DBG1(KERN_INFO, "tunX: tun_chr_open\n");
@@ -3413,7 +3414,16 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 					    &tun_proto, 0);
 	if (!tfile)
 		return -ENOMEM;
+
+	sock = sock_alloc();
+	if (!sock) {
+		sk_free(&tfile->sk);
+		return -ENOMEM;
+	}
+	tfile->socket = sock;
+
 	if (ptr_ring_init(&tfile->tx_ring, 0, GFP_KERNEL)) {
+		sock_release(tfile->socket);
 		sk_free(&tfile->sk);
 		return -ENOMEM;
 	}
@@ -3423,12 +3433,10 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->flags = 0;
 	tfile->ifindex = 0;
 
-	init_waitqueue_head(&tfile->socket.wq.wait);
-
-	tfile->socket.file = file;
-	tfile->socket.ops = &tun_socket_ops;
+	sock->file = file;
+	sock->ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data(sock, &tfile->sk);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
@@ -3646,7 +3654,7 @@ static int tun_device_event(struct notifier_block *unused,
 			struct tun_file *tfile;
 
 			tfile = rtnl_dereference(tun->tfiles[i]);
-			tfile->socket.sk->sk_write_space(tfile->socket.sk);
+			tfile->socket->sk->sk_write_space(tfile->socket->sk);
 		}
 		break;
 	default:
@@ -3713,7 +3721,7 @@ struct socket *tun_get_socket(struct file *file)
 	tfile = file->private_data;
 	if (!tfile)
 		return ERR_PTR(-EBADFD);
-	return &tfile->socket;
+	return tfile->socket;
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
-- 
2.23.0

