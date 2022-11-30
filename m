Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF263D6B5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiK3N3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbiK3N3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:29:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB366C9A;
        Wed, 30 Nov 2022 05:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669814987; x=1701350987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D8xEpmhqSV+pyWd3PBzu+0gtBcOl/hTNlpWkQLkNN3c=;
  b=Kl+iITf3EJ9UkZCqezdIVV8e29ph3bojYC7qn4Uit4x6gBh9U2Ahk7hg
   9hQhIiECgo802dGOk1Ssx9UB4xcBVjCOFJhE3+gFcnnYOAv/3mwaepuxf
   UG8vZMunv+yMXrnsytWZCU64N7Im9iWDPh7XJhklxxM5p/9S1jHflNED3
   pwduSJbGKUGXdmVU5Jb0eY6Ius+ShxfVlHQaEQuehNI9B+r+pMGNxjzs6
   1j0oHQQi426tGfHdy45BgMfNC6GgJ36Pjt65qQLJ2mjnl4SDM+GGZVxJK
   I2Wt2oH51CyTovjxHOpo4Oesoug5odOQt1DWu1OjLYvWoCAUmo437nzMM
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="202016568"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:29:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:29:46 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:29:43 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 1/5] net: dsa: microchip: add rmon grouping for ethtool statistics
Date:   Wed, 30 Nov 2022 18:58:58 +0530
Message-ID: <20221130132902.2984580-2-rakesh.sankaranarayanan@microchip.com>
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

Add support for ethtool standard device statistics grouping. Support rmon
statistics grouping using rmon groups parameter in ethtool command. rmon
provides packet size based range grouping. Common mib parameters are used
across all KSZ series swtches for packet size statistics, except for
KSZ8830. KSZ series have mib counters for packets with size:
- less than 64 Bytes,
- 65 to 127 Bytes,
- 128 to 255 Bytes,
- 256 to 511 Bytes,
- 512 to 1023 Bytes,
- 1024 to 1522 Bytes,
- 1523 to 2000 Bytes and
- More than 2001 Bytes
KSZ8830 have mib counters upto 1024-1522 range only. Since no other change,
common range used across all KSZ series, but used upto only upto 1024-1522
for KSZ8830.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  15 ++
 drivers/net/dsa/microchip/ksz_common.h  |   3 +
 drivers/net/dsa/microchip/ksz_ethtool.c | 178 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  18 +++
 5 files changed, 215 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.h

diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 28873559efc2..413a706a47fb 100644
--- a/drivers/net/dsa/microchip/Makefile
+++ b/drivers/net/dsa/microchip/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON)	+= ksz_switch.o
 ksz_switch-objs := ksz_common.o
+ksz_switch-objs += ksz_ethtool.o
 ksz_switch-objs += ksz9477.o
 ksz_switch-objs += ksz8795.o
 ksz_switch-objs += lan937x_main.o
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8c8db315317d..7a9d7ef818a7 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -24,6 +24,7 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz_ethtool.h"
 #include "ksz8.h"
 #include "ksz9477.h"
 #include "lan937x.h"
@@ -157,6 +158,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.r_mib_pkt = ksz8_r_mib_pkt,
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
+	.get_rmon_stats = ksz8_get_rmon_stats,
 	.fdb_dump = ksz8_fdb_dump,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
@@ -194,6 +196,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -230,6 +233,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1609,6 +1613,16 @@ static void ksz_get_pause_stats(struct dsa_switch *ds, int port,
 	spin_unlock(&mib->stats64_lock);
 }
 
