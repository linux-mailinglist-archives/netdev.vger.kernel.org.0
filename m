Return-Path: <netdev+bounces-854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9886B6FB060
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 14:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 525DC280F99
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F17DDA9;
	Mon,  8 May 2023 12:41:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692717CF;
	Mon,  8 May 2023 12:41:24 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18E039494;
	Mon,  8 May 2023 05:41:07 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QFLTg4rC7zpWDH;
	Mon,  8 May 2023 20:39:51 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 20:41:03 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <netdev@vger.kernel.org>
CC: <linux-rdma@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<xen-devel@lists.xenproject.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <alexanderduyck@fb.com>,
	<jbrouer@redhat.com>, <ilias.apalodimas@linaro.org>
Subject: [PATCH RFC 2/2] net: remove __skb_frag_set_page()
Date: Mon, 8 May 2023 20:39:22 +0800
Message-ID: <20230508123922.39284-3-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230508123922.39284-1-linyunsheng@huawei.com>
References: <20230508123922.39284-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The remaining users calling __skb_frag_set_page() with
page being NULL seems to doing defensive programming, as
shinfo->nr_frags is already decremented, so remove them.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/broadcom/bnx2.c      |  1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  1 -
 include/linux/skbuff.h                    | 12 ------------
 3 files changed, 14 deletions(-)

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
index efaff5018af8..f3f08660ec30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1105,7 +1105,6 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 			unsigned int nr_frags;
 
 			nr_frags = --shinfo->nr_frags;
-			__skb_frag_set_page(&shinfo->frags[nr_frags], NULL);
 			cons_rx_buf->page = page;
 
 			/* Update prod since possibly some pages have been
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0d1027ea81e0..a3c448757b4e 100644
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


