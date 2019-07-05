Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0090B60BB9
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 21:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfGETOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 15:14:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44304 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfGETOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 15:14:18 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hjTey-000111-Oc; Fri, 05 Jul 2019 19:14:16 +0000
Date:   Fri, 5 Jul 2019 20:14:16 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] coallocate socket_wq with socket itself
Message-ID: <20190705191416.GL17978@ZenIV.linux.org.uk>
References: <20190705191322.GK17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705191322.GK17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

socket->wq is assign-once, set when we are initializing both
struct socket it's in and struct socket_wq it points to.  As the
matter of fact, the only reason for separate allocation was the
ability to RCU-delay freeing of socket_wq.  RCU-delaying the
freeing of socket itself gets rid of that need, so we can just
fold struct socket_wq into the end of struct socket and simplify
the life both for sock_alloc_inode() (one allocation instead of
two) and for tun/tap oddballs, where we used to embed struct socket
and struct socket_wq into the same structure (now - embedding just
the struct socket).

Note that reference to struct socket_wq in struct sock does remain
a reference - that's unchanged.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/tap.c      |  5 ++---
 drivers/net/tun.c      |  8 +++-----
 include/linux/if_tap.h |  1 -
 include/linux/net.h    |  4 ++--
 include/net/sock.h     |  4 ++--
 net/core/sock.c        |  2 +-
 net/socket.c           | 19 +++++--------------
 7 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e01390c738e..dd614c2cd994 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -520,8 +520,7 @@ static int tap_open(struct inode *inode, struct file *file)
 		goto err;
 	}
 
-	RCU_INIT_POINTER(q->sock.wq, &q->wq);
-	init_waitqueue_head(&q->wq.wait);
+	init_waitqueue_head(&q->sock.wq.wait);
 	q->sock.type = SOCK_RAW;
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
@@ -579,7 +578,7 @@ static __poll_t tap_poll(struct file *file, poll_table *wait)
 		goto out;
 
 	mask = 0;
-	poll_wait(file, &q->wq.wait, wait);
+	poll_wait(file, &q->sock.wq.wait, wait);
 
 	if (!ptr_ring_empty(&q->ring))
 		mask |= EPOLLIN | EPOLLRDNORM;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d7c55e0fa8f4..3d443597bd04 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -160,7 +160,6 @@ struct tun_pcpu_stats {
 struct tun_file {
 	struct sock sk;
 	struct socket socket;
-	struct socket_wq wq;
 	struct tun_struct __rcu *tun;
 	struct fasync_struct *fasync;
 	/* only used for fasnyc */
@@ -2165,7 +2164,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 		goto out;
 	}
 
-	add_wait_queue(&tfile->wq.wait, &wait);
+	add_wait_queue(&tfile->socket.wq.wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -2185,7 +2184,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	}
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tfile->wq.wait, &wait);
+	remove_wait_queue(&tfile->socket.wq.wait, &wait);
 
 out:
 	*err = error;
@@ -3415,8 +3414,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->flags = 0;
 	tfile->ifindex = 0;
 
-	init_waitqueue_head(&tfile->wq.wait);
-	RCU_INIT_POINTER(tfile->socket.wq, &tfile->wq);
+	init_waitqueue_head(&tfile->socket.wq.wait);
 
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 8e66866c11be..915a187cfabd 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -62,7 +62,6 @@ struct tap_dev {
 struct tap_queue {
 	struct sock sk;
 	struct socket sock;
-	struct socket_wq wq;
 	int vnet_hdr_sz;
 	struct tap_dev __rcu *tap;
 	struct file *file;
diff --git a/include/linux/net.h b/include/linux/net.h
index f7d672cf25b5..9cafb5f353a9 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -116,11 +116,11 @@ struct socket {
 
 	unsigned long		flags;
 
-	struct socket_wq	*wq;
-
 	struct file		*file;
 	struct sock		*sk;
 	const struct proto_ops	*ops;
+
+	struct socket_wq	wq;
 };
 
 struct vm_area_struct;
diff --git a/include/net/sock.h b/include/net/sock.h
index 6cbc16136357..228db3998e46 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1822,7 +1822,7 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 {
 	WARN_ON(parent->sk);
 	write_lock_bh(&sk->sk_callback_lock);
-	rcu_assign_pointer(sk->sk_wq, parent->wq);
+	rcu_assign_pointer(sk->sk_wq, &parent->wq);
 	parent->sk = sk;
 	sk_set_socket(sk, parent);
 	sk->sk_uid = SOCK_INODE(parent)->i_uid;
@@ -2100,7 +2100,7 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 				  poll_table *p)
 {
 	if (!poll_does_not_wait(p)) {
-		poll_wait(filp, &sock->wq->wait, p);
+		poll_wait(filp, &sock->wq.wait, p);
 		/* We need to be sure we are in sync with the
 		 * socket flags modification.
 		 *
diff --git a/net/core/sock.c b/net/core/sock.c
index 0eb21384079d..3e073ca6138f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2847,7 +2847,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	if (sock) {
 		sk->sk_type	=	sock->type;
-		RCU_INIT_POINTER(sk->sk_wq, sock->wq);
+		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
 		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
diff --git a/net/socket.c b/net/socket.c
index 541719a2443d..16449d6daeca 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -234,20 +234,13 @@ static struct kmem_cache *sock_inode_cachep __ro_after_init;
 static struct inode *sock_alloc_inode(struct super_block *sb)
 {
 	struct socket_alloc *ei;
-	struct socket_wq *wq;
 
 	ei = kmem_cache_alloc(sock_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
-	wq = kmalloc(sizeof(*wq), GFP_KERNEL);
-	if (!wq) {
-		kmem_cache_free(sock_inode_cachep, ei);
-		return NULL;
-	}
-	init_waitqueue_head(&wq->wait);
-	wq->fasync_list = NULL;
-	wq->flags = 0;
-	ei->socket.wq = wq;
+	init_waitqueue_head(&ei->socket.wq.wait);
+	ei->socket.wq.fasync_list = NULL;
+	ei->socket.wq.flags = 0;
 
 	ei->socket.state = SS_UNCONNECTED;
 	ei->socket.flags = 0;
@@ -263,7 +256,6 @@ static void sock_free_inode(struct inode *inode)
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	kfree(ei->socket.wq);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
@@ -599,7 +591,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		module_put(owner);
 	}
 
-	if (sock->wq->fasync_list)
+	if (sock->wq.fasync_list)
 		pr_err("%s: fasync list not empty!\n", __func__);
 
 	if (!sock->file) {
@@ -1288,13 +1280,12 @@ static int sock_fasync(int fd, struct file *filp, int on)
 {
 	struct socket *sock = filp->private_data;
 	struct sock *sk = sock->sk;
-	struct socket_wq *wq;
+	struct socket_wq *wq = &sock->wq;
 
 	if (sk == NULL)
 		return -EINVAL;
 
 	lock_sock(sk);
-	wq = sock->wq;
 	fasync_helper(fd, filp, on, &wq->fasync_list);
 
 	if (!wq->fasync_list)
-- 
2.11.0

