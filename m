Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF091276725
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgIXDZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbgIXDZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=udJFktyGbHSPU2ACLVP6clJHUuXQ96F446FaxHy+b4U=;
        b=W/RrBkhicBcS3P9JXeuivoVYlV+3beeoLHAUIG0doJvE9+gIiuIpoohMlUntxWN0uiBqVR
        81NkCT+z5NVJTEYsamG54JQW1hDXVTnhBJOGd+GRhvyZoP3f1XjZIWOQMiIwf+vqOfkp18
        dtW32px6VfLvWFyVk0UoAjdoO9r3L8A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-eoec7iykNByO-6_RZXWjCw-1; Wed, 23 Sep 2020 23:25:13 -0400
X-MC-Unique: eoec7iykNByO-6_RZXWjCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A443E1091066;
        Thu, 24 Sep 2020 03:25:11 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4795255768;
        Thu, 24 Sep 2020 03:24:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 18/24] vhost-vdpa: support ASID based IOTLB API
Date:   Thu, 24 Sep 2020 11:21:19 +0800
Message-Id: <20200924032125.18619-19-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 drivers/vhost/vdpa.c | 106 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 978cf97dc03a..99ac13b2ed11 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -29,7 +29,8 @@
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
 	(1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
-	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
+	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
+	(1ULL << VHOST_BACKEND_F_IOTLB_ASID),
 };
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
@@ -58,12 +59,20 @@ struct vhost_vdpa {
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	int used_as;
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
@@ -76,6 +85,16 @@ static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
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
@@ -84,6 +103,9 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	if (asid_to_as(v, asid))
 		return NULL;
 
+	if (asid >= v->vdpa->nas)
+		return NULL;
+
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
 		return NULL;
@@ -96,13 +118,20 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
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
@@ -623,6 +652,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
 	r = vhost_iotlb_add_range(iotlb, iova, iova + size - 1,
@@ -631,10 +661,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
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
@@ -643,23 +673,32 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
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
+	if (!iotlb->nmaps)
+		vhost_vdpa_remove_as(v, asid);
+
+	return 0;
 }
 
 static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
@@ -755,30 +794,38 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_vdpa_as *as = asid_to_as(v, 0);
-	struct vhost_iotlb *iotlb = &as->iotlb;
+	struct vhost_iotlb *iotlb = asid_to_iotlb(v, asid);
+	struct vhost_vdpa_as *as;
 	int r = 0;
 
-	if (asid != 0)
-		return -EINVAL;
-
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		return r;
 
+	if ((msg->type == VHOST_IOTLB_UPDATE) && !iotlb) {
+		as = vhost_vdpa_find_alloc_as(v, asid);
+		if (!as)
+			return -EINVAL;
+		iotlb = &as->iotlb;
+	}
+
+	if (v->in_batch && v->batch_asid != asid)
+		return -EINVAL;
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
 		break;
 	default:
@@ -848,9 +895,17 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
 
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
@@ -883,18 +938,15 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	if (!vhost_vdpa_alloc_as(v, 0))
-		goto err_alloc_as;
-
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_as;
+		goto err_alloc_domain;
 
 	filep->private_data = v;
 
 	return 0;
 
-err_alloc_as:
+err_alloc_domain:
 	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
@@ -1022,8 +1074,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int i, r;
 
-	/* Only support 1 address space */
-	if (vdpa->ngroups != 1)
+	/* We can't support platform IOMMU device with more than 1 group */
+	if (!ops->set_map && !ops->dma_map && vdpa->ngroups > 1)
 		return -ENOTSUPP;
 
 	/* Currently, we only accept the network devices. */
-- 
2.20.1

