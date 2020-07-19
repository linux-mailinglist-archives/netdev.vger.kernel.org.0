Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE1022516E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 13:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgGSLAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 07:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGSLAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 07:00:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB21C0619D4;
        Sun, 19 Jul 2020 04:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5wxZ7XPuGRLP13+PHsbKXiQg3smDZA3oCeVscg/mtOc=; b=BgOHSUEbD2VW/MjqsE0epo3dBn
        5+XVyZT/3cbe/Pd1xgh5r7Gd497U3IW64n0FeDQnX/v2qcc087zb34nyWfWBzTthUAfIlj8sDFB5N
        02uFY2jgRJJXPPGiwRpHZEG4nBcAgdy27ztJhtVmxoaw2F6F3gPbZMevcQhOfJzihvtZoTreAPkWT
        X/mlN/9oIWf5lSTCOW932vkPTHRzUG6FsuENAnxmr+QHXvfAb+oHaKj+JTdl4pHB5qUg2PHmTbGPL
        YodaZYM7KuHmzOUZ2BDLnJYexTb06S64dv9FPHLVyuyYlvbNDG9LjjJVCLOO4/jAak8uBRjsguZ3p
        wLbK78Ig==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54114 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jx73c-0002CH-34; Sun, 19 Jul 2020 12:00:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jx73b-0006mh-Ox; Sun, 19 Jul 2020 12:00:35 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Rowe <martin.p.rowe@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Gregory Clement <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: fix in-band AN link establishment
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jx73b-0006mh-Ox@rmk-PC.armlinux.org.uk>
Date:   Sun, 19 Jul 2020 12:00:35 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If in-band negotiation or fixed-link modes are specified for a DSA
port, the DSA code will force the link down during initialisation. For
fixed-link mode, this is fine, as phylink will manage the link state.
However, for in-band mode, phylink expects the PCS to detect link,
which will not happen if the link is forced down.

There is a related issue that in in-band mode, the link could come up
while we are making configuration changes, so we should force the link
down prior to reconfiguring the interface mode.

This patch addresses both issues.

Fixes: 3be98b2d5fbc ("net: dsa: Down cpu/dsa ports phylink will control")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 +++++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0bce26f1df93..9c7b8cf0e39a 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -664,6 +664,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 const struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_port *p = &chip->ports[port];
 	int err;
 
 	/* FIXME: is this the correct test? If we're in fixed mode on an
@@ -675,10 +676,14 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
-	/* FIXME: should we force the link down here - but if we do, how
-	 * do we restore the link force/unforce state? The driver layering
-	 * gets in the way.
+	/* In inband mode, the link may come up at any time while the link
+	 * is not forced down. Force the link down while we reconfigure the
+	 * interface mode.
 	 */
+	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
+	    chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_FORCED_DOWN);
+
 	err = mv88e6xxx_port_config_interface(chip, port, state->interface);
 	if (err && err != -EOPNOTSUPP)
 		goto err_unlock;
@@ -691,6 +696,15 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	if (err > 0)
 		err = 0;
 
+	/* Undo the forced down state above after completing configuration
+	 * irrespective of its state on entry, which allows the link to come up.
+	 */
+	if (mode == MLO_AN_INBAND && p->interface != state->interface &&
+	    chip->info->ops->port_set_link)
+		chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);
+
+	p->interface = state->interface;
+
 err_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index f78536bdfe39..a8ef7edbb80b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -232,6 +232,7 @@ struct mv88e6xxx_port {
 	u64 atu_full_violation;
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
+	phy_interface_t interface;
 	u8 cmode;
 	bool mirror_ingress;
 	bool mirror_egress;
-- 
2.20.1

