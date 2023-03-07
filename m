Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270F76AE589
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbjCGP4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbjCGP4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:56:08 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B3E8F530;
        Tue,  7 Mar 2023 07:55:37 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pZZf5-0001rV-2X;
        Tue, 07 Mar 2023 16:55:35 +0100
Date:   Tue, 7 Mar 2023 15:53:58 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH net-next v12 08/18] net: ethernet: mtk_eth_soc: fix
 1000Base-X and 2500Base-X modes
Message-ID: <fd5c7ea79a7f84caac7d0b64b39fe5c4043edfa8.1678201958.git.daniel@makrotopia.org>
References: <cover.1678201958.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1678201958.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After conversion to phylink_pcs the 1000Base-X and 2500Base-X modes
would work only after `ethtool -s eth1 autoneg off`.
As ethtool autoneg and the ETHTOOL_LINK_MODE_Autoneg_BIT is supposed
to control auto-negotiation on the external interface it doesn't make
much sense to use it to control on-board SGMII auto-negotiation between
MAC and PHY.
Set correct values to really only enable SGMII auto-negotiation when
actually operating in SGMII mode. For 1000Base-X and 2500Base-X mode,
enable remote-fault detection only if in-band-status is enabled.
This fixes using 1000Base-X and 2500Base-X SFPs on the BananaPi R3
board and also makes it possible to use interface-mode-switching PHYs
operating in either SGMII mode for 10M/100M/1000M or in 2500Base-X for
2500M mode on other boards.

Fixes: 14a44ab0330d ("net: mtk_eth_soc: partially convert to phylink_pcs")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 24 +++++------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 61bd9986466a..58d8cb3aa7f4 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -38,9 +38,9 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 			  const unsigned long *advertising,
 			  bool permit_pause_to_mac)
 {
-	bool mode_changed = false, changed, use_an;
 	struct mtk_pcs *mpcs = pcs_to_mtk_pcs(pcs);
-	unsigned int rgc3, sgm_mode, bmcr;
+	unsigned int rgc3, sgm_mode = 0, bmcr = 0;
+	bool mode_changed = false, changed;
 	int advertise, link_timer;
 
 	advertise = phylink_mii_c22_pcs_encode_advertisement(interface,
@@ -55,27 +55,13 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	if (interface == PHY_INTERFACE_MODE_SGMII) {
 		sgm_mode = SGMII_IF_MODE_SGMII;
 		if (phylink_autoneg_inband(mode)) {
+			bmcr = SGMII_AN_ENABLE;
 			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
 				    SGMII_SPEED_DUPLEX_AN;
-			use_an = true;
-		} else {
-			use_an = false;
 		}
-	} else if (phylink_autoneg_inband(mode)) {
-		/* 1000base-X or 2500base-X autoneg */
-		sgm_mode = SGMII_REMOTE_FAULT_DIS;
-		use_an = linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-					   advertising);
-	} else {
+	} else if (!phylink_autoneg_inband(mode)) {
 		/* 1000base-X or 2500base-X without autoneg */
-		sgm_mode = 0;
-		use_an = false;
-	}
-
-	if (use_an) {
-		bmcr = SGMII_AN_ENABLE;
-	} else {
-		bmcr = 0;
+		sgm_mode = SGMII_REMOTE_FAULT_DIS;
 	}
 
 	if (mpcs->interface != interface) {
-- 
2.39.2

