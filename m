Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372236A7077
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 17:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCAQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 11:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjCAQET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 11:04:19 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0704738029;
        Wed,  1 Mar 2023 08:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677686659; x=1709222659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h7oaQxLcaEUZNhhmO/EwniWo3ZoJc2fUHo/bmddoeLQ=;
  b=MDkw6bfhUTFwkZjicAgMbdD2hLJE9u/a98k85w8ZS272VSkqF/a/1WRF
   mLvP4yVj2LC88qbZCWY0w6dyV9Kkxmox25SU+UQp/ZGIWwP+tRhiYiyV0
   WunZuBY6Vhxr8qErtxppZR+PcygagMXzQU9YPBufaZOXDoGKJ5Xl87/Xz
   ItCmBLifqlKxcY1m4OYwhJwvDF6ogQ7f2EuB1lD6FuL8UChznIIai5G/w
   lbzACjS445/7la6Caa8jYiJY/L9qrDyY01Q1SrZCfJ3b7su6q0QDQbAoz
   4UZi/M+38sqwMzcxnVj5DJD8XKVDuhwDbiDI2bV5iQ2EZw07G6BYKMjSL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322709904"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="322709904"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:04:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="848686068"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="848686068"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 01 Mar 2023 08:04:13 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id CD69F36C09;
        Wed,  1 Mar 2023 16:04:12 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v1 2/2] xdp: remove unused {__,}xdp_release_frame()
Date:   Wed,  1 Mar 2023 17:03:15 +0100
Message-Id: <20230301160315.1022488-3-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__xdp_build_skb_from_frame() was the last user of
{__,}xdp_release_frame(), which detaches pages from the Page Pool.
All the consumers now recycle Page Pool skbs and page, except mlx5,
stmmac and tsnep drivers, which use page_pool_release_page() directly
(might change one day). It's safe to assume this functionality is not
needed anymore and can be removed (in favor of recycling).

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 include/net/xdp.h | 29 -----------------------------
 net/core/xdp.c    | 15 ---------------
 2 files changed, 44 deletions(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index d517bfac937b..5393b3ebe56e 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -317,35 +317,6 @@ void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
 void xdp_return_frame_bulk(struct xdp_frame *xdpf,
 			   struct xdp_frame_bulk *bq);
 
-/* When sending xdp_frame into the network stack, then there is no
- * return point callback, which is needed to release e.g. DMA-mapping
- * resources with page_pool.  Thus, have explicit function to release
- * frame resources.
- */
-void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
-static inline void xdp_release_frame(struct xdp_frame *xdpf)
-{
-	struct xdp_mem_info *mem = &xdpf->mem;
-	struct skb_shared_info *sinfo;
-	int i;
-
-	/* Curr only page_pool needs this */
-	if (mem->type != MEM_TYPE_PAGE_POOL)
-		return;
-
-	if (likely(!xdp_frame_has_frags(xdpf)))
-		goto out;
-
-	sinfo = xdp_get_shared_info_from_frame(xdpf);
-	for (i = 0; i < sinfo->nr_frags; i++) {
-		struct page *page = skb_frag_page(&sinfo->frags[i]);
-
-		__xdp_release_frame(page_address(page), mem);
-	}
-out:
-	__xdp_release_frame(xdpf->data, mem);
-}
-
 static __always_inline unsigned int xdp_get_frame_len(struct xdp_frame *xdpf)
 {
 	struct skb_shared_info *sinfo;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index a2237cfca8e9..8d3ad315f18d 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -531,21 +531,6 @@ void xdp_return_buff(struct xdp_buff *xdp)
 }
 EXPORT_SYMBOL_GPL(xdp_return_buff);
 
-/* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
-void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
-{
-	struct xdp_mem_allocator *xa;
-	struct page *page;
-
-	rcu_read_lock();
-	xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
-	page = virt_to_head_page(data);
-	if (xa)
-		page_pool_release_page(xa->page_pool, page);
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL_GPL(__xdp_release_frame);
-
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf)
 {
-- 
2.39.2

