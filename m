Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35963A7C0
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 13:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiK1MC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 07:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiK1MAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 07:00:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4222618B3F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 04:00:49 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoU-0005Mj-1A; Mon, 28 Nov 2022 13:00:42 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoS-000oBt-EU; Mon, 28 Nov 2022 13:00:41 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ozcoP-00H6TM-03; Mon, 28 Nov 2022 13:00:37 +0100
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
Subject: [PATCH v1 25/26] net: dsa: microchip: remove ksz_port:on variable
Date:   Mon, 28 Nov 2022 13:00:33 +0100
Message-Id: <20221128120034.4075562-26-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221128120034.4075562-1-o.rempel@pengutronix.de>
References: <20221128120034.4075562-1-o.rempel@pengutronix.de>
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

The only place where this variable would be set to false is the
ksz8_config_cpu_port() function. But it is done in a bogus way:

 	for (i = 0; i < dev->phy_port_cnt; i++) {
		if (i == dev->phy_port_cnt) <--- will be never executed.
			break;
		p->on = 1;

So, we never have a situation where p->on = 0. In this case, we can just
remove it.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz8795.c    | 20 +-------------------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index ea08bdea193e..618366fadfb5 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -952,7 +952,6 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 {
 	u8 learn[DSA_MAX_PORTS];
 	int first, index, cnt;
-	struct ksz_port *p;
 	const u16 *regs;
 
 	regs = dev->info->regs;
@@ -966,9 +965,6 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 		cnt = dev->info->port_cnt;
 	}
 	for (index = first; index < cnt; index++) {
-		p = &dev->ports[index];
-		if (!p->on)
-			continue;
 		ksz_pread8(dev, index, regs[P_STP_CTRL], &learn[index]);
 		if (!(learn[index] & PORT_LEARN_DISABLE))
 			ksz_pwrite8(dev, index, regs[P_STP_CTRL],
@@ -976,9 +972,6 @@ void ksz8_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 	ksz_cfg(dev, S_FLUSH_TABLE_CTRL, SW_FLUSH_DYN_MAC_TABLE, true);
 	for (index = first; index < cnt; index++) {
-		p = &dev->ports[index];
-		if (!p->on)
-			continue;
 		if (!(learn[index] & PORT_LEARN_DISABLE))
 			ksz_pwrite8(dev, index, regs[P_STP_CTRL], learn[index]);
 	}
@@ -1368,25 +1361,14 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 
 	ksz_cfg(dev, regs[S_TAIL_TAG_CTRL], masks[SW_TAIL_TAG_ENABLE], true);
 
-	p = &dev->ports[dev->cpu_port];
-	p->on = 1;
-
 	ksz8_port_setup(dev, dev->cpu_port, true);
 
 	for (i = 0; i < dev->phy_port_cnt; i++) {
-		p = &dev->ports[i];
-
 		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
-
-		/* Last port may be disabled. */
-		if (i == dev->phy_port_cnt)
-			break;
-		p->on = 1;
 	}
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
-		if (!p->on)
-			continue;
+
 		if (!ksz_is_ksz88x3(dev)) {
 			ksz_pread8(dev, i, regs[P_REMOTE_STATUS], &remote);
 			if (remote & KSZ8_PORT_FIBER_MODE)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 055d61ff3fb8..504ad07842a0 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -87,7 +87,6 @@ struct ksz_port {
 	int stp_state;
 	struct phy_device phydev;
 
-	u32 on:1;			/* port is not disabled by hardware */
 	u32 fiber:1;			/* port is fiber */
 	u32 force:1;
 	u32 read:1;			/* read MIB counters in background */
-- 
2.30.2

