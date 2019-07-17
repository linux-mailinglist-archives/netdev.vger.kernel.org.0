Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58CA6BAC4
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387476AbfGQKyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:54:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733198AbfGQKyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:54:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B70EB30842A0;
        Wed, 17 Jul 2019 10:54:14 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B2E110246E1;
        Wed, 17 Jul 2019 10:54:11 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 13/15] vhost: packed ring support
Date:   Wed, 17 Jul 2019 06:52:53 -0400
Message-Id: <20190717105255.63488-14-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 17 Jul 2019 10:54:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces basic support for packed ring. The idea behinds
packed ring is to use a single descriptor ring instead of three
different rings (avail, used and descriptor). This could help to
reduce the cache contention and PCI transactions. So it was designed
to help for the performance for both software implementation and
hardware implementation.

The implementation was straightforward, packed version of vhost core
(whose name has a packed suffix) helpers were introduced and previous
helpers were renamed with a split suffix. Then the exported helpers
can just do a switch to go to the correct internal helpers.

The event suppression (device area and driver area) were not
implemented. It will be done on top with another patch.

For more information of packed ring, please refer Virtio spec.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   |   6 +-
 drivers/vhost/vhost.c | 980 ++++++++++++++++++++++++++++++++++++++----
 drivers/vhost/vhost.h |  24 +-
 3 files changed, 925 insertions(+), 85 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7c2f320930c7..ef79446b42f1 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -799,7 +799,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				goto done;
 			} else if (unlikely(err != -ENOSPC)) {
 				vhost_tx_batch(net, nvq, sock, &msg);
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, &used);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -820,7 +820,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
-			vhost_discard_vq_desc(vq, 1);
+			vhost_discard_vq_desc(vq, &used);
 			vhost_net_enable_vq(net, vq);
 			break;
 		}
@@ -919,7 +919,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 				vhost_net_ubuf_put(ubufs);
 			nvq->upend_idx = ((unsigned int)nvq->upend_idx - 1)
 					 % UIO_MAXIOV;
-			vhost_discard_vq_desc(vq, 1);
+			vhost_discard_vq_desc(vq, &used);
 			vhost_net_enable_vq(net, vq);
 			break;
 		}
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3fa1adf2cb90..a7d24b9d5204 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -479,6 +479,9 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vhost_reset_is_le(vq);
 	vhost_disable_cross_endian(vq);
 	vq->busyloop_timeout = 0;
+	vq->last_used_wrap_counter = true;
+	vq->last_avail_wrap_counter = true;
+	vq->avail_wrap_counter = true;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
 	vq->invalidate_count = 0;
@@ -551,7 +554,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 					     GFP_KERNEL);
 		vq->log = kmalloc_array(dev->iov_limit, sizeof(*vq->log),
 					GFP_KERNEL);
-		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
+		vq->heads = kmalloc_array(dev->iov_limit,
+					  sizeof(struct vhost_used_elem),
 					  GFP_KERNEL);
 		if (!vq->indirect || !vq->log || !vq->heads)
 			goto err_nomem;
@@ -1406,8 +1410,8 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
 	return vhost_get_used(vq, *idx, &vq->used->idx);
 }
 
-static inline int vhost_get_desc(struct vhost_virtqueue *vq,
-				 struct vring_desc *desc, int idx)
+static inline int vhost_get_desc_split(struct vhost_virtqueue *vq,
+				       struct vring_desc *desc, int idx)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
 	struct vring_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
@@ -1422,6 +1426,104 @@ static inline int vhost_get_desc(struct vhost_virtqueue *vq,
 	return vhost_copy_from_user(vq, desc, vq->desc + idx, sizeof(*desc));
 }
 
+static inline int vhost_get_desc_packed(struct vhost_virtqueue *vq,
+					struct vring_packed_desc *desc, int idx)
+{
+	int ret;
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
+
+	if (likely(d)) {
+		d += idx;
+
+		desc->flags = d->flags;
+
+		/* Make sure flags is seen before the rest fields of
+		 * descriptor.
+		 */
+		smp_rmb();
+
+		desc->addr = d->addr;
+		desc->len = d->len;
+		desc->id = d->id;
+
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+
+	ret = vhost_copy_from_user(vq, &desc->flags,
+				   &(vq->desc_packed + idx)->flags,
+				   sizeof(desc->flags));
+	if (unlikely(ret))
+		return ret;
+
+	/* Make sure flags is seen before the rest fields of
+	 * descriptor.
+	 */
+	smp_rmb();
+
+	return vhost_copy_from_user(vq, desc, vq->desc_packed + idx,
+				    offsetof(struct vring_packed_desc, flags));
+}
+
+static inline int vhost_put_desc_packed(struct vhost_virtqueue *vq,
+					struct vring_packed_desc *desc, int idx)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
+
+	if (likely(d)) {
+		d += idx;
+		d->id = desc->id;
+		d->flags = desc->flags;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+
+	return vhost_copy_to_user(vq, vq->desc_packed + idx, desc,
+				  sizeof(*desc));
+}
+
+static inline int vhost_get_desc_flags(struct vhost_virtqueue *vq,
+				       __virtio16 *flags, int idx)
+{
+	struct vring_packed_desc __user *desc;
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
+
+	if (likely(d)) {
+		d += idx;
+		*flags = d->flags;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+
+	desc = vq->desc_packed + idx;
+	return vhost_get_user(vq, *flags, &desc->flags, VHOST_ADDR_DESC);
+}
+
+static inline int vhost_put_desc_flags(struct vhost_virtqueue *vq,
+				       __virtio16 *flags, int idx)
+{
+	struct vring_packed_desc __user *desc;
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
+
+	if (likely(d)) {
+		d += idx;
+		d->flags = *flags;
+		vhost_put_meta_ptr();
+		return 0;
+	}
+#endif
+
+	desc = vq->desc_packed + idx;
+	return vhost_put_user(vq, *flags, &desc->flags, VHOST_ADDR_DESC);
+}
+
 static int vhost_new_umem_range(struct vhost_umem *umem,
 				u64 start, u64 size, u64 end,
 				u64 userspace_addr, int perm)
@@ -1701,17 +1803,44 @@ static int vhost_iotlb_miss(struct vhost_virtqueue *vq, u64 iova, int access)
 	return 0;
 }
 
-static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
-			 struct vring_desc __user *desc,
-			 struct vring_avail __user *avail,
-			 struct vring_used __user *used)
+static int vq_access_ok_packed(struct vhost_virtqueue *vq, unsigned int num,
+			       struct vring_desc __user *desc,
+			       struct vring_avail __user *avail,
+			       struct vring_used __user *used)
+{
+	struct vring_packed_desc *packed = (struct vring_packed_desc *)desc;
+
+	/* TODO: check device area and driver area */
+	return access_ok(packed, num * sizeof(*packed)) &&
+	       access_ok(packed, num * sizeof(*packed));
+}
 
