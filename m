Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4666D026
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbjAPUZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbjAPUZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:25:17 -0500
Received: from mx25lb.world4you.com (mx25lb.world4you.com [81.19.149.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF3C26862
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vtN3fhSAEuLzi5a7TXMmkTLbKZ1BTNTW3Z5UCd8nM70=; b=h9pbUMDlI66i076Zp1Cq+21S7C
        h+A3EvQ4A0hZ4PS6OklWyrqZ/xSiUQ3XHkxPulgHJ1DJVGBfgK+rbh0sPZoaeNh9BGNArYf0vZxwZ
        fWwsapodOVSPBMENut0WdFpU/CjhXdTIheMVjPpKjMzi9zd990o79BQ36/gqQi4GPtDQ=;
Received: from 88-117-53-243.adsl.highway.telekom.at ([88.117.53.243] helo=hornet.engleder.at)
        by mx25lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pHW2a-00018Q-BK; Mon, 16 Jan 2023 21:25:12 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, alexander.duyck@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 5/9] tsnep: Subtract TSNEP_RX_INLINE_METADATA_SIZE once
Date:   Mon, 16 Jan 2023 21:24:54 +0100
Message-Id: <20230116202458.56677-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230116202458.56677-1-gerhard@engleder-embedded.com>
References: <20230116202458.56677-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subtract size of metadata in front of received data only once. This
simplifies the RX code.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 9b3eddda3f06..0730cd45f9a3 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -948,7 +948,7 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 
 	/* update pointers within the skb to store the data */
 	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
-	__skb_put(skb, length - TSNEP_RX_INLINE_METADATA_SIZE - ETH_FCS_LEN);
+	__skb_put(skb, length - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
@@ -1020,6 +1020,13 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 		dma_sync_single_range_for_cpu(dmadev, entry->dma, TSNEP_SKB_PAD,
 					      length, dma_dir);
 
+		/* RX metadata with timestamps is in front of actual data,
+		 * subtract metadata size to get length of actual data and
+		 * consider metadata size as offset of actual data during RX
+		 * processing
+		 */
+		length -= TSNEP_RX_INLINE_METADATA_SIZE;
+
 		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
 		desc_available++;
 
@@ -1028,7 +1035,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			page_pool_release_page(rx->page_pool, entry->page);
 
 			rx->packets++;
-			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+			rx->bytes += length;
 			if (skb->pkt_type == PACKET_MULTICAST)
 				rx->multicast++;
 
-- 
2.30.2

