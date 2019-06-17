Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0639E483A1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFQNN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:13:56 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:45927 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:13:55 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MNOZO-1i0ZUq1BHO-00OktR; Mon, 17 Jun 2019 15:13:34 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Joao Pinto <jpinto@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: fix unused-variable warning
Date:   Mon, 17 Jun 2019 15:13:03 +0200
Message-Id: <20190617131327.2227754-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3iQswqHwy9CHF3y1gp7c7xlBW7MRNJ6Fv/0O9bUwjPHV/LWGdIh
 Sg9soT5vhpPfNJhxJsqwCgkwuTEe0AEIYCVllZ3t2UQIugkzeIa/1LuEaIZUloY3QurmxNh
 gczDmibxxnKXOGvclLvdFNkq77keyFmY3/wMG0JJpWlQyapLFJEW43ks+VIlxcOEDqSZwS3
 OARaUsIkb9o2x/pv8mmcw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3iQy2mN8gLw=:a/aWCEZLxeIcdIwAmPzzUe
 xGLtrdS/+m+HkJbvQmw4YCcKRq+jjVA4Wtn+HPWhql6rNXFI2OSAEXwdCkt4iIvUgoATCu+57
 GS0GebKolVJMtTG0QEJlFFsIjyGO8m59rwwITRlcQggasDrAK8+rvAmkj0zXDQxH5nOcB/2WQ
 G9c81RQTG3axlhsfWamWceqs0YzM6AfyfS3NtMZWZ3xgTJhILdLuladwA70p/S8/0BnTTu3sS
 KgBZQkXn8EU9dMZSuJhwKGITr+O3U2A0GJnFezlKJmwLcpxABgMy2XseUoS8lYpD+HStwu7MN
 v5Lok7Nv1fo/vD0OPBH7p0XLNlDiRb1rfN2ouloulgNBCsKnL1A9bJ7n6UpOo1exVphGK8Tif
 hYs9W9CfOJzSMWLFoQd0w0JnNBjPYpaoLYfaQRueJ/d42aHeDlXu2KS4QfKp2aOaCDW2nGk42
 CFtLQrArAaoKywY3KbXVgonhi/2dFRFUch79pGpZBX+eX4KT4Qv7sLcRKGltK3ZYuIrvYIC6o
 4SMRIX3QMKVrsFsdr2IW+8d7+BwLB51x/8nuP82jiswqd2ExGYd0lujY7KUV5oRMDq3y/hipa
 jmjMn/gFYzIcsNHaLFxdR3Pi5aP/QyWpVbZW8FWNTZXLu8QxuM21jnQBn+UAns6Q8ZT5GRUgK
 PMho0FQJnlISs1mGsxCqrIbfXVdpNqvbxqe46DKNwVH93SXxuPwMlpfFho+kgiQ8xftV+c7+/
 PlChMgjnn4hc9Nlo2a5n9L+84eTAkFLeiaSmdA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building without CONFIG_OF, we get a harmless build warning:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function 'stmmac_phy_setup':
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:973:22: error: unused variable 'node' [-Werror=unused-variable]
  struct device_node *node = priv->plat->phy_node;

Reword it so we always use the local variable, by making it the
fwnode pointer instead of the device_node.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4ca46289a742..a48751989fa6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -970,14 +970,14 @@ static int stmmac_init_phy(struct net_device *dev)
 
 static int stmmac_phy_setup(struct stmmac_priv *priv)
 {
-	struct device_node *node = priv->plat->phylink_node;
+	struct fwnode_handle *fwnode = of_fwnode_handle(priv->plat->phylink_node);
 	int mode = priv->plat->interface;
 	struct phylink *phylink;
 
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 
-	phylink = phylink_create(&priv->phylink_config, of_fwnode_handle(node),
+	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
 	if (IS_ERR(phylink))
 		return PTR_ERR(phylink);
-- 
2.20.0

