Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAA18DEA7
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCUIKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:33283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbgCUIKe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:34 -0400
IronPort-SDR: uTbL+IvZyxllNsx9lH9+CPknKIlfTnBagD9Zpldimx14SkfC/VvnTPedmkKx7zS3ncOm6MDgAD
 n+D0FRqL7POw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: BMzOECUz1skz16xSKvLyYIvCQrLvRiB4EpXYvUZDzvHzt8JDdaSgBWIuQKZ0W+eehB4KXNzVoy
 +yid7/iQdo+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737971"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 8/9] ice: add basic handler for devlink .info_get
Date:   Sat, 21 Mar 2020 01:10:27 -0700
Message-Id: <20200321081028.2763550-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The devlink .info_get callback allows the driver to report detailed
version information. The following devlink versions are reported with
this initial implementation:

 "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
 "fw.mgmt.api" -> API version of interface exposed over the AdminQ
 "fw.mgmt.build" -> Unique build id of the source for the management fw
 "fw.undi" -> Version of the Option ROM containing the UEFI driver
 "fw.psid.api" -> Version of the NVM image format.
 "fw.bundle_id" -> Unique identifier for the combined flash image.
 "fw.app.name" -> The name of the active DDP package.
 "fw.app" -> The version of the active DDP package.

With this, devlink dev info can report at least as much information as
is reported by ETHTOOL_GDRVINFO.

Compare the output from ethtool vs from devlink:

  $ ethtool -i ens785s0
  driver: ice
  version: 0.8.1-k
  firmware-version: 0.80 0x80002ec0 1.2581.0
  expansion-rom-version:
  bus-info: 0000:3b:00.0
  supports-statistics: yes
  supports-test: yes
  supports-eeprom-access: yes
  supports-register-dump: yes
  supports-priv-flags: yes

  $ devlink dev info pci/0000:3b:00.0
  pci/0000:3b:00.0:
  driver ice
  serial number 00-01-ab-ff-ff-ca-05-68
  versions:
      running:
        fw.mgmt 2.1.7
        fw.mgmt.api 1.5
        fw.mgmt.build 0x305d955f
        fw.undi 1.2581.0
        fw.psid.api 0.80
        fw.bundle_id 0x80002ec0
        fw.app.name ICE OS Default Package
        fw.app 1.3.1.0

More pieces of information can be displayed, each version is kept
separate instead of munged together, and each version has an identifier
which comes with associated documentation.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/networking/devlink/ice.rst     |  67 +++++++
 Documentation/networking/devlink/index.rst   |   1 +
 drivers/net/ethernet/intel/ice/ice_devlink.c | 189 +++++++++++++++++++
 3 files changed, 257 insertions(+)
 create mode 100644 Documentation/networking/devlink/ice.rst

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
new file mode 100644
index 000000000000..56739a51cdfe
--- /dev/null
+++ b/Documentation/networking/devlink/ice.rst
@@ -0,0 +1,67 @@
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
+      - 2.1.7
+      - 3-digit version number of the management firmware that controls the
+        PHY, link, etc.
+    * - ``fw.mgmt.api``
+      - running
+      - 1.5
+      - 2-digit version number of the API exported over the AdminQ by the
+        management firmware. Used by the driver to identify what commands
+        are supported.
+    * - ``fw.mgmt.build``
+      - running
+      - 0x305d955f
+      - Unique identifier of the source for the management firmware.
+    * - ``fw.undi``
+      - running
+      - 1.2581.0
+      - Version of the Option ROM containing the UEFI driver. The version is
+        reported in ``major.minor.patch`` format. The major version is
+        incremented whenever a major breaking change occurs, or when the
+        minor version would overflow. The minor version is incremented for
+        non-breaking changes and reset to 1 when the major version is
+        incremented. The patch version is normally 0 but is incremented when
+        a fix is delivered as a patch against an older base Option ROM.
+    * - ``fw.psid.api``
+      - running
+      - 0.80
+      - Version defining the format of the flash contents.
+    * - ``fw.bundle_id``
+      - running
+      - 0x80002ec0
+      - Unique identifier of the firmware image file that was loaded onto
+        the device. Also referred to as the EETRACK identifier of the NVM.
+    * - ``fw.app.name``
+      - running
+      - ICE OS Default Package
+      - The name of the DDP package that is active in the device. The DDP
+        package is loaded by the driver during initialization. Each varation
+        of DDP package shall have a unique name.
+    * - ``fw.app``
+      - running
+      - 1.3.1.0
+      - The version of the DDP package that is active in the device. Note
+        that both the name (as reported by ``fw.app.name``) and version are
+        required to uniquely identify the package.
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
index cedd9d02299e..410e2b531e5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -2,9 +2,198 @@
 /* Copyright (c) 2020, Intel Corporation. */
 
 #include "ice.h"
+#include "ice_lib.h"
 #include "ice_devlink.h"
 
