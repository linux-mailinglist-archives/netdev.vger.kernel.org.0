Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5476422B8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 06:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiLEF3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 00:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiLEF3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 00:29:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA9D10B5F
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 21:29:15 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p242O-0005F6-28; Mon, 05 Dec 2022 06:29:08 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p242L-002OOZ-Tt; Mon, 05 Dec 2022 06:29:06 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1p242M-00BtW6-0P; Mon, 05 Dec 2022 06:29:06 +0100
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
Subject: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64 support for ksz8 series of switches
Date:   Mon,  5 Dec 2022 06:29:04 +0100
Message-Id: <20221205052904.2834962-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

Add stats64 support for ksz8xxx series of switches.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 87 ++++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  1 +
 2 files changed, 88 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index f39b041765fb..423f944cc34c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -70,6 +70,43 @@ struct ksz_stats_raw {
 	u64 tx_discards;
 };
 
+struct ksz88xx_stats_raw {
+	u64 rx;
+	u64 rx_hi;
+	u64 rx_undersize;
+	u64 rx_fragments;
+	u64 rx_oversize;
+	u64 rx_jabbers;
+	u64 rx_symbol_err;
+	u64 rx_crc_err;
+	u64 rx_align_err;
+	u64 rx_mac_ctrl;
+	u64 rx_pause;
+	u64 rx_bcast;
+	u64 rx_mcast;
+	u64 rx_ucast;
+	u64 rx_64_or_less;
+	u64 rx_65_127;
+	u64 rx_128_255;
+	u64 rx_256_511;
+	u64 rx_512_1023;
+	u64 rx_1024_1522;
+	u64 tx;
+	u64 tx_hi;
+	u64 tx_late_col;
+	u64 tx_pause;
+	u64 tx_bcast;
+	u64 tx_mcast;
+	u64 tx_ucast;
+	u64 tx_deferred;
+	u64 tx_total_col;
+	u64 tx_exc_col;
+	u64 tx_single_col;
+	u64 tx_mult_col;
+	u64 rx_discards;
+	u64 tx_discards;
+};
+
 static const struct ksz_mib_names ksz88xx_mib_names[] = {
 	{ 0x00, "rx" },
 	{ 0x01, "rx_hi" },
@@ -156,6 +193,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.w_phy = ksz8_w_phy,
 	.r_mib_cnt = ksz8_r_mib_cnt,
 	.r_mib_pkt = ksz8_r_mib_pkt,
+	.r_mib_stat64 = ksz88xx_r_mib_stats64,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.fdb_dump = ksz8_fdb_dump,
@@ -1583,6 +1621,55 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 	spin_unlock(&mib->stats64_lock);
 }
 
+void ksz88xx_r_mib_stats64(struct ksz_device *dev, int port)
+{
+	struct ethtool_pause_stats *pstats;
+	struct rtnl_link_stats64 *stats;
+	struct ksz88xx_stats_raw *raw;
+	struct ksz_port_mib *mib;
+
+	mib = &dev->ports[port].mib;
+	stats = &mib->stats64;
+	pstats = &mib->pause_stats;
+	raw = (struct ksz88xx_stats_raw *)mib->counters;
+
+	spin_lock(&mib->stats64_lock);
+
+	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast +
+		raw->rx_pause;
+	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast +
+		raw->tx_pause;
+
+	/* HW counters are counting bytes + FCS which is not acceptable
+	 * for rtnl_link_stats64 interface
+	 */
+	stats->rx_bytes = raw->rx + raw->rx_hi - stats->rx_packets * ETH_FCS_LEN;
+	stats->tx_bytes = raw->tx + raw->tx_hi - stats->tx_packets * ETH_FCS_LEN;
+
+	stats->rx_length_errors = raw->rx_undersize + raw->rx_fragments +
+		raw->rx_oversize;
+
+	stats->rx_crc_errors = raw->rx_crc_err;
+	stats->rx_frame_errors = raw->rx_align_err;
+	stats->rx_dropped = raw->rx_discards;
+	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
+		stats->rx_frame_errors  + stats->rx_dropped;
+
+	stats->tx_window_errors = raw->tx_late_col;
+	stats->tx_fifo_errors = raw->tx_discards;
+	stats->tx_aborted_errors = raw->tx_exc_col;
+	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
+		stats->tx_aborted_errors;
+
+	stats->multicast = raw->rx_mcast;
+	stats->collisions = raw->tx_total_col;
+
+	pstats->tx_pause_frames = raw->tx_pause;
+	pstats->rx_pause_frames = raw->rx_pause;
+
+	spin_unlock(&mib->stats64_lock);
+}
+
 static void ksz_get_stats64(struct dsa_switch *ds, int port,
 			    struct rtnl_link_stats64 *s)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index cb27f5a180c7..055d61ff3fb8 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -345,6 +345,7 @@ void ksz_switch_remove(struct ksz_device *dev);
 
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
+void ksz88xx_r_mib_stats64(struct ksz_device *dev, int port);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
-- 
2.30.2

