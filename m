Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8F51C561
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbiEEQxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiEEQxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E75C76B;
        Thu,  5 May 2022 09:49:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372CDB82DF6;
        Thu,  5 May 2022 16:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EABC385AE;
        Thu,  5 May 2022 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651769363;
        bh=ZaYsTUV6uzr6y1G8TDHTptrwEu+1W/REsXEkvvs6KWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fMNgGa5k7UF+wr5D4X/rpIny0MlNPF0QwNRLDf2Cd78Y5w/hn3enPnh5hWwDJGqA4
         9X1f1oDPNciB3w1xTA4BDH2N6ldP/9OGP/GekpUt+7AwQSpNFKcG86k3ZZM2M3eER2
         fsnPmWix/wVpNeWHXMB75863r6oNznGAdBc2b0DY5OqGVi3SLB7yFloYxzcRuqB1u9
         k+62YuJ1rDwm4XuoM0ju3hXImYl2w97zct4rbEyu8XV4aXBDqfiOGTV/OF8XH0JXIv
         OliLXSrHRGpghN3UgMm4CAxhsvgoJSSvub2Mtc7pLV0qnSq9HQBfcVWRkZOi8S1I5M
         XDDdt+nxqyoog==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, alice.michael@intel.com,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, andrii@kernel.org,
        magnus.karlsson@intel.com, jbrouer@redhat.com, toke@redhat.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH net-next] i40e: add xdp frags support to ndo_xdp_xmit
Date:   Thu,  5 May 2022 18:48:45 +0200
Message-Id: <c4e15c421c5579da7bfc77512e8d40b6a76beae1.1651769002.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
callback.

Tested-by: Sarkar Tirthendu <tirthendu.sarkar@intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 87 +++++++++++++++------
 1 file changed, 62 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 7bc1174edf6b..b7967105a549 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2509,6 +2509,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			hard_start = page_address(rx_buffer->page) +
 				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+			xdp_buff_clear_frags_flag(&xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, size);
@@ -3713,35 +3714,55 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
 static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 			      struct i40e_ring *xdp_ring)
 {
-	u16 i = xdp_ring->next_to_use;
-	struct i40e_tx_buffer *tx_bi;
-	struct i40e_tx_desc *tx_desc;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u8 nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	u16 i = 0, index = xdp_ring->next_to_use;
+	struct i40e_tx_buffer *tx_head = &xdp_ring->tx_bi[index];
+	struct i40e_tx_buffer *tx_bi = tx_head;
+	struct i40e_tx_desc *tx_desc = I40E_TX_DESC(xdp_ring, index);
 	void *data = xdpf->data;
 	u32 size = xdpf->len;
-	dma_addr_t dma;
 
-	if (!unlikely(I40E_DESC_UNUSED(xdp_ring))) {
+	if (unlikely(I40E_DESC_UNUSED(xdp_ring) < 1 + nr_frags)) {
 		xdp_ring->tx_stats.tx_busy++;
 		return I40E_XDP_CONSUMED;
 	}
-	dma = dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
-	if (dma_mapping_error(xdp_ring->dev, dma))
-		return I40E_XDP_CONSUMED;
 
-	tx_bi = &xdp_ring->tx_bi[i];
-	tx_bi->bytecount = size;
-	tx_bi->gso_segs = 1;
-	tx_bi->xdpf = xdpf;
+	tx_head->bytecount = xdp_get_frame_len(xdpf);
+	tx_head->gso_segs = 1;
+	tx_head->xdpf = xdpf;
 
-	/* record length, and DMA address */
-	dma_unmap_len_set(tx_bi, len, size);
-	dma_unmap_addr_set(tx_bi, dma, dma);
+	for (;;) {
+		dma_addr_t dma;
 
-	tx_desc = I40E_TX_DESC(xdp_ring, i);
-	tx_desc->buffer_addr = cpu_to_le64(dma);
-	tx_desc->cmd_type_offset_bsz = build_ctob(I40E_TX_DESC_CMD_ICRC
-						  | I40E_TXD_CMD,
-						  0, size, 0);
+		dma = dma_map_single(xdp_ring->dev, data, size, DMA_TO_DEVICE);
+		if (dma_mapping_error(xdp_ring->dev, dma))
+			goto unmap;
+
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_bi, len, size);
+		dma_unmap_addr_set(tx_bi, dma, dma);
+
+		tx_desc->buffer_addr = cpu_to_le64(dma);
+		tx_desc->cmd_type_offset_bsz =
+			build_ctob(I40E_TX_DESC_CMD_ICRC, 0, size, 0);
+
+		if (++index == xdp_ring->count)
+			index = 0;
+
+		if (i == nr_frags)
+			break;
+
+		tx_bi = &xdp_ring->tx_bi[index];
+		tx_desc = I40E_TX_DESC(xdp_ring, index);
+
+		data = skb_frag_address(&sinfo->frags[i]);
+		size = skb_frag_size(&sinfo->frags[i]);
+		i++;
+	}
+
+	tx_desc->cmd_type_offset_bsz |=
+		cpu_to_le64(I40E_TXD_CMD << I40E_TXD_QW1_CMD_SHIFT);
 
 	/* Make certain all of the status bits have been updated
 	 * before next_to_watch is written.
@@ -3749,14 +3770,30 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
 	smp_wmb();
 
 	xdp_ring->xdp_tx_active++;
-	i++;
-	if (i == xdp_ring->count)
-		i = 0;
 
-	tx_bi->next_to_watch = tx_desc;
-	xdp_ring->next_to_use = i;
+	tx_head->next_to_watch = tx_desc;
+	xdp_ring->next_to_use = index;
 
 	return I40E_XDP_TX;
+
+unmap:
+	for (;;) {
+		tx_bi = &xdp_ring->tx_bi[index];
+		if (dma_unmap_len(tx_bi, len))
+			dma_unmap_page(xdp_ring->dev,
+				       dma_unmap_addr(tx_bi, dma),
+				       dma_unmap_len(tx_bi, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_bi, len, 0);
+		if (tx_bi == tx_head)
+			break;
+
+		if (!index)
+			index += xdp_ring->count;
+		index--;
+	}
+
+	return I40E_XDP_CONSUMED;
 }
 
 /**
-- 
2.35.1

