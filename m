Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F83F224333
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728233AbgGQSfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:35:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:34689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbgGQSfq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:35:46 -0400
IronPort-SDR: +b3F+QYxWmXUGlCGjz5viPaVie5gUvwBykLhbKVb4UV4zM4txN4wtrKPO72euXpIBPUaC9r/a7
 oZsX2wXI0jKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="129736660"
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="129736660"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2020 11:35:45 -0700
IronPort-SDR: CQ1w1KHwj5S7FdN5OJtkUTwTACxUOTykjvR1ZLwL7WM+a+iXXUDY2ttsNPSN9Lv4q757RBWSEe
 ZDrub8GpzDlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,364,1589266800"; 
   d="scan'208";a="486542508"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jul 2020 11:35:45 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next v2 3/6] ice: add flags indicating pending update of firmware module
Date:   Fri, 17 Jul 2020 11:35:38 -0700
Message-Id: <20200717183541.797878-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.27.0.353.gb9a2d1a0207f
In-Reply-To: <20200717183541.797878-1-jacob.e.keller@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
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
index ffa7490b5789..2e9a43bae67f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1855,6 +1855,18 @@ ice_parse_common_caps(struct ice_hw *hw, struct ice_hw_common_caps *caps,
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
index 4314da808679..714bb5749fd4 100644
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

