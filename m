Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77335122A73
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbfLQLnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:43:10 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:36550 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727452AbfLQLmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:42:54 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3733DC00A2;
        Tue, 17 Dec 2019 11:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576582973; bh=n+vS8YMLmx+EJMN5UhCjU7DGPOtft/OYuRFINpWV958=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CDVNNarvUr6Ro9cQFdpyM/uvlTmMerdaWFGytVMBTelXG2cd6YK1w6IKXeK2mp4vT
         zJto7BN4dBbJ3Y414gYIrwk9Dt29DDa9rombUUQZLzBiEDVoKa3cOBWKxcypNRmE98
         4RWLJW/+euT+Zwq6FzPT44U42L6mRMxY/p1P7WCHxNU7A1x8kvPrvaJA1kD6RMPf6i
         M9MLEOBl8079IMW4bNA23L4ieAtLZzBP00y2suOUR+6bKic13yy54qTrDvybfGw5pe
         8iBsDnslQlPYjx8QIHzUZzSipb85PA8RKV/S0wr9qhlmMaQIBxE4dwlaRBXTWmPC1w
         Rr9d0WxqX//TQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id DC79FA0091;
        Tue, 17 Dec 2019 11:42:50 +0000 (UTC)
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
Subject: [PATCH net v2 3/8] net: stmmac: Do not accept invalid MTU values
Date:   Tue, 17 Dec 2019 12:42:33 +0100
Message-Id: <e53f2836e1ae054ee554bc9a230afb2376480327.1576581853.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576581853.git.Jose.Abreu@synopsys.com>
References: <cover.1576581853.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The maximum MTU value is determined by the maximum size of TX FIFO so
that a full packet can fit in the FIFO. Add a check for this in the MTU
change callback.

Also check if provided and rounded MTU does not passes the maximum limit
of 16K.

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index dfecced43f29..2ebac89049ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3827,12 +3827,22 @@ static void stmmac_set_rx_mode(struct net_device *dev)
 static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	int txfifosz = priv->plat->tx_fifo_size;
+
+	if (txfifosz == 0)
+		txfifosz = priv->dma_cap.tx_fifo_size;
+
+	txfifosz /= priv->plat->tx_queues_to_use;
 
 	if (netif_running(dev)) {
 		netdev_err(priv->dev, "must be stopped to change its MTU\n");
 		return -EBUSY;
 	}
 
+	/* If condition true, FIFO is too small or MTU too large */
+	if ((txfifosz < new_mtu) || (new_mtu > STMMAC_ALIGN(BUF_SIZE_16KiB)))
+		return -EINVAL;
+
 	dev->mtu = new_mtu;
 
 	netdev_update_features(dev);
-- 
2.7.4

