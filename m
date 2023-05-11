Return-Path: <netdev+bounces-1624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CACD16FE91D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76D342815B1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294F362A;
	Thu, 11 May 2023 01:14:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E3371
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:14:56 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9DD10EB;
	Wed, 10 May 2023 18:14:54 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QGv3457C0z18LMY;
	Thu, 11 May 2023 09:10:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 09:14:52 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yunsheng Lin
	<linyunsheng@huawei.com>, Leon Romanovsky <leonro@nvidia.com>, Michael Chan
	<michael.chan@broadcom.com>, Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Simon Horman <simon.horman@corigine.com>, Rasesh Mody <rmody@marvell.com>,
	<GR-Linux-NIC-Dev@marvell.com>, Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 2/2] net: remove __skb_frag_set_page()
Date: Thu, 11 May 2023 09:12:13 +0800
Message-ID: <20230511011213.59091-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230511011213.59091-1-linyunsheng@huawei.com>
References: <20230511011213.59091-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The remaining users calling __skb_frag_set_page() with
page being NULL seems to be doing defensive programming,
as shinfo->nr_frags is already decremented, so remove
them.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
RFC: remove a local variable as pointed out by Simon.
---
 drivers/net/ethernet/broadcom/bnx2.c      |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  5 +----
 include/linux/skbuff.h                    | 12 ------------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 466e1d62bcf6..0d917a9699c5 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -2955,7 +2955,6 @@ bnx2_reuse_rx_skb_pages(struct bnx2 *bp, struct bnx2_rx_ring_info *rxr,
 		shinfo = skb_shinfo(skb);
 		shinfo->nr_frags--;
 		page = skb_frag_page(&shinfo->frags[shinfo->nr_frags]);
-		__skb_frag_set_page(&shinfo->frags[shinfo->nr_frags], NULL);
 
 		cons_rx_pg->page = page;
 		dev_kfree_skb(skb);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index efaff5018af8..f42e51bd3e42 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1102,10 +1102,7 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 			xdp_buff_set_frag_pfmemalloc(xdp);
 
 		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_ATOMIC) != 0) {
-			unsigned int nr_frags;
-
-			nr_frags = --shinfo->nr_frags;
-			__skb_frag_set_page(&shinfo->frags[nr_frags], NULL);
+			--shinfo->nr_frags;
 			cons_rx_buf->page = page;
 
 			/* Update prod since possibly some pages have been
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 30be21c7d05f..00e8c435fa1a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3491,18 +3491,6 @@ static inline void skb_frag_page_copy(skb_frag_t *fragto,
 	fragto->bv_page = fragfrom->bv_page;
 }
 
-/**
- * __skb_frag_set_page - sets the page contained in a paged fragment
- * @frag: the paged fragment
- * @page: the page to set
- *
- * Sets the fragment @frag to contain @page.
- */
-static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
-{
-	frag->bv_page = page;
-}
-
 bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
 
 /**
-- 
2.33.0


