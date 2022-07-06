Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257C8568087
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiGFHy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiGFHy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:54:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457781AF2A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 00:54:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA814B81B10
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 07:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C69C3411C;
        Wed,  6 Jul 2022 07:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657094090;
        bh=ELRHvyXNJVImNM2lth4w2n4eIkbQRwt/oCHIWIRH2F0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ovmjdjg/J+FeRWgkFNGcvru2B+5IzSto7Ma2M6Bi7Zgl0Jx5eS6kmwurjyjrOECfB
         6GY9fPUomDY9n8kRc5zKwk7JYGGezEbbLFbBzKEnnhmd84iLJ9JGtba4HB4HmjVfLU
         QHJYgwqkPUfCFKc4mT0woG4w8FQsi/QI2ro0IVKEgNmCujMFVCdHdW8lpCFAQ2Hbt0
         yE4x3rs1PIBSQ5cuMAMKxeS1UrjAQwKUXyJMb1NYxvNQqQCKy9W8xniFBGojfVAPJG
         MbSb7dHMlOumR2jgfQMSHSJdEYMkk4r2j3+mzpF/cJy9+AnuZghLtqhF2IJUPjDzKl
         ScrllAR/QZ5Ag==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, magnus.karlsson@intel.com,
        jbrouer@redhat.com
Subject: [PATCH net-next] igc: add xdp frags support to ndo_xdp_xmit
Date:   Wed,  6 Jul 2022 09:54:19 +0200
Message-Id: <d8e3744f060ee11d5069bfd0f581f02d0ecb5e08.1657093744.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Please note this patch is only compiled tested since I do not have
access to a igc NIC
---
 drivers/net/ethernet/intel/igc/igc_main.c | 128 ++++++++++++++--------
 1 file changed, 83 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ae17af44fe02..71657d03da03 100644
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
2.36.1

