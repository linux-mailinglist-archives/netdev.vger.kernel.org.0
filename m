Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BC450DE4D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbiDYK6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbiDYK6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:58:14 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1AC83011;
        Mon, 25 Apr 2022 03:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650884111; x=1682420111;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uJjtuUjEHKtNUzXPem1AHLqZCBAdmUhreUZZ3hnvK5w=;
  b=VGxkXhvaGetwd/nHJtr+gubjGIU+m1Esib2iK3GdE4i5ULivUC0ZQmjQ
   pTL3O4tZDTKAiBo7ctHe2JW5V5cA3Jsep6fqxYA7rNE+3B3R4KOWkNT0+
   Iw1pFTK8A3jDMM7CVVTTfSKvIoAj6wA2mNAIX1Hu+tK1RDLr0mVyBch0P
   KgnKtOoSakQXbHRICQCH6a75ypvHtc+xO8kIEBChInS/1zOcm46yPup22
   9rdJlIxo1KjG6p/L3CeLec42kUXRNm9pktGVISeBWep0IyjKmTH0WEmgO
   INMzTwMRlP02RBbP7Oci4VvNVOb1SfeXMFTq4Z9FZqYavSuVzfa5f5vJE
   A==;
X-IronPort-AV: E=Sophos;i="5.90,287,1643698800"; 
   d="scan'208";a="161602965"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2022 03:55:10 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 25 Apr 2022 03:55:09 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 25 Apr 2022 03:55:05 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [RFC Patch net-next] net: dsa: ksz9477: move get_stats64 to ksz_common.c
Date:   Mon, 25 Apr 2022 16:25:00 +0530
Message-ID: <20220425105500.20899-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mib counters for the ksz9477 is same for the ksz9477 switch and
LAN937x switch. Hence moving it to ksz_common.c file in order to have it
generic function. The DSA hook get_stats64 now can call ksz_get_stats64.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 98 +-------------------------
 drivers/net/dsa/microchip/ksz_common.c | 96 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  3 +
 3 files changed, 101 insertions(+), 96 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4f617fee9a4e..48c90e4cda30 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -65,100 +65,6 @@ static const struct {
 	{ 0x83, "tx_discards" },
 };
 
