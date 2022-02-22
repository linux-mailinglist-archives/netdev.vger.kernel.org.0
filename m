Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF624BF7AC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 13:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiBVMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 07:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiBVMC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 07:02:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348AEC4289
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 04:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645531320; x=1677067320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCxJIQOwRYPK4xuIjQZtMjD1ZTaAQgwz8r39Lsxd1FQ=;
  b=JJTBXhklVE3DZDDsLxaDH+yxGXKjeIyai9t2GwgqIfQNhkYwvosJg5Ee
   Se2Da9kOORQxGIH+8A1VfGPLGeyRJtUneGSWq6q22Xe3ICPMxSeanyYrs
   /j7vVHkt1csBabLM/t6aMMjAKmVBPKmrF42bOLt9/8E7ITFgIhKMkWCzF
   fqfteUMmQTISk1shSZTIXv6sMh+Fdr2p9kbILV0TyHDE6YAFqWCana9uA
   Kd9BloIQ5IQCdEPpmQlbd28Yk7dHi3t8UEy+iwNQBHroIaZmUrv/K5UXI
   545uunK9Kh5eFVWjUs3V7s5c7WtTIiO7HdjKYiuKjEzg6sucLdTJnlrXy
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="338117833"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="338117833"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:01:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="490772569"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.193.73])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 04:01:57 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V6 1/5] vDPA/ifcvf: make use of virtio pci modern IO helpers in ifcvf
Date:   Tue, 22 Feb 2022 19:54:24 +0800
Message-Id: <20220222115428.998334-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220222115428.998334-1-lingshan.zhu@intel.com>
References: <20220222115428.998334-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit discards ifcvf_ioreadX()/writeX(), use virtio pci
modern IO helpers instead

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 104 +++++++++++---------------------
 drivers/vdpa/ifcvf/ifcvf_base.h |   1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |   2 +-
 3 files changed, 36 insertions(+), 71 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 7d41dfe48ade..b9fdc5258611 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -10,42 +10,6 @@
 
 #include "ifcvf_base.h"
 
-static inline u8 ifc_ioread8(u8 __iomem *addr)
-{
-	return ioread8(addr);
-}
-static inline u16 ifc_ioread16 (__le16 __iomem *addr)
-{
-	return ioread16(addr);
-}
-
-static inline u32 ifc_ioread32(__le32 __iomem *addr)
-{
-	return ioread32(addr);
-}
-
-static inline void ifc_iowrite8(u8 value, u8 __iomem *addr)
-{
-	iowrite8(value, addr);
-}
-
-static inline void ifc_iowrite16(u16 value, __le16 __iomem *addr)
-{
-	iowrite16(value, addr);
-}
-
-static inline void ifc_iowrite32(u32 value, __le32 __iomem *addr)
-{
-	iowrite32(value, addr);
-}
-
-static void ifc_iowrite64_twopart(u64 val,
-				  __le32 __iomem *lo, __le32 __iomem *hi)
-{
-	ifc_iowrite32((u32)val, lo);
-	ifc_iowrite32(val >> 32, hi);
-}
-
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
 {
 	return container_of(hw, struct ifcvf_adapter, vf);
@@ -158,11 +122,11 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		return -EIO;
 	}
 
-	hw->nr_vring = ifc_ioread16(&hw->common_cfg->num_queues);
+	hw->nr_vring = vp_ioread16(&hw->common_cfg->num_queues);
 
 	for (i = 0; i < hw->nr_vring; i++) {
-		ifc_iowrite16(i, &hw->common_cfg->queue_select);
-		notify_off = ifc_ioread16(&hw->common_cfg->queue_notify_off);
+		vp_iowrite16(i, &hw->common_cfg->queue_select);
+		notify_off = vp_ioread16(&hw->common_cfg->queue_notify_off);
 		hw->vring[i].notify_addr = hw->notify_base +
 			notify_off * hw->notify_off_multiplier;
 		hw->vring[i].notify_pa = hw->notify_base_pa +
@@ -181,12 +145,12 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 
 u8 ifcvf_get_status(struct ifcvf_hw *hw)
 {
-	return ifc_ioread8(&hw->common_cfg->device_status);
+	return vp_ioread8(&hw->common_cfg->device_status);
 }
 
 void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
 {
-	ifc_iowrite8(status, &hw->common_cfg->device_status);
+	vp_iowrite8(status, &hw->common_cfg->device_status);
 }
 
 void ifcvf_reset(struct ifcvf_hw *hw)
@@ -214,11 +178,11 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
 	u32 features_lo, features_hi;
 	u64 features;
 
-	ifc_iowrite32(0, &cfg->device_feature_select);
-	features_lo = ifc_ioread32(&cfg->device_feature);
+	vp_iowrite32(0, &cfg->device_feature_select);
+	features_lo = vp_ioread32(&cfg->device_feature);
 
-	ifc_iowrite32(1, &cfg->device_feature_select);
-	features_hi = ifc_ioread32(&cfg->device_feature);
+	vp_iowrite32(1, &cfg->device_feature_select);
+	features_hi = vp_ioread32(&cfg->device_feature);
 
 	features = ((u64)features_hi << 32) | features_lo;
 
@@ -271,12 +235,12 @@ void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
 
 	WARN_ON(offset + length > hw->config_size);
 	do {
-		old_gen = ifc_ioread8(&hw->common_cfg->config_generation);
+		old_gen = vp_ioread8(&hw->common_cfg->config_generation);
 		p = dst;
 		for (i = 0; i < length; i++)
-			*p++ = ifc_ioread8(hw->dev_cfg + offset + i);
+			*p++ = vp_ioread8(hw->dev_cfg + offset + i);
 
-		new_gen = ifc_ioread8(&hw->common_cfg->config_generation);
+		new_gen = vp_ioread8(&hw->common_cfg->config_generation);
 	} while (old_gen != new_gen);
 }
 
