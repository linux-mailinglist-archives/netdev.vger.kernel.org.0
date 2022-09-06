Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41A5AEAE6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbiIFNzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiIFNxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4B8804B0;
        Tue,  6 Sep 2022 06:40:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F4F0614C9;
        Tue,  6 Sep 2022 13:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B7BC433D7;
        Tue,  6 Sep 2022 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471636;
        bh=6EetTVY8S2ZhgawWaaCaZPYbNXdW00FjqEoMiuxcw58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZh0THmr6HG9es+tJ+uG3YExoAjHCZPsovRp+QWwZt532ue6Ab5n1lm9yx0aoWBXL
         VaU+v3OWEaMSXgl2giomYuhGNbyK8vFvnN1tB+sewLqWEkTe52Ki2M16QLwKb3IiwT
         Gne+WNtNFF9LFQu406QarAJiDSYYoNFAVVBVWmTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Eric Dumazet <edumazet@google.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5.15 093/107] net: Use u64_stats_fetch_begin_irq() for stats fetch.
Date:   Tue,  6 Sep 2022 15:31:14 +0200
Message-Id: <20220906132825.765765780@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 278d3ba61563ceed3cb248383ced19e14ec7bc1f upstream.

On 32bit-UP u64_stats_fetch_begin() disables only preemption. If the
reader is in preemptible context and the writer side
(u64_stats_update_begin*()) runs in an interrupt context (IRQ or
softirq) then the writer can update the stats during the read operation.
This update remains undetected.

Use u64_stats_fetch_begin_irq() to ensure the stats fetch on 32bit-UP
are not interrupted by a writer. 32bit-SMP remains unaffected by this
change.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Catherine Sullivan <csully@google.com>
Cc: David Awogbemila <awogbemila@google.com>
Cc: Dimitris Michailidis <dmichail@fungible.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jeroen de Borst <jeroendb@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: oss-drivers@corigine.com
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cortina/gemini.c                |   24 +++++++++----------
 drivers/net/ethernet/google/gve/gve_ethtool.c        |   16 ++++++------
 drivers/net/ethernet/google/gve/gve_main.c           |   12 ++++-----
 drivers/net/ethernet/huawei/hinic/hinic_rx.c         |    4 +--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c         |    4 +--
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |    8 +++---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c |    8 +++---
 drivers/net/netdevsim/netdev.c                       |    4 +--
 net/mac80211/sta_info.c                              |    8 +++---
 net/mpls/af_mpls.c                                   |    4 +--
 10 files changed, 46 insertions(+), 46 deletions(-)

