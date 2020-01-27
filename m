Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36B14A483
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgA0NGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:31 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44214 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgA0NG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:29 -0500
Received: by mail-pf1-f193.google.com with SMTP id y5so1822646pfb.11
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0q69hOQzSOwncoPJA/V/eNtXVplCe0gP3Vwfs55jALk=;
        b=jQ0qJYzRXsPC0RYm7BcXsVLoRf1VEaMFOrG/7MR7dHIvk0p9Lu/YAts8viEjYsmotZ
         eGbE3O6ggjqpa/OTHR2H/n31VpyDLq1ripAjQL1/TaBZXNwxHn8wRZ/fHP/ncDvB8QwZ
         N624pcSgM8WQARiQsOUwXhLjWbk2N2QCWS+ldqoUGvx3w8tM2Bu6RQkuBN4UoSuhzJV/
         U14dR5K5KQvXtPYjUpmrEfVHwh2qBxjdTP48ujQ9tPYnEpwh+XyoPC6ZNzswMWx7SXxy
         YNjfcw0uBKiLj7XjX4FrPVdCV3bPyyeLQYs7qCJj0jo0Od/pMeBf8fJHnQLlukNuOef9
         X+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0q69hOQzSOwncoPJA/V/eNtXVplCe0gP3Vwfs55jALk=;
        b=JeB5bVrAs6KGsbL/lq/Sm/4ruV4il7eFVLV3fmFEfKql6Tbw8eQANX/7UcHK1MwcOx
         bT0wcWk1Ltf6NdrqbzvpHhdI4ZEX8IE6Rby18JQef5iH3WR3medkviAIGQ50ncMXETMG
         CuRvCUxwiIaZHkapI4JoKeF2DIQbLwMNBApxaBWIhYdzDp2faWlqvshKqlELR6bSKLNF
         /bYrJqILIHl4C42zPYuuBrnK+RvPWOFrbGtnfej0mms43ewZOKiH826ibCJU4lPdYksC
         W4mnxZfsQSlOhXUl3jTHcqh0Q5QBiP7fHdlVgmaJ7kxsDE/78Or0UD+wKY0Mwugn1lsX
         5UfQ==
X-Gm-Message-State: APjAAAUpa4RNiTWOtyX155cTUxOxf3e4S3QNLA9Hsmm18vv6McnsFlHH
        3BZkSVk99PRRbWthV+4O1tjGp6Iw13o=
X-Google-Smtp-Source: APXvYqwxJNKnXEBCbc+cO7cJBXUwH6J1cE3FK5qVj/olxPIRxYYQMIjhOTsKo8X5M8uM/TJLPLF5og==
X-Received: by 2002:a63:604:: with SMTP id 4mr20290718pgg.406.1580130388460;
        Mon, 27 Jan 2020 05:06:28 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:27 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Christina Jacob <cjacob@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 14/17] octeontx2-pf: Add basic ethtool support
Date:   Mon, 27 Jan 2020 18:35:28 +0530
Message-Id: <1580130331-8964-15-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

This patch adds ethtool support for
 - Driver stats, Tx/Rx perqueue and CGX LMAC stats
 - Set/show Rx/Tx queue count
 - Set/show Rx/Tx ring sizes
 - Set/show IRQ coalescing parameters

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  82 ++++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  10 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 408 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  16 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  11 +
 6 files changed, 525 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 0484d70..41bf00c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -5,6 +5,6 @@
 
 obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
 
-octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o
+octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index c4be787..07d4559 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -16,6 +16,72 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 
+static void otx2_nix_rq_op_stats(struct queue_stats *stats,
+				 struct otx2_nic *pfvf, int qidx)
+{
+	u64 incr = (u64)qidx << 32;
+	u64 *ptr;
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_RQ_OP_OCTS);
+	stats->bytes = otx2_atomic64_add(incr, ptr);
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_RQ_OP_PKTS);
+	stats->pkts = otx2_atomic64_add(incr, ptr);
+}
+
+static void otx2_nix_sq_op_stats(struct queue_stats *stats,
+				 struct otx2_nic *pfvf, int qidx)
+{
+	u64 incr = (u64)qidx << 32;
+	u64 *ptr;
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_OCTS);
+	stats->bytes = otx2_atomic64_add(incr, ptr);
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_PKTS);
+	stats->pkts = otx2_atomic64_add(incr, ptr);
+}
+
+void otx2_update_lmac_stats(struct otx2_nic *pfvf)
+{
+	struct msg_req *req;
+
+	if (!netif_running(pfvf->netdev))
+		return;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	req = otx2_mbox_alloc_msg_cgx_stats(&pfvf->mbox);
+	if (!req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return;
+	}
+
+	otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+}
+
+int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx)
+{
+	struct otx2_rcv_queue *rq = &pfvf->qset.rq[qidx];
+
+	if (!pfvf->qset.rq)
+		return 0;
+
+	otx2_nix_rq_op_stats(&rq->stats, pfvf, qidx);
+	return 1;
+}
+
+int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx)
+{
+	struct otx2_snd_queue *sq = &pfvf->qset.sq[qidx];
+
+	if (!pfvf->qset.sq)
+		return 0;
+
+	otx2_nix_sq_op_stats(&sq->stats, pfvf, qidx);
+	return 1;
+}
+
 void otx2_get_dev_stats(struct otx2_nic *pfvf)
 {
 	struct otx2_dev_stats *dev_stats = &pfvf->hw.dev_stats;
@@ -590,6 +656,9 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->lmt_addr = (__force u64 *)(pfvf->reg_base + LMT_LF_LMTLINEX(qidx));
 	sq->io_addr = (__force u64)otx2_get_regaddr(pfvf, NIX_LF_OP_SENDX(0));
 
+	sq->stats.bytes = 0;
+	sq->stats.pkts = 0;
+
 	/* Get memory to put this msg */
 	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
 	if (!aq)
@@ -1238,6 +1307,18 @@ void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
 	otx2_mbox_unlock(mbox);
 }
 
+/* Mbox message handlers */
+void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
+			    struct cgx_stats_rsp *rsp)
+{
+	int id;
+
+	for (id = 0; id < CGX_RX_STATS_COUNT; id++)
+		pfvf->hw.cgx_rx_stats[id] = rsp->rx_stats[id];
+	for (id = 0; id < CGX_TX_STATS_COUNT; id++)
+		pfvf->hw.cgx_tx_stats[id] = rsp->tx_stats[id];
+}
+
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp)
 {
@@ -1250,7 +1331,6 @@ void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				rsp->schq_list[lvl][schq];
 }
 
-/* Mbox message handlers */
 void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 			       struct npa_lf_alloc_rsp *rsp)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ce7a552..95557e8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -187,6 +187,8 @@ struct otx2_hw {
 	/* Stats */
 	struct otx2_dev_stats	dev_stats;
 	struct otx2_drv_stats	drv_stats;
+	u64			cgx_rx_stats[CGX_RX_STATS_COUNT];
+	u64			cgx_tx_stats[CGX_TX_STATS_COUNT];
 };
 
 struct refill_work {
@@ -588,12 +590,20 @@ void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 			       struct nix_lf_alloc_rsp *rsp);
 void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
 				  struct nix_txsch_alloc_rsp *rsp);
+void mbox_handler_cgx_stats(struct otx2_nic *pfvf,
+			    struct cgx_stats_rsp *rsp);
 
 /* Device stats APIs */
 void otx2_get_dev_stats(struct otx2_nic *pfvf);
 void otx2_get_stats64(struct net_device *netdev,
 		      struct rtnl_link_stats64 *stats);
+void otx2_update_lmac_stats(struct otx2_nic *pfvf);
+int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
+int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
+void otx2_set_ethtool_ops(struct net_device *netdev);
 
 int otx2_open(struct net_device *netdev);
 int otx2_stop(struct net_device *netdev);
