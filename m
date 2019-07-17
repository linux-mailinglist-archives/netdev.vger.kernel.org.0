Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7EE6BAC9
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387680AbfGQKyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387539AbfGQKyS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:54:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30293307D90D;
        Wed, 17 Jul 2019 10:54:18 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4143310246E8;
        Wed, 17 Jul 2019 10:54:14 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 14/15] vhost: event suppression for packed ring
Date:   Wed, 17 Jul 2019 06:52:54 -0400
Message-Id: <20190717105255.63488-15-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 17 Jul 2019 10:54:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces support for event suppression. This is done by
have a two areas: device area and driver area. One side could then try
to disable or enable (delayed) notification from other side by using a
boolean hint or event index interface in the areas.

For more information, please refer Virtio spec.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 265 +++++++++++++++++++++++++++++++++++++++---
 drivers/vhost/vhost.h |  11 +-
 2 files changed, 255 insertions(+), 21 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a7d24b9d5204..a188e9af3b35 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1524,6 +1524,76 @@ static inline int vhost_put_desc_flags(struct vhost_virtqueue *vq,
 	return vhost_put_user(vq, *flags, &desc->flags, VHOST_ADDR_DESC);
 }
 
+static int vhost_get_driver_off_wrap(struct vhost_virtqueue *vq,
+				     __virtio16 *off_wrap)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc_event *event =
+	       vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
+	if (likely(event)) {
+		*off_wrap = event->off_wrap;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+	return vhost_get_user(vq, *off_wrap,
+			      &vq->driver_event->off_wrap,
+			      VHOST_ADDR_AVAIL);
+}
+
+static int vhost_get_driver_flags(struct vhost_virtqueue *vq,
+				  __virtio16 *driver_flags)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc_event *event =
+	       vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
+
+	if (likely(event)) {
+		*driver_flags = event->flags;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+	return vhost_get_user(vq, *driver_flags, &vq->driver_event->flags,
+			      VHOST_ADDR_AVAIL);
+}
+
+static int vhost_put_device_off_wrap(struct vhost_virtqueue *vq,
+				     __virtio16 *off_wrap)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc_event *event =
+	       vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
+
+	if (likely(event)) {
+		event->off_wrap = *off_wrap;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+	return vhost_put_user(vq, *off_wrap,
+			      &vq->device_event->off_wrap,
+			      VHOST_ADDR_USED);
+}
+
+static int vhost_put_device_flags(struct vhost_virtqueue *vq,
+				  __virtio16 *device_flags)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc_event *event =
+	       vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
+
+	if (likely(event)) {
+		event->flags = *device_flags;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+	return vhost_put_user(vq, *device_flags,
+			      &vq->device_event->flags,
+			      VHOST_ADDR_USED);
+}
+
 static int vhost_new_umem_range(struct vhost_umem *umem,
 				u64 start, u64 size, u64 end,
 				u64 userspace_addr, int perm)
@@ -1809,10 +1879,15 @@ static int vq_access_ok_packed(struct vhost_virtqueue *vq, unsigned int num,
 			       struct vring_used __user *used)
 {
 	struct vring_packed_desc *packed = (struct vring_packed_desc *)desc;
+	struct vring_packed_desc_event *driver_event =
+		(struct vring_packed_desc_event *)avail;
+	struct vring_packed_desc_event *device_event =
+		(struct vring_packed_desc_event *)used;
 
-	/* TODO: check device area and driver area */
 	return access_ok(packed, num * sizeof(*packed)) &&
-	       access_ok(packed, num * sizeof(*packed));
+	       access_ok(packed, num * sizeof(*packed)) &&
+	       access_ok(driver_event, sizeof(*driver_event)) &&
+	       access_ok(device_event, sizeof(*device_event));
 }
 
 static int vq_access_ok_split(struct vhost_virtqueue *vq, unsigned int num,
@@ -1904,16 +1979,25 @@ static void vhost_vq_map_prefetch(struct vhost_virtqueue *vq)
 }
 #endif
 
