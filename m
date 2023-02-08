Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38BA668EF39
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 13:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBHMmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 07:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBHMmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 07:42:32 -0500
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2102729
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 04:42:27 -0800 (PST)
X-QQ-mid: bizesmtp77t1675860056tso805bk
Received: from localhost.localdomain ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 08 Feb 2023 20:40:54 +0800 (CST)
X-QQ-SSF: 01400000002000C0E000B00A0000000
X-QQ-FEAT: 3M0okmaRx3jmgcz4hYfpmUXK8ue06MHIp1jsI+1nr/Jbd8I+sZC8SmjemoglJ
        guBpXt5vqyZ51KN7TPkY1Br65zF7JIPHR4KZ13uJ+h/sCDb0ePOFjPVtxV6evJV8Kgah0B4
        ieSOyzEg+BStW0Cm+xgto/MywWcdt8S8lxg9IN7QddyipwxSwVZE4gLAp7ODRBe5fLgv3WV
        hRQpqOQu/xpKfK97fDiq5lZnlCZ05GcxuDAtZGQtjnTpg+7hMBbrYgCaXQOPhTki1vTwVBI
        VCxc6Kcpsu+gHc7LVbmIDe6x/zq5bZ10kosEE3qrAAx6GFXFML/y/Ikg4FnvBpy5RlIwMyv
        r7AVOxvgJkI/tw2V+dqaPA1DsMxNRNTUkwh4pk3jYTqHPfWLtSyAxqvWElPknDu9AX2BSGf
        IMAtvlweaBs=
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
Date:   Wed,  8 Feb 2023 20:40:25 +0800
Message-Id: <20230208124025.5828-1-guanwentao@uniontech.com>
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
In some phy devices like at803x, use phy->interface to init rgmii delay.
Use plat->phy_interface to init if know from stmmac_probe_config_dt.

Fixes: 74371272f97f ("net: stmmac: Convert to phylink and remove phylib logic")
Signed-off-by: Guan Wentao <guanwentao@uniontech.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..debfcb045c22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1162,6 +1162,12 @@ static int stmmac_init_phy(struct net_device *dev)
 			return -ENODEV;
 		}
 
+		/* If we know the interface, it defines which PHY interface */
+		if (priv->plat->phy_interface > 0) {
+			phydev->interface = priv->plat->phy_interface;
+			netdev_dbg(priv->dev, "Override default phy interface\n");
+		}
+
 		ret = phylink_connect_phy(priv->phylink, phydev);
 	}
 
-- 
2.20.1

