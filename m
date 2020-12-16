Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38502DBB9A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 07:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgLPGvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 01:51:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgLPGvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 01:51:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608101394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ucZFVbnSLjolInYBrTmeMC9TNcLOvT+i2R2XNtIFZQU=;
        b=brhsqr20g3bSwcZUkjaquC/9soHku79MfGMg0ZuV5vzFn0fIpsrmvzKuyv4n5AdNYYrDAP
        dLtg0db8BYpLAyb73SBBIB3ZAySOOA4NzEtcSGr1gevYWm7PLeELZvwFja9deWU+Dm9vW7
        lcGQP7lhNv8PgPE+Wq8HKVMdbDxRiZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-ZZt3uHG7Nj6Th6v8eYdh2w-1; Wed, 16 Dec 2020 01:49:51 -0500
X-MC-Unique: ZZt3uHG7Nj6Th6v8eYdh2w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D803802B42;
        Wed, 16 Dec 2020 06:49:49 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-12-210.pek2.redhat.com [10.72.12.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5081A10016F5;
        Wed, 16 Dec 2020 06:49:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
Subject: [PATCH 11/21] vhost-vdpa: introduce asid based IOTLB
Date:   Wed, 16 Dec 2020 14:48:08 +0800
Message-Id: <20201216064818.48239-12-jasowang@redhat.com>
In-Reply-To: <20201216064818.48239-1-jasowang@redhat.com>
References: <20201216064818.48239-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch converts the vhost-vDPA device to support multiple IOTLBs
tagged via ASID via hlist. This will be used for supporting multiple
address spaces in the following patches.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 106 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 80 insertions(+), 26 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index feb6a58df22d..060d5b5b7e64 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -33,13 +33,21 @@ enum {
 
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
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	struct vdpa_iova_range range;
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
@@ -525,15 +585,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
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
@@ -745,7 +796,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = v->iotlb;
+	struct vhost_vdpa_as *as = asid_to_as(v, 0);
+	struct vhost_iotlb *iotlb = &as->iotlb;
 	int r = 0;
 
 	if (asid != 0)
@@ -856,6 +908,13 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
+{
+	vhost_dev_cleanup(&v->vdev);
+	kfree(v->vdev.vqs);
+	vhost_vdpa_remove_as(v, 0);
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -886,15 +945,12 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	v->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!v->iotlb) {
-		r = -ENOMEM;
-		goto err_init_iotlb;
-	}
+	if (!vhost_vdpa_alloc_as(v, 0))
+		goto err_alloc_as;
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_domain;
+		goto err_alloc_as;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -902,11 +958,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_domain:
-	vhost_vdpa_iotlb_free(v);
-err_init_iotlb:
-	vhost_dev_cleanup(&v->vdev);
-	kfree(vqs);
+err_alloc_as:
+	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
 	return r;
@@ -933,12 +986,10 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	filep->private_data = NULL;
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
-	vhost_vdpa_iotlb_free(v);
 	vhost_vdpa_free_domain(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_clean_irq(v);
-	vhost_dev_cleanup(&v->vdev);
-	kfree(v->vdev.vqs);
+	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
 
 	atomic_dec(&v->opened);
@@ -1033,7 +1084,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct vhost_vdpa *v;
 	int minor;
-	int r;
+	int i, r;
 
 	/* Only support 1 address space and 1 groups */
 	if (vdpa->ngroups != 1 || vdpa->nas != 1)
@@ -1085,6 +1136,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	init_completion(&v->completion);
 	vdpa_set_drvdata(vdpa, v);
 
+	for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
+		INIT_HLIST_HEAD(&v->as[i]);
+
 	return 0;
 
 err:
-- 
2.25.1

