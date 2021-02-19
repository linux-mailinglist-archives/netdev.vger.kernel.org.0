Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C7C320058
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBSVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:36:10 -0500
Received: from mga03.intel.com ([134.134.136.65]:59577 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhBSVgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 16:36:04 -0500
IronPort-SDR: lvX+A7Jtn9SQ6Hz7+R93DZUByJs3SJ+XC6AfCtYV+Ia/dTTxZdBmlJtZs9zctwJ9ssFAj8tVYN
 YkxKUOfopFHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="184028686"
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="184028686"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 13:35:07 -0800
IronPort-SDR: spM3dms5iiSvSxkw6qaeOtnGdWT0jlVDxKhYY0gSU6CSMFmEMeD42dFA9xnJBKNNChr8/NPYYV
 6AaWhqsHt5vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="428012048"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2021 13:35:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Norbert Ciosek <norbertx.ciosek@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 8/8] i40e: Fix endianness conversions
Date:   Fri, 19 Feb 2021 13:36:06 -0800
Message-Id: <20210219213606.2567536-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Ciosek <norbertx.ciosek@intel.com>

Fixes the following sparse warnings:
i40e_main.c:5953:32: warning: cast from restricted __le16
i40e_main.c:8008:29: warning: incorrect type in assignment (different base types)
i40e_main.c:8008:29:    expected unsigned int [assigned] [usertype] ipa
i40e_main.c:8008:29:    got restricted __le32 [usertype]
i40e_main.c:8008:29: warning: incorrect type in assignment (different base types)
i40e_main.c:8008:29:    expected unsigned int [assigned] [usertype] ipa
i40e_main.c:8008:29:    got restricted __le32 [usertype]
i40e_txrx.c:1950:59: warning: incorrect type in initializer (different base types)
i40e_txrx.c:1950:59:    expected unsigned short [usertype] vlan_tag
i40e_txrx.c:1950:59:    got restricted __le16 [usertype] l2tag1
i40e_txrx.c:1953:40: warning: cast to restricted __le16
i40e_xsk.c:448:38: warning: invalid assignment: |=
i40e_xsk.c:448:38:    left side has type restricted __le64
i40e_xsk.c:448:38:    right side has type int

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Fixes: 2a508c64ad27 ("i40e: fix VLAN.TCI == 0 RX HW offload")
Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
Fixes: 8f88b3034db3 ("i40e: Add infrastructure for queue channel support")
Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 ++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3e4a4d6f0419..4a2d03cada01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5920,7 +5920,7 @@ static int i40e_add_channel(struct i40e_pf *pf, u16 uplink_seid,
 	ch->enabled_tc = !i40e_is_channel_macvlan(ch) && enabled_tc;
 	ch->seid = ctxt.seid;
 	ch->vsi_number = ctxt.vsi_number;
-	ch->stat_counter_idx = cpu_to_le16(ctxt.info.stat_counter_idx);
+	ch->stat_counter_idx = le16_to_cpu(ctxt.info.stat_counter_idx);
 
 	/* copy just the sections touched not the entire info
 	 * since not all sections are valid as returned by
@@ -7599,8 +7599,8 @@ static inline void
 i40e_set_cld_element(struct i40e_cloud_filter *filter,
 		     struct i40e_aqc_cloud_filters_element_data *cld)
 {
-	int i, j;
 	u32 ipa;
+	int i;
 
 	memset(cld, 0, sizeof(*cld));
 	ether_addr_copy(cld->outer_mac, filter->dst_mac);
@@ -7611,14 +7611,14 @@ i40e_set_cld_element(struct i40e_cloud_filter *filter,
 
 	if (filter->n_proto == ETH_P_IPV6) {
 #define IPV6_MAX_INDEX	(ARRAY_SIZE(filter->dst_ipv6) - 1)
-		for (i = 0, j = 0; i < ARRAY_SIZE(filter->dst_ipv6);
-		     i++, j += 2) {
+		for (i = 0; i < ARRAY_SIZE(filter->dst_ipv6); i++) {
 			ipa = be32_to_cpu(filter->dst_ipv6[IPV6_MAX_INDEX - i]);
-			ipa = cpu_to_le32(ipa);
-			memcpy(&cld->ipaddr.raw_v6.data[j], &ipa, sizeof(ipa));
+
+			*(__le32 *)&cld->ipaddr.raw_v6.data[i * 2] = cpu_to_le32(ipa);
 		}
 	} else {
 		ipa = be32_to_cpu(filter->dst_ipv4);
+
 		memcpy(&cld->ipaddr.v4.data, &ipa, sizeof(ipa));
 	}
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 32d97315f3f5..903d4e8cb0a1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1793,7 +1793,7 @@ void i40e_process_skb_fields(struct i40e_ring *rx_ring,
 	skb_record_rx_queue(skb, rx_ring->queue_index);
 
 	if (qword & BIT(I40E_RX_DESC_STATUS_L2TAG1P_SHIFT)) {
-		u16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
+		__le16 vlan_tag = rx_desc->wb.qword0.lo_dword.l2tag1;
 
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       le16_to_cpu(vlan_tag));
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 492ce213208d..37a21fb99922 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -444,7 +444,7 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
 	struct i40e_tx_desc *tx_desc;
 
 	tx_desc = I40E_TX_DESC(xdp_ring, ntu);
-	tx_desc->cmd_type_offset_bsz |= (I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
+	tx_desc->cmd_type_offset_bsz |= cpu_to_le64(I40E_TX_DESC_CMD_RS << I40E_TXD_QW1_CMD_SHIFT);
 }
 
 /**
-- 
2.26.2

