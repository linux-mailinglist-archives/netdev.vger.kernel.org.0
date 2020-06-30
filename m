Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED78620F2AE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbgF3K2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732315AbgF3K2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:28:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4FCC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HkcurbYwZxa0d2roGqU6sgCAOKesAKavmFLJe59CeSA=; b=jrGBX3L7Tkdip7+pAHtbvK6WZ3
        kHJ5Ktn0GPD9g4u1w9sXMEurbz+iHmBjTYbpDg6/gpdbr7RzWjuXNykHQiFvFWvlihXaEbMVbvIEf
        wEqlL1k2JokoVLLkDoI0c88GeniRTQRx8SBB5Y1CF9rO7LwrPgSQLxQr8n+cACNUXaC1bUpCwd2tc
        Mp8ITPvPE9tNEBZqfCcxSREODG8pETDqytzmTaVkIgPw0yuGkQA1BWDPHHy9UzHNF7C1a0w0aeK36
        fBbo0H+Qd4hvEOJajfKgurQAtqZgOeYy1vLxETnsw6RseTP/30rtMOIObYzr0ai+c5QSq+7YtHDHz
        ZAviKWFw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45952 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUm-0000PS-H7; Tue, 30 Jun 2020 11:28:08 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqDUm-0004tx-AN; Tue, 30 Jun 2020 11:28:08 +0100
In-Reply-To: <20200630102751.GA1551@shell.armlinux.org.uk>
References: <20200630102751.GA1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] net: dsa/bcm_sf2: fix incorrect usage of
 state->link
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqDUm-0004tx-AN@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 11:28:08 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

state->link has never been valid in mac_config() implementations -
while it may be correct in some calls, it is not true that it can be
relied upon.

Fix bcm_sf2 to use the correct method of handling forced link status.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 946e41f020a5..5a8759d2de6c 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -618,8 +618,6 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		break;
 	}
 
-	if (state->link)
-		reg |= LINK_STS;
 	if (state->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
 
@@ -650,6 +648,20 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 				     unsigned int mode,
 				     phy_interface_t interface)
 {
+	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
+	u32 reg, offset;
+
+	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
+		if (priv->type == BCM7445_DEVICE_ID)
+			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
+		else
+			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
+
+		reg = core_readl(priv, offset);
+		reg &= ~LINK_STS;
+		core_writel(priv, reg, offset);
+	}
+
 	bcm_sf2_sw_mac_link_set(ds, port, interface, false);
 }
 
@@ -662,9 +674,21 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
+	u32 reg, offset;
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
+	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
+		if (priv->type == BCM7445_DEVICE_ID)
+			offset = CORE_STS_OVERRIDE_GMIIP_PORT(port);
+		else
+			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
+
+		reg = core_readl(priv, offset);
+		reg |= LINK_STS;
+		core_writel(priv, reg, offset);
+	}
+
 	if (mode == MLO_AN_PHY && phydev)
 		p->eee_enabled = b53_eee_init(ds, port, phydev);
 }
-- 
2.20.1

