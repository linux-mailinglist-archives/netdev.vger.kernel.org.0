Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE36869A47B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjBQDnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjBQDm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1EC159
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gPiBwEoL8fK6/gtjB6C+nLzgT6H0xrCI1mH5IZul55A=; b=yVzibHylapHaBNW5taVEWYt24f
        98+oaQfH722wGbN7K1eyTZUjc0TWPbs4yrFHiMWdCHrJ2HGoO8TtlnXO78nKa11qBDnPdmTpUjObC
        fiD9VHt3j6WzGtwgMYQ8DhaXgafWkGV3szxeXfSpZGOn1i2R4Xbw78WhedlC7hH7EOJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6B-0Y; Fri, 17 Feb 2023 04:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 03/18] net: marvell: mvneta: Simplify EEE configuration
Date:   Fri, 17 Feb 2023 04:42:15 +0100
Message-Id: <20230217034230.1249661-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylib already does most of the work. It will track eee_enabled and
eee_active and correctly set them in the ethtool_get_eee callback.

Replace the call to phy_init_eee() by looking at the
phydev->eee_active member.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvneta.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 0e39d199ff06..519a08354442 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -536,8 +536,6 @@ struct mvneta_port {
 	struct mvneta_bm_pool *pool_short;
 	int bm_win_id;
 
-	bool eee_enabled;
-	bool eee_active;
 	bool tx_lpi_enabled;
 
 	u64 ethtool_stats[ARRAY_SIZE(mvneta_statistics)];
@@ -4170,7 +4168,6 @@ static void mvneta_mac_link_down(struct phylink_config *config,
 		mvreg_write(pp, MVNETA_GMAC_AUTONEG_CONFIG, val);
 	}
 
-	pp->eee_active = false;
 	mvneta_set_eee(pp, false);
 }
 
@@ -4221,10 +4218,8 @@ static void mvneta_mac_link_up(struct phylink_config *config,
 
 	mvneta_port_up(pp);
 
-	if (phy && pp->eee_enabled) {
-		pp->eee_active = phy_init_eee(phy, false) >= 0;
-		mvneta_set_eee(pp, pp->eee_active && pp->tx_lpi_enabled);
-	}
+	if (phy)
+		mvneta_set_eee(pp, phy->eee_active && pp->tx_lpi_enabled);
 }
 
 static const struct phylink_mac_ops mvneta_phylink_ops = {
@@ -5028,8 +5023,6 @@ static int mvneta_ethtool_get_eee(struct net_device *dev,
 
 	lpi_ctl0 = mvreg_read(pp, MVNETA_LPI_CTRL_0);
 
-	eee->eee_enabled = pp->eee_enabled;
-	eee->eee_active = pp->eee_active;
 	eee->tx_lpi_enabled = pp->tx_lpi_enabled;
 	eee->tx_lpi_timer = (lpi_ctl0) >> 8; // * scale;
 
@@ -5053,7 +5046,6 @@ static int mvneta_ethtool_set_eee(struct net_device *dev,
 	lpi_ctl0 |= eee->tx_lpi_timer << 8;
 	mvreg_write(pp, MVNETA_LPI_CTRL_0, lpi_ctl0);
 
-	pp->eee_enabled = eee->eee_enabled;
 	pp->tx_lpi_enabled = eee->tx_lpi_enabled;
 
 	mvneta_set_eee(pp, eee->tx_lpi_enabled && eee->eee_enabled);
-- 
2.39.1

