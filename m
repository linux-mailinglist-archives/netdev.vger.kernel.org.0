Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065BA393318
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 18:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhE0QDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbhE0QDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 12:03:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A084C061761
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 09:01:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id z12so1014780ejw.0
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHhzfRQXzDq/fjqjxqJGaKxK822kNsPHNNGG7dQUR1c=;
        b=LZ6rLqYmA9kE4znGAjpzghtkyKUEMxMrJ9QqhQG2+CwkGnNamsMOYjJzhstGLOPdHg
         G5jtuqSIXYHT81ITOkt2OW93H51JbYREVyaZckU6B9df5R3ICSKNL44JbNmHjjsVPYfw
         wmlWT3KSTrd3f0yjR7C61v4fEe2WhGh9kLABgn5O7ax8abXlRqFb1F3tfZ0GQNveajVz
         L7vjoWuldgG5GcFqaUwwrwBOPuqpCKJ//+41wpJCIUiaKtRCA8QgZqTSiyTRCxNT+tme
         9c102z8SHKsSLSJ9lQNmI0E5uIxRJ7/4XLZ7HfN1EbAcMbcbiV1dIiJRLkcLtW52sSKO
         B5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MHhzfRQXzDq/fjqjxqJGaKxK822kNsPHNNGG7dQUR1c=;
        b=aNt8QTxhhl9Onz06XVvvZOlDeNJXr5mhzbPLNsu3CozUXKGchd1Vihi45wTVP+HT7L
         DYpREsH3EZ3lvbYgfYrGjzMj009dCnPcBxiZiLYhlJxq7qCNM5tw9ik21kUjZxbj02J+
         M9i8ND9P5965NKH4nKgt0n3+6/I15mSbv8ZepaeOgmhTB/8rBZgsyTHCjD9Jt//EQa7/
         tPkIvARy1Vg1wqd/ydJJnxutv9G8AbI13S4YSrpNVySkkv9bcwREuXDbrHk2vKyLCKzO
         FpcvU88SsTEtWCHKVUPCROeMOOSzudlv9bc9M2+bdVlPvaH5XdknZ1f7Q/UP/5lUkewk
         0abw==
X-Gm-Message-State: AOAM532U2xLJyzGOW/Atcy4mwTDc11lq9O8cYxtFBxh7BptUAReKfMGC
        jRPvsgNj49f5+CPtYTBRL90=
X-Google-Smtp-Source: ABdhPJzlsSfE7k0AyZ9RcYM2AqyolYt8MFgNRJB8AOqHDsinKNX+jgKziIZ7jY8CxpxepxNRl9d58w==
X-Received: by 2002:a17:906:aec6:: with SMTP id me6mr4608279ejb.522.1622131293047;
        Thu, 27 May 2021 09:01:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id u6sm1201092ejr.55.2021.05.27.09.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:01:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: stmmac: the XPCS obscures a potential "PHY not found" error
Date:   Thu, 27 May 2021 18:59:59 +0300
Message-Id: <20210527155959.3270478-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

stmmac_mdio_register() has logic to search for PHYs on the MDIO bus and
assign them IRQ lines, as well as to set priv->plat->phy_addr.

If no PHY is found, the "found" variable remains set to 0 and the
function errors out.

After the introduction of commit f213bbe8a9d6 ("net: stmmac: Integrate
it with DesignWare XPCS"), the "found" variable was immediately reused
for searching for a PCS on the same MDIO bus.

This can result in 2 types of potential problems (none of them seems to
be seen on the only Intel system that sets has_xpcs = true, otherwise it
would have been reported):

1. If a PCS is found but a PHY is not, then the code happily exits with
   no error. One might say "yes, but this is not possible, because
   of_mdiobus_register will probe a PHY for all MDIO addresses,
   including for the XPCS, so if an XPCS exists, then a PHY certainly
   exists too". Well, that is not true, see intel_mgbe_common_data():

	/* Ensure mdio bus scan skips intel serdes and pcs-xpcs */
	plat->mdio_bus_data->phy_mask = 1 << INTEL_MGBE_ADHOC_ADDR;
	plat->mdio_bus_data->phy_mask |= 1 << INTEL_MGBE_XPCS_ADDR;

2. A PHY is found but an MDIO device with the XPCS PHY ID isn't, and in
   that case, the error message will be "No PHY found". Confusing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index b750074f8f9c..e293bf1ce9f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -503,6 +503,12 @@ int stmmac_mdio_register(struct net_device *ndev)
 		found = 1;
 	}
 
+	if (!found && !mdio_node) {
+		dev_warn(dev, "No PHY found\n");
+		err = -ENODEV;
+		goto no_phy_found;
+	}
+
 	/* Try to probe the XPCS by scanning all addresses. */
 	if (priv->hw->xpcs) {
 		struct mdio_xpcs_args *xpcs = &priv->hw->xpcs_args;
@@ -511,6 +517,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 		xpcs->bus = new_bus;
 
+		found = 0;
 		for (addr = 0; addr < max_addr; addr++) {
 			xpcs->addr = addr;
 
@@ -520,13 +527,12 @@ int stmmac_mdio_register(struct net_device *ndev)
 				break;
 			}
 		}
-	}
 
-	if (!found && !mdio_node) {
-		dev_warn(dev, "No PHY found\n");
-		mdiobus_unregister(new_bus);
-		mdiobus_free(new_bus);
-		return -ENODEV;
+		if (!found && !mdio_node) {
+			dev_warn(dev, "No XPCS found\n");
+			err = -ENODEV;
+			goto no_xpcs_found;
+		}
 	}
 
 bus_register_done:
@@ -534,6 +540,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 
 	return 0;
 
+no_xpcs_found:
+no_phy_found:
+	mdiobus_unregister(new_bus);
 bus_register_fail:
 	mdiobus_free(new_bus);
 	return err;
-- 
2.25.1

