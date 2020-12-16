Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B792DBBAB
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgLPGv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgLPGvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:51:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7DGH3xp7K8IU4jiyaoCZhtGAw82X37HtaQ8e9kcXt2c=;
        b=ASHRV8nUIe1iyhLyFIIa3Q5b6X/urc7FO8+piAwQ6oeUiRV/+Yn+LGajI/TdjxD1PQn4VN
        uqlACEeKr9ZqsHI0CdgsYNuHPAyBgf3/BGG3BlKRkQgIVlPu9rFmZRGyCZ+LxHIfQTdm6G
        wOnLPw3cQ2sRzZVEk2LP8PbPfr+1cdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-JrYYLeiAPS2eVbzveLlPlw-1; Wed, 16 Dec 2020 01:50:24 -0500
X-MC-Unique: JrYYLeiAPS2eVbzveLlPlw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF18B180A08A;
        Wed, 16 Dec 2020 06:50:22 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4AA610013C1;
        Wed, 16 Dec 2020 06:50:18 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 16/21] vhost-vdpa: support ASID based IOTLB API
Date:   Wed, 16 Dec 2020 14:48:13 +0800
Message-Id: <20201216064818.48239-17-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the vhost-vdpa to support ASID based IOTLB API. The
vhost-vdpa device will allocated multple IOTLBs for vDPA device that
supports multiple address spaces. The IOTLBs and vDPA device memory
mappings is determined and maintained through ASID.

Note that we still don't support vDPA device with more than one
address spaces that depends on platform IOMMU. This work will be done
by moving the IOMMU logic from vhost-vDPA to vDPA device driver.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c  | 127 ++++++++++++++++++++++++++++++++----------
 drivers/vhost/vhost.c |   4 +-
 2 files changed, 99 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index cd7c9a401a61..c4fda48d4273 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -28,7 +28,8 @@
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
 	(1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
-	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
+	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
+	(1ULL << VHOST_BACKEND_F_IOTLB_ASID),
 };
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
@@ -57,13 +58,20 @@ struct vhost_vdpa {
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	struct vdpa_iova_range range;
-	int used_as;
+	u32 batch_asid;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
+{
+	struct vhost_vdpa_as *as = container_of(iotlb, struct
+						vhost_vdpa_as, iotlb);
+	return as->id;
+}
+
 static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -76,6 +84,16 @@ static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 	return NULL;
 }
 
+static struct vhost_iotlb *asid_to_iotlb(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	if (!as)
+		return NULL;
+
+	return &as->iotlb;
+}
+
 static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -84,6 +102,9 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	if (asid_to_as(v, asid))
 		return NULL;
 
+	if (asid >= v->vdpa->nas)
+		return NULL;
+
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
 		return NULL;
@@ -91,18 +112,24 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	vhost_iotlb_init(&as->iotlb, 0, 0);
 	as->id = asid;
 	hlist_add_head(&as->hash_link, head);
-	++v->used_as;
 
 	return as;
 }
 
-static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+static struct vhost_vdpa_as *vhost_vdpa_find_alloc_as(struct vhost_vdpa *v,
+						      u32 asid)
 {
 	struct vhost_vdpa_as *as = asid_to_as(v, asid);
 
-	/* Remove default address space is not allowed */
-	if (asid == 0)
-		return -EINVAL;
+	if (as)
+		return as;
+
+	return vhost_vdpa_alloc_as(v, asid);
+}
+
+static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
 
 	if (!as)
 		return -EINVAL;
@@ -110,7 +137,6 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 	hlist_del(&as->hash_link);
 	vhost_iotlb_reset(&as->iotlb);
 	kfree(as);
-	--v->used_as;
 
 	return 0;
 }
@@ -636,6 +662,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
 	r = vhost_iotlb_add_range(iotlb, iova, iova + size - 1,
@@ -644,10 +671,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, 0, iova, size, pa, perm);
+		r = ops->dma_map(vdpa, asid, iova, size, pa, perm);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, 0, iotlb);
+			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
@@ -661,23 +688,35 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	return r;
 }
 
