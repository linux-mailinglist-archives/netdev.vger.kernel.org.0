Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5071E636B9A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiKWUvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236263AbiKWUvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:16 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C816B22A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236675; x=1700772675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mCBgn+I+LtVMFukwxzvEP36T+PyjpYd5zLs+8klKrIs=;
  b=evuS3eY/VPAb2Wn0cohDOBBlX9eUVTaBQcDPMrV91+N/eN73mFBASE3j
   rdQtAvVpMeaXX/ZYRbtAmP39OSJmufdwY2w7vpouGpvw2MYr7ht6iJdSg
   mdEvg967CNm3GLhyGN1fyIvbxbDn4QStRVQfUEihhpFl9Z+/2LFENzmre
   Wad1kWrBPKU8hGH6PijnUARAwSgwZfvjL6klI97TS3gA0eFeq2Z550bmS
   fSkDAZ8sPlwjQ+rqIa1PAeZfAmTksgOibgpI1SYWYsl8mfHm/ZUByBxF0
   VwdhMjKyNnG982vYcwKJXUPTIIoJLgWLHaNk+wvgEeiwX2M6N+4SE+df9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862671"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862671"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947701"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947701"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:12 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 net-next 4/6] cassini: Use memcpy_from_page() instead of k[un]map_atomic()
Date:   Wed, 23 Nov 2022 12:52:17 -0800
Message-Id: <20221123205219.31748-5-anirudh.venkataramanan@intel.com>
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
the map-memcpy-unmap usage pattern (done using k[un]map_atomic()) with
memcpy_from_page(), which internally uses kmap_local_page() and
kunmap_local(). This renders the variable 'vaddr' unnecessary, and so
remove this too.

Note that kmap_atomic() disables preemption and page-fault processing, but
kmap_local_page() doesn't. When converting uses of kmap_atomic(), one has
to check if the code being executed between the map/unmap implicitly
depends on page-faults and/or preemption being disabled. If yes, then code
to disable page-faults and/or preemption should also be added for
functional correctness. That however doesn't appear to be the case here,
so just memcpy_from_page() is used.

Also note that the page being mapped is not allocated by the driver, and so
the driver doesn't know if the page is in normal memory. This is the reason
kmap_local_page() is used (via memcpy_from_page()) as opposed to
page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
v1 -> v2:
 Use memcpy_from_page() as suggested by Fabio
 Add a "Suggested-by" tag
 Rework commit message
---
 drivers/net/ethernet/sun/cassini.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 2f66cfc..4ef05ba 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -90,8 +90,6 @@
 #include <linux/uaccess.h>
 #include <linux/jiffies.h>
 
-#define cas_page_map(x)      kmap_atomic((x))
-#define cas_page_unmap(x)    kunmap_atomic((x))
 #define CAS_NCPUS            num_online_cpus()
 
 #define cas_skb_release(x)  netif_rx(x)
@@ -2781,18 +2779,14 @@ static inline int cas_xmit_tx_ringN(struct cas *cp, int ring,
 
 		tabort = cas_calc_tabort(cp, skb_frag_off(fragp), len);
 		if (unlikely(tabort)) {
-			void *addr;
-
 			/* NOTE: len is always > tabort */
 			cas_write_txd(cp, ring, entry, mapping, len - tabort,
 				      ctrl, 0);
 			entry = TX_DESC_NEXT(ring, entry);
-
-			addr = cas_page_map(skb_frag_page(fragp));
-			memcpy(tx_tiny_buf(cp, ring, entry),
-			       addr + skb_frag_off(fragp) + len - tabort,
-			       tabort);
-			cas_page_unmap(addr);
+			memcpy_from_page(tx_tiny_buf(cp, ring, entry),
+					 skb_frag_page(fragp),
+					 skb_frag_off(fragp) + len - tabort,
+					 tabort);
 			mapping = tx_tiny_map(cp, ring, entry, tentry);
 			len     = tabort;
 		}
-- 
2.37.2

