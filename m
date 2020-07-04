Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7072145EC
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 14:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgGDMpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 08:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgGDMpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 08:45:30 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B1DC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 05:45:30 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a8so29019207edy.1
        for <netdev@vger.kernel.org>; Sat, 04 Jul 2020 05:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yS0+I411Ap/BIhKJFodwGD10vbKRmbIAa9qAlps6mM0=;
        b=vghO0ziBZ0y6kKC4q85P/fayyiu3x1izcgmN9YYBlrAx8WkZWmQ6RFFQ2fuPuD/TKY
         4EptVXzGnXnZ8lT5QowmOcx8aHH7ax6IWzgnk3EQMr7cHxKsJkAiQYbwouGOYKjHctri
         qFeoEFgMDxsIK+hP3di18gA2WsfUD42+KQGMqu4SNieZj5vv0hA+KIZzHQ6QV48egNgJ
         I7k++Xlbhb5k+RUJJdQIdIsHGaVatj10q7KjvtjUrJY0pjafhJOCus1vAZOHAxTJ01T9
         Xdo+CsvwqdZ5N9rb8zXMUKuNqtmQTQHMUDsBkRz4iw+UQAoi7IT7wmuZwelzx74ILyti
         ypxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yS0+I411Ap/BIhKJFodwGD10vbKRmbIAa9qAlps6mM0=;
        b=LsODFehiJoQWoMluxRKwoliEKVJiDAstrYFKC/PsMZh1CGunUWctyK5ptfiUw9wkhV
         DSEQJcq69rHNRiGbt8d6Ym9VLchEco0zwJKaNLthKcZN+n8mkfLMopBZO9EtK1lvpiCi
         Z5skYX/Mk9NgGVEv6rCUKXgC4e3qtyNpZiV2BDkO2F7Atz1OxCJ4xtL6S5mkIhlCAE+i
         E2VqRJe2IvI04z2AEZ0+qWgyBGrhJRRR3Cwk4MtPRyWBnKHfjJtO9fcSbOAE0Qzh2MOg
         g/fe0//sl4I2lqLXbkFoLs6XvF6iMNnBTnI6Ogj5sEPAtv5L+jIylzgqYUB7XfXZis0+
         pjFw==
X-Gm-Message-State: AOAM532xFSTmM3tcxxpj96v7a+cSwrmdQeI82Lt60wBE1PgKLygwBhdc
        XQOau7rc6M7EIJywVNCdqz0=
X-Google-Smtp-Source: ABdhPJwMx/fGvvLh9N9/2scyM0OwJY14h6rF3v7DLbHIkcQQM94pgjT338Dt4t0vbXGAl4f/XfORMA==
X-Received: by 2002:aa7:c6d3:: with SMTP id b19mr44158129eds.207.1593866728925;
        Sat, 04 Jul 2020 05:45:28 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id dm1sm12983851ejc.99.2020.07.04.05.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2020 05:45:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v2 net-next 2/6] net: dsa: felix: support half-duplex link modes
