Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1595D549A05
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiFMRby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243561AbiFMRaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:30:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE73313C4E3
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LHhcc1y+kLM/Yjh6WGWauOTDF47qM9hMsY8usxSDJjg=; b=IyzNu9KN7gDkkZAhyNDyjdtgSa
        VfyyPF/QTydYXkfXPp7kiEFCotFvvkUUTiCNJmdnh8Jxe2NLJspFz865JemUMobbIwBCOVI8SXTgO
        9WCHVh0a8VGBJviXeTcjMqkRFshxFaFp0tf1zk4ww4sHL6rlrT9BRjd3hu2wyF65mdBP/+BJqRtyZ
        aL+Pw0kAMtb1SNcdXRjCYV3Vin9Gdq9zUHOIE+Q9jhmTmUImz6lpo4Nrcw2a7VWZNEo6MM0QjI7zV
        uzzsB3zc4bUYALBanBKoktqk31Yk8Tr/z/w2BJiJvBempIbR2YRlI3ZecenP/2NkIeSfn5Tv2TJPB
        YQHWcHkg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52096 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgu-0001sN-Mv; Mon, 13 Jun 2022 14:01:12 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgu-000JZ5-3S; Mon, 13 Jun 2022 14:01:12 +0100
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
Subject: [PATCH net-next 10/15] net: dsa: mv88e6xxx: add infrastructure for
 phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgu-000JZ5-3S@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:12 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add infrastructure for phylink_pcs to the mv88e6xxx driver. This
involves adding a mac_select_pcs() hook so we can pass the PCS to
phylink at the appropriate time, and a PCS initialisation function.

As the various chip implementations are converted to use phylink_pcs,
they are no longer reliant on the legacy phylink behaviour. We detect
this by the use of this infrastructure, or the lack of any serdes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 46 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  6 +++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 40de1db2f190..8f379a97ef55 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -832,6 +832,37 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	if (mv88e6xxx_phy_is_internal(ds, port))
 		__set_bit(PHY_INTERFACE_MODE_GMII,
 			  config->supported_interfaces);
+
+	/* If we have a .pcs_init, or don't have a .serdes_pcs_get_state,
+	 * serdes_pcs_config, serdes_pcs_an_restart, or serdes_pcs_link_up,
+	 * we are not legacy.
+	 */
+	if (chip->info->ops->pcs_init ||
+	    (!chip->info->ops->serdes_pcs_get_state &&
+	     !chip->info->ops->serdes_pcs_config &&
+	     !chip->info->ops->serdes_pcs_an_restart &&
+	     !chip->info->ops->serdes_pcs_link_up))
+		config->legacy_pre_march2020 = false;
+}
+
+static struct phylink_pcs *mv88e6xxx_pcs_select(struct mv88e6xxx_chip *chip,
+						int port,
+						phy_interface_t interface)
+{
+	return chip->ports[port].pcs_private;
+}
+
+static struct phylink_pcs *__maybe_unused
+mv88e6xxx_mac_select_pcs(struct dsa_switch *ds, int port,
+			 phy_interface_t interface)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct phylink_pcs *pcs = NULL;
+
+	if (chip->info->ops->pcs_select)
+		pcs = chip->info->ops->pcs_select(chip, port, interface);
+
+	return pcs;
 }
 
 static int mv88e6xxx_mac_prepare(struct dsa_switch *ds, int port,
@@ -3832,12 +3863,26 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 static int mv88e6xxx_port_setup(struct dsa_switch *ds, int port)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	if (chip->info->ops->pcs_init) {
+		err = chip->info->ops->pcs_init(chip, port);
+		if (err)
+			return err;
+	}
+
 	return mv88e6xxx_setup_devlink_regions_port(ds, port);
 }
 
 static void mv88e6xxx_port_teardown(struct dsa_switch *ds, int port)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+
 	mv88e6xxx_teardown_devlink_regions_port(ds, port);
+
+	if (chip->info->ops->pcs_teardown)
+		chip->info->ops->pcs_teardown(chip, port);
 }
 
 /* prod_id for switch families which do not have a PHY model number */
@@ -6860,6 +6905,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_setup		= mv88e6xxx_port_setup,
 	.port_teardown		= mv88e6xxx_port_teardown,
 	.phylink_get_caps	= mv88e6xxx_get_caps,
+	.phylink_mac_select_pcs	= mv88e6xxx_mac_select_pcs,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_prepare	= mv88e6xxx_mac_prepare,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 5e03cfe50156..55e1baa614af 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -280,6 +280,7 @@ struct mv88e6xxx_port {
 	unsigned int serdes_irq;
 	char serdes_irq_name[64];
 	struct devlink_region *region;
+	void *pcs_private;
 };
 
 enum mv88e6xxx_region_id {
@@ -579,6 +580,11 @@ struct mv88e6xxx_ops {
 	/* SERDES lane mapping */
 	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
 
+	int (*pcs_init)(struct mv88e6xxx_chip *chip, int port);
+	void (*pcs_teardown)(struct mv88e6xxx_chip *chip, int port);
+	struct phylink_pcs *(*pcs_select)(struct mv88e6xxx_chip *chip, int port,
+					  phy_interface_t mode);
+
 	int (*serdes_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
 				    int lane, struct phylink_link_state *state);
 	int (*serdes_pcs_config)(struct mv88e6xxx_chip *chip, int port,
-- 
2.30.2

