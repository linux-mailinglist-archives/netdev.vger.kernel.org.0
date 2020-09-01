Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA07025A102
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgIAVwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgIAVwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C91CC061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j20so2704905ybt.10
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=c20ktH6NmViBNAmU75r3cg0aTyG4UTJz4SQKC6m12jk=;
        b=lt2nq6eGWWdymykMHQ5DOmFQG5Q6XG3eSBSqqh/wavQqePoE48wAh8rtlP+bgRY6rK
         6GfgB7CyKx+DApz3XdEFZtHZrS9Y/h2Ae4Rsk9djLLte+Q9sB/jG76Lh6mPfAGP1+4ks
         BJvHVKELX5Kam4X7yhpHMqr+3ZYmZSCEUB8cteCST2ooo1cRvtZYgIJ+hv6ApMhC1U9Y
         txT/DbnDlmOwPqdAZpPLd8tGmq0R7z+ByE1KaFkWtg3bnKTDAMBUa79ceVxdYyb+U/ML
         8lv0/l0bvtfddZrI6ZHTqLUNrGgueewXjjLMGButB+Hg2QNRiu9BXTOfk7onfADmEGB9
         VJQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=c20ktH6NmViBNAmU75r3cg0aTyG4UTJz4SQKC6m12jk=;
        b=LC9IAsaOT+2bn1j+f9Fnq4m+j87PZhj3/Hte0CJJ3EN2cNP3v4o0r9DACHTGkevqNg
         M3cry0NCA/C9flsdmFrH7U6WxIt7Cwdj3/Wg3xQaGT5EEuQiNNbbuZJ0q9Bj5ePGqWhL
         yi5nIKN1cg9hy/6b5umRkIHSk3x9pie04KlcJo0tuUo0BbHtd+pp5DOu5LsKa+UOAaIo
         lZFdscOMwYKjRnBF7gdh38YtMXX9Mb+78/FgJo8xe/1GfCRjUTSZFneSlbDSaPp6/+9u
         3tcG7k53XnpRz8R88mB4DhpN24A7DMbLcsE0/KOTG9fhfU/ry68ih2kWz9j9LHuYWZPn
         MyiQ==
X-Gm-Message-State: AOAM5327roSLpbGS/tiZ7zKblWTJ+kZ/WNqdNO3LViP4BejPcxLxGijF
        RgSy4BXexf+FTro0CuUmx0FGacMN+NvIeZEN3Qp6hf3fF7R4HqoA5PW0t58UPJEDfjFtBVFqOJQ
        46L1pr89BeAtqqv1E9mZnagm/Yd91g2PL338Xdb4NyyRC10aWb+Aa5Hq9DDP14SyHGEay9QnD
X-Google-Smtp-Source: ABdhPJz7dJDsRcYmnipGrb2aoIM3GSEb7unIJ711RdZSF46jnA3PQKFR4X2NK8AWo/p3JiFHbrL2XK0hG37dd+Ck
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:2e12:: with SMTP id
 u18mr5295029ybu.437.1598997127259; Tue, 01 Sep 2020 14:52:07 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:46 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-7-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 6/9] gve: NIC stats for report-stats and for ethtool
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
index 9957a7d535ad..bc54059f9b2e 100644
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
index 8d70df2447ef..db5642fe966f 100644
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
@@ -206,6 +224,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->dma_mapping_error;
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
@@ -230,11 +267,41 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
@@ -253,11 +320,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
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
index b76fc547cf5d..0c94dda67ba4 100644
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
2.28.0.402.g5ffc5be6b7-goog

