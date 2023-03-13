Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C646B8455
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 22:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjCMV5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 17:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCMV5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 17:57:41 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A82A9009A;
        Mon, 13 Mar 2023 14:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678744633; x=1710280633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZFpBMYKp7Vej9uaBP1GUTHm12MmkAD4Atk8fjSWwcN0=;
  b=G3oUjM/jERp3N2bTKOWoilQ2IctW14Ps+K4Mcv1YLoDbbTIJANpA6zXc
   RLvy2YcMFSHDzyoW8J3FF/fGK2wCh6Jy9K/DYYABPFfWM+GzZ2pZqX/B9
   g+ffd26W2112hUHd8vSLt+Ney4AhPhgsEVlojSFfHH4TWyzHZCikyhTAU
   rIU3Gt4vAc3gfrSlSJ58xoCOwHSwdqvl3x1WPSgKKpTC3XdTbtF9avD4Z
   WcCMKaPjuKrmYj14P+gUzQxUsQ76gw+UT3Lk/zpJdyWHv6VFhg9cMeI7/
   /k42A/NbWzlB1clUGuvNEJTNdEM01edRRPalrdR8OdlkGRlfhZ1McC6oP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364928677"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="364928677"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 14:57:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="747750987"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="747750987"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 14:57:07 -0700
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
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 4/4] xdp: remove unused {__,}xdp_release_frame()
Date:   Mon, 13 Mar 2023 22:55:53 +0100
Message-Id: <20230313215553.1045175-5-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
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
{__,}xdp_release_frame(), which detaches pages from the page_pool.
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

