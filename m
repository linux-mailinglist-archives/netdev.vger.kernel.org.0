Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC24B70BA9
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbfGVVkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:51 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45776 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732827AbfGVVkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so18268306pgp.12
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=mzsn/kyC8LtkIUbFNcUTEX7TB/tuLsEMof7/29hib+k=;
        b=oiv8WWmWqDoDPctb4xheH928hg4EYS0Ba7iI7QMvxWNc7apLtldQCmnpiDBWZ6NE0I
         pB9+NVU54+HY0iZ+eccquey00IomJrPIkHT0S5vn8VbzrNt5et/38e1hK9hV7YCSmVGf
         IaShODpIQCFTfO1i1YO1CpVuuvWQqf3MkuILrXzFeP+t9BdPg0CF/l/RREWgeFjkO8dH
         itbvXhj4gsSfIX2PHD3eAUp+/m/VL09q71jnqbHvrntc5WuOIkylM3CqS+1gb2GWStL/
         99+vyrKg697WDEvp4PXuU/y3eZ6bsbxdiv+o30GvivrCHswtcg4uAXstuxxlJ4tf3QVX
         hylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=mzsn/kyC8LtkIUbFNcUTEX7TB/tuLsEMof7/29hib+k=;
        b=qRXwUJ+HcBbbIMrC1wEF7rkAGvkuv9zw5SLftPpL49fxPTrcV/IG56lfRmyzwNue4t
         B+u7yaFtDfeH47IHhypD2rBVrURfxWz9Rw9JZk9lIsDMUI5vFteYlOHMwxNWOKrl/1Qg
         CC2eJzjuCgT+nRPRLpN/lbRPScLkhtS7S9mlwzzI2A8MHEqD+QTs3YBkZ6uRiyjrjdEa
         zzJW7LLhv+iYAHR2iydEqRYqYRq0F95u0qcz+VS59vpqdTtBMAfLMFTBJBGrdBO1QX53
         MRxCiImb4R40WNzxUEjUfv66BewNeA8SU8/g2vF7GfBI+CTib6YFFwNm/l7vDRQ+8mdf
         dknQ==
X-Gm-Message-State: APjAAAWRvU1zwShru2aoGrsiKd/QQbcUY2ggf/6YfKlSSiDjsbby7dXK
        GfsxE8KSXO5TwanyhnW6abQ5yg==
X-Google-Smtp-Source: APXvYqy6OeXix0jRbk2dkSEiDmpLmyYAWt1RSzlDUq8+OtGzf6cVexC+xZKHmGZMP+tKlrYhVjy3Og==
X-Received: by 2002:a63:f04:: with SMTP id e4mr71431449pgl.38.1563831645780;
        Mon, 22 Jul 2019 14:40:45 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:45 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 16/19] ionic: Add driver stats
Date:   Mon, 22 Jul 2019 14:40:20 -0700
Message-Id: <20190722214023.9513-17-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
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
 drivers/net/ethernet/pensando/ionic/Makefile  |   3 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 101 ++++++
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  14 +
 .../net/ethernet/pensando/ionic/ionic_stats.c | 333 ++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_stats.h |  53 +++
 5 files changed, 503 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_stats.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 0e2dc53f08d4..4f3cfbf36c23 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -4,4 +4,5 @@
 obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
-	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o
+	   ionic_lif.o ionic_rx_filter.o ionic_txrx.o ionic_debugfs.o \
+	   ionic_stats.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index f7899be547c3..d7503a3dafb7 100644
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
+static void ionic_get_stats_strings(struct lif *lif, u8 *buf)
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
+	struct lif *lif;
+	u32 i;
+
+	lif = netdev_priv(netdev);
+
+	memset(buf, 0, stats->n_stats * sizeof(*buf));
+	for (i = 0; i < ionic_num_stats_grps; i++)
+		ionic_stats_groups[i].get_values(lif, &buf);
+}
+
+static int ionic_get_stats_count(struct lif *lif)
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
+	struct lif *lif = netdev_priv(netdev);
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
+	struct lif *lif = netdev_priv(netdev);
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
@@ -398,6 +468,32 @@ static int ionic_set_channels(struct net_device *netdev,
 	return 0;
 }
 
+static u32 ionic_get_priv_flags(struct net_device *netdev)
+{
+	struct lif *lif = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (test_bit(LIF_SW_DEBUG_STATS, lif->state))
+		priv_flags |= PRIV_F_SW_DBG_STATS;
+
+	return priv_flags;
+}
+
+static int ionic_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct lif *lif = netdev_priv(netdev);
+	u32 flags = lif->flags;
+
+	clear_bit(LIF_SW_DEBUG_STATS, lif->state);
+	if (priv_flags & PRIV_F_SW_DBG_STATS)
+		set_bit(LIF_SW_DEBUG_STATS, lif->state);
+
+	if (flags != lif->flags)
+		lif->flags = flags;
+
+	return 0;
+}
+
 static int ionic_get_module_info(struct net_device *netdev,
 				 struct ethtool_modinfo *modinfo)
 
