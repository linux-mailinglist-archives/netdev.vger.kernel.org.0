Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A3341C7F5
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345116AbhI2PNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:13:08 -0400
Received: from smtp2.axis.com ([195.60.68.18]:4224 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345012AbhI2PNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:13:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1632928283;
  x=1664464283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sQYXIkzCFmG+nBQTwf3ciqSXojL95cuWllGvIIUr4vg=;
  b=J3fwcTNuGnuqra3vmeUJIJ80UR9wHbFLZL2wQ3AduPXuopFqm951bJuc
   0S+PTcRlCNqv4G8N6XSW6w6tb4c4YmOiqrM7FVKTnUBiPgOhNFbfDcv2z
   wrh673gjh3KS+QjOBg/g6Q7hy5uvYDWg7TTLgduZZuvg54geG7w05iH5D
   SZbzILZtNFLTDGRvqR/j8odSuvH3yJy2k/FyVNHDftfndg67FP/0ELxka
   MEmV08Rsh8A+7VOvYE+5B6/J5Ou+bLT1LrU7AZ0APchrkVgx6+fTTKhMr
   SQIytAE8Xju+5UAG5WYDepd4zUT2o1O7PbgCWkpdzTMZtfs+/pg4gz3Z5
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kernel@axis.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <stefanha@redhat.com>,
        <sgarzare@redhat.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: [RFC PATCH 04/10] vhost: add support for kernel buffers
Date:   Wed, 29 Sep 2021 17:11:13 +0200
Message-ID: <20210929151119.14778-5-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210929151119.14778-1-vincent.whitchurch@axis.com>
References: <20210929151119.14778-1-vincent.whitchurch@axis.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle the virtio rings and buffers being placed in kernel memory
instead of userspace memory.  The software IOTLB support is used to
ensure that only permitted regions are accessed.

Note that this patch does not provide a way to actually request that
kernel memory be used, an API for that is added in a later patch.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 drivers/vhost/Kconfig |   6 ++
 drivers/vhost/vhost.c | 222 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  34 +++++++
 3 files changed, 257 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 587fbae06182..9e76ed485fe1 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -20,6 +20,12 @@ config VHOST
 	  This option is selected by any driver which needs to access
 	  the core of vhost.
 
+config VHOST_KERNEL
+	tristate
+	help
+	  This option is selected by any driver which needs to access the
+	  support for kernel buffers in vhost.
+
 menuconfig VHOST_MENU
 	bool "VHOST drivers"
 	default y
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ce81eee2a3fa..9354061ce75e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -49,6 +49,9 @@ enum {
 #define vhost_used_event(vq) ((__virtio16 __user *)&vq->user.avail->ring[vq->num])
 #define vhost_avail_event(vq) ((__virtio16 __user *)&vq->user.used->ring[vq->num])
 
+#define vhost_used_event_kern(vq) ((__virtio16 *)&vq->kern.avail->ring[vq->num])
+#define vhost_avail_event_kern(vq) ((__virtio16 *)&vq->kern.used->ring[vq->num])
+
 #ifdef CONFIG_VHOST_CROSS_ENDIAN_LEGACY
 static void vhost_disable_cross_endian(struct vhost_virtqueue *vq)
 {
@@ -482,6 +485,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iotlb = NULL;
 	dev->mm = NULL;
 	dev->worker = NULL;
+	dev->kernel = false;
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -785,6 +789,18 @@ static inline void __user *vhost_vq_meta_fetch(struct vhost_virtqueue *vq,
 	return (void __user *)(uintptr_t)(map->addr + addr - map->start);
 }
 
+static inline void *vhost_vq_meta_fetch_kern(struct vhost_virtqueue *vq,
+					       u64 addr, unsigned int size,
+					       int type)
+{
+	const struct vhost_iotlb_map *map = vq->meta_iotlb[type];
+
+	if (!map)
+		return NULL;
+
+	return (void *)(uintptr_t)(map->addr + addr - map->start);
+}
+
 /* Can we switch to this memory table? */
 /* Caller should have device mutex but not vq mutex */
 static bool memory_access_ok(struct vhost_dev *d, struct vhost_iotlb *umem,
@@ -849,6 +865,40 @@ static int vhost_copy_to_user(struct vhost_virtqueue *vq, void __user *to,
 	return ret;
 }
 
+static int vhost_copy_to_kern(struct vhost_virtqueue *vq, void *to,
+			      const void *from, unsigned int size)
+{
+	int ret;
+
+	/* This function should be called after iotlb
+	 * prefetch, which means we're sure that all vq
+	 * could be access through iotlb. So -EAGAIN should
+	 * not happen in this case.
+	 */
+	struct iov_iter t;
+	void *kaddr = vhost_vq_meta_fetch_kern(vq,
+			     (u64)(uintptr_t)to, size,
+			     VHOST_ADDR_USED);
+
+	if (kaddr) {
+		memcpy(kaddr, from, size);
+		return 0;
+	}
+
+	ret = translate_desc(vq, (u64)(uintptr_t)to, size, vq->iotlb_iov,
+			     ARRAY_SIZE(vq->iotlb_iov),
+			     VHOST_ACCESS_WO);
+	if (ret < 0)
+		goto out;
+	iov_iter_kvec(&t, WRITE, &vq->iotlb_iov->kvec, ret, size);
+	ret = copy_to_iter(from, size, &t);
+	if (ret == size)
+		ret = 0;
+
+out:
+	return ret;
+}
+
 static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 				void __user *from, unsigned size)
 {
@@ -889,6 +939,43 @@ static int vhost_copy_from_user(struct vhost_virtqueue *vq, void *to,
 	return ret;
 }
 
+static int vhost_copy_from_kern(struct vhost_virtqueue *vq, void *to,
+				void *from, unsigned int size)
+{
+	int ret;
+
+	/* This function should be called after iotlb
+	 * prefetch, which means we're sure that vq
+	 * could be access through iotlb. So -EAGAIN should
+	 * not happen in this case.
+	 */
+	void *kaddr = vhost_vq_meta_fetch_kern(vq,
+			     (u64)(uintptr_t)from, size,
+			     VHOST_ADDR_DESC);
+	struct iov_iter f;
+
+	if (kaddr) {
+		memcpy(to, kaddr, size);
+		return 0;
+	}
+
+	ret = translate_desc(vq, (u64)(uintptr_t)from, size, vq->iotlb_iov,
+			     ARRAY_SIZE(vq->iotlb_iov),
+			     VHOST_ACCESS_RO);
+	if (ret < 0) {
+		vq_err(vq, "IOTLB translation failure: kaddr %p size 0x%llx\n",
+		       from, (unsigned long long) size);
+		goto out;
+	}
+	iov_iter_kvec(&f, READ, &vq->iotlb_iov->kvec, ret, size);
+	ret = copy_from_iter(to, size, &f);
+	if (ret == size)
+		ret = 0;
+
+out:
+	return ret;
+}
+
 static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
 					  void __user *addr, unsigned int size,
 					  int type)
@@ -915,6 +1002,33 @@ static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
 	return vq->iotlb_iov->iovec.iov_base;
 }
 
+static void *__vhost_get_kern_slow(struct vhost_virtqueue *vq,
+					  void *addr, unsigned int size,
+					  int type)
+{
+	void *out;
+	int ret;
+
+	ret = translate_desc(vq, (u64)(uintptr_t)addr, size, vq->iotlb_iov,
+			     ARRAY_SIZE(vq->iotlb_iov),
+			     VHOST_ACCESS_RO);
+	if (ret < 0) {
+		vq_err(vq, "IOTLB translation failure: addr %p size 0x%llx\n",
+			addr, (unsigned long long) size);
+		return NULL;
+	}
+
+	if (ret != 1 || vq->iotlb_iov->kvec.iov_len != size) {
+		vq_err(vq, "Non atomic memory access: addr %p size 0x%llx\n",
+			addr, (unsigned long long) size);
+		return NULL;
+	}
+
+	out = vq->iotlb_iov->kvec.iov_base;
+
+	return out;
+}
+
 /* This function should be called after iotlb
  * prefetch, which means we're sure that vq
  * could be access through iotlb. So -EAGAIN should
@@ -932,6 +1046,18 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 	return __vhost_get_user_slow(vq, addr, size, type);
 }
 
+static inline void *__vhost_get_kern(struct vhost_virtqueue *vq,
+				     void *addr, unsigned int size,
+				     int type)
+{
+	void *uaddr = vhost_vq_meta_fetch_kern(vq, (u64)(uintptr_t)addr, size, type);
+
+	if (uaddr)
+		return uaddr;
+
+	return __vhost_get_kern_slow(vq, addr, size, type);
+}
+
 #define vhost_put_user(vq, x, ptr)		\
 ({ \
 	int ret; \
@@ -949,8 +1075,25 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 	ret; \
 })
 
+#define vhost_put_kern(vq, x, ptr)		\
+({ \
+	int ret = 0; \
+	__typeof__(ptr) to = \
+		(__typeof__(ptr)) __vhost_get_kern(vq, ptr,	\
+				  sizeof(*ptr), VHOST_ADDR_USED); \
+	if (to != NULL) \
+		*to = x;	\
+	else \
+		ret = -EFAULT;	\
+	ret; \
+})
+
 static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
 {
+	if (vhost_kernel(vq))
+		return vhost_put_kern(vq, cpu_to_vhost16(vq, vq->avail_idx),
+				      vhost_avail_event_kern(vq));
+
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->avail_idx),
 			      vhost_avail_event(vq));
 }
@@ -959,6 +1102,10 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
 				 struct vring_used_elem *head, int idx,
 				 int count)
 {
+	if (vhost_kernel(vq))
+		return vhost_copy_to_kern(vq, vq->kern.used->ring + idx, head,
+					  count * sizeof(*head));
+
 	return vhost_copy_to_user(vq, vq->user.used->ring + idx, head,
 				  count * sizeof(*head));
 }
@@ -966,6 +1113,10 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
 static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 
 {
+	if (vhost_kernel(vq))
+		return vhost_put_kern(vq, cpu_to_vhost16(vq, vq->used_flags),
+				      &vq->kern.used->flags);
+
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->used_flags),
 			      &vq->user.used->flags);
 }
@@ -973,6 +1124,10 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 
 {
+	if (vhost_kernel(vq))
+		return vhost_put_kern(vq, cpu_to_vhost16(vq, vq->last_used_idx),
+				      &vq->kern.used->idx);
+
 	return vhost_put_user(vq, cpu_to_vhost16(vq, vq->last_used_idx),
 			      &vq->user.used->idx);
 }
@@ -995,12 +1150,32 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 	ret; \
 })
 
+#define vhost_get_kern(vq, x, ptr, type)		\
+({ \
+	int ret = 0; \
+	__typeof__(ptr) from = \
+		(__typeof__(ptr)) __vhost_get_kern(vq, ptr, \
+						   sizeof(*ptr), \
+						   type); \
+	if (from != NULL) \
+		x = *from; \
+	else \
+		ret = -EFAULT; \
+	ret; \
+})
+
 #define vhost_get_avail(vq, x, ptr) \
 	vhost_get_user(vq, x, ptr, VHOST_ADDR_AVAIL)
 
 #define vhost_get_used(vq, x, ptr) \
 	vhost_get_user(vq, x, ptr, VHOST_ADDR_USED)
 
+#define vhost_get_avail_kern(vq, x, ptr) \
+	vhost_get_kern(vq, x, ptr, VHOST_ADDR_AVAIL)
+
+#define vhost_get_used_kern(vq, x, ptr) \
+	vhost_get_kern(vq, x, ptr, VHOST_ADDR_USED)
+
 static void vhost_dev_lock_vqs(struct vhost_dev *d)
 {
 	int i = 0;
@@ -1018,12 +1193,19 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
 				      __virtio16 *idx)
 {
+	if (vhost_kernel(vq))
+		return vhost_get_avail_kern(vq, *idx, &vq->kern.avail->idx);
+
 	return vhost_get_avail(vq, *idx, &vq->user.avail->idx);
 }
 
 static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
 				       __virtio16 *head, int idx)
 {
+	if (vhost_kernel(vq))
+		return vhost_get_avail_kern(vq, *head,
+				&vq->kern.avail->ring[idx & (vq->num - 1)]);
+
 	return vhost_get_avail(vq, *head,
 			       &vq->user.avail->ring[idx & (vq->num - 1)]);
 }
@@ -1031,24 +1213,36 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
 static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
 					__virtio16 *flags)
 {
+	if (vhost_kernel(vq))
+		return vhost_get_avail_kern(vq, *flags, &vq->kern.avail->flags);
+
 	return vhost_get_avail(vq, *flags, &vq->user.avail->flags);
 }
 
 static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
 				       __virtio16 *event)
 {
+	if (vhost_kernel(vq))
+		return vhost_get_avail_kern(vq, *event, vhost_used_event_kern(vq));
+
 	return vhost_get_avail(vq, *event, vhost_used_event(vq));
 }
 
 static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
 				     __virtio16 *idx)
 {
+	if (vhost_kernel(vq))
+		return vhost_get_used_kern(vq, *idx, &vq->kern.used->idx);
+
 	return vhost_get_used(vq, *idx, &vq->user.used->idx);
 }
 
 static inline int vhost_get_desc(struct vhost_virtqueue *vq,
 				 struct vring_desc *desc, int idx)
 {
+	if (vhost_kernel(vq))
+		return vhost_copy_from_kern(vq, desc, vq->kern.desc + idx, sizeof(*desc));
+
 	return vhost_copy_from_user(vq, desc, vq->user.desc + idx, sizeof(*desc));
 }
 
@@ -1909,6 +2103,9 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 	struct iovec *iov = &vq->log_iov->iovec;
 	int i, ret;
 
+	if (vhost_kernel(vq))
+		return 0;
+
 	if (!vq->iotlb)
 		return log_write(vq->log_base, vq->log_addr + used_offset, len);
 
@@ -1933,6 +2130,9 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 	struct iovec *iov = &viov->iovec;
 	int i, r;
 
+	if (vhost_kernel(vq))
+		return 0;
+
 	/* Make sure data written is seen before log. */
 	smp_wmb();
 
@@ -2041,11 +2241,11 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	const struct vhost_iotlb_map *map;
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
-	struct iovec *_iov;
 	u64 s = 0;
 	int ret = 0;
 
 	while ((u64)len > s) {
+		u64 mappedaddr;
 		u64 size;
 		if (unlikely(ret >= iov_size)) {
 			ret = -ENOBUFS;
@@ -2065,11 +2265,23 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		_iov = &iov->iovec + ret;
 		size = map->size - addr + map->start;
-		_iov->iov_len = min((u64)len - s, size);
-		_iov->iov_base = (void __user *)(unsigned long)
-				 (map->addr + addr - map->start);
+		mappedaddr = map->addr + addr - map->start;
+
+		if (vhost_kernel(vq)) {
+			struct kvec *_kvec;
+
+			_kvec = &iov->kvec + ret;
+			_kvec->iov_len = min((u64)len - s, size);
+			_kvec->iov_base = (void *)(unsigned long)mappedaddr;
+		} else {
+			struct iovec *_iov;
+
+			_iov = &iov->iovec + ret;
+			_iov->iov_len = min((u64)len - s, size);
+			_iov->iov_base = (void __user *)(unsigned long)mappedaddr;
+		}
+
 		s += size;
 		addr += size;
 		++ret;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 69aec724ef7f..ded1b39d7852 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -67,6 +67,7 @@ struct vhost_vring_call {
 
 struct vhost_iov {
 	union {
+		struct kvec kvec;
 		struct iovec iovec;
 	};
 };
@@ -83,6 +84,11 @@ struct vhost_virtqueue {
 		vring_avail_t __user *avail;
 		vring_used_t __user *used;
 	} user;
+	struct {
+		vring_desc_t *desc;
+		vring_avail_t *avail;
+		vring_used_t *used;
+	} kern;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
 	struct file *kick;
 	struct vhost_vring_call call_ctx;
@@ -169,18 +175,41 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
+	bool kernel;
 	int (*msg_handler)(struct vhost_dev *dev,
 			   struct vhost_iotlb_msg *msg);
 };
 
+static inline bool vhost_kernel(const struct vhost_virtqueue *vq)
+{
+	if (!IS_ENABLED(CONFIG_VHOST_KERNEL))
+		return false;
+
+	return vq->dev->kernel;
+}
+
 static inline size_t vhost_iov_length(const struct vhost_virtqueue *vq, struct vhost_iov *iov,
 				      unsigned long nr_segs)
 {
+	if (vhost_kernel(vq)) {
+		size_t ret = 0;
+		const struct kvec *kvec = &iov->kvec;
+		unsigned int seg;
+
+		for (seg = 0; seg < nr_segs; seg++)
+			ret += kvec[seg].iov_len;
+
+		return ret;
+	};
+
 	return iov_length(&iov->iovec, nr_segs);
 }
 
 static inline size_t vhost_iov_len(const struct vhost_virtqueue *vq, struct vhost_iov *iov)
 {
+	if (vhost_kernel(vq))
+		return iov->kvec.iov_len;
+
 	return iov->iovec.iov_len;
 }
 
@@ -190,6 +219,11 @@ static inline void vhost_iov_iter_init(const struct vhost_virtqueue *vq,
 				       unsigned long nr_segs,
 				       size_t count)
 {
+	if (vhost_kernel(vq)) {
+		iov_iter_kvec(i, direction, &iov->kvec, nr_segs, count);
+		return;
+	}
+
 	iov_iter_init(i, direction, &iov->iovec, nr_segs, count);
 }
 
-- 
2.28.0

