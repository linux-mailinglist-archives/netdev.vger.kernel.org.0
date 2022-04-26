Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0975F50FEAD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiDZNTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350799AbiDZNS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:18:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDD89230D;
        Tue, 26 Apr 2022 06:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC99614A3;
        Tue, 26 Apr 2022 13:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AD3C385AA;
        Tue, 26 Apr 2022 13:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650978947;
        bh=/pYk0IF39cuVqn1gDqReGRf89BRsIwZNP7PwDX11BAo=;
        h=From:To:Cc:Subject:Date:From;
        b=FMKz1SkGb2c+HLwfyFqr+EkJj1ifKHmoWALFZfuVRNAf3ciUn+R4ZW0Nm9fQsNuVm
         iu62Zpf5XAdLlLSH56deLB/1qFyVAQgZm/GsBH+JxaHQRckbbGI4N1TJv8aKwtO1PT
         0m8rbyD0xV+uZb31pzDxdXpG6wZ4qoS11a4mZG3G/CWhUCGQO/uy9V4TA7KmOnMOf7
         oYVlN+b6g8YyMK6GJN1907JRZMUudJUJaYJJ4xHcq/G4CC5oEvGSZmtuhQ2+Vq6FmQ
         gMnsO8GYt6Y3tyshG9pYNRTD3/6vjxXg7dO/3BpkX6oHhf44wYak2oPUrPbrURRvl7
         jPpiYjTRJF74A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, alice.michael@intel.com,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, andrii@kernel.org,
        magnus.karlsson@intel.com, jbrouer@redhat.com, toke@redhat.com
Subject: [PATCH v2 net-next] ixgbe: add xdp frags support to ndo_xdp_xmit
Date:   Tue, 26 Apr 2022 15:14:55 +0200
Message-Id: <e36724d3cdfbedf9af1a2a7f47ebd60aa7932f83.1650978540.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- rebase on top of net-next
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 99 ++++++++++++-------
 1 file changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..8b84c9b2eecc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2344,6 +2344,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			hard_start = page_address(rx_buffer->page) +
 				     rx_buffer->page_offset - offset;
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+			xdp_buff_clear_frags_flag(&xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
@@ -8571,57 +8572,83 @@ static u16 ixgbe_select_queue(struct net_device *dev, struct sk_buff *skb,
 int ixgbe_xmit_xdp_ring(struct ixgbe_ring *ring,
 			struct xdp_frame *xdpf)
 {
-	struct ixgbe_tx_buffer *tx_buffer;
-	union ixgbe_adv_tx_desc *tx_desc;
-	u32 len, cmd_type;
-	dma_addr_t dma;
-	u16 i;
-
-	len = xdpf->len;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u8 nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	u16 i = 0, index = ring->next_to_use;
+	struct ixgbe_tx_buffer *tx_head = &ring->tx_buffer_info[index];
+	struct ixgbe_tx_buffer *tx_buff = tx_head;
+	union ixgbe_adv_tx_desc *tx_desc = IXGBE_TX_DESC(ring, index);
+	u32 cmd_type, len = xdpf->len;
+	void *data = xdpf->data;
 
-	if (unlikely(!ixgbe_desc_unused(ring)))
+	if (unlikely(ixgbe_desc_unused(ring) < 1 + nr_frags))
 		return IXGBE_XDP_CONSUMED;
 
-	dma = dma_map_single(ring->dev, xdpf->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ring->dev, dma))
-		return IXGBE_XDP_CONSUMED;
+	tx_head->bytecount = xdp_get_frame_len(xdpf);
+	tx_head->gso_segs = 1;
+	tx_head->xdpf = xdpf;
 
-	/* record the location of the first descriptor for this packet */
-	tx_buffer = &ring->tx_buffer_info[ring->next_to_use];
-	tx_buffer->bytecount = len;
-	tx_buffer->gso_segs = 1;
-	tx_buffer->protocol = 0;
+	tx_desc->read.olinfo_status =
+		cpu_to_le32(tx_head->bytecount << IXGBE_ADVTXD_PAYLEN_SHIFT);
 
-	i = ring->next_to_use;
-	tx_desc = IXGBE_TX_DESC(ring, i);
+	for (;;) {
+		dma_addr_t dma;
 
-	dma_unmap_len_set(tx_buffer, len, len);
-	dma_unmap_addr_set(tx_buffer, dma, dma);
-	tx_buffer->xdpf = xdpf;
+		dma = dma_map_single(ring->dev, data, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(ring->dev, dma))
+			goto unmap;
 
-	tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		dma_unmap_len_set(tx_buff, len, len);
+		dma_unmap_addr_set(tx_buff, dma, dma);
+
+		cmd_type = IXGBE_ADVTXD_DTYP_DATA | IXGBE_ADVTXD_DCMD_DEXT |
+			   IXGBE_ADVTXD_DCMD_IFCS | len;
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		tx_buff->protocol = 0;
+
+		if (++index == ring->count)
+			index = 0;
+
+		if (i == nr_frags)
+			break;
+
+		tx_buff = &ring->tx_buffer_info[index];
+		tx_desc = IXGBE_TX_DESC(ring, index);
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

