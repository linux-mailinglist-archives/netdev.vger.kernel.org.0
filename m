Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284805A569D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiH2WBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiH2WBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:01:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0F66A78
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661810463; x=1693346463;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P0VhT4DIpVhm2gqjNA6oELysweMUlFdFdcyBDPDeuoY=;
  b=U3Ct4/8bMe17hGnfY0OAqMA7tHeErMJE880onrBQySwu9bNwKQK/YDyf
   foBwG3NU32g0LmDwuywH1mcPG6e6PWtInuj3DltWZwc8xI7jb0RDuntNJ
   KvwOPZRI3TdE/BkT2oyBfv9vveLdgN5wyPzsvdwzZc8jHINkPbyy1TipT
   fkfektFocqJy/6ganneygpj43NaDphORt7P6kAnp6CDetjsapVx2SCROv
   vY9pEETpYvIgrRVyFFLnVKVGR8z9eNmBvWrYvtQhNvVFPUbMJg0xz/8AZ
   cLGxqYK7XQQ2hM/mqWY2bCgtwiwgyqamq3xN2n+Q5LUUjIW52wTafCPVV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356726830"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="356726830"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 15:01:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="672551182"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 15:01:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 2/3] ice: use bitmap_free instead of devm_kfree
Date:   Mon, 29 Aug 2022 15:00:48 -0700
Message-Id: <20220829220049.333434-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

pf->avail_txqs was allocated using bitmap_zalloc, bitmap_free should be
used to free this memory.

Fixes: 78b5713ac1241 ("ice: Alloc queue management bitmaps and arrays dynamically")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index e5bc69a9a37c..8c30eea61b6d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3913,7 +3913,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
 	if (!pf->avail_rxqs) {
-		devm_kfree(ice_pf_to_dev(pf), pf->avail_txqs);
+		bitmap_free(pf->avail_txqs);
 		pf->avail_txqs = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1

