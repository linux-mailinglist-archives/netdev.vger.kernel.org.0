Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F27B1595
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 22:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfILUuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 16:50:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:59562 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfILUuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 16:50:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 13:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="197345130"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2019 13:50:04 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/6] ice: send driver version to firmware
Date:   Thu, 12 Sep 2019 13:49:57 -0700
Message-Id: <20190912205002.12159-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
References: <20190912205002.12159-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>

The driver is required to send a version to the firmware
to indicate that the driver is up. If the driver doesn't
do this the firmware doesn't behave properly.

Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          |  1 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   | 13 +++++++
 drivers/net/ethernet/intel/ice/ice_common.c   | 37 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_common.h   |  3 ++
 drivers/net/ethernet/intel/ice/ice_main.c     | 36 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_type.h     |  8 ++++
 6 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b36e1cf0e461..4cdedcebb163 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -29,6 +29,7 @@
 #include <linux/sctp.h>
 #include <linux/ipv6.h>
 #include <linux/if_bridge.h>
+#include <linux/ctype.h>
 #include <linux/avf/virtchnl.h>
 #include <net/ipv6.h>
 #include "ice_devids.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 4da0cde9695b..9c9791788610 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -33,6 +33,17 @@ struct ice_aqc_get_ver {
 	u8 api_patch;
 };
 
+/* Send driver version (indirect 0x0002) */
+struct ice_aqc_driver_ver {
+	u8 major_ver;
+	u8 minor_ver;
+	u8 build_ver;
+	u8 subbuild_ver;
+	u8 reserved[4];
+	__le32 addr_high;
+	__le32 addr_low;
+};
+
 /* Queue Shutdown (direct 0x0003) */
 struct ice_aqc_q_shutdown {
 	u8 driver_unloading;
@@ -1547,6 +1558,7 @@ struct ice_aq_desc {
 		u8 raw[16];
 		struct ice_aqc_generic generic;
 		struct ice_aqc_get_ver get_ver;
+		struct ice_aqc_driver_ver driver_ver;
 		struct ice_aqc_q_shutdown q_shutdown;
 		struct ice_aqc_req_res res_owner;
 		struct ice_aqc_manage_mac_read mac_read;
@@ -1618,6 +1630,7 @@ enum ice_aq_err {
 enum ice_adminq_opc {
 	/* AQ commands */
 	ice_aqc_opc_get_ver				= 0x0001,
+	ice_aqc_opc_driver_ver				= 0x0002,
 	ice_aqc_opc_q_shutdown				= 0x0003,
 
 	/* resource ownership */
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8b2c46615834..db62cc748544 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1258,6 +1258,43 @@ enum ice_status ice_aq_get_fw_ver(struct ice_hw *hw, struct ice_sq_cd *cd)
 	return status;
 }
 
+/**
+ * ice_aq_send_driver_ver
+ * @hw: pointer to the HW struct
+ * @dv: driver's major, minor version
+ * @cd: pointer to command details structure or NULL
+ *
+ * Send the driver version (0x0002) to the firmware
+ */
+enum ice_status
+ice_aq_send_driver_ver(struct ice_hw *hw, struct ice_driver_ver *dv,
+		       struct ice_sq_cd *cd)
+{
+	struct ice_aqc_driver_ver *cmd;
+	struct ice_aq_desc desc;
+	u16 len;
+
+	cmd = &desc.params.driver_ver;
+
+	if (!dv)
+		return ICE_ERR_PARAM;
+
+	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_driver_ver);
+
+	desc.flags |= cpu_to_le16(ICE_AQ_FLAG_RD);
+	cmd->major_ver = dv->major_ver;
+	cmd->minor_ver = dv->minor_ver;
+	cmd->build_ver = dv->build_ver;
+	cmd->subbuild_ver = dv->subbuild_ver;
+
+	len = 0;
+	while (len < sizeof(dv->driver_string) &&
+	       isascii(dv->driver_string[len]) && dv->driver_string[len])
+		len++;
+
+	return ice_aq_send_cmd(hw, &desc, dv->driver_string, len, cd);
+}
+
 /**
  * ice_aq_q_shutdown
  * @hw: pointer to the HW struct
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index e376d1eadba4..e9d77370a17c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -71,6 +71,9 @@ ice_aq_send_cmd(struct ice_hw *hw, struct ice_aq_desc *desc,
 		void *buf, u16 buf_size, struct ice_sq_cd *cd);
 enum ice_status ice_aq_get_fw_ver(struct ice_hw *hw, struct ice_sq_cd *cd);
 
+enum ice_status
+ice_aq_send_driver_ver(struct ice_hw *hw, struct ice_driver_ver *dv,
+		       struct ice_sq_cd *cd);
 enum ice_status
 ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 		    struct ice_aqc_get_phy_caps_data *caps,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f8be9ada2447..c0988b74f007 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9,7 +9,13 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
-#define DRV_VERSION	"0.7.5-k"
+#define DRV_VERSION_MAJOR 0
+#define DRV_VERSION_MINOR 7
+#define DRV_VERSION_BUILD 5
+
+#define DRV_VERSION	__stringify(DRV_VERSION_MAJOR) "." \
+			__stringify(DRV_VERSION_MINOR) "." \
+			__stringify(DRV_VERSION_BUILD) "-k"
 #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800 Series Linux Driver"
 const char ice_drv_ver[] = DRV_VERSION;
 static const char ice_driver_string[] = DRV_SUMMARY;
@@ -2459,6 +2465,25 @@ static void ice_verify_cacheline_size(struct ice_pf *pf)
 			 ICE_CACHE_LINE_BYTES);
 }
 
+/**
+ * ice_send_version - update firmware with driver version
+ * @pf: PF struct
+ *
+ * Returns ICE_SUCCESS on success, else error code
+ */
+static enum ice_status ice_send_version(struct ice_pf *pf)
+{
+	struct ice_driver_ver dv;
+
+	dv.major_ver = DRV_VERSION_MAJOR;
+	dv.minor_ver = DRV_VERSION_MINOR;
+	dv.build_ver = DRV_VERSION_BUILD;
+	dv.subbuild_ver = 0;
+	strscpy((char *)dv.driver_string, DRV_VERSION,
+		sizeof(dv.driver_string));
+	return ice_aq_send_driver_ver(&pf->hw, &dv, NULL);
+}
+
 /**
  * ice_probe - Device initialization routine
  * @pdev: PCI device information struct
@@ -2612,6 +2637,15 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
 
 	clear_bit(__ICE_SERVICE_DIS, pf->state);
 
+	/* tell the firmware we are up */
+	err = ice_send_version(pf);
+	if (err) {
+		dev_err(dev,
+			"probe failed sending driver version %s. error: %d\n",
+			ice_drv_ver, err);
+		goto err_alloc_sw_unroll;
+	}
+
 	/* since everything is good, start the service timer */
 	mod_timer(&pf->serv_tmr, round_jiffies(jiffies + pf->serv_tmr_period));
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 4501d50a7dcc..a2676003275a 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -53,6 +53,14 @@ enum ice_aq_res_access_type {
 	ICE_RES_WRITE
 };
 
+struct ice_driver_ver {
+	u8 major_ver;
+	u8 minor_ver;
+	u8 build_ver;
+	u8 subbuild_ver;
+	u8 driver_string[32];
+};
+
 enum ice_fc_mode {
 	ICE_FC_NONE = 0,
 	ICE_FC_RX_PAUSE,
-- 
2.21.0

