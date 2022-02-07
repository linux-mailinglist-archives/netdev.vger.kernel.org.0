Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FF14AC75C
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376858AbiBGR1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347982AbiBGRYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:24:07 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9644EC0401D5;
        Mon,  7 Feb 2022 09:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644254646; x=1675790646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w/JZqlKQOTQ72ycCiJ6at2Sa6bT/5IpfMb1yuC0M5ss=;
  b=Y/LyJN0k3zkBIpkdsJ4MSDaB/FX0uXE36KKC1sW2I6QtoK/aOE+AMrdx
   324L5jirUOMdac0ETQGYu5aZ84RdslzuGVh709vd7poiMTmAsAt2aDTej
   6GNDlF5a0kQRRUzuSZVc83q/XUJEDT2bmkiNblS6po6PHzAQtypaXbrMD
   WspAO0h2aeXFiQs7JNvsWepQp4qOXY4LWa7V4ReiB5EimhbprFa51W4if
   8GGYmXxrh+xpMb/woUYgpBRX/DoPRUU2UfZmWUSC6ui9o8KsLuuk6zZ5E
   vA3FXwKMfY3UA28ctQcL6w+8XFevODwhYywXXBhz4hKfRNc+hqBHKQLrz
   w==;
IronPort-SDR: bHcIWsUX6shFj40A1Wz/NGHH438+weOmbbneYcjvS0+5AI0vTAxS3XJrUrTHfjR69yU3e7CxDh
 FXKWLmF1qYvlYYQ/yK7wxHGbhjOoL9dznr4bdRy3A1jjv4B4DwJfRK+bFbl0kUcO7o31l6ISSe
 43Bu30Z7zcGLxh5xIBwfC7Fn5OAQ80lKZa6Ys8jucu0P5vEYzV+hbPkbvEtl2bY8DMhGvhDEN2
 GlRk0zGrGKuJJ0nJOS9EJkGMp58ePU9e18AQV9zxO3Ndahk+Yo/xjzNR3xRX+XWjEu/ht1hN9u
 mhOvIEA6HOZXqq1K3UC5AzsL
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="145147794"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2022 10:23:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 7 Feb 2022 10:23:02 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 7 Feb 2022 10:22:57 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v8 net-next 07/10] net: dsa: microchip: add support for ethtool port counters
Date:   Mon, 7 Feb 2022 22:52:01 +0530
Message-ID: <20220207172204.589190-8-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for get_eth_**_stats() (phy/mac/ctrl) and
get_stats64()

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 164 +++++++++++++++++++++++
 1 file changed, 164 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index bddb9ce41136..dfeb728bf737 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -45,6 +45,20 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_internal_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port, u32 stringset,
+				u8 *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++)
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -334,12 +348,162 @@ static void lan937x_phylink_get_caps(struct dsa_switch *ds, int port,
 	}
 }
 