@@ -481,6 +577,11 @@ static const struct ethtool_ops ionic_ethtool_ops = {
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
index 88d5bf8f58a1..f93bfa2b4393 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -108,8 +108,22 @@ struct ionic_deferred {
 	struct work_struct work;
 };
 
+struct lif_sw_stats {
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
 enum lif_state_flags {
 	LIF_INITED,
+	LIF_SW_DEBUG_STATS,
 	LIF_UP,
 	LIF_LINK_CHECK_NEEDED,
 	LIF_QUEUE_RESET,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_stats.c b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
new file mode 100644
index 000000000000..978a9f89804a
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_stats.c
@@ -0,0 +1,333 @@
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
+static void ionic_get_lif_stats(struct lif *lif, struct lif_sw_stats *stats)
+{
+	struct tx_stats *tstats;
+	struct rx_stats *rstats;
+	struct qcq *txqcq;
+	struct qcq *rxqcq;
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
+static u64 ionic_sw_stats_get_count(struct lif *lif)
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
+	if (test_bit(LIF_SW_DEBUG_STATS, lif->state)) {
+		/* tx debug stats */
+		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+				      IONIC_NUM_TX_Q_STATS +
+				      IONIC_NUM_DBG_INTR_STATS +
+				      IONIC_NUM_DBG_NAPI_STATS +
+				      MAX_NUM_NAPI_CNTR +
+				      MAX_NUM_SG_CNTR);
+
+		/* rx debug stats */
+		total += MAX_Q(lif) * (IONIC_NUM_DBG_CQ_STATS +
+				      IONIC_NUM_DBG_INTR_STATS +
+				      IONIC_NUM_DBG_NAPI_STATS +
+				      MAX_NUM_NAPI_CNTR);
+	}
+
+	return total;
+}
+
+static void ionic_sw_stats_get_strings(struct lif *lif, u8 **buf)
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
+		if (test_bit(LIF_SW_DEBUG_STATS, lif->state)) {
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
+			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_napi_%s",
+					 q_num,
+					 ionic_dbg_napi_stats_desc[i].name);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < MAX_NUM_NAPI_CNTR; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "txq_%d_napi_work_done_%d",
+					 q_num, i);
+				*buf += ETH_GSTRING_LEN;
+			}
+			for (i = 0; i < MAX_NUM_SG_CNTR; i++) {
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
+		if (test_bit(LIF_SW_DEBUG_STATS, lif->state)) {
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
+			for (i = 0; i < MAX_NUM_NAPI_CNTR; i++) {
+				snprintf(*buf, ETH_GSTRING_LEN,
+					 "rxq_%d_napi_work_done_%d",
+					 q_num, i);
+				*buf += ETH_GSTRING_LEN;
+			}
+		}
+	}
+}
+
+static void ionic_sw_stats_get_values(struct lif *lif, u64 **buf)
+{
+	struct lif_sw_stats lif_stats;
+	struct qcq *txqcq, *rxqcq;
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
+		if (test_bit(LIF_SW_DEBUG_STATS, lif->state)) {
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
+			for (i = 0; i < IONIC_NUM_DBG_NAPI_STATS; i++) {
+				**buf = IONIC_READ_STAT64(&txqcq->napi_stats,
+						 &ionic_dbg_napi_stats_desc[i]);
+				(*buf)++;
+			}
+			for (i = 0; i < MAX_NUM_NAPI_CNTR; i++) {
+				**buf = txqcq->napi_stats.work_done_cntr[i];
+				(*buf)++;
+			}
+			for (i = 0; i < MAX_NUM_SG_CNTR; i++) {
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
+		if (test_bit(LIF_SW_DEBUG_STATS, lif->state)) {
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
+			for (i = 0; i < MAX_NUM_NAPI_CNTR; i++) {
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
index 000000000000..efa76694634e
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
+	IONIC_STAT_DESC(struct lif_sw_stats, stat_name)
+
+#define IONIC_TX_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct tx_stats, stat_name)
+
+#define IONIC_RX_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct rx_stats, stat_name)
+
+#define IONIC_TX_Q_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct queue, stat_name)
+
+#define IONIC_CQ_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct cq, stat_name)
+
+#define IONIC_INTR_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct intr, stat_name)
+
+#define IONIC_NAPI_STAT_DESC(stat_name) \
+	IONIC_STAT_DESC(struct napi_stats, stat_name)
+
+/* Interface structure for a particalar stats group */
+struct ionic_stats_group_intf {
+	void (*get_strings)(struct lif *lif, u8 **buf);
+	void (*get_values)(struct lif *lif, u64 **buf);
+	u64 (*get_count)(struct lif *lif);
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

