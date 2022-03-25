Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629794E750B
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbiCYOaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347634AbiCYOaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0024D638
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4BE8B82899
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B303C340E9;
        Fri, 25 Mar 2022 14:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648218517;
        bh=pCN7O5TPfjGomev8Ggr39T6ZVL6076bN1iA67zY9Gao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wlv1Qgr6ZjYuth20LLm/IU6XJovmHB7ZoUDHF+P77GKGjQ2A+AJZAOe3P8iDjxpVG
         0ZRQmtaYAE8yjTwRq8uqy0+Ow58lqmRdyVGKZtEEh257wgJp5PBVCJhGtYQOkatZ8O
         a/p2lZVoYCioo78j4XTNAgjMN3CSYalhea0jYmMUCMftA20XTSbVtaKavEqm+fgtCF
         xVYkYyPFjRcNUmhlY3vcD83ZFF6ZAspa0T6QvKwCROT5pKvfn21gpmm37n82h8QC6/
         0c715X3uzHJ/+q5WW77kbzcz/ga0yy22Mdx3ey+r2oakwG2bp4EbKvNUOYFN4ZodO9
         W1oeChhA3P8aA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jbrouer@redhat.com, magnus.karlsson@intel.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC net-next 2/2] i40e: add xdp frags support to ndo_xdp_xmit
Date:   Fri, 25 Mar 2022 15:28:12 +0100
Message-Id: <320ca7a6bc8266d4bf5ade545144b0dfb70231ca.1648218138.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648218138.git.lorenzo@kernel.org>
References: <cover.1648218138.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 86 +++++++++++++++------
 1 file changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 0eae5858f2fe..e9a772db869c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3688,35 +3688,55 @@ u16 i40e_lan_select_queue(struct net_device *netdev,
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
@@ -3724,14 +3744,30 @@ static int i40e_xmit_xdp_ring(struct xdp_frame *xdpf,
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

