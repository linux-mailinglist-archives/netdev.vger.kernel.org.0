Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C0733C22D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhCOQgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:36:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233857AbhCOQgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:36:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7lPMF4AhF+g6E7lQlwuYLZcnVAR9NBURQ63G4nVUIs=;
        b=DcyQ2CU9Ls+HUQr2IZ8KChYE939/sqA1BO3OdLAPI2m4M/eYsDyWQ0e+TldC6+rwCZTeqT
        96v3r627ApFr34T4/rxcdpz1pUcjAdHKjAEB/OgMA8dZShOVno1x4yp2BEtqL0f03JBsfL
        gFbdhZTdmkU3huwy6YrcqQ3Ou4J9JnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-gkViq4xxO_aVn93IdnQN0Q-1; Mon, 15 Mar 2021 12:36:21 -0400
X-MC-Unique: gkViq4xxO_aVn93IdnQN0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 699138189DC;
        Mon, 15 Mar 2021 16:36:20 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B32CD5F9B8;
        Mon, 15 Mar 2021 16:36:06 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 08/14] vdpa: add get_config_size callback in vdpa_config_ops
Date:   Mon, 15 Mar 2021 17:34:44 +0100
Message-Id: <20210315163450.254396-9-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new callback is used to get the size of the configuration space
of vDPA devices.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vdpa.h              | 4 ++++
 drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
 drivers/vdpa/virtio_pci/vp_vdpa.c | 8 ++++++++
 5 files changed, 33 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 15fa085fab05..1b094c1531f2 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -150,6 +150,9 @@ struct vdpa_iova_range {
  * @set_status:			Set the device status
  *				@vdev: vdpa device
  *				@status: virtio device status
+ * @get_config_size:		Get the size of the configuration space
+ *				@vdev: vdpa device
+ *				Returns size_t: configuration size
  * @get_config:			Read from device specific configuration space
  *				@vdev: vdpa device
  *				@offset: offset from the beginning of
@@ -231,6 +234,7 @@ struct vdpa_config_ops {
 	u32 (*get_vendor_id)(struct vdpa_device *vdev);
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
+	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
 			   void *buf, unsigned int len);
 	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d555a6a5d1ba..017ab07040c7 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -332,6 +332,11 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
 	return IFCVF_QUEUE_ALIGNMENT;
 }
 
+static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
 				  unsigned int offset,
 				  void *buf, unsigned int len)
@@ -392,6 +397,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_device_id	= ifcvf_vdpa_get_device_id,
 	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
 	.get_vq_align	= ifcvf_vdpa_get_vq_align,
+	.get_config_size	= ifcvf_vdpa_get_config_size,
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 71397fdafa6a..f6e03bf49e3e 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1814,6 +1814,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
 }
 
+static size_t mlx5_vdpa_get_config_size(struct vdpa_device *vdev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
 static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
 				 unsigned int len)
 {
@@ -1900,6 +1905,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vendor_id = mlx5_vdpa_get_vendor_id,
 	.get_status = mlx5_vdpa_get_status,
 	.set_status = mlx5_vdpa_set_status,
+	.get_config_size = mlx5_vdpa_get_config_size,
 	.get_config = mlx5_vdpa_get_config,
 	.set_config = mlx5_vdpa_set_config,
 	.get_generation = mlx5_vdpa_get_generation,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 14dc2d3d983e..98f793bc9376 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -462,6 +462,13 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
 	spin_unlock(&vdpasim->lock);
 }
 
+static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+
+	return vdpasim->dev_attr.config_size;
+}
+
 static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 			     void *buf, unsigned int len)
 {
@@ -598,6 +605,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.get_vendor_id          = vdpasim_get_vendor_id,
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
+	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
@@ -625,6 +633,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_vendor_id          = vdpasim_get_vendor_id,
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
+	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index 1321a2fcd088..dc27ec970884 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -295,6 +295,13 @@ static u32 vp_vdpa_get_vq_align(struct vdpa_device *vdpa)
 	return PAGE_SIZE;
 }
 
+static size_t vp_vdpa_get_config_size(struct vdpa_device *vdpa)
+{
+	struct virtio_pci_modern_device *mdev = vdpa_to_mdev(vdpa);
+
+	return mdev->device_len;
+}
+
 static void vp_vdpa_get_config(struct vdpa_device *vdpa,
 			       unsigned int offset,
 			       void *buf, unsigned int len)
@@ -354,6 +361,7 @@ static const struct vdpa_config_ops vp_vdpa_ops = {
 	.get_device_id	= vp_vdpa_get_device_id,
 	.get_vendor_id	= vp_vdpa_get_vendor_id,
 	.get_vq_align	= vp_vdpa_get_vq_align,
+	.get_config_size = vp_vdpa_get_config_size,
 	.get_config	= vp_vdpa_get_config,
 	.set_config	= vp_vdpa_set_config,
 	.set_config_cb  = vp_vdpa_set_config_cb,
-- 
2.30.2