-static void vhost_vdpa_unmap(struct vhost_vdpa *v,
-			     struct vhost_iotlb *iotlb,
-			     u64 iova, u64 size)
+static int vhost_vdpa_unmap(struct vhost_vdpa *v,
+			    struct vhost_iotlb *iotlb,
+			    u64 iova, u64 size)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
+
+	if (!iotlb)
+		return -EINVAL;
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, 0, iova, size);
+		ops->dma_unmap(vdpa, asid, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
+
+	/* If we are in the middle of batch processing, delay the free
+	 * of AS until BATCH_END.
+	 */
+	if (!v->in_batch && !iotlb->nmaps)
+		vhost_vdpa_remove_as(v, asid);
+
+	return 0;
 }
 
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
@@ -819,31 +858,52 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_vdpa_as *as = asid_to_as(v, 0);
-	struct vhost_iotlb *iotlb = &as->iotlb;
+	struct vhost_iotlb *iotlb = NULL;
+	struct vhost_vdpa_as *as = NULL;
 	int r = 0;
 
-	if (asid != 0)
-		return -EINVAL;
-
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		return r;
 
+	if (msg->type == VHOST_IOTLB_UPDATE ||
+	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
+		as = vhost_vdpa_find_alloc_as(v, asid);
+		if (!as) {
+			printk("can't find and alloc asid %d\n", asid);
+			return -EINVAL;
+		}
+		iotlb = &as->iotlb;
+	} else
+		iotlb = asid_to_iotlb(v, asid);
+
+	if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
+		if (v->in_batch && v->batch_asid != asid) {
+			printk("batch id %d asid %d\n",
+				v->batch_asid, asid);
+		}
+		if (!iotlb)
+			printk("no iotlb for asid %d\n", asid);
+		return -EINVAL;
+	}
+
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
 		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
 		break;
 	case VHOST_IOTLB_INVALIDATE:
-		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
+		r = vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
+		v->batch_asid = asid;
 		v->in_batch = true;
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 		v->in_batch = false;
+		if (!iotlb->nmaps)
+			vhost_vdpa_remove_as(v, asid);
 		break;
 	default:
 		r = -EINVAL;
@@ -933,9 +993,17 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 
 static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 {
+	struct vhost_vdpa_as *as;
+	u32 asid;
+
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
-	vhost_vdpa_remove_as(v, 0);
+
+	for (asid = 0; asid < v->vdpa->nas; asid++) {
+		as = asid_to_as(v, asid);
+		if (as)
+			vhost_vdpa_remove_as(v, asid);
+	}
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
@@ -968,12 +1036,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	if (!vhost_vdpa_alloc_as(v, 0))
-		goto err_alloc_as;
-
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_as;
+		goto err_alloc_domain;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -981,7 +1046,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_as:
+err_alloc_domain:
 	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
@@ -1109,8 +1174,10 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int i, r;
 
-	/* Only support 1 address space and 1 groups */
-	if (vdpa->ngroups != 1 || vdpa->nas != 1)
+	/* We can't support platform IOMMU device with more than 1
+	   group or as */
+	if (!ops->set_map && !ops->dma_map &&
+	    (vdpa->ngroups > 1 || vdpa->nas > 1))
 		return -ENOTSUPP;
 
 	/* Currently, we only accept the network devices. */
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7477b724c29b..d59a9b171756 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1138,7 +1138,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 	struct vhost_iotlb_msg msg;
 	size_t offset;
 	int type, ret;
-	u16 asid = 0;
+	u32 asid = 0;
 
 	ret = copy_from_iter(&type, sizeof(type), from);
 	if (ret != sizeof(type)) {
@@ -1161,7 +1161,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 				ret = -EINVAL;
 				goto done;
 			}
-			offset = sizeof(__u16);
+			offset = 0;
 		} else
 			offset = sizeof(__u32);
 		break;
-- 
2.25.1

