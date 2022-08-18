Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240A1599098
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243979AbiHRWeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243167AbiHRWeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:34:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B29B24A5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 15:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660862050; x=1692398050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAlR/sVWLl4kqTK6HmCoFqVNmzLanZVDsSotK0Obfm8=;
  b=XNd8dDqStwP41SMASdXcfupW6bCRMllj18FvYmxJ/iUT2CzPLddEJgBv
   vUafSTmVeJe2KU2JgbsPMUIg33WCsZru4WWOIPkCU3Rt2k9TpbqHjU57T
   OoEYQOB37mKDMQVgOnXzr5RXoHTB884xkIk7tAztfrOI4VOl4CPdu/XEA
   xQnrxr9UTeYeX0RygkhzVxNK3oostnmhes53SrNOXu6fZnFDHsTXGS803
   c2a6fmeTdJL+/SaGpDTzSDL5GT+LuJ4SNFep36fH412Mstyj0DbGgDQSK
   gEcS6ARI1w5WO4ET88jnCNjwPnXOVl7WQ5bmS7I17ttO8/zi0RzNd7B/2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="379178801"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="379178801"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 15:34:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="558718710"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 15:34:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Ira Weiny <ira.weiny@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/2] ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC
Date:   Thu, 18 Aug 2022 15:34:01 -0700
Message-Id: <20220818223402.1294091-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
References: <20220818223402.1294091-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>

Pages allocated with GFP_ATOMIC cannot come from Highmem. This is why
there is no need to call kmap() on them.

Therefore, don't call kmap() on rx_buffer->page() and instead use a
plain page_address() to get the kernel address.

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 04f453eabef6..cb5c707538a5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1964,15 +1964,13 @@ static bool ixgbe_check_lbtest_frame(struct ixgbe_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
+	data = page_address(rx_buffer->page) + rx_buffer->page_offset;
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
-
 	return match;
 }
 
-- 
2.35.1

