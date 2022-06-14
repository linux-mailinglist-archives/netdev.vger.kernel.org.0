Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C0654BDAB
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344917AbiFNWcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344024AbiFNWcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:32:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA43527C6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 15:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F58B81B89
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 22:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019FEC3411B;
        Tue, 14 Jun 2022 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655245917;
        bh=leGr+JWd0li0QJzHgZsu5Lo8BHy460tyUF/B30Yspnw=;
        h=From:To:Cc:Subject:Date:From;
        b=ARDlUG51Ii4QDpvKuPXkSGROYBTgorByvKJpCrNaWjuaOy6WwJBpsx5CtfyQKDHHg
         jGCmHYio0NE62vZhLmCFz+PkY4iHK8Tf1Ll2e03Hlqm6GiV8pMKSlqRamb6x2dy0Ut
         M/+ib8Hg4AqFszRbyk3mFY0i8V+UIpXWGRicfjkVAmHqGhc2lb67Q1Sspwu9vhLpTg
         K37uzYMrwSnRP5PnVat1NjkA8iWlAmB4E2ijLf1TuWeNrMlEg5FxX6Xhh0KnkZrhkh
         XMaMQwAcNMbVIz3jJORn47yR7Lng9efctY/Cpn6lqcfcKKkQA9B9hT7oYceZxkYNVx
         fJ92AftTiy7NQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, magnus.karlsson@intel.com,
        jbrouer@redhat.com
Subject: [PATCH net-next] igb: add xdp frags support to ndo_xdp_xmit
Date:   Wed, 15 Jun 2022 00:31:29 +0200
Message-Id: <3cd4bb394267b48b019fa6ccd4088577833051cb.1655245561.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
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

