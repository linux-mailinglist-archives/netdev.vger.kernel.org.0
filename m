Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8133ACC0
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCOHvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:51:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230317AbhCOHuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:32 -0400
IronPort-SDR: oNzYdUtITSWApQ554VoLggiRt6QdBQx2Be1+Y3XmtMnfwcjCB2dcAn5z8TTGbiI/RCQWRx/daN
 MgvsG8lDxAog==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140923"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140923"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:32 -0700
IronPort-SDR: +9Q21han6dQBQG1c6SItlm7RiSxAIsJJ7FPClazqAU/k71YTQXjSx0cavpkg10uwTgN340KqtI
 AeEFDL6jozKg==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752322"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:30 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 7/7] vDPA/ifcvf: deduce VIRTIO device ID from pdev ids
Date:   Mon, 15 Mar 2021 15:45:01 +0800
Message-Id: <20210315074501.15868-8-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315074501.15868-1-lingshan.zhu@intel.com>
References: <20210315074501.15868-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit checks the device ids from pdev, then deduce
VIRTIO device ID from the probed device.

Here we checks all four device ids than only subsystem_device_id,
help detecting a certain device for furture enabling.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.c | 42 +++++++++++++++++++++++++++++++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |  8 ++++++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 4f257c4b2f76..1a6ad7a11f16 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -408,3 +408,45 @@ void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
 {
 	ifc_iowrite16(qid, hw->vring[qid].notify_addr);
 }
+
+static int ifcvf_probed_N3000(struct pci_dev *pdev)
+{
+	int ret = false;
+
+	if (pdev->device == N3000_DEVICE_ID &&
+	    pdev->vendor == N3000_VENDOR_ID &&
+	    pdev->subsystem_device == N3000_SUBSYS_DEVICE_ID &&
+	    pdev->subsystem_vendor == N3000_SUBSYS_VENDOR_ID)
+		ret = true;
+
+	return ret;
+}
+
+static int ifcvf_probed_C5000X_PL(struct pci_dev *pdev)
+{
+	int ret = false;
+
+	if (pdev->device == C5000X_PL_DEVICE_ID &&
+	    pdev->vendor == C5000X_PL_VENDOR_ID &&
+	    pdev->subsystem_device == C5000X_PL_SUBSYS_DEVICE_ID &&
+	    pdev->subsystem_vendor == C5000X_PL_SUBSYS_VENDOR_ID)
+		ret = true;
+
+	return ret;
+}
+
+int ifcvf_probed_virtio_net(struct ifcvf_hw *hw)
+{
+	struct ifcvf_adapter *adapter;
+	struct pci_dev *pdev;
+	int ret = false;
+
+	adapter = vf_to_adapter(hw);
+	pdev = adapter->pdev;
+
+	if (ifcvf_probed_N3000(pdev) ||
+	    ifcvf_probed_C5000X_PL(pdev))
+		ret = true;
+
+	return ret;
+}
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f77239fc1644..b2eeb16b9c2c 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -127,4 +127,5 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
 u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
 int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
 struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
+int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
 #endif /* _IFCVF_H_ */
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index ea93ea7fd5df..b0787f79dac3 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -323,7 +323,13 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
 
 static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
 {
-	return VIRTIO_ID_NET;
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
+	u32 ret = -EOPNOTSUPP;
+
+	if (ifcvf_probed_virtio_net(vf))
+		ret = VIRTIO_ID_NET;
+
+	return ret;
 }
 
 static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
-- 
2.27.0

