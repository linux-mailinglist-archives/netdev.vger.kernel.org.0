Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7132F58F157
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiHJRPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbiHJRPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:15:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEAC967CAC
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660151743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Imye1gnnfzcz+CnTHG0VF+fJyp01Qs5zM0UuNG7EPiA=;
        b=OprhU86B0kobWkmXjoidB1V4LsooMHh5RXotOX/zko5jxUllBMroBsftTkRbl7wanJ/JMr
        sopKo7ldXbV3lOkC8pIGr3pvNbxVtRptpCHcPNjoQSwobX5cU6Y6yaTlf/b5ZQFNdUCWUO
        9loOQoeCVRGu7WZRHE3ZVtkhnG5H9KI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-JOUjUaghNQ25Zncct0Exdg-1; Wed, 10 Aug 2022 13:15:40 -0400
X-MC-Unique: JOUjUaghNQ25Zncct0Exdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE1B01C006C9;
        Wed, 10 Aug 2022 17:15:38 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 512A51415125;
        Wed, 10 Aug 2022 17:15:34 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v7 4/4] vdpa_sim: Implement suspend vdpa op
Date:   Wed, 10 Aug 2022 19:15:12 +0200
Message-Id: <20220810171512.2343333-5-eperezma@redhat.com>
In-Reply-To: <20220810171512.2343333-1-eperezma@redhat.com>
References: <20220810171512.2343333-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
Message-Id: <20220623160738.632852-5-eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
v7: Delete leftover resume code
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 14 ++++++++++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  1 +
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  3 +++
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  3 +++
 4 files changed, 21 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 0f2865899647..79a50edf8998 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -107,6 +107,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 	for (i = 0; i < vdpasim->dev_attr.nas; i++)
 		vhost_iotlb_reset(&vdpasim->iommu[i]);
 
+	vdpasim->running = true;
 	spin_unlock(&vdpasim->iommu_lock);
 
 	vdpasim->features = 0;
@@ -505,6 +506,17 @@ static int vdpasim_reset(struct vdpa_device *vdpa)
 	return 0;
 }
 
+static int vdpasim_suspend(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+
+	spin_lock(&vdpasim->lock);
+	vdpasim->running = false;
+	spin_unlock(&vdpasim->lock);
+
+	return 0;
+}
+
 static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -694,6 +706,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
 	.reset			= vdpasim_reset,
+	.suspend		= vdpasim_suspend,
 	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
@@ -726,6 +739,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
 	.reset			= vdpasim_reset,
+	.suspend		= vdpasim_suspend,
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
2.31.1

