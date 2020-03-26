Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 676861940D1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgCZODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:03:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:36573 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728180AbgCZODf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:03:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585231412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ezal15hgulE5KkDZEmS+B/Xi9s+uUpzAylUKzo6x+cE=;
        b=PuYgd1w/AIHM/7ekFoP62CwU11V1knXscaQvhVLQtFGkkPkiid8GZh2eVHOud57BJxamGg
        +1a9znnq2mmRnbqR6AFUYVoXNdCIUl1RregcEk1XlUx0Vap+gZb5giiKcBxkMtLMbsMR1M
        o3I7aHj7mdkJNPcRVXqhzSaE4GlD0pE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-yKsswqrfM22l95ILfNYLEQ-1; Thu, 26 Mar 2020 10:03:29 -0400
X-MC-Unique: yKsswqrfM22l95ILfNYLEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CDFA800EBD;
        Thu, 26 Mar 2020 14:03:26 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9984160BF7;
        Thu, 26 Mar 2020 14:03:07 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com, gdawar@xilinx.com, saugatm@xilinx.com,
        vmireyno@marvell.com, zhangweining@ruijie.com.cn,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V9 4/9] vringh: IOTLB support
Date:   Thu, 26 Mar 2020 22:01:20 +0800
Message-Id: <20200326140125.19794-5-jasowang@redhat.com>
In-Reply-To: <20200326140125.19794-1-jasowang@redhat.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements the third memory accessor for vringh besides
current kernel and userspace accessors. This idea is to allow vringh
to do the address translation through an IOTLB which is implemented
via vhost_map interval tree. Users should setup and IOVA to PA mapping
in this IOTLB.

This allows us to:

- Use vringh to access virtqueues with vIOMMU
- Use vringh to implement software virtqueues for vDPA devices

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/Kconfig  |   1 +
 drivers/vhost/vringh.c | 421 ++++++++++++++++++++++++++++++++++++++---
 include/linux/vringh.h |  36 ++++
 3 files changed, 435 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
index 2f6c2105b953..b03872886901 100644
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@ -6,6 +6,7 @@ config VHOST_IOTLB
=20
 config VHOST_RING
 	tristate
+	select VHOST_IOTLB
 	help
 	  This option is selected by any driver which needs to access
 	  the host side of a virtio ring.
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index a0a2d74967ef..ee0491f579ac 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -13,6 +13,9 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/bvec.h>
+#include <linux/highmem.h>
+#include <linux/vhost_iotlb.h>
 #include <uapi/linux/virtio_config.h>
=20
 static __printf(1,2) __cold void vringh_bad(const char *fmt, ...)
@@ -71,9 +74,11 @@ static inline int __vringh_get_head(const struct vring=
h *vrh,
 }
=20
 /* Copy some bytes to/from the iovec.  Returns num copied. */
