Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9FF46DDC3
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhLHVoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:44:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:15036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238875AbhLHVog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 16:44:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="237757862"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="237757862"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 13:12:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="606528300"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2021 13:12:49 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net v2 6/7] ice: fix adding different tunnels
Date:   Wed,  8 Dec 2021 13:11:43 -0800
Message-Id: <20211208211144.2629867-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
References: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Adding filters with the same values inside for VXLAN and Geneve causes HW
error, because it looks exactly the same. To choose between different
type of tunnels new recipe is needed. Add storing tunnel types in
creating recipes function and start checking it in finding function.

Change getting open tunnels function to return port on correct tunnel
type. This is needed to copy correct port to dummy packet.

Block user from adding enc_dst_port via tc flower, because VXLAN and
Geneve filters can be created only with destination port which was
previously opened.

Fixes: 8b032a55c1bd5 ("ice: low level support for tunnels")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_ethtool_fdir.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_fdir.c     |  2 +-
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  7 +++++--
 .../net/ethernet/intel/ice/ice_flex_pipe.h    |  3 ++-
 drivers/net/ethernet/intel/ice/ice_switch.c   | 19 +++++++++++++------
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  3 ++-
 6 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 38960bcc384c..b6e7f47c8c78 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1268,7 +1268,7 @@ ice_fdir_write_all_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input,
 		bool is_tun = tun == ICE_FD_HW_SEG_TUN;
 		int err;
 
-		if (is_tun && !ice_get_open_tunnel_port(&pf->hw, &port_num))
+		if (is_tun && !ice_get_open_tunnel_port(&pf->hw, &port_num, TNL_ALL))
 			continue;
 		err = ice_fdir_write_fltr(pf, input, add, is_tun);
 		if (err)
@@ -1652,7 +1652,7 @@ int ice_add_fdir_ethtool(struct ice_vsi *vsi, struct ethtool_rxnfc *cmd)
 	}
 
 	/* return error if not an update and no available filters */
-	fltrs_needed = ice_get_open_tunnel_port(hw, &tunnel_port) ? 2 : 1;
+	fltrs_needed = ice_get_open_tunnel_port(hw, &tunnel_port, TNL_ALL) ? 2 : 1;
 	if (!ice_fdir_find_fltr_by_idx(hw, fsp->location) &&
 	    ice_fdir_num_avail_fltr(hw, pf->vsi[vsi->idx]) < fltrs_needed) {
 		dev_err(dev, "Failed to add filter.  The maximum number of flow director filters has been reached.\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_fdir.c b/drivers/net/ethernet/intel/ice/ice_fdir.c
index cbd8424631e3..4dca009bdd50 100644
--- a/drivers/net/ethernet/intel/ice/ice_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_fdir.c
@@ -924,7 +924,7 @@ ice_fdir_get_gen_prgm_pkt(struct ice_hw *hw, struct ice_fdir_fltr *input,
 		memcpy(pkt, ice_fdir_pkt[idx].pkt, ice_fdir_pkt[idx].pkt_len);
 		loc = pkt;
 	} else {
-		if (!ice_get_open_tunnel_port(hw, &tnl_port))
+		if (!ice_get_open_tunnel_port(hw, &tnl_port, TNL_ALL))
 			return ICE_ERR_DOES_NOT_EXIST;
 		if (!ice_fdir_pkt[idx].tun_pkt)
 			return ICE_ERR_PARAM;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 23cfcceb1536..6ad1c2559724 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1899,9 +1899,11 @@ static struct ice_buf *ice_pkg_buf(struct ice_buf_build *bld)
  * ice_get_open_tunnel_port - retrieve an open tunnel port
  * @hw: pointer to the HW structure
  * @port: returns open port
+ * @type: type of tunnel, can be TNL_LAST if it doesn't matter
  */
 bool
-ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
+ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port,
+			 enum ice_tunnel_type type)
 {
 	bool res = false;
 	u16 i;
@@ -1909,7 +1911,8 @@ ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port)
 	mutex_lock(&hw->tnl_lock);
 
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
-		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].port) {
+		if (hw->tnl.tbl[i].valid && hw->tnl.tbl[i].port &&
+		    (type == TNL_LAST || type == hw->tnl.tbl[i].type)) {
 			*port = hw->tnl.tbl[i].port;
 			res = true;
 			break;
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
index 344c2637facd..a2863f38fd1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.h
@@ -33,7 +33,8 @@ enum ice_status
 ice_get_sw_fv_list(struct ice_hw *hw, u8 *prot_ids, u16 ids_cnt,
 		   unsigned long *bm, struct list_head *fv_list);
 bool
-ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port);
+ice_get_open_tunnel_port(struct ice_hw *hw, u16 *port,
+			 enum ice_tunnel_type type);
 int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
 			    unsigned int idx, struct udp_tunnel_info *ti);
 int ice_udp_tunnel_unset_port(struct net_device *netdev, unsigned int table,
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 793f4a9fc2cd..183d93033890 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -3796,10 +3796,13 @@ static struct ice_protocol_entry ice_prot_id_tbl[ICE_PROTOCOL_LAST] = {
  * ice_find_recp - find a recipe
  * @hw: pointer to the hardware structure
  * @lkup_exts: extension sequence to match
+ * @tun_type: type of recipe tunnel
  *
  * Returns index of matching recipe, or ICE_MAX_NUM_RECIPES if not found.
  */
-static u16 ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts)
+static u16
+ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts,
+	      enum ice_sw_tunnel_type tun_type)
 {
 	bool refresh_required = true;
 	struct ice_sw_recipe *recp;
@@ -3860,8 +3863,9 @@ static u16 ice_find_recp(struct ice_hw *hw, struct ice_prot_lkup_ext *lkup_exts)
 			}
 			/* If for "i"th recipe the found was never set to false
 			 * then it means we found our match
+			 * Also tun type of recipe needs to be checked
 			 */
