Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609391E978B
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgEaM1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729683AbgEaM1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708ADC03E969
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g9so5176679edr.8
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/2Pba/U6BX5MKmSK57VX5GCirz0mdChvO5m3VWJA2w=;
        b=C+JN5vc4pGnGh6WQPzIFPaxgrUq8g79kgRQRSUaHe/Z8UUb4OaXxtIktzcFCGngaF0
         p7A0n6ymprTGNyGB8HrFkEz/pI8z0oJPb7TIpY0jVueuLMlBKnJ+7SaFnf0Ly8HJOJLV
         zGeKM7SaooJfWzr3nHI6S8Icoke2WYw5a0CmGFQR9SDKt6pdybdVrisDw5TYIlImAC6l
         DykPHdSIAs/7bXQ46neHkGqcuA1UrhCQMXbJfRUPBh6ehlERLOY4ny8Qeeol53RDT8AB
         v3c2JSaDP9TtLf7b5wSnZ8uIRIBP2t1c3NFFXtvOeZGKTROo3cxfxbnt0V2kMFP0R5SB
         W1Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/2Pba/U6BX5MKmSK57VX5GCirz0mdChvO5m3VWJA2w=;
        b=UhyzFnrzGXgQVZQXIYLEVv5RFxEyLnckrsdWTELLhSygTQvMLG4cgC4Mh8uF3SY5Px
         v3eRNnCDMjVPyHpQRnh5wGaEnDbazghxH2c0/OaRO1eXaL7vZVoSZOZRXCEpnu6+4fWa
         fpc3GD7HDeESVtwCtl5E9hVLLiUDfAuHoV8SSWVw9SqJxxjr3F1zx97yS6utC2M/W+9k
         kfoIaH4Hs6achYuKaF4Y+GorKi0puRZyzmLaWaf9OlqZaTB38x1QYikVdKiZ9xsGaJwm
         dJsmsXpgOYS5zDo7qtWKfgkgUGUeWIUDGoiX5RcAQVGiVwS/2/DOV5r+hSkIodsVj9tf
         AjxA==
X-Gm-Message-State: AOAM530tCv+3dTI92vl4gFAfTOQdDpLTw0gcE2IkuKvTiaSsFyyEvvh1
        RDNPpWRDWiqDqn6uo3eQxR4=
X-Google-Smtp-Source: ABdhPJyJ0Twlc5QRLmH/BSue+kcFmNv3vKutZgS4yblVN/A812j4y1nPV0BCr4UlHzc/8faO55/kMg==
X-Received: by 2002:aa7:c598:: with SMTP id g24mr11028267edq.132.1590928038118;
        Sun, 31 May 2020 05:27:18 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 11/13] net: dsa: felix: support half-duplex link modes
Date:   Sun, 31 May 2020 15:26:38 +0300
Message-Id: <20200531122640.1375715-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
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
Patch resent from:
https://patchwork.ozlabs.org/project/netdev/patch/20200528094410.2658306-1-olteanv@gmail.com/

Changes in v3:
None.

Changes in v2:
Added spaces before the ping output in the commit message.

 drivers/net/dsa/ocelot/felix.c         |  4 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 13 ++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0346697bed3f..88b64faa8b25 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -167,14 +167,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
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
index e722b58a714f..61c91248a802 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -875,12 +875,12 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 
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
@@ -906,7 +906,7 @@ static void vsc9959_pcs_init_sgmii(struct phy_device *pcs,
 		/* Yes, not a mistake: speed is given by IF_MODE. */
 		phy_write(pcs, MII_BMCR, BMCR_RESET |
 					 BMCR_SPEED1000 |
-					 BMCR_FULLDPLX);
+					 duplex);
 	}
 }
 
@@ -983,8 +983,11 @@ static void vsc9959_pcs_init(struct ocelot *ocelot, int port,
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

