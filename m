Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8749022BAF4
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgGXAWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:22:24 -0400
Received: from mga07.intel.com ([134.134.136.100]:23104 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbgGXAWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 20:22:21 -0400
IronPort-SDR: CRWrAKH3MiRrs+rPAMdDY0bjiFg3RL4ETFiFJEZ2HbXgKM6GQbrzDwN75Gt5cmf/I5A5tz/fQv
 BP/KOCfm2a9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="215232506"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="215232506"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 17:22:19 -0700
IronPort-SDR: 4TlOIFY3hHJv1wCeMkFGaitrAuFOvwZZkP5kdIZslhWwM17cgrYiVhK429215f+PeeAKbf3gw9
 +FweFmBAFCQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="272441994"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jul 2020 17:22:19 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v1 4/5] ice: add flags indicating pending update of firmware module
Date:   Thu, 23 Jul 2020 17:22:02 -0700
Message-Id: <20200724002203.451621-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.rc1.139.gd6b33fda9dd1
In-Reply-To: <20200724002203.451621-1-jacob.e.keller@intel.com>
References: <20200724002203.451621-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a flash update, the pending status of the update can be determined
from the device capabilities.

Read the appropriate device capability and store whether there is
a pending update awaiting a reboot.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  6 ++++++
 drivers/net/ethernet/intel/ice/ice_common.c     | 12 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_type.h       |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b2ec792e6052..7fec9309d379 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -109,6 +109,12 @@ struct ice_aqc_list_caps_elem {
 #define ICE_AQC_CAPS_MSIX				0x0043
 #define ICE_AQC_CAPS_FD					0x0045
 #define ICE_AQC_CAPS_MAX_MTU				0x0047
+#define ICE_AQC_CAPS_NVM_VER				0x0048
+#define ICE_AQC_CAPS_PENDING_NVM_VER			0x0049
+#define ICE_AQC_CAPS_OROM_VER				0x004A
+#define ICE_AQC_CAPS_PENDING_OROM_VER			0x004B
+#define ICE_AQC_CAPS_NET_VER				0x004C
+#define ICE_AQC_CAPS_PENDING_NET_VER			0x004D
 #define ICE_AQC_CAPS_NVM_MGMT				0x0080
 
 	u8 major_ver;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 249526f217ff..e5d7f3c3c0d7 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1857,6 +1857,18 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
 			  "%s: msix_vector_first_id = %d\n", prefix,
 			  caps->msix_vector_first_id);
 		break;
+	case ICE_AQC_CAPS_PENDING_NVM_VER:
+		caps->nvm_update_pending_nvm = true;
+		ice_debug(hw, ICE_DBG_INIT, "%s: update_pending_nvm\n", prefix);
+		break;
+	case ICE_AQC_CAPS_PENDING_OROM_VER:
+		caps->nvm_update_pending_orom = true;
+		ice_debug(hw, ICE_DBG_INIT, "%s: update_pending_orom\n", prefix);
+		break;
+	case ICE_AQC_CAPS_PENDING_NET_VER:
+		caps->nvm_update_pending_netlist = true;
+		ice_debug(hw, ICE_DBG_INIT, "%s: update_pending_netlist\n", prefix);
+		break;
 	case ICE_AQC_CAPS_NVM_MGMT:
 		caps->nvm_unified_update =
 			(number & ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT) ?
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 1022086e8920..e4349475790f 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -245,6 +245,12 @@ struct ice_hw_common_caps {
 
 	u8 dcb;
 
+	bool nvm_update_pending_nvm;
+	bool nvm_update_pending_orom;
+	bool nvm_update_pending_netlist;
+#define ICE_NVM_PENDING_NVM_IMAGE		BIT(0)
+#define ICE_NVM_PENDING_OROM			BIT(1)
+#define ICE_NVM_PENDING_NETLIST			BIT(2)
 	bool nvm_unified_update;
 #define ICE_NVM_MGMT_UNIFIED_UPD_SUPPORT	BIT(3)
 };
-- 
2.28.0.rc1.139.gd6b33fda9dd1

