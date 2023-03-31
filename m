Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7B26D1472
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCaA4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCaAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EAC10A82
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jrn6cGCEToVRuwA/NoEFJON5CK6kATc25/oMJqS+RlM=; b=Xxqbnik4JcB1sE05tDaqZgydab
        Jd/IhZs1pJ/2MmDDgyRtdGdjbMH3XoVjbFAIJ7CpBVA78ysSTr+M8BQfybdKb7qDDqokmI3Drn9yQ
        OPbZUAnK/jjmHkAYWqqiKNvHYORSkiBQZ1vloqBhwO7skSOFhCED2Y0khKtxf4rx1kgQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xKX-Hf; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 07/24] net: marvell: mvneta: Simplify EEE configuration
Date:   Fri, 31 Mar 2023 02:55:01 +0200
Message-Id: <20230331005518.2134652-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylib already does most of the work. It will track eee_enabled,
eee_active and tx_lpi_enabled and correctly set them in the
ethtool_get_eee callback.

Replace the call to phy_init_eee() by looking at the value of
eee_active passed to the mac_set_eee callback.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
v2: Use eee_active parameter, which is race free.
    Remove handling of tx_lpi_enabled, leave it to phylib.
v3: Add mac_set_eee() callback.
---
 drivers/net/ethernet/marvell/mvneta.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0e39d199ff06..fba9edad9e37 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -536,10 +536,6 @@ struct mvneta_port {
 	struct mvneta_bm_pool *pool_short;
 	int bm_win_id;
 
-	bool eee_enabled;
-	bool eee_active;
-	bool tx_lpi_enabled;
-
 	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
 
 	u32 indir[MVNETA_RSS_LU_TABLE_SIZE];
@@ -4170,7 +4166,6 @@ static void mvneta_mac_link_down(struct phylink_config *config,
 		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
 	}
 
-	pp->eee_active = false;
 	mvneta_set_eee(pp, false);
 }
 
@@ -4220,11 +4215,15 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 	}
 
 	mvneta_port_up(pp);
+}
 
-	if (phy && pp->eee_enabled) {
-		pp->eee_active = phy_init_eee(phy, false) >= 0;
-		mvneta_set_eee(pp, pp->eee_active && pp->tx_lpi_enabled);
-	}
+static void mvneta_mac_set_eee(struct phylink_config *config,
+			       bool eee_active)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct mvneta_port *pp = netdev_priv(ndev);
+
+	mvneta_set_eee(pp, eee_active);
 }
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
@@ -4234,6 +4233,7 @@ static const struct phylink_mac_ops mvneta_phylink_ops = {
 	.mac_finish = mvneta_mac_finish,
 	.mac_link_down = mvneta_mac_link_down,
 	.mac_link_up = mvneta_mac_link_up,
+	.mac_set_eee = mvneta_mac_set_eee,
 };
 
 static int mvneta_mdio_probe(struct mvneta_port *pp)
@@ -5028,9 +5028,6 @@ static int mvneta_ethtool_get_eee(struct net_device *dev,
 
 	lpi_ctl0 = mvreg_read(pp, MVNETA_LPI_CTRL_0);
 
-	eee->eee_enabled = pp->eee_enabled;
-	eee->eee_active = pp->eee_active;
-	eee->tx_lpi_enabled = pp->tx_lpi_enabled;
 	eee->tx_lpi_timer = (lpi_ctl0) >> 8; // * scale;
 
 	return phylink_ethtool_get_eee(pp->phylink, eee);
@@ -5053,11 +5050,6 @@ static int mvneta_ethtool_set_eee(struct net_device *dev,
 	lpi_ctl0 |= eee->tx_lpi_timer << 8;
 	mvreg_write(pp, MVNETA_LPI_CTRL_0, lpi_ctl0);
 
-	pp->eee_enabled = eee->eee_enabled;
-	pp->tx_lpi_enabled = eee->tx_lpi_enabled;
-
-	mvneta_set_eee(pp, eee->tx_lpi_enabled && eee->eee_enabled);
-
 	return phylink_ethtool_set_eee(pp->phylink, eee);
 }
 
-- 
2.40.0

