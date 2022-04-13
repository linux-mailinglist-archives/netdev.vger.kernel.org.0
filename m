Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D344FFA32
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbiDMPdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDMPc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:32:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6333337A03;
        Wed, 13 Apr 2022 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863837; x=1681399837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hLCIV0xDKVUO54k59dWJqyAkxQMhB+VY6VyVkCjIRwo=;
  b=iopa6syL2Jl+eTVQnSKNx5iAYCX7krRBa0SqYAqO/W4WPominObYdxmr
   awBBW6aptFylIT6X0v6ee0vSYXJbqTuLVfI8KcK6zylBypo1xt7I+aNZD
   Z+fWN9werTVOOfGT4G8c3LZbVaIRPAfxiPc3EHi4O8s0mHRlI+1OWabfo
   alUT24oSUIhUa40Xk+L33RL/Hd/48tCKAps3wCTDtkZFdQEcaATysF047
   DnE077e99ZmMviil/7u6GDkxD8ADraClBxLbeXyy03YxxBbdl1R0chKX2
   xaX4ySzpI2y+HB+82Z6r8Zmlo3XyF7VPot0/OirgNAvfY8C9Pw42JexmN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544193"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544193"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318227"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:34 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: [PATCH v2 bpf-next 03/14] ice: xsk: decorate ICE_XDP_REDIR with likely()
Date:   Wed, 13 Apr 2022 17:30:04 +0200
Message-Id: <20220413153015.453864-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_run_xdp_zc() suggests to compiler that XDP_REDIRECT is the most
probable action returned from BPF program that AF_XDP has in its
pipeline. Let's also bring this suggestion up to the callsite of
ice_run_xdp_zc() so that compiler will be able to generate more
optimized code which in turn will make branch predictor happy.

Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 866ee4df9671..e9ff05de0084 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -629,18 +629,19 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		xsk_buff_dma_sync_for_cpu(xdp, rx_ring->xsk_pool);
 
 		xdp_res = ice_run_xdp_zc(rx_ring, xdp, xdp_prog, xdp_ring);
-		if (xdp_res) {
-			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
-				xdp_xmit |= xdp_res;
-			else
-				xsk_buff_free(xdp);
+		if (likely(xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR)))
+			xdp_xmit |= xdp_res;
+		else if (xdp_res == ICE_XDP_CONSUMED)
+			xsk_buff_free(xdp);
+		else
+			goto construct_skb;
 
-			total_rx_bytes += size;
-			total_rx_packets++;
+		total_rx_bytes += size;
+		total_rx_packets++;
+
+		ice_bump_ntc(rx_ring);
+		continue;
 
-			ice_bump_ntc(rx_ring);
-			continue;
-		}
 construct_skb:
 		/* XDP_PASS path */
 		skb = ice_construct_skb_zc(rx_ring, xdp);
-- 
2.33.1

