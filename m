Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A297E559A04
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 14:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiFXM7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 08:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbiFXM7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 08:59:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B405252C
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 05:59:14 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itu-00076J-Dv; Fri, 24 Jun 2022 14:59:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itr-002Qlm-7y; Fri, 24 Jun 2022 14:59:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itr-00H4Pt-ND; Fri, 24 Jun 2022 14:59:03 +0200
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
Subject: [PATCH net-next v1 3/3] net: dsa: microchip: add pause stats support
Date:   Fri, 24 Jun 2022 14:59:02 +0200
Message-Id: <20220624125902.4068436-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624125902.4068436-1-o.rempel@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
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
 drivers/net/dsa/microchip/ksz9477.c    |  1 +
 drivers/net/dsa/microchip/ksz_common.c | 19 +++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  3 +++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab40b700cf1a..8c31fb0fe1fd 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1351,6 +1351,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
+	.get_pause_stats	= ksz_get_pause_stats,
 	.port_change_mtu	= ksz9477_change_mtu,
 	.port_max_mtu		= ksz9477_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9ca8c8d7740f..1022affb45aa 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -461,12 +461,14 @@ EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
 
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
@@ -498,6 +500,9 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 	stats->multicast = raw->rx_mcast;
 	stats->collisions = raw->tx_total_col;
 
+	pstats->tx_pause_frames = raw->tx_pause;
+	pstats->rx_pause_frames = raw->rx_pause;
+
 	spin_unlock(&mib->stats64_lock);
 }
 EXPORT_SYMBOL_GPL(ksz_r_mib_stats64);
@@ -516,6 +521,20 @@ void ksz_get_stats64(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_get_stats64);
 
+void ksz_get_pause_stats(struct dsa_switch *ds, int port,
+			 struct ethtool_pause_stats *pause_stats)
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
+EXPORT_SYMBOL_GPL(ksz_get_pause_stats);
+
 void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 8500eaedad67..5d81faf81c1b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -25,6 +25,7 @@ struct ksz_port_mib {
 	u8 cnt_ptr;
 	u64 *counters;
 	struct rtnl_link_stats64 stats64;
+	struct ethtool_pause_stats pause_stats;
 	struct spinlock stats64_lock;
 };
 
@@ -200,6 +201,8 @@ void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_get_stats64(struct dsa_switch *ds, int port,
 		     struct rtnl_link_stats64 *s);
+void ksz_get_pause_stats(struct dsa_switch *ds, int port,
+			 struct ethtool_pause_stats *pause_stats);
 void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 			  struct phylink_config *config);
 extern const struct ksz_chip_data ksz_switch_chips[];
-- 
2.30.2

