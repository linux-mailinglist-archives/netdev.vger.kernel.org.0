Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7236E6560B5
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiLZHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiLZHOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:14:36 -0500
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 209FE2DC3;
        Sun, 25 Dec 2022 23:14:35 -0800 (PST)
X-IronPort-AV: E=Sophos;i="5.96,274,1665414000"; 
   d="scan'208";a="144515790"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 26 Dec 2022 16:14:33 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 4762C4003FDF;
        Mon, 26 Dec 2022 16:14:33 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH net-next 3/3] net: ethernet: renesas: rswitch: Add phy_power_{on,off}() calling
Date:   Mon, 26 Dec 2022 16:14:25 +0900
Message-Id: <20221226071425.3895915-4-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
References: <20221226071425.3895915-1-yoshihiro.shimoda.uh@renesas.com>
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

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/rswitch.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index ca79ee168206..2f335c95f5a8 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1180,6 +1180,10 @@ static void rswitch_mac_link_down(struct phylink_config *config,
 				  unsigned int mode,
 				  phy_interface_t interface)
 {
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	phy_power_off(rdev->serdes);
 }
 
 static void rswitch_mac_link_up(struct phylink_config *config,
@@ -1187,7 +1191,11 @@ static void rswitch_mac_link_up(struct phylink_config *config,
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

