Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912C1570DFB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiGKXK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiGKXKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 19:10:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AC3509DB;
        Mon, 11 Jul 2022 16:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657581054; x=1689117054;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IJDUfs5PueaQV3j5trOzLPxn9X25wV3W+YpQAN++hg4=;
  b=PRCYBsTv+UHL2Dktag/aY4kkyQ99EObUKHOFFYRXM/P9tq+a9G62Plrs
   3cmLt5pLCYVYxC1suM15E8SdZKVukKaSn/cqS5LchvWJASXdou35+l27S
   TWTrJ07rvHm08gJHdOne67FSv2iKelBsaAdmIpm57NA1vNhbAaQFc6FiT
   sDjE+Rown8jYV7N+8LdWLINM+AnUN7CEDWevFB9QJD00b0rXeCbqfQ+iT
   w+tTIaJrLakY7+/yp3ueeiMYeQ2ymJ5u36meNnwdxkNgD1b1X0TF+liCn
   fjnUs/2FBpysOqKPy1Xsx2HRxnSqWX7decxVDLRs/UE9dNC8LGcwemwF5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="267829920"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="267829920"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 16:10:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="592426707"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Jul 2022 16:10:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH net-next 1/1] igb: add xdp frags support to ndo_xdp_xmit
Date:   Mon, 11 Jul 2022 16:07:51 -0700
Message-Id: <20220711230751.3124415-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add the capability to map non-linear xdp frames in XDP_TX and
ndo_xdp_xmit callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 121 ++++++++++++++--------
 1 file changed, 78 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 4f91a85fe0cc..d8b836a85cc3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6260,74 +6260,108 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
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
@@ -8818,6 +8852,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			unsigned int offset = pkt_offset + igb_rx_offset(rx_ring);
 
 			xdp_prepare_buff(&xdp, hard_start, offset, size, true);
+			xdp_buff_clear_frags_flag(&xdp);
 #if (PAGE_SIZE > 4096)
 			/* At larger PAGE_SIZE, frame_sz depend on len size */
 			xdp.frame_sz = igb_rx_frame_truesize(rx_ring, size);
-- 
2.35.1

