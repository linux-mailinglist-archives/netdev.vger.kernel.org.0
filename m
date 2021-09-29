Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D169C41C7FB
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345260AbhI2PNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:23 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4224 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345109AbhI2PNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928288;
  x=1664464288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSpsqaSPCR0KkwR/V5TWdFbuLeIYeNSAyBlJF+6Nw08=;
  b=OygCTZBOjqmbHXpn3auLcjyAdF5zaNNmCkIdNB2IUQINO57pJtxNrPSP
   JDVnDwOYQsoRe3hblK9lOOSfMIEllyV+BxRjvvax7d9Y49PitY2ACrUJT
   MsJ7UvxZ8q64OVQviKwSXHUGTnOdnHHEx3z5AFtFthgzC0k8FIM0fRXO+
   tmohNN1LrFBhoymMcGJxuJaxhU3Zl4Ri4++70W6hLgrjScYLWL/zcZ9Q+
   fzrfA3TWY+o3GJDxaRswn7Ap22DYwIPEGKZYtmyJ87ALxxAr6Y4pzgEm+
   zBEYwePx4xEDasgifvVlyxaoY0WbRPncnD0jk5zMAabavaPYP89KVrnIv
   Q==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 02/10] vhost: push virtqueue area pointers into a user struct
Date:   Wed, 29 Sep 2021 17:11:11 +0200
Message-ID: <20210929151119.14778-3-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prepare for allowing vhost to operate on kernel buffers,
push the virtqueue desc/avail/used area pointers down to a new "user"
struct.

No functional change intended.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/vdpa.c  |  6 +--
 drivers/vhost/vhost.c | 90 +++++++++++++++++++++----------------------
 drivers/vhost/vhost.h |  8 ++--
 3 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index f41d081777f5..6f05388f5a21 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -400,9 +400,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	switch (cmd) {
 	case VHOST_SET_VRING_ADDR:
 		if (ops->set_vq_address(vdpa, idx,
-					(u64)(uintptr_t)vq->desc,
-					(u64)(uintptr_t)vq->avail,
-					(u64)(uintptr_t)vq->used))
+					(u64)(uintptr_t)vq->user.desc,
+					(u64)(uintptr_t)vq->user.avail,
+					(u64)(uintptr_t)vq->user.used))
 			r = -EINVAL;
 		break;
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..108994f386f7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -46,8 +46,8 @@ enum {
 	VHOST_MEMORY_F_LOG = 0x1,
 };
 
-#define vhost_used_event(vq) ((__virtio16 __user *)&vq->avail->ring[vq->num])
-#define vhost_avail_event(vq) ((__virtio16 __user *)&vq->used->ring[vq->num])
+#define vhost_used_event(vq) ((__virtio16 __user *)&vq->user.avail->ring[vq->num])
+#define vhost_avail_event(vq) ((__virtio16 __user *)&vq->user.used->ring[vq->num])
 
 #ifdef CONFIG_VHOST_CROSS_ENDIAN_LEGACY
 static void vhost_disable_cross_endian(struct vhost_virtqueue *vq)
