Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D671E979D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgEaMge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:12468 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbgEaMg1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:27 -0400
IronPort-SDR: ksXI1MdMVzO+1lOfCwmuNAfeXzwtFr/xazubCXyd6ccNmgV2HZzerKmStDn9t2p4uNO9m/hZ49
 iGINAAJaAQYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:25 -0700
IronPort-SDR: CgGyfrRrkbcdPnt1eDyEFyxY83n6vBEY1YaneohQ5r6N9I4dbxabgUkuss6cxGzbGBMnvkl44e
 sZx+BtJoaQXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345454"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 13/14] ice: fix aRFS after flow director delete
Date:   Sun, 31 May 2020 05:36:18 -0700
Message-Id: <20200531123619.2887469-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

The logic was missing for adding back perfect flows after flow director
filter delete. The code now adds perfect flows into the HW tables after
filter delete.

Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 42803fc0ed18..d7430ce6af26 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1363,6 +1363,31 @@ void ice_vsi_manage_fdir(struct ice_vsi *vsi, bool ena)
 	mutex_unlock(&hw->fdir_fltr_lock);
 }
 
+/**
+ * ice_fdir_do_rem_flow - delete flow and possibly add perfect flow
+ * @pf: PF structure
+ * @flow_type: FDir flow type to release
+ */
+static void
+ice_fdir_do_rem_flow(struct ice_pf *pf, enum ice_fltr_ptype flow_type)
+{
+	struct ice_hw *hw = &pf->hw;
+	bool need_perfect = false;
+
+	if (flow_type == ICE_FLTR_PTYPE_NONF_IPV4_TCP ||
+	    flow_type == ICE_FLTR_PTYPE_NONF_IPV4_UDP ||
+	    flow_type == ICE_FLTR_PTYPE_NONF_IPV6_TCP ||
+	    flow_type == ICE_FLTR_PTYPE_NONF_IPV6_UDP)
+		need_perfect = true;
+
+	if (need_perfect && test_bit(flow_type, hw->fdir_perfect_fltr))
+		return;
+
+	ice_fdir_rem_flow(hw, ICE_BLK_FD, flow_type);
+	if (need_perfect)
+		ice_create_init_fdir_rule(pf, flow_type);
+}
+
 /**
  * ice_fdir_update_list_entry - add or delete a filter from the filter list
  * @pf: PF structure
@@ -1393,7 +1418,7 @@ ice_fdir_update_list_entry(struct ice_pf *pf, struct ice_fdir_fltr *input,
 			/* we just deleted the last filter of flow_type so we
 			 * should also delete the HW filter info.
 			 */
-			ice_fdir_rem_flow(hw, ICE_BLK_FD, old_fltr->flow_type);
+			ice_fdir_do_rem_flow(pf, old_fltr->flow_type);
 		list_del(&old_fltr->fltr_node);
 		devm_kfree(ice_hw_to_dev(hw), old_fltr);
 	}
-- 
2.26.2

