Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267AE4E994A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbiC1OXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243765AbiC1OXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:23:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493A95DA69;
        Mon, 28 Mar 2022 07:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648477305; x=1680013305;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l4ladB7enXBGFYptXUzutTZKzemZwNUYE0C5E1wumoU=;
  b=ij/ryNGwnwCSon/72MvxKJkSAp9k9hcWIsusEqSlrJqZBtgWMqH5NDmQ
   3j4D0jM4Pa8H72/vImHKkwwKB5Rsd2WUetBCIhFOMUHgrVFjIttdHnpzU
   GZHZubWwSL5uKWSRY47oqkF4kFLpoMwQzgjzZdiTWFMsYZGODKqMY0SC2
   WctSHZuxMvp1Jz80ha96s04lFNFcmqQ/eFeYsSYtDtxOcQd4CooFJrS1e
   0J/Yq3NPYxurNBlB18EsFcYQ4QnpU3HZ0Zrq+jBJ0LAAMHZ4O+eCs2BFp
   6qk9N5fnlDCg6cVlszwW4Hh25Lyab057IHgYUri7a4Ii2HEcCsSF5a7rb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="259196087"
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="259196087"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 07:21:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,217,1643702400"; 
   d="scan'208";a="649076525"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 28 Mar 2022 07:21:43 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com, bjorn@kernel.org
Subject: [PATCH bpf 2/4] ice: xsk: eliminate unnecessary loop iteration
Date:   Mon, 28 Mar 2022 16:21:21 +0200
Message-Id: <20220328142123.170157-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
References: <20220328142123.170157-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

The NIC Tx ring completion routine cleans entries from the ring in
batches. However, it processes one more batch than it is supposed
to. Note that this does not matter from a functionality point of view
since it will not find a set DD bit for the next batch and just exit
the loop. But from a performance perspective, it is faster to
terminate the loop before and not issue an expensive read over PCIe to
get the DD bit.

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 88853a6ed931..51427cb4971a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -754,7 +754,7 @@ static u16 ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring, int napi_budget)
 		next_dd = next_dd + tx_thresh;
 		if (next_dd >= desc_cnt)
 			next_dd = tx_thresh - 1;
-	} while (budget--);
+	} while (--budget);
 
 	xdp_ring->next_dd = next_dd;
 
-- 
2.27.0

