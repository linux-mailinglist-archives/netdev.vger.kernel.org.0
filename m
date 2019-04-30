Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F1F11E
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfD3HS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:56 -0400
Received: from first.geanix.com ([116.203.34.67]:43798 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfD3HSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:50 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id F240B308EA3;
        Tue, 30 Apr 2019 07:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608723; bh=d5jSy2G73aQlTbm0gKX8UO9SuypNh5XD4AWqgpyyw8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jUramFxIeEYeFnLsreuoaW7Gk7DBAG10Otw/uPkYe2YOyWmGnXUvm+pDNooCBJg2U
         Hnf0GjP7UzeLsPaHFwg/93ZvrpzQdb82Bqh9ExCwpX71jP5vOqIgjlKC8WSWLHT0zr
         FKDIoeozLbhsrKW59/JPE/XcsfwQE89XX1IJbtEeuby/IQ6Kfc3k18lzUSXhQgYkgn
         zHi1oXQVFX/3LWkVcCToCDRbhi3CthF3zt4WamYw/QRNbuBAHFftmrrU5zqB0oR7eN
         tWBPzb2W3LYMqJVvbgbsm0C5whRJV2kS1kAS9LIf/J4JqyHh8wjNDp0LQf0Rjb5rFU
         Ml+pkAwmH9BOQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/12] net: ll_temac: Enable DMA when ready, not before
Date:   Tue, 30 Apr 2019 09:17:59 +0200
Message-Id: <20190430071759.2481-13-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As soon as TAILDESCR_PTR is written, DMA transfers might start.
Let's ensure we are ready to receive DMA IRQ's before doing that.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index bccef30..1003ee1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -314,17 +314,21 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		    CHNL_CTRL_IRQ_EN | CHNL_CTRL_IRQ_ERR_EN |
 		    CHNL_CTRL_IRQ_DLY_EN | CHNL_CTRL_IRQ_COAL_EN);
 
-	lp->dma_out(lp, RX_CURDESC_PTR,  lp->rx_bd_p);
-	lp->dma_out(lp, RX_TAILDESC_PTR,
-		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
-	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
-
 	/* Init descriptor indexes */
 	lp->tx_bd_ci = 0;
 	lp->tx_bd_next = 0;
 	lp->tx_bd_tail = 0;
 	lp->rx_bd_ci = 0;
 
+	/* Enable RX DMA transfers */
+	wmb();
+	lp->dma_out(lp, RX_CURDESC_PTR,  lp->rx_bd_p);
+	lp->dma_out(lp, RX_TAILDESC_PTR,
+		       lp->rx_bd_p + (sizeof(*lp->rx_bd_v) * (RX_BD_NUM - 1)));
+
+	/* Prepare for TX DMA transfer */
+	lp->dma_out(lp, TX_CURDESC_PTR, lp->tx_bd_p);
+
 	return 0;
 
 out:
@@ -789,6 +793,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_tx_timestamp(skb);
 
 	/* Kick off the transfer */
+	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
 	return NETDEV_TX_OK;
-- 
2.4.11

