Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DC0DE02
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfD2IfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:35:17 -0400
Received: from first.geanix.com ([116.203.34.67]:50060 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbfD2IfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:15 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id B5BBD308E94;
        Mon, 29 Apr 2019 08:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526830; bh=Syxx7UjWQdn8ym6ReJbNhi4YaO2pdMxoPdpOacvkHXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JOWacCElGVfmBjFHHw8WQQBDPJFJyMUpHn9DabH+ik6VatsagT46g8dJ0BBKibVgS
         ar45ruo6nspqTR2U8meXgSCmOlOWm6yBhdUcjG+wDc4v5147vnPD2uoKa0sFkPRN+R
         vk8ZlXCtcL6jsW9XGZzotjB41ISICQ99dRQCtoyxjUoXvGM18EYgjul1OzsMZ8jHgH
         pqdBks6XSYJPcqYD+X3rDLD9qg3kjCkvrelK4W8MK8nGKeaqzXyhfGl64tL+ShStLo
         uI84DxhLE82oDZN2wJR5HMEz+hpP7h3/U89uXUPvnrofBtpMzcOo1/Xl+G+DLjEuaw
         5HzNSKYl4jApg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        YueHaibing <yuehaibing@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] net: ll_temac: Enable DMA when ready, not before
Date:   Mon, 29 Apr 2019 10:34:22 +0200
Message-Id: <20190429083422.4356-13-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
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
index 5833f02..a230f6a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -316,17 +316,21 @@ static int temac_dma_bd_init(struct net_device *ndev)
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
@@ -790,6 +794,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_tx_timestamp(skb);
 
 	/* Kick off the transfer */
+	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
 	return NETDEV_TX_OK;
-- 
2.4.11

