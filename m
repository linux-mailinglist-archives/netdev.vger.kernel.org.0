Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7966815DA6
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfEGGnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:43:01 -0400
Received: from first.geanix.com ([116.203.34.67]:39484 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfEGGnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 02:43:01 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 89BE237F;
        Tue,  7 May 2019 06:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1557211340; bh=3j7hsqfL5Ak7/I07fcDuhw+qz+OMng7K/tE0F6C+WWc=;
        h=From:To:Cc:Subject:Date;
        b=YpnfD3eb+YPB29xtHpf26lp5faJa0/sZ8OX2+NSJ2QW+/NScicNU6T6JX1g3Kg3f6
         IUGDshncsdRa2a5FrzIMOxteBADFg/AHlrzgnzeNA7/T56yTA1LkbUFimWQdHZIsKx
         ySxur8Sbd9oMaLAhvyRekPecYEbghUG7wn6XtHGtvxLt5tJ71/yb7/bbcpgFhLiw5g
         ejOjnAvTl365nf7U6gy1vdM9elJYt3F+FBic6C+Nl6tHjny0SULOoZJnMMVLwP8GOm
         q3AZ2HPjAtdXCX2+XyHroO/58jQPbwIniou1yVagmQkngEZQ9WgM7jNRHIdppKubr6
         uTMDQMpF3nUvQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ll_temac: Improve error message on error IRQ
Date:   Tue,  7 May 2019 08:42:57 +0200
Message-Id: <20190507064258.2790-1-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 9cf0eadf640b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The channel status register value can be very helpful when debugging
SDMA problems.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9851991..36fc4c4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -886,8 +886,10 @@ static irqreturn_t ll_temac_tx_irq(int irq, void *_ndev)
 
 	if (status & (IRQ_COAL | IRQ_DLY))
 		temac_start_xmit_done(lp->ndev);
-	if (status & 0x080)
-		dev_err(&ndev->dev, "DMA error 0x%x\n", status);
+	if (status & (IRQ_ERR | IRQ_DMAERR))
+		dev_err_ratelimited(&ndev->dev,
+				    "TX error 0x%x TX_CHNL_STS=0x%08x\n",
+				    status, lp->dma_in(lp, TX_CHNL_STS));
 
 	return IRQ_HANDLED;
 }
@@ -904,6 +906,10 @@ static irqreturn_t ll_temac_rx_irq(int irq, void *_ndev)
 
 	if (status & (IRQ_COAL | IRQ_DLY))
 		ll_temac_recv(lp->ndev);
+	if (status & (IRQ_ERR | IRQ_DMAERR))
+		dev_err_ratelimited(&ndev->dev,
+				    "RX error 0x%x RX_CHNL_STS=0x%08x\n",
+				    status, lp->dma_in(lp, RX_CHNL_STS));
 
 	return IRQ_HANDLED;
 }
-- 
2.4.11