+static int vq_access_ok_split(struct vhost_virtqueue *vq, unsigned int num,
+			      struct vring_desc __user *desc,
+			      struct vring_avail __user *avail,
+			      struct vring_used __user *used)
 {
 	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
 	       access_ok(avail, vhost_get_avail_size(vq, num)) &&
 	       access_ok(used, vhost_get_used_size(vq, num));
 }
 
+#define VHOST_ALTERNATIVE(func, vq, ...)		   \
+do {							   \
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))   \
+		return func##_##packed(vq, ##__VA_ARGS__); \
+	else						   \
+		return func##_##split(vq, ##__VA_ARGS__);  \
+} while (0)
+
+static int vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
+			struct vring_desc __user *desc,
+			struct vring_avail __user *avail,
+			struct vring_used __user *used)
+{
+	VHOST_ALTERNATIVE(vq_access_ok, vq, num, desc, avail, used);
+}
+
 static void vhost_vq_meta_update(struct vhost_virtqueue *vq,
 				 const struct vhost_umem_node *node,
 				 int type)
@@ -1786,13 +1915,18 @@ int vq_meta_prefetch(struct vhost_virtqueue *vq)
 		return 1;
 	}
 
-	return iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->desc,
-			       vhost_get_desc_size(vq, num), VHOST_ADDR_DESC) &&
-	       iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->avail,
+	return iotlb_access_ok(vq, VHOST_ACCESS_RO,
+			       (u64)(uintptr_t)vq->desc,
+			       vhost_get_desc_size(vq, num),
+			       VHOST_ADDR_DESC) &&
+	       iotlb_access_ok(vq, VHOST_ACCESS_RO,
+			       (u64)(uintptr_t)vq->avail,
 			       vhost_get_avail_size(vq, num),
 			       VHOST_ADDR_AVAIL) &&
-	       iotlb_access_ok(vq, VHOST_ACCESS_WO, (u64)(uintptr_t)vq->used,
-			       vhost_get_used_size(vq, num), VHOST_ADDR_USED);
+	       iotlb_access_ok(vq, VHOST_ACCESS_WO,
+			       (u64)(uintptr_t)vq->used,
+			       vhost_get_used_size(vq, num),
+			       VHOST_ADDR_USED);
 }
 EXPORT_SYMBOL_GPL(vq_meta_prefetch);
 
@@ -2067,18 +2201,33 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			r = -EFAULT;
 			break;
 		}
-		if (s.num > 0xffff) {
-			r = -EINVAL;
-			break;
+		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
+			vq->last_used_wrap_counter = s.num & (1 << 31);
+			vq->last_used_idx = s.num >> 16 & ~(1 << 15);
+			s.num >>= 16;
+			vq->last_avail_wrap_counter = s.num & (1 << 15);
+			vq->last_avail_idx = s.num & ~(1 << 15);
+		} else {
+			if (s.num > 0xffff) {
+				r = -EINVAL;
+				break;
+			}
+			vq->last_avail_idx = s.num;
 		}
-		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
+		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+			vq->avail_wrap_counter = vq->last_avail_wrap_counter;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
 		s.num = vq->last_avail_idx;
-		if (copy_to_user(argp, &s, sizeof s))
+		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
+			s.num |= vq->last_avail_wrap_counter << 15;
+			s.num |= vq->last_used_idx << 16;
+			s.num |= vq->last_used_wrap_counter << 31;
+		}
+		if (copy_to_user(argp, &s, sizeof(s)))
 			r = -EFAULT;
 		break;
 	case VHOST_SET_VRING_KICK:
@@ -2375,6 +2524,48 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
 	return 0;
 }
 
