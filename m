Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6892F5BB521
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 03:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiIQBAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 21:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIQBAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 21:00:11 -0400
X-Greylist: delayed 2557 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 18:00:09 PDT
Received: from mail.base45.de (mail.base45.de [80.241.60.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3E72A254;
        Fri, 16 Sep 2022 18:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=fe80.eu;
        s=20190804; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dseKqDACf4EBVzoILiaSlts5zxldN3mGG1VKvgSWzOs=; b=cxNuqnbquVn9+k32ZGCj1glD6s
        M24xU4O0SrJVzP1A8crXG0q6bq+V2xfdzUc4w5NSkT+j14xNsICqMI/+rD5jLUpML5tZuqJXt4uB8
        SaoanFIGV30Mc4kzY3USeonpCnbekEPjSpwm6t4eUuxadteQB8oTH1oWWDB50cdkDN+60lHLL6tOG
        /H5tCUrNmHhHJGDKFk8FemhvPnLot6uU7gxM9n2P1DKi9wgrehrW7xC2dTLKnouELhDfojdKrPV2R
        wqZEQPfIWKWBmpkxkY6VSSeol6detNvnYiOeygzvw0hVhFzPZ1DywQReDqyOWo6pQpnn4jgNb0rpB
        Dz1JYevQ==;
Received: from p4fd2bf05.dip0.t-ipconnect.de ([79.210.191.5] helo=localhost.localdomain)
        by mail.base45.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lynxis@fe80.eu>)
        id 1oZLND-000nP7-J4; Sat, 17 Sep 2022 00:07:55 +0000
From:   Alexander Couzens <lynxis@fe80.eu>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Alexander Couzens <lynxis@fe80.eu>, stable@vger.kernel.org,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/2] net: mt7531: only do PLL once after the reset
Date:   Sat, 17 Sep 2022 02:07:33 +0200
Message-Id: <20220917000734.520253-2-lynxis@fe80.eu>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220917000734.520253-1-lynxis@fe80.eu>
References: <20220917000734.520253-1-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the PLL init of the switch out of the pad configuration of the port
6 (usally cpu port).

Fix a unidirectional 100 mbit limitation on 1 gbit or 2.5 gbit links for
outbound traffic on port 5 or port 6.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Cc: stable@vger.kernel.org
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
2.37.3