+int otx2_set_real_num_queues(struct net_device *netdev,
+			     int tx_queues, int rx_queues);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
new file mode 100644
index 0000000..b1f61e0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/pci.h>
+#include <linux/ethtool.h>
+#include <linux/stddef.h>
+#include <linux/etherdevice.h>
+#include <linux/log2.h>
+
+#include "otx2_common.h"
+
+#define DRV_NAME	"octeontx2-nicpf"
+
+struct otx2_stat {
+	char name[ETH_GSTRING_LEN];
+	unsigned int index;
+};
+
+/* HW device stats */
+#define OTX2_DEV_STAT(stat) { \
+	.name = #stat, \
+	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
+}
+
+static const struct otx2_stat otx2_dev_stats[] = {
+	OTX2_DEV_STAT(rx_ucast_frames),
+	OTX2_DEV_STAT(rx_bcast_frames),
+	OTX2_DEV_STAT(rx_mcast_frames),
+
+	OTX2_DEV_STAT(tx_ucast_frames),
+	OTX2_DEV_STAT(tx_bcast_frames),
+	OTX2_DEV_STAT(tx_mcast_frames),
+};
+
+/* Driver level stats */
+#define OTX2_DRV_STAT(stat) { \
+	.name = #stat, \
+	.index = offsetof(struct otx2_drv_stats, stat) / sizeof(atomic_t), \
+}
+
+static const struct otx2_stat otx2_drv_stats[] = {
+	OTX2_DRV_STAT(rx_fcs_errs),
+	OTX2_DRV_STAT(rx_oversize_errs),
+	OTX2_DRV_STAT(rx_undersize_errs),
+	OTX2_DRV_STAT(rx_csum_errs),
+	OTX2_DRV_STAT(rx_len_errs),
+	OTX2_DRV_STAT(rx_other_errs),
+};
+
+static const struct otx2_stat otx2_queue_stats[] = {
+	{ "bytes", 0 },
+	{ "frames", 1 },
+};
+
+static const unsigned int otx2_n_dev_stats = ARRAY_SIZE(otx2_dev_stats);
+static const unsigned int otx2_n_drv_stats = ARRAY_SIZE(otx2_drv_stats);
+static const unsigned int otx2_n_queue_stats = ARRAY_SIZE(otx2_queue_stats);
+
+static void otx2_dev_open(struct net_device *netdev)
+{
+	otx2_open(netdev);
+}
+
+static void otx2_dev_stop(struct net_device *netdev)
+{
+	otx2_stop(netdev);
+}
+
+static void otx2_get_drvinfo(struct net_device *netdev,
+			     struct ethtool_drvinfo *info)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->bus_info, pci_name(pfvf->pdev), sizeof(info->bus_info));
+}
+
+static void otx2_get_qset_strings(struct otx2_nic *pfvf, u8 **data, int qset)
+{
+	int start_qidx = qset * pfvf->hw.rx_queues;
+	int qidx, stats;
+
+	for (qidx = 0; qidx < pfvf->hw.rx_queues; qidx++) {
+		for (stats = 0; stats < otx2_n_queue_stats; stats++) {
+			sprintf(*data, "rxq%d: %s", qidx + start_qidx,
+				otx2_queue_stats[stats].name);
+			*data += ETH_GSTRING_LEN;
+		}
+	}
+	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+		for (stats = 0; stats < otx2_n_queue_stats; stats++) {
+			sprintf(*data, "txq%d: %s", qidx + start_qidx,
+				otx2_queue_stats[stats].name);
+			*data += ETH_GSTRING_LEN;
+		}
+	}
+}
+
+static void otx2_get_strings(struct net_device *netdev, u32 sset, u8 *data)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int stats;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (stats = 0; stats < otx2_n_dev_stats; stats++) {
+		memcpy(data, otx2_dev_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (stats = 0; stats < otx2_n_drv_stats; stats++) {
+		memcpy(data, otx2_drv_stats[stats].name, ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+
+	otx2_get_qset_strings(pfvf, &data, 0);
+
+	for (stats = 0; stats < CGX_RX_STATS_COUNT; stats++) {
+		sprintf(data, "cgx_rxstat%d: ", stats);
+		data += ETH_GSTRING_LEN;
+	}
+
+	for (stats = 0; stats < CGX_TX_STATS_COUNT; stats++) {
+		sprintf(data, "cgx_txstat%d: ", stats);
+		data += ETH_GSTRING_LEN;
+	}
+
+	strcpy(data, "reset_count");
+	data += ETH_GSTRING_LEN;
+}
+
+static void otx2_get_qset_stats(struct otx2_nic *pfvf,
+				struct ethtool_stats *stats, u64 **data)
+{
+	int stat, qidx;
+
+	if (!pfvf)
+		return;
+	for (qidx = 0; qidx < pfvf->hw.rx_queues; qidx++) {
+		if (!otx2_update_rq_stats(pfvf, qidx)) {
+			for (stat = 0; stat < otx2_n_queue_stats; stat++)
+				*((*data)++) = 0;
+			continue;
+		}
+		for (stat = 0; stat < otx2_n_queue_stats; stat++)
+			*((*data)++) = ((u64 *)&pfvf->qset.rq[qidx].stats)
+				[otx2_queue_stats[stat].index];
+	}
+
+	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+		if (!otx2_update_sq_stats(pfvf, qidx)) {
+			for (stat = 0; stat < otx2_n_queue_stats; stat++)
+				*((*data)++) = 0;
+			continue;
+		}
+		for (stat = 0; stat < otx2_n_queue_stats; stat++)
+			*((*data)++) = ((u64 *)&pfvf->qset.sq[qidx].stats)
+				[otx2_queue_stats[stat].index];
+	}
+}
+
+/* Get device and per queue statistics */
+static void otx2_get_ethtool_stats(struct net_device *netdev,
+				   struct ethtool_stats *stats, u64 *data)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int stat;
+
+	otx2_get_dev_stats(pfvf);
+	for (stat = 0; stat < otx2_n_dev_stats; stat++)
+		*(data++) = ((u64 *)&pfvf->hw.dev_stats)
+				[otx2_dev_stats[stat].index];
+
+	for (stat = 0; stat < otx2_n_drv_stats; stat++)
+		*(data++) = atomic_read(&((atomic_t *)&pfvf->hw.drv_stats)
+						[otx2_drv_stats[stat].index]);
+
+	otx2_get_qset_stats(pfvf, stats, &data);
+	otx2_update_lmac_stats(pfvf);
+	for (stat = 0; stat < CGX_RX_STATS_COUNT; stat++)
+		*(data++) = pfvf->hw.cgx_rx_stats[stat];
+	for (stat = 0; stat < CGX_TX_STATS_COUNT; stat++)
+		*(data++) = pfvf->hw.cgx_tx_stats[stat];
+	*(data++) = pfvf->reset_count;
+}
+
+static int otx2_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int qstats_count;
+
+	if (sset != ETH_SS_STATS)
+		return -EINVAL;
+
+	qstats_count = otx2_n_queue_stats *
+		       (pfvf->hw.rx_queues + pfvf->hw.tx_queues);
+
+	return otx2_n_dev_stats + otx2_n_drv_stats + qstats_count +
+		CGX_RX_STATS_COUNT + CGX_TX_STATS_COUNT + 1;
+}
+
+/* Get no of queues device supports and current queue count */
+static void otx2_get_channels(struct net_device *dev,
+			      struct ethtool_channels *channel)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+
+	channel->max_rx = pfvf->hw.max_queues;
+	channel->max_tx = pfvf->hw.max_queues;
+
+	channel->rx_count = pfvf->hw.rx_queues;
+	channel->tx_count = pfvf->hw.tx_queues;
+}
+
+/* Set no of Tx, Rx queues to be used */
+static int otx2_set_channels(struct net_device *dev,
+			     struct ethtool_channels *channel)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	bool if_up = netif_running(dev);
+	int err = 0;
+
+	if (!channel->rx_count || !channel->tx_count)
+		return -EINVAL;
+
+	if (if_up)
+		otx2_dev_stop(dev);
+
+	err = otx2_set_real_num_queues(dev, channel->tx_count,
+				       channel->rx_count);
+	if (err)
+		goto fail;
+
+	pfvf->hw.rx_queues = channel->rx_count;
+	pfvf->hw.tx_queues = channel->tx_count;
+	pfvf->qset.cq_cnt = pfvf->hw.tx_queues +  pfvf->hw.rx_queues;
+
+fail:
+	if (if_up)
+		otx2_dev_open(dev);
+
+	netdev_info(dev, "Setting num Tx rings to %d, Rx rings to %d success\n",
+		    pfvf->hw.tx_queues, pfvf->hw.rx_queues);
+
+	return err;
+}
+
+static void otx2_get_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct otx2_qset *qs = &pfvf->qset;
+
+	ring->rx_max_pending = Q_COUNT(Q_SIZE_MAX);
+	ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
+	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
+	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
+}
+
+static int otx2_set_ringparam(struct net_device *netdev,
+			      struct ethtool_ringparam *ring)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	bool if_up = netif_running(netdev);
+	struct otx2_qset *qs = &pfvf->qset;
+	u32 rx_count, tx_count;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	/* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
+	rx_count = ring->rx_pending;
+	/* On some silicon variants a skid or reserved CQEs are
+	 * needed to avoid CQ overflow.
+	 */
+	if (rx_count < pfvf->hw.rq_skid)
+		rx_count =  pfvf->hw.rq_skid;
+	rx_count = Q_COUNT(Q_SIZE(rx_count, 3));
+
+	/* Due pipelining impact minimum 2000 unused SQ CQE's
+	 * need to be maintained to avoid CQ overflow, hence the
+	 * minimum 4K size.
+	 */
+	tx_count = clamp_t(u32, ring->tx_pending,
+			   Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
+	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
+
+	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
+		return 0;
+
+	if (if_up)
+		otx2_dev_stop(netdev);
+
+	/* Assigned to the nearest possible exponent. */
+	qs->sqe_cnt = tx_count;
+	qs->rqe_cnt = rx_count;
+
+	if (if_up)
+		otx2_dev_open(netdev);
+	return 0;
+}
+
+static int otx2_get_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *cmd)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct otx2_hw *hw = &pfvf->hw;
+
+	cmd->rx_coalesce_usecs = hw->cq_time_wait;
+	cmd->rx_max_coalesced_frames = hw->cq_ecount_wait;
+	cmd->tx_coalesce_usecs = hw->cq_time_wait;
+	cmd->tx_max_coalesced_frames = hw->cq_ecount_wait;
+
+	return 0;
+}
+
+static int otx2_set_coalesce(struct net_device *netdev,
+			     struct ethtool_coalesce *ec)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct otx2_hw *hw = &pfvf->hw;
+	int qidx;
+
+	if (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce ||
+	    ec->rx_coalesce_usecs_irq || ec->rx_max_coalesced_frames_irq ||
+	    ec->tx_coalesce_usecs_irq || ec->tx_max_coalesced_frames_irq ||
+	    ec->stats_block_coalesce_usecs || ec->pkt_rate_low ||
+	    ec->rx_coalesce_usecs_low || ec->rx_max_coalesced_frames_low ||
+	    ec->tx_coalesce_usecs_low || ec->tx_max_coalesced_frames_low ||
+	    ec->pkt_rate_high || ec->rx_coalesce_usecs_high ||
+	    ec->rx_max_coalesced_frames_high || ec->tx_coalesce_usecs_high ||
+	    ec->tx_max_coalesced_frames_high || ec->rate_sample_interval)
+		return -EOPNOTSUPP;
+
+	if (!ec->rx_max_coalesced_frames || !ec->tx_max_coalesced_frames)
+		return 0;
+
+	/* 'cq_time_wait' is 8bit and is in multiple of 100ns,
+	 * so clamp the user given value to the range of 1 to 25usec.
+	 */
+	ec->rx_coalesce_usecs = clamp_t(u32, ec->rx_coalesce_usecs,
+					1, CQ_TIMER_THRESH_MAX);
+	ec->tx_coalesce_usecs = clamp_t(u32, ec->tx_coalesce_usecs,
+					1, CQ_TIMER_THRESH_MAX);
+
+	/* Rx and Tx are mapped to same CQ, check which one
+	 * is changed, if both then choose the min.
+	 */
+	if (hw->cq_time_wait == ec->rx_coalesce_usecs)
+		hw->cq_time_wait = ec->tx_coalesce_usecs;
+	else if (hw->cq_time_wait == ec->tx_coalesce_usecs)
+		hw->cq_time_wait = ec->rx_coalesce_usecs;
+	else
+		hw->cq_time_wait = min_t(u8, ec->rx_coalesce_usecs,
+					 ec->tx_coalesce_usecs);
+
+	/* Max ecount_wait supported is 16bit,
+	 * so clamp the user given value to the range of 1 to 64k.
+	 */
+	ec->rx_max_coalesced_frames = clamp_t(u32, ec->rx_max_coalesced_frames,
+					      1, U16_MAX);
+	ec->tx_max_coalesced_frames = clamp_t(u32, ec->tx_max_coalesced_frames,
+					      1, U16_MAX);
+
+	/* Rx and Tx are mapped to same CQ, check which one
+	 * is changed, if both then choose the min.
+	 */
+	if (hw->cq_ecount_wait == ec->rx_max_coalesced_frames)
+		hw->cq_ecount_wait = ec->tx_max_coalesced_frames;
+	else if (hw->cq_ecount_wait == ec->tx_max_coalesced_frames)
+		hw->cq_ecount_wait = ec->rx_max_coalesced_frames;
+	else
+		hw->cq_ecount_wait = min_t(u16, ec->rx_max_coalesced_frames,
+					   ec->tx_max_coalesced_frames);
+
+	if (netif_running(netdev)) {
+		for (qidx = 0; qidx < pfvf->hw.cint_cnt; qidx++)
+			otx2_config_irq_coalescing(pfvf, qidx);
+	}
+
+	return 0;
+}
+
+static const struct ethtool_ops otx2_ethtool_ops = {
+	.get_drvinfo		= otx2_get_drvinfo,
+	.get_strings		= otx2_get_strings,
+	.get_ethtool_stats	= otx2_get_ethtool_stats,
+	.get_sset_count		= otx2_get_sset_count,
+	.set_channels		= otx2_set_channels,
+	.get_channels		= otx2_get_channels,
+	.get_ringparam		= otx2_get_ringparam,
+	.set_ringparam		= otx2_set_ringparam,
+	.get_coalesce		= otx2_get_coalesce,
+	.set_coalesce		= otx2_set_coalesce,
+};
+
+void otx2_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &otx2_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 3092634..85f9b9b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -148,6 +148,9 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 		mbox_handler_nix_txsch_alloc(pf,
 					     (struct nix_txsch_alloc_rsp *)msg);
 		break;
