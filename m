Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0519851C474
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381583AbiEEQDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381600AbiEEQDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:03:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3775C366
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 08:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651766392; x=1683302392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZTi3bWSP4rcH4KrwwXqfMn0snqM1svHEi5LLbQoj60k=;
  b=gmcw/7dka5f5qlTvw6S9/aX1idrUjByWH8TjuhEeysMHFn9oxZhAXT4+
   PkcvbG+yt7gJSAZtXlxjFzoOawpJ95tQq+0USb3zHmXGiX2My3oHuun0W
   ZKPmuAyD1Z1bSbY6TVcdOE7vp0Umrgbxh9xsN8Ze4nMy1hHF7/0ToFUQQ
   N6fu2r7GW85Tiu2eaYDPR4bxkd1RD6RW2LXCqEzmfcQe1KdhpOjViOX+t
   krk7FHcjS6mcvo8PEjgMnvWZn3gospdCGxtrMwnKkNF8NkI0JFPaRt8h7
   nVWwXM6bVrNbivc2iliKKYNtxYn2gLJGWnJgDZSH19GwgNz+K6WhtAwTo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248696920"
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="248696920"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 08:59:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="811682475"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2022 08:59:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Ira Weiny <ira.weiny@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/2] igb: Convert kmap() to kmap_local_page()
Date:   Thu,  5 May 2022 08:56:51 -0700
Message-Id: <20220505155651.2606195-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
References: <20220505155651.2606195-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>

kmap() is being deprecated and these usages are all local to the thread
so there is no reason kmap_local_page() can't be used.

Replace kmap() calls with kmap_local_page().

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2a5782063f4c..c14fc871dd41 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page);
+	data = kmap_local_page(rx_buffer->page);
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
+	kunmap_local(data);
 
 	return match;
 }
-- 
2.35.1

