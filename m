Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838C843D09A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243513AbhJ0SYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:24:38 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:28946 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbhJ0SYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635358932; x=1666894932;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kuWU/YLCWUXDiF4ZRT9NfBoavlLB6rHiAr08b0+yyhk=;
  b=wZ7wWq/VraDB87NZcWyAJr0t/Ne0ZQjBWRlHkRD0XflDk0mPnp571jnf
   ITZRNqRdjlDxlm075TYjKoh5zN2ztBwVSe3M5Qw9AyT+70wtj0fQq7ooU
   hNF09W1ruKMqBmXvxctKji22UxgioPhoMSf76uMow3fIqgx2orN3A3DcI
   DRnl83TnnzNwzKxGkj6burIxnQMLg1ZYD/NxgRAEL4slmBhJ8T3i6rhbB
   AuKEvxvDAH0j3EF4tinPpQhEDQ9Gv/NCf6Q9TxPFeFA+7FTSBkBBBwK7f
   JiJs1ItJIWRzpkaEJ/2lZijg5MPLhMkQUl3UTXLWqLhfqfxH3QwbCL1QO
   g==;
IronPort-SDR: Z+sSKFpGjHH65vc0CpsNL8NY6Eiff6b7+tzfz+Bh2xxe+mxGWJ7iuHTXEEwB7+V5ClNN7xe3G4
 eN6kw6NtmCq1+U0DxWf2IhiWqSH6i6Yoe5mO5VZZliH4x6VOCZ/AvRl2wRWefhCuq7sYYQAxs1
 ZViuOrgRd6HhKTamWZTbHlR2w2DFQCOtTScrRhwruq0mro3GojEzC5uXqM4PoCxRFN5jXLkvXv
 gOEAKBs4atQGTU9Uh9EeXRseIBu9OL7CI6uVICj2Uu3cXBLIf1Lta+Ksgn7N9FRYPw8nRm1GwL
 oi2RK5d9ge9xH4S2S3G695fr
X-IronPort-AV: E=Sophos;i="5.87,187,1631602800"; 
   d="scan'208";a="149755738"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 11:22:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 11:22:11 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 27 Oct 2021 11:22:11 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        "Yuiko Oshino" <yuiko.oshino@microchip.com>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Fix skb allocation failure
Date:   Wed, 27 Oct 2021 14:23:02 -0400
Message-ID: <20211027182302.12010-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver allocates skb during ndo_open with GFP_ATOMIC which has high chance of failure when there are multiple instances.
GFP_KERNEL is enough while open and use GFP_ATOMIC only from interrupt context.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 03d02403c19e..fd3e5331922c 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1934,7 +1934,8 @@ static void lan743x_rx_update_tail(struct lan743x_rx *rx, int index)
 				  index);
 }
 
-static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
+static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index,
+					gfp_t gfp)
 {
 	struct net_device *netdev = rx->adapter->netdev;
 	struct device *dev = &rx->adapter->pdev->dev;
@@ -1948,7 +1949,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
 
 	descriptor = &rx->ring_cpu_ptr[index];
 	buffer_info = &rx->buffer_info[index];
-	skb = __netdev_alloc_skb(netdev, buffer_length, GFP_ATOMIC | GFP_DMA);
+	skb = __netdev_alloc_skb(netdev, buffer_length, gfp);
 	if (!skb)
 		return -ENOMEM;
 	dma_ptr = dma_map_single(dev, skb->data, buffer_length, DMA_FROM_DEVICE);
@@ -2110,7 +2111,8 @@ static int lan743x_rx_process_buffer(struct lan743x_rx *rx)
 
 	/* save existing skb, allocate new skb and map to dma */
 	skb = buffer_info->skb;
-	if (lan743x_rx_init_ring_element(rx, rx->last_head)) {
+	if (lan743x_rx_init_ring_element(rx, rx->last_head,
+					 GFP_ATOMIC | GFP_DMA)) {
 		/* failed to allocate next skb.
 		 * Memory is very low.
 		 * Drop this packet and reuse buffer.
@@ -2315,13 +2317,16 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 
 	rx->last_head = 0;
 	for (index = 0; index < rx->ring_size; index++) {
-		ret = lan743x_rx_init_ring_element(rx, index);
+		ret = lan743x_rx_init_ring_element(rx, index, GFP_KERNEL);
 		if (ret)
 			goto cleanup;
 	}
 	return 0;
 
 cleanup:
+	netif_warn(rx->adapter, ifup, rx->adapter->netdev,
+		   "Error allocating memory for LAN743x\n");
+
 	lan743x_rx_ring_cleanup(rx);
 	return ret;
 }
-- 
2.25.1

