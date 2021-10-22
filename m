Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF70437A5B
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJVPz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:55:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:7034 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhJVPz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:55:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634918021; x=1666454021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0tlHHuiMm8lnErn5V27t3ajdulg+qS8R0CqBufmjxlA=;
  b=HlCbjxmfTk/+uPxDu1jts5SfEb1zTEMUAck7j5xoDvcsmyYwhZQihs1C
   JbHkJtvurXtsgLBDfg37pgTAFvXhugi+XogP9lpX6f95YEDdrV5IpesDP
   uzwSzDbonREZV/49V4bLb1e0wjKjVkFetGpssJ9CNeOfw4110ffrfSQyz
   u21twM/g/1S8OZDwxVMWn6Ja1i5MX9UEYIGynmLXy4s1YS8delZSD6V9Y
   9o+1l9Jk2Q++jPYsv74GCJaRnjKOTGpc+ol1mpzblKJKzZhoYEQ2dGp6e
   kO6ONOWd1kHF6l6BDrtgsJwKWiRavF+CgUp/5cLzhUZsRTflgNu0p0Zqh
   A==;
IronPort-SDR: jsw2Ypl+pVt+8Hqs4wdbYCWymoDIkZMkEmcRMV1wRmbBsOc7y9NvpYA2Ifm9wcIjwH2Erv9Pfx
 QiRiZS/qmXgynfzQeXjc98pDYmB9BZpJUou7nvyh4GwYH8bn/YG3LS4Sgb8yRoCJy6vI2zIzQa
 fByNHhsyZka7+SaCTftVod8H+CuI/qT/ZgqnM7xSHddpaCqYHiW4UkFRWHd/edRSds36yqABor
 ptUUjs2fmAw/cZ3Ayc8x9HF6QOStcCVBWeUp8Rmfvsw0aHQETfywL5EBpM707rINKvJRtloP5b
 Q9Lbp20yXi7nJKsP7JmbdDaX
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="140767056"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Oct 2021 08:53:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Oct 2021 08:53:38 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Oct 2021 08:53:38 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        "Yuiko Oshino" <yuiko.oshino@microchip.com>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Fix dma allocation failure by using dma_set_mask_and_coherent
Date:   Fri, 22 Oct 2021 11:53:43 -0400
Message-ID: <20211022155343.91841-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dma failure was reported in the raspberry pi github (issue #4117).
https://github.com/raspberrypi/linux/issues/4117
The use of dma_set_mask_and_coherent fixes the issue.
Tested on 32/64-bit raspberry pi CM4 and 64-bit ubuntu x86 PC with EVB-LAN7430.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 03d02403c19e..6ffcd1b06f2d 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1743,6 +1743,16 @@ static int lan743x_tx_ring_init(struct lan743x_tx *tx)
 		ret = -EINVAL;
 		goto cleanup;
 	}
+	if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
+				      DMA_BIT_MASK(64))) {
+		if (dma_set_mask_and_coherent(&tx->adapter->pdev->dev,
+					      DMA_BIT_MASK(32))) {
+			dev_warn(&tx->adapter->pdev->dev,
+				 "lan743x_: No suitable DMA available\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
 	ring_allocation_size = ALIGN(tx->ring_size *
 				     sizeof(struct lan743x_tx_descriptor),
 				     PAGE_SIZE);
@@ -2276,6 +2286,16 @@ static int lan743x_rx_ring_init(struct lan743x_rx *rx)
 		ret = -EINVAL;
 		goto cleanup;
 	}
+	if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
+				      DMA_BIT_MASK(64))) {
+		if (dma_set_mask_and_coherent(&rx->adapter->pdev->dev,
+					      DMA_BIT_MASK(32))) {
+			dev_warn(&rx->adapter->pdev->dev,
+				 "lan743x_: No suitable DMA available\n");
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
 	ring_allocation_size = ALIGN(rx->ring_size *
 				     sizeof(struct lan743x_rx_descriptor),
 				     PAGE_SIZE);
-- 
2.25.1

