Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8C68EDDB
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjBHLYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBHLYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:24:08 -0500
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FE31ADF1
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:24:01 -0800 (PST)
X-QQ-mid: bizesmtp83t1675855333tqlmoazp
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 08 Feb 2023 19:22:11 +0800 (CST)
X-QQ-SSF: 01400000002000C0E000B00A0000000
X-QQ-FEAT: +ynUkgUhZJkgxBW25sgaiH/6+7B8q4hv7dUbmG0IJXh+FcLwy8TJioLF9lJc4
        i+qkeJQGYAtgftz4SDjv9+M4Lq5UcfLVXneqXU7H9hVHpgNVYAEHH9qcCf9bJRPa1pQqkOd
        S8tJICcyYfOTZlEOGMkReFWc91aFitazJX9a8h/NpkwcJng7F2zEGVtzXhxh7/GEnqbfL+U
        2mpNWYr1oqwZDbs6mHqps3b+XDWp5jGd9H1pZ/kxTpnV1Z7lfDrXfMoIXBL322HPn5EeCMr
        DPTuZbQbrTbSgl0XyRmC5EjieOsUEGZ1aPmOim3rV0VAOPgRTenPSi3xYmYXvRZe1qltvzU
        xLLnC8uA/58XqeL6/GYdip5VLGODZBl0JxqHGnGQqRJkyVxfdeW0kVCjcwakg==
X-QQ-GoodBg: 2
From:   Guan Wentao <guanwentao@uniontech.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Guan Wentao <guanwentao@uniontech.com>
Subject: [PATCH] net: stmmac: get phydev->interface from mac for mdio phy init
Date:   Wed,  8 Feb 2023 19:20:54 +0800
Message-Id: <20230208112054.22965-1-guanwentao@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy->interface from mdiobus_get_phy is default from phy_device_create.
In some phy devices like at803x, we need the correct value to init delay.
Use priv->plat->interface to init if we know.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Guan Wentao <guanwentao@uniontech.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..1dc9c7f3d714 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1162,6 +1162,12 @@ static int stmmac_init_phy(struct net_device *dev)
 			return -ENODEV;
 		}
 
+		/* If we know the interface, it defines which PHY interface */
+		if (priv->plat->interface > 0) {
+			phydev->interface = priv->plat->interface;
+			netdev_dbg(priv->dev, "Override default phy interface\n");
+		}
+
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-- 
2.20.1