@@ -306,7 +306,7 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
 
 bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
 {
-	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
+	return vq->user.avail && vq->user.desc && vq->user.used && vhost_vq_access_ok(vq);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
 
@@ -314,9 +314,9 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
 	vq->num = 1;
-	vq->desc = NULL;
-	vq->avail = NULL;
-	vq->used = NULL;
+	vq->user.desc = NULL;
+	vq->user.avail = NULL;
+	vq->user.used = NULL;
 	vq->last_avail_idx = 0;
 	vq->avail_idx = 0;
 	vq->last_used_idx = 0;
@@ -444,8 +444,8 @@ static size_t vhost_get_avail_size(struct vhost_virtqueue *vq,
 	size_t event __maybe_unused =
 	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
 
-	return sizeof(*vq->avail) +
-	       sizeof(*vq->avail->ring) * num + event;
+	return sizeof(*vq->user.avail) +
+	       sizeof(*vq->user.avail->ring) * num + event;
 }
 
 static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
@@ -454,14 +454,14 @@ static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
 	size_t event __maybe_unused =
 	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
 
-	return sizeof(*vq->used) +
-	       sizeof(*vq->used->ring) * num + event;
+	return sizeof(*vq->user.used) +
+	       sizeof(*vq->user.used->ring) * num + event;
 }
 
 static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
 				  unsigned int num)
 {
-	return sizeof(*vq->desc) * num;
+	return sizeof(*vq->user.desc) * num;
 }
 
 void vhost_dev_init(struct vhost_dev *dev,
@@ -959,7 +959,7 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
 				 struct vring_used_elem *head, int idx,
 				 int count)
 {
-	return vhost_copy_to_user(vq, vq->used->ring + idx, head,
+	return vhost_copy_to_user(vq, vq->user.used->ring + idx, head,
 				  count * sizeof(*head));
 }
 
@@ -967,14 +967,14 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 
 {
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->used_flags),
-			      &vq->used->flags);
+			      &vq->user.used->flags);
 }
 
 static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 
 {
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->last_used_idx),
-			      &vq->used->idx);
+			      &vq->user.used->idx);
 }
 
 #define vhost_get_user(vq, x, ptr, type)		\
@@ -1018,20 +1018,20 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
 				      __virtio16 *idx)
 {
-	return vhost_get_avail(vq, *idx, &vq->avail->idx);
+	return vhost_get_avail(vq, *idx, &vq->user.avail->idx);
 }
 
 static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
 				       __virtio16 *head, int idx)
 {
 	return vhost_get_avail(vq, *head,
-			       &vq->avail->ring[idx & (vq->num - 1)]);
+			       &vq->user.avail->ring[idx & (vq->num - 1)]);
 }
 
 static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
 					__virtio16 *flags)
 {
-	return vhost_get_avail(vq, *flags, &vq->avail->flags);
+	return vhost_get_avail(vq, *flags, &vq->user.avail->flags);
 }
 
 static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
@@ -1043,13 +1043,13 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
 static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
 				     __virtio16 *idx)
 {
-	return vhost_get_used(vq, *idx, &vq->used->idx);
+	return vhost_get_used(vq, *idx, &vq->user.used->idx);
 }
 
 static inline int vhost_get_desc(struct vhost_virtqueue *vq,
 				 struct vring_desc *desc, int idx)
 {
-	return vhost_copy_from_user(vq, desc, vq->desc + idx, sizeof(*desc));
+	return vhost_copy_from_user(vq, desc, vq->user.desc + idx, sizeof(*desc));
 }
 
 static void vhost_iotlb_notify_vq(struct vhost_dev *d,
@@ -1363,12 +1363,12 @@ int vq_meta_prefetch(struct vhost_virtqueue *vq)
 	if (!vq->iotlb)
 		return 1;
 
-	return iotlb_access_ok(vq, VHOST_MAP_RO, (u64)(uintptr_t)vq->desc,
+	return iotlb_access_ok(vq, VHOST_MAP_RO, (u64)(uintptr_t)vq->user.desc,
 			       vhost_get_desc_size(vq, num), VHOST_ADDR_DESC) &&
-	       iotlb_access_ok(vq, VHOST_MAP_RO, (u64)(uintptr_t)vq->avail,
+	       iotlb_access_ok(vq, VHOST_MAP_RO, (u64)(uintptr_t)vq->user.avail,
 			       vhost_get_avail_size(vq, num),
 			       VHOST_ADDR_AVAIL) &&
-	       iotlb_access_ok(vq, VHOST_MAP_WO, (u64)(uintptr_t)vq->used,
+	       iotlb_access_ok(vq, VHOST_MAP_WO, (u64)(uintptr_t)vq->user.used,
 			       vhost_get_used_size(vq, num), VHOST_ADDR_USED);
 }
 EXPORT_SYMBOL_GPL(vq_meta_prefetch);
@@ -1412,7 +1412,7 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq)
 	if (!vq_log_access_ok(vq, vq->log_base))
 		return false;
 
-	return vq_access_ok(vq, vq->num, vq->desc, vq->avail, vq->used);
+	return vq_access_ok(vq, vq->num, vq->user.desc, vq->user.avail, vq->user.used);
 }
 EXPORT_SYMBOL_GPL(vhost_vq_access_ok);
 
@@ -1523,8 +1523,8 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 		return -EFAULT;
 
 	/* Make sure it's safe to cast pointers to vring types. */
-	BUILD_BUG_ON(__alignof__ *vq->avail > VRING_AVAIL_ALIGN_SIZE);
-	BUILD_BUG_ON(__alignof__ *vq->used > VRING_USED_ALIGN_SIZE);
+	BUILD_BUG_ON(__alignof__ *vq->user.avail > VRING_AVAIL_ALIGN_SIZE);
+	BUILD_BUG_ON(__alignof__ *vq->user.used > VRING_USED_ALIGN_SIZE);
 	if ((a.avail_user_addr & (VRING_AVAIL_ALIGN_SIZE - 1)) ||
 	    (a.used_user_addr & (VRING_USED_ALIGN_SIZE - 1)) ||
 	    (a.log_guest_addr & (VRING_USED_ALIGN_SIZE - 1)))
@@ -1548,10 +1548,10 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
 	}
 
 	vq->log_used = !!(a.flags & (0x1 << VHOST_VRING_F_LOG));
