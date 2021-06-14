Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF203A6702
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhFNMwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhFNMwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:52:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD9961242;
        Mon, 14 Jun 2021 12:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675047;
        bh=xfvuZtjKE76Lu0VZWxAoomg7xwZPN+hMHNhuJVPNTVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCQRWJGmClSPvBKi9cjaXdMHwffNGbzDpNxqMCt1YJTBPN/rcAG3gBKaprw7AMLpQ
         CvaFs5Ar/0hfR8X/NEe0XA4iimDul0QqpsLsa70ghoS18nI7MRXuFlW7+/T5wNEIZq
         CaUDwfnifp7tGxwFJgcb9MQj8ZgjIxrZ0/m98KtinbJN2g5dLHfWXZ1zbtHjjGiWit
         QszeVN7sAOHbFQNpTHJH1TbFbLJdTubVtSd69t4L36UzM14S5efJLkdP/Lu/4eNE2W
         BXPRD+7eCkn1meXDDjEK1P/xzpLpmEwMSFwnVTMQUcxz4zcpAN+FZSaIRRdyWNlqfg
         nVPQUJaXkb3Rw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 03/14] net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
Date:   Mon, 14 Jun 2021 14:49:41 +0200
Message-Id: <0cb1664066f6a29d27264cb02ca69e812442bc53.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
XDP remote drivers if this is a "non-linear" XDP buffer. Access
xdp_shared_info only if xdp_buff mb is set.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 7d5cd9bc6c99..f8993f7488b9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2041,9 +2041,14 @@ mvneta_xdp_put_buff(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 {
 	int i;
 
+	if (likely(!xdp_buff_is_mb(xdp)))
+		goto out;
+
 	for (i = 0; i < sinfo->nr_frags; i++)
 		page_pool_put_full_page(rxq->page_pool,
 					skb_frag_page(&sinfo->frags[i]), true);
+
+out:
 	page_pool_put_page(rxq->page_pool, virt_to_head_page(xdp->data),
 			   sync_len, true);
 }
@@ -2245,7 +2250,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	int data_len = -MVNETA_MH_SIZE, len;
 	struct net_device *dev = pp->dev;
 	enum dma_data_direction dma_dir;
-	struct skb_shared_info *sinfo;
 
 	if (*size > MVNETA_MAX_RX_BUF_SIZE) {
 		len = MVNETA_MAX_RX_BUF_SIZE;
@@ -2267,9 +2271,6 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 	prefetch(data);
 	xdp_prepare_buff(xdp, data, pp->rx_offset_correction + MVNETA_MH_SIZE,
 			 data_len, false);
-
-	sinfo = xdp_get_shared_info_from_buff(xdp);
-	sinfo->nr_frags = 0;
 }
 
 static void
@@ -2304,12 +2305,18 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
 		skb_frag_size_set(frag, data_len);
 		__skb_frag_set_page(frag, page);
 
+		if (!xdp_buff_is_mb(xdp)) {
+			xdp_sinfo->data_len = *size;
+			xdp_buff_set_mb(xdp);
+		}
 		/* last fragment */
 		if (len == *size) {
 			struct skb_shared_info *sinfo;
 
 			sinfo = xdp_get_shared_info_from_buff(xdp);
 			sinfo->nr_frags = xdp_sinfo->nr_frags;
+			sinfo->data_len = xdp_sinfo->data_len;
+
 			memcpy(sinfo->frags, xdp_sinfo->frags,
 			       sinfo->nr_frags * sizeof(skb_frag_t));
 		}
@@ -2324,9 +2331,12 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
 		      struct xdp_buff *xdp, u32 desc_status)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
-	int i, num_frags = sinfo->nr_frags;
+	int i, num_frags = 0;
 	struct sk_buff *skb;
 
+	if (unlikely(xdp_buff_is_mb(xdp)))
+		num_frags = sinfo->nr_frags;
+
 	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
@@ -2398,6 +2408,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
 			frame_sz = size - ETH_FCS_LEN;
 			desc_status = rx_status;
 
+			xdp_buff_clear_mb(&xdp_buf);
 			mvneta_swbm_rx_frame(pp, rx_desc, rxq, &xdp_buf,
 					     &size, page);
 		} else {
-- 
2.31.1

