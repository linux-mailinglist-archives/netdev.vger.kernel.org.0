Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78A66E4414
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjDQJir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjDQJi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:38:28 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EC761B2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681724276; x=1713260276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WVMzcQmJMWcYa/TVIasKk8Rv+Cg1TScngvGoHZla3FY=;
  b=f5xnijpLOEqiwIc4yKDHK79cOoWjsz7/7Dmdh2U6IfCFeLiPdIy3VHvN
   GaxJiz8O9SiOtLFUncGfVvXquq5AL4CIDxm28JGq2p1Xb6yMsSLKHkp9S
   SzZAqbSQT6vrsyggqXzZshDDxF3HhZ8jfGqLtYr1urOC2xgZZig5TxWdC
   3DmJeGKwgndaeWNzPKbwheO4oZLp/UMhsIWFOwfMUu1+8K/IjyesqMOea
   dfPO9WYwnHOd+tQKMTgAJvvCCo0cVIJKbTsQowU5ceYQpJ+pNt2wJMj3T
   iwHWReFV7xgUmiCXdz8V9N1syxiNsm4dZAgTLynTMLeHOFf19cugF42sq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="333644098"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="333644098"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 02:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10682"; a="640899272"
X-IronPort-AV: E=Sophos;i="5.99,203,1677571200"; 
   d="scan'208";a="640899272"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2023 02:35:25 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id 76DF937F56;
        Mon, 17 Apr 2023 10:35:24 +0100 (IST)
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        david.m.ertman@intel.com, michal.swiatkowski@linux.intel.com,
        marcin.szycik@linux.intel.com, pawel.chmielewski@intel.com,
        sridhar.samudrala@intel.com
Subject: [PATCH net-next 12/12] ice: Ethtool fdb_cnt stats
Date:   Mon, 17 Apr 2023 11:34:12 +0200
Message-Id: <20230417093412.12161-13-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417093412.12161-1-wojciech.drewek@intel.com>
References: <20230417093412.12161-1-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new ethtool statistic which is 'fdb_cnt'. It
provides information about how many bridge fdbs are created on
a given netdev.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h            | 2 ++
 drivers/net/ethernet/intel/ice/ice_eswitch_br.c | 6 ++++++
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 489934ddfbb8..90e007942af6 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -350,6 +350,8 @@ struct ice_vsi {
 	u16 num_gfltr;
 	u16 num_bfltr;
 
+	u32 fdb_cnt;
+
 	/* RSS config */
 	u16 rss_table_size;	/* HW RSS table size */
 	u16 rss_size;		/* Allocated RSS queues */
diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 4a69b3a67914..cfa4324bf1a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -330,6 +330,7 @@ static void
 ice_eswitch_br_fdb_entry_delete(struct ice_esw_br *bridge,
 				struct ice_esw_br_fdb_entry *fdb_entry)
 {
+	struct ice_vsi *vsi = fdb_entry->br_port->vsi;
 	struct ice_pf *pf = bridge->br_offloads->pf;
 
 	rhashtable_remove_fast(&bridge->fdb_ht, &fdb_entry->ht_node,
@@ -339,6 +340,7 @@ ice_eswitch_br_fdb_entry_delete(struct ice_esw_br *bridge,
 	ice_eswitch_br_flow_delete(pf, fdb_entry->flow);
 
 	kfree(fdb_entry);
+	vsi->fdb_cnt--;
 }
 
 static void
@@ -462,6 +464,8 @@ ice_eswitch_br_fdb_entry_create(struct net_device *netdev,
 
 	ice_eswitch_br_fdb_offload_notify(netdev, mac, vid, event);
 
+	br_port->vsi->fdb_cnt++;
+
 	return;
 
 err_fdb_insert:
@@ -941,6 +945,7 @@ ice_eswitch_br_vf_repr_port_init(struct ice_esw_br *bridge,
 	br_port->vsi_idx = br_port->vsi->idx;
 	br_port->type = ICE_ESWITCH_BR_VF_REPR_PORT;
 	repr->br_port = br_port;
+	repr->src_vsi->fdb_cnt = 0;
 
 	err = xa_insert(&bridge->ports, br_port->vsi_idx, br_port, GFP_KERNEL);
 	if (err) {
@@ -966,6 +971,7 @@ ice_eswitch_br_uplink_port_init(struct ice_esw_br *bridge, struct ice_pf *pf)
 	br_port->vsi_idx = br_port->vsi->idx;
 	br_port->type = ICE_ESWITCH_BR_UPLINK_PORT;
 	pf->br_port = br_port;
+	vsi->fdb_cnt = 0;
 
 	err = xa_insert(&bridge->ports, br_port->vsi_idx, br_port, GFP_KERNEL);
 	if (err) {
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 8407c7175cf6..d06b2a688323 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -64,6 +64,7 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
 	ICE_VSI_STAT("tx_linearize", tx_linearize),
 	ICE_VSI_STAT("tx_busy", tx_busy),
 	ICE_VSI_STAT("tx_restart", tx_restart),
+	ICE_VSI_STAT("fdb_cnt", fdb_cnt),
 };
 
 enum ice_ethtool_test_id {
-- 
2.39.2

