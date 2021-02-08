Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91DA31349C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhBHOKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:10:25 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57244 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhBHOE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:04:29 -0500
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
Subject: [PATCH 04/20] net: stmmac: Assert reset control after MDIO de-registration
Date:   Mon, 8 Feb 2021 17:03:25 +0300
Message-ID: <20210208140341.9271-5-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140341.9271-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indeed it's unlikely but MDIO de-registration may still require an access
to the core registers, which obviously won't be possible in case if the
interface has been put into the reset state. So move the reset control
assertion to be executed after the MDIO bus is de-registered.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d45af1ea2565..1c40dc26fbf7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5159,10 +5159,10 @@ int stmmac_dvr_remove(struct device *dev)
 	stmmac_exit_fs(ndev);
 #endif
 	phylink_destroy(priv->phylink);
-	reset_control_assert(priv->plat->stmmac_rst);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
+	reset_control_assert(priv->plat->stmmac_rst);
 	destroy_workqueue(priv->wq);
 	mutex_destroy(&priv->lock);
 
-- 
2.29.2

