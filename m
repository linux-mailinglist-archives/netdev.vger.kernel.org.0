Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE64E750A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245235AbiCYOaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245221AbiCYOaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6966A4B411
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0839D61B6C
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 14:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FAFC340EE;
        Fri, 25 Mar 2022 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648218514;
        bh=qy1W8E4VT4NCRtLNyfJ62YUCerowl7AiKLWeb16wam4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P428wCnT1mbdKdYHTzRXdwcnlqnHj/stmDoXniMGPHhzgXF8N15DCkA0CmTsMuHsf
         NV1u/JgVT7G7F/PeHioLoOaNHeopHogzui+AhrIZYnH8j9/vjVYLvbB767Jl3V57/9
         jimSspUTPACP7mHPp137wqc1n3u4JsHKOeokO6X3grjCt4PXNwwsP9XACwdfq9QWQN
         XD31mU4/2+VKeyFw8uPKU21+r0VXhHuYi/v6USk/M8EwJ7t7mbXL5IfTZzWYVlcdAK
         rnijWpyUyY/GBtOog21I6CAh7dTMuGQJQix8oPRUWDvBu6loWgDWAAbDhQg8OQ+xLh
         SgzlmvqcCpLcA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jbrouer@redhat.com, magnus.karlsson@intel.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC net-next 1/2] ixgbe: add xdp frags support to ndo_xdp_xmit
Date:   Fri, 25 Mar 2022 15:28:11 +0100
Message-Id: <f46922d20c5447271c07bd2a0c9acfe39d1a766b.1648218138.git.lorenzo@kernel.org>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 99 ++++++++++++-------
 1 file changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..0dd5b2687609 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8571,57 +8571,84 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,
 			struct xdp_frame *xdpf)
 {
-	struct ixgbe_tx_buffer *tx_buffer;
-	union ixgbe_adv_tx_desc *tx_desc;
-	u32 len, cmd_type;
-	dma_addr_t dma;
-	u16 i;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u8 nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	u16 i = 0, index = ring->next_to_use;
+	struct ixgbe_tx_buffer *tx_head = &ring->tx_buffer_info[index];
+	struct ixgbe_tx_buffer *tx_buff = tx_head;
+	union ixgbe_adv_tx_desc *tx_desc = IXGBE_TX_DESC(ring, index);
+	u32 cmd_type, len = xdpf->len;
+	void *data = xdpf->data;
+
+	if (unlikely(ixgbe_desc_unused(ring) < 1 + nr_frags))
+		return IXGBE_XDP_CONSUMED;
 
-	len = xdpf->len;
+	tx_head->bytecount = xdp_get_frame_len(xdpf);
+	tx_head->gso_segs = 1;
+	tx_head->xdpf = xdpf;
 
-	if (unlikely(!ixgbe_desc_unused(ring)))
-		return IXGBE_XDP_CONSUMED;
+	tx_desc->read.olinfo_status =
+		cpu_to_le32(tx_head->bytecount << IXGBE_ADVTXD_PAYLEN_SHIFT);
 
-	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ring->dev, dma))
-		return IXGBE_XDP_CONSUMED;
+	for (;;) {
+		dma_addr_t dma;
 
-	/* record the location of the first descriptor for this packet */
-	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
-	tx_buffer->bytecount = len;
-	tx_buffer->gso_segs = 1;
-	tx_buffer->protocol = 0;
+		dma = dma_map_single(ring->dev, data, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(ring->dev, dma))
+			goto unmap;
+
+		dma_unmap_len_set(tx_buff, len, len);
+		dma_unmap_addr_set(tx_buff, dma, dma);
 
-	i = ring->next_to_use;
-	tx_desc = IXGBE_TX_DESC(ring, i);
+		cmd_type = IXGBE_ADVTXD_DTYP_DATA | IXGBE_ADVTXD_DCMD_DEXT |
+			   IXGBE_ADVTXD_DCMD_IFCS | len;
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		tx_buff->protocol = 0;
 
-	dma_unmap_len_set(tx_buffer, len, len);
-	dma_unmap_addr_set(tx_buffer, dma, dma);
-	tx_buffer->xdpf = xdpf;
+		if (++index == ring->count)
+			index = 0;
 
-	tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		if (i == nr_frags)
+			break;
+
+		tx_buff = &ring->tx_buffer_info[index];
+		tx_desc = IXGBE_TX_DESC(ring, index);
+
+		tx_desc->read.olinfo_status = 0;
 
+		data = skb_frag_address(&sinfo->frags[i]);
+		len = skb_frag_size(&sinfo->frags[i]);
+		i++;
+	}
 	/* put descriptor type bits */
-	cmd_type = IXGBE_ADVTXD_DTYP_DATA |
-		   IXGBE_ADVTXD_DCMD_DEXT |
-		   IXGBE_ADVTXD_DCMD_IFCS;
-	cmd_type |= len | IXGBE_TXD_CMD;
-	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
-	tx_desc->read.olinfo_status =
-		cpu_to_le32(len << IXGBE_ADVTXD_PAYLEN_SHIFT);
+	tx_desc->read.cmd_type_len |= cpu_to_le32(IXGBE_TXD_CMD);
 
 	/* Avoid any potential race with xdp_xmit and cleanup */
 	smp_wmb();
 
-	/* set next_to_watch value indicating a packet is present */
-	i++;
-	if (i == ring->count)
-		i = 0;
-
-	tx_buffer->next_to_watch = tx_desc;
-	ring->next_to_use = i;
+	tx_head->next_to_watch = tx_desc;
+	ring->next_to_use = index;
 
 	return IXGBE_XDP_TX;
+
+unmap:
+	for (;;) {
+		tx_buff = &ring->tx_buffer_info[index];
+		if (dma_unmap_len(tx_buff, len))
+			dma_unmap_page(ring->dev, dma_unmap_addr(tx_buff, dma),
+				       dma_unmap_len(tx_buff, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buff, len, 0);
+		if (tx_buff == tx_head)
+			break;
+
+		if (!index)
+			index += ring->count;
+		index--;
+	}
+
+	return IXGBE_XDP_CONSUMED;
 }
 
 netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
-- 
2.35.1

