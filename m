Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1D157D5AC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiGUVP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbiGUVP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:15:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1873258871;
        Thu, 21 Jul 2022 14:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658438125; x=1689974125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+b/gLo/Ell1uZ35XWmJYCy+/hdv/bRLcSSge8oMH/lY=;
  b=eUcdKYkTq73QXd4Rk4SPvNUuRww/oBoZ85a48yEHRnq0ncvwKnQC2+zf
   0gN7qACFIT2mucDdGNzrKtWdpdpHhbzLrnOhPDGK01TfUXZLrU5Ds+tGO
   DzqmIIoO9YcQUAF8ZJvy5xrX56tR8ssKDTAnQyIGI2JmOlRTuaEFanfvN
   7NMjtbCA5oPCcksH4h3RMZxGiyIOSCanrR+J6vhHgs/6FdSOTojP1EOWL
   fm3PqZQROZJvJTMfDN8Ya2YoDAGqsLTqs6bTbmnM+57zqnhy2MVjK4qdl
   jQ+yyKjcAF5iEyfXswSnhVezqmr6ZXoswtzVokF3LhJ3qXdlqMR3lokZQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312892768"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312892768"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:59 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925816194"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:59 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [net-next v2 2/2] ice: support dry run of a flash update to validate firmware file
Date:   Thu, 21 Jul 2022 14:14:47 -0700
Message-Id: <20220721211451.2475600-3-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
In-Reply-To: <20220721211451.2475600-1-jacob.e.keller@intel.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Changes since v1:
* Use u8 : 1 instead of bool in structure
* Name the PLDMFW parameter validate

 Documentation/driver-api/pldmfw/index.rst      | 10 ++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 14 ++++++++++----
 include/linux/pldmfw.h                         |  5 +++++
 lib/pldmfw/pldmfw.c                            | 12 ++++++++++++
 5 files changed, 39 insertions(+), 5 deletions(-)

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
index 3337314a7b35..18214ea33e2d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -467,7 +467,8 @@ ice_devlink_reload_empr_finish(struct devlink *devlink,
 }
 
 static const struct devlink_ops ice_devlink_ops = {
-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK |
+					 DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN,
 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	/* The ice driver currently does not support driver reinit */
 	.reload_down = ice_devlink_reload_empr_start,
diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 3dc5662d62a6..d79e4536b440 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -1015,15 +1015,21 @@ int ice_devlink_flash_update(struct devlink *devlink,
 	else
 		priv.context.ops = &ice_fwu_ops_e810;
 	priv.context.dev = dev;
+	priv.context.validate = params->dry_run;
 	priv.extack = extack;
 	priv.pf = pf;
 	priv.activate_flags = preservation;
 
-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
+	if (params->dry_run)
+		devlink_flash_update_status_notify(devlink, "Validating flash binary", NULL, 0, 0);
+	else
+		devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
 
-	err = ice_cancel_pending_update(pf, NULL, extack);
-	if (err)
-		return err;
+	if (!params->dry_run) {
+		err = ice_cancel_pending_update(pf, NULL, extack);
+		if (err)
+			return err;
+	}
 
 	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
 	if (err) {
diff --git a/include/linux/pldmfw.h b/include/linux/pldmfw.h
index 0fc831338226..3e221c5e24cb 100644
--- a/include/linux/pldmfw.h
+++ b/include/linux/pldmfw.h
@@ -124,10 +124,15 @@ struct pldmfw_ops;
  * should embed this in a private structure and use container_of to obtain
  * a pointer to their own data, used to implement the device specific
  * operations.
+ *
+ * @ops: function pointers used as callbacks from the PLDMFW library
+ * @dev: pointer to the device being updated
+ * @validate: if true, only validate the file, do not perform an update.
  */
 struct pldmfw {
 	const struct pldmfw_ops *ops;
 	struct device *dev;
+	u8 validate : 1;
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
2.35.1.456.ga9c7032d4631

