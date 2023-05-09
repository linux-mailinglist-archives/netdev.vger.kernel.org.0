Return-Path: <netdev+bounces-1144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 842556FC54E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A31AB1C20B33
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2294317AD2;
	Tue,  9 May 2023 11:45:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDA5182AE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:45:24 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77671FE3;
	Tue,  9 May 2023 04:45:20 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QFx6x6DlZzTkXp;
	Tue,  9 May 2023 19:40:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 19:45:18 +0800
From: Yunsheng Lin <linyunsheng@huawei.com>
To: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v1 1/2] net: introduce and use skb_frag_fill_page_desc()
Date: Tue, 9 May 2023 19:43:36 +0800
Message-ID: <20230509114337.21005-2-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230509114337.21005-1-linyunsheng@huawei.com>
References: <20230509114337.21005-1-linyunsheng@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Most users use __skb_frag_set_page()/skb_frag_off_set()/
skb_frag_size_set() to fill the page desc for a skb frag.

Introduce skb_frag_fill_page_desc() to do that.

net/bpf/test_run.c does not call skb_frag_off_set() to
set the offset, "copy_from_user(page_address(page), ...)"
suggest that it is assuming offset to be initialized as
zero, so call skb_frag_fill_page_desc() with offset being
zero for this case.

Also, skb_frag_set_page() is not used anymore, so remove
it.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 .../net/ethernet/aquantia/atlantic/aq_ring.c  |  6 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |  5 ++-
 drivers/net/ethernet/emulex/benet/be_main.c   | 32 ++++++++++---------
 drivers/net/ethernet/freescale/enetc/enetc.c  |  5 ++-
 .../net/ethernet/fungible/funeth/funeth_rx.c  |  5 ++-
 drivers/net/ethernet/marvell/mvneta.c         |  5 ++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  4 +--
 drivers/net/ethernet/sun/cassini.c            |  8 ++---
 drivers/net/virtio_net.c                      |  4 +--
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 +--
 drivers/net/xen-netback/netback.c             |  4 +--
 include/linux/skbuff.h                        | 27 ++++++----------
 net/bpf/test_run.c                            |  3 +-
 net/core/gro.c                                |  4 +--
 net/core/pktgen.c                             | 13 +++++---
 net/core/skbuff.c                             |  7 ++--
 net/tls/tls_device.c                          | 10 +++---
 net/xfrm/xfrm_ipcomp.c                        |  5 +--
 19 files changed, 64 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 7f933175cbda..4de22eed099a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -532,10 +532,10 @@ static bool aq_add_rx_fragment(struct device *dev,
 					      buff_->rxdata.pg_off,
 					      buff_->len,
 					      DMA_FROM_DEVICE);
-		skb_frag_off_set(frag, buff_->rxdata.pg_off);
-		skb_frag_size_set(frag, buff_->len);
 		sinfo->xdp_frags_size += buff_->len;
-		__skb_frag_set_page(frag, buff_->rxdata.page);
+		skb_frag_fill_page_desc(frag, buff_->rxdata.page,
+					buff_->rxdata.pg_off,
+					buff_->len);
 
 		buff_->is_cleaned = 1;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dcd9367f05af..efaff5018af8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1085,9 +1085,8 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 			    RX_AGG_CMP_LEN) >> RX_AGG_CMP_LEN_SHIFT;
 
 		cons_rx_buf = &rxr->rx_agg_ring[cons];
