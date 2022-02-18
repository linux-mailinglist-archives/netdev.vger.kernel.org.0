Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9605C4BB4A6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbiBRI4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:56:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiBRI4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:56:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81DD93183
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:56:06 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKz3W-0007qx-JH; Fri, 18 Feb 2022 09:55:58 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nKz3V-004ypS-0m; Fri, 18 Feb 2022 09:55:57 +0100
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
Subject: [PATCH net-next v2 1/1] net: dsa: microchip: ksz9477: export HW stats over stats64 interface
Date:   Fri, 18 Feb 2022 09:55:54 +0100
Message-Id: <20220218085554.1187089-1-o.rempel@pengutronix.de>
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
changes v2:
- fix locking issue in in atomic context
---
 drivers/net/dsa/microchip/ksz9477.c    | 100 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.c |   3 +
 drivers/net/dsa/microchip/ksz_common.h |   3 +
 3 files changed, 106 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a85d990896b0..e2d8b0898694 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -64,6 +64,103 @@ static const struct {
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
+static void ksz9477_r_mib_stats64(struct ksz_device *dev, int port)
+{
+	struct rtnl_link_stats64 *stats;
+	struct ksz9477_stats_raw raw;
+	struct ksz_port_mib *mib;
+
+	mib = &dev->ports[port].mib;
+	stats = &mib->stats64;
+
+	mutex_lock(&mib->cnt_mutex);
+	memcpy(&raw, mib->counters, sizeof(raw));
+	mutex_unlock(&mib->cnt_mutex);
+
+	spin_lock(&mib->stats64_lock);
+
+	stats->rx_packets = raw.rx_bcast + raw.rx_mcast + raw.rx_ucast;
+	stats->tx_packets = raw.tx_bcast + raw.tx_mcast + raw.tx_ucast;
+
+	/* HW counters are counting bytes + FCS which is not acceptable
+	 * for rtnl_link_stats64 interface
+	 */
+	stats->rx_bytes = raw.rx_total - stats->rx_packets * ETH_FCS_LEN;
+	stats->tx_bytes = raw.tx_total - stats->tx_packets * ETH_FCS_LEN;
+
+	stats->rx_length_errors = raw.rx_undersize + raw.rx_fragments +
+		raw.rx_oversize;
+
+	stats->rx_crc_errors = raw.rx_crc_err;
+	stats->rx_frame_errors = raw.rx_align_err;
+	stats->rx_dropped = raw.rx_discards;
+	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
+		stats->rx_frame_errors  + stats->rx_dropped;
+
+	stats->tx_window_errors = raw.tx_late_col;
+	stats->tx_fifo_errors = raw.tx_discards;
+	stats->tx_aborted_errors = raw.tx_exc_col;
+	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
+		stats->tx_aborted_errors;
+
+	stats->multicast = raw.rx_mcast;
+	stats->collisions = raw.tx_total_col;
+
+	spin_unlock(&mib->stats64_lock);
+}
+
+static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
+			       struct rtnl_link_stats64 *s)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib;
+
+	mib = &dev->ports[port].mib;
+
+	spin_lock(&mib->stats64_lock);
+	memcpy(s, &mib->stats64, sizeof(*s));
+	spin_unlock(&mib->stats64_lock);
+}
+
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -1365,6 +1462,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
+	.get_stats64		= ksz9477_get_stats64,
 };
 
 static u32 ksz9477_get_port_addr(int port, int offset)
@@ -1524,6 +1622,7 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	if (!dev->ports)
 		return -ENOMEM;
 	for (i = 0; i < dev->port_cnt; i++) {
+		spin_lock_init(&dev->ports[i].mib.stats64_lock);
 		mutex_init(&dev->ports[i].mib.cnt_mutex);
 		dev->ports[i].mib.counters =
 			devm_kzalloc(dev->dev,
@@ -1552,6 +1651,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.port_setup = ksz9477_port_setup,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
+	.r_mib_stat64 = ksz9477_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.shutdown = ksz9477_reset_switch,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7e33ec73f803..16fade9a088b 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -111,6 +111,9 @@ static void ksz_mib_read_work(struct work_struct *work)
 		port_r_cnt(dev, i);
 		p->read = false;
 		mutex_unlock(&mib->cnt_mutex);
+
+		if (dev->dev_ops->r_mib_stat64)
+			dev->dev_ops->r_mib_stat64(dev, i);
 	}
 
 	schedule_delayed_work(&dev->mib_read, dev->mib_read_interval);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3db63f62f0a1..c6fa487fb006 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -22,6 +22,8 @@ struct ksz_port_mib {
 	struct mutex cnt_mutex;		/* structure access */
 	u8 cnt_ptr;
 	u64 *counters;
+	struct rtnl_link_stats64 stats64;
+	struct spinlock stats64_lock;
 };
 
 struct ksz_port {
@@ -128,6 +130,7 @@ struct ksz_dev_ops {
 			  u64 *cnt);
 	void (*r_mib_pkt)(struct ksz_device *dev, int port, u16 addr,
 			  u64 *dropped, u64 *cnt);
+	void (*r_mib_stat64)(struct ksz_device *dev, int port);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
 	int (*shutdown)(struct ksz_device *dev);
-- 
2.30.2