-int vq_meta_prefetch(struct vhost_virtqueue *vq)
+static int vq_iotlb_prefetch_packed(struct vhost_virtqueue *vq)
 {
-	unsigned int num = vq->num;
+	int num = vq->num;
 
-	if (!vq->iotlb) {
-#if VHOST_ARCH_CAN_ACCEL_UACCESS
-		vhost_vq_map_prefetch(vq);
-#endif
-		return 1;
-	}
+	return iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->desc,
+			       num * sizeof(*vq->desc), VHOST_ADDR_DESC) &&
+	       iotlb_access_ok(vq, VHOST_ACCESS_WO, (u64)(uintptr_t)vq->desc,
+			       num * sizeof(*vq->desc), VHOST_ADDR_DESC) &&
+	       iotlb_access_ok(vq, VHOST_ACCESS_RO,
+			       (u64)(uintptr_t)vq->driver_event,
+			       sizeof(*vq->driver_event), VHOST_ADDR_AVAIL) &&
+	       iotlb_access_ok(vq, VHOST_ACCESS_WO,
+			       (u64)(uintptr_t)vq->device_event,
+			       sizeof(*vq->device_event), VHOST_ADDR_USED);
+}
+
+static int vq_iotlb_prefetch_split(struct vhost_virtqueue *vq)
+{
+	unsigned int num = vq->num;
 
 	return iotlb_access_ok(vq, VHOST_ACCESS_RO,
 			       (u64)(uintptr_t)vq->desc,
@@ -1928,6 +2012,21 @@ int vq_meta_prefetch(struct vhost_virtqueue *vq)
 			       vhost_get_used_size(vq, num),
 			       VHOST_ADDR_USED);
 }
+
+int vq_meta_prefetch(struct vhost_virtqueue *vq)
+{
+	if (!vq->iotlb) {
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+		vhost_vq_map_prefetch(vq);
+#endif
+		return 1;
+	}
+
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+		return vq_iotlb_prefetch_packed(vq);
+	else
+		return vq_iotlb_prefetch_split(vq);
+}
 EXPORT_SYMBOL_GPL(vq_meta_prefetch);
 
 /* Can we log writes? */
@@ -2620,6 +2719,48 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 	return 0;
 }
 
+static int vhost_update_device_flags(struct vhost_virtqueue *vq,
+				     __virtio16 device_flags)
+{
+	void __user *flags;
+
+	if (vhost_put_device_flags(vq, &device_flags))
+		return -EFAULT;
+	if (unlikely(vq->log_used)) {
+		/* Make sure the flag is seen before log. */
+		smp_wmb();
+		/* Log used flag write. */
+		flags = &vq->device_event->flags;
+		log_write(vq->log_base, vq->log_addr +
+			  (flags - (void __user *)vq->device_event),
+			  sizeof(vq->device_event->flags));
+		if (vq->log_ctx)
+			eventfd_signal(vq->log_ctx, 1);
+	}
+	return 0;
+}
+
+static int vhost_update_device_off_wrap(struct vhost_virtqueue *vq,
+					__virtio16 device_off_wrap)
+{
+	void __user *off_wrap;
+
+	if (vhost_put_device_off_wrap(vq, &device_off_wrap))
+		return -EFAULT;
+	if (unlikely(vq->log_used)) {
+		/* Make sure the flag is seen before log. */
+		smp_wmb();
+		/* Log used flag write. */
+		off_wrap = &vq->device_event->off_wrap;
+		log_write(vq->log_base, vq->log_addr +
+			  (off_wrap - (void __user *)vq->device_event),
+			  sizeof(vq->device_event->off_wrap));
+		if (vq->log_ctx)
+			eventfd_signal(vq->log_ctx, 1);
+	}
+	return 0;
+}
+
 static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
 {
 	if (vhost_put_avail_event(vq))
@@ -3689,16 +3830,13 @@ int vhost_add_used(struct vhost_virtqueue *vq, struct vhost_used_elem *used,
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
-static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+static bool vhost_notify_split(struct vhost_dev *dev,
+			       struct vhost_virtqueue *vq)
 {
 	__u16 old, new;
 	__virtio16 event;
 	bool v;
 
-	/* TODO: check driver area */
-	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
-		return true;
-
 	/* Flush out used index updates. This is paired
 	 * with the barrier that the Guest executes when enabling
 	 * interrupts. */
@@ -3731,6 +3869,62 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	return vring_need_event(vhost16_to_cpu(vq, event), new, old);
 }
 
+static bool vhost_notify_packed(struct vhost_dev *dev,
+				struct vhost_virtqueue *vq)
+{
+	__virtio16 event_off_wrap, event_flags;
+	__u16 old, new, off_wrap;
+	bool v;
+
+	/* Flush out used descriptors updates. This is paired
+	 * with the barrier that the Guest executes when enabling
+	 * interrupts.
+	 */
+	smp_mb();
+
+	if (vhost_get_driver_flags(vq, &event_flags)) {
+		vq_err(vq, "Failed to get driver desc_event_flags");
+		return true;
+	}
+
+	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX))
+		return event_flags !=
+		       cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_DISABLE);
+
+	old = vq->signalled_used;
+	v = vq->signalled_used_valid;
+	new = vq->signalled_used = vq->last_used_idx;
+	vq->signalled_used_valid = true;
+
+	if (event_flags != cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_DESC))
+		return event_flags !=
+		       cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_DISABLE);
+
+	/* Read desc event flags before event_off and event_wrap */
+	smp_rmb();
+
+	if (vhost_get_driver_off_wrap(vq, &event_off_wrap) < 0) {
+		vq_err(vq, "Failed to get driver desc_event_off/wrap");
+		return true;
+	}
+
+	off_wrap = vhost16_to_cpu(vq, event_off_wrap);
+
+	if (unlikely(!v))
+		return true;
+
+	return vhost_vring_packed_need_event(vq, vq->last_used_wrap_counter,
+					     off_wrap, new, old);
+}
+
+static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
+{
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+		return vhost_notify_packed(dev, vq);
+	else
+		return vhost_notify_split(dev, vq);
+}
+
 /* This actually signals the guest, using eventfd. */
 void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
