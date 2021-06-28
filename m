Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D013B5D50
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 13:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhF1LtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 07:49:17 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:35602 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232353AbhF1LtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 07:49:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0UdwTCe8_1624880807;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UdwTCe8_1624880807)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 28 Jun 2021 19:46:47 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net v3] xdp, net: fix for construct skb by xdp inside xsk zc rx
Date:   Mon, 28 Jun 2021 19:46:47 +0800
Message-Id: <20210628114647.75449-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When each driver supports xsk rx, if the received buff returns XDP_PASS
after run xdp prog, it must construct skb based on xdp. This patch
extracts this logic into a public function xdp_construct_skb().

There is a bug in the original logic. When constructing skb, we should
copy the meta information to skb and then use __skb_pull() to correct
the data.

Fixes: 0a714186d3c0f ("i40e: add AF_XDP zero-copy Rx support")
Fixes: 2d4238f556972 ("ice: Add support for AF_XDP")
Fixes: bba2556efad66 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Fixes: d0bcacd0a1309 ("ixgbe: add AF_XDP zero-copy Rx support")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---

v3: move xdp_construct_skb to xdp_sock_drv.h

 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 16 +---------
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 12 +-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 12 +-------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +-------------
 include/net/xdp_sock_drv.h                    | 30 +++++++++++++++++++
 5 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 68f177a86403..81b0f44eedda 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -246,23 +246,9 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 					     struct xdp_buff *xdp)
 {
-	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
 	struct sk_buff *skb;

-	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       xdp->data_end - xdp->data_hard_start,
-			       GFP_ATOMIC | __GFP_NOWARN);
-	if (unlikely(!skb))
-		goto out;
-
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
-	if (metasize)
-		skb_metadata_set(skb, metasize);
-
-out:
+	skb = xdp_construct_skb(xdp, &rx_ring->q_vector->napi);
 	xsk_buff_free(xdp);
 	return skb;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index a1f89ea3c2bd..f95e1adcebda 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -430,22 +430,12 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
 static struct sk_buff *
 ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 {
-	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
-	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
-	unsigned int datasize_hard = rx_buf->xdp->data_end -
-				     rx_buf->xdp->data_hard_start;
 	struct sk_buff *skb;

-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
-			       GFP_ATOMIC | __GFP_NOWARN);
+	skb = xdp_construct_skb(rx_buf->xdp, &rx_ring->q_vector->napi);
 	if (unlikely(!skb))
 		return NULL;

-	skb_reserve(skb, rx_buf->xdp->data - rx_buf->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), rx_buf->xdp->data, datasize);
-	if (metasize)
-		skb_metadata_set(skb, metasize);
-
 	xsk_buff_free(rx_buf->xdp);
 	rx_buf->xdp = NULL;
 	return skb;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index f72d2978263b..123945832c96 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -203,22 +203,12 @@ bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 count)
 static struct sk_buff *ixgbe_construct_skb_zc(struct ixgbe_ring *rx_ring,
 					      struct ixgbe_rx_buffer *bi)
 {
-	unsigned int metasize = bi->xdp->data - bi->xdp->data_meta;
-	unsigned int datasize = bi->xdp->data_end - bi->xdp->data;
 	struct sk_buff *skb;

-	/* allocate a skb to store the frags */
-	skb = __napi_alloc_skb(&rx_ring->q_vector->napi,
-			       bi->xdp->data_end - bi->xdp->data_hard_start,
-			       GFP_ATOMIC | __GFP_NOWARN);
+	skb = xdp_construct_skb(bi->xdp, &rx_ring->q_vector->napi);
 	if (unlikely(!skb))
 		return NULL;

-	skb_reserve(skb, bi->xdp->data - bi->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), bi->xdp->data, datasize);
-	if (metasize)
-		skb_metadata_set(skb, metasize);
-
 	xsk_buff_free(bi->xdp);
 	bi->xdp = NULL;
 	return skb;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c87202cbd3d6..143ac1edb876 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4729,27 +4729,6 @@ static void stmmac_finalize_xdp_rx(struct stmmac_priv *priv,
 		xdp_do_flush();
 }

-static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
-					       struct xdp_buff *xdp)
-{
-	unsigned int metasize = xdp->data - xdp->data_meta;
-	unsigned int datasize = xdp->data_end - xdp->data;
-	struct sk_buff *skb;
-
-	skb = __napi_alloc_skb(&ch->rxtx_napi,
-			       xdp->data_end - xdp->data_hard_start,
-			       GFP_ATOMIC | __GFP_NOWARN);
-	if (unlikely(!skb))
-		return NULL;
-
-	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
-	if (metasize)
-		skb_metadata_set(skb, metasize);
-
-	return skb;
-}
-
 static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 				   struct dma_desc *p, struct dma_desc *np,
 				   struct xdp_buff *xdp)
@@ -4761,7 +4740,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	struct sk_buff *skb;
 	u32 hash;

-	skb = stmmac_construct_skb_zc(ch, xdp);
+	skb = xdp_construct_skb(xdp, &ch->rxtx_napi);
 	if (!skb) {
 		priv->dev->stats.rx_dropped++;
 		return;
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4e295541e396..988665cc2981 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -244,4 +244,34 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,

 #endif /* CONFIG_XDP_SOCKETS */

+static __always_inline struct sk_buff *xdp_construct_skb(struct xdp_buff *xdp,
+							  struct napi_struct *napi)
+{
+	unsigned int metasize;
+	unsigned int datasize;
+	unsigned int headroom;
+	struct sk_buff *skb;
+	unsigned int len;
+
+	/* this include metasize */
+	datasize = xdp->data_end  - xdp->data_meta;
+	metasize = xdp->data      - xdp->data_meta;
+	headroom = xdp->data_meta - xdp->data_hard_start;
+	len      = xdp->data_end  - xdp->data_hard_start;
+
+	/* allocate a skb to store the frags */
+	skb = __napi_alloc_skb(napi, len, GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!skb))
+		return NULL;
+
+	skb_reserve(skb, headroom);
+	memcpy(__skb_put(skb, datasize), xdp->data_meta, datasize);
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
+	return skb;
+}
+
 #endif /* _LINUX_XDP_SOCK_DRV_H */
--
2.31.0

