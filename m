Return-Path: <netdev+bounces-5620-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EE8712457
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:15:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15912281771
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0447D156D7;
	Fri, 26 May 2023 10:14:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE37154B7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17B19E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=djvnifhvkv7qAufnKosk+gWEJUW9i+XXOBBka2xo+yo=; b=Uqecxvis8aZ/HgE72Q2sx8Ikqu
	bo8+zaE7aVY7ZesJMQfMxmlxn+U0Rggkkj0gse4H4MtT3P7kw4Aq2ibnU6usEGd65FqYfJ5wXOyzM
	FPltHldoQIdIu/dnrF0FWObE1bPCze9xHwqitHCYBNeIAG9SxBDFwKfk9G28QlZp01A875wIpSIIv
	MgSjvP/GAfIiqOCR5mGi5KwboZcrMlGJgLlDc32N1WH5HvCfe6rTLa0tJNkn7wPj8bf1+p1RGDFJ2
	gWVyLPn7E0ORDQAcnf59B2UHzIgrMTtQnveugghycMB6qNfz01VMsbbJZqbY7dg3OFEEMcBbR1d9w
	bOXtNhFg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36948 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2USx-0005PS-Br; Fri, 26 May 2023 11:14:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2USw-008PAa-Nl; Fri, 26 May 2023 11:14:34 +0100
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	 Maxime Chevallier <maxime.chevallier@bootlin.com>,
	 Simon Horman <simon.horman@corigine.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/6] net: stmmac: use xpcs_create_mdiodev()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2USw-008PAa-Nl@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 11:14:34 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the new xpcs_create_mdiodev() creator, which simplifies the
creation and destruction of the mdio device associated with xpcs.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 6807c4c1a0a2..3db1cb0fd160 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -491,7 +491,6 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 int stmmac_xpcs_setup(struct mii_bus *bus)
 {
 	struct net_device *ndev = bus->priv;
-	struct mdio_device *mdiodev;
 	struct stmmac_priv *priv;
 	struct dw_xpcs *xpcs;
 	int mode, addr;
@@ -501,16 +500,10 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 
 	/* Try to probe the XPCS by scanning all addresses. */
 	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
-		mdiodev = mdio_device_create(bus, addr);
-		if (IS_ERR(mdiodev))
+		xpcs = xpcs_create_mdiodev(bus, addr, mode);
+		if (IS_ERR(xpcs))
 			continue;
 
-		xpcs = xpcs_create(mdiodev, mode);
-		if (IS_ERR_OR_NULL(xpcs)) {
-			mdio_device_free(mdiodev);
-			continue;
-		}
-
 		priv->hw->xpcs = xpcs;
 		break;
 	}
@@ -669,10 +662,8 @@ int stmmac_mdio_unregister(struct net_device *ndev)
 	if (!priv->mii)
 		return 0;
 
-	if (priv->hw->xpcs) {
-		mdio_device_free(priv->hw->xpcs->mdiodev);
+	if (priv->hw->xpcs)
 		xpcs_destroy(priv->hw->xpcs);
-	}
 
 	mdiobus_unregister(priv->mii);
 	priv->mii->priv = NULL;
-- 
2.30.2


