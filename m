Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907091C4FEC
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgEEIL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:11:29 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:1837 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgEEIL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 04:11:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588666287; x=1620202287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=e6nX08CDkdFB2m7OjbP9uKwK/ueuTtE4/EJ3d5HRiDQ=;
  b=vOdb78Ts4bLxlyC0PjMB6fvz8pz7j31RU8bfB30uGkBe+gjM53SJWhMG
   Sdqh3lV22urXiuy/7s+raXnS0RsSvyV9YxnmmKdZsqYEiTkTXeRJPZx7w
   j7tAWgA/g+J3LaEMuUGCgQc89LyitK13Fn5UmCu9LJobRVp6/WnvO1/kG
   M=;
IronPort-SDR: oqOqNSKMi4EpbVGhtd+sLYzX/+wuY3HjzBpWzdS0HX4ISi2rwRtrN5A9BdV1s+oBozLdgaRaFt
 cdoKo3wrsQkQ==
X-IronPort-AV: E=Sophos;i="5.73,354,1583193600"; 
   d="scan'208";a="30084467"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 05 May 2020 08:11:27 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id 70B8EA23DF;
        Tue,  5 May 2020 08:11:24 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:23 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.92) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 5 May 2020 08:11:18 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <viro@zeniv.linux.org.uk>, <kuba@kernel.org>,
        <gregkh@linuxfoundation.org>, <edumazet@google.com>,
        <sj38.park@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, SeongJae Park <sjpark@amazon.de>
Subject: [PATCH net v2 1/2] Revert "coallocate socket_wq with socket itself"
Date:   Tue, 5 May 2020 10:10:34 +0200
Message-ID: <20200505081035.7436-2-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505081035.7436-1-sjpark@amazon.com>
References: <20200505081035.7436-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.92]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>

This reverts commit 333f7909a8573145811c4ab7d8c9092301707721.

The commit 6d7855c54e1e ("sockfs: switch to ->free_inode()") made the
deallocation of 'socket_alloc' to be done asynchronously using RCU, as
same to 'sock.wq'.  And the following commit 333f7909a857 ("coallocate
socket_sq with socket itself") made those to have same life cycle.

The changes made the code much more simple, but also made 'socket_alloc'
live longer than before.  For the reason, user programs intensively
repeating allocations and deallocations of sockets could cause memory
pressure on recent kernels.

To avoid the problem, this commit separates the life cycle of
'socket_alloc' and 'sock.wq' again.  The following commit will make the
deallocation of 'socket_alloc' to be done synchronously again.

Fixes: 6d7855c54e1e ("sockfs: switch to ->free_inode()")
Fixes: 333f7909a857 ("coallocate socket_sq with socket itself")
Signed-off-by: SeongJae Park <sjpark@amazon.de>
---
 drivers/net/tap.c      |  5 +++--
 drivers/net/tun.c      |  8 +++++---
 include/linux/if_tap.h |  1 +
 include/linux/net.h    |  4 ++--
 include/net/sock.h     |  4 ++--
 net/core/sock.c        |  2 +-
 net/socket.c           | 19 ++++++++++++++-----
 7 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 1f4bdd94407a..7912039a4846 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -518,7 +518,8 @@ static int tap_open(struct inode *inode, struct file *file)
 		goto err;
 	}
 
-	init_waitqueue_head(&q->sock.wq.wait);
+	RCU_INIT_POINTER(q->sock.wq, &q->wq);
+	init_waitqueue_head(&q->wq.wait);
 	q->sock.type = SOCK_RAW;
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
@@ -576,7 +577,7 @@ static __poll_t tap_poll(struct file *file, poll_table *wait)
 		goto out;
 
 	mask = 0;
-	poll_wait(file, &q->sock.wq.wait, wait);
+	poll_wait(file, &q->wq.wait, wait);
 
 	if (!ptr_ring_empty(&q->ring))
 		mask |= EPOLLIN | EPOLLRDNORM;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 650c937ed56b..16a5f3b80edf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -160,6 +160,7 @@ struct tun_pcpu_stats {
 struct tun_file {
 	struct sock sk;
 	struct socket socket;
+	struct socket_wq wq;
 	struct tun_struct __rcu *tun;
 	struct fasync_struct *fasync;
 	/* only used for fasnyc */
@@ -2173,7 +2174,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 		goto out;
 	}
 
-	add_wait_queue(&tfile->socket.wq.wait, &wait);
+	add_wait_queue(&tfile->wq.wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -2193,7 +2194,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	}
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tfile->socket.wq.wait, &wait);
+	remove_wait_queue(&tfile->wq.wait, &wait);
 
 out:
 	*err = error;
