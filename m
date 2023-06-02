Return-Path: <netdev+bounces-7426-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 629F07203D9
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1EA1128190B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F1C19531;
	Fri,  2 Jun 2023 13:58:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6B715BF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:58:45 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62AC71A7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Hf+GSt3vi2yDVYCHxuBJ5pfuLDjRBvRdTy+9bG9DOW4=; b=GY6uwqWxwW8pKvRy5TAtvuRQ+M
	t534IDyt2807yBulJPG1tSYZpGmJmB6YseFcmSfxD4+/2ZYBaQRI04Zyf0LRX38s1w63taZW71jqC
	uuWW7AG2igBSw43ra+qP3rIAeSxIk3MSXn0Nw8AIKh8SsHz4Y3ZFyG52u2+4H9tLHBNEbc9eSnMn2
	gG99PHjefqg9TCQS1EvYEIBC/dbAU4J5Je5NBBEiM7yQHLBTSURGhdEmk0ztgrDvwC/+IxuFVkU5H
	LZqlv3yCuiKGqLL511Mx9fHkQQdhV8vcJIzi1WEJJxEOXJV6VDgZGJHu6xgmGkBZ9srnqJUuCxddB
	GywCJzvQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36562 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q55Ie-00086g-TJ; Fri, 02 Jun 2023 14:58:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q55Ie-00Bp52-AA; Fri, 02 Jun 2023 14:58:40 +0100
In-Reply-To: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: use xpcs_create_mdiodev()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q55Ie-00Bp52-AA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 02 Jun 2023 14:58:40 +0100
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
 drivers/net/dsa/sja1105/sja1105_mdio.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 166fe747f70a..833e55e4b961 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -400,7 +400,6 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 	}
 
 	for (port = 0; port < ds->num_ports; port++) {
-		struct mdio_device *mdiodev;
 		struct dw_xpcs *xpcs;
 
 		if (dsa_is_unused_port(ds, port))
@@ -410,14 +409,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		    priv->phy_mode[port] != PHY_INTERFACE_MODE_2500BASEX)
 			continue;
 
-		mdiodev = mdio_device_create(bus, port);
-		if (IS_ERR(mdiodev)) {
-			rc = PTR_ERR(mdiodev);
-			goto out_pcs_free;
-		}
-
-		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
-		mdio_device_put(mdiodev);
+		xpcs = xpcs_create_mdiodev(bus, port, priv->phy_mode[port]);
 		if (IS_ERR(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
-- 
2.30.2


