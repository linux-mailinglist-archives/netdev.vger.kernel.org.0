Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75AAC3A1CEB
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhFISol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFISoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:44:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E77CC061574
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 11:42:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ba2so27947227edb.2
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uZ5jYvJRBU51BNg6a69WEodJQm6lb3/+UJF9RJja0Fg=;
        b=mu8F45cyczzhN1TgdHfy7mCvlZBFGpFmYh73p7qIhg6aUqYXkyg3OqiikPnnobttxz
         6GLFsvq7Hq73UdiMVy4I7WM2V8lbbRxKjSGlZP6JryCKXebiAZcjRgOlBJaGltG7Y6ul
         2BlI7zfnfI4j308G5e7TBvHMbDS+y9ZcEDtNScmK9jE/RHbNPaJphhc5ZraYPxU0c+cz
         LYXO73QEr7B3bi5xvAJK/QwM2L8cUgtctTJxgeL3MDoAPOjTaMGB7tXN6LZ2VWfFdgUL
         AtIc2xQTl7EVt3QVAoGKu7nfp2BIdtpr5NhF7v0HvAywP01dpD8kGHreN/RlCo7P57Ae
         abmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uZ5jYvJRBU51BNg6a69WEodJQm6lb3/+UJF9RJja0Fg=;
        b=mq/j5IW1R8Fn+sfXTCHhQACCCtCDBBP6JAjiE9b3nLq3OdTJsUmBJuypPZvmFjQfsL
         cjfqqToZVBePkbBbxmHow4tFo/vI7XQID1cD3zpinVjVSfEqy0otbQXMHAe1ZipAY7FG
         eWEqIbr4E9sivSZkLmiDMJrNeYq97uZdxyALBuxEwEdLPGuMJ/xTXoA+DML9pBvN9syY
         ZAoDEXgoIIgWqFmMvesakKk9qbyymBLcf3Jy1osDR19vrb8RJTf2EeLhHjB484iuTjGe
         DKG+EBUjzC2kqRKCSXYMUGe7Z/N0cZraRw0hDwWH8gUND1nelhTfSAqMSJkRIheMK4rT
         Xl6g==
X-Gm-Message-State: AOAM530rnSueIlEXsfJMXuUTSSedU66JkxRQOUJKMCZK+XNtca1y59MM
        SAEopuyDroU2vp5bHcIX/ak=
X-Google-Smtp-Source: ABdhPJxxloZB8yfL09mio37R7zdfws3rGTZaNVITCFVqHaItvTXrlj3XRmSLuA9gbA3i3fnH/D4qhA==
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr792744edv.262.1623264148528;
        Wed, 09 Jun 2021 11:42:28 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id oz11sm194935ejb.16.2021.06.09.11.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:42:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 13/13] net: dsa: sja1105: plug in support for 2500base-x
Date:   Wed,  9 Jun 2021 21:41:55 +0300
Message-Id: <20210609184155.921662-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609184155.921662-1-olteanv@gmail.com>
References: <20210609184155.921662-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The MAC treats 2500base-x same as SGMII (yay for that) except that it
must be set to a different speed.

Extend all places that check for SGMII to also check for 2500base-x.

Also add the missing 2500base-x compatibility matrix entry for SJA1110D.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_spi.c  |  2 ++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index aca243665f3b..a901803dbf02 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1046,6 +1046,9 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	case SPEED_1000:
 		speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
 		break;
+	case SPEED_2500:
+		speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
+		break;
 	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
@@ -1060,6 +1063,8 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 */
 	if (priv->phy_mode[port] == PHY_INTERFACE_MODE_SGMII)
 		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_1000MBPS];
+	else if (priv->phy_mode[port] == PHY_INTERFACE_MODE_2500BASEX)
+		mac[port].speed = priv->info->port_speed[SJA1105_SPEED_2500MBPS];
 	else
 		mac[port].speed = speed;
 
@@ -1172,6 +1177,10 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	if (mii->xmii_mode[port] == XMII_MODE_RGMII ||
 	    mii->xmii_mode[port] == XMII_MODE_SGMII)
 		phylink_set(mask, 1000baseT_Full);
+	if (priv->info->supports_2500basex[port]) {
+		phylink_set(mask, 2500baseT_Full);
+		phylink_set(mask, 2500baseX_Full);
+	}
 
 	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
 	bitmap_and(state->advertising, state->advertising, mask,
@@ -1859,7 +1868,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 							      mac[i].speed);
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
-		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII)
+		if (priv->phy_mode[i] == PHY_INTERFACE_MODE_SGMII ||
+		    priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
 			bmcr[i] = mdiobus_read(priv->mdio_pcs, i, reg_addr);
 	}
 
@@ -1914,7 +1924,8 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (rc < 0)
 			goto out;
 
-		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII)
+		if (priv->phy_mode[i] != PHY_INTERFACE_MODE_SGMII &&
+		    priv->phy_mode[i] != PHY_INTERFACE_MODE_2500BASEX)
 			continue;
 
 		if (bmcr[i] & BMCR_ANENABLE)
@@ -1931,7 +1942,9 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		if (!phylink_autoneg_inband(mode)) {
 			int speed = SPEED_UNKNOWN;
 
-			if (bmcr[i] & BMCR_SPEED1000)
+			if (priv->phy_mode[i] == PHY_INTERFACE_MODE_2500BASEX)
+				speed = SPEED_2500;
+			else if (bmcr[i] & BMCR_SPEED1000)
 				speed = SPEED_1000;
 			else if (bmcr[i] & BMCR_SPEED100)
 				speed = SPEED_100;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index e6c2cb68fcc4..53c2213660a3 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -939,6 +939,8 @@ const struct sja1105_info sja1110d_info = {
 				   false, false, false, false, false, false},
 	.supports_sgmii		= {false, true, true, true, true,
 				   false, false, false, false, false, false},
+	.supports_2500basex     = {false, false, false, true, true,
+				   false, false, false, false, false, false},
 	.internal_phy		= {SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_NO_PHY,
 				   SJA1105_NO_PHY, SJA1105_PHY_BASE_T1,
-- 
2.25.1

