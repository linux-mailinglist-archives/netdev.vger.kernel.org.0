Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7D6B0287
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjCHJM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjCHJMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:12:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD43D0A6
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:12:50 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZpqj-0005dN-JU; Wed, 08 Mar 2023 10:12:41 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pZpqh-002gNf-IC; Wed, 08 Mar 2023 10:12:39 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pZpqg-00EcKx-No; Wed, 08 Mar 2023 10:12:38 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v2 1/2] net: dsa: microchip: add ksz_setup_tc_mode() function
Date:   Wed,  8 Mar 2023 10:12:36 +0100
Message-Id: <20230308091237.3483895-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230308091237.3483895-1-o.rempel@pengutronix.de>
References: <20230308091237.3483895-1-o.rempel@pengutronix.de>
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

Add ksz_setup_tc_mode() to make queue scheduling and shaping
configuration more visible.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 20 ++++++++++++--------
 drivers/net/dsa/microchip/ksz_common.h |  6 ++----
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 48e35a1d110e..ae05fe0b0a81 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -32,10 +32,6 @@
 #include "ksz9477.h"
 #include "lan937x.h"
 
-#define KSZ_CBS_ENABLE ((MTI_SCHEDULE_STRICT_PRIO << MTI_SCHEDULE_MODE_S) | \
-			(MTI_SHAPING_SRP << MTI_SHAPING_S))
-#define KSZ_CBS_DISABLE ((MTI_SCHEDULE_WRR << MTI_SCHEDULE_MODE_S) |\
-			 (MTI_SHAPING_OFF << MTI_SHAPING_S))
 #define MIB_COUNTER_NUM 0x20
 
 struct ksz_stats_raw {
@@ -3119,6 +3115,14 @@ static int cinc_cal(s32 idle_slope, s32 send_slope, u32 *bw)
 	return 0;
 }
 
+static int ksz_setup_tc_mode(struct ksz_device *dev, int port, u8 scheduler,
+			     u8 shaper)
+{
+	return ksz_pwrite8(dev, port, REG_PORT_MTI_QUEUE_CTRL_0,
+			   FIELD_PREP(MTI_SCHEDULE_MODE_M, scheduler) |
+			   FIELD_PREP(MTI_SHAPING_M, shaper));
+}
+
 static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
 			    struct tc_cbs_qopt_offload *qopt)
 {
@@ -3138,8 +3142,8 @@ static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
 		return ret;
 
 	if (!qopt->enable)
-		return ksz_pwrite8(dev, port, REG_PORT_MTI_QUEUE_CTRL_0,
-				   KSZ_CBS_DISABLE);
+		return ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_WRR,
+					 MTI_SHAPING_OFF);
 
 	/* High Credit */
 	ret = ksz_pwrite16(dev, port, REG_PORT_MTI_HI_WATER_MARK,
@@ -3164,8 +3168,8 @@ static int ksz_setup_tc_cbs(struct dsa_switch *ds, int port,
 			return ret;
 	}
 
-	return ksz_pwrite8(dev, port, REG_PORT_MTI_QUEUE_CTRL_0,
-			   KSZ_CBS_ENABLE);
+	return ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_STRICT_PRIO,
+				 MTI_SHAPING_SRP);
 }
 
 static int ksz_setup_tc(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 10c732b1cea8..f53834bbe896 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -662,12 +662,10 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define REG_PORT_MTI_QUEUE_CTRL_0	0x0914
 
-#define MTI_SCHEDULE_MODE_M		0x3
-#define MTI_SCHEDULE_MODE_S		6
+#define MTI_SCHEDULE_MODE_M		GENMASK(7, 6)
 #define MTI_SCHEDULE_STRICT_PRIO	0
 #define MTI_SCHEDULE_WRR		2
-#define MTI_SHAPING_M			0x3
-#define MTI_SHAPING_S			4
+#define MTI_SHAPING_M			GENMASK(5, 4)
 #define MTI_SHAPING_OFF			0
 #define MTI_SHAPING_SRP			1
 #define MTI_SHAPING_TIME_AWARE		2
-- 
2.30.2