+static int __log_write(struct vhost_virtqueue *vq, void *addr, int size)
+{
+	struct iovec iov[64];
+	int ret, i;
+
+	if (!size)
+		return 0;
+
+	if (!vq->iotlb)
+		return log_write_hva(vq, (uintptr_t)addr, size);
+
+	ret = translate_desc(vq, (uintptr_t)addr, size, iov, 64,
+			     VHOST_ACCESS_WO);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ret; i++) {
+		ret = log_write_hva(vq,	(uintptr_t)iov[i].iov_base,
+				    iov[i].iov_len);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int log_desc(struct vhost_virtqueue *vq, unsigned int idx,
+		    unsigned int count)
+{
+	int ret, c = min(count, vq->num - idx);
+
+	ret = __log_write(vq, vq->desc_packed + idx,
+			  c * sizeof(*vq->desc_packed));
+	if (ret < 0)
+		return ret;
+
+	ret = __log_write(vq, vq->desc_packed,
+			  (count - c) * sizeof(*vq->desc_packed));
+
+	return ret;
+}
+
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 		    unsigned int log_num, u64 len, struct iovec *iov, int count)
 {
@@ -2458,6 +2649,9 @@ int vhost_vq_init_access(struct vhost_virtqueue *vq)
 
 	vhost_init_is_le(vq);
 
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+		return 0;
+
 	r = vhost_update_used_flags(vq);
 	if (r)
 		goto err;
@@ -2531,7 +2725,8 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 /* Each buffer in the virtqueues is actually a chain of descriptors.  This
  * function returns the next descriptor in the chain,
  * or -1U if we're at the end. */
-static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
+static unsigned next_desc_split(struct vhost_virtqueue *vq,
+				struct vring_desc *desc)
 {
 	unsigned int next;
 
@@ -2544,11 +2739,17 @@ static unsigned next_desc(struct vhost_virtqueue *vq, struct vring_desc *desc)
 	return next;
 }
 
-static int get_indirect(struct vhost_virtqueue *vq,
-			struct iovec iov[], unsigned int iov_size,
-			unsigned int *out_num, unsigned int *in_num,
-			struct vhost_log *log, unsigned int *log_num,
-			struct vring_desc *indirect)
+static unsigned int next_desc_packed(struct vhost_virtqueue *vq,
+				     struct vring_packed_desc *desc)
+{
+	return desc->flags & cpu_to_vhost16(vq, VRING_DESC_F_NEXT);
+}
+
+static int get_indirect_split(struct vhost_virtqueue *vq,
+			      struct iovec iov[], unsigned int iov_size,
+			      unsigned int *out_num, unsigned int *in_num,
+			      struct vhost_log *log, unsigned int *log_num,
+			      struct vring_desc *indirect)
 {
 	struct vring_desc desc;
 	unsigned int i = 0, count, found = 0;
@@ -2638,23 +2839,291 @@ static int get_indirect(struct vhost_virtqueue *vq,
 			}
 			*out_num += ret;
 		}
-	} while ((i = next_desc(vq, &desc)) != -1);
+	} while ((i = next_desc_split(vq, &desc)) != -1);
 	return 0;
 }
 
