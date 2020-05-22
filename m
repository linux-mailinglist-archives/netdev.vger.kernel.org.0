Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196EF1DE035
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgEVG4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:18659 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgEVG4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:09 -0400
IronPort-SDR: KlftLSDxVYqkLR1FVJJm8+9kyRx4WvoyYbrw0yFs95Ok+1Ll/JnzmXP2K0zQz2UetdyQiKPsIw
 w2aFzA+390FA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:09 -0700
IronPort-SDR: jRa2VJzt2O2FcgXa1S3iqCKMJ/Tggu8sYiq7PZc1gLavM2wYxeYkKKbEiGW7XswC4IWC4ZvVbb
 YepuI9d76XjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017735"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:08 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/17] ice: report netlist version in .info_get
Date:   Thu, 21 May 2020 23:55:51 -0700
Message-Id: <20200522065607.1680050-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The flash memory for the ice hardware contains a block of information
used for link management called the Netlist module.

As this essentially represents another section of firmware, add its
version information to the output of the driver's .info_get handler.

This includes both a version and the first few bytes of a hash of the
module contents.

  fw.netlist -> the version information extracted from the netlist module
  fw.netlist.build-> first 4 bytes of the hash of the contents, similar
                     to fw.mgmt.build

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/networking/devlink/ice.rst      | 11 +++
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 27 ++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  | 23 +++++
 drivers/net/ethernet/intel/ice/ice_nvm.c      | 86 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h     | 11 +++
 5 files changed, 158 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 4574352d6ff4..72ea8d295724 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -69,6 +69,17 @@ The ``ice`` driver reports the following versions
       - The version of the DDP package that is active in the device. Note
         that both the name (as reported by ``fw.app.name``) and version are
         required to uniquely identify the package.
+    * - ``fw.netlist``
+      - running
+      - 1.1.2000-6.7.0
+      - The version of the netlist module. This module defines the device's
+        Ethernet capabilities and default settings, and is used by the
+        management firmware as part of managing link and device
+        connectivity.
+    * - ``fw.netlist.build``
+      - running
+      - 0xee16ced7
+      - The first 4 bytes of the hash of the netlist module contents.
 
 Regions
 =======
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 2381b4014ed6..8767a78038e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1264,6 +1264,33 @@ struct ice_aqc_nvm_checksum {
 	u8 rsvd2[12];
 };
 
+/* The result of netlist NVM read comes in a TLV format. The actual data
+ * (netlist header) starts from word offset 1 (byte 2). The FW strips
+ * out the type field from the TLV header so all the netlist fields
+ * should adjust their offset value by 1 word (2 bytes) in order to map
+ * their correct location.
+ */
+#define ICE_AQC_NVM_LINK_TOPO_NETLIST_MOD_ID		0x11B
+#define ICE_AQC_NVM_LINK_TOPO_NETLIST_LEN_OFFSET	1
+#define ICE_AQC_NVM_LINK_TOPO_NETLIST_LEN		2 /* In bytes */
+#define ICE_AQC_NVM_NETLIST_NODE_COUNT_OFFSET		2
+#define ICE_AQC_NVM_NETLIST_NODE_COUNT_LEN		2 /* In bytes */
+#define ICE_AQC_NVM_NETLIST_NODE_COUNT_M		ICE_M(0x3FF, 0)
+#define ICE_AQC_NVM_NETLIST_ID_BLK_START_OFFSET		5
+#define ICE_AQC_NVM_NETLIST_ID_BLK_LEN			0x30 /* In words */
+
+/* netlist ID block field offsets (word offsets) */
+#define ICE_AQC_NVM_NETLIST_ID_BLK_MAJOR_VER_LOW	2
+#define ICE_AQC_NVM_NETLIST_ID_BLK_MAJOR_VER_HIGH	3
+#define ICE_AQC_NVM_NETLIST_ID_BLK_MINOR_VER_LOW	4
+#define ICE_AQC_NVM_NETLIST_ID_BLK_MINOR_VER_HIGH	5
+#define ICE_AQC_NVM_NETLIST_ID_BLK_TYPE_LOW		6
+#define ICE_AQC_NVM_NETLIST_ID_BLK_TYPE_HIGH		7
+#define ICE_AQC_NVM_NETLIST_ID_BLK_REV_LOW		8
+#define ICE_AQC_NVM_NETLIST_ID_BLK_REV_HIGH		9
+#define ICE_AQC_NVM_NETLIST_ID_BLK_SHA_HASH		0xA
+#define ICE_AQC_NVM_NETLIST_ID_BLK_CUST_VER		0x2F
+
 /**
  * Send to PF command (indirect 0x0801) ID is only used by PF
  *
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index c6833944b90a..a73d06e06b5d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -105,6 +105,27 @@ static int ice_info_ddp_pkg_version(struct ice_pf *pf, char *buf, size_t len)
 	return 0;
 }
 
+static int ice_info_netlist_ver(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_netlist_ver_info *netlist = &pf->hw.netlist_ver;
+
+	/* The netlist version fields are BCD formatted */
+	snprintf(buf, len, "%x.%x.%x-%x.%x.%x", netlist->major, netlist->minor,
+		 netlist->type >> 16, netlist->type & 0xFFFF, netlist->rev,
+		 netlist->cust_ver);
+
+	return 0;
+}
+
+static int ice_info_netlist_build(struct ice_pf *pf, char *buf, size_t len)
+{
+	struct ice_netlist_ver_info *netlist = &pf->hw.netlist_ver;
+
+	snprintf(buf, len, "0x%08x", netlist->hash);
+
+	return 0;
+}
+
 #define fixed(key, getter) { ICE_VERSION_FIXED, key, getter }
 #define running(key, getter) { ICE_VERSION_RUNNING, key, getter }
 