--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1920,7 +1920,7 @@ static void gmac_get_stats64(struct net_
 
 	/* Racing with RX NAPI */
 	do {
-		start = u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
 
 		stats->rx_packets = port->stats.rx_packets;
 		stats->rx_bytes = port->stats.rx_bytes;
@@ -1932,11 +1932,11 @@ static void gmac_get_stats64(struct net_
 		stats->rx_crc_errors = port->stats.rx_crc_errors;
 		stats->rx_frame_errors = port->stats.rx_frame_errors;
 
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
 
 	/* Racing with MIB and TX completion interrupts */
 	do {
-		start = u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
 
 		stats->tx_errors = port->stats.tx_errors;
 		stats->tx_packets = port->stats.tx_packets;
@@ -1946,15 +1946,15 @@ static void gmac_get_stats64(struct net_
 		stats->rx_missed_errors = port->stats.rx_missed_errors;
 		stats->rx_fifo_errors = port->stats.rx_fifo_errors;
 
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
 
 	/* Racing with hard_start_xmit */
 	do {
-		start = u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
 
 		stats->tx_dropped = port->stats.tx_dropped;
 
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
 
 	stats->rx_dropped += stats->rx_missed_errors;
 }
@@ -2032,18 +2032,18 @@ static void gmac_get_ethtool_stats(struc
 	/* Racing with MIB interrupt */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
 
 		for (i = 0; i < RX_STATS_NUM; i++)
 			*p++ = port->hw_stats[i];
 
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
 	values = p;
 
 	/* Racing with RX NAPI */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
 
 		for (i = 0; i < RX_STATUS_NUM; i++)
 			*p++ = port->rx_stats[i];
@@ -2051,13 +2051,13 @@ static void gmac_get_ethtool_stats(struc
 			*p++ = port->rx_csum_stats[i];
 		*p++ = port->rx_napi_exits;
 
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
 	values = p;
 
 	/* Racing with TX start_xmit */
 	do {
 		p = values;
-		start = u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start = u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
 
 		for (i = 0; i < TX_MAX_FRAGS; i++) {
 			*values++ = port->tx_frag_stats[i];
@@ -2066,7 +2066,7 @@ static void gmac_get_ethtool_stats(struc
 		*values++ = port->tx_frags_linearized;
 		*values++ = port->tx_hw_csummed;
 
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
 }
 
 static int gmac_get_ksettings(struct net_device *netdev,
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -174,14 +174,14 @@ gve_get_ethtool_stats(struct net_device
 				struct gve_rx_ring *rx = &priv->rx[ring];
 
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_pkts = rx->rpackets;
 				tmp_rx_bytes = rx->rbytes;
 				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			rx_pkts += tmp_rx_pkts;
 			rx_bytes += tmp_rx_bytes;
@@ -195,10 +195,10 @@ gve_get_ethtool_stats(struct net_device
 		if (priv->tx) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_pkts = priv->tx[ring].pkt_done;
 				tmp_tx_bytes = priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			tx_pkts += tmp_tx_pkts;
 			tx_bytes += tmp_tx_bytes;
@@ -256,13 +256,13 @@ gve_get_ethtool_stats(struct net_device
 			data[i++] = rx->cnt;
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_bytes = rx->rbytes;
 				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			data[i++] = tmp_rx_bytes;
 			/* rx dropped packets */
@@ -323,9 +323,9 @@ gve_get_ethtool_stats(struct net_device
 			}
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_bytes = tx->bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			data[i++] = tmp_tx_bytes;
 			data[i++] = tx->wake_queue;
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -51,10 +51,10 @@ static void gve_get_stats(struct net_dev
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				packets = priv->rx[ring].rpackets;
 				bytes = priv->rx[ring].rbytes;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			s->rx_packets += packets;
 			s->rx_bytes += bytes;
@@ -64,10 +64,10 @@ static void gve_get_stats(struct net_dev
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
 			do {
 				start =
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				packets = priv->tx[ring].pkt_done;
 				bytes = priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			s->tx_packets += packets;
 			s->tx_bytes += bytes;
@@ -1260,9 +1260,9 @@ void gve_handle_report_stats(struct gve_
 			}
 
 			do {
-				start = u64_stats_fetch_begin(&priv->tx[idx].statss);
+				start = u64_stats_fetch_begin_irq(&priv->tx[idx].statss);
 				tx_bytes = priv->tx[idx].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[idx].statss, start));
+			} while (u64_stats_fetch_retry_irq(&priv->tx[idx].statss, start));
 			stats[stats_idx++] = (struct stats) {
 				.stat_name = cpu_to_be32(TX_WAKE_CNT),
 				.value = cpu_to_be64(priv->tx[idx].wake_queue),
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -74,14 +74,14 @@ void hinic_rxq_get_stats(struct hinic_rx
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&rxq_stats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxq_stats->syncp);
 		stats->pkts = rxq_stats->pkts;
 		stats->bytes = rxq_stats->bytes;
 		stats->errors = rxq_stats->csum_errors +
 				rxq_stats->other_errors;
 		stats->csum_errors = rxq_stats->csum_errors;
 		stats->other_errors = rxq_stats->other_errors;
-	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxq_stats->syncp, start));
 }
 
 /**
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -98,14 +98,14 @@ void hinic_txq_get_stats(struct hinic_tx
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&txq_stats->syncp);
+		start = u64_stats_fetch_begin_irq(&txq_stats->syncp);
 		stats->pkts    = txq_stats->pkts;
 		stats->bytes   = txq_stats->bytes;
 		stats->tx_busy = txq_stats->tx_busy;
 		stats->tx_wake = txq_stats->tx_wake;
 		stats->tx_dropped = txq_stats->tx_dropped;
 		stats->big_frags_pkts = txq_stats->big_frags_pkts;
-	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&txq_stats->syncp, start));
 }
 
 /**
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3482,21 +3482,21 @@ static void nfp_net_stat64(struct net_de
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin(&r_vec->rx_sync);
+			start = u64_stats_fetch_begin_irq(&r_vec->rx_sync);
 			data[0] = r_vec->rx_pkts;
 			data[1] = r_vec->rx_bytes;
 			data[2] = r_vec->rx_drops;
-		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->rx_sync, start));
 		stats->rx_packets += data[0];
 		stats->rx_bytes += data[1];
 		stats->rx_dropped += data[2];
 
 		do {
-			start = u64_stats_fetch_begin(&r_vec->tx_sync);
+			start = u64_stats_fetch_begin_irq(&r_vec->tx_sync);
 			data[0] = r_vec->tx_pkts;
 			data[1] = r_vec->tx_bytes;
 			data[2] = r_vec->tx_errors;
-		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->tx_sync, start));
 		stats->tx_packets += data[0];
 		stats->tx_bytes += data[1];
 		stats->tx_errors += data[2];
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -483,7 +483,7 @@ static u64 *nfp_vnic_get_sw_stats(struct
 		unsigned int start;
 
 		do {
-			start = u64_stats_fetch_begin(&nn->r_vecs[i].rx_sync);
+			start = u64_stats_fetch_begin_irq(&nn->r_vecs[i].rx_sync);
 			data[0] = nn->r_vecs[i].rx_pkts;
 			tmp[0] = nn->r_vecs[i].hw_csum_rx_ok;
 			tmp[1] = nn->r_vecs[i].hw_csum_rx_inner_ok;
@@ -491,10 +491,10 @@ static u64 *nfp_vnic_get_sw_stats(struct
 			tmp[3] = nn->r_vecs[i].hw_csum_rx_error;
 			tmp[4] = nn->r_vecs[i].rx_replace_buf_alloc_fail;
 			tmp[5] = nn->r_vecs[i].hw_tls_rx;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].rx_sync, start));
 
 		do {
-			start = u64_stats_fetch_begin(&nn->r_vecs[i].tx_sync);
+			start = u64_stats_fetch_begin_irq(&nn->r_vecs[i].tx_sync);
 			data[1] = nn->r_vecs[i].tx_pkts;
 			data[2] = nn->r_vecs[i].tx_busy;
 			tmp[6] = nn->r_vecs[i].hw_csum_tx;
@@ -504,7 +504,7 @@ static u64 *nfp_vnic_get_sw_stats(struct
 			tmp[10] = nn->r_vecs[i].hw_tls_tx;
 			tmp[11] = nn->r_vecs[i].tls_tx_fallback;
 			tmp[12] = nn->r_vecs[i].tls_tx_no_fallback;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].tx_sync, start));
 
 		data += NN_RVEC_PER_Q_STATS;
 
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -67,10 +67,10 @@ nsim_get_stats64(struct net_device *dev,
 	unsigned int start;
 
 	do {
-		start = u64_stats_fetch_begin(&ns->syncp);
+		start = u64_stats_fetch_begin_irq(&ns->syncp);
 		stats->tx_bytes = ns->tx_bytes;
 		stats->tx_packets = ns->tx_packets;
-	} while (u64_stats_fetch_retry(&ns->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&ns->syncp, start));
 }
 
 static int
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2206,9 +2206,9 @@ static inline u64 sta_get_tidstats_msdu(
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin(&rxstats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value = rxstats->msdu[tid];
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
 
 	return value;
 }
@@ -2272,9 +2272,9 @@ static inline u64 sta_get_stats_bytes(st
 	u64 value;
 
 	do {
-		start = u64_stats_fetch_begin(&rxstats->syncp);
+		start = u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value = rxstats->bytes;
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
 
 	return value;
 }
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1079,9 +1079,9 @@ static void mpls_get_stats(struct mpls_d
 
 		p = per_cpu_ptr(mdev->stats, i);
 		do {
-			start = u64_stats_fetch_begin(&p->syncp);
+			start = u64_stats_fetch_begin_irq(&p->syncp);
 			local = p->stats;
-		} while (u64_stats_fetch_retry(&p->syncp, start));
+		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 		stats->rx_packets	+= local.rx_packets;
 		stats->rx_bytes		+= local.rx_bytes;


