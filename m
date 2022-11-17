Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDF362E85F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiKQWZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiKQWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F5982227
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723900; x=1700259900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gJB1fknomulu9hi49IyXWqmujg/T5VKkWSEybCJpo1c=;
  b=l4KiVKsdvMEFs7ryofVqjK3FJ8WOa2eBKGYDxzA3noCh7rgb7Xy32P5O
   uzy2N3X51Iv7y3YlSAyUeB3i5RU9xgO0yWXW6JmWusvq6Q/syb2Y79eEm
   PKsE/p+laSdTHUa3vBrG2tbmkuPF2zmDPMoVQd6v2YLIref+s0G+pytzf
   rHNmauo6b90J4xaGgCHv6VDy6BfCRNOw/UHeUHqv7ItgxoJl6FKI/aEfM
   ZZUTmxpf7ECVxRjuFjsZw9RnCUHZCL1GC7vZsjHKY4srmud4PPBYAhfqZ
   xRX4X4EBjv8960Ywc0SkL9w8YEIogwu5Qhl4izNuFOTTUyGoQt+0s4wK5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826323"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826323"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055463"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055463"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:58 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:54 -0800
Message-Id: <20221117222557.2196195-3-anirudh.venkataramanan@intel.com>
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

Note that kmap_atomic() disables preemption and page-fault processing, but
kmap_local_page() doesn't. Converting the former to the latter is safe only
if there isn't an implicit dependency on preemption and page-fault handling
being disabled, which does appear to be the case here.

Also note that the page being mapped is not allocated by the driver, and so
the driver doesn't know if the page is in normal memory. This is the reason
kmap_local_page() is used as opposed to page_address().

I don't have hardware, so this change has only been compile tested.

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
 drivers/net/ethernet/sfc/tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index c5f88f7..4ed4082 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -207,11 +207,11 @@ static void efx_skb_copy_bits_to_pio(struct efx_nic *efx, struct sk_buff *skb,
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 		u8 *vaddr;
 
-		vaddr = kmap_atomic(skb_frag_page(f));
+		vaddr = kmap_local_page(skb_frag_page(f));
 
 		efx_memcpy_toio_aligned_cb(efx, piobuf, vaddr + skb_frag_off(f),
 					   skb_frag_size(f), copy_buf);
-		kunmap_atomic(vaddr);
+		kunmap_local(vaddr);
 	}
 
 	EFX_WARN_ON_ONCE_PARANOID(skb_shinfo(skb)->frag_list);
-- 
2.37.2

