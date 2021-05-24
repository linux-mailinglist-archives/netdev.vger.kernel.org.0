Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3FD38F62C
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhEXXYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhEXXYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:02 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBB8C061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:33 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l1so44289594ejb.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/pbiDkMc1xiTTnzJey7JYsMk+HBUbuh5IEY8IdZSCR4=;
        b=C7seXepgq2gAHzZMJw1pQHL1RbPnq4IS0GQb/R1qIP8cShystNI5BJw/UmgbFboeS1
         q6xU2oGqwN7lCnfAvCjQW5tlxfvAyN/pPr8VFUMj7vsYZKCyGMRRyxeWnwYFA4bZmFlD
         ekOUBlf96CNNZyKbKF/ddBBfhnCmckuGjuPZ9FMorR35OuuFZkayABQVlKST8sW0l03Z
         LpbqQfjKT8j5dyv+TZd9EBD8BP5r7d4X4k2QEVNcfqb9IRb0Ns1wT91osXqVAfA1/9Sw
         HcOibdwdCY2KTzQN39j93Oh9IccPSwcGus1MTNXndWXvH5msrDo7uy0OQV7xx7P471Gi
         /87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/pbiDkMc1xiTTnzJey7JYsMk+HBUbuh5IEY8IdZSCR4=;
        b=aDKdq7dLpm/C9xNi7+YYI3OpQMsQ7yorRixcoYtKukDtQsZx2Add9gyOs2TbmXVuCb
         UFhrNOwk24fseqUgFCID9A+Cent8zM8dKkIZg0oztVanqaEeLSlUCxysfgwyYxu0mVuw
         GmQstqhY3o762hHxsCcY2gBjiAA3FfbqL4CUlMKBz/Lvyeexeqbo9fyNx2ZYoQ0PFA7g
         89QFbTg3b+NxZmOIgljRKQcofcymppHYRZWfkFA60Tib+rOkP5uZLqvbkdqp3zjMSYkV
         S05EQK5RU1fV313XywsrKfTPwLzahlP06bGAloiMQfCI3viTP+1iH7Nm3cDXW1AUTHwD
         TWtw==
X-Gm-Message-State: AOAM533LgExfB7VDdgv0974+soXA6/7mQF8tUa7NQMCgjpZp7hpaDEUX
        7SIs/hDrOBaSjdTs4/i4pJNjim4BQ6s=
X-Google-Smtp-Source: ABdhPJx3P3l5TOCRNBaaiKfmqHDvv6Je/JAY1o7O6MfJXzx6R0KiDj58QrsxVlBEe5/8LyY46JBknw==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr24798382ejl.430.1621898552162;
        Mon, 24 May 2021 16:22:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 04/13] net: dsa: sja1105: cache the phy-mode port property
Date:   Tue, 25 May 2021 02:22:05 +0300
Message-Id: <20210524232214.1378937-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

So far we've succeeded in operating without keeping a copy of the
phy-mode in the driver, since we already have the static config and we
can look at the xMII Mode Parameters Table which already holds that
information.

But with the SJA1110, we cannot make the distinction between sgmii and
2500base-x, because to the hardware's static config, it's all SGMII.
So add a phy_mode property per port inside struct sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 24 +++---------------------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 830ea5ca359f..d5c0217b1f65 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -210,6 +210,7 @@ struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
+	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool best_effort_vlan_filtering;
 	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 292490a2ea0e..f33c23074bb5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -871,6 +871,8 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			ports[index].role = XMII_MAC;
 		else if (of_property_read_bool(child, "sja1105,role-phy"))
 			ports[index].role = XMII_PHY;
+
+		priv->phy_mode[index] = phy_mode;
 	}
 
 	return 0;
@@ -1081,27 +1083,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
 				      phy_interface_t interface)
 {
-	struct sja1105_xmii_params_entry *mii;
-	sja1105_phy_interface_t phy_mode;
-
-	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
-	phy_mode = mii->xmii_mode[port];
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_MII:
-		return (phy_mode != XMII_MODE_MII);
-	case PHY_INTERFACE_MODE_RMII:
-		return (phy_mode != XMII_MODE_RMII);
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		return (phy_mode != XMII_MODE_RGMII);
-	case PHY_INTERFACE_MODE_SGMII:
-		return (phy_mode != XMII_MODE_SGMII);
-	default:
-		return true;
-	}
+	return priv->phy_mode[port] != interface;
 }
 
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
-- 
2.25.1

