Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D3A4C4417
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiBYMAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240371AbiBYMAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:00:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D8D27026F
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 04:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OqJBARfNAcBLTrX9FYKeYmqf8/5ESJhWwa6gF0nAmzI=; b=p5VBzcTkFATt+jqxnt9JxMuagS
        GQLl+9K2AdRmjN5LFcZ5SmpQeeqaM3bL3eyEVo1dib3HNyLyLGsNWHpPy4pRI71vTR79JvpImPLd0
        XaWYyjWviXSP/rd7g/lpLj0fUDTr5nI/LxuAdsMTSlBA/oBeh9Pl8mN534xFEmKgOYXLjeQk/OE7D
        lmejoJ3qrV4fr/NLL9P66vn2EkQNiiBAyhXbcnnoe4qDxLnjNGR4TVT+bKuvKomSiCoGX8MbRAZ5a
        MVfN/DZ645iPSsX8ncHxuB2rWfGPz7oUyj31IUf9nHb2/JJEeM6GVv+mp5j/iorybIFXwivW0zbkv
        fWPHcGLg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46078 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNZGe-0005JB-SF; Fri, 25 Feb 2022 12:00:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNZGe-00AbGt-9n; Fri, 25 Feb 2022 12:00:12 +0000
In-Reply-To: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
References: <YhjEm/Vu+w1XQpGT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/6] net: dsa: sja1105: use .mac_select_pcs()
 interface
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNZGe-00AbGt-9n@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 12:00:12 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the PCS selection to use mac_select_pcs, which allows the PCS
to perform any validation it needs, and removes the need to set the PCS
in the mac_config() callback, delving into the higher DSA levels to do
so.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e278bd86e3c6..b5c36f808df1 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1358,18 +1358,16 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	return sja1105_clocking_setup_port(priv, port);
 }
 
-static void sja1105_mac_config(struct dsa_switch *ds, int port,
-			       unsigned int mode,
-			       const struct phylink_link_state *state)
+static struct phylink_pcs *
+sja1105_mac_select_pcs(struct dsa_switch *ds, int port, phy_interface_t iface)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct sja1105_private *priv = ds->priv;
-	struct dw_xpcs *xpcs;
-
-	xpcs = priv->xpcs[port];
+	struct dw_xpcs *xpcs = priv->xpcs[port];
 
 	if (xpcs)
-		phylink_set_pcs(dp->pl, &xpcs->pcs);
+		return &xpcs->pcs;
+
+	return NULL;
 }
 
 static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
@@ -3137,7 +3135,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_max_mtu		= sja1105_get_max_mtu,
 	.phylink_get_caps	= sja1105_phylink_get_caps,
 	.phylink_validate	= sja1105_phylink_validate,
-	.phylink_mac_config	= sja1105_mac_config,
+	.phylink_mac_select_pcs	= sja1105_mac_select_pcs,
 	.phylink_mac_link_up	= sja1105_mac_link_up,
 	.phylink_mac_link_down	= sja1105_mac_link_down,
 	.get_strings		= sja1105_get_strings,
-- 
2.30.2

