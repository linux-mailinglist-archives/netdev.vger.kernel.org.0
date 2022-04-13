Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2A64FFA44
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiDMPde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiDMPd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 826B837BEF;
        Wed, 13 Apr 2022 08:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863865; x=1681399865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYH2RJS/d0A3UuePhevxDHsE0BibcVkMT3K9xBY9ZEY=;
  b=hYTW6Y73SKvIuZ+d7eanPxmsVfQwoOPhCIp7HEf5K+8iYX9wEQs2Aa91
   Xph5kU2gH0hx3EnAIkkPcDNeIZAg9WcJe9JBRvIlTKUoRP2bcp+0wpb4H
   S7JZtRG4eecoXDyIS+ruXQhOdV+56H0i3jPHKLu1J37Ht8hE312NolA/2
   pZmvG6A56eAfKMRsuFukoBjn8ULc6r3LnjBlc9bK2dNeI7M7/uZUMblJz
   YBTkMy0tmHLOKA5zyfSm7w8V847VtJrxZ4Hcm/dboJavgnvL/n3MdeXqy
   BeijZb1ICpOopR8GWQXzQmta4c3Fv2WLetHdsscSpnRgUzmoq0NNMVMZY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544344"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544344"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318427"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:31:02 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 13/14] ice: xsk: avoid refilling single Rx descriptors
Date:   Wed, 13 Apr 2022 17:30:14 +0200
Message-Id: <20220413153015.453864-14-maciej.fijalkowski@intel.com>
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

Call alloc Rx routine for ZC driver only when the amount of unallocated
descriptors exceeds given threshold.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 53c299eebd99..c26b408ba419 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -587,6 +587,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 	unsigned int xdp_xmit = 0;
 	struct bpf_prog *xdp_prog;
 	bool failure = false;
+	int entries_to_alloc;
 
 	/* ZC patch is enabled only when XDP program is set,
 	 * so here it can not be NULL
@@ -678,7 +679,9 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
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

