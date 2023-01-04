Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93DE65DD03
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 20:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239988AbjADTmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 14:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240070AbjADTln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 14:41:43 -0500
Received: from mx14lb.world4you.com (mx14lb.world4you.com [81.19.149.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF59B32
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 11:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Nz72CnL9nHY2qZPUJhfvhLhC0SYc3PFYteSyEsE0KI8=; b=DkG2vD8r2Dvr1uSUjKlM5N6IHU
        0wSp5dJLM9tMQ/txMZWe5lus7nKNKdjBTZkc6wgWS5Mw3yoltg46qwjfKTfXryUfBgALJfT/BNXL6
        wmalc85LuuRncJlczOsYA24KmN18ML6Zbkgv877gzemN5vcDwUuwiuV+0Wj1GpSzV7JA=;
Received: from 88-117-53-17.adsl.highway.telekom.at ([88.117.53.17] helo=hornet.engleder.at)
        by mx14lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pD9dt-0003c2-DN; Wed, 04 Jan 2023 20:41:41 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 5/9] tsnep: Substract TSNEP_RX_INLINE_METADATA_SIZE once
Date:   Wed,  4 Jan 2023 20:41:28 +0100
Message-Id: <20230104194132.24637-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230104194132.24637-1-gerhard@engleder-embedded.com>
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subtrace size of metadata in front of received data only once. This
simplifies the RX code.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 2c7252ded23a..9a666dbbe8cd 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -980,7 +980,7 @@ static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
 
 	/* update pointers within the skb to store the data */
 	skb_reserve(skb, TSNEP_SKB_PAD + TSNEP_RX_INLINE_METADATA_SIZE);
-	__skb_put(skb, length - TSNEP_RX_INLINE_METADATA_SIZE - ETH_FCS_LEN);
+	__skb_put(skb, length - ETH_FCS_LEN);
 
 	if (rx->adapter->hwtstamp_config.rx_filter == HWTSTAMP_FILTER_ALL) {
 		struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
@@ -1052,6 +1052,13 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
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
 
@@ -1060,7 +1067,7 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 			page_pool_release_page(rx->page_pool, entry->page);
 
 			rx->packets++;
-			rx->bytes += length - TSNEP_RX_INLINE_METADATA_SIZE;
+			rx->bytes += length;
 			if (skb->pkt_type == PACKET_MULTICAST)
 				rx->multicast++;
 
-- 
2.30.2