+	case MBOX_MSG_CGX_STATS:
+		mbox_handler_cgx_stats(pf, (struct cgx_stats_rsp *)msg);
+		break;
 	default:
 		if (msg->rc)
 			dev_err(pf->dev,
@@ -459,8 +462,8 @@ static int otx2_cgx_config_loopback(struct otx2_nic *pf, bool enable)
 	return err;
 }
 
-static int otx2_set_real_num_queues(struct net_device *netdev,
-				    int tx_queues, int rx_queues)
+int otx2_set_real_num_queues(struct net_device *netdev,
+			     int tx_queues, int rx_queues)
 {
 	int err;
 
@@ -812,6 +815,11 @@ int otx2_open(struct net_device *netdev)
 	if (!qset->sq)
 		goto err_free_mem;
 
+	qset->rq = kcalloc(pf->hw.rx_queues,
+			   sizeof(struct otx2_rcv_queue), GFP_KERNEL);
+	if (!qset->rq)
+		goto err_free_mem;
+
 	err = otx2_init_hw_resources(pf);
 	if (err)
 		goto err_free_mem;
@@ -917,6 +925,7 @@ int otx2_open(struct net_device *netdev)
 err_free_mem:
 	kfree(qset->sq);
 	kfree(qset->cq);
+	kfree(qset->rq);
 	kfree(qset->napi);
 	return err;
 }