-static inline ssize_t vringh_iov_xfer(struct vringh_kiov *iov,
+static inline ssize_t vringh_iov_xfer(struct vringh *vrh,
+				      struct vringh_kiov *iov,
 				      void *ptr, size_t len,
-				      int (*xfer)(void *addr, void *ptr,
+				      int (*xfer)(const struct vringh *vrh,
+						  void *addr, void *ptr,
 						  size_t len))
 {
 	int err, done =3D 0;
@@ -82,7 +87,7 @@ static inline ssize_t vringh_iov_xfer(struct vringh_kio=
v *iov,
 		size_t partlen;
=20
 		partlen =3D min(iov->iov[iov->i].iov_len, len);
-		err =3D xfer(iov->iov[iov->i].iov_base, ptr, partlen);
+		err =3D xfer(vrh, iov->iov[iov->i].iov_base, ptr, partlen);
 		if (err)
 			return err;
 		done +=3D partlen;
@@ -96,6 +101,7 @@ static inline ssize_t vringh_iov_xfer(struct vringh_ki=
ov *iov,
 			/* Fix up old iov element then increment. */
 			iov->iov[iov->i].iov_len =3D iov->consumed;
 			iov->iov[iov->i].iov_base -=3D iov->consumed;
+
 		=09
 			iov->consumed =3D 0;
 			iov->i++;
@@ -227,7 +233,8 @@ static int slow_copy(struct vringh *vrh, void *dst, c=
onst void *src,
 				      u64 addr,
 				      struct vringh_range *r),
 		     struct vringh_range *range,
-		     int (*copy)(void *dst, const void *src, size_t len))
+		     int (*copy)(const struct vringh *vrh,
+				 void *dst, const void *src, size_t len))
 {
 	size_t part, len =3D sizeof(struct vring_desc);
=20
@@ -241,7 +248,7 @@ static int slow_copy(struct vringh *vrh, void *dst, c=
onst void *src,
 		if (!rcheck(vrh, addr, &part, range, getrange))
 			return -EINVAL;
=20
-		err =3D copy(dst, src, part);
+		err =3D copy(vrh, dst, src, part);
 		if (err)
 			return err;
=20
@@ -262,7 +269,8 @@ __vringh_iov(struct vringh *vrh, u16 i,
 					     struct vringh_range *)),
 	     bool (*getrange)(struct vringh *, u64, struct vringh_range *),
 	     gfp_t gfp,
-	     int (*copy)(void *dst, const void *src, size_t len))
+	     int (*copy)(const struct vringh *vrh,
+			 void *dst, const void *src, size_t len))
 {
 	int err, count =3D 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
@@ -291,7 +299,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			err =3D slow_copy(vrh, &desc, &descs[i], rcheck, getrange,
 					&slowrange, copy);
 		else
-			err =3D copy(&desc, &descs[i], sizeof(desc));
+			err =3D copy(vrh, &desc, &descs[i], sizeof(desc));
 		if (unlikely(err))
 			goto fail;
=20
@@ -404,7 +412,8 @@ static inline int __vringh_complete(struct vringh *vr=
h,
 				    unsigned int num_used,
 				    int (*putu16)(const struct vringh *vrh,
 						  __virtio16 *p, u16 val),
-				    int (*putused)(struct vring_used_elem *dst,
+				    int (*putused)(const struct vringh *vrh,
+						   struct vring_used_elem *dst,
 						   const struct vring_used_elem
 						   *src, unsigned num))
 {
@@ -420,12 +429,12 @@ static inline int __vringh_complete(struct vringh *=
vrh,
 	/* Compiler knows num_used =3D=3D 1 sometimes, hence extra check */
 	if (num_used > 1 && unlikely(off + num_used >=3D vrh->vring.num)) {
 		u16 part =3D vrh->vring.num - off;
-		err =3D putused(&used_ring->ring[off], used, part);
+		err =3D putused(vrh, &used_ring->ring[off], used, part);
 		if (!err)
-			err =3D putused(&used_ring->ring[0], used + part,
+			err =3D putused(vrh, &used_ring->ring[0], used + part,
 				      num_used - part);
 	} else
-		err =3D putused(&used_ring->ring[off], used, num_used);
+		err =3D putused(vrh, &used_ring->ring[off], used, num_used);
=20
 	if (err) {
 		vringh_bad("Failed to write %u used entries %u at %p",
@@ -564,13 +573,15 @@ static inline int putu16_user(const struct vringh *=
vrh, __virtio16 *p, u16 val)
 	return put_user(v, (__force __virtio16 __user *)p);
 }
=20
-static inline int copydesc_user(void *dst, const void *src, size_t len)
+static inline int copydesc_user(const struct vringh *vrh,
+				void *dst, const void *src, size_t len)
 {
 	return copy_from_user(dst, (__force void __user *)src, len) ?
 		-EFAULT : 0;
 }
=20
-static inline int putused_user(struct vring_used_elem *dst,
+static inline int putused_user(const struct vringh *vrh,
+			       struct vring_used_elem *dst,
 			       const struct vring_used_elem *src,
 			       unsigned int num)
 {
@@ -578,13 +589,15 @@ static inline int putused_user(struct vring_used_el=
em *dst,
 			    sizeof(*dst) * num) ? -EFAULT : 0;
 }
=20
-static inline int xfer_from_user(void *src, void *dst, size_t len)
+static inline int xfer_from_user(const struct vringh *vrh, void *src,
+				 void *dst, size_t len)
 {
 	return copy_from_user(dst, (__force void __user *)src, len) ?
 		-EFAULT : 0;
 }
=20
-static inline int xfer_to_user(void *dst, void *src, size_t len)
+static inline int xfer_to_user(const struct vringh *vrh,
+			       void *dst, void *src, size_t len)
 {
 	return copy_to_user((__force void __user *)dst, src, len) ?
 		-EFAULT : 0;
@@ -706,7 +719,7 @@ EXPORT_SYMBOL(vringh_getdesc_user);
  */
 ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, size_t =
len)
 {
-	return vringh_iov_xfer((struct vringh_kiov *)riov,
+	return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
 			       dst, len, xfer_from_user);
 }
 EXPORT_SYMBOL(vringh_iov_pull_user);
@@ -722,7 +735,7 @@ EXPORT_SYMBOL(vringh_iov_pull_user);
 ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
 			     const void *src, size_t len)
 {
-	return vringh_iov_xfer((struct vringh_kiov *)wiov,
+	return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
 			       (void *)src, len, xfer_to_user);
 }
 EXPORT_SYMBOL(vringh_iov_push_user);
@@ -832,13 +845,15 @@ static inline int putu16_kern(const struct vringh *=
vrh, __virtio16 *p, u16 val)
 	return 0;
 }
=20
-static inline int copydesc_kern(void *dst, const void *src, size_t len)
+static inline int copydesc_kern(const struct vringh *vrh,
+				void *dst, const void *src, size_t len)
 {
 	memcpy(dst, src, len);
 	return 0;
 }
=20
-static inline int putused_kern(struct vring_used_elem *dst,
+static inline int putused_kern(const struct vringh *vrh,
+			       struct vring_used_elem *dst,
 			       const struct vring_used_elem *src,
 			       unsigned int num)
 {
@@ -846,13 +861,15 @@ static inline int putused_kern(struct vring_used_el=
em *dst,
 	return 0;
 }
=20
-static inline int xfer_kern(void *src, void *dst, size_t len)
+static inline int xfer_kern(const struct vringh *vrh, void *src,
+			    void *dst, size_t len)
 {
 	memcpy(dst, src, len);
 	return 0;
 }
=20
-static inline int kern_xfer(void *dst, void *src, size_t len)
+static inline int kern_xfer(const struct vringh *vrh, void *dst,
+			    void *src, size_t len)
 {
 	memcpy(dst, src, len);
 	return 0;
@@ -949,7 +966,7 @@ EXPORT_SYMBOL(vringh_getdesc_kern);
  */
 ssize_t vringh_iov_pull_kern(struct vringh_kiov *riov, void *dst, size_t=
 len)
 {
-	return vringh_iov_xfer(riov, dst, len, xfer_kern);
+	return vringh_iov_xfer(NULL, riov, dst, len, xfer_kern);
 }
 EXPORT_SYMBOL(vringh_iov_pull_kern);
=20
@@ -964,7 +981,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
 ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
 			     const void *src, size_t len)
 {
-	return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
+	return vringh_iov_xfer(NULL, wiov, (void *)src, len, kern_xfer);
 }
 EXPORT_SYMBOL(vringh_iov_push_kern);
=20
@@ -1042,4 +1059,362 @@ int vringh_need_notify_kern(struct vringh *vrh)
 }
 EXPORT_SYMBOL(vringh_need_notify_kern);
=20
+static int iotlb_translate(const struct vringh *vrh,
+			   u64 addr, u64 len, struct bio_vec iov[],
+			   int iov_size, u32 perm)
+{
+	struct vhost_iotlb_map *map;
+	struct vhost_iotlb *iotlb =3D vrh->iotlb;
+	int ret =3D 0;
+	u64 s =3D 0;
+
+	while (len > s) {
+		u64 size, pa, pfn;
+
+		if (unlikely(ret >=3D iov_size)) {
+			ret =3D -ENOBUFS;
+			break;
+		}
+
+		map =3D vhost_iotlb_itree_first(iotlb, addr,
+					      addr + len - 1);
+		if (!map || map->start > addr) {
+			ret =3D -EINVAL;
+			break;
+		} else if (!(map->perm & perm)) {
+			ret =3D -EPERM;
+			break;
+		}
+
+		size =3D map->size - addr + map->start;
+		pa =3D map->addr + addr - map->start;
+		pfn =3D pa >> PAGE_SHIFT;
+		iov[ret].bv_page =3D pfn_to_page(pfn);
+		iov[ret].bv_len =3D min(len - s, size);
+		iov[ret].bv_offset =3D pa & (PAGE_SIZE - 1);
+		s +=3D size;
+		addr +=3D size;
+		++ret;
+	}
+
+	return ret;
+}
+
+static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
+				  void *src, size_t len)
+{
+	struct iov_iter iter;
+	struct bio_vec iov[16];
+	int ret;
+
+	ret =3D iotlb_translate(vrh, (u64)(uintptr_t)src,
+			      len, iov, 16, VHOST_MAP_RO);
+	if (ret < 0)
+		return ret;
+
+	iov_iter_bvec(&iter, READ, iov, ret, len);
+
+	ret =3D copy_from_iter(dst, len, &iter);
+
+	return ret;
+}
+
+static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
+				void *src, size_t len)
+{
+	struct iov_iter iter;
+	struct bio_vec iov[16];
+	int ret;
+
+	ret =3D iotlb_translate(vrh, (u64)(uintptr_t)dst,
+			      len, iov, 16, VHOST_MAP_WO);
+	if (ret < 0)
+		return ret;
+
+	iov_iter_bvec(&iter, WRITE, iov, ret, len);
+
+	return copy_to_iter(src, len, &iter);
+}
+
+static inline int getu16_iotlb(const struct vringh *vrh,
+			       u16 *val, const __virtio16 *p)
+{
+	struct bio_vec iov;
+	void *kaddr, *from;
+	int ret;
+
+	/* Atomic read is needed for getu16 */
+	ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      &iov, 1, VHOST_MAP_RO);
+	if (ret < 0)
+		return ret;
+
+	kaddr =3D kmap_atomic(iov.bv_page);
+	from =3D kaddr + iov.bv_offset;
+	*val =3D vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
+	kunmap_atomic(kaddr);
+
+	return 0;
+}
+
+static inline int putu16_iotlb(const struct vringh *vrh,
+			       __virtio16 *p, u16 val)
+{
+	struct bio_vec iov;
+	void *kaddr, *to;
+	int ret;
+
+	/* Atomic write is needed for putu16 */
+	ret =3D iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      &iov, 1, VHOST_MAP_WO);
+	if (ret < 0)
+		return ret;
+
+	kaddr =3D kmap_atomic(iov.bv_page);
+	to =3D kaddr + iov.bv_offset;
+	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
+	kunmap_atomic(kaddr);
+
+	return 0;
+}
+
+static inline int copydesc_iotlb(const struct vringh *vrh,
+				 void *dst, const void *src, size_t len)
+{
+	int ret;
+
+	ret =3D copy_from_iotlb(vrh, dst, (void *)src, len);
+	if (ret !=3D len)
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline int xfer_from_iotlb(const struct vringh *vrh, void *src,
+				  void *dst, size_t len)
+{
+	int ret;
+
+	ret =3D copy_from_iotlb(vrh, dst, src, len);
+	if (ret !=3D len)
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline int xfer_to_iotlb(const struct vringh *vrh,
+			       void *dst, void *src, size_t len)
+{
+	int ret;
+
+	ret =3D copy_to_iotlb(vrh, dst, src, len);
+	if (ret !=3D len)
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline int putused_iotlb(const struct vringh *vrh,
+				struct vring_used_elem *dst,
+				const struct vring_used_elem *src,
+				unsigned int num)
+{
+	int size =3D num * sizeof(*dst);
+	int ret;
+
+	ret =3D copy_to_iotlb(vrh, dst, (void *)src, num * sizeof(*dst));
+	if (ret !=3D size)
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * vringh_init_iotlb - initialize a vringh for a ring with IOTLB.
+ * @vrh: the vringh to initialize.
+ * @features: the feature bits for this ring.
+ * @num: the number of elements.
+ * @weak_barriers: true if we only need memory barriers, not I/O.
+ * @desc: the userpace descriptor pointer.
+ * @avail: the userpace avail pointer.
+ * @used: the userpace used pointer.
+ *
+ * Returns an error if num is invalid.
+ */
+int vringh_init_iotlb(struct vringh *vrh, u64 features,
+		      unsigned int num, bool weak_barriers,
+		      struct vring_desc *desc,
+		      struct vring_avail *avail,
+		      struct vring_used *used)
+{
+	return vringh_init_kern(vrh, features, num, weak_barriers,
+				desc, avail, used);
+}
+EXPORT_SYMBOL(vringh_init_iotlb);
+
+/**
+ * vringh_set_iotlb - initialize a vringh for a ring with IOTLB.
+ * @vrh: the vring
+ * @iotlb: iotlb associated with this vring
+ */
+void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb)
+{
+	vrh->iotlb =3D iotlb;
+}
+EXPORT_SYMBOL(vringh_set_iotlb);
+
+/**
+ * vringh_getdesc_iotlb - get next available descriptor from ring with
+ * IOTLB.
+ * @vrh: the kernelspace vring.
+ * @riov: where to put the readable descriptors (or NULL)
+ * @wiov: where to put the writable descriptors (or NULL)
+ * @head: head index we received, for passing to vringh_complete_iotlb()=
.
+ * @gfp: flags for allocating larger riov/wiov.
+ *
+ * Returns 0 if there was no descriptor, 1 if there was, or -errno.
+ *
+ * Note that on error return, you can tell the difference between an
+ * invalid ring and a single invalid descriptor: in the former case,
+ * *head will be vrh->vring.num.  You may be able to ignore an invalid
+ * descriptor, but there's not much you can do with an invalid ring.
+ *
+ * Note that you may need to clean up riov and wiov, even on error!
+ */
+int vringh_getdesc_iotlb(struct vringh *vrh,
+			 struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov,
+			 u16 *head,
+			 gfp_t gfp)
+{
+	int err;
+
+	err =3D __vringh_get_head(vrh, getu16_iotlb, &vrh->last_avail_idx);
+	if (err < 0)
+		return err;
+
+	/* Empty... */
+	if (err =3D=3D vrh->vring.num)
+		return 0;
+
+	*head =3D err;
+	err =3D __vringh_iov(vrh, *head, riov, wiov, no_range_check, NULL,
+			   gfp, copydesc_iotlb);
+	if (err)
+		return err;
+
+	return 1;
+}
+EXPORT_SYMBOL(vringh_getdesc_iotlb);
+
+/**
+ * vringh_iov_pull_iotlb - copy bytes from vring_iov.
+ * @vrh: the vring.
+ * @riov: the riov as passed to vringh_getdesc_iotlb() (updated as we co=
nsume)
+ * @dst: the place to copy.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <=3D len or a negative errno.
+ */
+ssize_t vringh_iov_pull_iotlb(struct vringh *vrh,
+			      struct vringh_kiov *riov,
+			      void *dst, size_t len)
+{
+	return vringh_iov_xfer(vrh, riov, dst, len, xfer_from_iotlb);
+}
+EXPORT_SYMBOL(vringh_iov_pull_iotlb);
+
+/**
+ * vringh_iov_push_iotlb - copy bytes into vring_iov.
+ * @vrh: the vring.
+ * @wiov: the wiov as passed to vringh_getdesc_iotlb() (updated as we co=
nsume)
+ * @dst: the place to copy.
+ * @len: the maximum length to copy.
+ *
+ * Returns the bytes copied <=3D len or a negative errno.
+ */
+ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
+			      struct vringh_kiov *wiov,
+			      const void *src, size_t len)
+{
+	return vringh_iov_xfer(vrh, wiov, (void *)src, len, xfer_to_iotlb);
+}
+EXPORT_SYMBOL(vringh_iov_push_iotlb);
+
+/**
+ * vringh_abandon_iotlb - we've decided not to handle the descriptor(s).
+ * @vrh: the vring.
+ * @num: the number of descriptors to put back (ie. num
+ *	 vringh_get_iotlb() to undo).
+ *
+ * The next vringh_get_iotlb() will return the old descriptor(s) again.
+ */
+void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num)
+{
+	/* We only update vring_avail_event(vr) when we want to be notified,
+	 * so we haven't changed that yet.
+	 */
+	vrh->last_avail_idx -=3D num;
+}
+EXPORT_SYMBOL(vringh_abandon_iotlb);
+
+/**
+ * vringh_complete_iotlb - we've finished with descriptor, publish it.
+ * @vrh: the vring.
+ * @head: the head as filled in by vringh_getdesc_iotlb.
+ * @len: the length of data we have written.
+ *
+ * You should check vringh_need_notify_iotlb() after one or more calls
+ * to this function.
+ */
+int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len)
+{
+	struct vring_used_elem used;
+
+	used.id =3D cpu_to_vringh32(vrh, head);
+	used.len =3D cpu_to_vringh32(vrh, len);
+
+	return __vringh_complete(vrh, &used, 1, putu16_iotlb, putused_iotlb);
+}
+EXPORT_SYMBOL(vringh_complete_iotlb);
+
+/**
+ * vringh_notify_enable_iotlb - we want to know if something changes.
+ * @vrh: the vring.
+ *
+ * This always enables notifications, but returns false if there are
+ * now more buffers available in the vring.
+ */
+bool vringh_notify_enable_iotlb(struct vringh *vrh)
+{
+	return __vringh_notify_enable(vrh, getu16_iotlb, putu16_iotlb);
+}
+EXPORT_SYMBOL(vringh_notify_enable_iotlb);
+
+/**
+ * vringh_notify_disable_iotlb - don't tell us if something changes.
+ * @vrh: the vring.
+ *
+ * This is our normal running state: we disable and then only enable whe=
n
+ * we're going to sleep.
+ */
+void vringh_notify_disable_iotlb(struct vringh *vrh)
+{
+	__vringh_notify_disable(vrh, putu16_iotlb);
+}
+EXPORT_SYMBOL(vringh_notify_disable_iotlb);
+
+/**
+ * vringh_need_notify_iotlb - must we tell the other side about used buf=
fers?
+ * @vrh: the vring we've called vringh_complete_iotlb() on.
+ *
+ * Returns -errno or 0 if we don't need to tell the other side, 1 if we =
do.
+ */
+int vringh_need_notify_iotlb(struct vringh *vrh)
+{
+	return __vringh_need_notify(vrh, getu16_iotlb);
+}
+EXPORT_SYMBOL(vringh_need_notify_iotlb);
+
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index d237087eb257..bd0503ca6f8f 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -14,6 +14,8 @@
 #include <linux/virtio_byteorder.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
+#include <linux/dma-direction.h>
+#include <linux/vhost_iotlb.h>
 #include <asm/barrier.h>
=20
 /* virtio_ring with information needed for host access. */
@@ -39,6 +41,9 @@ struct vringh {
 	/* The vring (note: it may contain user pointers!) */
 	struct vring vring;
=20
+	/* IOTLB for this vring */
+	struct vhost_iotlb *iotlb;
+
 	/* The function to call to notify the guest about added buffers */
 	void (*notify)(struct vringh *);
 };
@@ -248,4 +253,35 @@ static inline __virtio64 cpu_to_vringh64(const struc=
t vringh *vrh, u64 val)
 {
 	return __cpu_to_virtio64(vringh_is_little_endian(vrh), val);
 }
+
+void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb);
+
+int vringh_init_iotlb(struct vringh *vrh, u64 features,
+		      unsigned int num, bool weak_barriers,
+		      struct vring_desc *desc,
+		      struct vring_avail *avail,
+		      struct vring_used *used);
+
+int vringh_getdesc_iotlb(struct vringh *vrh,
+			 struct vringh_kiov *riov,
+			 struct vringh_kiov *wiov,
+			 u16 *head,
+			 gfp_t gfp);
+
+ssize_t vringh_iov_pull_iotlb(struct vringh *vrh,
+			      struct vringh_kiov *riov,
+			      void *dst, size_t len);
+ssize_t vringh_iov_push_iotlb(struct vringh *vrh,
+			      struct vringh_kiov *wiov,
+			      const void *src, size_t len);
+
+void vringh_abandon_iotlb(struct vringh *vrh, unsigned int num);
+
+int vringh_complete_iotlb(struct vringh *vrh, u16 head, u32 len);
+
+bool vringh_notify_enable_iotlb(struct vringh *vrh);
+void vringh_notify_disable_iotlb(struct vringh *vrh);
+
+int vringh_need_notify_iotlb(struct vringh *vrh);
+
 #endif /* _LINUX_VRINGH_H */
--=20
2.20.1

