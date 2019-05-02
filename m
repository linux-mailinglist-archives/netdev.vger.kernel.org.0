Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7812048
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEBQc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 12:32:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53038 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfEBQc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 12:32:27 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hMEdD-0002lM-Vc; Thu, 02 May 2019 16:32:24 +0000
Date:   Thu, 2 May 2019 17:32:23 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [RFC] folding socket->wq into struct socket
Message-ID: <20190502163223.GW23075@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	I'm not sure what's the right way to handle that.
Background: new inode method (->free_inode()) allows to
do RCU-delayed parts of ->destroy_inode() conveniently,
killing a lot of boilerplate code in process.

	It's optional, so sockfs doesn't have to be
converted; however, looking at the ->destroy_inode() there
static void sock_destroy_inode(struct inode *inode)
{
        struct socket_alloc *ei;

        ei = container_of(inode, struct socket_alloc, vfs_inode);
        kfree_rcu(ei->socket.wq, rcu);
        kmem_cache_free(sock_inode_cachep, ei);
}
it appears that we might take freeing the socket itself to the
RCU-delayed part, along with socket->wq.  And doing that has
an interesting benefit - the only reason to do two separate
allocation disappears.

	We have 3 sources of struct socket - the regular one
in sock_alloc_inode() (where we allocate struct socket_wq
separately and set socket->wq to it; struct socket is embedded
into struct socket_alloc there) and two more in tun and tap
respectively.  There struct socket is embedded into struct
tun_file and struct tap_queue, with matching struct socket_wq
right next it it.  In all cases socket->wq is assigned once
at the initialization time and never modified afterwards.

	We do have other sources of struct socket_wq,
but these only go into sock->sk_wq, not socket->wq.
Folding struct socket_wq into struct socket (with socket->wq
turning from struct socket_wq * into struct socket_wq) looks
like a reasonable cleanup, possibly even with performance
improvements.  We already do RCU delay on socket destruction
(that kfree_rcu() in the current code), so we won't gain
overhead from those.  Is there any downside to doing that?

	I've put a couple of patches (switch to ->free_inode(),
taking freeing of struct socket into RCU-delayed part along
with freeing socket_wq + getting rid of separate allocations)
into vfs.git#for-davem; they are dependent upon the #work.icache,
where ->free_inode() is introduced.

	I don't think that feeding those two through vfs.git
would be right; nothing else in there depends upon those
and diffstat speaks for itself:
 drivers/net/tap.c      |  5 ++---
 drivers/net/tun.c      |  8 +++-----
 include/linux/if_tap.h |  1 -
 include/linux/net.h    |  4 ++--
 include/net/sock.h     |  4 ++--
 net/core/sock.c        |  2 +-
 net/socket.c           | 23 +++++++----------------
 7 files changed, 17 insertions(+), 30 deletions(-)

	One way to deal with that would be to leave those two
until the next window - once ->free_inode() series is in mainline,
they lose any dependencies on vfs.git and can just go through
netdev.

	Or am I missing some fundamental reason why coallocation
would be a bad idea?  FWIW, the composite of those two patches
is below:

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 2ea9b4976f4a..249bfd85b65c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -519,8 +519,7 @@ static int tap_open(struct inode *inode, struct file *file)
 		goto err;
 	}
 
-	RCU_INIT_POINTER(q->sock.wq, &q->wq);
-	init_waitqueue_head(&q->wq.wait);
+	init_waitqueue_head(&q->sock.wq.wait);
 	q->sock.type = SOCK_RAW;
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
@@ -578,7 +577,7 @@ static __poll_t tap_poll(struct file *file, poll_table *wait)
 		goto out;
 
 	mask = 0;
-	poll_wait(file, &q->wq.wait, wait);
+	poll_wait(file, &q->sock.wq.wait, wait);
 
 	if (!ptr_ring_empty(&q->ring))
 		mask |= EPOLLIN | EPOLLRDNORM;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e9ca1c088d0b..f404d1588e9c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -169,7 +169,6 @@ struct tun_pcpu_stats {
 struct tun_file {
 	struct sock sk;
 	struct socket socket;
-	struct socket_wq wq;
 	struct tun_struct __rcu *tun;
 	struct fasync_struct *fasync;
 	/* only used for fasnyc */
@@ -2174,7 +2173,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 		goto out;
 	}
 
-	add_wait_queue(&tfile->wq.wait, &wait);
+	add_wait_queue(&tfile->socket.wq.wait, &wait);
 
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -2194,7 +2193,7 @@ static void *tun_ring_recv(struct tun_file *tfile, int noblock, int *err)
 	}
 
 	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&tfile->wq.wait, &wait);
+	remove_wait_queue(&tfile->socket.wq.wait, &wait);
 
 out:
 	*err = error;
@@ -3417,8 +3416,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
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
index c606c72311d0..6979057c7c86 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -120,11 +120,11 @@ struct socket {
 
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
index 8de5ee258b93..0e1975b6202f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1811,7 +1811,7 @@ static inline void sock_graft(struct sock *sk, struct socket *parent)
 {
 	WARN_ON(parent->sk);
 	write_lock_bh(&sk->sk_callback_lock);
-	rcu_assign_pointer(sk->sk_wq, parent->wq);
+	rcu_assign_pointer(sk->sk_wq, &parent->wq);
 	parent->sk = sk;
 	sk_set_socket(sk, parent);
 	sk->sk_uid = SOCK_INODE(parent)->i_uid;
@@ -2095,7 +2095,7 @@ static inline void sock_poll_wait(struct file *filp, struct socket *sock,
 				  poll_table *p)
 {
 	if (!poll_does_not_wait(p)) {
-		poll_wait(filp, &sock->wq->wait, p);
+		poll_wait(filp, &sock->wq.wait, p);
 		/* We need to be sure we are in sync with the
 		 * socket flags modification.
 		 *
diff --git a/net/core/sock.c b/net/core/sock.c
index 782343bb925b..11af1ee7d542 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2842,7 +2842,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	if (sock) {
 		sk->sk_type	=	sock->type;
-		RCU_INIT_POINTER(sk->sk_wq, sock->wq);
+		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
 		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
diff --git a/net/socket.c b/net/socket.c
index 8255f5bda0aa..7d3d043fc56f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -239,20 +239,13 @@ static struct kmem_cache *sock_inode_cachep __ro_after_init;
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
@@ -263,12 +256,11 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
-static void sock_destroy_inode(struct inode *inode)
+static void sock_free_inode(struct inode *inode)
 {
 	struct socket_alloc *ei;
 
 	ei = container_of(inode, struct socket_alloc, vfs_inode);
-	kfree_rcu(ei->socket.wq, rcu);
 	kmem_cache_free(sock_inode_cachep, ei);
 }
 
@@ -293,7 +285,7 @@ static void init_inodecache(void)
 
 static const struct super_operations sockfs_ops = {
 	.alloc_inode	= sock_alloc_inode,
-	.destroy_inode	= sock_destroy_inode,
+	.free_inode	= sock_free_inode,
 	.statfs		= simple_statfs,
 };
 
@@ -604,7 +596,7 @@ static void __sock_release(struct socket *sock, struct inode *inode)
 		module_put(owner);
 	}
 
-	if (sock->wq->fasync_list)
+	if (sock->wq.fasync_list)
 		pr_err("%s: fasync list not empty!\n", __func__);
 
 	if (!sock->file) {
@@ -1263,13 +1255,12 @@ static int sock_fasync(int fd, struct file *filp, int on)
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
