Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED0214DF2
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgGEQRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgGEQQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:16:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796E5C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 09:16:59 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lx13so21206451ejb.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 09:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZhHqpIqDfrNOSU+5um3zSzVK23wPGbDAAeDQ/8JEsqM=;
        b=M6N2xxqNZFPqzL7wkspOj0CNYvvGFOeipkB16U+Ozdm8eHFlZfHg7Jt7inBSnn0hI5
         to+KwsoxVTvavLwfgBb1Gvt0OWiCExPCLXguXtCadfs1UGnPzsffUG4buogLNXlh350o
         TRTtYPyULlpTMFSoguuWyklc4Ix9SIB+thgmZkYiKV4xViYe4W8oUbjweMu7d6Qqh6X2
         ccA84nlF7xep0oFAzEzJeg82z2BIeU0snj3PjYCfW0BajAwPlOBp8YwAO5h3e3EI7rPG
         mTlYSkZza0fxgZ9hF0Cor2QYy52uyTX2E7mk5z5hvIftD57qZEUl6g9WKvoAKXbEvG3Q
         eh9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZhHqpIqDfrNOSU+5um3zSzVK23wPGbDAAeDQ/8JEsqM=;
        b=PERdqRLBinGcvGa7u+6Q0W0Z8HdG12oSBVj5MIRjR4+3qnsj5teiiFESapOGm5wEJv
         cn5RH4/B9kxypBjrmlnLOEv8cf0h+uppVbKM8XOh+aYeKUgf2O0RAJ+BzN0cLBXF07nZ
         91hrMJ+xHJ7bJoG2EvqApqMKdt3KxOz3tepGJ+8U8nbPquUhX3IFX0gPzIHk842giiVH
         MgmYjGsto6bg0zZef30QVHr8svnpFrPcWvJKFh/Fk5hwoDi39+vzcdtcViZVbiP2Xlew
         PtEKx9uXBu9/a0ZIrO9jax4A6Ie0XnwNILkHCwDh8p/95J1W8u4ElKtF2uftwlYGF0wi
         CeeA==
X-Gm-Message-State: AOAM533OTrQEyhvr3vbk2GVIGVnDOvWwrumb6ScuagBiTQWLt5bGVMAq
        hwfjYgJEEyXb/ToPhrbw7hoM8sjj
X-Google-Smtp-Source: ABdhPJxfHnk+2TEV9nr3YCzevhHV0iiuPkSEshtKOrVDS8UL+1i0FZFj2VBiJbtY2DtJO4VmO6hxig==
X-Received: by 2002:a17:906:5909:: with SMTP id h9mr38059839ejq.501.1593965818181;
        Sun, 05 Jul 2020 09:16:58 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id x4sm14406126eju.2.2020.07.05.09.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2020 09:16:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, linux@armlinux.org.uk
Subject: [PATCH v3 net-next 2/6] net: dsa: felix: support half-duplex link modes
Date:   Sun,  5 Jul 2020 19:16:22 +0300
Message-Id: <20200705161626.3797968-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200705161626.3797968-1-olteanv@gmail.com>
References: <20200705161626.3797968-1-olteanv@gmail.com>
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
Changes in v3:
None.

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

