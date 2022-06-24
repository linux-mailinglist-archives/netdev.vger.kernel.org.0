Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90045559A01
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 14:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbiFXM7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 08:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiFXM7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 08:59:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538E952537
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 05:59:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itu-00076H-Dv; Fri, 24 Jun 2022 14:59:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itq-002Qlg-SN; Fri, 24 Jun 2022 14:59:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4itr-00H4Ph-Md; Fri, 24 Jun 2022 14:59:03 +0200
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
Subject: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause stats
Date:   Fri, 24 Jun 2022 14:59:01 +0200
Message-Id: <20220624125902.4068436-2-o.rempel@pengutronix.de>
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

Add support for pause stats and fix rx_packets/tx_packets calculation.

Pause packets are counted by raw.rx64byte/raw.tx64byte counters, so
subtract it from main rx_packets/tx_packets counters.

tx_/rx_bytes are not affected.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index fb3fe74abfe6..82412f54c432 100644
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
@@ -625,9 +627,11 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
 	stats->tx_bytes += raw.txbyte;
 
 	stats->rx_packets += raw.rx64byte + raw.rx128byte + raw.rx256byte +
-		raw.rx512byte + raw.rx1024byte + raw.rx1518byte + raw.rxmaxbyte;
+		raw.rx512byte + raw.rx1024byte + raw.rx1518byte +
+		raw.rxmaxbyte - raw.rxpause;
 	stats->tx_packets += raw.tx64byte + raw.tx128byte + raw.tx256byte +
-		raw.tx512byte + raw.tx1024byte + raw.tx1518byte + raw.txmaxbyte;
+		raw.tx512byte + raw.tx1024byte + raw.tx1518byte +
+		raw.txmaxbyte - raw.txpause;
 
 	stats->rx_length_errors += raw.rxrunt + raw.rxfragment + raw.rxtoolong;
 	stats->rx_crc_errors += raw.rxfcserr;
@@ -646,6 +650,9 @@ static void ar9331_read_stats(struct ar9331_sw_port *port)
 	stats->multicast += raw.rxmulti;
 	stats->collisions += raw.txcollision;
 
+	pstats->tx_pause_frames += raw.txpause;
+	pstats->rx_pause_frames += raw.rxpause;
+
 	spin_unlock(&port->stats_lock);
 }
 
@@ -670,6 +677,17 @@ static void ar9331_get_stats64(struct dsa_switch *ds, int port,
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
@@ -679,6 +697,7 @@ static const struct dsa_switch_ops ar9331_sw_ops = {
 	.phylink_mac_link_down	= ar9331_sw_phylink_mac_link_down,
 	.phylink_mac_link_up	= ar9331_sw_phylink_mac_link_up,
 	.get_stats64		= ar9331_get_stats64,
+	.get_pause_stats	= ar9331_get_pause_stats,
 };
 
 static irqreturn_t ar9331_sw_irq(int irq, void *data)
-- 
2.30.2

