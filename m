Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF5124434
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfLRKR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:17:56 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:37016 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbfLRKRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:17:54 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2F3AAC0D71;
        Wed, 18 Dec 2019 10:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576664273; bh=0V7ycoXlyQYuTHjt0cT6JCyiSVD/6V/0IwC4LZ+D3l4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=emfbKhmIV1Bfm4dorxJ+szcV5zB6J9I0gnxQ33dWo0Hur7t//SVZbxgar6MlGt7JK
         S+VCZAD37PSj9vcnLd9pRkOwdVkyLJs+gZ+7jYOrrg+rsUzku2Vcyp1sNxVjrZWdRC
         HhiwstlUWadOWDeTNgXwzsGzP+UVj7vrrLFK+9YUdYkKHXiFdo0qQhfG9Z5qgEPh0j
         9YrjWlYO8p5DsIU3tSw2ts1GGhXRzHel2LKrpSoDVHd3rd8h4t+pbjjxJ1638Nr429
         ctZYY9r6/nokPKoUdpY+dqwKw61gtEhZkQhrI5QCpbnGFl1DhnSXuDVZExyJthF9sR
         EBcfcAFQNjcBg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 882C4A007B;
        Wed, 18 Dec 2019 10:17:51 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 2/9] net: stmmac: Determine earlier the size of RX buffer
Date:   Wed, 18 Dec 2019 11:17:36 +0100
Message-Id: <c63824aa983658fa83bbb3a53f56b4d8355a7073.1576664155.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576664155.git.Jose.Abreu@synopsys.com>
References: <cover.1576664155.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576664155.git.Jose.Abreu@synopsys.com>
References: <cover.1576664155.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split Header feature needs to know the size of RX buffer but current
code is determining it too late. Fix this by moving the RX buffer
computation to earlier stage.

Changes from v2:
- Do not try to align already aligned buffer size

Fixes: 67afd6d1cfdf ("net: stmmac: Add Split Header support and enable it in XGMAC cores")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index bbc65bd332a8..eccbf5daf9ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1293,19 +1293,9 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_count = priv->plat->rx_queues_to_use;
 	int ret = -ENOMEM;
-	int bfsize = 0;
 	int queue;
 	int i;
 
-	bfsize = stmmac_set_16kib_bfsize(priv, dev->mtu);
-	if (bfsize < 0)
-		bfsize = 0;
-
-	if (bfsize < BUF_SIZE_16KiB)
-		bfsize = stmmac_set_bfsize(dev->mtu, priv->dma_buf_sz);
-
-	priv->dma_buf_sz = bfsize;
-
 	/* RX INITIALIZATION */
 	netif_dbg(priv, probe, priv->dev,
 		  "SKB addresses:\nskb\t\tskb data\tdma data\n");
@@ -1347,8 +1337,6 @@ static int init_dma_rx_desc_rings(struct net_device *dev, gfp_t flags)
 		}
 	}
 
-	buf_sz = bfsize;
-
 	return 0;
 
 err_init_rx_buffers:
@@ -2658,6 +2646,7 @@ static void stmmac_hw_teardown(struct net_device *dev)
 static int stmmac_open(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	int bfsize = 0;
 	u32 chan;
 	int ret;
 
@@ -2677,7 +2666,16 @@ static int stmmac_open(struct net_device *dev)
 	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
 	priv->xstats.threshold = tc;
 
-	priv->dma_buf_sz = STMMAC_ALIGN(buf_sz);
+	bfsize = stmmac_set_16kib_bfsize(priv, dev->mtu);
+	if (bfsize < 0)
+		bfsize = 0;
+
+	if (bfsize < BUF_SIZE_16KiB)
+		bfsize = stmmac_set_bfsize(dev->mtu, priv->dma_buf_sz);
+
+	priv->dma_buf_sz = bfsize;
+	buf_sz = bfsize;
+
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	ret = alloc_dma_desc_resources(priv);
-- 
2.7.4