-/* This looks in the virtqueue and for the first available buffer, and converts
- * it to an iovec for convenient access.  Since descriptors consist of some
- * number of output then some number of input descriptors, it's actually two
- * iovecs, but we pack them into one and note how many of each there were.
- *
- * This function returns the descriptor number found, or vq->num (which is
- * never a valid descriptor number) if none was found.  A negative code is
- * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct vhost_used_elem *used,
-		      struct iovec iov[], unsigned int iov_size,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num)
+static int get_indirect_packed(struct vhost_virtqueue *vq,
+			       struct iovec iov[], unsigned int iov_size,
+			       unsigned int *out_num, unsigned int *in_num,
+			       struct vhost_log *log, unsigned int *log_num,
+			       struct vring_packed_desc *indirect)
+{
+	struct vring_packed_desc desc;
+	unsigned int i, count, found = 0;
+	u32 len = vhost32_to_cpu(vq, indirect->len);
+	struct iov_iter from;
+	int ret, access;
+
+	/* Sanity check */
+	if (unlikely(len % sizeof(desc))) {
+		vq_err(vq, "Invalid length in indirect descriptor: len 0x%llx not multiple of 0x%zx\n",
+		       (unsigned long long)len,
+		       sizeof(desc));
+		return -EINVAL;
+	}
+
+	ret = translate_desc(vq, vhost64_to_cpu(vq, indirect->addr),
+			     len, vq->indirect,
+			     UIO_MAXIOV, VHOST_ACCESS_RO);
+	if (unlikely(ret < 0)) {
+		if (ret != -EAGAIN)
+			vq_err(vq, "Translation failure %d in indirect.\n",
+			       ret);
+		return ret;
+	}
+	iov_iter_init(&from, READ, vq->indirect, ret, len);
+
+	/* We will use the result as an address to read from, so most
+	 * architectures only need a compiler barrier here.
+	 */
+	read_barrier_depends();
+
+	count = len / sizeof(desc);
+	/* Buffers are chained via a 16 bit next field, so
+	 * we can have at most 2^16 of these.
+	 */
+	if (unlikely(count > USHRT_MAX + 1)) {
+		vq_err(vq, "Indirect buffer length too big: %d\n",
+		       indirect->len);
+		return -E2BIG;
+	}
+
+	for (i = 0; i < count; i++) {
+		unsigned int iov_count = *in_num + *out_num;
+
+		if (unlikely(++found > count)) {
+			vq_err(vq, "Loop detected: last one at %u indirect size %u\n",
+			       i, count);
+			return -EINVAL;
+		}
+		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc),
+						  &from))) {
+			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)vhost64_to_cpu(vq, indirect->addr)
+				  + i * sizeof(desc));
+			return -EINVAL;
+		}
+		if (unlikely(desc.flags &
+			     cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) {
+			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)vhost64_to_cpu(vq, indirect->addr)
+				  + i * sizeof(desc));
+			return -EINVAL;
+		}
+
+		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
+			access = VHOST_ACCESS_WO;
+		else
+			access = VHOST_ACCESS_RO;
+
+		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
+				     vhost32_to_cpu(vq, desc.len),
+				     iov + iov_count,
+				     iov_size - iov_count, access);
+		if (unlikely(ret < 0)) {
+			if (ret != -EAGAIN)
+				vq_err(vq, "Translation failure %d indirect idx %d\n",
+				       ret, i);
+			return ret;
+		}
+		/* If this is an input descriptor, increment that count. */
+		if (access == VHOST_ACCESS_WO) {
+			*in_num += ret;
+			if (unlikely(log)) {
+				log[*log_num].addr =
+					vhost64_to_cpu(vq, desc.addr);
+				log[*log_num].len =
+					vhost32_to_cpu(vq, desc.len);
+				++*log_num;
+			}
+		} else {
+			/* If it's an output descriptor, they're all supposed
+			 * to come before any input descriptors.
+			 */
+			if (unlikely(*in_num)) {
+				vq_err(vq, "Indirect descriptor has out after in: idx %d\n",
+				       i);
+				return -EINVAL;
+			}
+			*out_num += ret;
+		}
+	}
+
+	return 0;
+}
+
+#define VRING_DESC_F_AVAIL (1 << VRING_PACKED_DESC_F_AVAIL)
+#define VRING_DESC_F_USED  (1 << VRING_PACKED_DESC_F_USED)
+
+static bool desc_is_avail(struct vhost_virtqueue *vq, bool wrap_counter,
+			  __virtio16 flags)
+{
+	bool avail = flags & cpu_to_vhost16(vq, VRING_DESC_F_AVAIL);
+
+	return avail == wrap_counter;
+}
+
+static __virtio16 get_desc_flags(struct vhost_virtqueue *vq,
+				 bool wrap_counter, bool write)
+{
+	__virtio16 flags = 0;
+
+	if (wrap_counter) {
+		flags |= cpu_to_vhost16(vq, VRING_DESC_F_AVAIL);
+		flags |= cpu_to_vhost16(vq, VRING_DESC_F_USED);
+	} else {
+		flags &= ~cpu_to_vhost16(vq, VRING_DESC_F_AVAIL);
+		flags &= ~cpu_to_vhost16(vq, VRING_DESC_F_USED);
+	}
+
+	if (write)
+		flags |= cpu_to_vhost16(vq, VRING_DESC_F_WRITE);
+
+	return flags;
+}
+
+static bool vhost_vring_packed_need_event(struct vhost_virtqueue *vq,
+					  bool wrap, __u16 off_wrap, __u16 new,
+					  __u16 old)
+{
+	int off = off_wrap & ~(1 << 15);
+
+	if (wrap != off_wrap >> 15)
+		off -= vq->num;
+
+	return vring_need_event(off, new, old);
+}
+
+static int vhost_get_vq_desc_packed(struct vhost_virtqueue *vq,
+				    struct vhost_used_elem *used,
+				    struct iovec iov[], unsigned int iov_size,
+				    unsigned int *out_num, unsigned int *in_num,
+				    struct vhost_log *log,
+				    unsigned int *log_num)
+{
+	struct vring_packed_desc desc;
+	struct vring_packed_used_elem *elem = &used->packed_elem;
+	int ret, access;
+	u16 last_avail_idx = vq->last_avail_idx;
+	u16 off_wrap = vq->avail_idx | (vq->avail_wrap_counter << 15);
+
+	/* When we start there are none of either input nor output. */
+	*out_num = *in_num = 0;
+	if (unlikely(log))
+		*log_num = 0;
+
+	elem->count = 0;
+
+	do {
+		unsigned int iov_count = *in_num + *out_num;
+
+		ret = vhost_get_desc_packed(vq, &desc, vq->last_avail_idx);
+		if (unlikely(ret)) {
+			vq_err(vq, "Failed to get flags: idx %d\n",
+			       vq->last_avail_idx);
+			return -EFAULT;
+		}
+
+		if (!desc_is_avail(vq, vq->last_avail_wrap_counter,
+				   desc.flags)) {
+			/* If there's nothing new since last we looked, return
+			 * invalid.
+			 */
+			if (!elem->count)
+				return -ENOSPC;
+			vq_err(vq, "Unexpected unavail descriptor: idx %d\n",
+			       vq->last_avail_idx);
+			return -EFAULT;
+		}
+
+		elem->id = desc.id;
+
+		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
+			ret = get_indirect_packed(vq, iov, iov_size,
+						  out_num, in_num, log,
+						  log_num, &desc);
+			if (unlikely(ret < 0)) {
+				if (ret != -EAGAIN)
+					vq_err(vq, "Failure detected in indirect descriptor at idx %d\n",
+					       desc.id);
+				return ret;
+			}
+			goto next;
+		}
+
+		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_WRITE))
+			access = VHOST_ACCESS_WO;
+		else
+			access = VHOST_ACCESS_RO;
+		ret = translate_desc(vq, vhost64_to_cpu(vq, desc.addr),
+				     vhost32_to_cpu(vq, desc.len),
+				     iov + iov_count, iov_size - iov_count,
+				     access);
+		if (unlikely(ret < 0)) {
+			if (ret != -EAGAIN)
+				vq_err(vq, "Translation failure %d idx %d\n",
+				       ret, desc.id);
+			return ret;
+		}
+
+		if (access == VHOST_ACCESS_WO) {
+			/* If this is an input descriptor,
+			 * increment that count.
+			 */
+			*in_num += ret;
+			if (unlikely(log)) {
+				log[*log_num].addr =
+					vhost64_to_cpu(vq, desc.addr);
+				log[*log_num].len =
+					vhost32_to_cpu(vq, desc.len);
+				++*log_num;
+			}
+		} else {
+			/* If it's an output descriptor, they're all supposed
+			 * to come before any input descriptors.
+			 */
+			if (unlikely(*in_num)) {
+				vq_err(vq, "Desc out after in: idx %d\n",
+				       desc.id);
+				return -EINVAL;
+			}
+			*out_num += ret;
+		}
+
+next:
+		if (unlikely(++elem->count > vq->num)) {
+			vq_err(vq, "Loop detected: last one at %u vq size %u head %u\n",
+			       desc.id, vq->num, elem->id);
+			return -EINVAL;
+		}
+		if (unlikely(++vq->last_avail_idx >= vq->num)) {
+			vq->last_avail_idx = 0;
+			vq->last_avail_wrap_counter ^= 1;
+		}
+	/* If this descriptor says it doesn't chain, we're done. */
+	} while (next_desc_packed(vq, &desc));
+
+	/* Packed ring does not have avail idx which means we need to
+	 * track it by our own. The check here is to make sure it
+	 * grows monotonically.
+	 */
+	if (likely(vhost_vring_packed_need_event(vq,
+						 vq->last_avail_wrap_counter,
+						 off_wrap, vq->last_avail_idx,
+						 last_avail_idx))) {
+		vq->avail_idx = vq->last_avail_idx;
+		vq->avail_wrap_counter = vq->last_avail_wrap_counter;
+	}
+
+	return 0;
+}
+
+static int vhost_get_vq_desc_split(struct vhost_virtqueue *vq,
+				   struct vhost_used_elem *used,
+				   struct iovec iov[], unsigned int iov_size,
+				   unsigned int *out_num, unsigned int *in_num,
+				   struct vhost_log *log, unsigned int *log_num)
 {
 	struct vring_desc desc;
 	unsigned int i, head, found = 0;
@@ -2730,16 +3199,16 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			       i, vq->num, head);
 			return -EINVAL;
 		}