@@ -128,6 +149,8 @@ static const struct ice_devlink_version {
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, ice_info_eetrack),
 	running("fw.app.name", ice_info_ddp_pkg_name),
 	running(DEVLINK_INFO_VERSION_GENERIC_FW_APP, ice_info_ddp_pkg_version),
+	running("fw.netlist", ice_info_netlist_ver),
+	running("fw.netlist.build", ice_info_netlist_build),
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index 8beb675d676b..7c2a06892bbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -366,6 +366,87 @@ static enum ice_status ice_get_orom_ver_info(struct ice_hw *hw)
 	return 0;
 }
 
+/**
+ * ice_get_netlist_ver_info
+ * @hw: pointer to the HW struct
+ *
+ * Get the netlist version information
+ */
+static enum ice_status ice_get_netlist_ver_info(struct ice_hw *hw)
+{
+	struct ice_netlist_ver_info *ver = &hw->netlist_ver;
+	enum ice_status ret;
+	u32 id_blk_start;
+	__le16 raw_data;
+	u16 data, i;
+	u16 *buff;
+
+	ret = ice_acquire_nvm(hw, ICE_RES_READ);
+	if (ret)
+		return ret;
+	buff = kcalloc(ICE_AQC_NVM_NETLIST_ID_BLK_LEN, sizeof(*buff),
+		       GFP_KERNEL);
+	if (!buff) {
+		ret = ICE_ERR_NO_MEMORY;
+		goto exit_no_mem;
+	}
+
+	/* read module length */
+	ret = ice_aq_read_nvm(hw, ICE_AQC_NVM_LINK_TOPO_NETLIST_MOD_ID,
+			      ICE_AQC_NVM_LINK_TOPO_NETLIST_LEN_OFFSET * 2,
+			      ICE_AQC_NVM_LINK_TOPO_NETLIST_LEN, &raw_data,
+			      false, false, NULL);
+	if (ret)
+		goto exit_error;
+
+	data = le16_to_cpu(raw_data);
+	/* exit if length is = 0 */
+	if (!data)
+		goto exit_error;
+
+	/* read node count */
+	ret = ice_aq_read_nvm(hw, ICE_AQC_NVM_LINK_TOPO_NETLIST_MOD_ID,
+			      ICE_AQC_NVM_NETLIST_NODE_COUNT_OFFSET * 2,
+			      ICE_AQC_NVM_NETLIST_NODE_COUNT_LEN, &raw_data,
+			      false, false, NULL);
+	if (ret)
+		goto exit_error;
+	data = le16_to_cpu(raw_data) & ICE_AQC_NVM_NETLIST_NODE_COUNT_M;
+
+	/* netlist ID block starts from offset 4 + node count * 2 */
+	id_blk_start = ICE_AQC_NVM_NETLIST_ID_BLK_START_OFFSET + data * 2;
+
+	/* read the entire netlist ID block */
+	ret = ice_aq_read_nvm(hw, ICE_AQC_NVM_LINK_TOPO_NETLIST_MOD_ID,
+			      id_blk_start * 2,
+			      ICE_AQC_NVM_NETLIST_ID_BLK_LEN * 2, buff, false,
+			      false, NULL);
+	if (ret)
+		goto exit_error;
+
+	for (i = 0; i < ICE_AQC_NVM_NETLIST_ID_BLK_LEN; i++)
+		buff[i] = le16_to_cpu(((__force __le16 *)buff)[i]);
+
+	ver->major = (buff[ICE_AQC_NVM_NETLIST_ID_BLK_MAJOR_VER_HIGH] << 16) |
+		buff[ICE_AQC_NVM_NETLIST_ID_BLK_MAJOR_VER_LOW];
+	ver->minor = (buff[ICE_AQC_NVM_NETLIST_ID_BLK_MINOR_VER_HIGH] << 16) |
+		buff[ICE_AQC_NVM_NETLIST_ID_BLK_MINOR_VER_LOW];
+	ver->type = (buff[ICE_AQC_NVM_NETLIST_ID_BLK_TYPE_HIGH] << 16) |
+		buff[ICE_AQC_NVM_NETLIST_ID_BLK_TYPE_LOW];
+	ver->rev = (buff[ICE_AQC_NVM_NETLIST_ID_BLK_REV_HIGH] << 16) |
+		buff[ICE_AQC_NVM_NETLIST_ID_BLK_REV_LOW];
+	ver->cust_ver = buff[ICE_AQC_NVM_NETLIST_ID_BLK_CUST_VER];
+	/* Read the left most 4 bytes of SHA */
+	ver->hash = buff[ICE_AQC_NVM_NETLIST_ID_BLK_SHA_HASH + 15] << 16 |
+		buff[ICE_AQC_NVM_NETLIST_ID_BLK_SHA_HASH + 14];
+
+exit_error:
+	kfree(buff);
+exit_no_mem:
+	ice_release_nvm(hw);
+	return ret;
+}
+
 /**
  * ice_discover_flash_size - Discover the available flash size.
  * @hw: pointer to the HW struct
@@ -515,6 +596,11 @@ enum ice_status ice_init_nvm(struct ice_hw *hw)
 		return status;
 	}
 
+	/* read the netlist version information */
+	status = ice_get_netlist_ver_info(hw);
+	if (status)
+		ice_debug(hw, ICE_DBG_INIT, "Failed to read netlist info.\n");
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4ce5f92fca4a..35ea5adbb3e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -259,6 +259,16 @@ struct ice_nvm_info {
 
 #define ICE_NVM_VER_LEN	32
 
+/* netlist version information */
+struct ice_netlist_ver_info {
+	u32 major;			/* major high/low */
+	u32 minor;			/* minor high/low */
+	u32 type;			/* type high/low */
+	u32 rev;			/* revision high/low */
+	u32 hash;			/* SHA-1 hash word */
+	u16 cust_ver;			/* customer version */
+};
+
 /* Max number of port to queue branches w.r.t topology */
 #define ICE_MAX_TRAFFIC_CLASS 8
 #define ICE_TXSCHED_MAX_BRANCHES ICE_MAX_TRAFFIC_CLASS
@@ -506,6 +516,7 @@ struct ice_hw {
 	struct ice_nvm_info nvm;
 	struct ice_hw_dev_caps dev_caps;	/* device capabilities */
 	struct ice_hw_func_caps func_caps;	/* function capabilities */
+	struct ice_netlist_ver_info netlist_ver; /* netlist version info */
 
 	struct ice_switch_info *switch_info;	/* switch filter lists */
 
-- 
2.26.2

