Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842E4532F6B
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbiEXRG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239875AbiEXRGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:06:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBAEB82140
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 10:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653412006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NRVyuXQ2anZsMTN0V2Kp61WOvAM/LWYlpRTqMTKf390=;
        b=iOg2BOjLLNPpZOFMYo7dFoUNRnTOsun9EvJ7OyFhBc5rr+1lDPvUl/tdw7U9A/XInJzS5Q
        bh1PjnIQa1NNKopJUyjDrbAHS/RlYGNBIbKg3z41+EzY0YEtDi//faksPsf/lnnP/rg/PP
        9RQM6LimSKWCZHPiDLMDZKG0zPW9WfY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-hHqKpHFUOOKaGi6FSPlasQ-1; Tue, 24 May 2022 13:06:42 -0400
X-MC-Unique: hHqKpHFUOOKaGi6FSPlasQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F5121C08973;
        Tue, 24 May 2022 17:06:36 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.195.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12CC92026D64;
        Tue, 24 May 2022 17:06:31 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Zhang Min <zhang.min9@zte.com.cn>,
        hanand@xilinx.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        tanuj.kamde@amd.com, gautam.dawar@amd.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>, dinang@xilinx.com,
        habetsm.xilinx@gmail.com, Eli Cohen <elic@nvidia.com>,
        pabloc@xilinx.com, lvivier@redhat.com,
        Dan Carpenter <dan.carpenter@oracle.com>, lulu@redhat.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        eperezma@redhat.com, ecree.xilinx@gmail.com,
        Piotr.Uminski@intel.com, martinpo@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Longpeng <longpeng2@huawei.com>, martinh@xilinx.com
Subject: [PATCH v2 4/4] vdpa_sim: Implement stop vdpa op
Date:   Tue, 24 May 2022 19:06:10 +0200
Message-Id: <20220524170610.2255608-5-eperezma@redhat.com>
In-Reply-To: <20220524170610.2255608-1-eperezma@redhat.com>
References: <20220524170610.2255608-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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

After the return of ioctl with stop != 0, the device MUST finish any
pending operations like in flight requests. It must also preserve all
the necessary state (the virtqueue vring base plus the possible device
specific states) that is required for restoring in the future. The
device must not change its configuration after that point.

After the return of ioctl with stop == 0, the device can continue
processing buffers as long as typical conditions are met (vq is enabled,
DRIVER_OK status bit is enabled, etc).

In the future, we will provide features similar to
VHOST_USER_GET_INFLIGHT_FD so the device can save pending operations.

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

