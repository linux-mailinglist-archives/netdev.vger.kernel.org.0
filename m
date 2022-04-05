Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E17A4F3C1D
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiDEMEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380502AbiDELmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6ED10CF19;
        Tue,  5 Apr 2022 04:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156824; x=1680692824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3nEl74+XZdmx/UlrD16oeykFiO71kSqBziCY+MfUjc=;
  b=BXEGrJO1hBE7ySDwFAgMDmxdseYbz1F1k0Jb7wxDt4TfIDf+JKypiL62
   rf2m5VY3ddCPHyMnI4f7X3TlLXHdiU4oWDLkNQEmGud82YCgNxo7K0jPV
   NeNPhtXEph+0sce/dPuhMrzwKGAOjbFQhcbMEDNFNDTEimb25Jk16pIE4
   knIkTO6q86ePGzrLCvnwf8zlt0bihnichXn8D1qE8bWuO9VL71W8c6gTI
   HVbPZ+05lZANAeUbDN8zbC/yDevwkfL7MvatyQQ3PARMc0XxiIBPodDbT
   PfYadgeD9Jasa+EQLiq8FB4tENhb70G34iauU65BQ6DVayZ0RFH/XsF/H
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241308020"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241308020"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:07:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570875"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:07:02 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 09/10] ice: xsk: avoid refilling single Rx descriptors
Date:   Tue,  5 Apr 2022 13:06:30 +0200
Message-Id: <20220405110631.404427-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
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

Call alloc Rx routine for ZC driver only when the amount of unallocated
descriptors exceeds given threshold.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 272c0daf9ed3..143f6b6937bd 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -581,6 +581,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
 	bool failure = false;
+	int entries_to_alloc;
 
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
@@ -673,7 +674,9 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 		ice_receive_skb(rx_ring, skb, vlan_tag);
 	}
 
-	failure |= !ice_alloc_rx_bufs_zc(rx_ring, ICE_DESC_UNUSED(rx_ring));
+	entries_to_alloc = ICE_DESC_UNUSED(rx_ring);
+	if (entries_to_alloc > ICE_RING_QUARTER(rx_ring))
+		failure |= !ice_alloc_rx_bufs_zc(rx_ring, entries_to_alloc);
 
 	ice_finalize_xdp_rx(xdp_ring, xdp_xmit);
 	ice_update_rx_ring_stats(rx_ring, total_rx_packets, total_rx_bytes);
-- 
2.33.1

