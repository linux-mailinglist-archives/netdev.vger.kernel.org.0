Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4129967E83C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbjA0O0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjA0O0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:26:35 -0500
Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2BFA4709F;
        Fri, 27 Jan 2023 06:26:32 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.97,251,1669042800"; 
   d="scan'208";a="150776286"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 27 Jan 2023 23:26:26 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 19FBF433ACC5;
        Fri, 27 Jan 2023 23:26:26 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add phy_power_{on,off}() calling
Date:   Fri, 27 Jan 2023 23:26:21 +0900
Message-Id: <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some Ethernet PHYs (like marvell10g) will decide the host interface
mode by the media-side speed. So, the rswitch driver needs to
initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
.init() for initializing all ports and .power_on() for initializing
each port. So, add phy_power_{on,off} calling for it.

Notes that in-band mode will not work because the initialization
is not completed. So, output error message if in-band mode.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index b9addbc29ef9..7bdfcb5270c0 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1143,12 +1143,20 @@ static void rswitch_mac_config(struct phylink_config *config,
 			       unsigned int mode,
 			       const struct phylink_link_state *state)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
+
+	if (mode == MLO_AN_INBAND)
+		netdev_err(ndev, "Link up/down will not work because in-band mode\n");
 }
 
 static void rswitch_mac_link_down(struct phylink_config *config,
 				  unsigned int mode,
 				  phy_interface_t interface)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	phy_power_off(rdev->serdes);
 }
 
 static void rswitch_mac_link_up(struct phylink_config *config,
@@ -1156,7 +1164,11 @@ static void rswitch_mac_link_up(struct phylink_config *config,
 				phy_interface_t interface, int speed,
 				int duplex, bool tx_pause, bool rx_pause)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
 	/* Current hardware cannot change speed at runtime */
+	phy_power_on(rdev->serdes);
 }
 
 static const struct phylink_mac_ops rswitch_phylink_ops = {
-- 
2.25.1