-	vq->desc = (void __user *)(unsigned long)a.desc_user_addr;
-	vq->avail = (void __user *)(unsigned long)a.avail_user_addr;
+	vq->user.desc = (void __user *)(unsigned long)a.desc_user_addr;
+	vq->user.avail = (void __user *)(unsigned long)a.avail_user_addr;
 	vq->log_addr = a.log_guest_addr;
-	vq->used = (void __user *)(unsigned long)a.used_user_addr;
+	vq->user.used = (void __user *)(unsigned long)a.used_user_addr;
 
 	return 0;
 }
@@ -1912,8 +1912,8 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 	if (!vq->iotlb)
 		return log_write(vq->log_base, vq->log_addr + used_offset, len);
 
-	ret = translate_desc(vq, (uintptr_t)vq->used + used_offset,
-			     len, iov, 64, VHOST_ACCESS_WO);
+	ret = translate_desc(vq, (uintptr_t)vq->user.used + used_offset,
+			     len, vq->log_iov, 64, VHOST_ACCESS_WO);
 	if (ret < 0)
 		return ret;
 
@@ -1972,9 +1972,9 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 		/* Make sure the flag is seen before log. */
 		smp_wmb();
 		/* Log used flag write. */
-		used = &vq->used->flags;
-		log_used(vq, (used - (void __user *)vq->used),
-			 sizeof vq->used->flags);
+		used = &vq->user.used->flags;
+		log_used(vq, (used - (void __user *)vq->user.used),
+			 sizeof vq->user.used->flags);
 		if (vq->log_ctx)
 			eventfd_signal(vq->log_ctx, 1);
 	}
@@ -1991,7 +1991,7 @@ static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
 		smp_wmb();
 		/* Log avail event write */
 		used = vhost_avail_event(vq);
