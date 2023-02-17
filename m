Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B2569A995
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 12:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjBQLCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 06:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBQLCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 06:02:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7516063BCD;
        Fri, 17 Feb 2023 03:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676631720; x=1708167720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ds+xcdqyuM0AGf3EleSMTk8z7ILujR2TSv0lkawhf5Q=;
  b=nTisAfsAfnY5JDN9PKV5dWpBPs099NqS/+o0mrQZyac8jDuH2X279Dew
   uhOokDJGkYlSVxr9CI4DPSXKozBackFXlgnQOwAm3ts6fqVMScQyqi18P
   05Hf+DFOxNxsjK/t2mf+bNh0XntlxgKQb+uobEJ/5j+p6KRFFejvvzYbW
   dLyRXBOsoV/PST5VH+dmwzIfVLT4BrILs8SvZNYBP/cti9LIeUWL+Lgyk
   1t9B5lTNi5Zho6XrOqWZRx4cQRDVeolv/Ako62qwq47KxNSLPTSAAS3f7
   tSx1WOixoe499R8/ieoQgPDcz4Wy7Ror+WEN+Ik5XNlRxiJ0ZeFSKMnzN
   A==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669100400"; 
   d="scan'208";a="137756684"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Feb 2023 04:01:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 17 Feb 2023 04:01:59 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 17 Feb 2023 04:01:55 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>,
        Thangaraj Samynathan <Thangaraj.S@microchip.com>
Subject: [PATCH v2 net-next 1/5] net: dsa: microchip: add rmon grouping for ethtool statistics
Date:   Fri, 17 Feb 2023 16:32:07 +0530
Message-ID: <20230217110211.433505-2-rakesh.sankaranarayanan@microchip.com>
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

Co-developed-by: Thangaraj Samynathan <Thangaraj.S@microchip.com>
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/Makefile      |   1 +
 drivers/net/dsa/microchip/ksz_common.c  |  15 ++
 drivers/net/dsa/microchip/ksz_common.h  |   3 +
 drivers/net/dsa/microchip/ksz_ethtool.c | 180 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_ethtool.h |  18 +++
 5 files changed, 217 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ethtool.h

diff --git a/drivers/net/dsa/microchip/Makefile b/drivers/net/dsa/microchip/Makefile
index 48360cc9fc68..2b698ac39a1f 100644
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
index 729b36eeb2c4..61f4e23d8849 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -27,6 +27,7 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz_ethtool.h"
 #include "ksz_ptp.h"
 #include "ksz8.h"
 #include "ksz9477.h"
@@ -204,6 +205,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.freeze_mib = ksz8_freeze_mib,
 	.port_init_cnt = ksz8_port_init_cnt,
 	.fdb_dump = ksz8_fdb_dump,
+	.get_rmon_stats = ksz8_get_rmon_stats,
 	.mdb_add = ksz8_mdb_add,
 	.mdb_del = ksz8_mdb_del,
 	.vlan_filtering = ksz8_port_vlan_filtering,
@@ -241,6 +243,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -277,6 +280,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.r_mib_stat64 = ksz_r_mib_stats64,
 	.freeze_mib = ksz9477_freeze_mib,
 	.port_init_cnt = ksz9477_port_init_cnt,
