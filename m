Return-Path: <netdev+bounces-5295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81722710A3C
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 438681C20EF2
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC1AD512;
	Thu, 25 May 2023 10:38:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C93E56C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:38:55 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5072310B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o2LiBgBK3MX7dmCCGCE4CMXZ3je8AGBwsmRwwgHqfzc=; b=o+Jxt0GmZw7UXe2JC896iAjrKT
	yoiraoV1IJ2UNHTl6nwJM17cLFHgeIOaCTqg7qTNa1+zuWAwl97fHeWk+wBWMyUo75kHB9/Zm+aMe
	PjfSqqP7Ut3fFLLUPWI3+U2K8IQxy2WwcKJPMdNByo80bmDE4O4opPcFe3oJ2X4qXOJGOq5E4HcVi
	+n0gift8PUE96lEF3gd3SRlF3ltL9YDGyGnx4JtOIfi72s1hzzDK/O73sfmpbrXiFZJUh4bg4GCar
	EVjSOelRV02XMAGnYrrWMyb0GiJSvI9PYtrGUmolegFqz70nevnFn41Wed2ooFlTx1TI1kD6qwJqc
	HVV++0Lg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:50068 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q28Ms-0003wO-Ln; Thu, 25 May 2023 11:38:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q28Ms-007tpv-2T; Thu, 25 May 2023 11:38:50 +0100
In-Reply-To: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
References: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: move link forcing to
 mac_prepare/mac_finish
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q28Ms-007tpv-2T@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Thu, 25 May 2023 11:38:50 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Move the link forcing out of mac_config() and into the mac_prepare()
and mac_finish() methods. This results in no change to the order in
which these operations are performed, but does mean when we convert
mv88e6xxx to phylink_pcs support, we will continue to preserve this
ordering.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 65 ++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64a2f2f83735..5bbe95fa951c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -841,29 +841,38 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static int mv88e6xxx_mac_prepare(struct dsa_switch *ds, int port,
+				 unsigned int mode, phy_interface_t interface)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = 0;
+
+	/* In inband mode, the link may come up at any time while the link
+	 * is not forced down. Force the link down while we reconfigure the
+	 * interface mode.
+	 */
+	if (mode == MLO_AN_INBAND &&
+	    chip->ports[port].interface != interface &&
+	    chip->info->ops->port_set_link) {
+		mv88e6xxx_reg_lock(chip);
+		err = chip->info->ops->port_set_link(chip, port,
+						     LINK_FORCED_DOWN);
+		mv88e6xxx_reg_unlock(chip);
+	}
+
+	return err;
+}
+
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 unsigned int mode,
 				 const struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	struct mv88e6xxx_port *p;
 	int err = 0;
 
-	p = &chip->ports[port];
-
 	mv88e6xxx_reg_lock(chip);
 
 	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
-		/* In inband mode, the link may come up at any time while the
-		 * link is not forced down. Force the link down while we
-		 * reconfigure the interface mode.
-		 */
-		if (mode == MLO_AN_INBAND &&
-		    p->interface != state->interface &&
-		    chip->info->ops->port_set_link)
-			chip->info->ops->port_set_link(chip, port,
-						       LINK_FORCED_DOWN);
-
 		err = mv88e6xxx_port_config_interface(chip, port,
 						      state->interface);
 		if (err && err != -EOPNOTSUPP)
@@ -880,24 +889,38 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 			err = 0;
 	}
 
+err_unlock:
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err && err != -EOPNOTSUPP)
+		dev_err(ds->dev, "p%d: failed to configure MAC/PCS\n", port);
+}
+
+static int mv88e6xxx_mac_finish(struct dsa_switch *ds, int port,
+				unsigned int mode, phy_interface_t interface)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err = 0;
+
 	/* Undo the forced down state above after completing configuration
 	 * irrespective of its state on entry, which allows the link to come
 	 * up in the in-band case where there is no separate SERDES. Also
 	 * ensure that the link can come up if the PPU is in use and we are
 	 * in PHY mode (we treat the PPU as an effective in-band mechanism.)
 	 */
+	mv88e6xxx_reg_lock(chip);
+
 	if (chip->info->ops->port_set_link &&
-	    ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
+	    ((mode == MLO_AN_INBAND &&
+	      chip->ports[port].interface != interface) ||
 	     (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
-		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
+		err = chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
 
-	p->interface = state->interface;
-
-err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
-	if (err && err != -EOPNOTSUPP)
-		dev_err(ds->dev, "p%d: failed to configure MAC/PCS\n", port);
+	chip->ports[port].interface = interface;
+
+	return err;
 }
 
 static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
@@ -7002,7 +7025,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
+	.phylink_mac_prepare	= mv88e6xxx_mac_prepare,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
+	.phylink_mac_finish	= mv88e6xxx_mac_finish,
 	.phylink_mac_an_restart	= mv88e6xxx_serdes_pcs_an_restart,
 	.phylink_mac_link_down	= mv88e6xxx_mac_link_down,
 	.phylink_mac_link_up	= mv88e6xxx_mac_link_up,
-- 
2.30.2


