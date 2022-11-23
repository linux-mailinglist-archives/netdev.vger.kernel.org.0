Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67F0636B96
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbiKWUvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiKWUvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C86A6B2
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236674; x=1700772674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PlTEkqcqKTtCSSpHTyMPxWxW34Lkp7kTExUro/0orGY=;
  b=FNNy5UXZt/mxNjrD52qoyp/vuFBTtnC0VHVh9zMjdI7TknennGjrmmF/
   jyfpnIe0F+J3yBqhi12Kqs6g9SHc4J+DGRKccUDkmaeWo5eFj0dIuexD3
   4E0ehsEOeTDzo0mgzAOwJYJlOEZNfmJjrwPWzk8IXDaPWtXIJ2REGAOCE
   Ep03KyIPBDpEKO+iQUscH11VyBat1Uhze6EO2yo8tY/7Y5xQJ+bn7G084
   Csyy9lOT7fFEidUsbL/8XKzMWzlFEaCDpbnmydYGRQcjUtUkQePtZoaWl
   xj3efx+N8fm6En/4lns9aJlPMfXD6rrl6dBpC03Fsyx/dZJhKcugvlsbW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862667"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862667"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947695"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947695"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:12 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 2/6] sfc: Use kmap_local_page() instead of kmap_atomic()
Date:   Wed, 23 Nov 2022 12:52:15 -0800
Message-Id: <20221123205219.31748-3-anirudh.venkataramanan@intel.com>
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
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
---
v1 -> v2: Update commit message
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

