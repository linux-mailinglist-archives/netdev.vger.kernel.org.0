Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF763760F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiKXKP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiKXKPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:15:15 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0328AC2878
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:15:15 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9G4-0004Ie-1x; Thu, 24 Nov 2022 11:15:04 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9G0-0000jX-Dp; Thu, 24 Nov 2022 11:15:01 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oy9Fz-00E4WX-L8; Thu, 24 Nov 2022 11:14:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v6 2/6] net: dsa: microchip: do not store max MTU for all ports
Date:   Thu, 24 Nov 2022 11:14:54 +0100
Message-Id: <20221124101458.3353902-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124101458.3353902-1-o.rempel@pengutronix.de>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have global MTU configuration, it is enough to configure it on CPU
port only.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 14 +++++---------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 602d00671bef..f6e7968ab105 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -45,19 +45,15 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 
 int ksz9477_change_mtu(struct ksz_device *dev, int port, int mtu)
 {
-	u16 frame_size, max_frame = 0;
-	int i;
-
-	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+	u16 frame_size;
 
-	/* Cache the per-port MTU setting */
-	dev->ports[port].max_frame = frame_size;
+	if (!dsa_is_cpu_port(dev->ds, port))
+		return 0;
 
-	for (i = 0; i < dev->info->port_cnt; i++)
-		max_frame = max(max_frame, dev->ports[i].max_frame);
+	frame_size = mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 
 	return regmap_update_bits(dev->regmap[1], REG_SW_MTU__2,
-				  REG_SW_MTU_MASK, max_frame);
+				  REG_SW_MTU_MASK, frame_size);
 }
 
 static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 27c26ee15af4..61228be299f9 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -95,7 +95,6 @@ struct ksz_port {
 
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
-	u16 max_frame;
 	u32 rgmii_tx_val;
 	u32 rgmii_rx_val;
 	struct ksz_device *ksz_dev;
-- 
2.30.2

