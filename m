Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6AD228D3A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388752AbfEWWd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:33:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:19068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388559AbfEWWdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:33:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 15:33:36 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 23 May 2019 15:33:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/15] ice: Call out dev/func caps when printing
Date:   Thu, 23 May 2019 15:33:30 -0700
Message-Id: <20190523223340.13449-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
References: <20190523223340.13449-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

ice_parse_caps is used to parse both device and function capabilities.
Currently, capabilities are printed with a cryptic "HW caps" prefix,
which makes it difficult to distinguish whether the capabilities being
printed are device or function capabilities.

This patch makes a change to add a "func cap" prefix when printing
function capabilities, and a "dev cap" prefix when printing device
capabilities.

This patch also changes some of the capability print strings for
consistency.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 56 +++++++++++----------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index da7878529929..91f3f82b43a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1447,6 +1447,7 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 	struct ice_hw_func_caps *func_p = NULL;
 	struct ice_hw_dev_caps *dev_p = NULL;
 	struct ice_hw_common_caps *caps;
+	char const *prefix;
 	u32 i;
 
 	if (!buf)
@@ -1457,9 +1458,11 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 	if (opc == ice_aqc_opc_list_dev_caps) {
 		dev_p = &hw->dev_caps;
 		caps = &dev_p->common_cap;
+		prefix = "dev cap";
 	} else if (opc == ice_aqc_opc_list_func_caps) {
 		func_p = &hw->func_caps;
 		caps = &func_p->common_cap;
+		prefix = "func cap";
 	} else {
 		ice_debug(hw, ICE_DBG_INIT, "wrong opcode\n");
 		return;
@@ -1475,28 +1478,29 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 		case ICE_AQC_CAPS_VALID_FUNCTIONS:
 			caps->valid_functions = number;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Valid Functions = %d\n",
+				  "%s: valid functions = %d\n", prefix,
 				  caps->valid_functions);
 			break;
 		case ICE_AQC_CAPS_SRIOV:
 			caps->sr_iov_1_1 = (number == 1);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: SR-IOV = %d\n", caps->sr_iov_1_1);
+				  "%s: SR-IOV = %d\n", prefix,
+				  caps->sr_iov_1_1);
 			break;
 		case ICE_AQC_CAPS_VF:
 			if (dev_p) {
 				dev_p->num_vfs_exposed = number;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: VFs exposed = %d\n",
+					  "%s: VFs exposed = %d\n", prefix,
 					  dev_p->num_vfs_exposed);
 			} else if (func_p) {
 				func_p->num_allocd_vfs = number;
 				func_p->vf_base_id = logical_id;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: VFs allocated = %d\n",
+					  "%s: VFs allocated = %d\n", prefix,
 					  func_p->num_allocd_vfs);
 				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: VF base_id = %d\n",
+					  "%s: VF base_id = %d\n", prefix,
 					  func_p->vf_base_id);
 			}
 			break;
@@ -1504,69 +1508,69 @@ ice_parse_caps(struct ice_hw *hw, void *buf, u32 cap_count,
 			if (dev_p) {
 				dev_p->num_vsi_allocd_to_host = number;
 				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: Dev.VSI cnt = %d\n",
+					  "%s: num VSI alloc to host = %d\n",
+					  prefix,
 					  dev_p->num_vsi_allocd_to_host);
 			} else if (func_p) {
 				func_p->guar_num_vsi =
 					ice_get_num_per_func(hw, ICE_MAX_VSI);
 				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: Func.VSI cnt = %d\n",
-					  number);
+					  "%s: num guaranteed VSI (fw) = %d\n",
+					  prefix, number);
+				ice_debug(hw, ICE_DBG_INIT,
+					  "%s: num guaranteed VSI = %d\n",
+					  prefix, func_p->guar_num_vsi);
 			}
 			break;
 		case ICE_AQC_CAPS_RSS:
 			caps->rss_table_size = number;
 			caps->rss_table_entry_width = logical_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: RSS table size = %d\n",
+				  "%s: RSS table size = %d\n", prefix,
 				  caps->rss_table_size);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: RSS table width = %d\n",
+				  "%s: RSS table width = %d\n", prefix,
 				  caps->rss_table_entry_width);
 			break;
 		case ICE_AQC_CAPS_RXQS:
 			caps->num_rxq = number;
 			caps->rxq_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Num Rx Qs = %d\n", caps->num_rxq);
+				  "%s: num Rx queues = %d\n", prefix,
+				  caps->num_rxq);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Rx first queue ID = %d\n",
+				  "%s: Rx first queue ID = %d\n", prefix,
 				  caps->rxq_first_id);
 			break;
 		case ICE_AQC_CAPS_TXQS:
 			caps->num_txq = number;
 			caps->txq_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Num Tx Qs = %d\n", caps->num_txq);
+				  "%s: num Tx queues = %d\n", prefix,
+				  caps->num_txq);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Tx first queue ID = %d\n",
+				  "%s: Tx first queue ID = %d\n", prefix,
 				  caps->txq_first_id);
 			break;
 		case ICE_AQC_CAPS_MSIX:
 			caps->num_msix_vectors = number;
 			caps->msix_vector_first_id = phys_id;
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: MSIX vector count = %d\n",
+				  "%s: MSIX vector count = %d\n", prefix,
 				  caps->num_msix_vectors);
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: MSIX first vector index = %d\n",
+				  "%s: MSIX first vector index = %d\n", prefix,
 				  caps->msix_vector_first_id);
 			break;
 		case ICE_AQC_CAPS_MAX_MTU:
 			caps->max_mtu = number;
-			if (dev_p)
-				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: Dev.MaxMTU = %d\n",
-					  caps->max_mtu);
-			else if (func_p)
-				ice_debug(hw, ICE_DBG_INIT,
-					  "HW caps: func.MaxMTU = %d\n",
-					  caps->max_mtu);
+			ice_debug(hw, ICE_DBG_INIT, "%s: max MTU = %d\n",
+				  prefix, caps->max_mtu);
 			break;
 		default:
 			ice_debug(hw, ICE_DBG_INIT,
-				  "HW caps: Unknown capability[%d]: 0x%x\n", i,
-				  cap);
+				  "%s: unknown capability[%d]: 0x%x\n", prefix,
+				  i, cap);
 			break;
 		}
 	}
-- 
2.21.0

