Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B937362E861
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbiKQWZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiKQWZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32D126ADC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723900; x=1700259900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BQXotOlVFzlqsy83DhVYdJX+DYhqFcG5hOHEmNhlyhA=;
  b=OH0cHpdluICB36VwGG+ysqsxHNmAQfSP0dPytDjluJy/ZfhNFslAC8+O
   dBvJqBQxb+xuVlZGlXDkBIGd6FAnzXF54mSZci0i6mQQA2pSRFk+e0WTH
   zRtgBS17otSVuOCTx+j6zCZQEm/KBk9gbotZ0QE2+x48VWthDKoLV2Peb
   wKPZVm6v9U4jp5xQJxrg6erMVkFxVEKFHg8uhG2PB4AJfdYME4a73AoZl
   Rw6S1NM6LtaZzzbG8Vg3pTmljLxiXAZ55ZviLjPb+M/pLP+rQJvkCJFF0
   LLLVT9FJHQg9sk2jkigTl8Rk+C4DyOOyNqtoj0EA3fC5LPyu7EVy5u4yQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826325"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826325"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055470"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055470"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:59 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH net-next 4/5] cassini: Use kmap_local_page() instead of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:56 -0800
Message-Id: <20221117222557.2196195-5-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated in favor of kmap_local_page().
Replace kmap_atomic() and kunmap_atomic() with kmap_local_page() and
kunmap_local() respectively. cas_page_map() and cas_page_unmap() aren't
really useful anymore, so get rid of these as well.

Note that kmap_atomic() disables preemption and page-fault processing,
but kmap_local_page() doesn't. Converting the former to the latter is safe
only if there isn't an implicit dependency on preemption and page-fault
handling being disabled, which does appear to be the case here.

Also note that the page being mapped is not allocated by the driver,
and so the driver doesn't know if the page is in normal memory. This is the
reason kmap_local_page() is used as opposed to page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 drivers/net/ethernet/sun/cassini.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 2f66cfc..3e632b0 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -90,8 +90,6 @@
 #include <linux/uaccess.h>
 #include <linux/jiffies.h>
 
-#define cas_page_map(x)      kmap_atomic((x))
-#define cas_page_unmap(x)    kunmap_atomic((x))
 #define CAS_NCPUS            num_online_cpus()
 
 #define cas_skb_release(x)  netif_rx(x)
@@ -2788,11 +2786,11 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 				      ctrl, 0);
 			entry = TX_DESC_NEXT(ring, entry);
 
-			addr = cas_page_map(skb_frag_page(fragp));
+			addr = kmap_local_page(skb_frag_page(fragp));
 			memcpy(tx_tiny_buf(cp, ring, entry),
 			       addr + skb_frag_off(fragp) + len - tabort,
 			       tabort);
-			cas_page_unmap(addr);
+			kunmap_local(addr);
 			mapping = tx_tiny_map(cp, ring, entry, tentry);
 			len     = tabort;
 		}
-- 
2.37.2

