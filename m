Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9362063D6BC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiK3Nah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiK3NaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:30:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4B77CAB5;
        Wed, 30 Nov 2022 05:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669815002; x=1701351002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zI8qmvOdp+9rHbSq/mQh0++aRx/yJ0H3E/ueXM5IhBA=;
  b=uKQSHkCyKH7sx+Myid4Kkv734MeQJWze6QcAN++Di2t9QomzASNeZCt4
   x6Uf9VdXxsVkT+UoKUeO466ZEkKLXZUS1DCNcDRHGsM08B5E+BaYlzPZT
   3nLR9nTeW5KIxDUTjpm3b9xV3FhuywiXGfvdVu65IJse2Wqgl+S61LonL
   hNg+wYis8w4KlQ4n82/O9kv5P6IEScvUvlGmrOXl0ctks7PZqo3n+HBAw
   x1ZV8XIXC5UgnNG7vFnXqY0ZDi0lSgMN2ZCevw3PgVD1wK9NS5ByUs1U2
   HoOHaXHxy2TLcJGTY9cNd1wa4nUrD2gCe6aiofxASbII9iEjI9vscLLqP
   g==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="191136742"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:30:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:30:02 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:29:58 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 4/5] net: dsa: microchip: add eth phy grouping for ethtool statistics
Date:   Wed, 30 Nov 2022 18:59:01 +0530
Message-ID: <20221130132902.2984580-5-rakesh.sankaranarayanan@microchip.com>
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
ethernet phy statistics grouping using eth-phy groups parameter in
ethtool command.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c  | 13 +++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  2 ++
 drivers/net/dsa/microchip/ksz_ethtool.c | 36 +++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  5 ++++
 4 files changed, 56 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ceb3c4f120bd..0f3925d0c668 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -161,6 +161,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.get_rmon_stats = ksz8_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz8_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz8_get_eth_phy_stats,
 	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
@@ -201,6 +202,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz9477_get_eth_phy_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -240,6 +242,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz9477_get_eth_phy_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1647,6 +1650,15 @@ static void ksz_get_eth_mac_stats(struct dsa_switch *ds, int port,
 		dev->dev_ops->get_eth_mac_stats(dev, port, mac_stats);
 }
 
+static void ksz_get_eth_phy_stats(struct dsa_switch *ds, int port,
+				  struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->get_eth_phy_stats)
+		dev->dev_ops->get_eth_phy_stats(dev, port, phy_stats);
+}
+
 static void ksz_get_strings(struct dsa_switch *ds, int port,
 			    u32 stringset, uint8_t *buf)
 {
@@ -2900,6 +2912,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_rmon_stats		= ksz_get_rmon_stats,
 	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
 	.get_eth_mac_stats	= ksz_get_eth_mac_stats,
+	.get_eth_phy_stats	= ksz_get_eth_phy_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 5b77f98483a9..c253d761b62b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -346,6 +346,8 @@ struct ksz_dev_ops {
 				   struct ethtool_eth_ctrl_stats *ctrl_stats);
 	void (*get_eth_mac_stats)(struct ksz_device *dev, int port,
 				  struct ethtool_eth_mac_stats *mac_stats);
+	void (*get_eth_phy_stats)(struct ksz_device *dev, int port,
+				  struct ethtool_eth_phy_stats *phy_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 96529fea8e84..5061c503437a 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -203,6 +203,24 @@ void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
 	mutex_unlock(&mib->cnt_mutex);
 }
 
+void ksz8_get_eth_phy_stats(struct ksz_device *dev, int port,
+			    struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz8_rx_symbol_err];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_symbol_err, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -306,3 +324,21 @@ void ksz9477_get_eth_mac_stats(struct ksz_device *dev, int port,
 
 	mutex_unlock(&mib->cnt_mutex);
 }
+
+void ksz9477_get_eth_phy_stats(struct ksz_device *dev, int port,
+			       struct ethtool_eth_phy_stats *phy_stats)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz9477_rx_symbol_err];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_symbol_err, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.h b/drivers/net/dsa/microchip/ksz_ethtool.h
index 2dcfe8922b4e..042a0b38a899 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.h
+++ b/drivers/net/dsa/microchip/ksz_ethtool.h
@@ -15,6 +15,8 @@ void ksz8_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 			     struct ethtool_eth_ctrl_stats *ctrl_stats);
 void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
 			    struct ethtool_eth_mac_stats *mac_stats);
+void ksz8_get_eth_phy_stats(struct ksz_device *dev, int port,
+			    struct ethtool_eth_phy_stats *phy_stats);
 
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
@@ -23,4 +25,7 @@ void ksz9477_get_eth_ctrl_stats(struct ksz_device *dev, int port,
 				struct ethtool_eth_ctrl_stats *ctrl_stats);
 void ksz9477_get_eth_mac_stats(struct ksz_device *dev, int port,
 			       struct ethtool_eth_mac_stats *mac_stats);
+void ksz9477_get_eth_phy_stats(struct ksz_device *dev, int port,
+			       struct ethtool_eth_phy_stats *phy_stats);
+
 #endif
-- 
2.34.1

