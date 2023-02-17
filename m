Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2091B69A997
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBQLC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjBQLCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:02:14 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B1A644E3;
        Fri, 17 Feb 2023 03:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631726; x=1708167726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qQ8jpLCWB3xADM+WiiX2unPMfeq17rScD8SdIVMh6Nk=;
  b=xgWeM/zR6Qs6Ff3tD5BukDZ5MPDlDW2Tc8AH3YIHtkdaY1WFZWAP9S4W
   HD31uuQCCMx52b5ZqNrDpv2zNWneXvFgWRlxZbmKMVy9Rj7LnHGalG4JB
   RvrebxSnKPTApgCb/uDR4k2IU3EoZkP1RNvUBTLpnmZsPGZT0EohXqLnb
   tUoFz0rx+a9BBdc0urCdQy8N7n7pG0Z06IAHY50mJt9qxwy1VwklGrNXr
   fw4JkZf0WbI/MYOrUevLh3EL11GNzYZtGiyzyd6UBkQMvgx+bx2zWK188
   z0pFBWuf4SeBeRN9JJWa2euIMTxLfxwh4yr9xqwddBoLISGNuUEkhQP7S
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="201101352"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:02:06 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:02:05 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:02:02 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net-next 2/5] net: dsa: microchip: add eth ctrl grouping for ethtool statistics
Date:   Fri, 17 Feb 2023 16:32:08 +0530
Message-ID: <20230217110211.433505-3-rakesh.sankaranarayanan@microchip.com>
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
index 61f4e23d8849..91fc7eed79f0 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -206,6 +206,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.port_init_cnt = ksz8_port_init_cnt,
 	.fdb_dump = ksz8_fdb_dump,
 	.get_rmon_stats = ksz8_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz8_get_eth_ctrl_stats,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
@@ -244,6 +245,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -281,6 +283,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
 	.get_rmon_stats = ksz9477_get_rmon_stats,
+	.get_eth_ctrl_stats = ksz9477_get_eth_ctrl_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1744,6 +1747,15 @@ static void ksz_get_rmon_stats(struct dsa_switch *ds, int port,
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
@@ -3201,6 +3213,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.get_stats64		= ksz_get_stats64,
 	.get_pause_stats	= ksz_get_pause_stats,
 	.get_rmon_stats		= ksz_get_rmon_stats,
+	.get_eth_ctrl_stats	= ksz_get_eth_ctrl_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info		= ksz_get_ts_info,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a4e53431218c..7b0219947c7a 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -364,6 +364,8 @@ struct ksz_dev_ops {
 	void (*get_rmon_stats)(struct ksz_device *dev, int port,
 			       struct ethtool_rmon_stats *rmon_stats,
 			       const struct ethtool_rmon_hist_range **ranges);
+	void (*get_eth_ctrl_stats)(struct ksz_device *dev, int port,
+				   struct ethtool_eth_ctrl_stats *ctrl_stats);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
index 0f3f18545858..122c4371810a 100644
--- a/drivers/net/dsa/microchip/ksz_ethtool.c
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -139,6 +139,27 @@ void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
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
+	cnt = &mib->counters[KSZ8_TX_PAUSE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_TX_PAUSE, NULL, cnt);
+	ctrl_stats->MACControlFramesTransmitted = *cnt;
+
+	cnt = &mib->counters[KSZ8_RX_PAUSE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_PAUSE, NULL, cnt);
+	ctrl_stats->MACControlFramesReceived = *cnt;
+
+	mutex_unlock(&mib->cnt_mutex);
+}
+
 void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 			    struct ethtool_rmon_stats *rmon_stats,
 			    const struct ethtool_rmon_hist_range **ranges)
@@ -178,3 +199,24 @@ void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
 
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
+	cnt = &mib->counters[KSZ9477_TX_PAUSE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_TX_PAUSE, NULL, cnt);
+	ctrl_stats->MACControlFramesTransmitted = *cnt;
+
+	cnt = &mib->counters[KSZ9477_RX_PAUSE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_PAUSE, NULL, cnt);
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

