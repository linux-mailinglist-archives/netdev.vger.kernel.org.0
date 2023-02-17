Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C5469A484
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjBQDnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjBQDm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A2310AA4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=v0MEiMWS+uXrX6lIdQ1G6bplK2FfCnGNtr94G+uxu9E=; b=IZBYPtmm6yMRzi/ciD4yx7w6h/
        a/Xbk5imBWRxy0SrbF4458CSG1yXc/whD60MWZ/Bt4IFwayt91VbDqMbkd6Yjo19PoC1exO92xKDS
        lgNUFnI3Oms8AjbDym4fL+C9UcpP9m9hRBlXvyyAWbZDYslrKtF3lLTeNRRvPHIQCbyk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6t-E8; Fri, 17 Feb 2023 04:42:44 +0100
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
Subject: [PATCH RFC 14/18] net: dsa: b53: Call phylib for set_eee and get_eee
Date:   Fri, 17 Feb 2023 04:42:26 +0100
Message-Id: <20230217034230.1249661-15-andrew@lunn.ch>
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
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 1e8eaf143b65..f782a08a9bc9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2179,6 +2179,7 @@ EXPORT_SYMBOL(b53_eee_init);
 
 int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 	u16 reg;
@@ -2190,12 +2191,15 @@ int b53_get_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	e->eee_enabled = p->eee_enabled;
 	e->eee_active = !!(reg & BIT(port));
 
+	if (dp->slave->phydev)
+		return phy_ethtool_get_eee(dp->slave->phydev, e);
 	return 0;
 }
 EXPORT_SYMBOL(b53_get_mac_eee);
 
 int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct b53_device *dev = ds->priv;
 	struct ethtool_eee *p = &dev->ports[port].eee;
 
@@ -2205,6 +2209,8 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 	p->eee_enabled = e->eee_enabled;
 	b53_eee_enable_set(ds, port, e->eee_enabled);
 
+	if (dp->slave->phydev)
+		return phy_ethtool_set_eee(dp->slave->phydev, e);
 	return 0;
 }
 EXPORT_SYMBOL(b53_set_mac_eee);
-- 
2.39.1

