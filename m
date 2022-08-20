Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CB59B0AA
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 00:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiHTWAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 18:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiHTWAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 18:00:14 -0400
X-Greylist: delayed 1341 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 Aug 2022 15:00:09 PDT
Received: from mail.base45.de (mail.base45.de [IPv6:2001:67c:2050:320::77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0BA13E09;
        Sat, 20 Aug 2022 15:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jbV1371i5Ukeh0rbH2uM6B5K8Dm+kdefS/HHp+Iyam4=; b=nWoYvl5DQgAKhWm4gpfKp7TPPX
        rWZ16GPPdw/DL2LVABuYgIUb50pjhC1vcajpjVQhryNhy6/kPMUGuVLw7gZUpnaBasbuQhGub9ui0
        kctA4MO7YWTbhJ7a8nyvNEk+osvL2RPfQMztWE9GKLgCK9Za+dKY8QZtmM17b578APSY2OOMvDw0K
        BlO0ihNHu7ySvM88PZvmC8OId9L7z+89j+0g5kE2w4ZXZBNLgIFEDPJcKTC+aSbo4EKokgaSGQwWu
        /soeKX8WkH2Urs6HL1MhVIfTHXKYFnVzu0gtU1DNWh70n9yHZAzkGFY4/jbZN9HCdliYiHoHs/yHp
        RWD+Xytg==;
Received: from [2a02:2454:9869:1a:9eb6:54ff:0:fa5] (helo=cerator.lan)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oPW9p-00G1Te-HM; Sat, 20 Aug 2022 21:37:29 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [PATCH 1/2] net: mt7531: only do PLL once after the reset
Date:   Sat, 20 Aug 2022 23:37:06 +0200
Message-Id: <20220820213707.46138-1-lynxis@fe80.eu>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the PLL init of the switch out of the pad configuration of the port
6 (usally cpu port).

Fix a unidirectional 100 mbit limitation on 1 gbit or 2.5 gbit links for
outbound traffic on port 5 or port 6.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
---
 drivers/net/dsa/mt7530.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 835807911be0..95a57aeb466e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -506,14 +506,19 @@ static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 static int
 mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
-	struct mt7530_priv *priv = ds->priv;
+	return 0;
+}
+
+static void
+mt7531_pll_setup(struct mt7530_priv *priv)
+{
 	u32 top_sig;
 	u32 hwstrap;
 	u32 xtal;
 	u32 val;
 
 	if (mt7531_dual_sgmii_supported(priv))
-		return 0;
+		return;
 
 	val = mt7530_read(priv, MT7531_CREV);
 	top_sig = mt7530_read(priv, MT7531_TOP_SIG_SR);
@@ -592,8 +597,6 @@ mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 	val |= EN_COREPLL;
 	mt7530_write(priv, MT7531_PLLGP_EN, val);
 	usleep_range(25, 35);
-
-	return 0;
 }
 
 static void
@@ -2331,6 +2334,8 @@ mt7531_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7531_pll_setup(priv);
+
 	if (mt7531_dual_sgmii_supported(priv)) {
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5_SGMII;
 
@@ -2887,8 +2892,6 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	case 6:
 		interface = PHY_INTERFACE_MODE_2500BASEX;
 
-		mt7531_pad_setup(ds, interface);
-
 		priv->p6_interface = interface;
 		break;
 	default:
-- 
2.35.1