@@ -3836,10 +4030,34 @@ EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 static bool vhost_enable_notify_packed(struct vhost_virtqueue *vq)
 {
 	struct vring_packed_desc *d = vq->desc_packed + vq->avail_idx;
-	__virtio16 flags;
+	__virtio16 flags = cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_ENABLE);
 	int ret;
 
-	/* TODO: enable notification through device area */
+	if (!(vq->used_flags & VRING_USED_F_NO_NOTIFY))
+		return false;
+	vq->used_flags &= ~VRING_USED_F_NO_NOTIFY;
+
+	if (vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
+		__virtio16 off_wrap = cpu_to_vhost16(vq, vq->avail_idx |
+				      vq->avail_wrap_counter << 15);
+
+		ret = vhost_update_device_off_wrap(vq, off_wrap);
+		if (ret) {
+			vq_err(vq, "Failed to write to off warp at %p: %d\n",
+			       &vq->device_event->off_wrap, ret);
+			return false;
+		}
+		/* Make sure off_wrap is wrote before flags */
+		smp_wmb();
+		flags = cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_DESC);
+	}
+
+	ret = vhost_update_device_flags(vq, flags);
+	if (ret) {
+		vq_err(vq, "Failed to enable notification at %p: %d\n",
+			&vq->device_event->flags, ret);
+		return false;
+	}
 
 	/* They could have slipped one in as we were doing that: make
 	 * sure it's written, then check again.
@@ -3901,7 +4119,18 @@ EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
 static void vhost_disable_notify_packed(struct vhost_virtqueue *vq)
 {
-	/* TODO: disable notification through device area */
+	__virtio16 flags;
+	int r;
+
+	if (vq->used_flags & VRING_USED_F_NO_NOTIFY)
+		return;
+	vq->used_flags |= VRING_USED_F_NO_NOTIFY;
+
+	flags = cpu_to_vhost16(vq, VRING_PACKED_EVENT_FLAG_DISABLE);
+	r = vhost_update_device_flags(vq, flags);
+	if (r)
+		vq_err(vq, "Failed to enable notification at %p: %d\n",
+		       &vq->device_event->flags, r);
 }
 
 static void vhost_disable_notify_split(struct vhost_virtqueue *vq)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 7f3a2dd1b628..bb3f8bb763b9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -125,9 +125,14 @@ struct vhost_virtqueue {
 		struct vring_desc __user *desc;
 		struct vring_packed_desc __user *desc_packed;
 	};
-	struct vring_avail __user *avail;
-	struct vring_used __user *used;
-
+	union {
+		struct vring_avail __user *avail;
+		struct vring_packed_desc_event __user *driver_event;
+	};
+	union {
+		struct vring_used __user *used;
+		struct vring_packed_desc_event __user *device_event;
+	};
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
 	/* Read by memory accessors, modified by meta data
 	 * prefetching, MMU notifier and vring ioctl().
-- 
2.18.1