+static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
+{
+	u8 dsn[8];
+
+	/* Copy the DSN into an array in Big Endian format */
+	put_unaligned_be64(pci_get_dsn(pf->pdev), dsn);
+
+	snprintf(buf, len, "%02x-%02x-%02x-%02x-%02x-%02x-%02x-%02x",
+		 dsn[0], dsn[1], dsn[2], dsn[3],
+		 dsn[4], dsn[5], dsn[6], dsn[7]);
+
+	return 0;
+}
+
+static int ice_info_fw_mgmt(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	snprintf(buf, len, "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
+		 hw->fw_patch);
+
+	return 0;
+}
+
+static int ice_info_fw_api(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	snprintf(buf, len, "%u.%u", hw->api_maj_ver, hw->api_min_ver);
+
+	return 0;
+}
+
+static int ice_info_fw_build(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	snprintf(buf, len, "0x%08x", hw->fw_build);
+
+	return 0;
+}
+
+static int ice_info_orom_ver(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_orom_info *orom = &pf->hw.nvm.orom;
+
+	snprintf(buf, len, "%u.%u.%u", orom->major, orom->build, orom->patch);
+
+	return 0;
+}
+
+static int ice_info_nvm_ver(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_nvm_info *nvm = &pf->hw.nvm;
+
+	snprintf(buf, len, "%x.%02x", nvm->major_ver, nvm->minor_ver);
+
+	return 0;
+}
+
+static int ice_info_eetrack(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_nvm_info *nvm = &pf->hw.nvm;
+
+	snprintf(buf, len, "0x%08x", nvm->eetrack);
+
+	return 0;
+}
+
+static int ice_info_ddp_pkg_name(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_hw *hw = &pf->hw;
+
+	snprintf(buf, len, "%s", hw->active_pkg_name);
+
+	return 0;
+}
+
+static int ice_info_ddp_pkg_version(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_pkg_ver *pkg = &pf->hw.active_pkg_ver;
+
+	snprintf(buf, len, "%u.%u.%u.%u", pkg->major, pkg->minor, pkg->update,
+		 pkg->draft);
+
+	return 0;
+}
+
+#define running(key, getter) { ICE_VERSION_RUNNING, key, getter }
+
+enum ice_version_type {
+	ICE_VERSION_FIXED,
+	ICE_VERSION_RUNNING,
+	ICE_VERSION_STORED,
+};
+
+static const struct ice_devlink_version {
+	enum ice_version_type type;
+	const char *key;
+	int (*getter)(struct ice_pf *pf, char *buf, size_t len);
+} ice_devlink_versions[] = {
+	running(DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, ice_info_fw_mgmt),
+	running("fw.mgmt.api", ice_info_fw_api),
+	running("fw.mgmt.build", ice_info_fw_build),
+	running(DEVLINK_INFO_VERSION_GENERIC_FW_UNDI, ice_info_orom_ver),
+	running("fw.psid.api", ice_info_nvm_ver),
+	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
+	running("fw.app.name", ice_info_ddp_pkg_name),
+	running(DEVLINK_INFO_VERSION_GENERIC_FW_APP, ice_info_ddp_pkg_version),
+};
+
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
+	struct ice_pf *pf = devlink_priv(devlink);
+	char buf[100];
+	size_t i;
+	int err;
+
+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
+		return err;
+	}
+
+	err = ice_info_get_dsn(pf, buf, sizeof(buf));
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to obtain serial number");
+		return err;
+	}
+
+	err = devlink_info_serial_number_put(req, buf);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Unable to set serial number");
+		return err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ice_devlink_versions); i++) {
+		enum ice_version_type type = ice_devlink_versions[i].type;
+		const char *key = ice_devlink_versions[i].key;
+
+		err = ice_devlink_versions[i].getter(pf, buf, sizeof(buf));
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Unable to obtain version info");
+			return err;
+		}
+
+		switch (type) {
+		case ICE_VERSION_FIXED:
+			err = devlink_info_version_fixed_put(req, key, buf);
+			if (err) {
+				NL_SET_ERR_MSG_MOD(extack, "Unable to set fixed version");
+				return err;
+			}
+			break;
+		case ICE_VERSION_RUNNING:
+			err = devlink_info_version_running_put(req, key, buf);
+			if (err) {
+				NL_SET_ERR_MSG_MOD(extack, "Unable to set running version");
+				return err;
+			}
+			break;
+		case ICE_VERSION_STORED:
+			err = devlink_info_version_stored_put(req, key, buf);
+			if (err) {
+				NL_SET_ERR_MSG_MOD(extack, "Unable to set stored version");
+				return err;
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static const struct devlink_ops ice_devlink_ops = {
+	.info_get = ice_devlink_info_get,
 };
 
 static void ice_devlink_free(void *devlink_ptr)
-- 
2.25.1