@@ -3434,7 +3435,8 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->flags = 0;
 	tfile->ifindex = 0;
 
-	init_waitqueue_head(&tfile->socket.wq.wait);
+	init_waitqueue_head(&tfile->wq.wait);
+	RCU_INIT_POINTER(tfile->socket.wq, &tfile->wq);
 
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..8e66866c11be 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -62,6 +62,7 @@ struct tap_dev {
 struct tap_queue {
 	struct sock sk;
 	struct socket sock;
+	struct socket_wq wq;
 	int vnet_hdr_sz;
 	struct tap_dev __rcu *tap;
 	struct file *file;
diff --git a/include/linux/net.h b/include/linux/net.h
index 6451425e828f..28c929bebb4a 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -116,11 +116,11 @@ struct socket {
 
 	unsigned long		flags;
 
+	struct socket_wq	*wq;
+
 	struct file		*file;
 	struct sock		*sk;
 	const struct proto_ops	*ops;
-
-	struct socket_wq	wq;
 };
 
 struct vm_area_struct;
diff --git a/include/net/sock.h b/include/net/sock.h
index 328564525526..20799a333570 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1841,7 +1841,7 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 {
 	WARN_ON(parent->sk);
 	write_lock_bh(&sk->sk_callback_lock);
-	rcu_assign_pointer(sk->sk_wq, &parent->wq);
+	rcu_assign_pointer(sk->sk_wq, parent->wq);
 	parent->sk = sk;
 	sk_set_socket(sk, parent);
 	sk->sk_uid = SOCK_INODE(parent)->i_uid;
@@ -2119,7 +2119,7 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 				  poll_table *p)
 {
 	if (!poll_does_not_wait(p)) {
-		poll_wait(filp, &sock->wq.wait, p);
+		poll_wait(filp, &sock->wq->wait, p);
 		/* We need to be sure we are in sync with the
 		 * socket flags modification.
 		 *
diff --git a/net/core/sock.c b/net/core/sock.c
index 8f71684305c3..7fa3241b5507 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2869,7 +2869,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	if (sock) {
 		sk->sk_type	=	sock->type;
-		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
+		RCU_INIT_POINTER(sk->sk_wq, sock->wq);
 		sock->sk	=	sk;
 		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
diff --git a/net/socket.c b/net/socket.c
index 2eecf1517f76..e274ae4b45e4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -249,13 +249,20 @@ static struct kmem_cache *sock_inode_cachep __ro_after_init;
 static struct inode *sock_alloc_inode(struct super_block *sb)
 {
 	struct socket_alloc *ei;
+	struct socket_wq *wq;
 
 	ei = kmem_cache_alloc(sock_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
-	init_waitqueue_head(&ei->socket.wq.wait);
-	ei->socket.wq.fasync_list = NULL;
-	ei->socket.wq.flags = 0;
+	wq = kmalloc(sizeof(*wq), GFP_KERNEL);
+	if (!wq) {
+		kmem_cache_free(sock_inode_cachep, ei);
+		return NULL;
+	}
+	init_waitqueue_head(&wq->wait);
+	wq->fasync_list = NULL;
+	wq->flags = 0;
+	ei->socket.wq = wq;
 
 	ei->socket.state = SS_UNCONNECTED;
 	ei->socket.flags = 0;
@@ -271,6 +278,7 @@ static void sock_free_inode(struct inode *inode)
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
+	kfree(ei->socket.wq);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
@@ -610,7 +618,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		module_put(owner);
 	}
 
-	if (sock->wq.fasync_list)
+	if (sock->wq->fasync_list)
 		pr_err("%s: fasync list not empty!\n", __func__);
 
 	if (!sock->file) {
@@ -1299,12 +1307,13 @@ static int sock_fasync(int fd, struct file *filp, int on)
 {
 	struct socket *sock = filp->private_data;
 	struct sock *sk = sock->sk;
-	struct socket_wq *wq = &sock->wq;
+	struct socket_wq *wq;
 
 	if (sk == NULL)
 		return -EINVAL;
 
 	lock_sock(sk);
+	wq = sock->wq;
 	fasync_helper(fd, filp, on, &wq->fasync_list);
 
 	if (!wq->fasync_list)
-- 
2.17.1

