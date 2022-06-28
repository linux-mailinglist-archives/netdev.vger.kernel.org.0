Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A25655C605
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245612AbiF1IwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244301AbiF1IwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:52:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966702F65E
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:52:10 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o66x1-0003rq-Fd; Tue, 28 Jun 2022 10:52:03 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66wx-003Ael-7g; Tue, 28 Jun 2022 10:52:02 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o66wz-00As6t-VH; Tue, 28 Jun 2022 10:52:01 +0200
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
Subject: [PATCH net-next v2 2/4] net: dsa: ar9331: add support for pause stats
Date:   Tue, 28 Jun 2022 10:51:53 +0200
Message-Id: <20220628085155.2591201-3-o.rempel@pengutronix.de>
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

Add support for pause stats.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index fb3fe74abfe6..b286e4e9c2c4 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -231,6 +231,7 @@ struct ar9331_sw_port {
 	int idx;
 	struct delayed_work mib_read;
 	struct rtnl_link_stats64 stats;
+	struct ethtool_pause_stats pause_stats;
 	struct spinlock stats_lock;
 };
 
@@ -606,6 +607,7 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_switch *ds, int port,
 static void ar9331_read_stats(struct ar9331_sw_port *port)
 {
 	struct ar9331_sw_priv *priv = ar9331_sw_port_to_priv(port);
+	struct ethtool_pause_stats *pstats = &port->pause_stats;
 	struct rtnl_link_stats64 *stats = &port->stats;
 	struct ar9331_sw_stats_raw raw;
 	int ret;
@@ -646,6 +648,9 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
 	stats->multicast += raw.rxmulti;
 	stats->collisions += raw.txcollision;
 
+	pstats->tx_pause_frames += raw.txpause;
+	pstats->rx_pause_frames += raw.rxpause;
+
 	spin_unlock(&port->stats_lock);
 }
 
@@ -670,6 +675,17 @@ static void ar9331_get_stats64(struct dsa_switch *ds, int port,
 	spin_unlock(&p->stats_lock);
 }
 
+static void ar9331_get_pause_stats(struct dsa_switch *ds, int port,
+				   struct ethtool_pause_stats *pause_stats)
+{
+	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
+	struct ar9331_sw_port *p = &priv->port[port];
+
+	spin_lock(&p->stats_lock);
+	memcpy(pause_stats, &p->pause_stats, sizeof(*pause_stats));
+	spin_unlock(&p->stats_lock);
+}
+
 static const struct dsa_switch_ops ar9331_sw_ops = {
 	.get_tag_protocol	= ar9331_sw_get_tag_protocol,
 	.setup			= ar9331_sw_setup,
@@ -679,6 +695,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
 	.get_stats64		= ar9331_get_stats64,
+	.get_pause_stats	= ar9331_get_pause_stats,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.30.2

