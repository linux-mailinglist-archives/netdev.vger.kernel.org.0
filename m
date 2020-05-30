Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C83571E90F5
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgE3Lwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbgE3Lwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:31 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F8C08C5CA
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:31 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id z5so4705093ejb.3
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BRGbdw6by/2Gamfpb2pljI1rWmwGfS0gww8erKBjbmQ=;
        b=InA4ld+GpNSDMM6ExfYRXkOEQFghk70vMKb5koN7g7I6dPpdCdwMbR40KLUL7wEewQ
         El5W4/T8eSLs1k9YFXrg0L6o9qfNjgyYpLZCViL+Or+C2JscnaCyKO2Z6YPF9tJ1zqUu
         4O7HsDMO1iUqjquuLQZsjKAe5dCIEx6msTHtyfD0hFXkT89lC+5wRcXcJpIGvakhrwbp
         GU7tDNl7cAurLLwpaG0QbDFWiNZ7rX1HXt4U6VfS5QGHDBQNHYTtoVSf9PzABzv8QAjd
         Si/L4ZGaRo/0eFuHORA/ygKJDbquyhtYcpLsPcYTScmgTWG6t0gp1o3TAbY666xb/J2A
         u3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRGbdw6by/2Gamfpb2pljI1rWmwGfS0gww8erKBjbmQ=;
        b=l1XMAuI/oAWHn6tc02Vb41K605KgwMuBTm7dMN7Rqo7oGmcffy7cB/Q39or0G4gPRF
         ydfgrRHHF+LzVZrdfsq36R/zXDFxzIOt1AUQLG5ivuCDs2hrFVMhiN0xpZyVvsF7vOPO
         TCMp69EPCgGHv3MYkk6iwHdzJcvzNQ7ej6cPVGg9fM0fsreKXzP39c0YBV9jxy/GLL4j
         41UlN3fpLV7Wn3+I/VqeoKML5MnwLXqdlFtYfSc3/hMFLkECZDU8HJ9MDZdWWiSi+f5J
         FQFMNA/6bHPUWb/PmNNI58sbD4cibcUrsL8ka4OWgJe0oGdKo26Dpiwe0KhtvtN0lI9n
         n2rw==
X-Gm-Message-State: AOAM5319umOhMpKy0Y6vYsxR0m+Ec1BfQVeCDnAK1Af9Uxhmf68PuvlD
        lcifEox+AdNB/FOv2T+Foug=
X-Google-Smtp-Source: ABdhPJwaA1mSqaXxUmqT+nDljPZJ/cmM4DXnISOsbTHqDycpG7/WLoJpaG3SMghRr960+k/p1uYVZQ==
X-Received: by 2002:a17:906:8283:: with SMTP id h3mr12624073ejx.415.1590839550086;
        Sat, 30 May 2020 04:52:30 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 11/13] net: dsa: felix: support half-duplex link modes
Date:   Sat, 30 May 2020 14:51:40 +0300
Message-Id: <20200530115142.707415-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
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
Patch resent from:
https://patchwork.ozlabs.org/project/netdev/patch/20200528094410.2658306-1-olteanv@gmail.com/
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

