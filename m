Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9387163D6B6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbiK3N3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiK3N3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:29:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF59B6D4B0;
        Wed, 30 Nov 2022 05:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669814992; x=1701350992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bG2YB0NkrzG6BJsd5W3PcjQo2F7CAw9j+x82YqMWPLQ=;
  b=MXEDj3TcxOYF7e5IRPSyZv/WpuZKTI9SxzUkLfwGgHnn1tW2J6NMj1lp
   efbvuIdLwABE6NxcvDq8W28XKkEt84ZtbXDumgTc0x5frEoEwfYCogehj
   3zZsKCS59PkyiKfHWVcvWiKIpAjLNmJ01CxU5mDxW8T3dePB/+0R/vPqS
   09UdZQ2ei5w5y2ZxevbHAM3IqH+L9syMoTKiFM3b2gR+khnqY0wpj2Crs
   vl3yjlhN8ZovLQW0c90MQV9e455Ymdg/PIp943RyYFmp56/dAYPcmA6Xz
   yY4uj6qB1QDdnCfPbPts9EbLAmLznd5oTzVbrqP/QjKc35woiqxcoXdKc
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191142261"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:29:52 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:29:52 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:29:48 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 2/5] net: dsa: microchip: add eth ctrl grouping for ethtool statistics
Date:   Wed, 30 Nov 2022 18:58:59 +0530
Message-ID: <20221130132902.2984580-3-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ethtool standard device statistics grouping. Support
ethernet mac ctrl statistics grouping using eth-ctrl groups parameter
in ethtool command.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c  | 13 ++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  2 ++
 drivers/net/dsa/microchip/ksz_ethtool.c | 42 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  4 +++
 4 files changed, 61 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7a9d7ef818a7..9b13a38d553d 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -159,6 +159,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.get_rmon_stats = ksz8_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
 	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
@@ -197,6 +198,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -234,6 +236,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1623,6 +1626,15 @@ static void ksz_get_rmon_stats(struct dsa_switch *ds, int port,
 		dev->dev_ops->get_rmon_stats(dev, port, rmon_stats, ranges);
 }
 
+static void ksz_get_eth_ctrl_stats(struct dsa_switch *ds, int port,
+				   struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->get_eth_ctrl_stats)
+		dev->dev_ops->get_eth_ctrl_stats(dev, port, ctrl_stats);
+}
+
 static void ksz_get_strings(struct dsa_switch *ds, int port,
 			    u32 stringset, uint8_t *buf)
 {
@@ -2874,6 +2886,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_stats64		= ksz_get_stats64,
 	.get_pause_stats	= ksz_get_pause_stats,
 	.get_rmon_stats		= ksz_get_rmon_stats,
+	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index ad6d196d2927..07627ff1a749 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -342,6 +342,8 @@ struct ksz_dev_ops {
 	void (*get_rmon_stats)(struct ksz_device *dev, int port,
 			       struct ethtool_rmon_stats *rmon_stats,
 			       const struct ethtool_rmon_hist_range **ranges);
+	void (*get_eth_ctrl_stats)(struct ksz_device *dev, int port,
+				   struct ethtool_eth_ctrl_stats *ctrl_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 7e1f1b4d1e98..4c9ca21e1806 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -138,6 +138,27 @@ void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
 	*ranges = ksz_rmon_ranges;
 }
 
+void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
+			     struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz8_tx_pause];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_tx_pause, NULL, cnt);
+	ctrl_stats->MACControlFramesTransmitted = *cnt;
+
+	cnt = &mib->counters[ksz8_rx_pause];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_pause, NULL, cnt);
+	ctrl_stats->MACControlFramesReceived = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -176,3 +197,24 @@ void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 
 	*ranges = ksz_rmon_ranges;
 }
+
+void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
+				struct ethtool_eth_ctrl_stats *ctrl_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz9477_tx_pause];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_tx_pause, NULL, cnt);
+	ctrl_stats->MACControlFramesTransmitted = *cnt;
+
+	cnt = &mib->counters[ksz9477_rx_pause];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_pause, NULL, cnt);
+	ctrl_stats->MACControlFramesReceived = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.h b/drivers/net/dsa/microchip/ksz_ethtool.h
index 6927e2f143f8..18dc155d60b9 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.h
+++ b/drivers/net/dsa/microchip/ksz_ethtool.h
@@ -11,8 +11,12 @@
 void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
 			 struct ethtool_rmon_stats *rmon_stats,
 			 const struct ethtool_rmon_hist_range **ranges);
+void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
+			     struct ethtool_eth_ctrl_stats *ctrl_stats);
 
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges);
+void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
+				struct ethtool_eth_ctrl_stats *ctrl_stats);
 #endif
-- 
2.34.1

