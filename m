Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB788146083
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAWBm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgAWBmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:25 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9F462468D;
        Thu, 23 Jan 2020 01:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743744;
        bh=91dEofdiDaefppgV0V/OCOJB7WdG6FxqQ0kZDIIMXgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc3wzdynu2uGtkAI8ZhKgUWtNRGn6y1R8HoudmKjHQQGWAm7mwihiPSaM/l007c4N
         KOHia0nPK8Z/E6yFpoi7Z6WolsJ71XItsfKYd6vx4pCaBmUrRJZ/1qjOF2RDdQaHb9
         aQf2PjzS9k8sFFio5q2hbTYWM5+7p2pgmoUEZ57E=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 08/12] tuntap: remove usage of ptr ring in vhost_net
Date:   Wed, 22 Jan 2020 18:42:06 -0700
Message-Id: <20200123014210.38412-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Remove usage of ptr ring of tuntap in vhost_net and remove the
functions exported from tuntap drivers to get ptr ring.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c      | 13 -------------
 drivers/net/tun.c      | 13 -------------
 drivers/vhost/net.c    | 31 ++++---------------------------
 include/linux/if_tap.h |  5 -----
 include/linux/if_tun.h |  5 -----
 5 files changed, 4 insertions(+), 63 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a5ce44db11a3..fe816a99275d 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1288,19 +1288,6 @@ struct socket *tap_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
-struct ptr_ring *tap_get_ptr_ring(struct file *file)
-{
-	struct tap_queue *q;
-
-	if (file->f_op != &tap_fops)
-		return ERR_PTR(-EINVAL);
-	q = file->private_data;
-	if (!q)
-		return ERR_PTR(-EBADFD);
-	return &q->ring;
-}
-EXPORT_SYMBOL_GPL(tap_get_ptr_ring);
-
 int tap_queue_resize(struct tap_dev *tap)
 {
 	struct net_device *dev = tap->dev;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 197bde748c09..d4a0e59fcf5c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3717,19 +3717,6 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
-struct ptr_ring *tun_get_tx_ring(struct file *file)
-{
-	struct tun_file *tfile;
-
-	if (file->f_op != &tun_fops)
-		return ERR_PTR(-EINVAL);
-	tfile = file->private_data;
-	if (!tfile)
-		return ERR_PTR(-EBADFD);
-	return &tfile->tx_ring;
-}
-EXPORT_SYMBOL_GPL(tun_get_tx_ring);
-
 module_init(tun_init);
 module_exit(tun_cleanup);
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 482548d00105..30b5c68193c9 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -122,7 +122,6 @@ struct vhost_net_virtqueue {
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ptr_ring *rx_ring;
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
@@ -997,8 +996,9 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	len = vhost_net_buf_peek(rvq);
+	if (len)
+		return len;
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1187,7 +1187,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring) {
+		if (!vhost_net_buf_is_empty(&nvq->rxq)) {
 			ctl.type = TUN_MSG_PKT;
 			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
 			msg.msg_control = &ctl;
@@ -1343,7 +1343,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1372,7 +1371,6 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	vhost_net_disable_vq(n, vq);
 	vhost_net_buf_unproduce(nvq);
 	vq->private_data = NULL;
-	nvq->rx_ring = NULL;
 	mutex_unlock(&vq->mutex);
 	return sock;
 }
@@ -1468,25 +1466,6 @@ static struct socket *get_raw_socket(int fd)
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(int fd)
-{
-	struct ptr_ring *ring;
-	struct file *file = fget(fd);
-
-	if (!file)
-		return NULL;
-	ring = tun_get_tx_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = tap_get_ptr_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = NULL;
-out:
-	fput(file);
-	return ring;
-}
-
 static struct socket *get_tap_socket(int fd)
 {
 	struct file *file = fget(fd);
@@ -1570,8 +1549,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..68fe366fb185 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -4,7 +4,6 @@
 
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
-struct ptr_ring *tap_get_ptr_ring(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -14,10 +13,6 @@ static inline struct socket *tap_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
-static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
 #endif /* CONFIG_TAP */
 
 #include <net/sock.h>
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 9184e3f177b8..41d72bb0eaf1 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -45,7 +45,6 @@ struct tun_xdp_hdr {
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
-struct ptr_ring *tun_get_tx_ring(struct file *file);
 
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -84,10 +83,6 @@ static inline struct socket *tun_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
-static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.21.1 (Apple Git-122.3)

