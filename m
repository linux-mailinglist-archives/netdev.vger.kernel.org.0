Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D227670A
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgIXDYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbgIXDYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:24:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bj5hOD/TaR3wsx6jelP41mbkhAddYnJnOwxBYmlKZHY=;
        b=Kh34IzMu/Z6nn/1jJ598eQNKNBUU7wd/FrLyII3o40Wt1a/+tR8MUORC5HmolOyQ9SPMRq
        Lu//J5fbV8niWwm0kVYsQ0lW2wIO8Hyx33t0xSDLsZcgqAXBdD+hGFdl9WAEozPV+k6FEO
        4hr83cXAOCiMOM6HuHF8tqwsx3OxzI4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-NG8Tkue9OyWIW121jiVfbw-1; Wed, 23 Sep 2020 23:24:13 -0400
X-MC-Unique: NG8Tkue9OyWIW121jiVfbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A342C106B827;
        Thu, 24 Sep 2020 03:24:11 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 048A63A40;
        Thu, 24 Sep 2020 03:24:02 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 13/24] vhost-vdpa: introduce ASID based IOTLB
Date:   Thu, 24 Sep 2020 11:21:14 +0800
Message-Id: <20200924032125.18619-14-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the support of ASID based IOTLB by tagging IOTLB
with a unique ASID. This is a must for supporting ASID based vhost
IOTLB API by the following patches.

IOTLB were stored in a hlist and new IOTLB will be allocated when a
new ASID is seen via IOTLB API and destoryed when there's no mapping
associated with an ASID.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 94 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 72 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6552987544d7..1ba7e95619b5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -34,13 +34,21 @@ enum {
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
 
+#define VHOST_VDPA_IOTLB_BUCKETS 16
+
+struct vhost_vdpa_as {
+	struct hlist_node hash_link;
+	struct vhost_iotlb iotlb;
+	u32 id;
+};
+
 struct vhost_vdpa {
 	struct vhost_dev vdev;
 	struct iommu_domain *domain;
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
-	struct vhost_iotlb *iotlb;
+	struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -49,12 +57,64 @@ struct vhost_vdpa {
 	int minor;
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
+	int used_as;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	hlist_for_each_entry(as, head, hash_link)
+		if (as->id == asid)
+			return as;
+
+	return NULL;
+}
+
+static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
+	struct vhost_vdpa_as *as;
+
+	if (asid_to_as(v, asid))
+		return NULL;
+
+	as = kmalloc(sizeof(*as), GFP_KERNEL);
+	if (!as)
+		return NULL;
+
+	vhost_iotlb_init(&as->iotlb, 0, 0);
+	as->id = asid;
+	hlist_add_head(&as->hash_link, head);
+	++v->used_as;
+
+	return as;
+}
+
+static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	/* Remove default address space is not allowed */
+	if (asid == 0)
+		return -EINVAL;
+
+	if (!as)
+		return -EINVAL;
+
+	hlist_del(&as->hash_link);
+	vhost_iotlb_reset(&as->iotlb);
+	kfree(as);
+	--v->used_as;
+
+	return 0;
+}
+
 static void handle_vq_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -513,15 +573,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 	}
 }
 
-static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
-{
-	struct vhost_iotlb *iotlb = v->iotlb;
-
-	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(v->iotlb);
-	v->iotlb = NULL;
-}
-
 static int perm_to_iommu_flags(u32 perm)
 {
 	int flags = 0;
@@ -681,7 +732,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = v->iotlb;
+	struct vhost_vdpa_as *as = asid_to_as(v, 0);
+	struct vhost_iotlb *iotlb = &as->iotlb;
 	int r = 0;
 
 	if (asid != 0)
@@ -775,6 +827,7 @@ static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 {
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
+	vhost_vdpa_remove_as(v, 0);
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
@@ -807,23 +860,18 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	dev->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!dev->iotlb) {
-		r = -ENOMEM;
-		goto err_init_iotlb;
-	}
+	if (!vhost_vdpa_alloc_as(v, 0))
+		goto err_alloc_as;
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_domain;
+		goto err_alloc_as;
 
 	filep->private_data = v;
 
 	return 0;
 
-err_alloc_domain:
-	vhost_vdpa_iotlb_free(v);
-err_init_iotlb:
+err_alloc_as:
 	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
@@ -851,7 +899,6 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	filep->private_data = NULL;
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_clean_irq(v);
@@ -950,7 +997,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa *v;
 	int minor;
-	int r;
+	int i, r;
 
 	/* Only support 1 address space */
 	if (vdpa->ngroups != 1)
@@ -1002,6 +1049,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
+
 	return 0;
 
 err:
-- 
2.20.1

