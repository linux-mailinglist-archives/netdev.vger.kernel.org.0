Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95B155C97F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343628AbiF1IwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245246AbiF1IwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:52:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD56C2F663
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:52:11 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o66x2-0003sA-DF; Tue, 28 Jun 2022 10:52:04 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66wy-003Aep-1D; Tue, 28 Jun 2022 10:52:03 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66x0-00As72-OT; Tue, 28 Jun 2022 10:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next v2 3/4] net: dsa: microchip: add pause stats support
Date:   Tue, 28 Jun 2022 10:51:54 +0200
Message-Id: <20220628085155.2591201-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628085155.2591201-1-o.rempel@pengutronix.de>
References: <20220628085155.2591201-1-o.rempel@pengutronix.de>
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

Add support for pause specific stats.

Tested on ksz9477.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 19 +++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 59582eb3bcaf..7c221ec331ee 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -586,12 +586,14 @@ static void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 
 void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 {
+	struct ethtool_pause_stats *pstats;
 	struct rtnl_link_stats64 *stats;
 	struct ksz_stats_raw *raw;
 	struct ksz_port_mib *mib;
 
 	mib = &dev->ports[port].mib;
 	stats = &mib->stats64;
+	pstats = &mib->pause_stats;
 	raw = (struct ksz_stats_raw *)mib->counters;
 
 	spin_lock(&mib->stats64_lock);
@@ -623,6 +625,9 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 	stats->multicast = raw->rx_mcast;
 	stats->collisions = raw->tx_total_col;
 
+	pstats->tx_pause_frames = raw->tx_pause;
+	pstats->rx_pause_frames = raw->rx_pause;
+
 	spin_unlock(&mib->stats64_lock);
 }
 
@@ -639,6 +644,19 @@ static void ksz_get_stats64(struct dsa_switch *ds, int port,
 	spin_unlock(&mib->stats64_lock);
 }
 
+static void ksz_get_pause_stats(struct dsa_switch *ds, int port,
+				struct ethtool_pause_stats *pause_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib;
+
+	mib = &dev->ports[port].mib;
+
+	spin_lock(&mib->stats64_lock);
+	memcpy(pause_stats, &mib->pause_stats, sizeof(*pause_stats));
+	spin_unlock(&mib->stats64_lock);
+}
+
 static void ksz_get_strings(struct dsa_switch *ds, int port,
 			    u32 stringset, uint8_t *buf)
 {
@@ -1248,6 +1266,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_mirror_add	= ksz_port_mirror_add,
 	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
+	.get_pause_stats	= ksz_get_pause_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 0e7f15efbb79..28846566028d 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -25,6 +25,7 @@ struct ksz_port_mib {
 	u8 cnt_ptr;
 	u64 *counters;
 	struct rtnl_link_stats64 stats64;
+	struct ethtool_pause_stats pause_stats;
 	struct spinlock stats64_lock;
 };
 
-- 
2.30.2