+static void lan937x_get_eth_phy_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_sym_err];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_sym_err, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_mac_stats(struct dsa_switch *ds, int port,
+				      struct ethtool_eth_mac_stats *mac_stats)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		lan937x_r_mib_pkt(dev, port, mib->cnt_ptr,
+				  NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	mac_stats->FramesTransmittedOK = ctr[lan937x_mib_tx_mcast] +
+					 ctr[lan937x_mib_tx_bcast] +
+					 ctr[lan937x_mib_tx_ucast] +
+					 ctr[lan937x_mib_tx_pause];
+
+	mac_stats->SingleCollisionFrames = ctr[lan937x_mib_tx_single_col];
+	mac_stats->MultipleCollisionFrames = ctr[lan937x_mib_tx_mult_col];
+
+	mac_stats->FramesReceivedOK = ctr[lan937x_mib_rx_mcast] +
+				      ctr[lan937x_mib_rx_bcast] +
+				      ctr[lan937x_mib_rx_ucast] +
+				      ctr[lan937x_mib_rx_pause];
+
+	mac_stats->FrameCheckSequenceErrors = ctr[lan937x_mib_rx_crc_err];
+	mac_stats->AlignmentErrors = ctr[lan937x_mib_rx_align_err];
+	mac_stats->OctetsTransmittedOK = ctr[lan937x_mib_tx_total];
+	mac_stats->FramesWithDeferredXmissions = ctr[lan937x_mib_tx_deferred];
+	mac_stats->LateCollisions = ctr[lan937x_mib_tx_late_col];
+	mac_stats->FramesAbortedDueToXSColls = ctr[lan937x_mib_tx_exc_col];
+	mac_stats->FramesLostDueToIntMACXmitError = ctr[lan937x_mib_tx_discard];
+
+	mac_stats->OctetsReceivedOK = ctr[lan937x_mib_rx_total];
+	mac_stats->FramesLostDueToIntMACRcvError = ctr[lan937x_mib_rx_discard];
+	mac_stats->MulticastFramesXmittedOK = ctr[lan937x_mib_tx_mcast];
+	mac_stats->BroadcastFramesXmittedOK = ctr[lan937x_mib_tx_bcast];
+
+	mac_stats->MulticastFramesReceivedOK = ctr[lan937x_mib_rx_mcast];
+	mac_stats->BroadcastFramesReceivedOK = ctr[lan937x_mib_rx_bcast];
+	mac_stats->InRangeLengthErrors = ctr[lan937x_mib_rx_fragments];
+
+	mib->cnt_ptr = 0;
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				       struct ethtool_eth_ctrl_stats *ctrl_sts)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *cnt;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[lan937x_mib_rx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_rx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesReceived = *cnt;
+
+	cnt = &mib->counters[lan937x_mib_tx_pause];
+	lan937x_r_mib_pkt(dev, port, lan937x_mib_tx_pause, NULL, cnt);
+	ctrl_sts->MACControlFramesTransmitted = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
+static void lan937x_get_stats64(struct dsa_switch *ds, int port,
+				struct rtnl_link_stats64 *s)
+{
+	struct ksz_device *dev = ds->priv;
+	struct ksz_port_mib *mib = &dev->ports[port].mib;
+	u64 *ctr = mib->counters;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	while (mib->cnt_ptr < dev->mib_cnt) {
+		lan937x_r_mib_pkt(dev, port, mib->cnt_ptr,
+				  NULL, &mib->counters[mib->cnt_ptr]);
+		++mib->cnt_ptr;
+	}
+
+	s->rx_packets = ctr[lan937x_mib_rx_mcast] +
+			ctr[lan937x_mib_rx_bcast] +
+			ctr[lan937x_mib_rx_ucast] +
+			ctr[lan937x_mib_rx_pause];
+
+	s->tx_packets = ctr[lan937x_mib_tx_mcast] +
+			ctr[lan937x_mib_tx_bcast] +
+			ctr[lan937x_mib_tx_ucast] +
+			ctr[lan937x_mib_tx_pause];
+
+	s->rx_bytes = ctr[lan937x_mib_rx_total];
+	s->tx_bytes = ctr[lan937x_mib_tx_total];
+
+	s->rx_errors = ctr[lan937x_mib_rx_fragments] +
+		       ctr[lan937x_mib_rx_jabbers] +
+		       ctr[lan937x_mib_rx_sym_err] +
+		       ctr[lan937x_mib_rx_align_err] +
+		       ctr[lan937x_mib_rx_crc_err];
+
+	s->tx_errors = ctr[lan937x_mib_tx_exc_col] +
+		       ctr[lan937x_mib_tx_late_col];
+
+	s->rx_dropped = ctr[lan937x_mib_rx_discard];
+	s->tx_dropped = ctr[lan937x_mib_tx_discard];
+	s->multicast = ctr[lan937x_mib_rx_mcast];
+
+	s->collisions = ctr[lan937x_mib_tx_late_col] +
+			ctr[lan937x_mib_tx_single_col] +
+			ctr[lan937x_mib_tx_mult_col];
+
+	s->rx_length_errors = ctr[lan937x_mib_rx_fragments] +
+			      ctr[lan937x_mib_rx_jabbers];
+
+	s->rx_crc_errors = ctr[lan937x_mib_rx_crc_err];
+	s->rx_frame_errors = ctr[lan937x_mib_rx_align_err];
+	s->tx_aborted_errors = ctr[lan937x_mib_tx_exc_col];
+	s->tx_window_errors = ctr[lan937x_mib_tx_late_col];
+
+	mib->cnt_ptr = 0;
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol = lan937x_get_tag_protocol,
 	.setup = lan937x_setup,
 	.phy_read = lan937x_phy_read16,
 	.phy_write = lan937x_phy_write16,
 	.port_enable = ksz_enable_port,
+	.get_strings = lan937x_get_strings,
+	.get_ethtool_stats = ksz_get_ethtool_stats,
+	.get_sset_count = ksz_sset_count,
+	.get_eth_ctrl_stats = lan937x_get_eth_ctrl_stats,
+	.get_eth_mac_stats = lan937x_get_eth_mac_stats,
+	.get_eth_phy_stats = lan937x_get_eth_phy_stats,
+	.get_stats64 = lan937x_get_stats64,
 	.port_bridge_join = ksz_port_bridge_join,
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
-- 
2.30.2

