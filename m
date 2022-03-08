Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B554D1513
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345964AbiCHKsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiCHKsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:48:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23605FFE
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 02:47:35 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRXNG-0006Eh-Tp; Tue, 08 Mar 2022 11:47:26 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nRXNF-00FLy7-Nj; Tue, 08 Mar 2022 11:47:25 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 1/1] net: dsa: microchip: ksz9477: implement MTU configuration
Date:   Tue,  8 Mar 2022 11:47:24 +0100
Message-Id: <20220308104724.3659317-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chips supports two ways to configure max MTU size:
- by setting SW_LEGAL_PACKET_DISABLE bit: if this bit is 0 allowed packed size
  will be between 64 and bytes 1518. If this bit is 1, it will accept
  packets up to 2000 bytes.
- by setting SW_JUMBO_PACKET bit. If this bit is set, the chip will
  ignore SW_LEGAL_PACKET_DISABLE value and use REG_SW_MTU__2 register to
  configure MTU size.

Current driver has disabled SW_JUMBO_PACKET bit and activates
SW_LEGAL_PACKET_DISABLE. So the switch will pass all packets up to 2000 without
any way to configure it.

By providing port_change_mtu we are switch to SW_JUMBO_PACKET way and will
be able to configure MTU up to ~9000.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
changes v3:
- do more testing and fix mtu configuration
changes v2:
- rename max_mtu to max_frame and new_mtu to frame_size
- use max() instead of if(>)
---
 drivers/net/dsa/microchip/ksz9477.c     | 35 +++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz9477_reg.h |  3 +++
 drivers/net/dsa/microchip/ksz_common.h  |  1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 94ad6d9504f4..3673a4d20b37 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -182,6 +182,29 @@ static void ksz9477_port_cfg32(struct ksz_device *dev, int port, int offset,
 			   bits, set ? bits : 0);
 }
 
+static int ksz9477_change_mtu(struct dsa_switch *ds, int port, int mtu)
+{
+	struct ksz_device *dev = ds->priv;
+	u16 frame_size, max_frame = 0;
+	int i;
+
+	frame_size = mtu + ETH_HLEN + ETH_FCS_LEN;
+
+	/* Cache the per-port MTU setting */
+	dev->ports[port].max_frame = frame_size;
+
+	for (i = 0; i < dev->port_cnt; i++)
+		max_frame = max(max_frame, dev->ports[i].max_frame);
+
+	return regmap_update_bits(dev->regmap[1], REG_SW_MTU__2,
+				  REG_SW_MTU_MASK, max_frame);
+}
+
+static int ksz9477_max_mtu(struct dsa_switch *ds, int port)
+{
+	return KSZ9477_MAX_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN;
+}
+
 static int ksz9477_wait_vlan_ctrl_ready(struct ksz_device *dev)
 {
 	unsigned int val;
@@ -1416,8 +1439,14 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	/* Do not work correctly with tail tagging. */
 	ksz_cfg(dev, REG_SW_MAC_CTRL_0, SW_CHECK_LENGTH, false);
 
-	/* accept packet up to 2000bytes */
-	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_LEGAL_PACKET_DISABLE, true);
+	/* Enable REG_SW_MTU__2 reg by setting SW_JUMBO_PACKET */
+	ksz_cfg(dev, REG_SW_MAC_CTRL_1, SW_JUMBO_PACKET, true);
+
+	/* Now we can configure default MTU value */
+	ret = regmap_update_bits(dev->regmap[1], REG_SW_MTU__2, REG_SW_MTU_MASK,
+				 ETH_FRAME_LEN + ETH_FCS_LEN);
+	if (ret)
+		return ret;
 
 	ksz9477_config_cpu_port(ds);
 
@@ -1464,6 +1493,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
 	.get_stats64		= ksz9477_get_stats64,
+	.port_change_mtu	= ksz9477_change_mtu,
+	.port_max_mtu		= ksz9477_max_mtu,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 16939f29faa5..0bd58467181f 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -176,6 +176,7 @@
 #define REG_SW_MAC_ADDR_5		0x0307
 
 #define REG_SW_MTU__2			0x0308
+#define REG_SW_MTU_MASK			GENMASK(13, 0)
 
 #define REG_SW_ISP_TPID__2		0x030A
 
@@ -1662,4 +1663,6 @@
 /* 148,800 frames * 67 ms / 100 */
 #define BROADCAST_STORM_VALUE		9969
 
+#define KSZ9477_MAX_FRAME_SIZE		9000
+
 #endif /* KSZ9477_REGS_H */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4ff0a159ce3c..fa39ee73cbd2 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -41,6 +41,7 @@ struct ksz_port {
 
 	struct ksz_port_mib mib;
 	phy_interface_t interface;
+	u16 max_frame;
 };
 
 struct ksz_device {
-- 
2.30.2

