Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635EB27B704
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgI1VaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:30:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:22998 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1VaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 17:30:08 -0400
IronPort-SDR: OmTWHv4UauIaWjYm6z/nbZ20nvSnGD/c+7dGlfh5BLivCN/zX9AwZomIiP+GfLqHSfviHQcvWY
 XD+KJZCKa85w==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="180222306"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="180222306"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:30:07 -0700
IronPort-SDR: h+s1f5TnVQWn+IfbJywgtXwgWkRoEj6o5t9PZTtM2GomZ4bZhA6JyM7Q33lISxVxAH9j48TXm0
 AcCpaPJ7vR1A==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="340559687"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:30:07 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next] ice: use new timeout for devlink flash notify on erasing
Date:   Mon, 28 Sep 2020 14:29:11 -0700
Message-Id: <20200928212911.3369696-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When erasing, notify userspace of how long we will potentially take to
erase a module. This allows for better status reporting, because the
devlink program can display the timeout to the user in case the command
takes more than a few seconds to complete.

Since we're re-using the erase timeout value, make it a macro rather
than a magic number.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 142123155a0f..1ab805873cb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -399,6 +399,11 @@ ice_write_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 	return err;
 }
 
+/* Length in seconds to wait before timing out when erasing a flash module.
+ * Yes, erasing really can take minutes to complete.
+ */
+#define ICE_FW_ERASE_TIMEOUT 300
+
 /**
  * ice_erase_nvm_module - Erase an NVM module and await firmware completion
  * @pf: the PF data structure
@@ -429,7 +434,7 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 
 	devlink = priv_to_devlink(pf);
 
-	devlink_flash_update_status_notify(devlink, "Erasing", component, 0, 0);
+	devlink_flash_update_timeout_notify(devlink, "Erasing", component, ICE_FW_ERASE_TIMEOUT);
 
 	status = ice_aq_erase_nvm(hw, module, NULL);
 	if (status) {
@@ -441,8 +446,7 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 		goto out_notify_devlink;
 	}
 
-	/* Yes, this really can take minutes to complete */
-	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_erase, 300 * HZ, &event);
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_erase, ICE_FW_ERASE_TIMEOUT * HZ, &event);
 	if (err) {
 		dev_err(dev, "Timed out waiting for firmware to respond with erase completion for %s (module 0x%02x), err %d\n",
 			component, module, err);

base-commit: bcbf1be0ad49eed35f3cf27fb668f77e0c94f5f7
-- 
2.28.0.497.g54e85e7af1ac

