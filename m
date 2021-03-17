Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B73D33ED95
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhCQJzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:55:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:59767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCQJzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 05:55:00 -0400
IronPort-SDR: fR03KbjV13NNCytzBp8PFgiMglJRMi18ZhbG8pJF2p59rLD0qK2Rtl8W1Mj4p5uMiuhQwzOXAl
 CEK1M/eX3XUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="187058688"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="187058688"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:55:00 -0700
IronPort-SDR: Vmg6AY6wcKfV0IP8X/tKaUCRiI5QvL5En6PUE7mhrFwzJ4SCIf0nbIezjQndaH42xvwzLxYryT
 R0h7yv8ejGCw==
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="405873255"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 02:54:57 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V5 7/7] vDPA/ifcvf: deduce VIRTIO device ID from pdev ids
Date:   Wed, 17 Mar 2021 17:49:33 +0800
Message-Id: <20210317094933.16417-8-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317094933.16417-1-lingshan.zhu@intel.com>
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit deduces the VIRTIO device ID of a probed
device from its pdev device ids.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

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
index ea93ea7fd5df..9fade400b5a4 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -323,7 +323,19 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
 
 static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
 {
-	return VIRTIO_ID_NET;
+	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
+	struct pci_dev *pdev = adapter->pdev;
+	u32 ret = -ENODEV;
+
+	if (pdev->device < 0x1000 || pdev->device > 0x107f)
+		return ret;
+
+	if (pdev->device < 0x1040)
+		ret =  pdev->subsystem_device;
+	else
+		ret =  pdev->device - 0x1040;
+
+	return ret;
 }
 
 static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
-- 
2.27.0