-		ret = vhost_get_desc(vq, &desc, i);
+		ret = vhost_get_desc_split(vq, &desc, i);
 		if (unlikely(ret)) {
 			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
 			       i, vq->desc + i);
 			return -EFAULT;
 		}
 		if (desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT)) {
-			ret = get_indirect(vq, iov, iov_size,
-					   out_num, in_num,
-					   log, log_num, &desc);
+			ret = get_indirect_split(vq, iov, iov_size,
+						 out_num, in_num,
+						 log, log_num, &desc);
 			if (unlikely(ret < 0)) {
 				if (ret != -EAGAIN)
 					vq_err(vq, "Failure detected "
@@ -2781,7 +3250,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			}
 			*out_num += ret;
 		}
-	} while ((i = next_desc(vq, &desc)) != -1);
+	} while ((i = next_desc_split(vq, &desc)) != -1);
 
 	/* On success, increment avail index. */
 	vq->last_avail_idx++;
@@ -2791,50 +3260,134 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 	return 0;
 }
+
+/* This looks in the virtqueue and for the first available buffer, and converts
+ * it to an iovec for convenient access.  Since descriptors consist of some
+ * number of output then some number of input descriptors, it's actually two
+ * iovecs, but we pack them into one and note how many of each there were.
+ *
+ * This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error.
+ */
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct vhost_used_elem *used,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	VHOST_ALTERNATIVE(vhost_get_vq_desc, vq, used, iov,
+			  iov_size, out_num, in_num, log, log_num);
+}
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
+static void vhost_set_used_len_split(struct vhost_virtqueue *vq,
+				     struct vhost_used_elem *used, int len)
+{
+	struct vring_used_elem *elem = &used->elem;
+
+	elem->len = cpu_to_vhost32(vq, len);
+}
+
+static void vhost_set_used_len_packed(struct vhost_virtqueue *vq,
+				      struct vhost_used_elem *used, int len)
+{
+	struct vring_packed_used_elem *elem = &used->packed_elem;
+
+	elem->len = cpu_to_vhost32(vq, len);
+}
+
 void vhost_set_used_len(struct vhost_virtqueue *vq,
 			struct vhost_used_elem *used, int len)
 {
-	used->elem.len = cpu_to_vhost32(vq, len);
+	VHOST_ALTERNATIVE(vhost_set_used_len, vq, used, len);
 }
 EXPORT_SYMBOL_GPL(vhost_set_used_len);
 
+__virtio32 vhost_get_used_len_split(struct vhost_virtqueue *vq,
+				    struct vhost_used_elem *used)
+{
+	return vhost32_to_cpu(vq, used->elem.len);
+}
+
+__virtio32 vhost_get_used_len_packed(struct vhost_virtqueue *vq,
+				    struct vhost_used_elem *used)
+{
+	return vhost32_to_cpu(vq, used->packed_elem.len);
+}
+
 __virtio32 vhost_get_used_len(struct vhost_virtqueue *vq,
 			      struct vhost_used_elem *used)
 {
-	return vhost32_to_cpu(vq, used->elem.len);
+	VHOST_ALTERNATIVE(vhost_get_used_len, vq, used);
 }
 EXPORT_SYMBOL_GPL(vhost_get_used_len);
 
-static void vhost_withdraw_shadow_used(struct vhost_virtqueue *vq, int count)
+static void vhost_withdraw_shadow_used(struct vhost_virtqueue *vq,
+				       int count)
 {
 	BUG_ON(count > vq->nheads);
 	vq->nheads -= count;
 }
 
