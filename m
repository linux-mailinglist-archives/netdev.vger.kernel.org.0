Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2817C50D183
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 13:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiDXLnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 07:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiDXLnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 07:43:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C002021BD
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 04:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650800448; x=1682336448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u4LsBa1/hM0x1TBgQ0dqNrYEvWAXAsqdjLkmYv3OKao=;
  b=bVWV+JVfKse/5BHYRt5BXcJN7SFx4ii+DrT1J7N8LcxO02P2LIGTR4Z9
   XSYdMw/93NXpO45WpmadUYpBHRYns3qf/yaVa7aUGfu/GUSkmdAO+5GRp
   B8QNsBBqn2Vha0fGrT1GI5yJB+0xnJSBMTp9CNAy6Wy+6sCvJzzC3J4i3
   LYBQ/S6tyAk8apL3KbcmgwoXvIJOzetJZTPFLGTzu3PORuxeGD5GuoMO2
   mxT1Xh9CFtFmNeWg1+9wHD3YsKMfr76wbxK9I8aJyKFXhLNGOE/qxHJCT
   VlaKCtM/kctY+xXgw9Bm3U6mHlgffb6WxfqfvrCSwNhSch33BtQXPTHix
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="290168209"
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="290168209"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 04:40:47 -0700
X-IronPort-AV: E=Sophos;i="5.90,286,1643702400"; 
   d="scan'208";a="557235903"
Received: from unknown (HELO ocsbesrhlrepo01.amr.corp.intel.com) ([10.240.193.73])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 04:40:45 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2] vDPA/ifcvf: allow userspace to suspend a queue
Date:   Sun, 24 Apr 2022 19:33:21 +0800
Message-Id: <20220424113321.7176-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Formerly, ifcvf driver has implemented a lazy-initialization mechanism
for the virtqueues, it would store all virtqueue config fields that
passed down from the userspace, then load them to the virtqueues and
enable the queues upon DRIVER_OK.

To allow the userspace to suspend a virtqueue,
this commit passes queue_enable to the virtqueue directly through
set_vq_ready().

This feature requires and this commits implementing all virtqueue
ops(set_vq_addr, set_vq_num and set_vq_ready) to take immediate
actions than lazy-initialization, so ifcvf_hw_enable() is retired.

set_features() should take immediate actions as well.

ifcvf_add_status() is retierd because we should not add
status like FEATURES_OK by ifcvf's decision, this driver should
only set device status upon vdpa_ops.set_status()

To avoid losing virtqueue configurations caused by multiple
rounds of reset(), this commit also refactors thed evice reset
routine, now it simply reset the config handler and the virtqueues,
and only once device-reset().

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 150 +++++++++++++++++++-------------
 drivers/vdpa/ifcvf/ifcvf_base.h |  16 ++--
 drivers/vdpa/ifcvf/ifcvf_main.c |  81 +++--------------
 3 files changed, 111 insertions(+), 136 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 48c4dadb0c7c..bbc9007a6f34 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -179,20 +179,7 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
 
 void ifcvf_reset(struct ifcvf_hw *hw)
 {
-	hw->config_cb.callback = NULL;
-	hw->config_cb.private = NULL;
-
 	ifcvf_set_status(hw, 0);
-	/* flush set_status, make sure VF is stopped, reset */
-	ifcvf_get_status(hw);
-}
-
-static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
-{
-	if (status != 0)
-		status |= ifcvf_get_status(hw);
-
-	ifcvf_set_status(hw, status);
 	ifcvf_get_status(hw);
 }
 
@@ -213,7 +200,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
 	return features;
 }
 
-u64 ifcvf_get_features(struct ifcvf_hw *hw)
+u64 ifcvf_get_device_features(struct ifcvf_hw *hw)
 {
 	return hw->hw_features;
 }
@@ -280,7 +267,7 @@ void ifcvf_write_dev_config(struct ifcvf_hw *hw, u64 offset,
 		vp_iowrite8(*p++, hw->dev_cfg + offset + i);
 }
 
-static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
+void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
 
@@ -289,22 +276,22 @@ static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
 
 	vp_iowrite32(1, &cfg->guest_feature_select);
 	vp_iowrite32(features >> 32, &cfg->guest_feature);
+
+	vp_ioread32(&cfg->guest_feature);
 }
 
-static int ifcvf_config_features(struct ifcvf_hw *hw)
+u64 ifcvf_get_features(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *ifcvf;
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	u64 features;
 
-	ifcvf = vf_to_adapter(hw);
-	ifcvf_set_features(hw, hw->req_features);
-	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
+	vp_iowrite32(0, &cfg->device_feature_select);
+	features = vp_ioread32(&cfg->device_feature);
 
-	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
-		IFCVF_ERR(ifcvf->pdev, "Failed to set FEATURES_OK status\n");
-		return -EIO;
-	}
+	vp_iowrite32(1, &cfg->device_feature_select);
+	features |= ((u64)vp_ioread32(&cfg->guest_feature) << 32);
 
