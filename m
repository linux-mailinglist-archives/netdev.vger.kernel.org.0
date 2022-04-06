Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA17D4F66BE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbiDFRPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbiDFROd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:14:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D32184270
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BDbYnTS0oTHfNb+Yu5s/Nzh1/TaiMZpWAo7vfLU9G5A=; b=ul37fOcGJxV3Zg/+WyhP/4e7Z2
        k8foi0+QqiT2WPKNxNYfBQZzWNsShObr32XbAxnY9Na7lGKKLzoJ/8H5mEc6q+UgtE7bwiw3ul1dS
        QDBzD2GI2y047fEFVZ5VKbmUSShAce8tmYitbYDBbGFygIVQZbKlTK7UKZdKx/lMn+8HdT4HA9eG7
        o3yGqxgnaQpOOv2R7pCo5Dr3ujNEZWBfQ7OsQgxk8jA4qZcnsxgyYpD4M6MKclCQQjbYINA3iILm7
        csu0MZhMam9lFWDCjTWiasSnZgWysSWJfNkHlAHiXZagLT0fqD7FatyDdUzI6qbn0IjRljs2DeZuH
        bEHc9HnQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60672 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nc6ki-0002ux-UY; Wed, 06 Apr 2022 15:35:20 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nc6ki-004ijw-1O; Wed, 06 Apr 2022 15:35:20 +0100
In-Reply-To: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
References: <Yk2k9D40QojsRhoo@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH RFC net-next 05/12] net: mtk_eth_soc: correct 802.3z duplex
 setting
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nc6ki-004ijw-1O@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 06 Apr 2022 15:35:20 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink does not guarantee that state->duplex will be set correctly in
the mac_config() call, so it's a bug that the driver makes use of it.

Move the 802.3z PCS duplex configuration to mac_link_up().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 16 +++++++++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 22 +++++++++++++++------
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e491d43f049a..6fedfa8fceb1 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -482,8 +482,18 @@ static void mtk_mac_link_up(struct phylink_config *config,
 {
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
-	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
+	u32 mcr;
+
+	if (phy_interface_mode_is_8023z(interface)) {
+		struct mtk_eth *eth = mac->hw;
+
+		/* Decide how GMAC and SGMIISYS be mapped */
+		int sid = (MTK_HAS_CAPS(eth->soc->caps, MTK_SHARED_SGMII)) ?
+			   0 : mac->id;
+		mtk_sgmii_link_up(eth->sgmii, sid, speed, duplex);
+	}
 
+	mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr &= ~(MAC_MCR_SPEED_100 | MAC_MCR_SPEED_1000 |
 		 MAC_MCR_FORCE_DPX | MAC_MCR_FORCE_TX_FC |
 		 MAC_MCR_FORCE_RX_FC);
@@ -2972,9 +2982,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	mac->phylink_config.dev = &eth->netdev[id]->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
-	/* This driver makes use of state->speed/state->duplex in
-	 * mac_config
-	 */
+	/* This driver makes use of state->speed in mac_config */
 	mac->phylink_config.legacy_pre_march2020 = true;
 	mac->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index f31ef594008a..1912f84922c8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1007,6 +1007,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *np,
 int mtk_sgmii_setup_mode_an(struct mtk_sgmii *ss, int id);
 int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 			       const struct phylink_link_state *state);
+void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex);
 void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id);
 
 int mtk_gmac_sgmii_path_setup(struct mtk_eth *eth, int mac_id);
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 16e66c0cb557..a5ec61e13b85 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -82,14 +82,10 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 	val &= ~SGMII_AN_ENABLE;
 	regmap_write(ss->regmap[id], SGMSYS_PCS_CONTROL_1, val);
 
-	/* SGMII force mode setting */
+	/* Set the speed etc but leave the duplex unchanged */
 	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
-	val &= ~SGMII_IF_MODE_MASK;
+	val &= SGMII_DUPLEX_FULL | ~SGMII_IF_MODE_MASK;
 	val |= SGMII_SPEED_1000;
-
-	if (state->duplex == DUPLEX_FULL)
-		val |= SGMII_DUPLEX_FULL;
-
 	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
 
 	/* Release PHYA power down state */
@@ -100,6 +96,20 @@ int mtk_sgmii_setup_mode_force(struct mtk_sgmii *ss, int id,
 	return 0;
 }
 
+/* For 1000BASE-X and 2500BASE-X interface modes */
+void mtk_sgmii_link_up(struct mtk_sgmii *ss, int id, int speed, int duplex)
+{
+	unsigned int val;
+
+	/* SGMII force duplex setting */
+	regmap_read(ss->regmap[id], SGMSYS_SGMII_MODE, &val);
+	val &= ~SGMII_DUPLEX_FULL;
+	if (duplex == DUPLEX_FULL)
+		val |= SGMII_DUPLEX_FULL;
+
+	regmap_write(ss->regmap[id], SGMSYS_SGMII_MODE, val);
+}
+
 void mtk_sgmii_restart_an(struct mtk_eth *eth, int mac_id)
 {
 	struct mtk_sgmii *ss = eth->sgmii;
-- 
2.30.2

