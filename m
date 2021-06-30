Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FE53B7EF7
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 10:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhF3Ia0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 04:30:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:52728 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233554AbhF3IaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 04:30:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="208131948"
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="208131948"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:27:56 -0700
X-IronPort-AV: E=Sophos;i="5.83,311,1616482800"; 
   d="scan'208";a="419912843"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 01:27:54 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 1/3] vDPA/ifcvf: introduce get_dev_type() which returns virtio dev id
Date:   Wed, 30 Jun 2021 16:21:43 +0800
Message-Id: <20210630082145.5729-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210630082145.5729-1-lingshan.zhu@intel.com>
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new function get_dev_type() which returns
the virtio device id of a device, to avoid duplicated code.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 34 ++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index bc1d59f316d1..5f70ab1283a0 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -442,6 +442,26 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
 };
 
+static u32 get_dev_type(struct pci_dev *pdev)
+{
+	u32 dev_type;
+
+	/* This drirver drives both modern virtio devices and transitional
+	 * devices in modern mode.
+	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
+	 * so legacy devices and transitional devices in legacy
+	 * mode will not work for vDPA, this driver will not
+	 * drive devices with legacy interface.
+	 */
+
+	if (pdev->device < 0x1040)
+		dev_type =  pdev->subsystem_device;
+	else
+		dev_type =  pdev->device - 0x1040;
+
+	return dev_type;
+}
+
 static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
@@ -486,19 +506,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_drvdata(pdev, adapter);
 
 	vf = &adapter->vf;
-
-	/* This drirver drives both modern virtio devices and transitional
-	 * devices in modern mode.
-	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
-	 * so legacy devices and transitional devices in legacy
-	 * mode will not work for vDPA, this driver will not
-	 * drive devices with legacy interface.
-	 */
-	if (pdev->device < 0x1040)
-		vf->dev_type =  pdev->subsystem_device;
-	else
-		vf->dev_type =  pdev->device - 0x1040;
-
+	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
 
 	adapter->pdev = pdev;
-- 
2.27.0