@@ -973,6 +982,7 @@ int otx2_stop(struct net_device *netdev)
 
 	kfree(qset->sq);
 	kfree(qset->cq);
+	kfree(qset->rq);
 	kfree(qset->napi);
 	/* Do not clear RQ/SQ ringsize settings */
 	memset((void *)qset + offsetof(struct otx2_qset, sqe_cnt), 0,
@@ -1268,6 +1278,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_detach_rsrc;
 	}
 
+	otx2_set_ethtool_ops(netdev);
+
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 107a261..4ab32d3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -60,6 +60,15 @@
  */
 #define CQ_QCOUNT_DEFAULT	1
 
+struct queue_stats {
+	u64	bytes;
+	u64	pkts;
+};
+
+struct otx2_rcv_queue {
+	struct queue_stats	stats;
+};
+
 struct sg_list {
 	u16	num_segs;
 	u64	skb;
@@ -82,6 +91,7 @@ struct otx2_snd_queue {
 	struct qmem		*sqe;
 	struct qmem		*tso_hdrs;
 	struct sg_list		*sg;
+	struct queue_stats	stats;
 	u16			sqb_count;
 	u64			*sqb_ptrs;
 } ____cacheline_aligned_in_smp;
@@ -134,6 +144,7 @@ struct otx2_qset {
 	struct otx2_cq_poll	*napi;
 	struct otx2_cq_queue	*cq;
 	struct otx2_snd_queue	*sq;
+	struct otx2_rcv_queue	*rq;
 };
 
 /* Translate IOVA to physical address */
-- 
2.7.4

