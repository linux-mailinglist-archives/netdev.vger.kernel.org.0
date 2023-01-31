Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AEF6837D5
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 21:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjAaUrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 15:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjAaUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 15:47:07 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0080959B4C;
        Tue, 31 Jan 2023 12:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675198015; x=1706734015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kOWRheW7fwAeLC+2dD2fzA8D77VjXbWMzFjbcbtqfTY=;
  b=KCzGqW+vacnLekqyhctpEwKhcFI5rcXhdl8p8dl9P3nmn9E/W+4bvMPT
   whfQAhz0zybuzu0MPnfSyD8eAdarPpTRYd2TXBfwE2/WEOtGz6BECYpGp
   6Kt1CLglKtTwXoAvfJnR+CxL/h7btuDyuGgu4nZKXrOWsCSVYQeDGyLU0
   nl9l+fCYR5pXEjcT1vKf7jot+w4tQoE8/W8N4AQy8lIjBLnOLg6VLumg2
   Le9mQJMrJIDr93rj6rV1kxq6t9gudT0Da7+y8pGiIhgxKL/v0Tz9SsXmN
   IT4W3eaxgm59zEXhQ+jImTlxl+9tymwt92+7Uw6gREgrOsL+KnN+5BPog
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="414167511"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="414167511"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 12:46:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="788595470"
X-IronPort-AV: E=Sophos;i="5.97,261,1669104000"; 
   d="scan'208";a="788595470"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2023 12:45:41 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 12/13] ice: remove next_{dd,rs} fields from ice_tx_ring
Date:   Tue, 31 Jan 2023 21:45:05 +0100
Message-Id: <20230131204506.219292-13-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
References: <20230131204506.219292-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that both ZC and standard XDP data paths stopped using Tx logic
based on next_dd and next_rs fields, we can safely remove these fields
and shrink Tx ring structure.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 --
 drivers/net/ethernet/intel/ice/ice_main.c    | 2 --
 drivers/net/ethernet/intel/ice/ice_txrx.c    | 2 --
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 2 --
 4 files changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 205d32e4c317..1611f25b6d01 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3027,8 +3027,6 @@ ice_set_ringparam(struct net_device *netdev, struct ethtool_ringparam *ring,
 		/* clone ring and setup updated count */
 		xdp_rings[i] = *vsi->xdp_rings[i];
 		xdp_rings[i].count = new_tx_cnt;
-		xdp_rings[i].next_dd = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
-		xdp_rings[i].next_rs = ICE_RING_QUARTER(&xdp_rings[i]) - 1;
 		xdp_rings[i].desc = NULL;
 		xdp_rings[i].tx_buf = NULL;
 		err = ice_setup_tx_ring(&xdp_rings[i]);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b04f7729d5ba..81b0437201a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2570,8 +2570,6 @@ static int ice_xdp_alloc_setup_rings(struct ice_vsi *vsi)
 		xdp_ring->netdev = NULL;
 		xdp_ring->dev = dev;
 		xdp_ring->count = vsi->num_tx_desc;
-		xdp_ring->next_dd = ICE_RING_QUARTER(xdp_ring) - 1;
-		xdp_ring->next_rs = ICE_RING_QUARTER(xdp_ring) - 1;
 		WRITE_ONCE(vsi->xdp_rings[i], xdp_ring);
 		if (ice_setup_tx_ring(xdp_ring))
 			goto free_xdp_rings;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 38c6bd615127..8e211b210a24 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -174,8 +174,6 @@ void ice_clean_tx_ring(struct ice_tx_ring *tx_ring)
 
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
-	tx_ring->next_dd = ICE_RING_QUARTER(tx_ring) - 1;
-	tx_ring->next_rs = ICE_RING_QUARTER(tx_ring) - 1;
 
 	if (!tx_ring->netdev)
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 55f47c560981..7903bb692c1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -343,8 +343,6 @@ struct ice_tx_ring {
 	struct xsk_buff_pool *xsk_pool;
 	u16 next_to_use;
 	u16 next_to_clean;
-	u16 next_rs;
-	u16 next_dd;
 	u16 q_handle;			/* Queue handle per TC */
 	u16 reg_idx;			/* HW register index of the ring */
 	u16 count;			/* Number of descriptors */
-- 
2.34.1

