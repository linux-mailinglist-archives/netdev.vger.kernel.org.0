Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8713134FF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhBHOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:22:15 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57762 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhBHOKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:08 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/16] net: stmmac: Convert STMMAC_DOWN flag to STMMAC_UP
Date:   Mon, 8 Feb 2021 17:08:14 +0300
Message-ID: <20210208140820.10410-11-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flag name and semantics are misleading. Judging by the code the flag
will be set only if the networking is requested for being reset, while
logically in order to correctly reflect the device state the flag needs to
be also set when the network device isn't opened. Let's convert the flag
to having a positive meaning instead of keeping it being set all the time
the interface is down.

This modification will be also helpful for the case of the IRQs request
being performed in the device probe method. So the driver could
enable/disable the network-related IRQs handlers by synchronous flag
switching together with the IRQs unmasking and masking. Luckily the IRQs
are normally enabled/disable in the late/early network initialization
stages respectively.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index d88bc8af8eaa..ab8b1e04ed22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -246,7 +246,7 @@ struct stmmac_priv {
 };
 
 enum stmmac_state {
-	STMMAC_DOWN,
+	STMMAC_UP,
 	STMMAC_RESET_REQUESTED,
 };
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fcd59a647b02..f458d728825c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4151,6 +4151,8 @@ static void stmmac_enable_irq(struct stmmac_priv *priv)
 
 	stmmac_enable_mac_irq(priv, priv->hw);
 
+	set_bit(STMMAC_UP, &priv->state);
+
 	enable_irq(priv->dev->irq);
 }
 
@@ -4165,6 +4167,8 @@ static void stmmac_disable_irq(struct stmmac_priv *priv)
 
 	disable_irq(priv->dev->irq);
 
+	clear_bit(STMMAC_UP, &priv->state);
+
 	stmmac_disable_mac_irq(priv, priv->hw);
 
 	maxq = max(priv->plat->rx_queues_to_use, priv->plat->tx_queues_to_use);
@@ -4213,7 +4217,7 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 		pm_wakeup_event(priv->device, 0);
 
 	/* Check if adapter is up */
-	if (test_bit(STMMAC_DOWN, &priv->state))
+	if (!test_bit(STMMAC_UP, &priv->state))
 		return IRQ_HANDLED;
 	/* Check if a fatal error happened */
 	if (stmmac_safety_feat_interrupt(priv))
@@ -4739,7 +4743,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
 {
-	if (test_bit(STMMAC_DOWN, &priv->state))
+	if (!test_bit(STMMAC_UP, &priv->state))
 		return;
 
 	netdev_err(priv->dev, "Reset adapter.\n");
@@ -4747,10 +4751,8 @@ static void stmmac_reset_subtask(struct stmmac_priv *priv)
 	rtnl_lock();
 	netif_trans_update(priv->dev);
 
-	set_bit(STMMAC_DOWN, &priv->state);
 	dev_close(priv->dev);
 	dev_open(priv->dev, NULL);
-	clear_bit(STMMAC_DOWN, &priv->state);
 	rtnl_unlock();
 }
 
-- 
2.29.2