-	return 0;
+	return features;
 }
 
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
@@ -331,68 +318,111 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
 	q_pair_id = qid / hw->nr_vring;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
-	hw->vring[qid].last_avail_idx = num;
 	vp_iowrite16(num, avail_idx_addr);
 
 	return 0;
 }
 
-static int ifcvf_hw_enable(struct ifcvf_hw *hw)
+void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num)
 {
-	struct virtio_pci_common_cfg __iomem *cfg;
-	u32 i;
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
 
-	cfg = hw->common_cfg;
-	for (i = 0; i < hw->nr_vring; i++) {
-		if (!hw->vring[i].ready)
-			break;
+	vp_iowrite16(qid, &cfg->queue_select);
+	vp_iowrite16(num, &cfg->queue_size);
+}
 
-		vp_iowrite16(i, &cfg->queue_select);
-		vp_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
-				     &cfg->queue_desc_hi);
-		vp_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
-				      &cfg->queue_avail_hi);
-		vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
-				     &cfg->queue_used_hi);
-		vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
-		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
-		vp_iowrite16(1, &cfg->queue_enable);
-	}
+int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
+			 u64 driver_area, u64 device_area)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+
+	vp_iowrite16(qid, &cfg->queue_select);
+	vp_iowrite64_twopart(desc_area, &cfg->queue_desc_lo,
+			     &cfg->queue_desc_hi);
+	vp_iowrite64_twopart(driver_area, &cfg->queue_avail_lo,
+			     &cfg->queue_avail_hi);
+	vp_iowrite64_twopart(device_area, &cfg->queue_used_lo,
+			     &cfg->queue_used_hi);
 
 	return 0;
 }
 
-static void ifcvf_hw_disable(struct ifcvf_hw *hw)
+void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready)
 {
-	u32 i;
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+
+	vp_iowrite16(qid, &cfg->queue_select);
+	/* write 0 to queue_enable will suspend a queue*/
+	vp_iowrite16(ready, &cfg->queue_enable);
+}
+
+bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
+{
+	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
+	bool queue_enable;
+
+	vp_iowrite16(qid, &cfg->queue_select);
+	queue_enable = vp_ioread16(&cfg->queue_enable);
+
+	return (bool)queue_enable;
+}
+
+static void synchronize_per_vq_irq(struct ifcvf_hw *hw)
+{
+	int i;
 
-	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
 	for (i = 0; i < hw->nr_vring; i++) {
-		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
+		if (hw->vring[i].irq != -EINVAL)
+			synchronize_irq(hw->vring[i].irq);
 	}
 }
 
-int ifcvf_start_hw(struct ifcvf_hw *hw)
+static void synchronize_vqs_reused_irq(struct ifcvf_hw *hw)
 {
-	ifcvf_reset(hw);
-	ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
-	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
+	if (hw->vqs_reused_irq != -EINVAL)
+		synchronize_irq(hw->vqs_reused_irq);
+}
 
-	if (ifcvf_config_features(hw) < 0)
-		return -EINVAL;
+static void synchronize_vq_irq(struct ifcvf_hw *hw)
+{
+	u8 status = hw->msix_vector_status;
 
-	if (ifcvf_hw_enable(hw) < 0)
-		return -EINVAL;
+	if (status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
+		synchronize_per_vq_irq(hw);
+	else
+		synchronize_vqs_reused_irq(hw);
+}
 
-	ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
+static void synchronize_config_irq(struct ifcvf_hw *hw)
+{
+	if (hw->config_irq != -EINVAL)
+		synchronize_irq(hw->config_irq);
+}
 
-	return 0;
+static void ifcvf_reset_vring(struct ifcvf_hw *hw)
+{
+	int i;
+
+	for (i = 0; i < hw->nr_vring; i++) {
+		synchronize_vq_irq(hw);
+		hw->vring[i].cb.callback = NULL;
+		hw->vring[i].cb.private = NULL;
+		ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
+	}
+}
+
+static void ifcvf_reset_config_handler(struct ifcvf_hw *hw)
+{
+	synchronize_config_irq(hw);
+	hw->config_cb.callback = NULL;
+	hw->config_cb.private = NULL;
+	ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
 }
 
 void ifcvf_stop_hw(struct ifcvf_hw *hw)
 {
-	ifcvf_hw_disable(hw);
-	ifcvf_reset(hw);
+	ifcvf_reset_vring(hw);
+	ifcvf_reset_config_handler(hw);
 }
 
 void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 115b61f4924b..f3dce0d795cb 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -49,12 +49,6 @@
 #define MSIX_VECTOR_DEV_SHARED			3
 
 struct vring_info {
-	u64 desc;
-	u64 avail;
-	u64 used;
-	u16 size;
-	u16 last_avail_idx;
-	bool ready;
 	void __iomem *notify_addr;
 	phys_addr_t notify_pa;
 	u32 irq;
@@ -76,7 +70,6 @@ struct ifcvf_hw {
 	phys_addr_t notify_base_pa;
 	u32 notify_off_multiplier;
 	u32 dev_type;
-	u64 req_features;
 	u64 hw_features;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *dev_cfg;
@@ -123,7 +116,7 @@ u8 ifcvf_get_status(struct ifcvf_hw *hw);
 void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
 void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
 void ifcvf_reset(struct ifcvf_hw *hw);
-u64 ifcvf_get_features(struct ifcvf_hw *hw);
+u64 ifcvf_get_device_features(struct ifcvf_hw *hw);
 u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
@@ -131,6 +124,13 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
 int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
+int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
+			 u64 driver_area, u64 device_area);
 u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
 u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
+void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num);
+void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready);
+bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid);
+void ifcvf_set_features(struct ifcvf_hw *hw, u64 features);
+u64 ifcvf_get_features(struct ifcvf_hw *hw);
 #endif /* _IFCVF_H_ */
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4366320fb68d..0257ba98cffe 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -358,53 +358,6 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 	return 0;
 }
 