+	.get_rmon_stats = ksz9477_get_rmon_stats,
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
@@ -1730,6 +1734,16 @@ static void ksz_get_pause_stats(struct dsa_switch *ds, int port,
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
@@ -3186,6 +3200,7 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz_get_stats64,
 	.get_pause_stats	= ksz_get_pause_stats,
+	.get_rmon_stats		= ksz_get_rmon_stats,
 	.port_change_mtu	= ksz_change_mtu,
 	.port_max_mtu		= ksz_max_mtu,
 	.get_ts_info		= ksz_get_ts_info,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index d2d5761d58e9..a4e53431218c 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -361,6 +361,9 @@ struct ksz_dev_ops {
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
index 000000000000..0f3f18545858
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_ethtool.c
@@ -0,0 +1,180 @@
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
+	KSZ8_RX,
+	KSZ8_RX_HI,
+	KSZ8_RX_UNDERSIZE,
+	KSZ8_RX_FRAGMENTS,
+	KSZ8_RX_OVERSIZE,
+	KSZ8_RX_JABBERS,
+	KSZ8_RX_SYMBOL_ERR,
+	KSZ8_RX_CRC_ERR,
+	KSZ8_RX_ALIGN_ERR,
+	KSZ8_RX_MAC_CTL,
+	KSZ8_RX_PAUSE,
+	KSZ8_RX_BCAST,
+	KSZ8_RX_MCAST,
+	KSZ8_RX_UCAST,
+	KSZ8_RX_64_OR_LESS,
+	KSZ8_RX_65_127,
+	KSZ8_RX_128_255,
+	KSZ8_RX_256_511,
+	KSZ8_RX_512_1023,
+	KSZ8_RX_1024_1522,
+	KSZ8_TX,
+	KSZ8_TX_HI,
+	KSZ8_TX_LATE_COL,
+	KSZ8_TX_PAUSE,
+	KSZ8_TX_BCAST,
+	KSZ8_TX_MCAST,
+	KSZ8_TX_UCAST,
+	KSZ8_TX_DEFERRED,
+	KSZ8_TX_TOTAL_COL,
+	KSZ8_TX_EXC_COL,
+	KSZ8_TX_SINGLE_COL,
+	KSZ8_TX_MULT_COL,
+	KSZ8_RX_DISCARDS,
+	KSZ8_TX_DISCARDS,
+};
+
+enum ksz9477_mib_entry {
+	KSZ9477_RX_HI,
+	KSZ9477_RX_UNDERSIZE,
+	KSZ9477_RX_FRAGMENTS,
+	KSZ9477_RX_OVERSIZE,
+	KSZ9477_RX_JABBERS,
+	KSZ9477_RX_SYMBOL_ERR,
+	KSZ9477_RX_CRC_ERR,
+	KSZ9477_RX_ALIGN_ERR,
+	KSZ9477_RX_MAC_CTL,
+	KSZ9477_RX_PAUSE,
+	KSZ9477_RX_BCAST,
+	KSZ9477_RX_MCAST,
+	KSZ9477_RX_UCAST,
+	KSZ9477_RX_64_OR_LESS,
+	KSZ9477_RX_65_127,
+	KSZ9477_RX_128_255,
+	KSZ9477_RX_256_511,
+	KSZ9477_RX_512_1023,
+	KSZ9477_RX_1024_1522,
+	KSZ9477_RX_1523_2000,
+	KSZ9477_RX_2001,
+	KSZ9477_TX_HI,
+	KSZ9477_TX_LATE_COL,
+	KSZ9477_TX_PAUSE,
+	KSZ9477_TX_BCAST,
+	KSZ9477_TX_MCAST,
+	KSZ9477_TX_UCAST,
+	KSZ9477_TX_DEFERRED,
+	KSZ9477_TX_TOTAL_COL,
+	KSZ9477_TX_EXC_COL,
+	KSZ9477_TX_SINGLE_COL,
+	KSZ9477_TX_MULT_COL,
+	KSZ9477_RX_TOTAL,
+	KSZ9477_TX_TOTAL,
+	KSZ9477_RX_DISCARDS,
+	KSZ9477_TX_DISCARDS,
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
+	cnt = &mib->counters[KSZ8_RX_UNDERSIZE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_UNDERSIZE, NULL, cnt);
+	rmon_stats->undersize_pkts = *cnt;
+
+	cnt = &mib->counters[KSZ8_RX_OVERSIZE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_OVERSIZE, NULL, cnt);
+	rmon_stats->oversize_pkts = *cnt;
+
+	cnt = &mib->counters[KSZ8_RX_FRAGMENTS];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_FRAGMENTS, NULL, cnt);
+	rmon_stats->fragments = *cnt;
+
+	cnt = &mib->counters[KSZ8_RX_JABBERS];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ8_RX_JABBERS, NULL, cnt);
+	rmon_stats->jabbers = *cnt;
+
+	for (i = 0; i < KSZ8_HIST_LEN; i++) {
+		cnt = &mib->counters[KSZ8_RX_64_OR_LESS + i];
+		dev->dev_ops->r_mib_pkt(dev, port,
+				(KSZ8_RX_64_OR_LESS + i), NULL, cnt);
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
+	cnt = &mib->counters[KSZ9477_RX_UNDERSIZE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_UNDERSIZE, NULL, cnt);
+	rmon_stats->undersize_pkts = *cnt;
+
+	cnt = &mib->counters[KSZ9477_RX_OVERSIZE];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_OVERSIZE, NULL, cnt);
+	rmon_stats->oversize_pkts = *cnt;
+
+	cnt = &mib->counters[KSZ9477_RX_FRAGMENTS];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_FRAGMENTS, NULL, cnt);
+	rmon_stats->fragments = *cnt;
+
+	cnt = &mib->counters[KSZ9477_RX_JABBERS];
+	dev->dev_ops->r_mib_pkt(dev, port, KSZ9477_RX_JABBERS, NULL, cnt);
+	rmon_stats->jabbers = *cnt;
+
+	for (i = 0; i < KSZ9477_HIST_LEN; i++) {
+		cnt = &mib->counters[KSZ9477_RX_64_OR_LESS + i];
+		dev->dev_ops->r_mib_pkt(dev, port,
+				(KSZ9477_RX_64_OR_LESS + i), NULL, cnt);
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

