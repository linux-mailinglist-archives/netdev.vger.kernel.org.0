Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFC9261AC5
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbgIHSkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731849AbgIHSj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C30C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 207so16208999ybd.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=SiaamnNXN+MdLB7ZpqKV09NC4MLS3TsUYmRqfBqlvos=;
        b=vbnFwgVfcNW8ao8bOU5wS+3xQKu2SKymd/YC+6wG9YjotxdbT47XV/HToNsQexyp8P
         yqhB3moJBGVlzG5HTsPuyP/LzN+DjvMV539m6JGTGcF9x+tItEAUOg+nYmW2dfR58nDB
         yv64+uqRyCqdT1dc2t24g8MCBYfMIsthVMMNxOFEMeOT17NrkzNvrWa7H8Qfzsa5CR3R
         LeLLKHnF9upYI/07z9NnObimutPIgIMjelOmVXqhjm2/ZFshdGK8/YBeO59bR/JEwUkl
         MMBUXiBjcntLnKvZg3DAmyXRE+mnelRB+Jm29O/ujhjG+p4KBKfmobca2mx8+86i1AeK
         vpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SiaamnNXN+MdLB7ZpqKV09NC4MLS3TsUYmRqfBqlvos=;
        b=irbMoXT6qkGP03q4A6riHlOxyq2p5cnznlIX+mwLCxY4e/kHwtayXkO7u4h9fM5P4C
         JhLE7qqN2C6SbkOKt7P/q8LGk8qAlyYHMVsnhc7+MsUb1UWGC/DO/uJTz4Lh7Lwgwnet
         xb9SYHSlBlbf5d+LD3+MwYDRqQ/8M5U1KbrkRxfQ/M1AtH+4HQ1zFZ0p3kEMQrgFNcj5
         j5gd++3Trh7aGYweZ9vmeXKRBTz3PZUQ5cd1o8T8ErJXMLvEu3XSxCj0cYqZgwUW1V6z
         JZp/fmiUQUk3mMdWj5WVdrv9NtFmiCygtLUv1bbMkyZUi5QDD/DiXrofyfFjy8x3oGKh
         Ck1w==
X-Gm-Message-State: AOAM5305D8aANadIy8QFbpa0sUupmwoFI8VNo2zGLuV01Jf2I1epPqx0
        2w4cFZA4qM5eBEsUE1mIgG2zYXvELc8NzFfU21UUFL+xWFp27SK8IErz1W8ieLCISGCeIdWxkqm
        9LRIcX5JuoNfHuOnrWCyTs0cDBtsFkrKVq5M0sAhqfzYA8RX6gVtYKOkRAKYb7Xos54P0kQjJ
X-Google-Smtp-Source: ABdhPJzFbbo0WfTS1IfZABeMG2rYr9e1LIYYQiRB7i7LE8e4OTSH+5XLYn2uvqotps6IXuAK6AZ7TAid9k9fKHfz
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:640e:: with SMTP id
 y14mr313163ybb.340.1599590364911; Tue, 08 Sep 2020 11:39:24 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:06 -0700
In-Reply-To: <20200908183909.4156744-1-awogbemila@google.com>
Message-Id: <20200908183909.4156744-7-awogbemila@google.com>
Mime-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 6/9] gve: NIC stats for report-stats and for ethtool
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds per queue NIC stats to ethtool stats and to report-stats.
These stats are always exposed to guest whether or not the
report-stats flag is turned on.

Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  4 +
 drivers/net/ethernet/google/gve/gve_adminq.h  |  5 ++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 83 ++++++++++++++++++-
 drivers/net/ethernet/google/gve/gve_main.c    |  4 +-
 4 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index e1183cc35b1c..b348eb360cd0 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -31,6 +31,10 @@
 #define GVE_TX_STATS_REPORT_NUM	5
 #define GVE_RX_STATS_REPORT_NUM	2
 
