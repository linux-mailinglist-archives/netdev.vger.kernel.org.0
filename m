Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603EE211E26
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 10:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgGBIWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 04:22:42 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:34456 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbgGBIWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 04:22:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0628MD3P017061;
        Thu, 2 Jul 2020 03:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593678133;
        bh=N2Gbtsq8k3jkbnqxN/KZBC1QC1TkA9iW5uvR+twVvhg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=a5rx8XCugNxdGtJhwEWB3iGK5xebh/uFIDVYhLg2Cw88Wk339mPGydv6v0QZk3Pvg
         PMlRwp3+RyLk8uPeeR/n0wJrl+jYUUZ6s5YiFhWUO5bWYmYJW5tP4WGeQlL2VfqI0d
         txOtIlUUNH94QTu3HyEwTZk5yTbMCoyXwtcVIxLI=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0628MDP2030503
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 2 Jul 2020 03:22:13 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 2 Jul
 2020 03:22:13 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 2 Jul 2020 03:22:13 -0500
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0628LiYG006145;
        Thu, 2 Jul 2020 03:22:08 -0500
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-remoteproc@vger.kernel.org>, <linux-ntb@googlegroups.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH 04/22] vringh: Add helpers to access vring in MMIO
Date:   Thu, 2 Jul 2020 13:51:25 +0530
Message-ID: <20200702082143.25259-5-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702082143.25259-1-kishon@ti.com>
References: <20200702082143.25259-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to access vring in memory mapped IO. This would require
using IO accessors to access vring and the addresses populated by
virtio driver (in the descriptor) should be directly given to the
vhost client driver. Even if the vhost runs in 32 bit system, it
can access 64 bit address provided by the virtio if the vhost device
supports translation.

This is in preparation for adding VHOST devices (PCIe Endpoint or
Host in NTB) to access vrings created by VIRTIO devices (PCIe RC or
Host in NTB) over memory mapped IO.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/vhost/vringh.c | 332 +++++++++++++++++++++++++++++++++++++++++
 include/linux/vringh.h |  46 ++++++
 2 files changed, 378 insertions(+)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index ba8e0d6cfd97..b3f1910b99ec 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -5,6 +5,7 @@
  * Since these may be in userspace, we use (inline) accessors.
  */
 #include <linux/compiler.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/vringh.h>
 #include <linux/virtio_ring.h>
@@ -188,6 +189,32 @@ static int move_to_indirect(const struct vringh *vrh,
 	return 0;
 }
 
