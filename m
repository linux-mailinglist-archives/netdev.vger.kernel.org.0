Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1E5476720
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 01:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhLPArX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 19:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhLPArU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 19:47:20 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D884AC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:19 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w2-20020a627b02000000b0049fa951281fso14396569pfc.9
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 16:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5D+ShvjgcU7ed+hKOQlJMneE8N9UvAX/syZ4CjDlJA8=;
        b=kmISZFcja7CJB/mbHsa0KiczBYaiSTqekNnkfkcB1ukOvtItbXO/HJKlaHD+bP0bqm
         1jpQxCU0x1g+TmN5698ikbIv5Ae4Mj1y5W/VeTSsKgGY53jWFOUW9Xyh9iSMnUm6PUau
         ogn/IavGzONbh84HGHuZNU7T5fJJE+ReX98derPKsR8NHDGfEcROPqbW9YXWSn0cBFu2
         +tDo+5G/T8mbR+DI6DSb/gkkt8iIrgfr7yQJ8dhKOkTsD6cmfX6K/l+RO5H1qVyGsPZK
         tp4t1UhYi6D3i9zDtdtgavloqos1rFT/Jw87daTk6NE7JjzZt9KdMNzRh61BWdzR3j5v
         879g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5D+ShvjgcU7ed+hKOQlJMneE8N9UvAX/syZ4CjDlJA8=;
        b=t1JD67IBUSyo7R6BJkzqJCFy5e3T0LD0wwEIIut5kqiD22LHuQpcmG93XnlTyMb+gB
         26WsTo/aqhscSd8Bp9zMwVTB5oPzGtXRhiy1dmrb5fY6XHozG1pnow6j59UfJmh95LLO
         A+tTudHkXcxvLpxynbGzKauxMYu5YN1aAuVIbLCABz7IIPGvG208JozeOIbnQ0CbL/41
         JmuUtWu72FoYUabo5LBOnow1SnONvk25gcFOAlVHkpTvSSxfTcpnUyYUpVK+nou1ouxX
         UzX74nocT/lhzDbJJmW+gmOTjwSchRYvGjqz36owB0QM8JrEeXipgPBNBCKU0jRgwnTO
         uzdQ==
X-Gm-Message-State: AOAM532hhEc0WouppduynY9BWm9DwWP1fLEWE09XNSWpQSzGMcK0ygcS
        hJ3w3ng7SSUOQUjBTSaeSFCPoxWmSqN5brgft25P205g3eyRD6uAV3QOsE6ExYNXxWEPJOxPsjs
        i4m5LcOBjYnIUmGLatRVRnJatFPkWelYsvRzJAasqkNCRfY2AFd09YLBAt8tMMvoIQNk=
X-Google-Smtp-Source: ABdhPJxFJDgtlzyNnK3CSja3Qqz2W/pGOQYcGZpxhvYxXNwmpx8ihzr/0JTdRiAukfFSkxLNHJFUje6jhguhrg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:964d:9084:bbdd:97a9])
 (user=jeroendb job=sendgmr) by 2002:a17:902:bd44:b0:148:a2e8:2c51 with SMTP
 id b4-20020a170902bd4400b00148a2e82c51mr7039696plx.160.1639615639318; Wed, 15
 Dec 2021 16:47:19 -0800 (PST)
Date:   Wed, 15 Dec 2021 16:46:51 -0800
In-Reply-To: <20211216004652.1021911-1-jeroendb@google.com>
Message-Id: <20211216004652.1021911-8-jeroendb@google.com>
Mime-Version: 1.0
References: <20211216004652.1021911-1-jeroendb@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH net-next 7/8] gve: Add consumed counts to ethtool stats
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jordan Kim <jrkim@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jordan Kim <jrkim@google.com>

Being able to see how many descriptors are in-use is helpful
when diagnosing certain issues.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: Jordan Kim <jrkim@google.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index fd2d2c705391..e0815bb031e9 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -42,7 +42,7 @@ static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 };
 
 static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
-	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_bytes[%u]",
+	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_consumed_desc[%u]", "rx_bytes[%u]",
 	"rx_cont_packet_cnt[%u]", "rx_frag_flip_cnt[%u]", "rx_frag_copy_cnt[%u]",
 	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
 	"rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
@@ -50,7 +50,7 @@ static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
-	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_bytes[%u]",
+	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_consumed_desc[%u]", "tx_bytes[%u]",
 	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
 	"tx_dma_mapping_error[%u]",
 };
@@ -139,10 +139,11 @@ static void
 gve_get_ethtool_stats(struct net_device *netdev,
 		      struct ethtool_stats *stats, u64 *data)
 {
-	u64 tmp_rx_pkts, tmp_rx_bytes, tmp_rx_skb_alloc_fail,	tmp_rx_buf_alloc_fail,
-		tmp_rx_desc_err_dropped_pkt, tmp_tx_pkts, tmp_tx_bytes;
+	u64 tmp_rx_pkts, tmp_rx_bytes, tmp_rx_skb_alloc_fail,
+		tmp_rx_buf_alloc_fail, tmp_rx_desc_err_dropped_pkt,
+		tmp_tx_pkts, tmp_tx_bytes;
 	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
-		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes;
+		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes, tx_dropped;
 	int stats_idx, base_stats_idx, max_stats_idx;
 	struct stats *report_stats;
 	int *rx_qid_to_stats_idx;
@@ -191,7 +192,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			rx_desc_err_dropped_pkt += tmp_rx_desc_err_dropped_pkt;
 		}
 	}
-	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
+	for (tx_pkts = 0, tx_bytes = 0, tx_dropped = 0, ring = 0;
 	     ring < priv->tx_cfg.num_queues; ring++) {
 		if (priv->tx) {
 			do {
@@ -203,6 +204,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 						       start));
 			tx_pkts += tmp_tx_pkts;
 			tx_bytes += tmp_tx_bytes;
+			tx_dropped += priv->tx[ring].dropped_pkt;
 		}
 	}
 
@@ -214,9 +216,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	/* total rx dropped packets */
 	data[i++] = rx_skb_alloc_fail + rx_buf_alloc_fail +
 		    rx_desc_err_dropped_pkt;
-	/* Skip tx_dropped */
-	i++;
-
+	data[i++] = tx_dropped;
 	data[i++] = priv->tx_timeo_cnt;
 	data[i++] = rx_skb_alloc_fail;
 	data[i++] = rx_buf_alloc_fail;
@@ -255,6 +255,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 
 			data[i++] = rx->fill_cnt;
 			data[i++] = rx->cnt;
+			data[i++] = rx->fill_cnt - rx->cnt;
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->rx[ring].statss);
@@ -318,12 +319,14 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			if (gve_is_gqi(priv)) {
 				data[i++] = tx->req;
 				data[i++] = tx->done;
+				data[i++] = tx->req - tx->done;
 			} else {
 				/* DQO doesn't currently support
 				 * posted/completed descriptor counts;
 				 */
 				data[i++] = 0;
 				data[i++] = 0;
+				data[i++] = tx->dqo_tx.tail - tx->dqo_tx.head;
 			}
 			do {
 				start =
-- 
2.34.1.173.g76aa8bc2d0-goog

