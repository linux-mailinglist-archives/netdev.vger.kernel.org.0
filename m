Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F264597538
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbiHQRgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiHQRgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:36:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE4DA0634;
        Wed, 17 Aug 2022 10:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660757800; x=1692293800;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=I1efkdsc7DB6bh1uIU97PGGNJMFoa28d5brL3OXk8Iw=;
  b=NaBFbzfDYSfo9veo+EBZQAbzfN1ZiLy9QEFRPK2v7KTi7gc2UU197p5y
   AHBhLp7u1bQwhYGBWCnClCczS3HfodWnIc4OMbUSoGVZe5khrSo/6fJ9M
   jNM8TKO3qy4DV31xsaBxhcbPu1jl7g0IWhoWyvUF4+722ZEpMQmn9O/Az
   NYU+QU8NpUY0BKKSn+qFke7rRSsYJho7S7wvI3av8WlxlXSG8mHl75gWU
   rInFtB0Qn6D3vd0cyzUJ7fLWflKkQ+D/PsfSpkkzYVLWYHURdFHFKOFea
   SJGn9PyKbrzT2BSILRdyVfL3pdkJxE2YrvKSbzgVAjLRv4epZkpn0bBem
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="275614067"
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="275614067"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 10:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,243,1654585200"; 
   d="scan'208";a="636470685"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 17 Aug 2022 10:36:38 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 1/1] igc: add xdp frags support to ndo_xdp_xmit
Date:   Wed, 17 Aug 2022 10:36:28 -0700
Message-Id: <20220817173628.109102-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add the capability to map non-linear xdp frames in XDP_TX and
ndo_xdp_xmit callback.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 128 ++++++++++++++--------
 1 file changed, 83 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ebff0e04045d..bf6c461e1a2a 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2129,65 +2129,102 @@ static bool igc_alloc_rx_buffers_zc(struct igc_ring *ring, u16 count)
 	return ok;
 }
 
