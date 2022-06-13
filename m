Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E125549A06
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbiFMRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241948AbiFMRbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:31:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1776C13C370
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WG4w83Pv5w8egIL1YDxdHhKJvMPuPB/1HCTC+pbafMQ=; b=AdGBoHktZXonUmmO82bxW9thYy
        OKdRAAgEQocy8hbTnuJi2sMpuy6C5VvlxRinhM8EpgLJer38rjdPg6VUcDl8L3j225+VKi5LyYTgw
        njHCj7CyJ5oFU/zXwNsM2p2oe1J0x+NN1vqJ7a77fNTDuIuO8WFCsO0ZSi9npkixUMzUREc3+g+SX
        fuR1YNasuDyMchHCQ1PKJL7s5yCMF0L7qYhk5nFsaR+KabGi/iUmh76lup8DrFeZ+NkavIzIWJjHt
        Y9/N6pg0Cz6jM9iXHP/EJmElaaIuNupx+i2vXZFOTmxGPQvEB28Le3CXvgOmm6lKuztu+O+fUk38m
        Mp+f/0GQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52094 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgp-0001s9-Io; Mon, 13 Jun 2022 14:01:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgo-000JYz-VN; Mon, 13 Jun 2022 14:01:07 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 09/15] net: dsa: mv88e6xxx: move link forcing to
 mac_prepare/mac_finish
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgo-000JYz-VN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:06 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the link forcing out of mac_config() and into the mac_prepare()
and mac_finish() methods. This results in no change to the order in
which these operations are performed, but does mean when we convert
mv88e6xxx to phylink_pcs support, we will continue to preserve this
ordering.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 65 ++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0b49d243e00b..40de1db2f190 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -834,29 +834,38 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
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
@@ -873,24 +882,38 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
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
@@ -6838,7 +6861,9 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
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

