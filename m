Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CAA525704
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358710AbiELV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343679AbiELV31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:29:27 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31DD71A15FD;
        Thu, 12 May 2022 14:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652390967; x=1683926967;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1eq8MyD+b5WPzdc827/VpN9OEEmXa8hVevz1mkGB6mA=;
  b=JZnbLggdiXJAkA/cix1CyS+NovwLFWDBn3Ff1q2n1uSKczC2hHLVYObX
   axTpnxqZerk5mFOAD4NC2KqKEbgUPYuOzAfw4m8xDH+Xbt5UEaT/SznsQ
   i6kzZQHS6ZAjUyQzrbJ5B7IOqwaWq91VlVQIguCNyZl+3nfhMYOwNI4gO
   NrcPT4NxtRnwAepCOOwl/VFVyi/usIzgpomUg8sRE5ff5zgkZIsoeI2EH
   /Wpn3DYga6Dfn2+QGPn/TruySP0bkub7S8Tq0YSAi1H+uXeVZ9i5cbz/x
   Jb//c2RjCGjfpLzL8mPhgJ/J+gZYMu8sxp4KSd8XJNBzZYnuw7Tgbh4f9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="257685342"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="257685342"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 14:29:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="698221168"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 12 May 2022 14:29:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 1/1] ixgbe: add xdp frags support to ndo_xdp_xmit
Date:   Thu, 12 May 2022 14:26:21 -0700
Message-Id: <20220512212621.3746140-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 99 ++++++++++++-------
 1 file changed, 63 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 19cde928d9b7..77c2e70b0860 100644
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

