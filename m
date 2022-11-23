Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB3D636B99
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiKWUvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbiKWUvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1546DCEA
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236675; x=1700772675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wea0u3J/7G3sxaeH3i5jFr/osYZe+X53rRQ2eZZBWH8=;
  b=MTBmpnRxbQoJTry3gdgfm07AB5ZyuscqqQ1OQJGauWByCEik1cGg/w1i
   IQLHM1Ydgqt9Ja4jSH9eIrXXKlHut6gEXWu04fD5GPq+IgeGrNGNxEF40
   pAIpwXCixij9c7a3AFF2XQIfOvXW3MzPeX4ZrxWVp/cW2ot/leUin9lQh
   Qvwn9BIILp/1OVNtP5RyDryIEYVSN2SaKB5OHi5ac9PWDSzo3+HwDY6hY
   2A5ergEz9yV0xOARuBhy3D2uZ0RHD3nf9/658FiTMB9tu3JqvYk6STAgC
   rZ4XxGxo9VmwJv4Ws4JHE+aIX/ODQBMo9UFLLhNRZOux9OOGEC1jcjG9O
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862673"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862673"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947705"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947705"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:13 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 net-next 5/6] sunvnet: Use kmap_local_page() instead of kmap_atomic()
Date:   Wed, 23 Nov 2022 12:52:18 -0800
Message-Id: <20221123205219.31748-6-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
References: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated in favor of kmap_local_page(). Replace
kmap_atomic() and kunmap_atomic() with kmap_local_page() and kunmap_local()
respectively.

Note that kmap_atomic() disables preemption and page-fault processing, but
kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
to check if the code being executed between the map/unmap implicitly
depends on page-faults and/or preemption being disabled. If yes, then code
to disable page-faults and/or preemption should also be added for
functional correctness. That however doesn't appear to be the case here,
so just kmap_local_page() is used.

Also note that the page being mapped is not allocated by the driver, and so
the driver doesn't know if the page is in normal memory. This is the reason
kmap_local_page() is used as opposed to page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
v1 -> v2: Update commit message
---
 drivers/net/ethernet/sun/sunvnet_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 80fde5f..a6211b9 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1085,13 +1085,13 @@ static inline int vnet_skb_map(struct ldc_channel *lp, struct sk_buff *skb,
 		u8 *vaddr;
 
 		if (nc < ncookies) {
-			vaddr = kmap_atomic(skb_frag_page(f));
+			vaddr = kmap_local_page(skb_frag_page(f));
 			blen = skb_frag_size(f);
 			blen += 8 - (blen & 7);
 			err = ldc_map_single(lp, vaddr + skb_frag_off(f),
 					     blen, cookies + nc, ncookies - nc,
 					     map_perm);
-			kunmap_atomic(vaddr);
+			kunmap_local(vaddr);
 		} else {
 			err = -EMSGSIZE;
 		}
-- 
2.37.2

