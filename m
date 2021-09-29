Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEE41C804
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345199AbhI2PNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:20 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4231 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345099AbhI2PNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928287;
  x=1664464287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MzYbA0bW/O2YRknujPHqmWmFDtAuyM+1z3OFVDXtNn4=;
  b=OxBb9EEjEn5vfWGYoQZa8vuDnBdiNdFmiGurCXJTAu5z+7+5cC7zWdij
   caZXU8IOSnPfxIjAYtN8ZbpEeyDVmafxIzz6z7RxiOxHY9o9DYU9PSRot
   QGNSnL0xoI5ZiSwWoiat25+jitZpUPIbD97Hva/xDOlnOzMTxzeDOpG3J
   25wyS8cuSgkZP8J5G8PoKFOeeVEGlpvyBw84KhWJVZVldaLSE1bMHorGL
   7RNpXh596AIoELjrj1oBCyQvuMVkdI6z8HIWTuL7ap/g0qVmq8DVs1q+z
   +8GKiaVQ66wEmp0AnTpwyiaIztFERpWsAaA17weZa5wOSsrE+787gDR0d
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 08/10] vhost: net: add support for kernel control
Date:   Wed, 29 Sep 2021 17:11:17 +0200
Message-ID: <20210929151119.14778-9-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for kernel control to virtio-net.  For the vhost-*-kernel
devices, the ioctl to set the backend only provides the socket to
vhost-net but does not start the handling of the virtqueues.  The
handling of the virtqueues is started and stopped by the kernel.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/net.c | 106 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 98 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b5590b7862a9..977cfa89b216 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -144,6 +144,9 @@ struct vhost_net {
 	struct page_frag page_frag;
 	/* Refcount bias of page frag */
 	int refcnt_bias;
+	/* Used for storing backend sockets when stopped under kernel control */
+	struct socket *tx_sock;
+	struct socket *rx_sock;
 };
 
 static unsigned vhost_net_zcopy_mask __read_mostly;
@@ -1293,6 +1296,8 @@ static struct vhost_dev *vhost_net_open(struct vhost *vhost)
 	n = kvmalloc(sizeof *n, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!n)
 		return ERR_PTR(-ENOMEM);
+	n->tx_sock = NULL;
+	n->rx_sock = NULL;
 	vqs = kmalloc_array(VHOST_NET_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
 	if (!vqs) {
 		kvfree(n);
@@ -1364,6 +1369,20 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	return sock;
 }
 
+/* Stops the virtqueue but doesn't unconsume the tap ring */
+static struct socket *__vhost_net_stop_vq(struct vhost_net *n,
+					  struct vhost_virtqueue *vq)
+{
+	struct socket *sock;
+
+	mutex_lock(&vq->mutex);
+	sock = vhost_vq_get_backend(vq);
+	vhost_net_disable_vq(n, vq);
+	vhost_vq_set_backend(vq, NULL);
+	mutex_unlock(&vq->mutex);
+	return sock;
+}
+
 static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
 			   struct socket **rx_sock)
 {
@@ -1394,6 +1413,57 @@ static void vhost_net_flush(struct vhost_net *n)
 	}
 }
 
