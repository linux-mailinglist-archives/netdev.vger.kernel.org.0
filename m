Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1E16F58BC
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbfKHUi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:38:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:65452 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732490AbfKHUiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 15:38:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 12:38:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="354200463"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 08 Nov 2019 12:38:08 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/15] ice: Introduce and use ice_vsi_type_str
Date:   Fri,  8 Nov 2019 12:38:04 -0800
Message-Id: <20191108203806.12109-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
References: <20191108203806.12109-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

ice_vsi_type_str converts an ice_vsi_type enum value to its string
equivalent. This is expected to help easily identify VSI types from
module print statements.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 21 ++++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_lib.h  |  2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 16 ++++++++--------
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index ebcf81edcb19..d71f7ce0a265 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -6,6 +6,24 @@
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
 
+/**
+ * ice_vsi_type_str - maps VSI type enum to string equivalents
+ * @type: VSI type enum
+ */
+const char *ice_vsi_type_str(enum ice_vsi_type type)
+{
+	switch (type) {
+	case ICE_VSI_PF:
+		return "ICE_VSI_PF";
+	case ICE_VSI_VF:
+		return "ICE_VSI_VF";
+	case ICE_VSI_LB:
+		return "ICE_VSI_LB";
+	default:
+		return "unknown";
+	}
+}
+
 /**
  * ice_vsi_ctrl_rx_rings - Start or stop a VSI's Rx rings
  * @vsi: the VSI being configured
@@ -700,7 +718,8 @@ static void ice_set_rss_vsi_ctx(struct ice_vsi_ctx *ctxt, struct ice_vsi *vsi)
 		hash_type = ICE_AQ_VSI_Q_OPT_RSS_TPLZ;
 		break;
 	case ICE_VSI_LB:
-		dev_dbg(&pf->pdev->dev, "Unsupported VSI type %d\n", vsi->type);
+		dev_dbg(&pf->pdev->dev, "Unsupported VSI type %s\n",
+			ice_vsi_type_str(vsi->type));
 		return;
 	default:
 		dev_warn(&pf->pdev->dev, "Unknown VSI type %d\n", vsi->type);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 2c5c01b7a582..e86aa60c0254 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -6,6 +6,8 @@
 
 #include "ice.h"
 
+const char *ice_vsi_type_str(enum ice_vsi_type type);
+
 int
 ice_add_mac_to_list(struct ice_vsi *vsi, struct list_head *add_list,
 		    const u8 *macaddr);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 4f4ebb499559..5681e3be81f2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4487,8 +4487,8 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		err = ice_vsi_rebuild(vsi);
 		if (err) {
 			dev_err(&pf->pdev->dev,
-				"rebuild VSI failed, err %d, VSI index %d, type %d\n",
-				err, vsi->idx, type);
+				"rebuild VSI failed, err %d, VSI index %d, type %s\n",
+				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
 		}
 
@@ -4496,8 +4496,8 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		status = ice_replay_vsi(&pf->hw, vsi->idx);
 		if (status) {
 			dev_err(&pf->pdev->dev,
-				"replay VSI failed, status %d, VSI index %d, type %d\n",
-				status, vsi->idx, type);
+				"replay VSI failed, status %d, VSI index %d, type %s\n",
+				status, vsi->idx, ice_vsi_type_str(type));
 			return -EIO;
 		}
 
@@ -4510,13 +4510,13 @@ static int ice_vsi_rebuild_by_type(struct ice_pf *pf, enum ice_vsi_type type)
 		err = ice_ena_vsi(vsi, false);
 		if (err) {
 			dev_err(&pf->pdev->dev,
-				"enable VSI failed, err %d, VSI index %d, type %d\n",
-				err, vsi->idx, type);
+				"enable VSI failed, err %d, VSI index %d, type %s\n",
+				err, vsi->idx, ice_vsi_type_str(type));
 			return err;
 		}
 
-		dev_info(&pf->pdev->dev, "VSI rebuilt. VSI index %d, type %d\n",
-			 vsi->idx, type);
+		dev_info(&pf->pdev->dev, "VSI rebuilt. VSI index %d, type %s\n",
+			 vsi->idx, ice_vsi_type_str(type));
 	}
 
 	return 0;
-- 
2.21.0

