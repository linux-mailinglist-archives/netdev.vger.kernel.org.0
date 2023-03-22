Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE956C49CB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCVMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCVMAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DF3570B0;
        Wed, 22 Mar 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P/qDIKEXByHY2/N3TKS7+nB/0HfKOu7KPqR9nLtkfwE=; b=eDF75J5J8rXizfk3r2+FDs3dOa
        35Mmj9z1ZUBXXoKN46KAXYg4dU1BeI/nDOhxYUmxQxRol7BbnVOhTGmY/Z5qH8QI540kjOBwfAwlZ
        MaGz4YrU8bw3hSn4LRSQdnlA6yTuBflUs8phNy0TV3Afv9nLD8KWXeS86OUmGbEUQkoULypZcnW2+
        UZzJ+GoxwBOu4kaER3zm5mRJXlvGQH809xy8nY4xGxh0+2a7Y8vPHkfWQCHmai35eBi9HTSEh8rSJ
        zALShRUX541MexaRUzESybEvd09uvvVrT9RMrsSzs+kzQcoCJpUSidoSLp7xDUVy/nHPvRirClQD7
        OrTXx+qw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60880 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8Q-00035i-SG; Wed, 22 Mar 2023 12:00:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8Q-00Dvnr-5y; Wed, 22 Mar 2023 12:00:06 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to get
 phy interface mode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 12:00:06 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting the use of software nodes to setup
phylink, switch DSA to use fwnode_get_phy_mode() to retrieve the
phy interface mode, rather than using of_get_phy_mode() which is
DT specific.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 67ad1adec2a2..07f9cb374a5d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1678,13 +1678,9 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
+	struct fwnode_handle *fwnode;
 	struct phylink *pl;
-	int err;
-
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err)
-		mode = PHY_INTERFACE_MODE_NA;
+	int mode;
 
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
 	 * an indicator of a legacy phylink driver.
@@ -1696,8 +1692,14 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (ds->ops->phylink_get_caps)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
-	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
-			    mode, &dsa_port_phylink_mac_ops);
+	fwnode = of_fwnode_handle(dp->dn);
+
+	mode = fwnode_get_phy_mode(fwnode);
+	if (mode < 0)
+		mode = PHY_INTERFACE_MODE_NA;
+
+	pl = phylink_create(&dp->pl_config, fwnode, mode,
+			    &dsa_port_phylink_mac_ops);
 	if (IS_ERR(pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
 		return PTR_ERR(pl);
-- 
2.30.2

