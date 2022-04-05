Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31864F3C31
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 17:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238508AbiDEMF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 08:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380495AbiDELmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 07:42:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC11078FDF;
        Tue,  5 Apr 2022 04:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649156821; x=1680692821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tNyPP4zMu6+m0eD0jhm5nRuJJvIC5tf1PRKFyd4P1Vo=;
  b=GT9si91Jcb11RnQwHXKZVuSXXDZaIeE3Ac6fbMqSjNkuqV4f1/mqw/fc
   ZDsf1I5cR5avQL/R4ke3ZWxuri4eh/wTrGkDtfC1hMAP6brlzlVNWOcpd
   idgjZaRtgnoDtr7MUjQLUlWPE8S2PwUWb/A8JFgJgMKpiD8QrhVBRjhvh
   azFQb/VFn1WtNMmImqg4OEV3bUGpaU5TRR1eNn5EUUtN4iRau5nB9sf9w
   9G6le30Q7hAvpFLMU97rdR0vdsz9HsNnx9RnAJnwXwnnGPRfSLkkMkRzx
   6NC+vF3wY+BHj2EuIAu8XfGETc97TBPC5t6Rw7vBS0o32veAvBIyCToVK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="241308010"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="241308010"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 04:07:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="641570860"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Apr 2022 04:06:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org
Cc:     netdev@vger.kernel.org, brouer@redhat.com, maximmi@nvidia.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 08/10] ixgbe: xsk: diversify return values from xsk_wakeup call paths
Date:   Tue,  5 Apr 2022 13:06:29 +0200
Message-Id: <20220405110631.404427-9-maciej.fijalkowski@intel.com>
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

Currently, when debugging AF_XDP workloads, one can correlate the -ENXIO
return code as the case that XSK is not in the bound state. Returning
same code from ndo_xsk_wakeup can be misleading and simply makes it
harder to follow what is going on.

Change ENXIOs in ixgbe's ndo_xsk_wakeup() implementations to EINVALs, so
that when probing it is clear that something is wrong on the driver
side, not in the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 475244a2c6e4..c8870da7af72 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -523,10 +523,10 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		return -ENETDOWN;
 
 	if (!READ_ONCE(adapter->xdp_prog))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (qid >= adapter->num_xdp_queues)
-		return -ENXIO;
+		return -EINVAL;
 
 	ring = adapter->xdp_ring[qid];
 
@@ -534,7 +534,7 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		return -ENETDOWN;
 
 	if (!ring->xsk_pool)
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
 		u64 eics = BIT_ULL(ring->q_vector->v_idx);
-- 
2.33.1

