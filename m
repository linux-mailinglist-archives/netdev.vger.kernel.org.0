Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE07E45CB69
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349883AbhKXRzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237134AbhKXRzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:55:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CCEC061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5r0nIEND0MZ83LQBPhUX6WdtGt1o7Ko1ahfqFOPp4UE=; b=lRR5KrotW8c4VCmzoQPz4fIa6u
        ubFHyeTeYOrN5irLo8k1x/d0qMg8Ey9DYsFBYsR13pcuH+Z0yaAb8hpE4SDWKfqc3tq9yt6rCa+9q
        3ZRoPNDnc8o+DtzsGX9fzQ0OH0nQfNWrCISdUpn1Z7V9sABhYuAx3F5HcGA2KNmenEjPCJEeSUud3
        Vnly6wNRT8Mhp/l+P4FlSCavX+owhUMd+a7aTD6iGx1NFUGxAuzt6KXmJEwAb3YrCru1awT5hjO4l
        dglmxH3YqEXEivXH/Sh0bXBn3A5IP4s9Ay83LJcq9mwQNbqBxncKqjzvW1/58BaUpbaRsO7MEjKpF
        cDC4vGZQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49516 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRd-0000wK-Q2; Wed, 24 Nov 2021 17:52:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpwRd-00D8L2-Aq; Wed, 24 Nov 2021 17:52:33 +0000
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
Subject: [PATCH RFC net-next 02/12] net: dsa: support use of
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpwRd-00D8L2-Aq@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 24 Nov 2021 17:52:33 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the use of phylink_generic_validate() when there is no
phylink_validate method given in the DSA switch operations and
mac_capabilities have been set in the phylink_config structure by the
DSA switch driver.

This gives DSA switch drivers the option to use this if they provide
the supported_interfaces and mac_capabilities, while still giving them
an option to override the default implementation if necessary.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index eaa66114924b..d928be884f01 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -981,8 +981,11 @@ static void dsa_port_phylink_validate(struct phylink_config *config,
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->phylink_validate)
+	if (!ds->ops->phylink_validate) {
+		if (config->mac_capabilities)
+			phylink_generic_validate(config, supported, state);
 		return;
+	}
 
 	ds->ops->phylink_validate(ds, dp->index, supported, state);
 }
-- 
2.30.2

