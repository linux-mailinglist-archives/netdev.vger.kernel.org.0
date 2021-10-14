Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB142DE45
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJNPjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:39:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:31404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhJNPjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:39:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="227599603"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="227599603"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 08:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="592642519"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 14 Oct 2021 08:37:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Machnikowski <maciej.machnikowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH net-next v2 1/4] ice: Refactor ice_aqc_link_topo_addr
Date:   Thu, 14 Oct 2021 08:35:28 -0700
Message-Id: <20211014153531.2908804-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014153531.2908804-1-anthony.l.nguyen@intel.com>
References: <20211014153531.2908804-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Machnikowski <maciej.machnikowski@intel.com>

Separate link topo parameters in struct ice_aqc_link_topo_addr into
new struct ice_aqc_link_topo_params.
This keeps input parameters for the get_link_topo command in a separate
structure and is required by future commands that operate only on link
topo params without the node handle.

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 6 +++++-
 drivers/net/ethernet/intel/ice/ice_common.c     | 8 +++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 2b4437dc112f..9f6edfa59770 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1279,7 +1279,7 @@ struct ice_aqc_set_mac_lb {
 	u8 reserved[15];
 };
 
-struct ice_aqc_link_topo_addr {
+struct ice_aqc_link_topo_params {
 	u8 lport_num;
 	u8 lport_num_valid;
 #define ICE_AQC_LINK_TOPO_PORT_NUM_VALID	BIT(0)
@@ -1305,6 +1305,10 @@ struct ice_aqc_link_topo_addr {
 #define ICE_AQC_LINK_TOPO_NODE_CTX_PROVIDED	4
 #define ICE_AQC_LINK_TOPO_NODE_CTX_OVERRIDE	5
 	u8 index;
+};
+
+struct ice_aqc_link_topo_addr {
+	struct ice_aqc_link_topo_params topo_params;
 	__le16 handle;
 #define ICE_AQC_LINK_TOPO_HANDLE_S	0
 #define ICE_AQC_LINK_TOPO_HANDLE_M	(0x3FF << ICE_AQC_LINK_TOPO_HANDLE_S)
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 152a1405e353..b0084359a7e1 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -240,11 +240,13 @@ ice_aq_get_link_topo_handle(struct ice_port_info *pi, u8 node_type,
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_get_link_topo);
 
-	cmd->addr.node_type_ctx = (ICE_AQC_LINK_TOPO_NODE_CTX_PORT <<
-				   ICE_AQC_LINK_TOPO_NODE_CTX_S);
+	cmd->addr.topo_params.node_type_ctx =
+		(ICE_AQC_LINK_TOPO_NODE_CTX_PORT <<
+		 ICE_AQC_LINK_TOPO_NODE_CTX_S);
 
 	/* set node type */
-	cmd->addr.node_type_ctx |= (ICE_AQC_LINK_TOPO_NODE_TYPE_M & node_type);
+	cmd->addr.topo_params.node_type_ctx |=
+		(ICE_AQC_LINK_TOPO_NODE_TYPE_M & node_type);
 
 	return ice_aq_send_cmd(pi->hw, &desc, NULL, 0, cd);
 }
-- 
2.31.1

