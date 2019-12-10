Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA7511912B
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLJTzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:55:18 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:45166 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726647AbfLJTzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:55:01 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 97AA9C0BAA;
        Tue, 10 Dec 2019 19:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576007700; bh=Cfw3M7U5ViQkR09cH8IW6MQSpnx2YW5OmJD8GTUWfj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eV1RGKdFcT2wyJSSJMUdmUOprKeBNVWz4wosj6Pdq3911eIlpfkijdwPOwQXfc6Z6
         xnlPmg5AsvsZFHZ+gtrS/wpRfb5wArCh2XbhvDGTg3+k34jNiyLSOFr0chrcTS6byE
         pG85yOg0AGTUz77JaMcCN/ffyuBbL7aheJw6UBQrjEseZ0TW1efng4uLFIIB9pu2xb
         XQmw3JbWSpXoptJytpJnvj7pbRCmXXSWettZrYBeEE17zDurEdGLMVW2GiX/Y1uz/V
         8nLTiipzFIAcEdbtYRM9ZGZ2wdBYTkcAe6vz107sn0sQ7Mo+XZyjoNoxrV/gJSDVZq
         H2/asnIQzZoug==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 23C1CA009C;
        Tue, 10 Dec 2019 19:54:58 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: stmmac: Always arm TX Timer at end of transmission start
Date:   Tue, 10 Dec 2019 20:54:42 +0100
Message-Id: <1fb07301c129a858f82ab548fbadd8e1992de561.1576007149.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576007149.git.Jose.Abreu@synopsys.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If TX Coalesce timer is enabled we should always arm it, otherwise we
may hit the case where an interrupt is missed and the TX Queue will
timeout.

Arming the timer does not necessarly mean it will run the tx_clean()
because this function is wrapped around NAPI launcher.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 41d4188fc7bc..ae499fdd47bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3053,8 +3053,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -3125,6 +3123,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_q->tx_tail_addr = tx_q->dma_tx_phy + (tx_q->cur_tx * sizeof(*desc));
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
+	stmmac_tx_timer_arm(priv, queue);
 
 	return NETDEV_TX_OK;
 
@@ -3276,8 +3275,6 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	/* We've used all descriptors we need for this skb, however,
@@ -3366,6 +3363,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_q->tx_tail_addr = tx_q->dma_tx_phy + (tx_q->cur_tx * sizeof(*desc));
 	stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr, queue);
+	stmmac_tx_timer_arm(priv, queue);
 
 	return NETDEV_TX_OK;
 
-- 
2.7.4

