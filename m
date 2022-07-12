Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E2B572167
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiGLQvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiGLQvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:51:32 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADECC54B5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657644691; x=1689180691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iI0l54A7R9llgvnm7L0mzDpqUmsJ9SPeenZoYVICBv4=;
  b=kJJvKjs59khY3aeIzFGrKdyCdihgB8N5+braJq8aHqcnWH2CYz3SJyo4
   Te/mfQU0jCatsjJ79t2dX+wCkqv2hd7cGUE8leJyy8SjjMR2fi9eIFY3P
   l2Itrvk6nNXHg2AZbsTA5OuVAzryEfjTAGmuOUCiZ+gNuccGEYfEHJ5h0
   /lV3ukph+9+6QGhOIEK9+GKjxugILwHZlOY9uc5XDS8miNtgBrnbiq2gy
   ZMSMk0c2Qjp8InHDQQcOsYCpW+YbKSYFs2WgnrNHKJp5oKWKExeqtl4RF
   PjbGJ2Oq/VneSeBi+Zpbrh/dE5DwGuzLV2WnyXKx6LeV41gSa10k6UfWX
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285014500"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285014500"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 09:51:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="841447052"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jul 2022 09:51:30 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/2] ice: handle E822 generic device ID in PLDM header
Date:   Tue, 12 Jul 2022 09:48:28 -0700
Message-Id: <20220712164829.7275-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
References: <20220712164829.7275-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

The driver currently presumes that the record data in the PLDM header
of the firmware image will match the device ID of the running device.
This is true for E810 devices. It appears that for E822 devices that
this is not guaranteed to be true.

Fix this by adding a check for the generic E822 device.

Fixes: d69ea414c9b4 ("ice: implement device flash update via devlink")
Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devids.h   |  1 +
 .../net/ethernet/intel/ice/ice_fw_update.c    | 96 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devids.h b/drivers/net/ethernet/intel/ice/ice_devids.h
index 61dd2f18dee8..b41bc3dc1745 100644
--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@ -5,6 +5,7 @@
 #define _ICE_DEVIDS_H_
 
 /* Device IDs */
+#define ICE_DEV_ID_E822_SI_DFLT         0x1888
 /* Intel(R) Ethernet Connection E823-L for backplane */
 #define ICE_DEV_ID_E823L_BACKPLANE	0x124C
 /* Intel(R) Ethernet Connection E823-L for SFP */
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 665a344fb9c0..3dc5662d62a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -736,7 +736,87 @@ static int ice_finalize_update(struct pldmfw *context)
 	return 0;
 }
 
-static const struct pldmfw_ops ice_fwu_ops = {
+struct ice_pldm_pci_record_id {
+	u32 vendor;
+	u32 device;
+	u32 subsystem_vendor;
+	u32 subsystem_device;
+};
+
+/**
+ * ice_op_pci_match_record - Check if a PCI device matches the record
+ * @context: PLDM fw update structure
+ * @record: list of records extracted from the PLDM image
+ *
+ * Determine if the PCI device associated with this device matches the record
+ * data provided.
+ *
+ * Searches the descriptor TLVs and extracts the relevant descriptor data into
+ * a pldm_pci_record_id. This is then compared against the PCI device ID
+ * information.
+ *
+ * Returns: true if the device matches the record, false otherwise.
+ */
+static bool
+ice_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record)
+{
+	struct pci_dev *pdev = to_pci_dev(context->dev);
+	struct ice_pldm_pci_record_id id = {
+		.vendor = PCI_ANY_ID,
+		.device = PCI_ANY_ID,
+		.subsystem_vendor = PCI_ANY_ID,
+		.subsystem_device = PCI_ANY_ID,
+	};
+	struct pldmfw_desc_tlv *desc;
+
+	list_for_each_entry(desc, &record->descs, entry) {
+		u16 value;
+		int *ptr;
+
+		switch (desc->type) {
+		case PLDM_DESC_ID_PCI_VENDOR_ID:
+			ptr = &id.vendor;
+			break;
+		case PLDM_DESC_ID_PCI_DEVICE_ID:
+			ptr = &id.device;
+			break;
+		case PLDM_DESC_ID_PCI_SUBVENDOR_ID:
+			ptr = &id.subsystem_vendor;
+			break;
+		case PLDM_DESC_ID_PCI_SUBDEV_ID:
+			ptr = &id.subsystem_device;
+			break;
+		default:
+			/* Skip unrelated TLVs */
+			continue;
+		}
+
+		value = get_unaligned_le16(desc->data);
+		/* A value of zero for one of the descriptors is sometimes
+		 * used when the record should ignore this field when matching
+		 * device. For example if the record applies to any subsystem
+		 * device or vendor.
+		 */
+		if (value)
+			*ptr = value;
+		else
+			*ptr = PCI_ANY_ID;
+	}
+
+	/* the E822 device can have a generic device ID so check for that */
+	if ((id.vendor == PCI_ANY_ID || id.vendor == pdev->vendor) &&
+	    (id.device == PCI_ANY_ID || id.device == pdev->device ||
+	    id.device == ICE_DEV_ID_E822_SI_DFLT) &&
+	    (id.subsystem_vendor == PCI_ANY_ID ||
+	    id.subsystem_vendor == pdev->subsystem_vendor) &&
+	    (id.subsystem_device == PCI_ANY_ID ||
+	    id.subsystem_device == pdev->subsystem_device))
+		return true;
+
+	return false;
+}
+
+static const struct pldmfw_ops ice_fwu_ops_e810 = {
 	.match_record = &pldmfw_op_pci_match_record,
 	.send_package_data = &ice_send_package_data,
 	.send_component_table = &ice_send_component_table,
@@ -744,6 +824,14 @@ static const struct pldmfw_ops ice_fwu_ops = {
 	.finalize_update = &ice_finalize_update,
 };
 
+static const struct pldmfw_ops ice_fwu_ops_e822 = {
+	.match_record = &ice_op_pci_match_record,
+	.send_package_data = &ice_send_package_data,
+	.send_component_table = &ice_send_component_table,
+	.flash_component = &ice_flash_component,
+	.finalize_update = &ice_finalize_update,
+};
+
 /**
  * ice_get_pending_updates - Check if the component has a pending update
  * @pf: the PF driver structure
@@ -921,7 +1009,11 @@ int ice_devlink_flash_update(struct devlink *devlink,
 
 	memset(&priv, 0, sizeof(priv));
 
-	priv.context.ops = &ice_fwu_ops;
+	/* the E822 device needs a slightly different ops */
+	if (hw->mac_type == ICE_MAC_GENERIC)
+		priv.context.ops = &ice_fwu_ops_e822;
+	else
+		priv.context.ops = &ice_fwu_ops_e810;
 	priv.context.dev = dev;
 	priv.extack = extack;
 	priv.pf = pf;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..ff2eac2f8c64 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5413,6 +5413,7 @@ static const struct pci_device_id ice_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_10G_BASE_T), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_1GBE), 0 },
 	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E823L_QSFP), 0 },
+	{ PCI_VDEVICE(INTEL, ICE_DEV_ID_E822_SI_DFLT), 0 },
 	/* required last entry */
 	{ 0, }
 };
-- 
2.35.1