@@ -289,18 +253,18 @@ void ifcvf_write_dev_config(struct ifcvf_hw *hw, u64 offset,
 	p = src;
 	WARN_ON(offset + length > hw->config_size);
 	for (i = 0; i < length; i++)
-		ifc_iowrite8(*p++, hw->dev_cfg + offset + i);
+		vp_iowrite8(*p++, hw->dev_cfg + offset + i);
 }
 
 static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
 
-	ifc_iowrite32(0, &cfg->guest_feature_select);
-	ifc_iowrite32((u32)features, &cfg->guest_feature);
+	vp_iowrite32(0, &cfg->guest_feature_select);
+	vp_iowrite32((u32)features, &cfg->guest_feature);
 
-	ifc_iowrite32(1, &cfg->guest_feature_select);
-	ifc_iowrite32(features >> 32, &cfg->guest_feature);
+	vp_iowrite32(1, &cfg->guest_feature_select);
+	vp_iowrite32(features >> 32, &cfg->guest_feature);
 }
 
 static int ifcvf_config_features(struct ifcvf_hw *hw)
@@ -329,7 +293,7 @@ u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid)
 	ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
 	q_pair_id = qid / hw->nr_vring;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
-	last_avail_idx = ifc_ioread16(avail_idx_addr);
+	last_avail_idx = vp_ioread16(avail_idx_addr);
 
 	return last_avail_idx;
 }
@@ -344,7 +308,7 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
 	q_pair_id = qid / hw->nr_vring;
 	avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
 	hw->vring[qid].last_avail_idx = num;
-	ifc_iowrite16(num, avail_idx_addr);
+	vp_iowrite16(num, avail_idx_addr);
 
 	return 0;
 }
@@ -357,9 +321,9 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 
 	ifcvf = vf_to_adapter(hw);
 	cfg = hw->common_cfg;
-	ifc_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
+	vp_iowrite16(IFCVF_MSI_CONFIG_OFF, &cfg->msix_config);
 
-	if (ifc_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
+	if (vp_ioread16(&cfg->msix_config) == VIRTIO_MSI_NO_VECTOR) {
 		IFCVF_ERR(ifcvf->pdev, "No msix vector for device config\n");
 		return -EINVAL;
 	}
@@ -368,17 +332,17 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 		if (!hw->vring[i].ready)
 			break;
 
-		ifc_iowrite16(i, &cfg->queue_select);
-		ifc_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
+		vp_iowrite16(i, &cfg->queue_select);
+		vp_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
 				     &cfg->queue_desc_hi);
-		ifc_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
+		vp_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
 				      &cfg->queue_avail_hi);
-		ifc_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
+		vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
 				     &cfg->queue_used_hi);
-		ifc_iowrite16(hw->vring[i].size, &cfg->queue_size);
-		ifc_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
+		vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
+		vp_iowrite16(i + IFCVF_MSI_QUEUE_OFF, &cfg->queue_msix_vector);
 
-		if (ifc_ioread16(&cfg->queue_msix_vector) ==
+		if (vp_ioread16(&cfg->queue_msix_vector) ==
 		    VIRTIO_MSI_NO_VECTOR) {
 			IFCVF_ERR(ifcvf->pdev,
 				  "No msix vector for queue %u\n", i);
@@ -386,7 +350,7 @@ static int ifcvf_hw_enable(struct ifcvf_hw *hw)
 		}
 
 		ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
-		ifc_iowrite16(1, &cfg->queue_enable);
+		vp_iowrite16(1, &cfg->queue_enable);
 	}
 
 	return 0;
@@ -398,14 +362,14 @@ static void ifcvf_hw_disable(struct ifcvf_hw *hw)
 	u32 i;
 
 	cfg = hw->common_cfg;
-	ifc_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
+	vp_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->msix_config);
 
 	for (i = 0; i < hw->nr_vring; i++) {
-		ifc_iowrite16(i, &cfg->queue_select);
-		ifc_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
+		vp_iowrite16(i, &cfg->queue_select);
+		vp_iowrite16(VIRTIO_MSI_NO_VECTOR, &cfg->queue_msix_vector);
 	}
 
-	ifc_ioread16(&cfg->queue_msix_vector);
+	vp_ioread16(&cfg->queue_msix_vector);
 }
 
 int ifcvf_start_hw(struct ifcvf_hw *hw)
@@ -433,5 +397,5 @@ void ifcvf_stop_hw(struct ifcvf_hw *hw)
 
 void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
 {
-	ifc_iowrite16(qid, hw->vring[qid].notify_addr);
+	vp_iowrite16(qid, hw->vring[qid].notify_addr);
 }
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index c486873f370a..25c591a3eae2 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -14,6 +14,7 @@
 #include <linux/pci.h>
 #include <linux/pci_regs.h>
 #include <linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 #include <uapi/linux/virtio_net.h>
 #include <uapi/linux/virtio_blk.h>
 #include <uapi/linux/virtio_config.h>
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d1a6b5ab543c..43b7180256c6 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -348,7 +348,7 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
 {
 	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return ioread8(&vf->common_cfg->config_generation);
+	return vp_ioread8(&vf->common_cfg->config_generation);
 }
 
 static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
-- 
2.27.0

