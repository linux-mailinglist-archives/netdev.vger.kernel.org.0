Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52351E5C45
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgE1JoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbgE1JoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 05:44:19 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D9DC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:44:18 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id e2so31317702eje.13
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 02:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CVQLXSPqYu2wNoD1AB9EsNddWvJ6zowsmDUL6fEcjE=;
        b=laiBHvsGXgXup7Jgo2b44c8i9y/1Pgg7YVvhp4o13U3S625t7ZSm7MNi++l8Tvwqqp
         wihJIf/MVKT34f/dmS3KRZdNlYnL9HuEE7X5a3oeE31X2lsEYdqXT7+8QMseUgujBPLu
         at2hLDDtNqA8Px16RO+e11Py/QS0a0I48Tzf/T98TEgNq7z43k9zAQrLsJr6IUqrv1TL
         MdI20Z3w5ESzVmEmvqeVT80Jx09e+63HPJK2qqf0WQdMt8vX1xu3fKvOPxpqVaKZgA2u
         tYcvpZz7ZPef60//2ryCjpPKZYVxPb2m4yUtfzkrCDqUL/yTFVAtusFSg9FokzOSTxad
         LNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CVQLXSPqYu2wNoD1AB9EsNddWvJ6zowsmDUL6fEcjE=;
        b=c7+bvmilUNeJAalPnLj7TeilCV0hFUHbdhvwZrI2KrsshhvHb/ArsAHoitRo1tPNfA
         mwVpcnYJBw0EGdMWBImVqfGasFgkqic0in+0wvsG2x74AqBCynncvDQKM0M5eWghQGzj
         khNDLRKTNgGFjg4MJxsPZ3P1+xNPqAk+SrAurtkeK8xduhScVUMybvwekhddv3bflO7w
         9UD94kg+cM3NL1k0IPFiKg8wfNsSdDK7UVPIl1iMFeywWMnuqUmrquTdrf3PAoKoUyB3
         V5KAfzQVzli0O80XYFjjuqSqx9Lpol3ZNWEsuwooykzyPQ5lgfUq7p3cb/JcIrz5hZiV
         DwDw==
X-Gm-Message-State: AOAM533FzhzysDlV6uPP3yheQB16RB0cCegtVk6qoKyzNDMWxZzLNZ30
        UsnF+imOA9N2uZMKE5VMILg=
X-Google-Smtp-Source: ABdhPJzQCqb5ebjP+Dn7u1zUcmrmjedFERIq0Lp0m0KK1y1+oukQ9j5m3019YC+VK8JVBHde+dTRCA==
X-Received: by 2002:a17:906:b2c6:: with SMTP id cf6mr2180077ejb.210.1590659057571;
        Thu, 28 May 2020 02:44:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id qt19sm676793ejb.14.2020.05.28.02.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 02:44:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: felix: support half-duplex link modes
Date:   Thu, 28 May 2020 12:44:10 +0300
Message-Id: <20200528094410.2658306-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
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
---
 drivers/net/dsa/ocelot/felix.c         |  4 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 13 ++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 66648986e6e3..e5ec1bf90eb0 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -171,14 +171,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 		return;
 	}
 
-	/* No half-duplex. */
 	phylink_set_port_modes(mask);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
 	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 10baseT_Half);
 	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 1000baseT_Full);
+	phylink_set(mask, 1000baseT_Half);
 
 	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
 	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1dd9e348152d..e706677bcb01 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -817,12 +817,12 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 
 		phy_write(pcs, MII_BMCR, BMCR_ANRESTART | BMCR_ANENABLE);
 	} else {
+		u16 duplex = 0;
 		int speed;
 
-		if (state->duplex == DUPLEX_HALF) {
-			phydev_err(pcs, "Half duplex not supported\n");
-			return;
-		}
+		if (state->duplex == DUPLEX_FULL)
+			duplex = BMCR_FULLDPLX;
+
 		switch (state->speed) {
 		case SPEED_1000:
 			speed = ENETC_PCS_SPEED_1000;
@@ -848,7 +848,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 		/* Yes, not a mistake: speed is given by IF_MODE. */
 		phy_write(pcs, MII_BMCR, BMCR_RESET |
 					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
+					 duplex);
 	}
 }
 
@@ -925,8 +925,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
 			       ARRAY_SIZE(phy_basic_ports_array),
 			       pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT, pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT, pcs->supported);
 	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, pcs->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT, pcs->supported);
 	if (pcs->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	    pcs->interface == PHY_INTERFACE_MODE_USXGMII)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
-- 
2.25.1

