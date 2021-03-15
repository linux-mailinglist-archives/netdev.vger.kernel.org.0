Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F7233ACAD
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhCOHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhCOHu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:27 -0400
IronPort-SDR: E6ZcQd2AeiYokttGZtsmCsaUYJhcn8LZ0pjS8KGD0vvZwDj598OmYN9VF+imgVtrxYmOcyv1YL
 iI9SEOD2sDig==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140915"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140915"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:27 -0700
IronPort-SDR: sCnalsKjF+T8HClMQVCLr4/WHqXjz3Daz9sYCCJ53e72nYthWf+DLaFgDnI4yZLjAQjfVhR3RG
 6Diem+Z5EDmQ==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752272"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:24 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 5/7] vDPA/ifcvf: fetch device feature bits when probe
Date:   Mon, 15 Mar 2021 15:44:59 +0800
Message-Id: <20210315074501.15868-6-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315074501.15868-1-lingshan.zhu@intel.com>
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit would read and store device feature
bits when probe.

rename ifcvf_get_features() to ifcvf_get_hw_features(),
it reads and stores features of the probed device.

new ifcvf_get_features() simply returns stored
feature bits.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c |  2 ++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index f2a128e56de5..ea6a78791c9b 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -202,10 +202,11 @@ static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
 	ifcvf_get_status(hw);
 }
 
-u64 ifcvf_get_features(struct ifcvf_hw *hw)
+u64 ifcvf_get_hw_features(struct ifcvf_hw *hw)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
 	u32 features_lo, features_hi;
+	u64 features;
 
 	ifc_iowrite32(0, &cfg->device_feature_select);
 	features_lo = ifc_ioread32(&cfg->device_feature);
@@ -213,7 +214,14 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
 	ifc_iowrite32(1, &cfg->device_feature_select);
 	features_hi = ifc_ioread32(&cfg->device_feature);
 
-	return ((u64)features_hi << 32) | features_lo;
+	features = ((u64)features_hi << 32) | features_lo;
+
+	return features;
+}
+
+u64 ifcvf_get_features(struct ifcvf_hw *hw)
+{
+	return hw->hw_features;
 }
 
 void ifcvf_read_net_config(struct ifcvf_hw *hw, u64 offset,
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index 794d1505d857..dbb8c10aa3b1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -83,6 +83,7 @@ struct ifcvf_hw {
 	void __iomem *notify_base;
 	u32 notify_off_multiplier;
 	u64 req_features;
+	u64 hw_features;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *net_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
@@ -121,6 +122,7 @@ void ifcvf_set_status(struct ifcvf_hw *hw, u8 status);
 void io_write64_twopart(u64 val, u32 *lo, u32 *hi);
 void ifcvf_reset(struct ifcvf_hw *hw);
 u64 ifcvf_get_features(struct ifcvf_hw *hw);
+u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index c34e1eec6b6c..25fb9dfe23f0 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -458,6 +458,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++)
 		vf->vring[i].irq = -EINVAL;
 
+	vf->hw_features = ifcvf_get_hw_features(vf);
+
 	ret = vdpa_register_device(&adapter->vdpa);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to register ifcvf to vdpa bus");
-- 
2.27.0

