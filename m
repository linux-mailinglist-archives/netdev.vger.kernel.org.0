Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1876120782E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404562AbgFXP7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404137AbgFXP7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 11:59:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D7C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:59:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id d15so1875473edm.10
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GuVZiR7e1LROR05gv4rHhtX8GjCe4icOTWn4Uiiw2Ec=;
        b=Y/YXLAVwVUcbOF6TdE811hnjqyq13TtqpadEV7+eD1y0d6BbkI09h/VyACyWMAIAFm
         sW7AGkUjKoI5+QxrxKeFPt6Og+0Jz/iiS4o3/37acX+wbmKKiq0nsmPszGe5FNwfHQHc
         EFsGANbchpwoz589lgTobxLIXYPIwDJ2GTPl8bhIz+Sl6+SYcfwD4WhDeXCGqbE+B07f
         eDuRY+7pZbcGEg2OMbFqzEpj4dUZz4huYJ4JCpLcgKXorH5co4yj2GmDJwkMa3QAysmc
         3eVav0FoI1z4kWYsHgw7HbR2vTP8gjgPvsOmQZLuRV0JrULG9knaHEb1j4f6I3udjMmt
         ioUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GuVZiR7e1LROR05gv4rHhtX8GjCe4icOTWn4Uiiw2Ec=;
        b=JsIx+3G+WzO3wsIcQSTLGODqdNYlRTmbUN8AltygzDXJbGZgnLVuT0h8JVU0QckJlX
         1V9QuXUGOyqoiiXXgWn677Ioj7VmrJ54v70cwLrfvyfLPocFh0Ax+Kqe8rBFN5D9rT0C
         Je0A2hCzJm/T9VHSiTRA1OuXDpx1UDN2RmsrBh8FhMmujctTDNn2m3sBVgBDd/++BS+F
         Pm/8sri9UIyMa2A8gwVIZMfpN1H0X098vyg9lcHnadhE89P/XbQCncJzkLHmMAC63H5M
         3IAm3WUzQIz7t/SG65GbxX8vM10oRXFlANl/VO+8Wco0Dw87Z3Byim7ZY4al3dXBN5Kh
         YnaA==
X-Gm-Message-State: AOAM531AxWG8NiqEZpTt3miAKnvqzwqEptE0Hi5b86r7MAb5+2zUOjJj
        dpXqHsaLJnMlGT5OxR1nNX8=
X-Google-Smtp-Source: ABdhPJwCXSqdwMkCQZsXal2crQQWR98zbphS4yicQNFgIHWV5pxzLPOZK8vm2mS23eM0Wni0199Z0w==
X-Received: by 2002:aa7:db57:: with SMTP id n23mr6880663edt.235.1593014378708;
        Wed, 24 Jun 2020 08:59:38 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id rl16sm15749189ejb.33.2020.06.24.08.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:59:38 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com
Subject: [PATCH net-next] net: dsa: felix: support half-duplex link modes
Date:   Wed, 24 Jun 2020 18:59:26 +0300
Message-Id: <20200624155926.3379373-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
This is a resend (no changes) of:
https://patchwork.ozlabs.org/project/netdev/patch/20200531122640.1375715-12-olteanv@gmail.com/
(which in itself was a resend, link to original in that link)

It was extracted out of that series since that's now entangled with
other development, but this could be applied separately.

 drivers/net/dsa/ocelot/felix.c         |  4 +++-
 drivers/net/dsa/ocelot/felix_vsc9959.c | 13 ++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 25046777c993..55b4129a1f9d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -194,14 +194,16 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
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
index 2067776773f7..f5e8df584073 100644
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

