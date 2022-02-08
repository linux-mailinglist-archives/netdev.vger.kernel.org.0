Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965A24AE346
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385747AbiBHWVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387052AbiBHVv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:28 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B20C0612BC
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357087; x=1675893087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1lsMMOpU085P2wLNqXt7IjxgLSblQvgPhXtHD9efZC4=;
  b=WwcW96anmtUmbaP8S/gPhSwx3GnF9Iu296Y2IijSO9ztfOUqPBgRN0jL
   aaVproQOKQqBeTB9nAOAc2jNFnb2JWzUTN4yDlBuMIElJOhn9Geg/ePur
   IiKCaGYwg/8EmL/MwUpl2Bwga2Qfv2ZU+wusIeC0HfN1WPgUoGYc9sHr0
   3b6D4Fffee4rroFsvH8cKdnbbgwuQQ9OCow86fdWocZOBTHjwjqe8eO2g
   X21K0BFENtYkyum5tiwaoCgUFmJtrb3KbFmi0RWcyeJrg2CTmD4Qfb4cK
   ar6f57Mf44tKB5f4+BaJHFosVMktxIaGvheEZUd3Q5bZs32vtEx+vS4wu
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008204"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008204"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047949"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 1/5] i40e: Remove rx page reuse double count
Date:   Tue,  8 Feb 2022 13:51:13 -0800
Message-Id: <20220208215117.1733822-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
References: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
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

From: Joe Damato <jdamato@fastly.com>

Page reuse was being tracked from two locations:
  - i40e_reuse_rx_page (via 40e_clean_rx_irq), and
  - i40e_alloc_mapped_page

Remove the double count and only count reuse from i40e_alloc_mapped_page
when the page is about to be reused.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 66cc79500c10..da4929ece778 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1382,8 +1382,6 @@ static void i40e_reuse_rx_page(struct i40e_ring *rx_ring,
 	new_buff->page_offset	= old_buff->page_offset;
 	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
 
-	rx_ring->rx_stats.page_reuse_count++;
-
 	/* clear contents of buffer_info */
 	old_buff->page = NULL;
 }
-- 
2.31.1

