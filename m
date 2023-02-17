Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D11469A479
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjBQDnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBQDm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:56 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A9C83C6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IKXfikYVEQK0YiYSa8fL5WQqzVqNY3QKUY67lWqb7F4=; b=dlF5hWoyUFpmAsAK57JN5qn3fY
        5uUUtfOKkoRh03Atw9N7BfzI5C1qra3kyKFM2B1mzKHdZvOWm0nql8jnF1vRmNNyJ7jlAUehw2LxK
        ylY3DeKmhjmewkPozXWcpOzguQXjbrKBhIgHf6gAeeSqENnDBwqesD9CB8kNoFRanDH4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6l-Bh; Fri, 17 Feb 2023 04:42:44 +0100
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
Subject: [PATCH RFC 12/18] net: dsa: mt7530: Call phylib for set_eee and get_eee
Date:   Fri, 17 Feb 2023 04:42:24 +0100
Message-Id: <20230217034230.1249661-13-andrew@lunn.ch>
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

phylib should be called in order to manage the EEE settings in the
PHY, and to return EEE status such are supported link modes, and what
the link peer supports.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 214450378978..a472353f14f8 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3124,10 +3124,13 @@ static int mt753x_get_mac_eee(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 eeecr = mt7530_read(priv, MT7530_PMEEECR_P(port));
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	e->tx_lpi_enabled = !(eeecr & LPI_MODE_EN);
 	e->tx_lpi_timer = GET_LPI_THRESH(eeecr);
 
+	if (dp->slave->phydev)
+		return phy_ethtool_get_eee(dp->slave->phydev, e);
 	return 0;
 }
 
@@ -3136,6 +3139,7 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 set, mask = LPI_THRESH_MASK | LPI_MODE_EN;
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (e->tx_lpi_timer > 0xFFF)
 		return -EINVAL;
@@ -3146,6 +3150,8 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 		set |= LPI_MODE_EN;
 	mt7530_rmw(priv, MT7530_PMEEECR_P(port), mask, set);
 
+	if (dp->slave->phydev)
+		return phy_ethtool_set_eee(dp->slave->phydev, e);
 	return 0;
 }
 
-- 
2.39.1

