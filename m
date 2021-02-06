Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340B311B09
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhBFEn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:43:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:21610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231503AbhBFEkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:40:53 -0500
IronPort-SDR: BlJT6H7dyBlwIaZeGXYkjLQEGLRC6XKhj+5Qw3+6M6fTmdvfDeToID3tQDD6YEm3Lz+9zcTWPD
 SebMIzkP0DMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194688"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194688"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:11 -0800
IronPort-SDR: +K9mPeSvq/bsG50L1z0oTPRrg+xGZHkFcaI50SXeMMszdIgCQh26upNd1tFgUMzAH7u7nzFSUQ
 ymAdH2ciQShw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751039"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:11 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Shannon Nelson <snelson@pensando.io>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 01/11] ice: report timeout length for erasing during devlink flash
Date:   Fri,  5 Feb 2021 20:40:51 -0800
Message-Id: <20210206044101.636242-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

When erasing, notify userspace of how long we will potentially take to
erase a module. Doing so allows userspace to report the timeout, giving
a clear indication of the upper time bound of the operation.

Since we're re-using the erase timeout value, make it a macro rather
than a magic number.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Shannon Nelson <snelson@pensando.io>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_fw_update.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
index 8f81b95e679c..dcec0360ce55 100644
--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
@@ -417,6 +417,11 @@ ice_write_nvm_module(struct ice_pf *pf, u16 module, const char *component,
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
@@ -449,7 +454,7 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 
 	devlink = priv_to_devlink(pf);
 
-	devlink_flash_update_status_notify(devlink, "Erasing", component, 0, 0);
+	devlink_flash_update_timeout_notify(devlink, "Erasing", component, ICE_FW_ERASE_TIMEOUT);
 
 	status = ice_aq_erase_nvm(hw, module, NULL);
 	if (status) {
@@ -461,8 +466,7 @@ ice_erase_nvm_module(struct ice_pf *pf, u16 module, const char *component,
 		goto out_notify_devlink;
 	}
 
-	/* Yes, this really can take minutes to complete */
-	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_erase, 300 * HZ, &event);
+	err = ice_aq_wait_for_event(pf, ice_aqc_opc_nvm_erase, ICE_FW_ERASE_TIMEOUT * HZ, &event);
 	if (err) {
 		dev_err(dev, "Timed out waiting for firmware to respond with erase completion for %s (module 0x%02x), err %d\n",
 			component, module, err);
-- 
2.26.2

