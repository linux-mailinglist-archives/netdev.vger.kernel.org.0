Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B27A76FD
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfICW3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:29:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37770 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfICW3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:29:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id b10so3500064plr.4
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 15:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=Lo5F1O2a/wVhrnr0G/9UVHsHwZqvH4bnexa5iozZPS8=;
        b=erFyIKTkUd2LoIfeApSHsUYwHm6jrOuDU9KL2WJ1OLp6W2PrlMw4i1lrElGzZ00RMJ
         CLVpt3SS9cR5NCMtnE82t4cN40DPHT+yfN5QpkHw7mNz34/aRWdRjiPyi+HQMm0JtetN
         LFnmuWqvbScxubtCM7MRP7LVqylRjF+t8MtZGKbMFzoweTpuhcsjdR+WVpcUhmo4nEMk
         vyOxe5g0kO81I4YdT28G8RUiTxaeDUmvfmVkZ9mm90Nf0cGEaC8aEkebqncPFq+26m7b
         3GRNgq1ADM8BziMFbTrhIMvapztl1PPfB4+z8/Cbta/8AqoIPawR4+4igc/HCL4CZPZr
         Ia6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=Lo5F1O2a/wVhrnr0G/9UVHsHwZqvH4bnexa5iozZPS8=;
        b=bM5JW3dVPcwET/iMJAlO+alTNRD+UzcMO/aQGlnpQt9ElXDkiriTfL8ZP9Yc8W93hK
         4V0jCqlwTfALXxZDUYm3JQBOyu8V9rsEnuh3HLM8+PHk15DACITkH+OCy2yDJ3ycq7g5
         rmYIq2vApTNRN7TC4tHUQH8qYWvOoa791+IoNWv0uj/PqxBrk9MnpZFWF2jA9hbHfSZR
         aJBEQQQEiTzT4PyiyF1PxvkYDmd/ybbggGPH0pXnWdVE66I29JPMtkdrkqBHTyyJ3MLu
         bUPQwh8jb5pyIQAXQOENO948Nqhe/ZrJzjNcTnvUk/xUJtjWtI85aDk5ZFoXqhjFU6ZI
         MqdA==
X-Gm-Message-State: APjAAAW4kHXhGK5SHLqAzNneElkHFlHf7rhNIkNWeqNF9swWANjtVmmZ
        alVAuOQrqKKj3fPQtAWU8JT1kg==
X-Google-Smtp-Source: APXvYqxWDRMkzBnDp5V4v3lIBQZT6E2K/xBmhnhqAW1kXgg1XjiW1b2OAtE9pkWcmG80u780xKx63w==
X-Received: by 2002:a17:902:e592:: with SMTP id cl18mr37397843plb.291.1567549745154;
        Tue, 03 Sep 2019 15:29:05 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id e17sm520520pjt.6.2019.09.03.15.29.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 15:29:04 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v7 net-next 17/19] ionic: Add driver stats
Date:   Tue,  3 Sep 2019 15:28:19 -0700
Message-Id: <20190903222821.46161-18-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903222821.46161-1-snelson@pensando.io>
References: <20190903222821.46161-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the detailed statistics for ethtool -S that the driver
keeps as it processes packets.  Display of the additional
debug statistics can be enabled through the ethtool priv-flags
feature.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 101 ++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  16 +-
 .../net/ethernet/pensando/ionic/ionic_stats.c | 310 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_stats.h |  53 +++
 5 files changed, 480 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 1cf8117db443..29f304d75261 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
 	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
-	   ionic_txrx.o
+	   ionic_txrx.o ionic_stats.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index fb2bd4122db4..ab17066acb8d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -8,6 +8,76 @@
 #include "ionic_bus.h"
 #include "ionic_lif.h"
 #include "ionic_ethtool.h"
