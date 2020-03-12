Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1919183017
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 13:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCLMUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 08:20:00 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:41978 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCLMUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 08:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UVvVOMVGmynQndrdDhbozXlLAYHdva8vTup3iriWDnA=; b=qc6mGJzafV8GLUp95uxkRApr7Q
        TMDbKIxncRtDeMhAyXNKNZrdN3PnpEI6iSkKjJR68e0je60pNjv90GKzN7v1hHOQCDg7FF5OoHqe0
        GialVRIMDWG/IvFifKK+lEKnia68svmWJ+RSwvJKbBW1f1tYt3e4RMTKflK42dtsrgpVWlU2iGRby
        nJ4HW2ve9OfTmBI9dOKlWRa8CJQURyOdbweRVl8FyIi0MnBU+FeZLAsnsu0ikP5b38IV1AEU4IIEO
        k0TZTTYQXgNCNo1l5vW6enT0zA7MjdJGnWJLL0J3IGJ4oxh7pt8Ct5k4lyEFn+Tzc2wXwIeD7Slu5
        qFFxyuaw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:40594 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jCMoa-00017A-Id; Thu, 12 Mar 2020 12:19:52 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jCMoZ-0005U0-Tv; Thu, 12 Mar 2020 12:19:51 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: move MAC configuration to
 .phylink_mac_link_up
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jCMoZ-0005U0-Tv@rmk-PC.armlinux.org.uk>
Date:   Thu, 12 Mar 2020 12:19:51 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

The switches supported so far by the driver only have non-SerDes ports,
so they should be configured in the PHYLINK callback that provides the
resolved PHY link parameters.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6fe679143216..2deb9c5e3ef7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -765,15 +765,16 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (sja1105_phy_mode_mismatch(priv, port, state->interface))
+	if (sja1105_phy_mode_mismatch(priv, port, state->interface)) {
+		dev_err(ds->dev, "Changing PHY mode to %s not supported!\n",
+			phy_modes(state->interface));
 		return;
+	}
 
 	if (link_an_mode == MLO_AN_INBAND) {
 		dev_err(ds->dev, "In-band AN not supported!\n");
 		return;
 	}
-
-	sja1105_adjust_port_config(priv, port, state->speed);
 }
 
 static void sja1105_mac_link_down(struct dsa_switch *ds, int port,
@@ -790,7 +791,11 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 				int speed, int duplex,
 				bool tx_pause, bool rx_pause)
 {
-	sja1105_inhibit_tx(ds->priv, BIT(port), false);
+	struct sja1105_private *priv = ds->priv;
+
+	sja1105_adjust_port_config(priv, port, speed);
+
+	sja1105_inhibit_tx(priv, BIT(port), false);
 }
 
 static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
-- 
2.20.1

