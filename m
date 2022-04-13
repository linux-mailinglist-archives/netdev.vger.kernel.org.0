Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82624FFA3E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236519AbiDMPdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbiDMPdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:33:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202A237AB2;
        Wed, 13 Apr 2022 08:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649863855; x=1681399855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GEOFI2L+Sr82ytthmiJvWAK5wJHfsuRxDbyttCm5JNQ=;
  b=lAMLez76tb38e3No8/dDRuloWRnBhecJ2ng1UNkCg4qQ6xpi+sGzVIWw
   CcQBU8/cHZUCyeZt/b1eSXK9GG8vIo/szO4IGRSes2lF2jFGdCT0A14Ev
   qUaRPnE2RVqPUeaGtIJOKc/S7XFWQhTrd6cdI7YSWSaKFA04gxvutLvZl
   5He2H3inOFLMs6VaVVtljMdNyrcq8oY5WWQR5CvBd4OjpEbUfCh4enQCK
   gc3dmQ6T+PQD4n/Bf82PSz/N4qNSGTH8Jjm+HHfvpwziLkRgeW+AvUwda
   jOToB2RYssgvGiOTuBvLQUTpdcZ+Sf150w9e1JazFF44ab31b5FkzhRBN
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="261544303"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="261544303"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 08:30:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573318367"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 08:30:52 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, maximmi@nvidia.com, kuba@kernel.org,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 09/14] i40e: xsk: diversify return values from xsk_wakeup call paths
Date:   Wed, 13 Apr 2022 17:30:10 +0200
Message-Id: <20220413153015.453864-10-maciej.fijalkowski@intel.com>
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

Change ENXIOs in i40e's ndo_xsk_wakeup() implementation to EINVALs, so
that when probing it is clear that something is wrong on the driver
side, not the xsk_{recv,send}msg.

There is a -ENETDOWN that can happen from both kernel/driver sides
though, but I don't have a correct replacement for this on one of the
sides, so let's keep it that way.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 94ea8288859a..050280fd10c1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -606,13 +606,13 @@ int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 		return -ENETDOWN;
 
 	if (!i40e_enabled_xdp_vsi(vsi))
-		return -ENXIO;
+		return -EINVAL;
 
 	if (queue_id >= vsi->num_queue_pairs)
-		return -ENXIO;
+		return -EINVAL;
 
 	if (!vsi->xdp_rings[queue_id]->xsk_pool)
-		return -ENXIO;
+		return -EINVAL;
 
 	ring = vsi->xdp_rings[queue_id];
 
-- 
2.33.1

