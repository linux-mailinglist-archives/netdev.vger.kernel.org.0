Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B870D361A76
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhDPHWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:22:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:57485 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239271AbhDPHWT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 03:22:19 -0400
IronPort-SDR: Q8B0mcEvdamP3GM8JEItiRNr9+l1y29W0EofoNV4MaG9GG/VGBia7PIigR77wm94auoUUxd6WB
 AogCuaob85lw==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194561079"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="194561079"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:54 -0700
IronPort-SDR: YxBEh6f2rL3mPk8q3sL17v5+jSORbc1CvFcIZN+b3TxhkMs7s2tdxkY+p5MV/daZ1eh0gfkC+3
 Us8l6ew9kWfA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="425489762"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:49 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
Date:   Fri, 16 Apr 2021 15:16:26 +0800
Message-Id: <20210416071628.4984-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210416071628.4984-1-lingshan.zhu@intel.com>
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 30 ++++++++++++++++++------------
 2 files changed, 19 insertions(+), 12 deletions(-)

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
index 44d7586019da..469a9b5737b7 100644
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
@@ -466,6 +456,22 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
+	if (pdev->device < 0x1000 || pdev->device > 0x107f)
+		return -EOPNOTSUPP;
+
+	if (pdev->device < 0x1040)
+		vf->dev_type =  pdev->subsystem_device;
+	else
+		vf->dev_type =  pdev->device - 0x1040;
+
 	vf->base = pcim_iomap_table(pdev);
 
 	adapter->pdev = pdev;
-- 
2.27.0

