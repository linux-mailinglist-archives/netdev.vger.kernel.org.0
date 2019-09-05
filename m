Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE90AAD13
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391675AbfIEUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:45332 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390393AbfIEUeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136533"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/16] ice: Add ice_get_main_vsi to get PF/main VSI
Date:   Thu,  5 Sep 2019 13:33:52 -0700
Message-Id: <20190905203406.4152-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

There are multiple places where we currently use ice_find_vsi_by_type
to get the PF (a.k.a. main) VSI. The PF VSI by definition is always
the first element in the pf->vsi array (i.e. pf->vsi[0]). So instead
add and use a new helper function ice_get_main_vsi, which just returns
pf->vsi[0].

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 20 +++++++-------------
 drivers/net/ethernet/intel/ice/ice_main.c |  6 +++---
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index fb2bc836b20a..bbb3c290a0bf 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -425,21 +425,15 @@ ice_irq_dynamic_ena(struct ice_hw *hw, struct ice_vsi *vsi,
 }
 
 /**
- * ice_find_vsi_by_type - Find and return VSI of a given type
- * @pf: PF to search for VSI
- * @type: Value indicating type of VSI we are looking for
+ * ice_get_main_vsi - Get the PF VSI
+ * @pf: PF instance
+ *
+ * returns pf->vsi[0], which by definition is the PF VSI
  */
-static inline struct ice_vsi *
-ice_find_vsi_by_type(struct ice_pf *pf, enum ice_vsi_type type)
+static inline struct ice_vsi *ice_get_main_vsi(struct ice_pf *pf)
 {
-	int i;
-
-	for (i = 0; i < pf->num_alloc_vsi; i++) {
-		struct ice_vsi *vsi = pf->vsi[i];
-
-		if (vsi && vsi->type == type)
-			return vsi;
-	}
+	if (pf->vsi)
+		return pf->vsi[0];
 
 	return NULL;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 50a17a0337be..703fc7bf2b31 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -120,7 +120,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	u8 broadcast[ETH_ALEN];
 	struct ice_vsi *vsi;
 
-	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	vsi = ice_get_main_vsi(pf);
 	if (!vsi)
 		return -EINVAL;
 
@@ -826,7 +826,7 @@ ice_link_event(struct ice_pf *pf, struct ice_port_info *pi, bool link_up,
 	if (link_up == old_link && link_speed == old_link_speed)
 		return result;
 
-	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	vsi = ice_get_main_vsi(pf);
 	if (!vsi || !vsi->port_info)
 		return -EINVAL;
 
@@ -1439,7 +1439,7 @@ static void ice_check_media_subtask(struct ice_pf *pf)
 	struct ice_vsi *vsi;
 	int err;
 
-	vsi = ice_find_vsi_by_type(pf, ICE_VSI_PF);
+	vsi = ice_get_main_vsi(pf);
 	if (!vsi)
 		return;
 
-- 
2.21.0