+static void vhost_net_start_vq(struct vhost_net *n, struct vhost_virtqueue *vq,
+			       struct socket *sock)
+{
+	mutex_lock(&vq->mutex);
+	vhost_vq_set_backend(vq, sock);
+	vhost_vq_init_access(vq);
+	vhost_net_enable_vq(n, vq);
+	mutex_unlock(&vq->mutex);
+}
+
+static void vhost_net_dev_start_vq(struct vhost_dev *dev, u16 idx)
+{
+	struct vhost_net *n = container_of(dev, struct vhost_net, dev);
+
+	if (WARN_ON(idx >= ARRAY_SIZE(n->vqs)))
+		return;
+
+	if (idx == VHOST_NET_VQ_RX) {
+		vhost_net_start_vq(n, &n->vqs[idx].vq, n->rx_sock);
+		n->rx_sock = NULL;
+	} else if (idx == VHOST_NET_VQ_TX) {
+		vhost_net_start_vq(n, &n->vqs[idx].vq, n->tx_sock);
+		n->tx_sock = NULL;
+	}
+
+	vhost_net_flush_vq(n, idx);
+}
+
+static void vhost_net_dev_stop_vq(struct vhost_dev *dev, u16 idx)
+{
+	struct vhost_net *n = container_of(dev, struct vhost_net, dev);
+	struct socket *sock;
+
+	if (WARN_ON(idx >= ARRAY_SIZE(n->vqs)))
+		return;
+
+	if (!vhost_vq_get_backend(&n->vqs[idx].vq))
+		return;
+
+	sock = __vhost_net_stop_vq(n, &n->vqs[idx].vq);
+
+	vhost_net_flush(n);
+	synchronize_rcu();
+	vhost_net_flush(n);
+
+	if (idx == VHOST_NET_VQ_RX)
+		n->rx_sock = sock;
+	else if (idx == VHOST_NET_VQ_TX)
+		n->tx_sock = sock;
+}
+
 static void vhost_net_release(struct vhost_dev *dev)
 {
 	struct vhost_net *n = container_of(dev, struct vhost_net, dev);
@@ -1405,6 +1475,14 @@ static void vhost_net_release(struct vhost_dev *dev)
 	vhost_dev_stop(&n->dev);
 	vhost_dev_cleanup(&n->dev);
 	vhost_net_vq_reset(n);
+	if (n->tx_sock) {
+		WARN_ON(tx_sock);
+		tx_sock = n->tx_sock;
+	}
+	if (n->rx_sock) {
+		WARN_ON(rx_sock);
+		rx_sock = n->rx_sock;
+	}
 	if (tx_sock)
 		sockfd_put(tx_sock);
 	if (rx_sock)
@@ -1518,7 +1596,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	mutex_lock(&vq->mutex);
 
 	/* Verify that ring has been setup correctly. */
-	if (!vhost_vq_access_ok(vq)) {
+	if (!vhost_kernel(vq) && !vhost_vq_access_ok(vq)) {
 		r = -EFAULT;
 		goto err_vq;
 	}
@@ -1539,14 +1617,17 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		}
 
 		vhost_net_disable_vq(n, vq);
-		vhost_vq_set_backend(vq, sock);
+		if (!vhost_kernel(vq))
+			vhost_vq_set_backend(vq, sock);
 		vhost_net_buf_unproduce(nvq);
-		r = vhost_vq_init_access(vq);
-		if (r)
-			goto err_used;
-		r = vhost_net_enable_vq(n, vq);
-		if (r)
-			goto err_used;
+		if (!vhost_kernel(vq)) {
+			r = vhost_vq_init_access(vq);
+			if (r)
+				goto err_used;
+			r = vhost_net_enable_vq(n, vq);
+			if (r)
+				goto err_used;
+		}
 		if (index == VHOST_NET_VQ_RX)
 			nvq->rx_ring = get_tap_ptr_ring(fd);
 
@@ -1572,6 +1653,13 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		sockfd_put(oldsock);
 	}
 
+	if (vhost_kernel(vq)) {
+		if (index == VHOST_NET_VQ_TX)
+			n->tx_sock = sock;
+		else if (index == VHOST_NET_VQ_RX)
+			n->rx_sock = sock;
+	}
+
 	return 0;
 
 err_used:
@@ -1733,6 +1821,8 @@ static const struct vhost_ops vhost_net_ops = {
 	.open           = vhost_net_open,
 	.release        = vhost_net_release,
 	.ioctl		= vhost_net_ioctl,
+	.start_vq	= vhost_net_dev_start_vq,
+	.stop_vq	= vhost_net_dev_stop_vq,
 };
 
 static struct vhost *vhost_net;
-- 
2.28.0

