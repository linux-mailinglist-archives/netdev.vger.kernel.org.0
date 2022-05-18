Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D952BE41
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbiEROzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiEROz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:55:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9315631222
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JQJfZSE9kledh/qBXxdYmqroe+XEFKxmmVfowX+wP4c=; b=MrZxYcYU+qewDWLhSICZfotgt5
        cvpwzKz6YyrUsQujcUw4PVKbanRrcQ8bqVvjL4AvKEK+X1W5Z3SxsHOAlKO1Y2eLnYDp9xxUA+P/4
        zpYYlCoD9ST0fenW5VtTXEtp7yvEVG5lnTeKPt0SlHVPz5CrgR88ZDBowwNB+ZN2Gop/mYzXNNO15
        GiIGvmAfy5F0embGoI3R2t7GdkMFNyhzXgsIBNA9MCAJiH8/AOZZ80okvTD9scZnOGslCN3U+SRFE
        ZLOnG0JWcWsZsC40hVKHcl97nv04sVsTkeH3T36tQsp/HCBoOZ2GMCXm+lc04EICqHFbEFzD4ABnr
        isuAIKPQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38628 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nrL53-0002Gb-UA; Wed, 18 May 2022 15:55:18 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nrL53-00AM5X-QI; Wed, 18 May 2022 15:55:17 +0100
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 10/12] net: mtk_eth_soc: move restoration of SYSCFG0
 to mac_finish()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nrL53-00AM5X-QI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 May 2022 15:55:17 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SGMIISYS configuration is performed while ETHSYS_SYSCFG0 is in a
disabled state. In order to preserve this when we switch to phylink_pcs
we need to move the restoration of this register to the mac_finish()
callback.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 11 +++++++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d9947faa2cd3..6dca98de0067 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -400,8 +400,8 @@ static void mtk_mac_config(struct phylink_config *config, unsigned int mode,
 		if (err)
 			goto init_err;
 
-		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
-				   SYSCFG0_SGMII_MASK, val);
+		/* Save the syscfg0 value for mac_finish */
+		mac->syscfg0 = val;
 	} else if (phylink_autoneg_inband(mode)) {
 		dev_err(eth->dev,
 			"In-band mode not supported in non SGMII mode!\n");
@@ -425,8 +425,15 @@ static int mtk_mac_finish(struct phylink_config *config, unsigned int mode,
 {
 	struct mtk_mac *mac = container_of(config, struct mtk_mac,
 					   phylink_config);
+	struct mtk_eth *eth = mac->hw;
 	u32 mcr_cur, mcr_new;
 
+	/* Enable SGMII */
+	if (interface == PHY_INTERFACE_MODE_SGMII ||
+	    phy_interface_mode_is_8023z(interface))
+		regmap_update_bits(eth->ethsys, ETHSYS_SYSCFG0,
+				   SYSCFG0_SGMII_MASK, mac->syscfg0);
+
 	/* Setup gmac */
 	mcr_cur = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
 	mcr_new = mcr_cur;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index fa3c085bf7ed..1ad5c26f01fb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -1001,6 +1001,7 @@ struct mtk_mac {
 	struct mtk_hw_stats		*hw_stats;
 	__be32				hwlro_ip[MTK_MAX_LRO_IP_CNT];
 	int				hwlro_ip_cnt;
+	unsigned int			syscfg0;
 };
 
 /* the struct describing the SoC. these are declared in the soc_xyz.c files */
-- 
2.30.2