+static int resize_mmiovec(struct vringh_mmiov *iov, gfp_t gfp)
+{
+	unsigned int flag, new_num = (iov->max_num & ~VRINGH_IOV_ALLOCATED) * 2;
+	struct mmiovec *new;
+
+	if (new_num < 8)
+		new_num = 8;
+
+	flag = (iov->max_num & VRINGH_IOV_ALLOCATED);
+	if (flag) {
+		new = krealloc(iov->iov, new_num * sizeof(struct iovec), gfp);
+	} else {
+		new = kmalloc_array(new_num, sizeof(struct iovec), gfp);
+		if (new) {
+			memcpy(new, iov->iov,
+			       iov->max_num * sizeof(struct iovec));
+			flag = VRINGH_IOV_ALLOCATED;
+		}
+	}
+	if (!new)
+		return -ENOMEM;
+	iov->iov = new;
+	iov->max_num = (new_num | flag);
+	return 0;
+}
+
 static int resize_iovec(struct vringh_kiov *iov, gfp_t gfp)
 {
 	struct kvec *new;
@@ -261,6 +288,142 @@ static int slow_copy(struct vringh *vrh, void *dst, const void *src,
 	return 0;
 }
 
+static inline int
+__vringh_mmiov(struct vringh *vrh, u16 i, struct vringh_mmiov *riov,
+	       struct vringh_mmiov *wiov,
+	       bool (*rcheck)(struct vringh *vrh, u64 addr, size_t *len,
+			      struct vringh_range *range,
+			      bool (*getrange)(struct vringh *, u64,
+					       struct vringh_range *)),
+	       bool (*getrange)(struct vringh *, u64, struct vringh_range *),
+	       gfp_t gfp,
+	       int (*copy)(const struct vringh *vrh,
+			   void *dst, const void *src, size_t len))
+{
+	int err, count = 0, up_next, desc_max;
+	struct vring_desc desc, *descs;
+	struct vringh_range range = { -1ULL, 0 }, slowrange;
+	bool slow = false;
+
+	/* We start traversing vring's descriptor table. */
+	descs = vrh->vring.desc;
+	desc_max = vrh->vring.num;
+	up_next = -1;
+
+	if (riov) {
+		riov->i = 0;
+		riov->used = 0;
+	} else if (wiov) {
+		wiov->i = 0;
+		wiov->used = 0;
+	} else {
+		/* You must want something! */
+		WARN_ON(1);
+	}
+
+	for (;;) {
+		u64 addr;
+		struct vringh_mmiov *iov;
+		size_t len;
+
+		if (unlikely(slow))
+			err = slow_copy(vrh, &desc, &descs[i], rcheck, getrange,
+					&slowrange, copy);
+		else
+			err = copy(vrh, &desc, &descs[i], sizeof(desc));
+		if (unlikely(err))
+			goto fail;
+
+		if (unlikely(desc.flags &
+			     cpu_to_vringh16(vrh, VRING_DESC_F_INDIRECT))) {
+			/* VRING_DESC_F_INDIRECT is not supported */
+			err = -EINVAL;
+			goto fail;
+		}
+
+		if (count++ == vrh->vring.num) {
+			vringh_bad("Descriptor loop in %p", descs);
+			err = -ELOOP;
+			goto fail;
+		}
+
+		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_WRITE)) {
+			iov = wiov;
+		} else {
+			iov = riov;
+			if (unlikely(wiov && wiov->i)) {
+				vringh_bad("Readable desc %p after writable",
+					   &descs[i]);
+				err = -EINVAL;
+				goto fail;
+			}
+		}
+
+		if (!iov) {
+			vringh_bad("Unexpected %s desc",
+				   !wiov ? "writable" : "readable");
+			err = -EPROTO;
+			goto fail;
+		}
+
+again:
+		/* Make sure it's OK, and get offset. */
+		len = vringh32_to_cpu(vrh, desc.len);
+		if (!rcheck(vrh, vringh64_to_cpu(vrh, desc.addr), &len, &range,
+			    getrange)) {
+			err = -EINVAL;
+			goto fail;
+		}
+		addr = vringh64_to_cpu(vrh, desc.addr) + range.offset;
+
+		if (unlikely(iov->used == (iov->max_num & ~VRINGH_IOV_ALLOCATED))) {
+			err = resize_mmiovec(iov, gfp);
+			if (err)
+				goto fail;
+		}
+
+		iov->iov[iov->used].iov_base = addr;
+		iov->iov[iov->used].iov_len = len;
+		iov->used++;
+
+		if (unlikely(len != vringh32_to_cpu(vrh, desc.len))) {
+			desc.len =
+				cpu_to_vringh32(vrh,
+						vringh32_to_cpu(vrh, desc.len)
+						- len);
+			desc.addr =
+				cpu_to_vringh64(vrh,
+						vringh64_to_cpu(vrh, desc.addr)
+						+ len);
+			goto again;
+		}
+
+		if (desc.flags & cpu_to_vringh16(vrh, VRING_DESC_F_NEXT)) {
+			i = vringh16_to_cpu(vrh, desc.next);
+		} else {
+			/* Just in case we need to finish traversing above. */
+			if (unlikely(up_next > 0)) {
+				i = return_from_indirect(vrh, &up_next,
+							 &descs, &desc_max);
+				slow = false;
+			} else {
+				break;
+			}
+		}
+
+		if (i >= desc_max) {
+			vringh_bad("Chained index %u > %u", i, desc_max);
+			err = -EINVAL;
+			goto fail;
+		}
+	}
+
+	return 0;
+
+fail:
+	return err;
+}
+
 static inline int
 __vringh_iov(struct vringh *vrh, u16 i,
 	     struct vringh_kiov *riov,
@@ -833,6 +996,175 @@ int vringh_need_notify_user(struct vringh *vrh)
 }
 EXPORT_SYMBOL(vringh_need_notify_user);
 
