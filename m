Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A89359BE25
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiHVLEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiHVLEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:04:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73221286FF
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:04:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dx-0005QF-2K; Mon, 22 Aug 2022 13:04:05 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dv-001HmF-UA; Mon, 22 Aug 2022 13:04:03 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Ds-009h02-Gw; Mon, 22 Aug 2022 13:04:00 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 13/17] net: dsa: microchip: ksz9477: use internal_phy instead of phy_port_cnt
Date:   Mon, 22 Aug 2022 13:03:54 +0200
Message-Id: <20220822110358.2310055-14-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822110358.2310055-1-o.rempel@pengutronix.de>
References: <20220822110358.2310055-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With code refactoring was introduced new variable internal_phy. Let's
use it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index cb5bd0ceb8df4..2982c8cb0983c 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -291,7 +291,7 @@ int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 	 * For RGMII PHY there is no way to access it so the fixed PHY should
 	 * be used.  For SGMII PHY the supporting code will be added later.
 	 */
-	if (addr >= dev->phy_port_cnt) {
+	if (!dev->info->internal_phy[addr]) {
 		struct ksz_port *p = &dev->ports[addr];
 
 		switch (reg) {
@@ -339,7 +339,7 @@ int ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 int ksz9477_w_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 val)
 {
 	/* No real PHY after this. */
-	if (addr >= dev->phy_port_cnt)
+	if (!dev->info->internal_phy[addr])
 		return 0;
 
 	return ksz_pwrite16(dev, addr, 0x100 + (reg << 1), val);
@@ -888,7 +888,7 @@ static phy_interface_t ksz9477_get_interface(struct ksz_device *dev, int port)
 	phy_interface_t interface;
 	bool gbit;
 
-	if (port < dev->phy_port_cnt)
+	if (dev->info->internal_phy[port])
 		return PHY_INTERFACE_MODE_NA;
 
 	gbit = ksz_get_gbit(dev, port);
@@ -995,7 +995,7 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	/* enable 802.1p priority */
 	ksz_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
 
-	if (port < dev->phy_port_cnt) {
+	if (dev->info->internal_phy[port]) {
 		/* do not force flow control */
 		ksz_port_cfg(dev, port, REG_PORT_CTRL_0,
 			     PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
@@ -1018,7 +1018,7 @@ void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
 	ksz9477_cfg_port_member(dev, port, member);
 
 	/* clear pending interrupts */
-	if (port < dev->phy_port_cnt)
+	if (dev->info->internal_phy[port])
 		ksz_pread16(dev, port, REG_PORT_PHY_INT_ENABLE, &data16);
 }
 
@@ -1081,7 +1081,7 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
 
 		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
-		if (i < dev->phy_port_cnt)
+		if (dev->info->internal_phy[i])
 			p->phy = 1;
 		if (dev->chip_id == 0x00947700 && i == 6) {
 			p->sgmii = 1;
@@ -1177,15 +1177,9 @@ int ksz9477_switch_init(struct ksz_device *dev)
 	if (ret)
 		return ret;
 
-	/* Number of ports can be reduced depending on chip. */
-	dev->phy_port_cnt = 5;
-
-	if (dev->chip_id == KSZ9893_CHIP_ID) {
+	if (dev->chip_id == KSZ9893_CHIP_ID)
 		dev->features |= IS_9893;
 
-		dev->phy_port_cnt = 2;
-	}
-
 	return 0;
 }
 
-- 
2.30.2

