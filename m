Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1EAF5AB7D6
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 19:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbiIBR5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 13:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiIBR5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 13:57:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D9FADCDA
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662141434; x=1693677434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P0VhT4DIpVhm2gqjNA6oELysweMUlFdFdcyBDPDeuoY=;
  b=SNe5bOu9QJl26Ys9khgl4bXQ/wUi+y0EsA+Q6Tc0GlqiivCArT8r8KIv
   l9ybBRkbWc74Ivcy996pQnhgMCG8mKNzS6R+LHXytxPVF5PKy3Muc2Exx
   kKUKdq2u6k7Sg1N30CdA/+bG2wCt+4cfipzop4UpShQVL82OYeNzCXUCh
   ynbUPEW1Uy7FxIrWQYgxf+uzsMJepzyWZZYUwYY6WfOeBP7sZ596JKtRX
   S8jPvQPtiiAEjUaf3Scb/DIogmV7plSl1HgBdEyJgo4lxfMyw+U0SJZs7
   6DqrR6VtwlkiK3f0zjP9pKFuXr7qWngxxfHcO/B7HaptDLn9/l3ejh3Hy
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10458"; a="296046892"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="296046892"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 10:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="590156243"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 10:57:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net v2 2/2] ice: use bitmap_free instead of devm_kfree
Date:   Fri,  2 Sep 2022 10:57:03 -0700
Message-Id: <20220902175703.1171660-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220902175703.1171660-1-anthony.l.nguyen@intel.com>
References: <20220902175703.1171660-1-anthony.l.nguyen@intel.com>
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

