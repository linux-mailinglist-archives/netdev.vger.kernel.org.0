Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99C062E862
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbiKQWZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiKQWZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371D0F6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723901; x=1700259901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vovRZG0YyOT2r62E4ukWHeazcTcalAZO78ahCNwyTBQ=;
  b=LdJHMXM3leGg3fczQKO8uHlCMgMGbrLW8vFqV2n/r1SHBkdtq/TMssPX
   d+n6f0Ytkc6YvFawfseobs98y0hT6ExAMjtRiUeIQhNU9wqkTA8ecEMYJ
   i1ySowqqIo1ALbImsh59Cy1W7FaEAXHOzkO8xe9rSSFUUmmH09cgDk2PP
   fmEQQPUDDIdru7Vy1bWmyxI5ItfuEEy60J6uliAeToGlSwvvbQ5viRfT5
   bWhEbRuqfbIfz3GaxHWfx4BIetfAmZR2q3dKMwLUiEd7Md0oi9OZLF+jg
   eEIaaAM+LnEg9LRwkgb7Bm23EHXYXs+ZcACfuMvVAii3ic0kysvw/YEtv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826326"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826326"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055474"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055474"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:59 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH net-next 5/5] sunvnet: Use kmap_local_page() instead of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:57 -0800
Message-Id: <20221117222557.2196195-6-anirudh.venkataramanan@intel.com>
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
Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
and kunmap_local() respectively.

Note that kmap_atomic() disables preemption and page-fault processing,
but kmap_local_page() doesn't. Converting the former to the latter is safe
only if there isn't an implicit dependency on preemption and page-fault
handling being disabled, which does appear to be the case here.

Also note that the page being mapped is not allocated by the driver, and so
the driver doesn't know if the page is in normal memory. This is the reason
kmap_local_page() is used as opposed to page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
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

