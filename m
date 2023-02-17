Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC569A999
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBQLCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjBQLCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:02:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072A83028D;
        Fri, 17 Feb 2023 03:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631740; x=1708167740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xuAQHwlijF+Yj0VX+hzdHh3BDSnnpTYis5wdwFZYBCU=;
  b=r2CeWCvXHU0dxcrwPxxhXf7bABxpbm/Y1ur/5GqiCLVCkoPo8R0EBueP
   qY66D4fdOl8gGXftvI4pkrzjUvdBV9FOgePpD3t31aN5DMi2kuq9AVOE7
   ti0lGWA75ZwGI4Nl0I5PVoYAS9147j5/M/QEe2oEQWseSaZJ7Dn+/dJBC
   5ZZfZGxg3wQgv1gSTtONZG8rLpFF1/0xR0Ye2rKniRFRI4Q9Z1hOLKc50
   T9HVJUFMpJiUrJVJXYd4oR4yqVvOTX6Wm/uQv+YPp5BpfOK18TyWXn3pe
   +w8IjXJC/BpbvdTMeQjvwqeh7YsUINlAkOgakGJjvlYju9Ypk7t+9P1Qt
   g==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="201101386"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:02:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:02:15 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:02:12 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net-next 4/5] net: dsa: microchip: add eth phy grouping for ethtool statistics
Date:   Fri, 17 Feb 2023 16:32:10 +0530
Message-ID: <20230217110211.433505-5-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
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
index e4a51f13afa4..01adcbeffaaa 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -208,6 +208,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.get_rmon_stats = ksz8_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz8_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz8_get_eth_phy_stats,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
@@ -248,6 +249,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz9477_get_eth_phy_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -287,6 +289,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.get_eth_mac_stats = ksz9477_get_eth_mac_stats,
+	.get_eth_phy_stats = ksz9477_get_eth_phy_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1768,6 +1771,15 @@ static void ksz_get_eth_mac_stats(struct dsa_switch *ds, int port,
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
@@ -3227,6 +3239,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_rmon_stats		= ksz_get_rmon_stats,
 	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
 	.get_eth_mac_stats	= ksz_get_eth_mac_stats,
+	.get_eth_phy_stats	= ksz_get_eth_phy_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info		= ksz_get_ts_info,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 738e81923c31..8a71e035b699 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -368,6 +368,8 @@ struct ksz_dev_ops {
 				   struct ethtool_eth_ctrl_stats *ctrl_stats);
 	void (*get_eth_mac_stats)(struct ksz_device *dev, int port,
 				  struct ethtool_eth_mac_stats *mac_stats);
+	void (*get_eth_phy_stats)(struct ksz_device *dev, int port,
+				  struct ethtool_eth_phy_stats *phy_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 42954bbfb9b4..c0b95d78e41e 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -204,6 +204,24 @@ void ksz8_get_eth_mac_stats(struct ksz_device *dev, int port,
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
+	cnt = &mib->counters[KSZ8_RX_SYMBOL_ERR];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_SYMBOL_ERR, NULL, cnt);
+
+	phy_stats->SymbolErrorDuringCarrier = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -310,3 +328,21 @@ void ksz9477_get_eth_mac_stats(struct ksz_device *dev, int port,
 
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
+	cnt = &mib->counters[KSZ9477_RX_SYMBOL_ERR];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_SYMBOL_ERR, NULL, cnt);
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

