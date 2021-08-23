Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE863F4677
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 10:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbhHWIPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 04:15:33 -0400
Received: from smtp2.axis.com ([195.60.68.18]:18544 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235353AbhHWIPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 04:15:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1629706489;
  x=1661242489;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=32tMdW/MLxZqNlGhqw7Ozd6NQxd2ifBcs6cYnFP5KZA=;
  b=pcEBjlviIHWUa+SvTHTOznfq9Uw3e6TJSzBgd37NOSx+MGBl5ithppVI
   bJVJ5zh96absMrvmNNzesuUOEDIBYm5EvgVBEnM5LHyech5fwwlxfMvsW
   wQ00WjgXY1Row4qlFbSHzjYyCNO0akTkGm4UuCe40Eh3t2pHBv3Ep88wh
   n7x9dRQR0fUa1/dCLqoNCRZ554yjrBkfaP8qRajjsRJQa1VpIyFxOR/UG
   B1nikl6A9vYOE+9cFWYo3jAo/v6ZpYs9wbBoCS1MKObqra28uFu9DX8pP
   m2gwXXZbfu0Tnb6a0Jb0Lnnl1nAhKJmHTcWxZzdXV1PW1saIBy4IYzi7f
   A==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] vhost: add support for mandatory barriers
Date:   Mon, 23 Aug 2021 10:14:37 +0200
Message-ID: <20210823081437.14274-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost always uses SMP-conditional barriers, but these may not be
sufficient when vhost is used to communicate between heterogeneous
processors in an AMP configuration, especially since they're NOPs on
!SMP builds.

To solve this, use the virtio_*() barrier functions and ask them for
non-weak barriers if requested by userspace.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/vhost.c      | 23 ++++++++++++++---------
 drivers/vhost/vhost.h      |  2 ++
 include/uapi/linux/vhost.h |  2 ++
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b9e853e6094d..f7172e1bc395 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -500,6 +500,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->indirect = NULL;
 		vq->heads = NULL;
 		vq->dev = dev;
+		vq->weak_barriers = true;
 		mutex_init(&vq->mutex);
 		vhost_vq_reset(dev, vq);
 		if (vq->handle_kick)
@@ -1801,6 +1802,10 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
 		if (ctx)
 			eventfd_ctx_put(ctx);
 		break;
+	case VHOST_SET_STRONG_BARRIERS:
+		for (i = 0; i < d->nvqs; ++i)
+			d->vqs[i]->weak_barriers = false;
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 		break;
@@ -1927,7 +1932,7 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 	int i, r;
 
 	/* Make sure data written is seen before log. */
-	smp_wmb();
+	virtio_wmb(vq->weak_barriers);
 
 	if (vq->iotlb) {
 		for (i = 0; i < count; i++) {
@@ -1964,7 +1969,7 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 		return -EFAULT;
 	if (unlikely(vq->log_used)) {
 		/* Make sure the flag is seen before log. */
-		smp_wmb();
+		virtio_wmb(vq->weak_barriers);
 		/* Log used flag write. */
 		used = &vq->used->flags;
 		log_used(vq, (used - (void __user *)vq->used),
@@ -1982,7 +1987,7 @@ static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
 	if (unlikely(vq->log_used)) {
 		void __user *used;
 		/* Make sure the event is seen before log. */
-		smp_wmb();
+		virtio_wmb(vq->weak_barriers);
 		/* Log avail event write */
 		used = vhost_avail_event(vq);
 		log_used(vq, (used - (void __user *)vq->used),
@@ -2228,7 +2233,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		/* Only get avail ring entries after they have been
 		 * exposed by guest.
 		 */
-		smp_rmb();
+		virtio_rmb(vq->weak_barriers);
 	}
 
 	/* Grab the next descriptor number they're advertising, and increment
@@ -2367,7 +2372,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	}
 	if (unlikely(vq->log_used)) {
 		/* Make sure data is seen before log. */
-		smp_wmb();
+		virtio_wmb(vq->weak_barriers);
 		/* Log used ring entry write. */
 		log_used(vq, ((void __user *)used - (void __user *)vq->used),
 			 count * sizeof *used);
@@ -2402,14 +2407,14 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	r = __vhost_add_used_n(vq, heads, count);
 
 	/* Make sure buffer is written before we update index. */
-	smp_wmb();
+	virtio_wmb(vq->weak_barriers);
 	if (vhost_put_used_idx(vq)) {
 		vq_err(vq, "Failed to increment used idx");
 		return -EFAULT;
 	}
 	if (unlikely(vq->log_used)) {
 		/* Make sure used idx is seen before log. */
-		smp_wmb();
+		virtio_wmb(vq->weak_barriers);
 		/* Log used index update. */
 		log_used(vq, offsetof(struct vring_used, idx),
 			 sizeof vq->used->idx);
@@ -2428,7 +2433,7 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	/* Flush out used index updates. This is paired
 	 * with the barrier that the Guest executes when enabling
 	 * interrupts. */
-	smp_mb();
+	virtio_mb(vq->weak_barriers);
 
 	if (vhost_has_feature(vq, VIRTIO_F_NOTIFY_ON_EMPTY) &&
 	    unlikely(vq->avail_idx == vq->last_avail_idx))
@@ -2530,7 +2535,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	}
 	/* They could have slipped one in as we were doing that: make
 	 * sure it's written, then check again. */
-	smp_mb();
+	virtio_mb(vq->weak_barriers);
 	r = vhost_get_avail_idx(vq, &avail_idx);
 	if (r) {
 		vq_err(vq, "Failed to check avail idx at %p: %d\n",
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..5bd20d0db457 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -108,6 +108,8 @@ struct vhost_virtqueue {
 	bool log_used;
 	u64 log_addr;
 
+	bool weak_barriers;
+
 	struct iovec iov[UIO_MAXIOV];
 	struct iovec iotlb_iov[64];
 	struct iovec *indirect;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c998860d7bbc..4b8656307f51 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -97,6 +97,8 @@
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
+#define VHOST_SET_STRONG_BARRIERS _IO(VHOST_VIRTIO, 0x27)
+
 /* VHOST_NET specific defines */
 
 /* Attach virtio net ring to a raw socket, or tap device.
-- 
2.28.0

