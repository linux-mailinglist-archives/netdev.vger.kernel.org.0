Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131694FFA47
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiDMPdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiDMPd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:26 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D8137BD0;
        Wed, 13 Apr 2022 08:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863862; x=1681399862;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g4dm2m2hBU8t34U2sYB3MEK8uSxXcD6yVdkrodWYRhk=;
  b=Wn0TIdppgJbAcXtOilLT+vZta3CF9SpOYaEteEhYiAFvui5wm7YJxhsn
   yDLGKh3JWP2613ckMOyvc0mNgvhZt6S2TpkM9wc/9haTn/1NMFGekOCtj
   ep16RtzHfmE7qXjcO0kf7hsz46VYScBrdjh/kvyUdqA6ALcpk4REqPq9M
   qxtlmwPwvOhS549j4XJPABrzNErNE6wkxlJxMPsyx4p1cFyAlXuQHXVNz
   lmvsb5GQ2lLr0eQiGaCAbhvBFUiXf2yCVcLjzGPqHTty16X4iAFtRVrV8
   17pEpupFYrg5TT27FjwUmlOIgz4xFzFDqP8SzFYm66NHkiLaowKdG8TmB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544330"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544330"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:31:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318419"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 12/14] stmmac: xsk: diversify return values from xsk_wakeup call paths
Date:   Wed, 13 Apr 2022 17:30:13 +0200
Message-Id: <20220413153015.453864-13-maciej.fijalkowski@intel.com>
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

Change ENXIOs in stmmac's ndo_xsk_wakeup() implementation to EINVALs, so
that when probing it is clear that something is wrong on the driver
side, not the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4a4b3651ab3e..c9e077b2a56e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6565,7 +6565,7 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 		return -ENETDOWN;
 
 	if (!stmmac_xdp_is_enabled(priv))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (queue >= priv->plat->rx_queues_to_use ||
 	    queue >= priv->plat->tx_queues_to_use)
@@ -6576,7 +6576,7 @@ int stmmac_xsk_wakeup(struct net_device *dev, u32 queue, u32 flags)
 	ch = &priv->channel[queue];
 
 	if (!rx_q->xsk_pool && !tx_q->xsk_pool)
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!napi_if_scheduled_mark_missed(&ch->rxtx_napi)) {
 		/* EQoS does not have per-DMA channel SW interrupt,
-- 
2.33.1

