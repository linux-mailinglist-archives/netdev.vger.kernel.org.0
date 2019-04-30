Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651DBF111
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfD3HSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:21 -0400
Received: from first.geanix.com ([116.203.34.67]:43632 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfD3HST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:19 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 0922B308E96;
        Tue, 30 Apr 2019 07:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608691; bh=N9rIOEY5cDKP0QgUz3zh23RIYriyNIyneQockxlSB8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=caYeJEdOwgP+vTozy51jSuoBaZ6efk4kSNhIwhBroX/NKyWCsJC+YJSjsvtyKLxPp
         yvh5hVT66Or4c9JjP7f3D470dER88AigYkgfQYRNbVUDISjhVIekJipEI96MRulSXg
         Xor/GshkcfEvi5nn0ufi5r1rQvwF7wzjPIGstIcZy9h1+8+tUBb+6bVNziAEie6+E5
         Xsqc5G8oZu5DgaQvEtAym8ppE4qasIYaMsmeaeN8W3Ysvj6L81kKTgemuisXFDFkjL
         NyMBUpP5jOT7NNl4PQHwufUvXhK0lKHZbDA1TWk7T9uULLJFr+CEZFKb+bzk8LEDPe
         fS3ZZqSNmreFg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/12] net: ll_temac: Fix support for 64-bit platforms
Date:   Tue, 30 Apr 2019 09:17:50 +0200
Message-Id: <20190430071759.2481-4-esben@geanix.com>
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

The use of buffer descriptor APP4 field (32-bit) for storing skb pointer
obviously does not work on 64-bit platforms.
As APP3 is also unused, we can use that to store the other half of 64-bit
pointer values.

Contrary to what is hinted at in commit message of commit 15bfe05c8d63
("net: ethernet: xilinx: Mark XILINX_LL_TEMAC broken on 64-bit")
there are no other pointers stored in cdmac_bd.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/Kconfig         |  1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c | 35 ++++++++++++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index da4ec57..6d68c8a 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -34,7 +34,6 @@ config XILINX_AXI_EMAC
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
 	depends on (PPC || MICROBLAZE)
-	depends on !64BIT || BROKEN
 	select PHYLIB
 	---help---
 	  This driver supports the Xilinx 10/100/1000 LocalLink TEMAC
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index fddd1b3..bcafb89 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -619,11 +619,39 @@ static void temac_adjust_link(struct net_device *ndev)
 	mutex_unlock(&lp->indirect_mutex);
 }
 
+#ifdef CONFIG_64BIT
+
+void ptr_to_txbd(void *p, struct cdmac_bd *bd)
+{
+	bd->app3 = (u32)(((u64)p) >> 32);
+	bd->app4 = (u32)((u64)p & 0xFFFFFFFF);
+}
+
+void *ptr_from_txbd(struct cdmac_bd *bd)
+{
+	return (void *)(((u64)(bd->app3) << 32) | bd->app4);
+}
+
+#else
+
+void ptr_to_txbd(void *p, struct cmdac_bd *bd)
+{
+	bd->app4 = (u32)p;
+}
+
+void *ptr_from_txbd(struct cdmac_bd *bd)
+{
+	return (void *)(bd->app4);
+}
+
+#endif
+
 static void temac_start_xmit_done(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct cdmac_bd *cur_p;
 	unsigned int stat = 0;
+	struct sk_buff *skb;
 
 	cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
 	stat = cur_p->app0;
@@ -631,8 +659,9 @@ static void temac_start_xmit_done(struct net_device *ndev)
 	while (stat & STS_CTRL_APP0_CMPLT) {
 		dma_unmap_single(ndev->dev.parent, cur_p->phys, cur_p->len,
 				 DMA_TO_DEVICE);
-		if (cur_p->app4)
-			dev_consume_skb_irq((struct sk_buff *)cur_p->app4);
+		skb = (struct sk_buff *)ptr_from_txbd(cur_p);
+		if (skb)
+			dev_consume_skb_irq(skb);
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -711,7 +740,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p->len = skb_headlen(skb);
 	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
 				     skb_headlen(skb), DMA_TO_DEVICE);
-	cur_p->app4 = (unsigned long)skb;
+	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
 		lp->tx_bd_tail++;
-- 
2.4.11