-			if (found)
+			if (found && recp[i].tun_type == tun_type)
 				return i; /* Return the recipe ID */
 		}
 	}
@@ -4651,11 +4655,12 @@ ice_add_adv_recipe(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	}
 
 	/* Look for a recipe which matches our requested fv / mask list */
-	*rid = ice_find_recp(hw, lkup_exts);
+	*rid = ice_find_recp(hw, lkup_exts, rinfo->tun_type);
 	if (*rid < ICE_MAX_NUM_RECIPES)
 		/* Success if found a recipe that match the existing criteria */
 		goto err_unroll;
 
+	rm->tun_type = rinfo->tun_type;
 	/* Recipe we need does not exist, add a recipe */
 	status = ice_add_sw_recipe(hw, rm, profiles);
 	if (status)
@@ -4958,11 +4963,13 @@ ice_fill_adv_packet_tun(struct ice_hw *hw, enum ice_sw_tunnel_type tun_type,
 
 	switch (tun_type) {
 	case ICE_SW_TUN_VXLAN:
+		if (!ice_get_open_tunnel_port(hw, &open_port, TNL_VXLAN))
+			return ICE_ERR_CFG;
+		break;
 	case ICE_SW_TUN_GENEVE:
-		if (!ice_get_open_tunnel_port(hw, &open_port))
+		if (!ice_get_open_tunnel_port(hw, &open_port, TNL_GENEVE))
 			return ICE_ERR_CFG;
 		break;
-
 	default:
 		/* Nothing needs to be done for this tunnel type */
 		return 0;
@@ -5555,7 +5562,7 @@ ice_rem_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (status)
 		return status;
 
-	rid = ice_find_recp(hw, &lkup_exts);
+	rid = ice_find_recp(hw, &lkup_exts, rinfo->tun_type);
 	/* If did not find a recipe that match the existing criteria */
 	if (rid == ICE_MAX_NUM_RECIPES)
 		return ICE_ERR_PARAM;
diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 384439a267ad..25cca5c4ae57 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -795,7 +795,8 @@ ice_parse_tunnel_attr(struct net_device *dev, struct flow_rule *rule,
 		headers->l3_mask.ttl = match.mask->ttl;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS)) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_PORTS) &&
+	    fltr->tunnel_type != TNL_VXLAN && fltr->tunnel_type != TNL_GENEVE) {
 		struct flow_match_ports match;
 
 		flow_rule_match_enc_ports(rule, &match);
-- 
2.31.1

