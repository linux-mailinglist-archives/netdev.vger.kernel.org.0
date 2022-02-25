Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96304C4407
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbiBYL5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240326AbiBYL5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:57:09 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55868AE75
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RYCgZJ6/uSj3Jq+s87BgA+sd185pOO5jBmMWhdDnF8w=; b=spET+2T7/ANbDKg8Z0Xotvhh/C
        D73ykT5+9rOs77tGoUWt0Snb4hih0jZ+QabtNiZATsH1MrmBWHEgIoq1fIQWGFHrEB+9CvE7yzsaf
        HgEz6s2W7Rj29jTC9OlQz2wFI/ilgMj3Gugi3s7UPUtAZwu9SI5FcCCzdrc6YmJTksqFNPnxGMF8N
        X4QB0DLSyfs7B+yiWczn0Jq2xA50YlwlRkc4ZcBwFRWhnSaeErSQypTLwUFOwc/5oR6Kqq4Jk6pRD
        NGLfqDPBuUr9/n2j3xbmIKQTeKQSHMLd681nBepcO6388BKLibUbzIgjMPZYHat3+UxU8De4tKSlK
        LqSoGH3A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46056 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nNZD2-0005I6-QJ; Fri, 25 Feb 2022 11:56:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nNZD2-00Ab1w-7J; Fri, 25 Feb 2022 11:56:28 +0000
In-Reply-To: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
References: <YhjDvsSC1gZAYF74@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] net: dsa: sja1105: support switching between
 SGMII and 2500BASE-X
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nNZD2-00Ab1w-7J@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 25 Feb 2022 11:56:28 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean suggests that sja1105 can support switching between
SGMII and 2500BASE-X modes. Augment sja1105_phylink_get_caps() to
fill in both interface modes if they can be supported.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 27 +++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5beef06d8ff7..8fc309446e1e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1396,6 +1396,7 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_xmii_params_entry *mii;
+	phy_interface_t phy_mode;
 
 	/* This driver does not make use of the speed, duplex, pause or the
 	 * advertisement in its mac_config, so it is safe to mark this driver
@@ -1403,11 +1404,27 @@ static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
 	 */
 	config->legacy_pre_march2020 = false;
 
-	/* The SJA1105 MAC programming model is through the static config
-	 * (the xMII Mode table cannot be dynamically reconfigured), and
-	 * we have to program that early.
-	 */
-	__set_bit(priv->phy_mode[port], config->supported_interfaces);
+	phy_mode = priv->phy_mode[port];
+	if (phy_mode == PHY_INTERFACE_MODE_SGMII ||
+	    phy_mode == PHY_INTERFACE_MODE_2500BASEX) {
+		/* Changing the PHY mode on SERDES ports is possible and makes
+		 * sense, because that is done through the XPCS. We allow
+		 * changes between SGMII and 2500base-X.
+		 */
+		if (priv->info->supports_sgmii[port])
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  config->supported_interfaces);
+
+		if (priv->info->supports_2500basex[port])
+			__set_bit(PHY_INTERFACE_MODE_2500BASEX,
+				  config->supported_interfaces);
+	} else {
+		/* The SJA1105 MAC programming model is through the static
+		 * config (the xMII Mode table cannot be dynamically
+		 * reconfigured), and we have to program that early.
+		 */
+		__set_bit(phy_mode, config->supported_interfaces);
+	}
 
 	/* The MAC does not support pause frames, and also doesn't
 	 * support half-duplex traffic modes.
-- 
2.30.2

