Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597499F05D
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbfH0Qij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:38:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:7283 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfH0Qig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:38:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 09:38:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="331876327"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 27 Aug 2019 09:38:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Usha Ketineni <usha.k.ketineni@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] ice: Fix ethtool port and PFC stats for 4x25G cards
Date:   Tue, 27 Aug 2019 09:38:18 -0700
Message-Id: <20190827163832.8362-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Usha Ketineni <usha.k.ketineni@intel.com>

This patch fixes the issue where port and PFC statistics counters are
incrementing at the wrong port with 4x25G cards.
Read the GLPRT port registers using lport parameter instead of pf_id to
update the statistics otherwise the pf_ids are flipped for ports 2 and 3
when read from the HW register PF_FUNC_RID and this is expected as per
hardware specification.

Signed-off-by: Usha Ketineni <usha.k.ketineni@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 13 ++--
 drivers/net/ethernet/intel/ice/ice_main.c    | 76 ++++++++++----------
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 734cef8eed9e..d9578919aad8 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -500,30 +500,31 @@ void ice_update_dcb_stats(struct ice_pf *pf)
 {
 	struct ice_hw_port_stats *prev_ps, *cur_ps;
 	struct ice_hw *hw = &pf->hw;
-	u8 pf_id = hw->pf_id;
+	u8 port;
 	int i;
 
+	port = hw->port_info->lport;
 	prev_ps = &pf->stats_prev;
 	cur_ps = &pf->stats;
 
 	for (i = 0; i < 8; i++) {
-		ice_stat_update32(hw, GLPRT_PXOFFRXC(pf_id, i),
+		ice_stat_update32(hw, GLPRT_PXOFFRXC(port, i),
 				  pf->stat_prev_loaded,
 				  &prev_ps->priority_xoff_rx[i],
 				  &cur_ps->priority_xoff_rx[i]);
-		ice_stat_update32(hw, GLPRT_PXONRXC(pf_id, i),
+		ice_stat_update32(hw, GLPRT_PXONRXC(port, i),
 				  pf->stat_prev_loaded,
 				  &prev_ps->priority_xon_rx[i],
 				  &cur_ps->priority_xon_rx[i]);
-		ice_stat_update32(hw, GLPRT_PXONTXC(pf_id, i),
+		ice_stat_update32(hw, GLPRT_PXONTXC(port, i),
 				  pf->stat_prev_loaded,
 				  &prev_ps->priority_xon_tx[i],
 				  &cur_ps->priority_xon_tx[i]);
-		ice_stat_update32(hw, GLPRT_PXOFFTXC(pf_id, i),
+		ice_stat_update32(hw, GLPRT_PXOFFTXC(port, i),
 				  pf->stat_prev_loaded,
 				  &prev_ps->priority_xoff_tx[i],
 				  &cur_ps->priority_xoff_tx[i]);
-		ice_stat_update32(hw, GLPRT_RXON2OFFCNT(pf_id, i),
+		ice_stat_update32(hw, GLPRT_RXON2OFFCNT(port, i),
 				  pf->stat_prev_loaded,
 				  &prev_ps->priority_xon_2_xoff[i],
 				  &cur_ps->priority_xon_2_xoff[i]);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f3923dec32b7..76a647cc2dbd 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3262,25 +3262,25 @@ void ice_update_pf_stats(struct ice_pf *pf)
 {
 	struct ice_hw_port_stats *prev_ps, *cur_ps;
 	struct ice_hw *hw = &pf->hw;
-	u8 pf_id;
+	u8 port;
 
+	port = hw->port_info->lport;
 	prev_ps = &pf->stats_prev;
 	cur_ps = &pf->stats;
-	pf_id = hw->pf_id;
 
-	ice_stat_update40(hw, GLPRT_GORCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_GORCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.rx_bytes,
 			  &cur_ps->eth.rx_bytes);
 
-	ice_stat_update40(hw, GLPRT_UPRCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_UPRCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.rx_unicast,
 			  &cur_ps->eth.rx_unicast);
 
-	ice_stat_update40(hw, GLPRT_MPRCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_MPRCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.rx_multicast,
 			  &cur_ps->eth.rx_multicast);
 
-	ice_stat_update40(hw, GLPRT_BPRCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_BPRCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.rx_broadcast,
 			  &cur_ps->eth.rx_broadcast);
 
@@ -3288,109 +3288,109 @@ void ice_update_pf_stats(struct ice_pf *pf)
 			  &prev_ps->eth.rx_discards,
 			  &cur_ps->eth.rx_discards);
 
-	ice_stat_update40(hw, GLPRT_GOTCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_GOTCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.tx_bytes,
 			  &cur_ps->eth.tx_bytes);
 
-	ice_stat_update40(hw, GLPRT_UPTCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_UPTCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.tx_unicast,
 			  &cur_ps->eth.tx_unicast);
 
-	ice_stat_update40(hw, GLPRT_MPTCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_MPTCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.tx_multicast,
 			  &cur_ps->eth.tx_multicast);
 
-	ice_stat_update40(hw, GLPRT_BPTCL(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_BPTCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.tx_broadcast,
 			  &cur_ps->eth.tx_broadcast);
 
-	ice_stat_update32(hw, GLPRT_TDOLD(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_TDOLD(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_dropped_link_down,
 			  &cur_ps->tx_dropped_link_down);
 
-	ice_stat_update40(hw, GLPRT_PRC64L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC64L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_64, &cur_ps->rx_size_64);
 
-	ice_stat_update40(hw, GLPRT_PRC127L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC127L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_127, &cur_ps->rx_size_127);
 
-	ice_stat_update40(hw, GLPRT_PRC255L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC255L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_255, &cur_ps->rx_size_255);
 
-	ice_stat_update40(hw, GLPRT_PRC511L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC511L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_511, &cur_ps->rx_size_511);
 
-	ice_stat_update40(hw, GLPRT_PRC1023L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC1023L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_1023, &cur_ps->rx_size_1023);
 
-	ice_stat_update40(hw, GLPRT_PRC1522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC1522L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_1522, &cur_ps->rx_size_1522);
 
-	ice_stat_update40(hw, GLPRT_PRC9522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PRC9522L(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_size_big, &cur_ps->rx_size_big);
 
-	ice_stat_update40(hw, GLPRT_PTC64L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC64L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_64, &cur_ps->tx_size_64);
 
-	ice_stat_update40(hw, GLPRT_PTC127L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC127L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_127, &cur_ps->tx_size_127);
 
-	ice_stat_update40(hw, GLPRT_PTC255L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC255L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_255, &cur_ps->tx_size_255);
 
-	ice_stat_update40(hw, GLPRT_PTC511L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC511L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_511, &cur_ps->tx_size_511);
 
-	ice_stat_update40(hw, GLPRT_PTC1023L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC1023L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_1023, &cur_ps->tx_size_1023);
 
-	ice_stat_update40(hw, GLPRT_PTC1522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC1522L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_1522, &cur_ps->tx_size_1522);
 
-	ice_stat_update40(hw, GLPRT_PTC9522L(pf_id), pf->stat_prev_loaded,
+	ice_stat_update40(hw, GLPRT_PTC9522L(port), pf->stat_prev_loaded,
 			  &prev_ps->tx_size_big, &cur_ps->tx_size_big);
 
-	ice_stat_update32(hw, GLPRT_LXONRXC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_LXONRXC(port), pf->stat_prev_loaded,
 			  &prev_ps->link_xon_rx, &cur_ps->link_xon_rx);
 
-	ice_stat_update32(hw, GLPRT_LXOFFRXC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_LXOFFRXC(port), pf->stat_prev_loaded,
 			  &prev_ps->link_xoff_rx, &cur_ps->link_xoff_rx);
 
-	ice_stat_update32(hw, GLPRT_LXONTXC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_LXONTXC(port), pf->stat_prev_loaded,
 			  &prev_ps->link_xon_tx, &cur_ps->link_xon_tx);
 
-	ice_stat_update32(hw, GLPRT_LXOFFTXC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_LXOFFTXC(port), pf->stat_prev_loaded,
 			  &prev_ps->link_xoff_tx, &cur_ps->link_xoff_tx);
 
 	ice_update_dcb_stats(pf);
 
-	ice_stat_update32(hw, GLPRT_CRCERRS(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_CRCERRS(port), pf->stat_prev_loaded,
 			  &prev_ps->crc_errors, &cur_ps->crc_errors);
 
-	ice_stat_update32(hw, GLPRT_ILLERRC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_ILLERRC(port), pf->stat_prev_loaded,
 			  &prev_ps->illegal_bytes, &cur_ps->illegal_bytes);
 
-	ice_stat_update32(hw, GLPRT_MLFC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_MLFC(port), pf->stat_prev_loaded,
 			  &prev_ps->mac_local_faults,
 			  &cur_ps->mac_local_faults);
 
-	ice_stat_update32(hw, GLPRT_MRFC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_MRFC(port), pf->stat_prev_loaded,
 			  &prev_ps->mac_remote_faults,
 			  &cur_ps->mac_remote_faults);
 
-	ice_stat_update32(hw, GLPRT_RLEC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_RLEC(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_len_errors, &cur_ps->rx_len_errors);
 
-	ice_stat_update32(hw, GLPRT_RUC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_RUC(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_undersize, &cur_ps->rx_undersize);
 
-	ice_stat_update32(hw, GLPRT_RFC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_RFC(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_fragments, &cur_ps->rx_fragments);
 
-	ice_stat_update32(hw, GLPRT_ROC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_ROC(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_oversize, &cur_ps->rx_oversize);
 
-	ice_stat_update32(hw, GLPRT_RJC(pf_id), pf->stat_prev_loaded,
+	ice_stat_update32(hw, GLPRT_RJC(port), pf->stat_prev_loaded,
 			  &prev_ps->rx_jabber, &cur_ps->rx_jabber);
 
 	pf->stat_prev_loaded = true;
-- 
2.21.0

