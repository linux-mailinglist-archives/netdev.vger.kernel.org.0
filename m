Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E3F636B9C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbiKWUvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiKWUvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:17 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE996E56F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236675; x=1700772675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cPmSHyeg9PEnSRGKlGTB4o3UvpFAudqSfNc2Iz7sJJc=;
  b=Q0DS8//QB0OHurw0DaLMsrBZPxnA70B85ljXhEOojYuKOyprvT6+LNby
   lbY+9A+n+CNvzNs5ju1ByAFdHznRfZiNTzyvmeD2c6Zr4Xqf9j0K1ZTe6
   hHOCWVHua4d6iBRHgDN+NI/nc2W2YxhLW0fyKio0wot4UHK3B3y0y5FqM
   bLXPo3KQ/8/lXQZlwqL/IrLF/1Vo6BDhK6FC+GOYLzd6+gB1Fjow98KaS
   olh3uBNLOXDeTvoedmTIGtoZxMqJhGNr7670fozIv4C2TgdvM0rccE/As
   oKC11aIK5FJ1raTv6qHk5eAdrPC0/3mGcW3/37BiHuiGQr8fqarkK0p7w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862675"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862675"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947708"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947708"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:13 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: [PATCH v2 net-next 6/6] net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()
Date:   Wed, 23 Nov 2022 12:52:19 -0800
Message-Id: <20221123205219.31748-7-anirudh.venkataramanan@intel.com>
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

Cc: Michael Jamet <michael.jamet@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Yehezkel Bernat <YehezkelShB@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 drivers/net/thunderbolt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index a52ee2b..b20cd37 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1051,7 +1051,7 @@ static void *tbnet_kmap_frag(struct sk_buff *skb, unsigned int frag_num,
 	const skb_frag_t *frag = &skb_shinfo(skb)->frags[frag_num];
 
 	*len = skb_frag_size(frag);
-	return kmap_atomic(skb_frag_page(frag)) + skb_frag_off(frag);
+	return kmap_local_page(skb_frag_page(frag)) + skb_frag_off(frag);
 }
 
 static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
@@ -1109,7 +1109,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 			dest += len;
 
 			if (unmap) {
-				kunmap_atomic(src);
+				kunmap_local(src);
 				unmap = false;
 			}
 
@@ -1147,7 +1147,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 		dest += len;
 
 		if (unmap) {
-			kunmap_atomic(src);
+			kunmap_local(src);
 			unmap = false;
 		}
 
@@ -1162,7 +1162,7 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 	memcpy(dest, src, data_len);
 
 	if (unmap)
-		kunmap_atomic(src);
+		kunmap_local(src);
 
 	if (!tbnet_xmit_csum_and_map(net, skb, frames, frame_index + 1))
 		goto err_drop;
-- 
2.37.2