+#include "ionic_stats.h"
+
+static const char ionic_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define PRIV_F_SW_DBG_STATS		BIT(0)
+	"sw-dbg-stats",
+};
+#define PRIV_FLAGS_COUNT ARRAY_SIZE(ionic_priv_flags_strings)
+
+static void ionic_get_stats_strings(struct ionic_lif *lif, u8 *buf)
+{
+	u32 i;
+
+	for (i = 0; i < ionic_num_stats_grps; i++)
+		ionic_stats_groups[i].get_strings(lif, &buf);
+}
+
+static void ionic_get_stats(struct net_device *netdev,
+			    struct ethtool_stats *stats, u64 *buf)
+{
+	struct ionic_lif *lif;
+	u32 i;
+
+	lif = netdev_priv(netdev);
+
+	memset(buf, 0, stats->n_stats * sizeof(*buf));
+	for (i = 0; i < ionic_num_stats_grps; i++)
+		ionic_stats_groups[i].get_values(lif, &buf);
+}
+
+static int ionic_get_stats_count(struct ionic_lif *lif)
+{
+	int i, num_stats = 0;
+
+	for (i = 0; i < ionic_num_stats_grps; i++)
+		num_stats += ionic_stats_groups[i].get_count(lif);
+
+	return num_stats;
+}
+
+static int ionic_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	int count = 0;
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		count = ionic_get_stats_count(lif);
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		count = PRIV_FLAGS_COUNT;
+		break;
+	}
+	return count;
+}
+
+static void ionic_get_strings(struct net_device *netdev,
+			      u32 sset, u8 *buf)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		ionic_get_stats_strings(lif, buf);
+		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(buf, ionic_priv_flags_strings,
+		       PRIV_FLAGS_COUNT * ETH_GSTRING_LEN);
+		break;
+	}
+}
 
 static void ionic_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
@@ -386,6 +456,32 @@ static int ionic_set_channels(struct net_device *netdev,
 	return 0;
 }
 
+static u32 ionic_get_priv_flags(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state))
+		priv_flags |= PRIV_F_SW_DBG_STATS;
+
+	return priv_flags;
+}
+
+static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u32 flags = lif->flags;
+
+	clear_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state);
+	if (priv_flags & PRIV_F_SW_DBG_STATS)
+		set_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state);
+
+	if (flags != lif->flags)
+		lif->flags = flags;
+
+	return 0;
+}
+
 static int ionic_get_module_info(struct net_device *netdev,
 				 struct ethtool_modinfo *modinfo)
 
