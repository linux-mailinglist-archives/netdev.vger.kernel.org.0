Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE454BA29A
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 15:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiBQOHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 09:07:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiBQOHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 09:07:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10D1C7EB7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 06:07:40 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKhRQ-0000BX-Gc; Thu, 17 Feb 2022 15:07:28 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nKhRP-0012Y2-EA; Thu, 17 Feb 2022 15:07:27 +0100
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
Subject: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: export HW stats over stats64 interface
Date:   Thu, 17 Feb 2022 15:07:26 +0100
Message-Id: <20220217140726.248071-1-o.rempel@pengutronix.de>
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

Provide access to HW offloaded packets over stats64 interface.
The rx/tx_bytes values needed some fixing since HW is accounting size of
the Ethernet frame together with FCS.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c | 83 +++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a85d990896b0..d0990f536a36 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -64,6 +64,88 @@ static const struct {
 	{ 0x83, "tx_discards" },
 };
 
+struct ksz9477_stats_raw {
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
+	u64 rx_1523_2000;
+	u64 rx_2001;
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
+	u64 rx_total;
+	u64 tx_total;
+	u64 rx_discards;
+	u64 tx_discards;
+};
+
+static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
+				struct rtnl_link_stats64 *stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz9477_stats_raw *raw;
+	struct ksz_port_mib *mib;
+	int ret;
+
+	mib = &dev->ports[port].mib;
+	raw = (struct ksz9477_stats_raw *)mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast;
+	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast;
+
+	/* HW counters are counting bytes + FCS which is not acceptable
+	 * for rtnl_link_stats64 interface
+	 */
+	stats->rx_bytes = raw->rx_total - stats->rx_packets * ETH_FCS_LEN;
+	stats->tx_bytes = raw->tx_total - stats->tx_packets * ETH_FCS_LEN;
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
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -1365,6 +1447,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
+	.get_stats64		= ksz9477_get_stats64,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
-- 
2.30.2

