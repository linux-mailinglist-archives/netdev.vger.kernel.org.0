Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6485521A9B5
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgGIV1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:27:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:49958 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbgGIV06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 17:26:58 -0400
IronPort-SDR: Jx4zv4pqrGh5XSYWmAC1XAgcCdU4+AY4RDD2OVaQkfXmVl1OA7tpXftO9Po2X6yC1t1UCCHnT6
 neZSD6ESfMwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="147202445"
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="147202445"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 14:26:54 -0700
IronPort-SDR: UjKgfotDG4TFaVMNmgg2AXWSPx1M1wZhhyCHSpNi+T/o76k+K9LFpQDaKwSGInpTOWAPO6ED/C
 7e8N8twz05gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,332,1589266800"; 
   d="scan'208";a="284293643"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga006.jf.intel.com with ESMTP; 09 Jul 2020 14:26:53 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 3/6] ice: add flags indicating pending update of firmware module
Date:   Thu,  9 Jul 2020 14:26:49 -0700
Message-Id: <20200709212652.2785924-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200709212652.2785924-1-jacob.e.keller@intel.com>
References: <20200709212652.2785924-1-jacob.e.keller@intel.com>
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
index d81ee985a2c3..a35739d726a7 100644
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
index dcfb75c10944..7a6eb36ef2da 100644
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
index 74ef42b0721b..4207790bd9ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -263,6 +263,12 @@ struct ice_hw_common_caps {
 
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
2.27.0.353.gb9a2d1a0207f