Add the capability to map non-linear xdp frames in XDP_TX and
ndo_xdp_xmit callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 121 ++++++++++++++--------
 1 file changed, 78 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 68be2976f539..ca1a4e511cbc 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6257,74 +6257,108 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
 		      struct igb_ring *tx_ring,
 		      struct xdp_frame *xdpf)
 {
-	union e1000_adv_tx_desc *tx_desc;
-	u32 len, cmd_type, olinfo_status;
-	struct igb_tx_buffer *tx_buffer;
-	dma_addr_t dma;
-	u16 i;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u8 nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	u16 count, i, index = tx_ring->next_to_use;
+	struct igb_tx_buffer *tx_head = &tx_ring->tx_buffer_info[index];
+	struct igb_tx_buffer *tx_buffer = tx_head;
+	union e1000_adv_tx_desc *tx_desc = IGB_TX_DESC(tx_ring, index);
+	u32 len = xdpf->len, cmd_type, olinfo_status;
+	void *data = xdpf->data;
+
+	count = TXD_USE_COUNT(len);
+	for (i = 0; i < nr_frags; i++)
+		count += TXD_USE_COUNT(skb_frag_size(&sinfo->frags[i]));
+
+	if (igb_maybe_stop_tx(tx_ring, count + 3))
+		return IGB_XDP_CONSUMED;
 
-	len = xdpf->len;
+	i = 0;
+	/* record the location of the first descriptor for this packet */
+	tx_head->bytecount = xdp_get_frame_len(xdpf);
+	tx_head->type = IGB_TYPE_XDP;
+	tx_head->gso_segs = 1;
+	tx_head->xdpf = xdpf;
 
-	if (unlikely(!igb_desc_unused(tx_ring)))
-		return IGB_XDP_CONSUMED;
+	olinfo_status = tx_head->bytecount << E1000_ADVTXD_PAYLEN_SHIFT;
+	/* 82575 requires a unique index per ring */
+	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
+		olinfo_status |= tx_ring->reg_idx << 4;
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 
-	dma = dma_map_single(tx_ring->dev, xdpf->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(tx_ring->dev, dma))
-		return IGB_XDP_CONSUMED;
+	for (;;) {
+		dma_addr_t dma;
 
-	/* record the location of the first descriptor for this packet */
-	tx_buffer = &tx_ring->tx_buffer_info[tx_ring->next_to_use];
-	tx_buffer->bytecount = len;
-	tx_buffer->gso_segs = 1;
-	tx_buffer->protocol = 0;
+		dma = dma_map_single(tx_ring->dev, data, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(tx_ring->dev, dma))
+			goto unmap;
 
-	i = tx_ring->next_to_use;
-	tx_desc = IGB_TX_DESC(tx_ring, i);
+		/* record length, and DMA address */
+		dma_unmap_len_set(tx_buffer, len, len);
+		dma_unmap_addr_set(tx_buffer, dma, dma);
 
-	dma_unmap_len_set(tx_buffer, len, len);
-	dma_unmap_addr_set(tx_buffer, dma, dma);
-	tx_buffer->type = IGB_TYPE_XDP;
-	tx_buffer->xdpf = xdpf;
+		/* put descriptor type bits */
+		cmd_type = E1000_ADVTXD_DTYP_DATA | E1000_ADVTXD_DCMD_DEXT |
+			   E1000_ADVTXD_DCMD_IFCS | len;
 
-	tx_desc->read.buffer_addr = cpu_to_le64(dma);
+		tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+		tx_desc->read.buffer_addr = cpu_to_le64(dma);
 
-	/* put descriptor type bits */
-	cmd_type = E1000_ADVTXD_DTYP_DATA |
-		   E1000_ADVTXD_DCMD_DEXT |
-		   E1000_ADVTXD_DCMD_IFCS;
-	cmd_type |= len | IGB_TXD_DCMD;
-	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+		tx_buffer->protocol = 0;
 
-	olinfo_status = len << E1000_ADVTXD_PAYLEN_SHIFT;
-	/* 82575 requires a unique index per ring */
-	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
-		olinfo_status |= tx_ring->reg_idx << 4;
+		if (++index == tx_ring->count)
+			index = 0;
 
-	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
+		if (i == nr_frags)
+			break;
+
+		tx_buffer = &tx_ring->tx_buffer_info[index];
+		tx_desc = IGB_TX_DESC(tx_ring, index);
+		tx_desc->read.olinfo_status = 0;
 
-	netdev_tx_sent_queue(txring_txq(tx_ring), tx_buffer->bytecount);
+		data = skb_frag_address(&sinfo->frags[i]);
+		len = skb_frag_size(&sinfo->frags[i]);
+		i++;
+	}
+	tx_desc->read.cmd_type_len |= cpu_to_le32(IGB_TXD_DCMD);
 
+	netdev_tx_sent_queue(txring_txq(tx_ring), tx_head->bytecount);
 	/* set the timestamp */
-	tx_buffer->time_stamp = jiffies;
+	tx_head->time_stamp = jiffies;
 
 	/* Avoid any potential race with xdp_xmit and cleanup */
 	smp_wmb();
 
 	/* set next_to_watch value indicating a packet is present */
-	i++;
-	if (i == tx_ring->count)
-		i = 0;
-
-	tx_buffer->next_to_watch = tx_desc;
-	tx_ring->next_to_use = i;
+	tx_head->next_to_watch = tx_desc;
+	tx_ring->next_to_use = index;
 
 	/* Make sure there is space in the ring for the next send. */
 	igb_maybe_stop_tx(tx_ring, DESC_NEEDED);
 
 	if (netif_xmit_stopped(txring_txq(tx_ring)) || !netdev_xmit_more())
-		writel(i, tx_ring->tail);
+		writel(index, tx_ring->tail);
 
 	return IGB_XDP_TX;
+
+unmap:
+	for (;;) {
+		tx_buffer = &tx_ring->tx_buffer_info[index];
+		if (dma_unmap_len(tx_buffer, len))
+			dma_unmap_page(tx_ring->dev,
+				       dma_unmap_addr(tx_buffer, dma),
+				       dma_unmap_len(tx_buffer, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(tx_buffer, len, 0);
+		if (tx_buffer == tx_head)
+			break;
+
+		if (!index)
+			index += tx_ring->count;
+		index--;
+	}
+
+	return IGB_XDP_CONSUMED;
 }
 
 netdev_tx_t igb_xmit_frame_ring(struct sk_buff *skb,
@@ -8815,6 +8849,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			unsigned int offset = pkt_offset + igb_rx_offset(rx_ring);
 
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+			xdp_buff_clear_frags_flag(&xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
-- 
2.36.1

