Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BF945CB6A
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349897AbhKXRzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhKXRzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:55:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23989C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gXb5GRSK5/bRvPawHv8QHpyGKu/zGMTCpGs4DGt5Pgo=; b=VNoTDmJdwa498TfCp+LuTJW+IF
        8mgxV1w/1gUxOb3INNbQYNYWDG/e9wMGkpmw0W6MBlnOYqCBCg2YZg2vxw78S665ouMOW5QDwTRRX
        nPfyoSUCiwmSGJ02sfBe88avKB1UIh1LhVESdICymc5XFoBcPyHTg9tBllicLm1CMbY3hHmUvm/Tw
        oCUjDOC/QTDJA0u2s2T7BU7w8qACr43EUazCDRMHHD7zaTJm9wlKN4sODe8g3rDQ2RW1NGVzCZlJO
        +vBlvnFyHpynuPlsd2ugDD2iKyJSVUlz2yMcSSTeJqu+uiVU3h9bwNvWPz3oPSwaZx7X7k5UigI5U
        tXmg04fQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49520 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRi-0000wf-Tt; Wed, 24 Nov 2021 17:52:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRi-00D8L8-F1; Wed, 24 Nov 2021 17:52:38 +0000
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH RFC net-next 03/12] net: dsa: replace phylink_get_interfaces()
 with phylink_get_caps()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:52:38 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink needs slightly more information than phylink_get_interfaces()
allows us to get from the DSA drivers - we need the MAC capabilities.
Replace the phylink_get_interfaces() method with phylink_get_caps() to
allow DSA drivers to fill in the phylink_config MAC capabilities field
as well.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h | 4 ++--
 net/dsa/port.c    | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index eff5c44ba377..8ca9d50cbbc2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -645,8 +645,8 @@ struct dsa_switch_ops {
 	/*
 	 * PHYLINK integration
 	 */
-	void	(*phylink_get_interfaces)(struct dsa_switch *ds, int port,
-					  unsigned long *supported_interfaces);
+	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
+				    struct phylink_config *config);
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d928be884f01..6d5ebe61280b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1094,9 +1094,8 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 
-	if (ds->ops->phylink_get_interfaces)
-		ds->ops->phylink_get_interfaces(ds, dp->index,
-					dp->pl_config.supported_interfaces);
+	if (ds->ops->phylink_get_caps)
+		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 				mode, &dsa_port_phylink_mac_ops);
-- 
2.30.2