+/* Numbers of NIC tx/rx stats in stats report. */
+#define NIC_TX_STATS_REPORT_NUM	0
+#define NIC_RX_STATS_REPORT_NUM	4
+
 /* Interval to schedule a service task, 20000ms. */
 #define GVE_SERVICE_TIMER_PERIOD	20000
 
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index b81a3bb76d5e..a6c8c29f0d13 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -205,6 +205,11 @@ enum gve_stat_names {
 	TX_LAST_COMPLETION_PROCESSED	= 5,
 	RX_NEXT_EXPECTED_SEQUENCE	= 6,
 	RX_BUFFERS_POSTED		= 7,
+	// stats from NIC
+	RX_QUEUE_DROP_CNT		= 65,
+	RX_NO_BUFFERS_POSTED		= 66,
+	RX_DROPS_PACKET_OVER_MRU	= 67,
+	RX_DROPS_INVALID_CHECKSUM	= 68,
 };
 
 union gve_adminq_command {
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index e3987faf4b2e..50cadf8755af 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -43,6 +43,8 @@ static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_bytes[%u]",
 	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
+	"rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
+	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
@@ -138,14 +140,30 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		tmp_rx_desc_err_dropped_pkt, tmp_tx_pkts, tmp_tx_bytes;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
 		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes;
+	int stats_idx, base_stats_idx, max_stats_idx;
+	struct stats *report_stats;
+	int *rx_qid_to_stats_idx;
+	int *tx_qid_to_stats_idx;
 	struct gve_priv *priv;
+	bool skip_nic_stats;
 	unsigned int start;
 	int ring;
-	int i;
+	int i, j;
 
 	ASSERT_RTNL();
 
 	priv = netdev_priv(netdev);
+	report_stats = priv->stats_report->stats;
+	rx_qid_to_stats_idx = kmalloc_array(priv->rx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!rx_qid_to_stats_idx)
+		return;
+	tx_qid_to_stats_idx = kmalloc_array(priv->tx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!tx_qid_to_stats_idx) {
+		kfree(rx_qid_to_stats_idx);
+		return;
+	}
 	for (rx_pkts = 0, rx_bytes = 0, rx_skb_alloc_fail = 0,
 	     rx_buf_alloc_fail = 0, rx_desc_err_dropped_pkt = 0, ring = 0;
 	     ring < priv->rx_cfg.num_queues; ring++) {
@@ -207,6 +225,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->stats_report_trigger_cnt;
 	i = GVE_MAIN_STATS_LEN;
 
+	/* For rx cross-reporting stats, start from nic rx stats in report */
+	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
+	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+		base_stats_idx;
+	/* Preprocess the stats report for rx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_RX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		rx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk RX rings */
 	if (priv->rx) {
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
@@ -231,11 +268,41 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				tmp_rx_desc_err_dropped_pkt;
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC rx stats */
+				i += NIC_RX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[rx_qid_to_stats_idx[ring] + j].value);
+
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
 
+	/* For tx cross-reporting stats, start from nic tx stats in report */
+	base_stats_idx = max_stats_idx;
+	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		max_stats_idx;
+	/* Preprocess the stats report for tx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_TX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		tx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk TX rings */
 	if (priv->tx) {
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
@@ -254,11 +321,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = tx->stop_queue;
 			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
 									  tx));
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC tx stats */
+				i += NIC_TX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[tx_qid_to_stats_idx[ring] + j].value);
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
 	}
 
+	kfree(rx_qid_to_stats_idx);
+	kfree(tx_qid_to_stats_idx);
+
 	/* AQ Stats */
 	data[i++] = priv->adminq_prod_cnt;
 	data[i++] = priv->adminq_cmd_fail;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index c84f74cc750b..7e380fdc3aa5 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -101,9 +101,9 @@ static int gve_alloc_stats_report(struct gve_priv *priv)
 {
 	int tx_stats_num, rx_stats_num;
 
-	tx_stats_num = (GVE_TX_STATS_REPORT_NUM) *
+	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
 		       priv->tx_cfg.num_queues;
-	rx_stats_num = (GVE_RX_STATS_REPORT_NUM) *
+	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
 		       priv->rx_cfg.num_queues;
 	priv->stats_report_len = sizeof(struct gve_stats_report) +
 				 (tx_stats_num + rx_stats_num) *
-- 
2.28.0.526.ge36021eeef-goog