-static int ifcvf_start_datapath(void *private)
-{
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
-	u8 status;
-	int ret;
-
-	ret = ifcvf_start_hw(vf);
-	if (ret < 0) {
-		status = ifcvf_get_status(vf);
-		status |= VIRTIO_CONFIG_S_FAILED;
-		ifcvf_set_status(vf, status);
-	}
-
-	return ret;
-}
-
-static int ifcvf_stop_datapath(void *private)
-{
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
-	int i;
-
-	for (i = 0; i < vf->nr_vring; i++)
-		vf->vring[i].cb.callback = NULL;
-
-	ifcvf_stop_hw(vf);
-
-	return 0;
-}
-
-static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
-{
-	struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
-	int i;
-
-	for (i = 0; i < vf->nr_vring; i++) {
-		vf->vring[i].last_avail_idx = 0;
-		vf->vring[i].desc = 0;
-		vf->vring[i].avail = 0;
-		vf->vring[i].used = 0;
-		vf->vring[i].ready = 0;
-		vf->vring[i].cb.callback = NULL;
-		vf->vring[i].cb.private = NULL;
-	}
-
-	ifcvf_reset(vf);
-}
-
 static struct ifcvf_adapter *vdpa_to_adapter(struct vdpa_device *vdpa_dev)
 {
 	return container_of(vdpa_dev, struct ifcvf_adapter, vdpa);
@@ -426,7 +379,7 @@ static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
 	u64 features;
 
 	if (type == VIRTIO_ID_NET || type == VIRTIO_ID_BLOCK)
-		features = ifcvf_get_features(vf);
+		features = ifcvf_get_device_features(vf);
 	else {
 		features = 0;
 		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
@@ -444,7 +397,7 @@ static int ifcvf_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 feat
 	if (ret)
 		return ret;
 
-	vf->req_features = features;
+	ifcvf_set_features(vf, features);
 
 	return 0;
 }
@@ -453,7 +406,7 @@ static u64 ifcvf_vdpa_get_driver_features(struct vdpa_device *vdpa_dev)
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return vf->req_features;
+	return ifcvf_get_features(vf);
 }
 
 static u8 ifcvf_vdpa_get_status(struct vdpa_device *vdpa_dev)
@@ -486,11 +439,6 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 			ifcvf_set_status(vf, status);
 			return;
 		}
-
-		if (ifcvf_start_datapath(adapter) < 0)
-			IFCVF_ERR(adapter->pdev,
-				  "Failed to set ifcvf vdpa  status %u\n",
-				  status);
 	}
 
 	ifcvf_set_status(vf, status);
@@ -509,12 +457,10 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
 	if (status_old == 0)
 		return 0;
 
-	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
-		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter);
-	}
+	ifcvf_stop_hw(vf);
+	ifcvf_free_irq(adapter);
 
-	ifcvf_reset_vring(adapter);
+	ifcvf_reset(vf);
 
 	return 0;
 }
@@ -554,14 +500,17 @@ static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	vf->vring[qid].ready = ready;
+	ifcvf_set_vq_ready(vf, qid, ready);
 }
 
 static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	bool ready;
+
+	ready = ifcvf_get_vq_ready(vf, qid);
 
-	return vf->vring[qid].ready;
+	return ready;
 }
 
 static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
@@ -569,7 +518,7 @@ static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	vf->vring[qid].size = num;
+	ifcvf_set_vq_num(vf, qid, num);
 }
 
 static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
@@ -578,11 +527,7 @@ static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	vf->vring[qid].desc = desc_area;
-	vf->vring[qid].avail = driver_area;
-	vf->vring[qid].used = device_area;
-
-	return 0;
+	return ifcvf_set_vq_address(vf, qid, desc_area, driver_area, device_area);
 }
 
 static void ifcvf_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
-- 
2.31.1

