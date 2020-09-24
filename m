Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23D52766F1
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIXDW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726781AbgIXDW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600917777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=roAbV6FPOAWx9gZkzOd8DWSbxuYMFGVoYNhpPWU7Hyw=;
        b=KCPSyM684QIMnZm0WGAWRmM4o2oBmuvEo6FGTxSCyVoTfLEkagGfVdM7KKOhk1wuwdduJ7
        11IbKCdZM0DCne6GDVLRmYA405eMEH14h5SS22jxfsNPeG/1SRKlWP/3lKXUlXaZbPDcQN
        QE+zmmT9FLdTVpTh49OGUk8ApKRoJeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-H6YhDPIZMa6CiLbp26wgHw-1; Wed, 23 Sep 2020 23:22:53 -0400
X-MC-Unique: H6YhDPIZMa6CiLbp26wgHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAD14186DD2C;
        Thu, 24 Sep 2020 03:22:51 +0000 (UTC)
Received: from jason-ThinkPad-X1-Carbon-6th.redhat.com (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF28D3782;
        Thu, 24 Sep 2020 03:22:35 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
Subject: [RFC PATCH 06/24] vhost-vdpa: switch to use vhost-vdpa specific IOTLB
Date:   Thu, 24 Sep 2020 11:21:07 +0800
Message-Id: <20200924032125.18619-7-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-1-jasowang@redhat.com>
References: <20200924032125.18619-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ease the implementation of per group ASID support for vDPA
device. This patch switches to use a vhost-vdpa specific IOTLB to
avoid the unnecessary refactoring of the vhost core.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 74bef1c15a70..ec3c94f706c1 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -40,6 +40,7 @@ struct vhost_vdpa {
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
+	struct vhost_iotlb *iotlb;
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -514,12 +515,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
-	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(dev->iotlb);
-	dev->iotlb = NULL;
+	kfree(v->iotlb);
+	v->iotlb = NULL;
 }
 
 static int perm_to_iommu_flags(u32 perm)
@@ -681,7 +681,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 	int r = 0;
 
 	r = vhost_dev_check_owner(dev);
@@ -812,12 +812,14 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_init_iotlb;
+		goto err_alloc_domain;
 
 	filep->private_data = v;
 
 	return 0;
 
+err_alloc_domain:
+	vhost_vdpa_iotlb_free(v);
 err_init_iotlb:
 	vhost_vdpa_cleanup(v);
 err:
-- 
2.20.1

