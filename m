Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E8E4FFA42
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiDMPd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiDMPdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D834D37A9F;
        Wed, 13 Apr 2022 08:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863857; x=1681399857;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zR2LLs75XT0kCmEEP/LYE5KhyXYEesKqdXnC7IQSGqI=;
  b=DR0ebTJYeTq1WNSck7iIH4yu/07XmtE56XTrAB7yJoAPHIIMHDnciYtM
   6Vc82J+z6KgakKDSWMk3VWKWSKzvnr8CBtUn4KfvR4kxISAkY+6/tjfl4
   MO6g+8A0/Mm28v6ir8McW4S1qRK+sTeCyfrHXYye7aLRozKxisJqAhJMm
   YxgkFZw/DmUtij3CpzsEmSwO6A4jSgjcozZuCvqiFmVWNQL4mymRWEtVv
   XsIocRvFj51IAh1dhoM7Y/a9DFUKcNb4EuchF2ervJM2nPC/TlZI10kHm
   mZCxBouTjYNb97M40Jt52x8RBA8FaeTofjY3vsGHtdpctRw2W51IwtjRy
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544309"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544309"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318385"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:55 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 10/14] ixgbe: xsk: diversify return values from xsk_wakeup call paths
Date:   Wed, 13 Apr 2022 17:30:11 +0200
Message-Id: <20220413153015.453864-11-maciej.fijalkowski@intel.com>
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

Currently, when debugging AF_XDP workloads, one can correlate the -ENXIO
return code as the case that XSK is not in the bound state. Returning
same code from ndo_xsk_wakeup can be misleading and simply makes it
harder to follow what is going on.

Change ENXIOs in ixgbe's ndo_xsk_wakeup() implementation to EINVALs, so
that when probing it is clear that something is wrong on the driver
side, not the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index bdd70b85a787..68532cffd453 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -526,10 +526,10 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		return -ENETDOWN;
 
 	if (!READ_ONCE(adapter->xdp_prog))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (qid >= adapter->num_xdp_queues)
-		return -ENXIO;
+		return -EINVAL;
 
 	ring = adapter->xdp_ring[qid];
 
@@ -537,7 +537,7 @@ int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		return -ENETDOWN;
 
 	if (!ring->xsk_pool)
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!napi_if_scheduled_mark_missed(&ring->q_vector->napi)) {
 		u64 eics = BIT_ULL(ring->q_vector->v_idx);
-- 
2.33.1

