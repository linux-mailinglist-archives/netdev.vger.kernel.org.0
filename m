Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8C3E9CEA
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhHLDbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 23:31:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:65094 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHLDbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 23:31:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="212159228"
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="212159228"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 20:31:07 -0700
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="527545884"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.192.107])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 20:31:03 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RESEND PATCH V3 1/2] vDPA/ifcvf: introduce get_dev_type() which returns virtio dev id
Date:   Thu, 12 Aug 2021 11:24:53 +0800
Message-Id: <20210812032454.24486-2-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210812032454.24486-1-lingshan.zhu@intel.com>
References: <20210812032454.24486-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new function get_dev_type() which returns
the virtio device id of a device, to avoid duplicated code.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/ifcvf/ifcvf_main.c | 34 ++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 21b78f1cd521..b5db114646c1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -458,6 +458,26 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_vq_notification = ifcvf_get_vq_notification,
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
@@ -502,19 +522,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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