-		log_used(vq, (used - (void __user *)vq->used),
+		log_used(vq, (used - (void __user *)vq->user.used),
 			 sizeof *vhost_avail_event(vq));
 		if (vq->log_ctx)
 			eventfd_signal(vq->log_ctx, 1);
@@ -2015,14 +2015,14 @@ int vhost_vq_init_access(struct vhost_virtqueue *vq)
 		goto err;
 	vq->signalled_used_valid = false;
 	if (!vq->iotlb &&
-	    !access_ok(&vq->used->idx, sizeof vq->used->idx)) {
+	    !access_ok(&vq->user.used->idx, sizeof vq->user.used->idx)) {
 		r = -EFAULT;
 		goto err;
 	}
 	r = vhost_get_used_idx(vq, &last_used_idx);
 	if (r) {
 		vq_err(vq, "Can't access used idx at %p\n",
-		       &vq->used->idx);
+		       &vq->user.used->idx);
 		goto err;
 	}
 	vq->last_used_idx = vhost16_to_cpu(vq, last_used_idx);
@@ -2214,7 +2214,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	if (vq->avail_idx == vq->last_avail_idx) {
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
-				&vq->avail->idx);
+				&vq->user.avail->idx);
 			return -EFAULT;
 		}
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
@@ -2242,7 +2242,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
 		vq_err(vq, "Failed to read head: idx %d address %p\n",
 		       last_avail_idx,
-		       &vq->avail->ring[last_avail_idx % vq->num]);
+		       &vq->user.avail->ring[last_avail_idx % vq->num]);
 		return -EFAULT;
 	}
 
@@ -2277,7 +2277,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		ret = vhost_get_desc(vq, &desc, i);
 		if (unlikely(ret)) {
 			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
-			       i, vq->desc + i);
+			       i, vq->user.desc + i);
 			return -EFAULT;
 		}
 		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
@@ -2366,7 +2366,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	int start;
 
 	start = vq->last_used_idx & (vq->num - 1);
-	used = vq->used->ring + start;
+	used = vq->user.used->ring + start;
 	if (vhost_put_used(vq, heads, start, count)) {
 		vq_err(vq, "Failed to write used");
 		return -EFAULT;
@@ -2375,7 +2375,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 		/* Make sure data is seen before log. */
 		smp_wmb();
 		/* Log used ring entry write. */
-		log_used(vq, ((void __user *)used - (void __user *)vq->used),
+		log_used(vq, ((void __user *)used - (void __user *)vq->user.used),
 			 count * sizeof *used);
 	}
 	old = vq->last_used_idx;
@@ -2418,7 +2418,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		smp_wmb();
 		/* Log used index update. */
 		log_used(vq, offsetof(struct vring_used, idx),
-			 sizeof vq->used->idx);
+			 sizeof vq->user.used->idx);
 		if (vq->log_ctx)
 			eventfd_signal(vq->log_ctx, 1);
 	}
@@ -2523,7 +2523,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 		r = vhost_update_used_flags(vq);
 		if (r) {
 			vq_err(vq, "Failed to enable notification at %p: %d\n",
-			       &vq->used->flags, r);
+			       &vq->user.used->flags, r);
 			return false;
 		}
 	} else {
@@ -2540,7 +2540,7 @@ bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	r = vhost_get_avail_idx(vq, &avail_idx);
 	if (r) {
 		vq_err(vq, "Failed to check avail idx at %p: %d\n",
-		       &vq->avail->idx, r);
+		       &vq->user.avail->idx, r);
 		return false;
 	}
 
@@ -2560,7 +2560,7 @@ void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 		r = vhost_update_used_flags(vq);
 		if (r)
 			vq_err(vq, "Failed to disable notification at %p: %d\n",
-			       &vq->used->flags, r);
+			       &vq->user.used->flags, r);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_disable_notify);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..b1db4ffe75f0 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -72,9 +72,11 @@ struct vhost_virtqueue {
 	/* The actual ring of buffers. */
 	struct mutex mutex;
 	unsigned int num;
-	vring_desc_t __user *desc;
-	vring_avail_t __user *avail;
-	vring_used_t __user *used;
+	struct {
+		vring_desc_t __user *desc;
+		vring_avail_t __user *avail;
+		vring_used_t __user *used;
+	} user;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;
 	struct vhost_vring_call call_ctx;
-- 
2.28.0

