Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48043134D9
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhBHORw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:17:52 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57522 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhBHOIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:08:30 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/20] net: stmmac: Discard STMMAC_RESETING flag
Date:   Mon, 8 Feb 2021 17:03:36 +0300
Message-ID: <20210208140341.9271-16-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That flag is totally useless. It's set inside a non-reentrant
mutex-protected section. For the same reason the test-and-set loop is also
pointless. The flag is also unused anywhere else in the driver. So just
drop it.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      | 1 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e444b1b237c0..3e2bf7e2dafb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -248,7 +248,6 @@ struct stmmac_priv {
 enum stmmac_state {
 	STMMAC_DOWN,
 	STMMAC_RESET_REQUESTED,
-	STMMAC_RESETING,
 	STMMAC_SERVICE_SCHED,
 };
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index abe8db9965f4..16e08cfaadf0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4669,14 +4669,11 @@ static void stmmac_reset_subtask(struct stmmac_priv *priv)
 
 	rtnl_lock();
 	netif_trans_update(priv->dev);
-	while (test_and_set_bit(STMMAC_RESETING, &priv->state))
-		usleep_range(1000, 2000);
 
 	set_bit(STMMAC_DOWN, &priv->state);
 	dev_close(priv->dev);
 	dev_open(priv->dev, NULL);
 	clear_bit(STMMAC_DOWN, &priv->state);
-	clear_bit(STMMAC_RESETING, &priv->state);
 	rtnl_unlock();
 }
 
-- 
2.29.2