+static void ksz_get_rmon_stats(struct dsa_switch *ds, int port,
+			       struct ethtool_rmon_stats *rmon_stats,
+			       const struct ethtool_rmon_hist_range **ranges)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (dev->dev_ops->get_rmon_stats)
+		dev->dev_ops->get_rmon_stats(dev, port, rmon_stats, ranges);
+}
+
 static void ksz_get_strings(struct dsa_switch *ds, int port,
 			    u32 stringset, uint8_t *buf)
 {
@@ -2859,6 +2873,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
 	.get_pause_stats	= ksz_get_pause_stats,
+	.get_rmon_stats		= ksz_get_rmon_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 };
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c6726cbd5465..ad6d196d2927 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -339,6 +339,9 @@ struct ksz_dev_ops {
 	int (*reset)(struct ksz_device *dev);
 	int (*init)(struct ksz_device *dev);
 	void (*exit)(struct ksz_device *dev);
+	void (*get_rmon_stats)(struct ksz_device *dev, int port,
+			       struct ethtool_rmon_stats *rmon_stats,
+			       const struct ethtool_rmon_hist_range **ranges);
 };
 
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.c b/drivers/net/dsa/microchip/ksz_ethtool.c
new file mode 100644
index 000000000000..7e1f1b4d1e98
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Microchip KSZ series ethtool statistics
+ *
+ * Copyright (C) 2022 Microchip Technology Inc.
+ */
+
+#include "ksz_common.h"
+#include "ksz_ethtool.h"
+
+enum ksz8_mib_entry {
+	ksz8_rx,
+	ksz8_rx_hi,
+	ksz8_rx_undersize,
+	ksz8_rx_fragments,
+	ksz8_rx_oversize,
+	ksz8_rx_jabbers,
+	ksz8_rx_symbol_err,
+	ksz8_rx_crc_err,
+	ksz8_rx_align_err,
+	ksz8_rx_mac_ctrl,
+	ksz8_rx_pause,
+	ksz8_rx_bcast,
+	ksz8_rx_mcast,
+	ksz8_rx_ucast,
+	ksz8_rx_64_or_less,
+	ksz8_rx_65_127,
+	ksz8_rx_128_255,
+	ksz8_rx_256_511,
+	ksz8_rx_512_1023,
+	ksz8_rx_1024_1522,
+	ksz8_tx,
+	ksz8_tx_hi,
+	ksz8_tx_late_col,
+	ksz8_tx_pause,
+	ksz8_tx_bcast,
+	ksz8_tx_mcast,
+	ksz8_tx_ucast,
+	ksz8_tx_deferred,
+	ksz8_tx_total_col,
+	ksz8_tx_exc_col,
+	ksz8_tx_single_col,
+	ksz8_tx_mult_col,
+	ksz8_rx_discards = 0x100,
+	ksz8_tx_discards,
+};
+
+enum ksz9477_mib_entry {
+	ksz9477_rx_hi,
+	ksz9477_rx_undersize,
+	ksz9477_rx_fragments,
+	ksz9477_rx_oversize,
+	ksz9477_rx_jabbers,
+	ksz9477_rx_symbol_err,
+	ksz9477_rx_crc_err,
+	ksz9477_rx_align_err,
+	ksz9477_rx_mac_ctrl,
+	ksz9477_rx_pause,
+	ksz9477_rx_bcast,
+	ksz9477_rx_mcast,
+	ksz9477_rx_ucast,
+	ksz9477_rx_64_or_less,
+	ksz9477_rx_65_127,
+	ksz9477_rx_128_255,
+	ksz9477_rx_256_511,
+	ksz9477_rx_512_1023,
+	ksz9477_rx_1024_1522,
+	ksz9477_rx_1523_2000,
+	ksz9477_rx_2001,
+	ksz9477_tx_hi,
+	ksz9477_tx_late_col,
+	ksz9477_tx_pause,
+	ksz9477_tx_bcast,
+	ksz9477_tx_mcast,
+	ksz9477_tx_ucast,
+	ksz9477_tx_deferred,
+	ksz9477_tx_total_col,
+	ksz9477_tx_exc_col,
+	ksz9477_tx_single_col,
+	ksz9477_tx_mult_col,
+	ksz9477_rx_total = 0x80,
+	ksz9477_tx_total,
+	ksz9477_rx_discards,
+	ksz9477_tx_discards,
+};
+
+static const struct ethtool_rmon_hist_range ksz_rmon_ranges[] = {
+	{    0,     64 },
+	{   65,    127 },
+	{  128,    255 },
+	{  256,    511 },
+	{  512,   1023 },
+	{ 1024,   1522 },
+	{ 1523,   2000 },
+	{ 2001,   9000 },
+	{}
+};
+
+#define KSZ8_HIST_LEN		6
+#define KSZ9477_HIST_LEN	8
+
+void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
+			 struct ethtool_rmon_stats *rmon_stats,
+			 const struct ethtool_rmon_hist_range **ranges)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+	u8 i;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz8_rx_undersize];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_undersize, NULL, cnt);
+	rmon_stats->undersize_pkts = *cnt;
+
+	cnt = &mib->counters[ksz8_rx_oversize];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_oversize, NULL, cnt);
+	rmon_stats->oversize_pkts = *cnt;
+
+	cnt = &mib->counters[ksz8_rx_fragments];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_fragments, NULL, cnt);
+	rmon_stats->fragments = *cnt;
+
+	cnt = &mib->counters[ksz8_rx_jabbers];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz8_rx_jabbers, NULL, cnt);
+	rmon_stats->jabbers = *cnt;
+
+	for (i = 0; i < KSZ8_HIST_LEN; i++) {
+		cnt = &mib->counters[ksz8_rx_64_or_less + i];
+		dev->dev_ops->r_mib_pkt(dev, port, (ksz8_rx_64_or_less + i), NULL, cnt);
+		rmon_stats->hist[i] = *cnt;
+	}
+
+	mutex_unlock(&mib->cnt_mutex);
+
+	*ranges = ksz_rmon_ranges;
+}
+
+void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
+			    struct ethtool_rmon_stats *rmon_stats,
+			    const struct ethtool_rmon_hist_range **ranges)
+{
+	struct ksz_port_mib *mib;
+	u64 *cnt;
+	u8 i;
+
+	mib = &dev->ports[port].mib;
+
+	mutex_lock(&mib->cnt_mutex);
+
+	cnt = &mib->counters[ksz9477_rx_undersize];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_undersize, NULL, cnt);
+	rmon_stats->undersize_pkts = *cnt;
+
+	cnt = &mib->counters[ksz9477_rx_oversize];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_oversize, NULL, cnt);
+	rmon_stats->oversize_pkts = *cnt;
+
+	cnt = &mib->counters[ksz9477_rx_fragments];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_fragments, NULL, cnt);
+	rmon_stats->fragments = *cnt;
+
+	cnt = &mib->counters[ksz9477_rx_jabbers];
+	dev->dev_ops->r_mib_pkt(dev, port, ksz9477_rx_jabbers, NULL, cnt);
+	rmon_stats->jabbers = *cnt;
+
+	for (i = 0; i < KSZ9477_HIST_LEN; i++) {
+		cnt = &mib->counters[ksz9477_rx_64_or_less + i];
+		dev->dev_ops->r_mib_pkt(dev, port, (ksz9477_rx_64_or_less + i), NULL, cnt);
+		rmon_stats->hist[i] = *cnt;
+	}
+
+	mutex_unlock(&mib->cnt_mutex);
+
+	*ranges = ksz_rmon_ranges;
+}
diff --git a/drivers/net/dsa/microchip/ksz_ethtool.h b/drivers/net/dsa/microchip/ksz_ethtool.h
new file mode 100644
index 000000000000..6927e2f143f8
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ethtool.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Microchip KSZ series ethtool statistics
+ *
+ * Copyright (C) 2022 Microchip Technology Inc.
+ */
+
+#ifndef __KSZ_ETHTOOL_H
+#define __KSZ_ETHTOOL_H
+
+void ksz8_get_rmon_stats(struct ksz_device *dev, int port,
+			 struct ethtool_rmon_stats *rmon_stats,
+			 const struct ethtool_rmon_hist_range **ranges);
+
+void ksz9477_get_rmon_stats(struct ksz_device *dev, int port,
+			    struct ethtool_rmon_stats *rmon_stats,
+			    const struct ethtool_rmon_hist_range **ranges);
+#endif
-- 
2.34.1