Date:   Sat,  4 Jul 2020 15:45:03 +0300
Message-Id: <20200704124507.3336497-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200704124507.3336497-1-olteanv@gmail.com>
References: <20200704124507.3336497-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Ping tested:

  [   11.808455] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control rx/tx
  [   11.816497] IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready

  [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x4
  [   18.844591] mscc_felix 0000:00:00.5 swp0: Link is Down
  [   22.048337] mscc_felix 0000:00:00.5 swp0: Link is Up - 100Mbps/Half - flow control off

  [root@LS1028ARDB ~] # ip addr add 192.168.1.1/24 dev swp0

  [root@LS1028ARDB ~] # ping 192.168.1.2
  PING 192.168.1.2 (192.168.1.2): 56 data bytes
  (...)
  ^C--- 192.168.1.2 ping statistics ---
  3 packets transmitted, 3 packets received, 0% packet loss
  round-trip min/avg/max = 0.383/0.611/1.051 ms

  [root@LS1028ARDB ~] # ethtool -s swp0 advertise 0x10
  [  355.637747] mscc_felix 0000:00:00.5 swp0: Link is Down
  [  358.788034] mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Half - flow control off

  [root@LS1028ARDB ~] # ping 192.168.1.2
  PING 192.168.1.2 (192.168.1.2): 56 data bytes
  (...)
  ^C
  --- 192.168.1.2 ping statistics ---
  16 packets transmitted, 16 packets received, 0% packet loss
  round-trip min/avg/max = 0.301/0.384/1.138 ms

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Changes in v2:
None.

Note: this patch is still using state->duplex from mac_config(),
although that will be changed in 6/6.

 drivers/net/dsa/ocelot/felix.c         |  4 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++----------
 include/linux/fsl/enetc_mdio.h         |  1 +
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 75020af7f7a4..f54648dff0ec 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -194,13 +194,15 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	/* No half-duplex. */
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
+	phylink_set(mask, 10baseT_Half);
 	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
 	phylink_set(mask, 1000baseT_Full);
 
 	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9f4c8343652f..94e946b26f90 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -817,12 +817,9 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 
 		phy_set_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	} else {
+		u16 if_mode = ENETC_PCS_IF_MODE_SGMII_EN;
 		int speed;
 
-		if (state->duplex == DUPLEX_HALF) {
-			phydev_err(pcs, "Half duplex not supported\n");
-			return;
-		}
 		switch (state->speed) {
 		case SPEED_1000:
 			speed = ENETC_PCS_SPEED_1000;
@@ -841,9 +838,9 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			return;
 		}
 
-		phy_write(pcs, ENETC_PCS_IF_MODE,
-			  ENETC_PCS_IF_MODE_SGMII_EN |
-			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
+		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(speed);
+		if (state->duplex == DUPLEX_HALF)
+			if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
 
 		phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 	}
@@ -870,15 +867,18 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
 				       unsigned int link_an_mode,
 				       const struct phylink_link_state *state)
 {
+	u16 if_mode = ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500) |
+		      ENETC_PCS_IF_MODE_SGMII_EN;
+
 	if (link_an_mode == MLO_AN_INBAND) {
 		phydev_err(pcs, "AN not supported on 3.125GHz SerDes lane\n");
 		return;
 	}
 
-	phy_write(pcs, ENETC_PCS_IF_MODE,
-		  ENETC_PCS_IF_MODE_SGMII_EN |
-		  ENETC_PCS_IF_MODE_SGMII_SPEED(ENETC_PCS_SPEED_2500));
+	if (state->duplex == DUPLEX_HALF)
+		if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
 
+	phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
 	phy_clear_bits(pcs, MII_BMCR, BMCR_ANENABLE);
 }
 
@@ -919,8 +919,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
 	linkmode_set_bit_array(phy_basic_ports_array,
 			       ARRAY_SIZE(phy_basic_ports_array),
 			       pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
 	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	    pcs->interface == PHY_INTERFACE_MODE_USXGMII)
diff --git a/include/linux/fsl/enetc_mdio.h b/include/linux/fsl/enetc_mdio.h
index 4875dd38af7e..2d9203314865 100644
--- a/include/linux/fsl/enetc_mdio.h
+++ b/include/linux/fsl/enetc_mdio.h
@@ -15,6 +15,7 @@
 #define ENETC_PCS_IF_MODE_SGMII_EN		BIT(0)
 #define ENETC_PCS_IF_MODE_USE_SGMII_AN		BIT(1)
 #define ENETC_PCS_IF_MODE_SGMII_SPEED(x)	(((x) << 2) & GENMASK(3, 2))
+#define ENETC_PCS_IF_MODE_DUPLEX_HALF		BIT(3)
 
 /* Not a mistake, the SerDes PLL needs to be set at 3.125 GHz by Reset
  * Configuration Word (RCW, outside Linux control) for 2.5G SGMII mode. The PCS
-- 
2.25.1