@@ -483,6 +579,11 @@ static const struct ethtool_ops ionic_ethtool_ops = {
 	.set_ringparam		= ionic_set_ringparam,
 	.get_channels		= ionic_get_channels,
 	.set_channels		= ionic_set_channels,
+	.get_strings		= ionic_get_strings,
+	.get_ethtool_stats	= ionic_get_stats,
+	.get_sset_count		= ionic_get_sset_count,
+	.get_priv_flags		= ionic_get_priv_flags,
+	.set_priv_flags		= ionic_set_priv_flags,
 	.get_module_info	= ionic_get_module_info,
 	.get_module_eeprom	= ionic_get_module_eeprom,
 	.get_pauseparam		= ionic_get_pauseparam,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index db6d5e016607..4e0b65ddd8e0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -12,7 +12,7 @@
 
 #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
 #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS + 1)
-#define IONIC_RX_COPYBREAK_DEFAULT		256
+#define IONIC_RX_COPYBREAK_DEFAULT	256
 
 struct ionic_tx_stats {
 	u64 dma_map_err;
@@ -106,8 +106,22 @@ struct ionic_deferred {
 	struct work_struct work;
 };
 
+struct ionic_lif_sw_stats {
+	u64 tx_packets;
+	u64 tx_bytes;
+	u64 rx_packets;
+	u64 rx_bytes;
+	u64 tx_tso;
+	u64 tx_no_csum;
+	u64 tx_csum;
+	u64 rx_csum_none;
+	u64 rx_csum_complete;
+	u64 rx_csum_error;
+};
+
 enum ionic_lif_state_flags {
 	IONIC_LIF_INITED,
+	IONIC_LIF_SW_DEBUG_STATS,
 	IONIC_LIF_UP,
 	IONIC_LIF_LINK_CHECK_REQUESTED,
 	IONIC_LIF_QUEUE_RESET,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
new file mode 100644
index 000000000000..e2907884f843
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+
+#include "ionic.h"
+#include "ionic_lif.h"
+#include "ionic_stats.h"
+
+static const struct ionic_stat_desc ionic_lif_stats_desc[] = {
+	IONIC_LIF_STAT_DESC(tx_packets),
+	IONIC_LIF_STAT_DESC(tx_bytes),
+	IONIC_LIF_STAT_DESC(rx_packets),
+	IONIC_LIF_STAT_DESC(rx_bytes),
+	IONIC_LIF_STAT_DESC(tx_tso),
+	IONIC_LIF_STAT_DESC(tx_no_csum),
+	IONIC_LIF_STAT_DESC(tx_csum),
+	IONIC_LIF_STAT_DESC(rx_csum_none),
+	IONIC_LIF_STAT_DESC(rx_csum_complete),
+	IONIC_LIF_STAT_DESC(rx_csum_error),
+};
+
+static const struct ionic_stat_desc ionic_tx_stats_desc[] = {
+	IONIC_TX_STAT_DESC(pkts),
+	IONIC_TX_STAT_DESC(bytes),
+	IONIC_TX_STAT_DESC(clean),
+	IONIC_TX_STAT_DESC(dma_map_err),
+	IONIC_TX_STAT_DESC(linearize),
+	IONIC_TX_STAT_DESC(frags),
+};
+
+static const struct ionic_stat_desc ionic_rx_stats_desc[] = {
+	IONIC_RX_STAT_DESC(pkts),
+	IONIC_RX_STAT_DESC(bytes),
+	IONIC_RX_STAT_DESC(dma_map_err),
+	IONIC_RX_STAT_DESC(alloc_err),
+	IONIC_RX_STAT_DESC(csum_none),
+	IONIC_RX_STAT_DESC(csum_complete),
+	IONIC_RX_STAT_DESC(csum_error),
+};
+
+static const struct ionic_stat_desc ionic_txq_stats_desc[] = {
+	IONIC_TX_Q_STAT_DESC(stop),
+	IONIC_TX_Q_STAT_DESC(wake),
+	IONIC_TX_Q_STAT_DESC(drop),
+	IONIC_TX_Q_STAT_DESC(dbell_count),
+};
+
+static const struct ionic_stat_desc ionic_dbg_cq_stats_desc[] = {
+	IONIC_CQ_STAT_DESC(compl_count),
+};
+
+static const struct ionic_stat_desc ionic_dbg_intr_stats_desc[] = {
+	IONIC_INTR_STAT_DESC(rearm_count),
+};
+
+static const struct ionic_stat_desc ionic_dbg_napi_stats_desc[] = {
+	IONIC_NAPI_STAT_DESC(poll_count),
+};
+
+#define IONIC_NUM_LIF_STATS ARRAY_SIZE(ionic_lif_stats_desc)
+#define IONIC_NUM_TX_STATS ARRAY_SIZE(ionic_tx_stats_desc)
+#define IONIC_NUM_RX_STATS ARRAY_SIZE(ionic_rx_stats_desc)
+#define IONIC_NUM_TX_Q_STATS ARRAY_SIZE(ionic_txq_stats_desc)
+#define IONIC_NUM_DBG_CQ_STATS ARRAY_SIZE(ionic_dbg_cq_stats_desc)
+#define IONIC_NUM_DBG_INTR_STATS ARRAY_SIZE(ionic_dbg_intr_stats_desc)
+#define IONIC_NUM_DBG_NAPI_STATS ARRAY_SIZE(ionic_dbg_napi_stats_desc)
+
+#define MAX_Q(lif)   ((lif)->netdev->real_num_tx_queues)
+
+static void ionic_get_lif_stats(struct ionic_lif *lif,
+				struct ionic_lif_sw_stats *stats)
+{
+	struct ionic_tx_stats *tstats;
+	struct ionic_rx_stats *rstats;
+	struct ionic_qcq *txqcq;
+	struct ionic_qcq *rxqcq;
+	int q_num;
+
+	memset(stats, 0, sizeof(*stats));
+
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
+		txqcq = lif_to_txqcq(lif, q_num);
+		if (txqcq && txqcq->stats) {
+			tstats = &txqcq->stats->tx;
+			stats->tx_packets += tstats->pkts;
+			stats->tx_bytes += tstats->bytes;
+			stats->tx_tso += tstats->tso;
+			stats->tx_no_csum += tstats->no_csum;
+			stats->tx_csum += tstats->csum;
+		}
+
+		rxqcq = lif_to_rxqcq(lif, q_num);
+		if (rxqcq && rxqcq->stats) {
+			rstats = &rxqcq->stats->rx;
+			stats->rx_packets += rstats->pkts;
+			stats->rx_bytes += rstats->bytes;
+			stats->rx_csum_none += rstats->csum_none;
+			stats->rx_csum_complete += rstats->csum_complete;
+			stats->rx_csum_error += rstats->csum_error;
+		}
+	}
+}
+
+static u64 ionic_sw_stats_get_count(struct ionic_lif *lif)
+{
+	u64 total = 0;
+
+	/* lif stats */
+	total += IONIC_NUM_LIF_STATS;
+
+	/* tx stats */
+	total += MAX_Q(lif) * IONIC_NUM_TX_STATS;
+
+	/* rx stats */
+	total += MAX_Q(lif) * IONIC_NUM_RX_STATS;
+
+	if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+		/* tx debug stats */
+		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+				      IONIC_NUM_TX_Q_STATS +
+				      IONIC_NUM_DBG_INTR_STATS +
+				      IONIC_MAX_NUM_SG_CNTR);
+
+		/* rx debug stats */
+		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+				      IONIC_NUM_DBG_INTR_STATS +
+				      IONIC_NUM_DBG_NAPI_STATS +
+				      IONIC_MAX_NUM_NAPI_CNTR);
+	}
+
+	return total;
+}
+
+static void ionic_sw_stats_get_strings(struct ionic_lif *lif, u8 **buf)
+{
+	int i, q_num;
+
+	for (i = 0; i < IONIC_NUM_LIF_STATS; i++) {
+		snprintf(*buf, ETH_GSTRING_LEN, ionic_lif_stats_desc[i].name);
+		*buf += ETH_GSTRING_LEN;
+	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
+		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
+			snprintf(*buf, ETH_GSTRING_LEN, "tx_%d_%s",
+				 q_num, ionic_tx_stats_desc[i].name);
+			*buf += ETH_GSTRING_LEN;
+		}
+
+		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_%s",
+					 q_num,
+					 ionic_txq_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_cq_%s",
+					 q_num,
+					 ionic_dbg_cq_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_intr_%s",
+					 q_num,
+					 ionic_dbg_intr_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_sg_cntr_%d",
+					 q_num, i);
+				*buf += ETH_GSTRING_LEN;
+			}
+		}
+	}
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
+		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
+			snprintf(*buf, ETH_GSTRING_LEN,
+				 "rx_%d_%s",
+				 q_num, ionic_rx_stats_desc[i].name);
+			*buf += ETH_GSTRING_LEN;
+		}
+
+		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "rxq_%d_cq_%s",
+					 q_num,
+					 ionic_dbg_cq_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "rxq_%d_intr_%s",
+					 q_num,
+					 ionic_dbg_intr_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "rxq_%d_napi_%s",
+					 q_num,
+					 ionic_dbg_napi_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "rxq_%d_napi_work_done_%d",
+					 q_num, i);
+				*buf += ETH_GSTRING_LEN;
+			}
+		}
+	}
+}
+
+static void ionic_sw_stats_get_values(struct ionic_lif *lif, u64 **buf)
+{
+	struct ionic_lif_sw_stats lif_stats;
+	struct ionic_qcq *txqcq, *rxqcq;
+	int i, q_num;
+
+	ionic_get_lif_stats(lif, &lif_stats);
+
+	for (i = 0; i < IONIC_NUM_LIF_STATS; i++) {
+		**buf = IONIC_READ_STAT64(&lif_stats, &ionic_lif_stats_desc[i]);
+		(*buf)++;
+	}
+
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
+		txqcq = lif_to_txqcq(lif, q_num);
+
+		for (i = 0; i < IONIC_NUM_TX_STATS; i++) {
+			**buf = IONIC_READ_STAT64(&txqcq->stats->tx,
+						  &ionic_tx_stats_desc[i]);
+			(*buf)++;
+		}
+
+		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			for (i = 0; i < IONIC_NUM_TX_Q_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&txqcq->q,
+						      &ionic_txq_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&txqcq->cq,
+						   &ionic_dbg_cq_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&txqcq->intr,
+						 &ionic_dbg_intr_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_MAX_NUM_SG_CNTR; i++) {
+				**buf = txqcq->stats->tx.sg_cntr[i];
+				(*buf)++;
+			}
+		}
+	}
+
+	for (q_num = 0; q_num < MAX_Q(lif); q_num++) {
+		rxqcq = lif_to_rxqcq(lif, q_num);
+
+		for (i = 0; i < IONIC_NUM_RX_STATS; i++) {
+			**buf = IONIC_READ_STAT64(&rxqcq->stats->rx,
+						  &ionic_rx_stats_desc[i]);
+			(*buf)++;
+		}
+
+		if (test_bit(IONIC_LIF_SW_DEBUG_STATS, lif->state)) {
+			for (i = 0; i < IONIC_NUM_DBG_CQ_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&rxqcq->cq,
+						   &ionic_dbg_cq_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_INTR_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&rxqcq->intr,
+						 &ionic_dbg_intr_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&rxqcq->napi_stats,
+						 &ionic_dbg_napi_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < IONIC_MAX_NUM_NAPI_CNTR; i++) {
+				**buf = rxqcq->napi_stats.work_done_cntr[i];
+				(*buf)++;
+			}
+		}
+	}
+}
+
+const struct ionic_stats_group_intf ionic_stats_groups[] = {
+	/* SW Stats group */
+	{
+		.get_strings = ionic_sw_stats_get_strings,
+		.get_values = ionic_sw_stats_get_values,
+		.get_count = ionic_sw_stats_get_count,
+	},
+	/* Add more stat groups here */
+};
+
+const int ionic_num_stats_grps = ARRAY_SIZE(ionic_stats_groups);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.h b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
new file mode 100644
index 000000000000..d2c1122a2c6e
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_STATS_H_
+#define _IONIC_STATS_H_
+
+#define IONIC_STAT_TO_OFFSET(type, stat_name) (offsetof(type, stat_name))
+
+#define IONIC_STAT_DESC(type, stat_name) { \
+	.name = #stat_name, \
+	.offset = IONIC_STAT_TO_OFFSET(type, stat_name) \
+}
+
+#define IONIC_LIF_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_lif_sw_stats, stat_name)
+
+#define IONIC_TX_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_tx_stats, stat_name)
+
+#define IONIC_RX_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_rx_stats, stat_name)
+
+#define IONIC_TX_Q_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_queue, stat_name)
+
+#define IONIC_CQ_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_cq, stat_name)
+
+#define IONIC_INTR_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_intr_info, stat_name)
+
+#define IONIC_NAPI_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct ionic_napi_stats, stat_name)
+
+/* Interface structure for a particalar stats group */
+struct ionic_stats_group_intf {
+	void (*get_strings)(struct ionic_lif *lif, u8 **buf);
+	void (*get_values)(struct ionic_lif *lif, u64 **buf);
+	u64 (*get_count)(struct ionic_lif *lif);
+};
+
+extern const struct ionic_stats_group_intf ionic_stats_groups[];
+extern const int ionic_num_stats_grps;
+
+#define IONIC_READ_STAT64(base_ptr, desc_ptr) \
+	(*((u64 *)(((u8 *)(base_ptr)) + (desc_ptr)->offset)))
+
+struct ionic_stat_desc {
+	char name[ETH_GSTRING_LEN];
+	u64 offset;
+};
+
+#endif /* _IONIC_STATS_H_ */
-- 
2.17.1