+static void vhost_discard_vq_desc_packed(struct vhost_virtqueue *vq,
+					 struct vring_packed_used_elem *elem,
+					 int headcount)
+{
+	int i;
+
+	for (i = 0; i < headcount; i++) {
+		vq->last_avail_idx -= elem[i].count;
+		if (vq->last_avail_idx >= vq->num) {
+			vq->last_avail_wrap_counter ^= 1;
+			vq->last_avail_idx += vq->num;
+		}
+	}
+}
+
+static void vhost_discard_vq_desc_split(struct vhost_virtqueue *vq, int n)
+{
+	vq->last_avail_idx -= n;
+}
+
+static void vhost_discard_shadow_used_packed(struct vhost_virtqueue *vq, int n)
+{
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	vhost_discard_vq_desc_packed(vq, elem + vq->nheads - n, n);
+	vhost_withdraw_shadow_used(vq, n);
+}
+
+static void vhost_discard_shadow_used_split(struct vhost_virtqueue *vq, int n)
+{
+	vhost_withdraw_shadow_used(vq, n);
+	vhost_discard_vq_desc_split(vq, n);
+}
+
 /* Reverse the effect of vhost_get_vq_desc and
  * vhost_add_shadow_used. Useful for error handleing
  */
 void vhost_discard_shadow_used(struct vhost_virtqueue *vq, int n)
 {
-	vhost_withdraw_shadow_used(vq, n);
-	vhost_discard_vq_desc(vq, n);
+	VHOST_ALTERNATIVE(vhost_discard_shadow_used, vq, n);
 }
 EXPORT_SYMBOL_GPL(vhost_discard_shadow_used);
 
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq,
+			   struct vhost_used_elem *used)
 {
-	vq->last_avail_idx -= n;
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+		vhost_discard_vq_desc_packed(vq, &used->packed_elem, 1);
+	else
+		vhost_discard_vq_desc_split(vq, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
-static int __vhost_add_used_n(struct vhost_virtqueue *vq,
-			    struct vhost_used_elem *shadow,
-			    unsigned count)
+static int __vhost_add_used_n_split(struct vhost_virtqueue *vq,
+				    struct vring_used_elem *heads,
+				    unsigned count)
 {
-	struct vring_used_elem *heads = (struct vring_used_elem *)shadow;
 	struct vring_used_elem __user *used;
 	u16 old, new;
 	int start;
@@ -2863,59 +3416,241 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
+static void vhost_set_zc_used_len_split(struct vhost_virtqueue *vq,
+					int idx, int len)
+{
+	struct vring_used_elem *heads = vq->heads;
+
+	heads[idx].len = len;
+}
+
+static void vhost_set_zc_used_len_packed(struct vhost_virtqueue *vq,
+					 int idx, int len)
+{
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	elem[idx].len = len;
+}
+
 void vhost_set_zc_used_len(struct vhost_virtqueue *vq,
-			       int idx, int len)
+			   int idx, int len)
 {
-	vq->heads[idx].elem.len = len;
+	VHOST_ALTERNATIVE(vhost_set_zc_used_len, vq, idx, len);
 }
 EXPORT_SYMBOL_GPL(vhost_set_zc_used_len);
 
-int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx)
+void vhost_add_shadow_used_split(struct vhost_virtqueue *vq,
+				 struct vhost_used_elem *used, int len)
 {
-	return vq->heads[idx].elem.len;
+	struct vring_used_elem *heads = vq->heads;
+
+	heads[vq->nheads].id = used->elem.id;
+	heads[vq->nheads].len = len;
+	++vq->nheads;
 }
-EXPORT_SYMBOL_GPL(vhost_get_zc_used_len);
 
-void vhost_set_zc_used(struct vhost_virtqueue *vq, int idx,
-		       struct vhost_used_elem *elem, int len)
+void vhost_add_shadow_used_packed(struct vhost_virtqueue *vq,
+				  struct vhost_used_elem *used, int len)
 {
-	vq->heads[idx] = *elem;
-	vhost_set_zc_used_len(vq, idx, len);
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	elem[vq->nheads].id = used->packed_elem.id;
+	elem[vq->nheads].count = used->packed_elem.count;
+	elem[vq->nheads].len = len;
+	++vq->nheads;
 }
-EXPORT_SYMBOL_GPL(vhost_set_zc_used);
 
 void vhost_add_shadow_used(struct vhost_virtqueue *vq,
-			   struct vhost_used_elem *elem, int len)
+			   struct vhost_used_elem *used, int len)
 {
-	vhost_set_zc_used(vq, vq->nheads, elem, len);
-	++vq->nheads;
+	VHOST_ALTERNATIVE(vhost_add_shadow_used, vq, used, len);
 }
 EXPORT_SYMBOL_GPL(vhost_add_shadow_used);
 
+int vhost_get_zc_used_len_split(struct vhost_virtqueue *vq, int idx)
+{
+	struct vring_used_elem *heads = vq->heads;
+
+	return heads[idx].len;
+}
+
+int vhost_get_zc_used_len_packed(struct vhost_virtqueue *vq, int idx)
+{
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	return elem[idx].len;
+}
+
+int vhost_get_zc_used_len(struct vhost_virtqueue *vq, int idx)
+{
+	VHOST_ALTERNATIVE(vhost_get_zc_used_len, vq, idx);
+}
+EXPORT_SYMBOL_GPL(vhost_get_zc_used_len);
+
+void vhost_set_zc_used_split(struct vhost_virtqueue *vq, int idx,
+			     struct vhost_used_elem *used, int len)
+{
+	struct vring_used_elem *heads = vq->heads;
+
+	heads[idx] = used->elem;
+	vhost_set_zc_used_len_split(vq, idx, len);
+}
+
+void vhost_set_zc_used_packed(struct vhost_virtqueue *vq, int idx,
+			      struct vhost_used_elem *used, int len)
+{
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	elem[idx].id = used->packed_elem.id;
+	elem[idx].count = used->packed_elem.count;
+	vhost_set_zc_used_len_packed(vq, idx, len);
+}
+
+void vhost_set_zc_used(struct vhost_virtqueue *vq, int idx,
+		       struct vhost_used_elem *used, int len)
+{
+	VHOST_ALTERNATIVE(vhost_set_zc_used, vq, idx, used, len);
+}
+EXPORT_SYMBOL_GPL(vhost_set_zc_used);
+
 int vhost_get_shadow_used_count(struct vhost_virtqueue *vq)
 {
 	return vq->nheads;
 }
 EXPORT_SYMBOL_GPL(vhost_get_shadow_used_count);
 
