Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E107041456B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 11:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhIVJon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 05:44:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19999 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbhIVJod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 05:44:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HDtXV706Tzbmh5;
        Wed, 22 Sep 2021 17:38:50 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 22 Sep 2021 17:43:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <jonathan.lemon@gmail.com>,
        <alobakin@pm.me>, <willemb@google.com>, <cong.wang@bytedance.com>,
        <pabeni@redhat.com>, <haokexin@gmail.com>, <nogikh@google.com>,
        <elver@google.com>, <memxor@gmail.com>, <edumazet@google.com>,
        <alexander.duyck@gmail.com>, <dsahern@gmail.com>
Subject: [PATCH net-next 7/7] skbuff: remove unused skb->pp_recycle
Date:   Wed, 22 Sep 2021 17:41:31 +0800
Message-ID: <20210922094131.15625-8-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922094131.15625-1-linyunsheng@huawei.com>
References: <20210922094131.15625-1-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we have used pp_magic to identify pp page for the head
and frag page of a skb, the skb->pp_recycle is not used, so
remove it.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  6 ------
 drivers/net/ethernet/marvell/mvneta.c         |  2 --
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  4 +---
 drivers/net/ethernet/ti/cpsw.c                |  2 --
 drivers/net/ethernet/ti/cpsw_new.c            |  2 --
 include/linux/skbuff.h                        | 12 +----------
 net/core/skbuff.c                             | 21 +------------------
 7 files changed, 3 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 22af3d6ce178..5331e0f2cee4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3864,9 +3864,6 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 		return 0;
 	}
 
-	if (ring->page_pool)
-		skb_mark_for_recycle(skb);
-
 	u64_stats_update_begin(&ring->syncp);
 	ring->stats.seg_pkt_cnt++;
 	u64_stats_update_end(&ring->syncp);
@@ -3906,9 +3903,6 @@ static int hns3_add_frag(struct hns3_enet_ring *ring)
 				return -ENXIO;
 			}
 
-			if (ring->page_pool)
-				skb_mark_for_recycle(new_skb);
-
 			ring->frag_num = 0;
 
 			if (ring->tail_skb) {
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9d460a270601..c852e0dd6d38 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2327,8 +2327,6 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	skb_mark_for_recycle(skb);
-
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
 	skb_put(skb, xdp->data_end - xdp->data);
 	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d5c92e43f89e..bacae115c6c6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3994,9 +3994,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			goto err_drop_frame;
 		}
 
-		if (pp)
-			skb_mark_for_recycle(skb);
-		else
+		if (!pp)
 			dma_unmap_single_attrs(dev->dev.parent, dma_addr,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
 					       DMA_ATTR_SKIP_CPU_SYNC);
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 66f7ddd9b1f9..2fb5a4545b8b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -430,8 +430,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* mark skb for recycling */
-	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 7968f24d99c8..1e74d484852d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -374,8 +374,6 @@ static void cpsw_rx_handler(void *token, int len, int status)
 		cpts_rx_timestamp(cpsw->cpts, skb);
 	skb->protocol = eth_type_trans(skb, ndev);
 
-	/* mark skb for recycling */
-	skb_mark_for_recycle(skb);
 	netif_receive_skb(skb);
 
 	ndev->stats.rx_bytes += len;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b77ee060b64d..d4bb0e160fef 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -668,8 +668,6 @@ typedef unsigned char *sk_buff_data_t;
  *	@head_frag: skb was allocated from page fragments,
  *		not allocated by kmalloc() or vmalloc().
  *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
- *	@pp_recycle: mark the packet for recycling instead of freeing (implies
- *		page_pool support on driver)
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
@@ -795,8 +793,7 @@ struct sk_buff {
 				fclone:2,
 				peeked:1,
 				head_frag:1,
-				pfmemalloc:1,
-				pp_recycle:1; /* page_pool recycle indicator */
+				pfmemalloc:1;
 #ifdef CONFIG_SKB_EXTENSIONS
 	__u8			active_extensions;
 #endif
@@ -4721,12 +4718,5 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
 #endif
 }
 
-#ifdef CONFIG_PAGE_POOL
-static inline void skb_mark_for_recycle(struct sk_buff *skb)
-{
-	skb->pp_recycle = 1;
-}
-#endif
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_SKBUFF_H */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3718898da499..85ae59f4349a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -670,7 +670,7 @@ static void skb_release_data(struct sk_buff *skb)
 	if (skb->cloned &&
 	    atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
 			      &shinfo->dataref))
-		goto exit;
+		return;
 
 	skb_zcopy_clear(skb, true);
 
@@ -681,17 +681,6 @@ static void skb_release_data(struct sk_buff *skb)
 		kfree_skb_list(shinfo->frag_list);
 
 	skb_free_head(skb);
-exit:
-	/* When we clone an SKB we copy the reycling bit. The pp_recycle
-	 * bit is only set on the head though, so in order to avoid races
-	 * while trying to recycle fragments on __skb_frag_unref() we need
-	 * to make one SKB responsible for triggering the recycle path.
-	 * So disable the recycling bit if an SKB is cloned and we have
-	 * additional references to to the fragmented part of the SKB.
-	 * Eventually the last SKB will have the recycling bit set and it's
-	 * dataref set to 0, which will trigger the recycling
-	 */
-	skb->pp_recycle = 0;
 }
 
 /*
@@ -1073,7 +1062,6 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	n->nohdr = 0;
 	n->peeked = 0;
 	C(pfmemalloc);
-	C(pp_recycle);
 	n->destructor = NULL;
 	C(tail);
 	C(end);
@@ -5368,13 +5356,6 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* The page pool signature of struct page will eventually figure out
-	 * which pages can be recycled or not but for now let's prohibit slab
-	 * allocated and page_pool allocated SKBs from being coalesced.
-	 */
-	if (to->pp_recycle != from->pp_recycle)
-		return false;
-
 	if (len <= skb_tailroom(to)) {
 		if (len)
 			BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
-- 
2.33.0