-struct ksz9477_stats_raw {
-	u64 rx_hi;
-	u64 rx_undersize;
-	u64 rx_fragments;
-	u64 rx_oversize;
-	u64 rx_jabbers;
-	u64 rx_symbol_err;
-	u64 rx_crc_err;
-	u64 rx_align_err;
-	u64 rx_mac_ctrl;
-	u64 rx_pause;
-	u64 rx_bcast;
-	u64 rx_mcast;
-	u64 rx_ucast;
-	u64 rx_64_or_less;
-	u64 rx_65_127;
-	u64 rx_128_255;
-	u64 rx_256_511;
-	u64 rx_512_1023;
-	u64 rx_1024_1522;
-	u64 rx_1523_2000;
-	u64 rx_2001;
-	u64 tx_hi;
-	u64 tx_late_col;
-	u64 tx_pause;
-	u64 tx_bcast;
-	u64 tx_mcast;
-	u64 tx_ucast;
-	u64 tx_deferred;
-	u64 tx_total_col;
-	u64 tx_exc_col;
-	u64 tx_single_col;
-	u64 tx_mult_col;
-	u64 rx_total;
-	u64 tx_total;
-	u64 rx_discards;
-	u64 tx_discards;
-};
-
-static void ksz9477_r_mib_stats64(struct ksz_device *dev, int port)
-{
-	struct rtnl_link_stats64 *stats;
-	struct ksz9477_stats_raw *raw;
-	struct ksz_port_mib *mib;
-
-	mib = &dev->ports[port].mib;
-	stats = &mib->stats64;
-	raw = (struct ksz9477_stats_raw *)mib->counters;
-
-	spin_lock(&mib->stats64_lock);
-
-	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast;
-	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast;
-
-	/* HW counters are counting bytes + FCS which is not acceptable
-	 * for rtnl_link_stats64 interface
-	 */
-	stats->rx_bytes = raw->rx_total - stats->rx_packets * ETH_FCS_LEN;
-	stats->tx_bytes = raw->tx_total - stats->tx_packets * ETH_FCS_LEN;
-
-	stats->rx_length_errors = raw->rx_undersize + raw->rx_fragments +
-		raw->rx_oversize;
-
-	stats->rx_crc_errors = raw->rx_crc_err;
-	stats->rx_frame_errors = raw->rx_align_err;
-	stats->rx_dropped = raw->rx_discards;
-	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
-		stats->rx_frame_errors  + stats->rx_dropped;
-
-	stats->tx_window_errors = raw->tx_late_col;
-	stats->tx_fifo_errors = raw->tx_discards;
-	stats->tx_aborted_errors = raw->tx_exc_col;
-	stats->tx_errors = stats->tx_window_errors + stats->tx_fifo_errors +
-		stats->tx_aborted_errors;
-
-	stats->multicast = raw->rx_mcast;
-	stats->collisions = raw->tx_total_col;
-
-	spin_unlock(&mib->stats64_lock);
-}
-
-static void ksz9477_get_stats64(struct dsa_switch *ds, int port,
-			       struct rtnl_link_stats64 *s)
-{
-	struct ksz_device *dev = ds->priv;
-	struct ksz_port_mib *mib;
-
-	mib = &dev->ports[port].mib;
-
-	spin_lock(&mib->stats64_lock);
-	memcpy(s, &mib->stats64, sizeof(*s));
-	spin_unlock(&mib->stats64_lock);
-}
-
 static void ksz_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set)
 {
 	regmap_update_bits(dev->regmap[0], addr, bits, set ? bits : 0);
@@ -1462,7 +1368,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
 	.port_mirror_del	= ksz9477_port_mirror_del,
-	.get_stats64		= ksz9477_get_stats64,
+	.get_stats64		= ksz_get_stats64,
 	.port_change_mtu	= ksz9477_change_mtu,
 	.port_max_mtu		= ksz9477_max_mtu,
 };
@@ -1653,7 +1559,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.port_setup = ksz9477_port_setup,
 	.r_mib_cnt = ksz9477_r_mib_cnt,
 	.r_mib_pkt = ksz9477_r_mib_pkt,
-	.r_mib_stat64 = ksz9477_r_mib_stats64,
+	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.shutdown = ksz9477_reset_switch,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9b9f570ebb0b..10f127b09e58 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -20,6 +20,102 @@
 
 #include "ksz_common.h"
 
+struct ksz_stats_raw {
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
+void ksz_r_mib_stats64(struct ksz_device *dev, int port)
+{
+	struct rtnl_link_stats64 *stats;
+	struct ksz_stats_raw *raw;
+	struct ksz_port_mib *mib;
+
+	mib = &dev->ports[port].mib;
+	stats = &mib->stats64;
+	raw = (struct ksz_stats_raw *)mib->counters;
+
+	spin_lock(&mib->stats64_lock);
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
+	spin_unlock(&mib->stats64_lock);
+}
+EXPORT_SYMBOL_GPL(ksz_r_mib_stats64);
+
+void ksz_get_stats64(struct dsa_switch *ds, int port,
+		     struct rtnl_link_stats64 *s)
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
+EXPORT_SYMBOL_GPL(ksz_get_stats64);
+
 void ksz_update_port_member(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4d978832c448..28cda79b090f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -151,6 +151,9 @@ int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
+void ksz_r_mib_stats64(struct ksz_device *dev, int port);
+void ksz_get_stats64(struct dsa_switch *ds, int port,
+		     struct rtnl_link_stats64 *s);
 
 /* Common DSA access functions */
 
-- 
2.33.0