-static int igc_xdp_init_tx_buffer(struct igc_tx_buffer *buffer,
-				  struct xdp_frame *xdpf,
-				  struct igc_ring *ring)
-{
-	dma_addr_t dma;
-
-	dma = dma_map_single(ring->dev, xdpf->data, xdpf->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(ring->dev, dma)) {
-		netdev_err_once(ring->netdev, "Failed to map DMA for TX\n");
-		return -ENOMEM;
-	}
-
-	buffer->type = IGC_TX_BUFFER_TYPE_XDP;
-	buffer->xdpf = xdpf;
-	buffer->protocol = 0;
-	buffer->bytecount = xdpf->len;
-	buffer->gso_segs = 1;
-	buffer->time_stamp = jiffies;
-	dma_unmap_len_set(buffer, len, xdpf->len);
-	dma_unmap_addr_set(buffer, dma, dma);
-	return 0;
-}
-
 /* This function requires __netif_tx_lock is held by the caller. */
 static int igc_xdp_init_tx_descriptor(struct igc_ring *ring,
 				      struct xdp_frame *xdpf)
 {
-	struct igc_tx_buffer *buffer;
-	union igc_adv_tx_desc *desc;
-	u32 cmd_type, olinfo_status;
-	int err;
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_frame(xdpf);
+	u8 nr_frags = unlikely(xdp_frame_has_frags(xdpf)) ? sinfo->nr_frags : 0;
+	u16 count, index = ring->next_to_use;
+	struct igc_tx_buffer *head = &ring->tx_buffer_info[index];
+	struct igc_tx_buffer *buffer = head;
+	union igc_adv_tx_desc *desc = IGC_TX_DESC(ring, index);
+	u32 olinfo_status, len = xdpf->len, cmd_type;
+	void *data = xdpf->data;
+	u16 i;
 
-	if (!igc_desc_unused(ring))
-		return -EBUSY;
+	count = TXD_USE_COUNT(len);
+	for (i = 0; i < nr_frags; i++)
+		count += TXD_USE_COUNT(skb_frag_size(&sinfo->frags[i]));
 
-	buffer = &ring->tx_buffer_info[ring->next_to_use];
-	err = igc_xdp_init_tx_buffer(buffer, xdpf, ring);
-	if (err)
-		return err;
+	if (igc_maybe_stop_tx(ring, count + 3)) {
+		/* this is a hard error */
+		return -EBUSY;
+	}
 
-	cmd_type = IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
-		   IGC_ADVTXD_DCMD_IFCS | IGC_TXD_DCMD |
-		   buffer->bytecount;
-	olinfo_status = buffer->bytecount << IGC_ADVTXD_PAYLEN_SHIFT;
+	i = 0;
+	head->bytecount = xdp_get_frame_len(xdpf);
+	head->type = IGC_TX_BUFFER_TYPE_XDP;
+	head->gso_segs = 1;
+	head->xdpf = xdpf;
 
-	desc = IGC_TX_DESC(ring, ring->next_to_use);
-	desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+	olinfo_status = head->bytecount << IGC_ADVTXD_PAYLEN_SHIFT;
 	desc->read.olinfo_status = cpu_to_le32(olinfo_status);
-	desc->read.buffer_addr = cpu_to_le64(dma_unmap_addr(buffer, dma));
 
-	netdev_tx_sent_queue(txring_txq(ring), buffer->bytecount);
+	for (;;) {
+		dma_addr_t dma;
 
-	buffer->next_to_watch = desc;
+		dma = dma_map_single(ring->dev, data, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(ring->dev, dma)) {
+			netdev_err_once(ring->netdev,
+					"Failed to map DMA for TX\n");
+			goto unmap;
+		}
 
-	ring->next_to_use++;
-	if (ring->next_to_use == ring->count)
-		ring->next_to_use = 0;
+		dma_unmap_len_set(buffer, len, len);
+		dma_unmap_addr_set(buffer, dma, dma);
+
+		cmd_type = IGC_ADVTXD_DTYP_DATA | IGC_ADVTXD_DCMD_DEXT |
+			   IGC_ADVTXD_DCMD_IFCS | len;
+
+		desc->read.cmd_type_len = cpu_to_le32(cmd_type);
+		desc->read.buffer_addr = cpu_to_le64(dma);
+
+		buffer->protocol = 0;
+
+		if (++index == ring->count)
+			index = 0;
+
+		if (i == nr_frags)
+			break;
+
+		buffer = &ring->tx_buffer_info[index];
+		desc = IGC_TX_DESC(ring, index);
+		desc->read.olinfo_status = 0;
+
+		data = skb_frag_address(&sinfo->frags[i]);
+		len = skb_frag_size(&sinfo->frags[i]);
+		i++;
+	}
+	desc->read.cmd_type_len |= cpu_to_le32(IGC_TXD_DCMD);
+
+	netdev_tx_sent_queue(txring_txq(ring), head->bytecount);
+	/* set the timestamp */
+	head->time_stamp = jiffies;
+	/* set next_to_watch value indicating a packet is present */
+	head->next_to_watch = desc;
+	ring->next_to_use = index;
 
 	return 0;
+
+unmap:
+	for (;;) {
+		buffer = &ring->tx_buffer_info[index];
+		if (dma_unmap_len(buffer, len))
+			dma_unmap_page(ring->dev,
+				       dma_unmap_addr(buffer, dma),
+				       dma_unmap_len(buffer, len),
+				       DMA_TO_DEVICE);
+		dma_unmap_len_set(buffer, len, 0);
+		if (buffer == head)
+			break;
+
+		if (!index)
+			index += ring->count;
+		index--;
+	}
+
+	return -ENOMEM;
 }
 
 static struct igc_ring *igc_xdp_get_tx_ring(struct igc_adapter *adapter,
@@ -2369,6 +2406,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 			xdp_prepare_buff(&xdp, pktbuf - igc_rx_offset(rx_ring),
 					 igc_rx_offset(rx_ring) + pkt_offset,
 					 size, true);
+			xdp_buff_clear_frags_flag(&xdp);
 
 			skb = igc_xdp_run_prog(adapter, &xdp);
 		}
-- 
2.35.1

