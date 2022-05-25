Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE2533B30
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiEYLAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiEYLAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25D617A821
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 04:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653476418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovY2VffbNgFSVd4EdA9lKw3OU/gUQCdeGqQ5LnkLao8=;
        b=bXMmVpfnX2phUvV7fFInpWOQ//I4fAsAzUf5Cf2G4idO8auXc/iJopq70tP+JuiEUIzpmG
        CxJIbQkQK4WdGaZ2NAbdm9iVv26vN7CMq8DZbBAsNKw8Lif0hIBVz3DOho/RcFzNVzp8es
        0tOzbGR+2Mf4epexIa6sikpHQf5omh8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-vIufvyjGMG2OnI2MXWAsig-1; Wed, 25 May 2022 07:00:12 -0400
X-MC-Unique: vIufvyjGMG2OnI2MXWAsig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DD04100F84A;
        Wed, 25 May 2022 11:00:11 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E820E1730C;
        Wed, 25 May 2022 11:00:04 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        ecree.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>, dinang@xilinx.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, gautam.dawar@amd.com,
        lulu@redhat.com, martinpo@xilinx.com, pabloc@xilinx.com,
        Longpeng <longpeng2@huawei.com>, Piotr.Uminski@intel.com,
        tanuj.kamde@amd.com, Si-Wei Liu <si-wei.liu@oracle.com>,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhang Min <zhang.min9@zte.com.cn>, hanand@xilinx.com
Subject: [PATCH v3 4/4] vdpa_sim: Implement stop vdpa op
Date:   Wed, 25 May 2022 12:59:22 +0200
Message-Id: <20220525105922.2413991-5-eperezma@redhat.com>
In-Reply-To: <20220525105922.2413991-1-eperezma@redhat.com>
References: <20220525105922.2413991-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement stop operation for vdpa_sim devices, so vhost-vdpa will offer
that backend feature and userspace can effectively stop the device.

This is a must before get virtqueue indexes (base) for live migration,
since the device could modify them after userland gets them. There are
individual ways to perform that action for some devices
(VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but there was no
way to perform it for any vhost device (and, in particular, vhost-vdpa).

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 21 +++++++++++++++++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
 4 files changed, 28 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 50d721072beb..0515cf314bed 100644
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
 
+static int vdpasim_stop(struct vdpa_device *vdpa, bool stop)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	int i;
+
+	spin_lock(&vdpasim->lock);
+	vdpasim->running = !stop;
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
+	.stop			= vdpasim_stop,
 	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
@@ -726,6 +746,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
 	.reset			= vdpasim_reset,
+	.stop			= vdpasim_stop,
 	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index 622782e92239..061986f30911 100644
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
index 42d401d43911..bcdb1982c378 100644
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
index 5125976a4df8..886449e88502 100644
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
2.27.0

