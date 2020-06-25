Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A479820A1D1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405809AbgFYPXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:23:48 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B77C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id m21so4507216eds.13
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NrtYGIGXeIVrUUUH2RaWHc9PVo2H+kIRyqzNNvoWTS0=;
        b=MIHG5HUt90e+myQhBVk9oUiN1JzBoU5nGt9G0QE6OljA7F8g9NxjuqFetZbJhjzzca
         XnV37KOdRd45rA8H7oOZHTPPjobIdU6jA/Bi2F3HDE2XSCz2C42dDCyqLWpNubhla/ZV
         eldiS/W7mc0C8C9iPDxRlIYLZLzgCZn3dXPga+6q4WXKdxFUg78Dgr8cq1FKjOgQuKG+
         2yHCdp0mhKI7t4Lzoel+/ohO/QTD8GJ3/cCvAx+2aHTtO8OR7IfFQohguwZMiz2/lzgw
         fRiRlW3TT0C7SrcyJeVStbVmf9EEDbADKdtJIgMoUgN7/Gvmu7ambGzyEosB7ovjlqiw
         bRuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NrtYGIGXeIVrUUUH2RaWHc9PVo2H+kIRyqzNNvoWTS0=;
        b=OdqW75bXMnPYRribir73HhIiGAy+lqkO+st+IXWH4kwgvcRMXIpupGsb/UKETtwlJy
         VuuflEqSz4CLuqfXRnuctsBsYnEMN6+9M+VwrLRGa8SPquKEJvwxWhiaS8/GCgFV/vH8
         f9IGFx7aNFkk7OcCqc7o80BSUSQDqxxHLmHT+Tm6JW03bXhLPdaLLTdXsAZlU6tKayaj
         zBbCfw9AAUHZzn0eMCLQgxmx5cvf0h/tHWCf0uJ9OOLC/RTOLqb7HRelhEPGZOBV8bOD
         0TwU9BBpe8295GfVVpr35a/D75spNSIbwV4LEAZMAhU9dc0A2nkipNy/bWfne8vI1NNG
         lLcA==
X-Gm-Message-State: AOAM532LP8Kywa0p4G1ay0ew1KLTOkG0A2wfdB6WLyeR63qi9hQsaKK6
        GVsWgKKWN23ChQiY2rzMxxA=
X-Google-Smtp-Source: ABdhPJy2Sy3T66ETVZkTCw6L/7yniPbRenNIo205u8A4dmThiuJVmZzoskeMZ0JUwUQyQY636c42ng==
X-Received: by 2002:a50:cfc4:: with SMTP id i4mr31915484edk.252.1593098626820;
        Thu, 25 Jun 2020 08:23:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id o17sm9102898ejb.105.2020.06.25.08.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:23:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH net-next 2/7] net: dsa: felix: support half-duplex link modes
Date:   Thu, 25 Jun 2020 18:23:26 +0300
Message-Id: <20200625152331.3784018-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200625152331.3784018-1-olteanv@gmail.com>
References: <20200625152331.3784018-1-olteanv@gmail.com>
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
---
Repost of:
https://patchwork.ozlabs.org/project/netdev/patch/20200624155926.3379373-1-olteanv@gmail.com/
Changed:
In the "forced link" scenario (not previously tested, just in-band), we
need to configure half duplex through the IF_MODE register, not BMCR.

 drivers/net/dsa/ocelot/felix.c         |  4 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 24 ++++++++++++++----------
 include/linux/fsl/enetc_mdio.h         |  1 +
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 25046777c993..25b340e0a6dd 100644
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
index 3269c76b59ff..c1220b488f9c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -817,12 +817,9 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 
 		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
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
@@ -841,10 +838,11 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 			return;
 		}
 
-		phy_write(pcs, ENETC_PCS_IF_MODE,
-			  ENETC_PCS_IF_MODE_SGMII_EN |
-			  ENETC_PCS_IF_MODE_SGMII_SPEED(speed));
+		if_mode |= ENETC_PCS_IF_MODE_SGMII_SPEED(speed);
+		if (state->duplex == DUPLEX_HALF)
+			if_mode |= ENETC_PCS_IF_MODE_DUPLEX_HALF;
 
+		phy_write(pcs, ENETC_PCS_IF_MODE, if_mode);
 		phy_write(pcs, MII_BMCR, BMCR_RESET);
 	}
 }
@@ -870,15 +868,18 @@ static void vsc9959_pcs_init_2500basex(struct phy_device *pcs,
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
 	phy_write(pcs, MII_BMCR, BMCR_RESET);
 }
 
@@ -919,8 +920,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
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