+static int __vhost_add_used_n_packed(struct vhost_virtqueue *vq,
+				     struct vring_packed_used_elem *elem,
+				     unsigned int count)
+{
+	int i, ret;
+	__virtio16 head_flags = 0;
+	struct vring_packed_desc desc;
+	unsigned int used_idx = vq->last_used_idx;
+	bool wrap_counter = vq->last_used_wrap_counter;
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_packed_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
+
+	if (likely(d)) {
+		used_idx += elem[0].count;
+		if (unlikely(used_idx >= vq->num)) {
+			used_idx -= vq->num;
+			wrap_counter ^= 1;
+		}
+
+		for (i = 1; i < count; i++) {
+			d[used_idx].flags = get_desc_flags(vq, wrap_counter,
+							   elem[i].len);
+			d[used_idx].id = elem[i].id;
+			d[used_idx].len = elem[i].len;
+			used_idx += elem[i].count;
+			if (unlikely(used_idx >= vq->num)) {
+				used_idx -= vq->num;
+				wrap_counter ^= 1;
+			}
+		}
+
+		d[vq->last_used_idx].id = elem[0].id;
+		d[vq->last_used_idx].len = elem[0].len;
+		/* Make sure descriptor id and len is written before
+		 * flags for the first used buffer.
+		 */
+		smp_wmb();
+		head_flags = get_desc_flags(vq,	vq->last_used_wrap_counter,
+					    elem[0].len);
+		d[vq->last_used_idx].flags = head_flags;
+
+		vq->last_used_idx = used_idx;
+		vq->last_used_wrap_counter = wrap_counter;
+
+		vhost_put_meta_ptr();
+
+		return 0;
+	}
+#endif
+
+	/* Update used elems other than first to save unnecessary
+	 * memory barriers.
+	 */
+	for (i = 0; i < count; i++) {
+		__virtio16 flags = get_desc_flags(vq, wrap_counter,
+						  elem[i].len);
+		if (i == 0) {
+			head_flags = flags;
+			desc.flags = ~flags;
+		} else
+			desc.flags = flags;
+
+		desc.id = elem[i].id;
+		desc.len = elem[i].len;
+
+		ret = vhost_put_desc_packed(vq, &desc, used_idx);
+		if (unlikely(ret))
+			return ret;
+
+		used_idx += elem[i].count;
+		if (used_idx >= vq->num) {
+			used_idx -= vq->num;
+			wrap_counter ^= 1;
+		}
+	}
+
+	/* Make sure descriptor id and len is written before
+	 * flags for the first used buffer.
+	 */
+	smp_wmb();
+
+	if (vhost_put_desc_flags(vq, &head_flags, vq->last_used_idx)) {
+		vq_err(vq, "Failed to update flags: idx %d",
+		       vq->last_used_idx);
+		return -EFAULT;
+	}
+
+	vq->last_used_idx = used_idx;
+	vq->last_used_wrap_counter = wrap_counter;
+
+	return 0;
+}
+
+static int vhost_add_used_n_packed(struct vhost_virtqueue *vq,
+				   struct vring_packed_used_elem *elem,
+				   unsigned int count)
+{
+	u16 last_used_idx = vq->last_used_idx;
+	int ret;
+
+	ret = __vhost_add_used_n_packed(vq, elem, count);
+	if (unlikely(ret))
+		return ret;
+
+	if (unlikely(vq->log_used)) {
+		/* Make sure used descriptors are seen before log. */
+		smp_wmb();
+		ret = log_desc(vq, last_used_idx, count);
+	}
+
+	return ret;
+}
+
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-static int vhost_add_used_n(struct vhost_virtqueue *vq,
-			    struct vhost_used_elem *heads,
-			    unsigned count)
+static int vhost_add_used_n_split(struct vhost_virtqueue *vq,
+				  struct vring_used_elem *heads,
+				  unsigned count)
+
 {
 	int start, n, r;
 
 	start = vq->last_used_idx & (vq->num - 1);
 	n = vq->num - start;
 	if (n < count) {
-		r = __vhost_add_used_n(vq, heads, n);
+		r = __vhost_add_used_n_split(vq, heads, n);
 		if (r < 0)
 			return r;
 		heads += n;
 		count -= n;
 	}
-	r = __vhost_add_used_n(vq, heads, count);
+	r = __vhost_add_used_n_split(vq, heads, count);
 
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
@@ -2934,7 +3669,15 @@ static int vhost_add_used_n(struct vhost_virtqueue *vq,
 	}
 	return r;
 }
-EXPORT_SYMBOL_GPL(vhost_add_used_n);
+
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using eventfd.
+ */
+static int vhost_add_used_n(struct vhost_virtqueue *vq,
+			    void *heads, unsigned int count)
+{
+	VHOST_ALTERNATIVE(vhost_add_used_n, vq, heads, count);
+}
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
@@ -2951,6 +3694,11 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	__u16 old, new;
 	__virtio16 event;
 	bool v;
+
+	/* TODO: check driver area */
+	if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED))
+		return true;
+
 	/* Flush out used index updates. This is paired
 	 * with the barrier that the Guest executes when enabling
 	 * interrupts. */
@@ -3023,14 +3771,32 @@ void vhost_flush_shadow_used_and_signal(struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_flush_shadow_used_and_signal);
 
+void vhost_flush_zc_used_and_signal_split(struct vhost_virtqueue *vq,
+					  int idx, int n)
+{
+	struct vring_used_elem *heads = vq->heads;
+
+	vhost_add_used_n_split(vq, &heads[idx], n);
+	vhost_signal(vq->dev, vq);
+}
+
+void vhost_flush_zc_used_and_signal_packed(struct vhost_virtqueue *vq,
+					   int idx, int n)
+{
+	struct vring_packed_used_elem *elem = vq->heads;
+
+	vhost_add_used_n_packed(vq, &elem[idx], n);
+	vhost_signal(vq->dev, vq);
+}
+
 void vhost_flush_zc_used_and_signal(struct vhost_virtqueue *vq, int idx, int n)
 {
-	vhost_add_used_and_signal_n(vq->dev, vq, &vq->heads[idx], n);
+	VHOST_ALTERNATIVE(vhost_flush_zc_used_and_signal, vq, idx, n);
 }
 EXPORT_SYMBOL_GPL(vhost_flush_zc_used_and_signal);
 
 /* return true if we're sure that avaiable ring is empty */
