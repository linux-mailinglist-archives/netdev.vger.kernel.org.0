Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4F53C82D
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243383AbiFCKKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243480AbiFCKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6CCD3B3C7
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 03:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654251020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3+EP9PD/XGXq5/0hvrOKGwV2S5RKvIGOAb6+LG+/kc=;
        b=Lno5InqW3+LApULwQZ4iG2/7SLvz2U6xfy9oe4UMIKPV4azfXaBU+D/4vVOsZjsYmEpu69
        4n1Xy2Nvy00iYBWf9qGkZCMLVnKej/gXVrRaI08OwsfbxrLqdjbzQRfgczxfqi39qqdHFz
        OaxuL1fBydql0KYnGXIrJUYxnC2tkG0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-5xAbDisiOb6gLvcBpaFx1A-1; Fri, 03 Jun 2022 06:10:15 -0400
X-MC-Unique: 5xAbDisiOb6gLvcBpaFx1A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB74380A0B9;
        Fri,  3 Jun 2022 10:10:14 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.40.192.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97681403371;
        Fri,  3 Jun 2022 10:10:09 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Longpeng <longpeng2@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>, dinang@xilinx.com,
        Piotr.Uminski@intel.com, martinpo@xilinx.com, tanuj.kamde@amd.com,
        Parav Pandit <parav@nvidia.com>,
        Zhang Min <zhang.min9@zte.com.cn>, habetsm.xilinx@gmail.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, lulu@redhat.com,
        hanand@xilinx.com, martinh@xilinx.com,
        Si-Wei Liu <si-wei.liu@oracle.com>, gautam.dawar@amd.com,
        Xie Yongji <xieyongji@bytedance.com>, ecree.xilinx@gmail.com,
        pabloc@xilinx.com, lvivier@redhat.com, Eli Cohen <elic@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v5 4/4] vdpa_sim: Implement suspend vdpa op
Date:   Fri,  3 Jun 2022 12:09:44 +0200
Message-Id: <20220603100944.871727-5-eperezma@redhat.com>
In-Reply-To: <20220603100944.871727-1-eperezma@redhat.com>
References: <20220603100944.871727-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement suspend operation for vdpa_sim devices, so vhost-vdpa will
offer that backend feature and userspace can effectively suspend the
device.

This is a must before get virtqueue indexes (base) for live migration,
since the device could modify them after userland gets them. There are
individual ways to perform that action for some devices
(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
way to perform it for any vhost device (and, in particular, vhost-vdpa).

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
 4 files changed, 28 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 0f28658996472..01f9377830b3e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 	for (i = 0; i < vdpasim->dev_attr.nas; i++)
 		vhost_iotlb_reset(&vdpasim->iommu[i]);
 
+	vdpasim->running = true;
 	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
@@ -505,6 +506,24 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
 	return 0;
 }
 
+static int vdpasim_suspend(struct vdpa_device *vdpa, bool suspend)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	int i;
+
+	spin_lock(&vdpasim->lock);
+	vdpasim->running = !suspend;
+	if (vdpasim->running) {
+		/* Check for missed buffers */
+		for (i = 0; i < vdpasim->dev_attr.nvqs; ++i)
+			vdpasim_kick_vq(vdpa, i);
+
+	}
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
 static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -694,6 +713,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
 	.reset			= vdpasim_reset,
+	.suspend		= vdpasim_suspend,
 	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
 	.reset			= vdpasim_reset,
+	.suspend		= vdpasim_suspend,
 	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 622782e922391..061986f30911a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -66,6 +66,7 @@ struct vdpasim {
 	u32 generation;
 	u64 features;
 	u32 groups;
+	bool running;
 	/* spinlock to synchronize iommu table */
 	spinlock_t iommu_lock;
 };
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index 42d401d439117..bcdb1982c378e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -204,6 +204,9 @@ static void vdpasim_blk_work(struct work_struct *work)
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
 
+	if (!vdpasim->running)
+		goto out;
+
 	for (i = 0; i < VDPASIM_BLK_VQ_NUM; i++) {
 		struct vdpasim_virtqueue *vq = &vdpasim->vqs[i];
 
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 5125976a4df87..886449e885026 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -154,6 +154,9 @@ static void vdpasim_net_work(struct work_struct *work)
 
 	spin_lock(&vdpasim->lock);
 
+	if (!vdpasim->running)
+		goto out;
+
 	if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
 		goto out;
 
-- 
2.31.1

