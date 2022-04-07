Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742674F8AD4
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiDGWwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiDGWwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:52:54 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9081829CB6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=arHGN8UkCeGwwL2dYvMXiUiFyNwCU9rXAcjFck0SCx0=; b=xBwKc0/Ak98HOCrBcMA37CEO3t
        E7QuZp/YcvmtktUNjq76g/W+VuNll2d6V+3vr0d9h0e/pKZuMx6ZigiC4xEdSLviWrVPjOT6O9e7u
        3BeKg8+Cd+WeL7XVAtjORaLoCCb/fGuf/BdeX4hU5M1w067/FF81rvgSAmuNUlKJBChw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncaxk-00EjHm-0A; Fri, 08 Apr 2022 00:50:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v0 RFC RFT net-next 4/5] net: dsa: sja1105: Convert to mdiobus_c45_read
Date:   Fri,  8 Apr 2022 00:50:22 +0200
Message-Id: <20220407225023.3510609-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407225023.3510609-1-andrew@lunn.ch>
References: <20220407225023.3510609-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop using the helpers to construct a special phy address which
indicates C45. Instead use the C45 accessors, which will call the
busses C45 specific read/write API.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b33841c6507a..72b6fc1932b5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2252,14 +2252,13 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 	 * change it through the dynamic interface later.
 	 */
 	for (i = 0; i < ds->num_ports; i++) {
-		u32 reg_addr = mdiobus_c45_addr(MDIO_MMD_VEND2, MDIO_CTRL1);
-
 		speed_mbps[i] = sja1105_port_speed_to_ethtool(priv,
 							      mac[i].speed);
 		mac[i].speed = priv->info->port_speed[SJA1105_SPEED_AUTO];
 
 		if (priv->xpcs[i])
-			bmcr[i] = mdiobus_read(priv->mdio_pcs, i, reg_addr);
+			bmcr[i] = mdiobus_c45_read(priv->mdio_pcs, i,
+						   MDIO_MMD_VEND2, MDIO_CTRL1);
 	}
 
 	/* No PTP operations can run right now */
-- 
2.35.1