+/* MMIO access helpers */
+static inline int getu16_mmio(const struct vringh *vrh,
+			      u16 *val, const __virtio16 *p)
+{
+	*val = vringh16_to_cpu(vrh, readw(p));
+	return 0;
+}
+
+static inline int putu16_mmio(const struct vringh *vrh, __virtio16 *p, u16 val)
+{
+	writew(cpu_to_vringh16(vrh, val), p);
+	return 0;
+}
+
+static inline int copydesc_mmio(const struct vringh *vrh,
+				void *dst, const void *src, size_t len)
+{
+	memcpy_fromio(dst, src, len);
+	return 0;
+}
+
+static inline int putused_mmio(const struct vringh *vrh,
+			       struct vring_used_elem *dst,
+			       const struct vring_used_elem *src,
+			       unsigned int num)
+{
+	memcpy_toio(dst, src, num * sizeof(*dst));
+	return 0;
+}
+
+/**
+ * vringh_init_mmio - initialize a vringh for a MMIO vring.
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
+int vringh_init_mmio(struct vringh *vrh, u64 features,
+		     unsigned int num, bool weak_barriers,
+		     struct vring_desc *desc,
+		     struct vring_avail *avail,
+		     struct vring_used *used)
+{
+	/* Sane power of 2 please! */
+	if (!num || num > 0xffff || (num & (num - 1))) {
+		vringh_bad("Bad ring size %u", num);
+		return -EINVAL;
+	}
+
+	vrh->little_endian = (features & (1ULL << VIRTIO_F_VERSION_1));
+	vrh->event_indices = (features & (1 << VIRTIO_RING_F_EVENT_IDX));
+	vrh->weak_barriers = weak_barriers;
+	vrh->completed = 0;
+	vrh->last_avail_idx = 0;
+	vrh->last_used_idx = 0;
+	vrh->vring.num = num;
+	vrh->vring.desc = desc;
+	vrh->vring.avail = avail;
+	vrh->vring.used = used;
+	return 0;
+}
+EXPORT_SYMBOL(vringh_init_mmio);
+
+/**
+ * vringh_getdesc_mmio - get next available descriptor from MMIO ring.
+ * @vrh: the MMIO vring.
+ * @riov: where to put the readable descriptors (or NULL)
+ * @wiov: where to put the writable descriptors (or NULL)
+ * @head: head index we received, for passing to vringh_complete_mmio().
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
+int vringh_getdesc_mmio(struct vringh *vrh,
+			struct vringh_mmiov *riov,
+			struct vringh_mmiov *wiov,
+			u16 *head,
+			gfp_t gfp)
+{
+	int err;
+
+	err = __vringh_get_head(vrh, getu16_mmio, &vrh->last_avail_idx);
+	if (err < 0)
+		return err;
+
+	/* Empty... */
+	if (err == vrh->vring.num)
+		return 0;
+
+	*head = err;
+	err = __vringh_mmiov(vrh, *head, riov, wiov, no_range_check, NULL,
+			     gfp, copydesc_mmio);
+	if (err)
+		return err;
+
+	return 1;
+}
+EXPORT_SYMBOL(vringh_getdesc_mmio);
+
+/**
+ * vringh_complete_mmio - we've finished with descriptor, publish it.
+ * @vrh: the vring.
+ * @head: the head as filled in by vringh_getdesc_mmio.
+ * @len: the length of data we have written.
+ *
+ * You should check vringh_need_notify_mmio() after one or more calls
+ * to this function.
+ */
+int vringh_complete_mmio(struct vringh *vrh, u16 head, u32 len)
+{
+	struct vring_used_elem used;
+
+	used.id = cpu_to_vringh32(vrh, head);
+	used.len = cpu_to_vringh32(vrh, len);
+
+	return __vringh_complete(vrh, &used, 1, putu16_mmio, putused_mmio);
+}
+EXPORT_SYMBOL(vringh_complete_mmio);
+
+/**
+ * vringh_notify_enable_mmio - we want to know if something changes.
+ * @vrh: the vring.
+ *
+ * This always enables notifications, but returns false if there are
+ * now more buffers available in the vring.
+ */
+bool vringh_notify_enable_mmio(struct vringh *vrh)
+{
+	return __vringh_notify_enable(vrh, getu16_mmio, putu16_mmio);
+}
+EXPORT_SYMBOL(vringh_notify_enable_mmio);
+
+/**
+ * vringh_notify_disable_mmio - don't tell us if something changes.
+ * @vrh: the vring.
+ *
+ * This is our normal running state: we disable and then only enable when
+ * we're going to sleep.
+ */
+void vringh_notify_disable_mmio(struct vringh *vrh)
+{
+	__vringh_notify_disable(vrh, putu16_mmio);
+}
+EXPORT_SYMBOL(vringh_notify_disable_mmio);
+
+/**
+ * vringh_need_notify_mmio - must we tell the other side about used buffers?
+ * @vrh: the vring we've called vringh_complete_mmio() on.
+ *
+ * Returns -errno or 0 if we don't need to tell the other side, 1 if we do.
+ */
+int vringh_need_notify_mmio(struct vringh *vrh)
+{
+	return __vringh_need_notify(vrh, getu16_mmio);
+}
+EXPORT_SYMBOL(vringh_need_notify_mmio);
+
 /* Kernelspace access helpers. */
 static inline int getu16_kern(const struct vringh *vrh,
 			      u16 *val, const __virtio16 *p)
diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 9e2763d7c159..0ba63a72b124 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -99,6 +99,23 @@ struct vringh_kiov {
 	unsigned i, used, max_num;
 };
 
+struct mmiovec {
+	u64 iov_base;
+	size_t iov_len;
+};
+
+/**
+ * struct vringh_mmiov - mmiovec mangler.
+ *
+ * Mangles mmiovec in place, and restores it.
+ * Remaining data is iov + i, of used - i elements.
+ */
+struct vringh_mmiov {
+	struct mmiovec *iov;
+	size_t consumed; /* Within iov[i] */
+	unsigned int i, used, max_num;
+};
+
 /* Flag on max_num to indicate we're kmalloced. */
 #define VRINGH_IOV_ALLOCATED 0x8000000
 
@@ -213,6 +230,35 @@ void vringh_notify_disable_kern(struct vringh *vrh);
 
 int vringh_need_notify_kern(struct vringh *vrh);
 
+/* Helpers for kernelspace vrings. */
+int vringh_init_mmio(struct vringh *vrh, u64 features,
+		     unsigned int num, bool weak_barriers,
+		     struct vring_desc *desc,
+		     struct vring_avail *avail,
+		     struct vring_used *used);
+
+static inline void vringh_mmiov_init(struct vringh_mmiov *mmiov,
+				     struct mmiovec *mmiovec, unsigned int num)
+{
+	mmiov->used = 0;
+	mmiov->i = 0;
+	mmiov->consumed = 0;
+	mmiov->max_num = num;
+	mmiov->iov = mmiovec;
+}
+
+int vringh_getdesc_mmio(struct vringh *vrh,
+			struct vringh_mmiov *riov,
+			struct vringh_mmiov *wiov,
+			u16 *head,
+			gfp_t gfp);
+
+int vringh_complete_mmio(struct vringh *vrh, u16 head, u32 len);
+
+bool vringh_notify_enable_mmio(struct vringh *vrh);
+void vringh_notify_disable_mmio(struct vringh *vrh);
+int vringh_need_notify_mmio(struct vringh *vrh);
+
 /* Notify the guest about buffers added to the used ring */
 static inline void vringh_notify(struct vringh *vrh)
 {
-- 
2.17.1

