Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A155A363B9C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 08:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbhDSGj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 02:39:26 -0400
Received: from mga12.intel.com ([192.55.52.136]:32762 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhDSGjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 02:39:24 -0400
IronPort-SDR: oVT9q37GsCqzuPPb+kzTNPvUNw0gm3uPWLZaRwtqIFeCPLaI/s65gueBCenRX6J+/3becEebaQ
 4rgyjyRdUkZA==
X-IronPort-AV: E=McAfee;i="6200,9189,9958"; a="174766096"
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="174766096"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:55 -0700
IronPort-SDR: yqwS8lMV8URXbMYC3Wo7Ip/2IbOv/etlP1Gpu+7MnKiv92pdiLbBRT/EUY9FB+FHNN/UD+a5EB
 uP8btBrpMx/A==
X-IronPort-AV: E=Sophos;i="5.82,233,1613462400"; 
   d="scan'208";a="523328535"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2021 23:38:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
Date:   Mon, 19 Apr 2021 14:33:24 +0800
Message-Id: <20210419063326.3748-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210419063326.3748-1-lingshan.zhu@intel.com>
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit deduces VIRTIO device ID as device type when probe,
then ifcvf_vdpa_get_device_id() can simply return the ID.
ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
can work properly based on the device ID.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 27 +++++++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index b2eeb16b9c2c..1c04cd256fa7 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -84,6 +84,7 @@ struct ifcvf_hw {
 	u32 notify_off_multiplier;
 	u64 req_features;
 	u64 hw_features;
+	u32 dev_type;
 	struct virtio_pci_common_cfg __iomem *common_cfg;
 	void __iomem *net_cfg;
 	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 44d7586019da..66927ec81fa5 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -323,19 +323,9 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
 
 static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
 {
-	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
-	struct pci_dev *pdev = adapter->pdev;
-	u32 ret = -ENODEV;
-
-	if (pdev->device < 0x1000 || pdev->device > 0x107f)
-		return ret;
-
-	if (pdev->device < 0x1040)
-		ret =  pdev->subsystem_device;
-	else
-		ret =  pdev->device - 0x1040;
+	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
 
-	return ret;
+	return vf->dev_type;
 }
 
 static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
@@ -466,6 +456,19 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, adapter);
 
 	vf = &adapter->vf;
+
+	/* This drirver drives both modern virtio devices and transitional
+	 * devices in modern mode.
+	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
+	 * so legacy devices and transitional devices in legacy
+	 * mode will not work for vDPA, this driver will not
+	 * drive devices with legacy interface.
+	 */
+	if (pdev->device < 0x1040)
+		vf->dev_type =  pdev->subsystem_device;
+	else
+		vf->dev_type =  pdev->device - 0x1040;
+
 	vf->base = pcim_iomap_table(pdev);
 
 	adapter->pdev = pdev;
-- 
2.27.0