-		skb_frag_off_set(frag, cons_rx_buf->offset);
-		skb_frag_size_set(frag, frag_len);
-		__skb_frag_set_page(frag, cons_rx_buf->page);
+		skb_frag_fill_page_desc(frag, cons_rx_buf->page,
+					cons_rx_buf->offset, frag_len);
 		shinfo->nr_frags = i + 1;
 		__clear_bit(cons, rxr->rx_agg_bmap);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index efa7f401529e..2e9a74fe0970 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -2184,9 +2184,8 @@ static void lro_add_page(struct adapter *adap, struct sge_qset *qs,
 	len -= offset;
 
 	rx_frag += nr_frags;
-	__skb_frag_set_page(rx_frag, sd->pg_chunk.page);
-	skb_frag_off_set(rx_frag, sd->pg_chunk.offset + offset);
-	skb_frag_size_set(rx_frag, len);
+	skb_frag_fill_page_desc(rx_frag, sd->pg_chunk.page,
+				sd->pg_chunk.offset + offset, len);
 
 	skb->len += len;
 	skb->data_len += len;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 7e408bcc88de..3164ed205cf7 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2343,11 +2343,10 @@ static void skb_fill_rx_data(struct be_rx_obj *rxo, struct sk_buff *skb,
 		hdr_len = ETH_HLEN;
 		memcpy(skb->data, start, hdr_len);
 		skb_shinfo(skb)->nr_frags = 1;
-		skb_frag_set_page(skb, 0, page_info->page);
-		skb_frag_off_set(&skb_shinfo(skb)->frags[0],
-				 page_info->page_offset + hdr_len);
-		skb_frag_size_set(&skb_shinfo(skb)->frags[0],
-				  curr_frag_len - hdr_len);
+		skb_frag_fill_page_desc(&skb_shinfo(skb)->frags[0],
+					page_info->page,
+					page_info->page_offset + hdr_len,
+					curr_frag_len - hdr_len);
 		skb->data_len = curr_frag_len - hdr_len;
 		skb->truesize += rx_frag_size;
 		skb->tail += hdr_len;
@@ -2369,16 +2368,17 @@ static void skb_fill_rx_data(struct be_rx_obj *rxo, struct sk_buff *skb,
 		if (page_info->page_offset == 0) {
 			/* Fresh page */
 			j++;
-			skb_frag_set_page(skb, j, page_info->page);
-			skb_frag_off_set(&skb_shinfo(skb)->frags[j],
-					 page_info->page_offset);
-			skb_frag_size_set(&skb_shinfo(skb)->frags[j], 0);
+			skb_frag_fill_page_desc(&skb_shinfo(skb)->frags[j],
+						page_info->page,
+						page_info->page_offset,
+						curr_frag_len);
 			skb_shinfo(skb)->nr_frags++;
 		} else {
 			put_page(page_info->page);
+			skb_frag_size_add(&skb_shinfo(skb)->frags[j],
+					  curr_frag_len);
 		}
 
-		skb_frag_size_add(&skb_shinfo(skb)->frags[j], curr_frag_len);
 		skb->len += curr_frag_len;
 		skb->data_len += curr_frag_len;
 		skb->truesize += rx_frag_size;
@@ -2451,14 +2451,16 @@ static void be_rx_compl_process_gro(struct be_rx_obj *rxo,
 		if (i == 0 || page_info->page_offset == 0) {
 			/* First frag or Fresh page */
 			j++;
-			skb_frag_set_page(skb, j, page_info->page);
-			skb_frag_off_set(&skb_shinfo(skb)->frags[j],
-					 page_info->page_offset);
-			skb_frag_size_set(&skb_shinfo(skb)->frags[j], 0);
+			skb_frag_fill_page_desc(&skb_shinfo(skb)->frags[j],
+						page_info->page,
+						page_info->page_offset,
+						curr_frag_len);
 		} else {
 			put_page(page_info->page);
+			skb_frag_size_add(&skb_shinfo(skb)->frags[j],
+					  curr_frag_len);
 		}
-		skb_frag_size_add(&skb_shinfo(skb)->frags[j], curr_frag_len);
+
 		skb->truesize += rx_frag_size;
 		remaining -= curr_frag_len;
 		memset(page_info, 0, sizeof(*page_info));
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3c4fa26f0f9b..63854294ac33 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1445,9 +1445,8 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 		xdp_buff_set_frag_pfmemalloc(xdp_buff);
 
 	frag = &shinfo->frags[shinfo->nr_frags];
-	skb_frag_off_set(frag, rx_swbd->page_offset);
-	skb_frag_size_set(frag, size);
-	__skb_frag_set_page(frag, rx_swbd->page);
+	skb_frag_fill_page_desc(frag, rx_swbd->page, rx_swbd->page_offset,
+				size);
 
 	shinfo->nr_frags++;
 }
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_rx.c b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
index 29a6c2ede43a..7e2584895de3 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_rx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_rx.c
@@ -323,9 +323,8 @@ static int fun_gather_pkt(struct funeth_rxq *q, unsigned int tot_len,
 		if (ref_ok)
 			ref_ok |= buf->node;
 
-		__skb_frag_set_page(frags, buf->page);
-		skb_frag_off_set(frags, q->buf_offset);
-		skb_frag_size_set(frags++, frag_len);
+		skb_frag_fill_page_desc(frags++, buf->page, q->buf_offset,
+					frag_len);
 
 		tot_len -= frag_len;
 		if (!tot_len)
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2cad76d0a50e..01b0312977d6 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2369,9 +2369,8 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 	if (data_len > 0 && sinfo->nr_frags < MAX_SKB_FRAGS) {
 		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags++];
 
-		skb_frag_off_set(frag, pp->rx_offset_correction);
-		skb_frag_size_set(frag, data_len);
-		__skb_frag_set_page(frag, page);
+		skb_frag_fill_page_desc(frag, page,
+					pp->rx_offset_correction, data_len);
 
 		if (!xdp_buff_has_frags(xdp)) {
 			sinfo->xdp_frags_size = *size;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 69634829558e..704b022cd1f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -491,9 +491,7 @@ mlx5e_add_skb_shared_info_frag(struct mlx5e_rq *rq, struct skb_shared_info *sinf
 	}
 
 	frag = &sinfo->frags[sinfo->nr_frags++];
-	__skb_frag_set_page(frag, frag_page->page);
-	skb_frag_off_set(frag, frag_offset);
-	skb_frag_size_set(frag, len);
+	skb_frag_fill_page_desc(frag, frag_page->page, frag_offset, len);
 
 	if (page_is_pfmemalloc(frag_page->page))
 		xdp_buff_set_frag_pfmemalloc(xdp);
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 4ef05bad4613..2d52f54ebb45 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1998,10 +1998,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 		skb->truesize += hlen - swivel;
 		skb->len      += hlen - swivel;
 
-		__skb_frag_set_page(frag, page->buffer);
+		skb_frag_fill_page_desc(frag, page->buffer, off, hlen - swivel);
 		__skb_frag_ref(frag);
-		skb_frag_off_set(frag, off);
-		skb_frag_size_set(frag, hlen - swivel);
 
 		/* any more data? */
 		if ((words[0] & RX_COMP1_SPLIT_PKT) && ((dlen -= hlen) > 0)) {
@@ -2024,10 +2022,8 @@ static int cas_rx_process_pkt(struct cas *cp, struct cas_rx_comp *rxc,
 			skb->len      += hlen;
 			frag++;
 
-			__skb_frag_set_page(frag, page->buffer);
+			skb_frag_fill_page_desc(frag, page->buffer, 0, hlen);
 			__skb_frag_ref(frag);
-			skb_frag_off_set(frag, 0);
-			skb_frag_size_set(frag, hlen);
 			RX_USED_ADD(page, hlen + cp->crc_size);
 		}
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8d8038538fc4..b4c0d1acb3ae 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1153,9 +1153,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		}
 
 		frag = &shinfo->frags[shinfo->nr_frags++];
-		__skb_frag_set_page(frag, page);
-		skb_frag_off_set(frag, offset);
-		skb_frag_size_set(frag, len);
+		skb_frag_fill_page_desc(frag, page, offset, len);
 		if (page_is_pfmemalloc(page))
 			xdp_buff_set_frag_pfmemalloc(xdp);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index f2b76ee866a4..7fa74b8b2100 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -686,9 +686,7 @@ vmxnet3_append_frag(struct sk_buff *skb, struct Vmxnet3_RxCompDesc *rcd,
 
 	BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS);
 
-	__skb_frag_set_page(frag, rbi->page);
-	skb_frag_off_set(frag, 0);
-	skb_frag_size_set(frag, rcd->len);
+	skb_frag_fill_page_desc(frag, rbi->page, 0, rcd->len);
 	skb->data_len += rcd->len;
 	skb->truesize += PAGE_SIZE;
 	skb_shinfo(skb)->nr_frags++;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index c1501f41e2d8..3d79b35eb577 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1128,9 +1128,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			BUG();
 
 		offset += len;
-		__skb_frag_set_page(&frags[i], page);
-		skb_frag_off_set(&frags[i], 0);
-		skb_frag_size_set(&frags[i], len);
+		skb_frag_fill_page_desc(&frags[i], page, 0, len);
 	}
 
 	/* Release all the original (foreign) frags. */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 738776ab8838..30be21c7d05f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2411,6 +2411,15 @@ static inline unsigned int skb_pagelen(const struct sk_buff *skb)
 	return skb_headlen(skb) + __skb_pagelen(skb);
 }
 
+static inline void skb_frag_fill_page_desc(skb_frag_t *frag,
+					   struct page *page,
+					   int off, int size)
+{
+	frag->bv_page = page;
+	frag->bv_offset = off;
+	skb_frag_size_set(frag, size);
+}
+
 static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
 					      int i, struct page *page,
 					      int off, int size)
@@ -2422,9 +2431,7 @@ static inline void __skb_fill_page_desc_noacc(struct skb_shared_info *shinfo,
 	 * that not all callers have unique ownership of the page but rely
 	 * on page_is_pfmemalloc doing the right thing(tm).
 	 */
-	frag->bv_page		  = page;
-	frag->bv_offset		  = off;
-	skb_frag_size_set(frag, size);
+	skb_frag_fill_page_desc(frag, page, off, size);
 }
 
 /**
@@ -3496,20 +3503,6 @@ static inline void __skb_frag_set_page(skb_frag_t *frag, struct page *page)
 	frag->bv_page = page;
 }
 
-/**
- * skb_frag_set_page - sets the page contained in a paged fragment of an skb
- * @skb: the buffer
- * @f: the fragment offset
- * @page: the page to set
- *
- * Sets the @f'th fragment of @skb to contain @page.
- */
-static inline void skb_frag_set_page(struct sk_buff *skb, int f,
-				     struct page *page)
-{
-	__skb_frag_set_page(&skb_shinfo(skb)->frags[f], page);
-}
-
 bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio);
 
 /**
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index e79e3a415ca9..98143b86a9dd 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1415,11 +1415,10 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			}
 
 			frag = &sinfo->frags[sinfo->nr_frags++];
-			__skb_frag_set_page(frag, page);
 
 			data_len = min_t(u32, kattr->test.data_size_in - size,
 					 PAGE_SIZE);
-			skb_frag_size_set(frag, data_len);
+			skb_frag_fill_page_desc(frag, page, 0, data_len);
 
 			if (copy_from_user(page_address(page), data_in + size,
 					   data_len)) {
diff --git a/net/core/gro.c b/net/core/gro.c
index 2d84165cb4f1..6783a47a6136 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -239,9 +239,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 
 		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
 
-		__skb_frag_set_page(frag, page);
-		skb_frag_off_set(frag, first_offset);
-		skb_frag_size_set(frag, first_size);
+		skb_frag_fill_page_desc(frag, page, first_offset, first_size);
 
 		memcpy(frag + 1, skbinfo->frags, sizeof(*frag) * skbinfo->nr_frags);
 		/* We dont need to clear skbinfo->nr_frags here */
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 760238196db1..f56b8d697014 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2785,14 +2785,17 @@ static void pktgen_finalize_skb(struct pktgen_dev *pkt_dev, struct sk_buff *skb,
 					break;
 			}
 			get_page(pkt_dev->page);
-			skb_frag_set_page(skb, i, pkt_dev->page);
-			skb_frag_off_set(&skb_shinfo(skb)->frags[i], 0);
+
 			/*last fragment, fill rest of data*/
 			if (i == (frags - 1))
-				skb_frag_size_set(&skb_shinfo(skb)->frags[i],
-				    (datalen < PAGE_SIZE ? datalen : PAGE_SIZE));
+				skb_frag_fill_page_desc(&skb_shinfo(skb)->frags[i],
+							pkt_dev->page, 0,
+							(datalen < PAGE_SIZE ?
+							 datalen : PAGE_SIZE));
 			else
-				skb_frag_size_set(&skb_shinfo(skb)->frags[i], frag_len);
+				skb_frag_fill_page_desc(&skb_shinfo(skb)->frags[i],
+							pkt_dev->page, 0, frag_len);
+
 			datalen -= skb_frag_size(&skb_shinfo(skb)->frags[i]);
 			skb->len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
 			skb->data_len += skb_frag_size(&skb_shinfo(skb)->frags[i]);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2112146092bf..06a94cb50945 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4241,10 +4241,9 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	struct page *page;
 
 	page = virt_to_head_page(frag_skb->head);
-	__skb_frag_set_page(&head_frag, page);
-	skb_frag_off_set(&head_frag, frag_skb->data -
-			 (unsigned char *)page_address(page));
-	skb_frag_size_set(&head_frag, skb_headlen(frag_skb));
+	skb_frag_fill_page_desc(&head_frag, page, frag_skb->data -
+				(unsigned char *)page_address(page),
+				skb_headlen(frag_skb));
 	return head_frag;
 }
 
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..daeff54bdbfa 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -268,9 +268,8 @@ static void tls_append_frag(struct tls_record_info *record,
 		skb_frag_size_add(frag, size);
 	} else {
 		++frag;
-		__skb_frag_set_page(frag, pfrag->page);
-		skb_frag_off_set(frag, pfrag->offset);
-		skb_frag_size_set(frag, size);
+		skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
+					size);
 		++record->num_frags;
 		get_page(pfrag->page);
 	}
@@ -357,9 +356,8 @@ static int tls_create_new_record(struct tls_offload_context_tx *offload_ctx,
 		return -ENOMEM;
 
 	frag = &record->frags[0];
-	__skb_frag_set_page(frag, pfrag->page);
-	skb_frag_off_set(frag, pfrag->offset);
-	skb_frag_size_set(frag, prepend_size);
+	skb_frag_fill_page_desc(frag, pfrag->page, pfrag->offset,
+				prepend_size);
 
 	get_page(pfrag->page);
 	pfrag->offset += prepend_size;
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 80143360bf09..9c0fa0e1786a 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -74,14 +74,11 @@ static int ipcomp_decompress(struct xfrm_state *x, struct sk_buff *skb)
 		if (!page)
 			return -ENOMEM;
 
-		__skb_frag_set_page(frag, page);
-
 		len = PAGE_SIZE;
 		if (dlen < len)
 			len = dlen;
 
-		skb_frag_off_set(frag, 0);
-		skb_frag_size_set(frag, len);
+		skb_frag_fill_page_desc(frag, page, 0, len);
 		memcpy(skb_frag_address(frag), scratch, len);
 
 		skb->truesize += len;
-- 
2.33.0