-bool vhost_vq_avail_empty(struct vhost_virtqueue *vq)
+static bool vhost_vq_avail_empty_split(struct vhost_virtqueue *vq)
 {
 	__virtio16 avail_idx;
 	int r;
@@ -3045,10 +3811,52 @@ bool vhost_vq_avail_empty(struct vhost_virtqueue *vq)
 
 	return vq->avail_idx == vq->last_avail_idx;
 }
+
+static bool vhost_vq_avail_empty_packed(struct vhost_virtqueue *vq)
+{
+	__virtio16 flags;
+	int ret;
+
+	ret = vhost_get_desc_flags(vq, &flags, vq->avail_idx);
+	if (unlikely(ret)) {
+		vq_err(vq, "Failed to get flags: idx %d\n",
+		       vq->avail_idx);
+		return -EFAULT;
+	}
+
+	return !desc_is_avail(vq, vq->avail_wrap_counter, flags);
+}
+
+bool vhost_vq_avail_empty(struct vhost_virtqueue *vq)
+{
+	VHOST_ALTERNATIVE(vhost_vq_avail_empty, vq);
+}
 EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 
-/* OK, now we need to know about added descriptors. */
-bool vhost_enable_notify(struct vhost_virtqueue *vq)
+static bool vhost_enable_notify_packed(struct vhost_virtqueue *vq)
+{
+	struct vring_packed_desc *d = vq->desc_packed + vq->avail_idx;
+	__virtio16 flags;
+	int ret;
+
+	/* TODO: enable notification through device area */
+
+	/* They could have slipped one in as we were doing that: make
+	 * sure it's written, then check again.
+	 */
+	smp_mb();
+
+	ret = vhost_get_desc_flags(vq, &flags, vq->avail_idx);
+	if (unlikely(ret)) {
+		vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
+			vq->avail_idx, &d->flags);
+		return -EFAULT;
+	}
+
+	return desc_is_avail(vq, vq->avail_wrap_counter, flags);
+}
+
+static bool vhost_enable_notify_split(struct vhost_virtqueue *vq)
 {
 	__virtio16 avail_idx;
 	int r;
@@ -3083,10 +3891,20 @@ bool vhost_enable_notify(struct vhost_virtqueue *vq)
 
 	return vhost16_to_cpu(vq, avail_idx) != vq->avail_idx;
 }
+
+/* OK, now we need to know about added descriptors. */
+bool vhost_enable_notify(struct vhost_virtqueue *vq)
+{
+	VHOST_ALTERNATIVE(vhost_enable_notify, vq);
+}
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 
-/* We don't need to be notified again. */
-void vhost_disable_notify(struct vhost_virtqueue *vq)
+static void vhost_disable_notify_packed(struct vhost_virtqueue *vq)
+{
+	/* TODO: disable notification through device area */
+}
+
+static void vhost_disable_notify_split(struct vhost_virtqueue *vq)
 {
 	int r;
 
@@ -3100,6 +3918,12 @@ void vhost_disable_notify(struct vhost_virtqueue *vq)
 			       &vq->used->flags, r);
 	}
 }
+
+/* We don't need to be notified again. */
+void vhost_disable_notify(struct vhost_virtqueue *vq)
+{
+	VHOST_ALTERNATIVE(vhost_disable_notify, vq);
+}
 EXPORT_SYMBOL_GPL(vhost_disable_notify);
 
 /* Create a new message. */
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b8a5d1a2bed9..7f3a2dd1b628 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -37,8 +37,17 @@ struct vhost_poll {
 	struct vhost_dev	 *dev;
 };
 
+struct vring_packed_used_elem {
+	__u16 id;
+	__u16 count;
+	__u32 len;
+};
+
 struct vhost_used_elem {
-	struct vring_used_elem elem;
+	union {
+		struct vring_used_elem elem;
+		struct vring_packed_used_elem packed_elem;
+	};
 };
 
 void vhost_work_init(struct vhost_work *work, vhost_work_fn_t fn);
@@ -112,7 +121,10 @@ struct vhost_virtqueue {
 	/* The actual ring of buffers. */
 	struct mutex mutex;
 	unsigned int num;
-	struct vring_desc __user *desc;
+	union {
+		struct vring_desc __user *desc;
+		struct vring_packed_desc __user *desc_packed;
+	};
 	struct vring_avail __user *avail;
 	struct vring_used __user *used;
 
@@ -166,7 +178,7 @@ struct vhost_virtqueue {
 	struct iovec iov[UIO_MAXIOV];
 	struct iovec iotlb_iov[64];
 	struct iovec *indirect;
-	struct vhost_used_elem *heads;
+	void *heads;
 	int nheads;
 	/* Protected by virtqueue mutex. */
 	struct vhost_umem *umem;
@@ -188,6 +200,9 @@ struct vhost_virtqueue {
 	u32 busyloop_timeout;
 	spinlock_t mmu_lock;
 	int invalidate_count;
+	bool last_used_wrap_counter;
+	bool avail_wrap_counter;
+	bool last_avail_wrap_counter;
 };
 
 struct vhost_msg_node {
@@ -241,7 +256,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq,
+			   struct vhost_used_elem *elem);
 
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, struct vhost_used_elem *, int);
-- 
2.18.1

