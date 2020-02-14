Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFD815FA4F
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 00:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgBNXW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 18:22:28 -0500
Received: from mga17.intel.com ([192.55.52.151]:1652 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbgBNXW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 18:22:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 15:22:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,442,1574150400"; 
   d="scan'208";a="228629284"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.244.172])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2020 15:22:26 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH v2 06/22] ice: add basic handler for devlink .info_get
Date:   Fri, 14 Feb 2020 15:22:05 -0800
Message-Id: <20200214232223.3442651-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.368.g28a2d05eebfb
In-Reply-To: <20200214232223.3442651-1-jacob.e.keller@intel.com>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink .info_get callback allows the driver to report detailed
version information. The following devlink versions are reported with
this initial implementation:

 "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
 "fw.mgmt.api" -> API version of interface exposed over the AdminQ
 "fw.mgmt.bundle" -> Unique identifier for the firmware bundle
 "fw.undi.orom" -> Version of the Option ROM containing the UEFI driver
 "nvm.psid" -> Version of the format for the NVM parameter set
 "nvm.bundle" -> Unique identifier for the combined NVM image

With this, devlink can now report at least the same information as
reported by the older ethtool interface. Each section of the
"firmware-version" is also reported independently so that it is easier
to understand the meaning.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 Documentation/networking/devlink/ice.rst     | 55 +++++++++++++
 Documentation/networking/devlink/index.rst   |  1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 81 ++++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 Documentation/networking/devlink/ice.rst

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
new file mode 100644
index 000000000000..5545e708f18f
--- /dev/null
+++ b/Documentation/networking/devlink/ice.rst
@@ -0,0 +1,55 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+ice devlink support
+===================
+
+This document describes the devlink features implemented by the ``ice``
+device driver.
+
+Info versions
+=============
+
+The ``ice`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+    :widths: 5 5 5 90
+
+    * - Name
+      - Type
+      - Example
+      - Description
+    * - ``fw.mgmt``
+      - running
+      - 1.16.10
+      - 3-digit version number of the management firmware that controls the
+        PHY, link, etc.
+    * - ``fw.mgmt.api``
+      - running
+      - 1.5
+      - 2-digit version number of the API exported over the AdminQ by the
+        management firmware. Used by the driver to identify what commands
+        are supported.
+    * - ``fw.mgmt.bundle``
+      - running
+      - 0xecabd066
+      - Unique identifier of the management firmware build.
+    * - ``fw.undi.orom``
+      - running
+      - 1.2186.0
+      - Version of the Option ROM containing the UEFI driver. The version is
+        reported in ``major.minor.patch`` format. The major version is
+        incremented whenever a major breaking change occurs, or when the
+        minor version would overflow. The minor version is incremented for
+        non-breaking changes and reset to 1 when the major version is
+        incremented. The patch version is normally 0 but is incremented when
+        a fix is delivered as a patch against an older base Option ROM.
+    * - ``nvm.psid``
+      - running
+      - 0.50
+      - Version describing the format of the NVM parameter set.
+    * - ``nvm.bundle``
+      - running
+      - 0x80001709
+      - Unique identifier of the NVM image contents, also known as the
+        EETRACK id.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 087ff54d53fc..272509cd9215 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -32,6 +32,7 @@ parameters, info versions, and other features it supports.
 
    bnxt
    ionic
+   ice
    mlx4
    mlx5
    mlxsw
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 2a72857c4b26..f834025d58aa 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -2,9 +2,90 @@
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
+	u8 orom_maj, orom_patch, nvm_ver_hi, nvm_ver_lo;
+	struct ice_pf *pf = devlink_priv(devlink);
+	struct ice_hw *hw = &pf->hw;
+	u16 orom_min;
+	char buf[32];
+	int err;
+
+	ice_get_nvm_version(hw, &orom_maj, &orom_min, &orom_patch, &nvm_ver_hi,
+			    &nvm_ver_lo);
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
+		 hw->fw_patch);
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW_MGMT,
+					       buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw version data");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "%u.%u", hw->api_maj_ver, hw->api_min_ver);
+	err = devlink_info_version_running_put(req, "fw.mgmt.api", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set mgmt fw API data");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "0x%08x", hw->fw_build);
+	err = devlink_info_version_running_put(req, "fw.mgmt.bundle", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw bundle data");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "%u.%u.%u", orom_maj, orom_min, orom_patch);
+	err = devlink_info_version_running_put(req, "fw.undi.orom", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set Option ROM version");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "%x.%02x", nvm_ver_hi, nvm_ver_lo);
+	err = devlink_info_version_running_put(req, "nvm.psid", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM parameter set version data");
+		return err;
+	}
+
+	snprintf(buf, sizeof(buf), "0x%0X", hw->nvm.eetrack);
+	err = devlink_info_version_running_put(req, "nvm.bundle", buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM bundle data");
+		return err;
+	}
+
+	return 0;
+}
+
 const struct devlink_ops ice_devlink_ops = {
+	.info_get = ice_devlink_info_get,
 };
 
 static void ice_devlink_free(void *devlink_ptr)
-- 
2.25.0.368.g28a2d05eebfb

