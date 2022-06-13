Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987B4549CD7
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346939AbiFMTF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346878AbiFMTEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:04:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA092AEE3E;
        Mon, 13 Jun 2022 09:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655139294; x=1686675294;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T8DsjbHMJH9H/sas4zjaNcK0/xHg+etx706tBmmx1aU=;
  b=LE0dM8ryqkChJPM5zgV8oahRuUvjuvJijdF1SQCMlCEljXzGV/ugA0is
   fgq4rbjjeeOn6vHBZWt12JN1pSytkloxaldlDmuK+lH5xwaDZlSpJsoAg
   yRU//Kfpu7JQPE+2seiAajdGyNzM4wa4Z2qIgBkKc2ot0SFazIaFxdJzt
   TVp3Qdro5tlapqWesyb7VmApX3NUHJBpimF1eXfB+hkOH8zTFO3nBPejU
   PcWBi2Db2S1uqKuqzHyNvHtZgMwxu7f8FKJ5T+99Ef7eZEnT5cN8XiPWk
   +zE2pbr9wbElqJMoBq/u8MKtys4geJEofgQ0KooiTMtQz7kUkQHFxLtJf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="277120297"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="277120297"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 09:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="726354239"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2022 09:54:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Sarkar Tirthendu <tirthendu.sarkar@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net-next 1/1] i40e: add xdp frags support to ndo_xdp_xmit
Date:   Mon, 13 Jun 2022 09:51:50 -0700
Message-Id: <20220613165150.439856-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Add the capability to map non-linear xdp frames in XDP_TX and ndo_xdp_xmit
callback.

Tested-by: Sarkar Tirthendu <tirthendu.sarkar@intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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

