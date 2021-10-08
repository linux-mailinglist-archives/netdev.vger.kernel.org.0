Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C67426817
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbhJHKn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:43:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:45107 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239820AbhJHKnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 06:43:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="213622805"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="213622805"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478934493"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 03:41:54 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kubakici@wp.pl>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next 4/4] ice: support dry run of a flash update to validate firmware file
Date:   Fri,  8 Oct 2021 03:41:15 -0700
Message-Id: <20211008104115.1327240-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
In-Reply-To: <20211008104115.1327240-1-jacob.e.keller@intel.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that devlink core flash update can handle dry run requests, update
the ice driver to allow validating a PLDM file in dry_run mode.

First, add a new dry_run field to the pldmfw context structure. This
indicates that the PLDM firmware file library should only validate the
file and verify that it has a matching record. Update the pldmfw
documentation to indicate this "dry run" mode.

In the ice driver, let the stack know that we support the dry run
attribute for flash update by setting the appropriate bit in the
.supported_flash_update_params field.

If the dry run is requested, notify the PLDM firmware library by setting
the context bit appropriately. Don't cancel a pending update during
a dry run.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/driver-api/pldmfw/index.rst      | 10 ++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 15 +++++++++++----
 include/linux/pldmfw.h                         |  5 +++++
 lib/pldmfw/pldmfw.c                            | 12 ++++++++++++
 5 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/driver-api/pldmfw/index.rst b/Documentation/driver-api/pldmfw/index.rst
index ad2c33ece30f..454b3ed6576a 100644
--- a/Documentation/driver-api/pldmfw/index.rst
+++ b/Documentation/driver-api/pldmfw/index.rst
@@ -51,6 +51,16 @@ unaligned access of multi-byte fields, and to properly convert from Little
 Endian to CPU host format. Additionally the records, descriptors, and
 components are stored in linked lists.
 
+Validating a PLDM firmware file
+===============================
+
+To simply validate a PLDM firmware file, and verify whether it applies to
+the device, set the ``dry_run`` flag in the ``pldmfw`` context structure.
+If this flag is set, the library will parse the file, validating its UUID
+and checking if any record matches the device. Note that in a dry run, the
+library will *not* issue any ops besides ``match_record``. It will not
+attempt to send the component table or package data to the device firmware.
+
 Performing a flash update
 =========================
 
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index f023e862dbf1..cdf4ad4aa437 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -372,7 +372,8 @@ static int ice_devlink_info_get(struct devlink *devlink,
 }
 
 static const struct devlink_ops ice_devlink_ops = {
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK |
+					 DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN,
 	.info_get = ice_devlink_info_get,
 	.flash_update = ice_devlink_flash_update,
 };
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 436f71a8e8aa..d1ca4dc0dd10 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -783,11 +783,15 @@ int ice_devlink_flash_update(struct devlink *devlink,
 
 	priv.context.ops = &ice_fwu_ops;
 	priv.context.dev = dev;
+	priv.context.dry_run = params->dry_run;
 	priv.extack = extack;
 	priv.pf = pf;
 	priv.activate_flags = preservation;
 
-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
+	if (params->dry_run)
+		devlink_flash_update_status_notify(devlink, "Validating flash binary", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
 
 	status = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (status) {
@@ -798,9 +802,12 @@ int ice_devlink_flash_update(struct devlink *devlink,
 		return -EIO;
 	}
 
-	err = ice_cancel_pending_update(pf, NULL, extack);
-	if (err)
-		goto out_release_nvm;
+	/* Do not cancel a previous flash update if this is a dry run */
+	if (!params->dry_run) {
+		err = ice_cancel_pending_update(pf, NULL, extack);
+		if (err)
+			goto out_release_nvm;
+	}
 
 	err = pldmfw_flash_image(&priv.context, params->fw);
 	if (err == -ENOENT) {
diff --git a/include/linux/pldmfw.h b/include/linux/pldmfw.h
index 0fc831338226..d9add301582b 100644
--- a/include/linux/pldmfw.h
+++ b/include/linux/pldmfw.h
@@ -124,10 +124,15 @@ struct pldmfw_ops;
  * should embed this in a private structure and use container_of to obtain
  * a pointer to their own data, used to implement the device specific
  * operations.
+ *
+ * @ops: function pointers used as callbacks from the PLDMFW library
+ * @dev: pointer to the device being updated
+ * @dry_run: if true, only validate the file, do not perform an update.
  */
 struct pldmfw {
 	const struct pldmfw_ops *ops;
 	struct device *dev;
+	bool dry_run;
 };
 
 bool pldmfw_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record);
diff --git a/lib/pldmfw/pldmfw.c b/lib/pldmfw/pldmfw.c
index 6e77eb6d8e72..29a132a39876 100644
--- a/lib/pldmfw/pldmfw.c
+++ b/lib/pldmfw/pldmfw.c
@@ -827,6 +827,10 @@ static int pldm_finalize_update(struct pldmfw_priv *data)
  * to the device firmware. Extract and write the flash data for each of the
  * components indicated in the firmware file.
  *
+ * If the context->dry_run is set, this is a request for a dry run, i.e. to
+ * only validate the PLDM firmware file. In this case, stop and exit after we
+ * find a valid matching record.
+ *
  * Returns: zero on success, or a negative error code on failure.
  */
 int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
@@ -844,14 +848,22 @@ int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
 	data->fw = fw;
 	data->context = context;
 
+	/* Parse the image and make sure it is a valid PLDM firmware binary */
 	err = pldm_parse_image(data);
 	if (err)
 		goto out_release_data;
 
+	/* Search for a record matching the device */
 	err = pldm_find_matching_record(data);
 	if (err)
 		goto out_release_data;
 
+	/* If this is a dry run, do not perform an update */
+	if (context->dry_run)
+		goto out_release_data;
+
+	/* Perform the device update */
+
 	err = pldm_send_package_data(data);
 	if (err)
 		goto out_release_data;
-- 
2.31.1.331.gb0c09ab8796f

