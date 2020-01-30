Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D904314E5D1
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 00:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgA3W7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 17:59:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:51511 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbgA3W7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 17:59:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jan 2020 14:59:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,383,1574150400"; 
   d="scan'208";a="430187805"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2020 14:59:23 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 10/15] ice: add basic handler for devlink .info_get
Date:   Thu, 30 Jan 2020 14:59:05 -0800
Message-Id: <20200130225913.1671982-11-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink .info_get callback allows the driver to report detailed
version information. The following devlink versions are reported with
this initial implementation:

 "driver.version" -> device driver version, to match ethtool -i version
 "fw" -> firmware version as reported by ethtool -i firmware-version
 "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
 "fw.api" -> API version of interface exposed over the AdminQ
 "fw.build" -> Unique build identifier for the management firmware
 "nvm.version" -> Version of the NVM parameters section
 "nvm.oem" -> OEM-specific version information
 "nvm.eetrack" -> Unique identifier for the combined NVM image

With this, devlink can now report at least the same information as
reported by the older ethtool interface. Each section of the
"firmware-version" is also reported independently so that it is easier
to understand the meaning.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 103 +++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 0b0f936122de..493c2c2986f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -2,9 +2,112 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_devlink.h"
 
+/**
+ * ice_devlink_info_get - .info_get devlink handler
+ * @devlink: devlink instance structure
+ * @req: the devlink info request
+ * @extack: extended netdev ack structure
+ *
+ * Callback for the devlink .info_get operation. Reports information about the
+ * device.
+ *
+ * @returns zero on success or an error code on failure.
+ */
+static int ice_devlink_info_get(struct devlink *devlink,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct ice_hw *hw = &pf->hw;
+	u16 oem_build;
+	char buf[32]; /* TODO: size this properly */
+	int err;
+
+	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch, &nvm_ver_hi,
+			    &nvm_ver_lo);
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
+		return err;
+	}
+
+	/* driver.version */
+	err = devlink_info_version_fixed_put(req, "driver.version",
+					     ice_drv_ver);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver version");
+		return err;
+	}
+
+	/* fw (match exact output of ethtool -i firmware-version) */
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       ice_nvm_version_str(hw));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set combined fw version");
+		return err;
+	}
+
+	/* fw.mgmt (DEVLINK_INFO_VERSION_GENERIC_FW_MGMT) */
+	snprintf(buf, sizeof(buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
+		 hw->fw_patch);
+	err = devlink_info_version_running_put(req, "fw.mgmt", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw version data");
+		return err;
+	}
+
+	/* fw.api */
+	snprintf(buf, sizeof(buf), "%u.%u", hw->api_maj_ver,
+		 hw->api_min_ver);
+	err = devlink_info_version_running_put(req, "fw.api", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw API data");
+		return err;
+	}
+
+	/* fw.build */
+	snprintf(buf, sizeof(buf), "%08x", hw->fw_build);
+	err = devlink_info_version_running_put(req, "fw.build", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw build data");
+		return err;
+	}
+
+	/* nvm.version */
+	snprintf(buf, sizeof(buf), "%x.%02x", nvm_ver_hi, nvm_ver_lo);
+	err = devlink_info_version_running_put(req, "nvm.version", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM version data");
+		return err;
+	}
+
+	/* nvm.oem */
+	snprintf(buf, sizeof(buf), "%u.%u.%u", oem_ver, oem_build, oem_patch);
+	err = devlink_info_version_running_put(req, "nvm.oem", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set oem version data");
+		return err;
+	}
+
+	/* nvm.eetrack */
+	snprintf(buf, sizeof(buf), "0x%0X", hw->nvm.eetrack);
+	err = devlink_info_version_running_put(req, "nvm.eetrack", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM eetrack data");
+		return err;
+	}
+
+	return 0;
+}
+
 const struct devlink_ops ice_devlink_ops = {
+	.info_get = ice_devlink_info_get,
 };
 
 /**
-- 
2.25.0.rc1

