Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8F15A0F66
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiHYLhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiHYLgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:36:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEF932B9B;
        Thu, 25 Aug 2022 04:36:53 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661427411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxL8BjfzaoQ+Wc2gV/weu177+XY+NOHuUD0xlptqLLU=;
        b=iiWytKyRU7K4rzIWhXwOj9q7Y8PZBhvirU1HwD3NNTjeKMhhXABXc9vmNrGxx191iuCHfy
        QUfwSBX6t/GfmD861jZcfpJM1k0LIuD7q/jVytZA2CSpXy0OhBTrsfVwzEkC7RClvEYqgX
        qKDPjQMkqyP+8aygdeuXX3rDfrPcikUNTBevP4pJOub2yAOUTte9bXRxd4MF2psQFPs24j
        cgWjA0ZvRR8P56nOUE+PDTJ4YczM1k/PrMPXxSINB78FBvHi5Y6sUfJ2vecMCYYKPxQUyE
        UaVNXSQd2NysgSQJmcvHb1/hkxy5WkcnyvJw9FPzCM7V75jU3yqLNNSS6feUbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661427411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxL8BjfzaoQ+Wc2gV/weu177+XY+NOHuUD0xlptqLLU=;
        b=bQ4XXTvosRxK9MSn4FNrWeQC0xZkynDhgFpADWq0y8LlZu5JlRz+fJuAc1AvJbhZHnGrPe
        Qh/6IJT+juXEmiBA==
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Eric Dumazet <edumazet@google.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jeroen de Borst <jeroendb@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, oss-drivers@corigine.com,
        stable@vger.kernel.org
Subject: [PATCH net 2/2] net: Use u64_stats_fetch_begin_irq() for stats fetch.
Date:   Thu, 25 Aug 2022 13:36:45 +0200
Message-Id: <20220825113645.212996-3-bigeasy@linutronix.de>
In-Reply-To: <20220825113645.212996-1-bigeasy@linutronix.de>
References: <20220825113645.212996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/cortina/gemini.c         | 24 +++++++++----------
 .../ethernet/fungible/funeth/funeth_txrx.h    |  4 ++--
 drivers/net/ethernet/google/gve/gve_ethtool.c | 16 ++++++-------
 drivers/net/ethernet/google/gve/gve_main.c    | 12 +++++-----
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  4 ++--
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  4 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  8 +++----
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  8 +++----
 drivers/net/netdevsim/netdev.c                |  4 ++--
 net/mac80211/sta_info.c                       |  8 +++----
 net/mpls/af_mpls.c                            |  4 ++--
 11 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/c=
ortina/gemini.c
index 9e6de2f968fa3..6dae768671e3d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1919,7 +1919,7 @@ static void gmac_get_stats64(struct net_device *netde=
v,
=20
 	/* Racing with RX NAPI */
 	do {
-		start =3D u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
=20
 		stats->rx_packets =3D port->stats.rx_packets;
 		stats->rx_bytes =3D port->stats.rx_bytes;
@@ -1931,11 +1931,11 @@ static void gmac_get_stats64(struct net_device *net=
dev,
 		stats->rx_crc_errors =3D port->stats.rx_crc_errors;
 		stats->rx_frame_errors =3D port->stats.rx_frame_errors;
=20
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
=20
 	/* Racing with MIB and TX completion interrupts */
 	do {
-		start =3D u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
=20
 		stats->tx_errors =3D port->stats.tx_errors;
 		stats->tx_packets =3D port->stats.tx_packets;
@@ -1945,15 +1945,15 @@ static void gmac_get_stats64(struct net_device *net=
dev,
 		stats->rx_missed_errors =3D port->stats.rx_missed_errors;
 		stats->rx_fifo_errors =3D port->stats.rx_fifo_errors;
=20
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
=20
 	/* Racing with hard_start_xmit */
 	do {
-		start =3D u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
=20
 		stats->tx_dropped =3D port->stats.tx_dropped;
=20
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
=20
 	stats->rx_dropped +=3D stats->rx_missed_errors;
 }
@@ -2031,18 +2031,18 @@ static void gmac_get_ethtool_stats(struct net_devic=
e *netdev,
 	/* Racing with MIB interrupt */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin(&port->ir_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->ir_stats_syncp);
=20
 		for (i =3D 0; i < RX_STATS_NUM; i++)
 			*p++ =3D port->hw_stats[i];
=20
-	} while (u64_stats_fetch_retry(&port->ir_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->ir_stats_syncp, start));
 	values =3D p;
=20
 	/* Racing with RX NAPI */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin(&port->rx_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->rx_stats_syncp);
=20
 		for (i =3D 0; i < RX_STATUS_NUM; i++)
 			*p++ =3D port->rx_stats[i];
@@ -2050,13 +2050,13 @@ static void gmac_get_ethtool_stats(struct net_devic=
e *netdev,
 			*p++ =3D port->rx_csum_stats[i];
 		*p++ =3D port->rx_napi_exits;
=20
-	} while (u64_stats_fetch_retry(&port->rx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->rx_stats_syncp, start));
 	values =3D p;
=20
 	/* Racing with TX start_xmit */
 	do {
 		p =3D values;
-		start =3D u64_stats_fetch_begin(&port->tx_stats_syncp);
+		start =3D u64_stats_fetch_begin_irq(&port->tx_stats_syncp);
=20
 		for (i =3D 0; i < TX_MAX_FRAGS; i++) {
 			*values++ =3D port->tx_frag_stats[i];
@@ -2065,7 +2065,7 @@ static void gmac_get_ethtool_stats(struct net_device =
*netdev,
 		*values++ =3D port->tx_frags_linearized;
 		*values++ =3D port->tx_hw_csummed;
=20
-	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
+	} while (u64_stats_fetch_retry_irq(&port->tx_stats_syncp, start));
 }
=20
 static int gmac_get_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/n=
et/ethernet/fungible/funeth/funeth_txrx.h
index 53b7e95213a85..671f51135c269 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -206,9 +206,9 @@ struct funeth_rxq {
=20
 #define FUN_QSTAT_READ(q, seq, stats_copy) \
 	do { \
-		seq =3D u64_stats_fetch_begin(&(q)->syncp); \
+		seq =3D u64_stats_fetch_begin_irq(&(q)->syncp); \
 		stats_copy =3D (q)->stats; \
-	} while (u64_stats_fetch_retry(&(q)->syncp, (seq)))
+	} while (u64_stats_fetch_retry_irq(&(q)->syncp, (seq)))
=20
 #define FUN_INT_NAME_LEN (IFNAMSIZ + 16)
=20
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/et=
hernet/google/gve/gve_ethtool.c
index 50b384910c839..7b9a2d9d96243 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -177,14 +177,14 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				struct gve_rx_ring *rx =3D &priv->rx[ring];
=20
 				start =3D
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_pkts =3D rx->rpackets;
 				tmp_rx_bytes =3D rx->rbytes;
 				tmp_rx_skb_alloc_fail =3D rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail =3D rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =3D
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			rx_pkts +=3D tmp_rx_pkts;
 			rx_bytes +=3D tmp_rx_bytes;
@@ -198,10 +198,10 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		if (priv->tx) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_pkts =3D priv->tx[ring].pkt_done;
 				tmp_tx_bytes =3D priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			tx_pkts +=3D tmp_tx_pkts;
 			tx_bytes +=3D tmp_tx_bytes;
@@ -259,13 +259,13 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] =3D rx->fill_cnt - rx->cnt;
 			do {
 				start =3D
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				tmp_rx_bytes =3D rx->rbytes;
 				tmp_rx_skb_alloc_fail =3D rx->rx_skb_alloc_fail;
 				tmp_rx_buf_alloc_fail =3D rx->rx_buf_alloc_fail;
 				tmp_rx_desc_err_dropped_pkt =3D
 					rx->rx_desc_err_dropped_pkt;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			data[i++] =3D tmp_rx_bytes;
 			data[i++] =3D rx->rx_cont_packet_cnt;
@@ -331,9 +331,9 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			}
 			do {
 				start =3D
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				tmp_tx_bytes =3D tx->bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			data[i++] =3D tmp_tx_bytes;
 			data[i++] =3D tx->wake_queue;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ether=
net/google/gve/gve_main.c
index 6cafee55efc32..044db3ebb071c 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -51,10 +51,10 @@ static void gve_get_stats(struct net_device *dev, struc=
t rtnl_link_stats64 *s)
 		for (ring =3D 0; ring < priv->rx_cfg.num_queues; ring++) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->rx[ring].statss);
 				packets =3D priv->rx[ring].rpackets;
 				bytes =3D priv->rx[ring].rbytes;
-			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->rx[ring].statss,
 						       start));
 			s->rx_packets +=3D packets;
 			s->rx_bytes +=3D bytes;
@@ -64,10 +64,10 @@ static void gve_get_stats(struct net_device *dev, struc=
t rtnl_link_stats64 *s)
 		for (ring =3D 0; ring < priv->tx_cfg.num_queues; ring++) {
 			do {
 				start =3D
-				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				  u64_stats_fetch_begin_irq(&priv->tx[ring].statss);
 				packets =3D priv->tx[ring].pkt_done;
 				bytes =3D priv->tx[ring].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+			} while (u64_stats_fetch_retry_irq(&priv->tx[ring].statss,
 						       start));
 			s->tx_packets +=3D packets;
 			s->tx_bytes +=3D bytes;
@@ -1274,9 +1274,9 @@ void gve_handle_report_stats(struct gve_priv *priv)
 			}
=20
 			do {
-				start =3D u64_stats_fetch_begin(&priv->tx[idx].statss);
+				start =3D u64_stats_fetch_begin_irq(&priv->tx[idx].statss);
 				tx_bytes =3D priv->tx[idx].bytes_done;
-			} while (u64_stats_fetch_retry(&priv->tx[idx].statss, start));
+			} while (u64_stats_fetch_retry_irq(&priv->tx[idx].statss, start));
 			stats[stats_idx++] =3D (struct stats) {
 				.stat_name =3D cpu_to_be32(TX_WAKE_CNT),
 				.value =3D cpu_to_be64(priv->tx[idx].wake_queue),
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/eth=
ernet/huawei/hinic/hinic_rx.c
index a866bea651103..e5828a658caf4 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -74,14 +74,14 @@ void hinic_rxq_get_stats(struct hinic_rxq *rxq, struct =
hinic_rxq_stats *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin(&rxq_stats->syncp);
+		start =3D u64_stats_fetch_begin_irq(&rxq_stats->syncp);
 		stats->pkts =3D rxq_stats->pkts;
 		stats->bytes =3D rxq_stats->bytes;
 		stats->errors =3D rxq_stats->csum_errors +
 				rxq_stats->other_errors;
 		stats->csum_errors =3D rxq_stats->csum_errors;
 		stats->other_errors =3D rxq_stats->other_errors;
-	} while (u64_stats_fetch_retry(&rxq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxq_stats->syncp, start));
 }
=20
 /**
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/eth=
ernet/huawei/hinic/hinic_tx.c
index 5051cdff2384b..3b6c7b5857376 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -99,14 +99,14 @@ void hinic_txq_get_stats(struct hinic_txq *txq, struct =
hinic_txq_stats *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin(&txq_stats->syncp);
+		start =3D u64_stats_fetch_begin_irq(&txq_stats->syncp);
 		stats->pkts    =3D txq_stats->pkts;
 		stats->bytes   =3D txq_stats->bytes;
 		stats->tx_busy =3D txq_stats->tx_busy;
 		stats->tx_wake =3D txq_stats->tx_wake;
 		stats->tx_dropped =3D txq_stats->tx_dropped;
 		stats->big_frags_pkts =3D txq_stats->big_frags_pkts;
-	} while (u64_stats_fetch_retry(&txq_stats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&txq_stats->syncp, start));
 }
=20
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index cf4d6f1129fa2..349a2b1a19a24 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1630,21 +1630,21 @@ static void nfp_net_stat64(struct net_device *netde=
v,
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin(&r_vec->rx_sync);
+			start =3D u64_stats_fetch_begin_irq(&r_vec->rx_sync);
 			data[0] =3D r_vec->rx_pkts;
 			data[1] =3D r_vec->rx_bytes;
 			data[2] =3D r_vec->rx_drops;
-		} while (u64_stats_fetch_retry(&r_vec->rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->rx_sync, start));
 		stats->rx_packets +=3D data[0];
 		stats->rx_bytes +=3D data[1];
 		stats->rx_dropped +=3D data[2];
=20
 		do {
-			start =3D u64_stats_fetch_begin(&r_vec->tx_sync);
+			start =3D u64_stats_fetch_begin_irq(&r_vec->tx_sync);
 			data[0] =3D r_vec->tx_pkts;
 			data[1] =3D r_vec->tx_bytes;
 			data[2] =3D r_vec->tx_errors;
-		} while (u64_stats_fetch_retry(&r_vec->tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&r_vec->tx_sync, start));
 		stats->tx_packets +=3D data[0];
 		stats->tx_bytes +=3D data[1];
 		stats->tx_errors +=3D data[2];
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers=
/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index eeb1455a4e5db..b1b1b648e40cb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -649,7 +649,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *ne=
tdev, u64 *data)
 		unsigned int start;
=20
 		do {
-			start =3D u64_stats_fetch_begin(&nn->r_vecs[i].rx_sync);
+			start =3D u64_stats_fetch_begin_irq(&nn->r_vecs[i].rx_sync);
 			data[0] =3D nn->r_vecs[i].rx_pkts;
 			tmp[0] =3D nn->r_vecs[i].hw_csum_rx_ok;
 			tmp[1] =3D nn->r_vecs[i].hw_csum_rx_inner_ok;
@@ -657,10 +657,10 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *=
netdev, u64 *data)
 			tmp[3] =3D nn->r_vecs[i].hw_csum_rx_error;
 			tmp[4] =3D nn->r_vecs[i].rx_replace_buf_alloc_fail;
 			tmp[5] =3D nn->r_vecs[i].hw_tls_rx;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].rx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].rx_sync, start));
=20
 		do {
-			start =3D u64_stats_fetch_begin(&nn->r_vecs[i].tx_sync);
+			start =3D u64_stats_fetch_begin_irq(&nn->r_vecs[i].tx_sync);
 			data[1] =3D nn->r_vecs[i].tx_pkts;
 			data[2] =3D nn->r_vecs[i].tx_busy;
 			tmp[6] =3D nn->r_vecs[i].hw_csum_tx;
@@ -670,7 +670,7 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *ne=
tdev, u64 *data)
 			tmp[10] =3D nn->r_vecs[i].hw_tls_tx;
 			tmp[11] =3D nn->r_vecs[i].tls_tx_fallback;
 			tmp[12] =3D nn->r_vecs[i].tls_tx_no_fallback;
-		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
+		} while (u64_stats_fetch_retry_irq(&nn->r_vecs[i].tx_sync, start));
=20
 		data +=3D NN_RVEC_PER_Q_STATS;
=20
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e470e3398abc2..9a1a5b2036240 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -67,10 +67,10 @@ nsim_get_stats64(struct net_device *dev, struct rtnl_li=
nk_stats64 *stats)
 	unsigned int start;
=20
 	do {
-		start =3D u64_stats_fetch_begin(&ns->syncp);
+		start =3D u64_stats_fetch_begin_irq(&ns->syncp);
 		stats->tx_bytes =3D ns->tx_bytes;
 		stats->tx_packets =3D ns->tx_packets;
-	} while (u64_stats_fetch_retry(&ns->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&ns->syncp, start));
 }
=20
 static int
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cb23da9aff1e6..3bcb0a1767fd2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2316,9 +2316,9 @@ static inline u64 sta_get_tidstats_msdu(struct ieee80=
211_sta_rx_stats *rxstats,
 	u64 value;
=20
 	do {
-		start =3D u64_stats_fetch_begin(&rxstats->syncp);
+		start =3D u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value =3D rxstats->msdu[tid];
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
=20
 	return value;
 }
@@ -2384,9 +2384,9 @@ static inline u64 sta_get_stats_bytes(struct ieee8021=
1_sta_rx_stats *rxstats)
 	u64 value;
=20
 	do {
-		start =3D u64_stats_fetch_begin(&rxstats->syncp);
+		start =3D u64_stats_fetch_begin_irq(&rxstats->syncp);
 		value =3D rxstats->bytes;
-	} while (u64_stats_fetch_retry(&rxstats->syncp, start));
+	} while (u64_stats_fetch_retry_irq(&rxstats->syncp, start));
=20
 	return value;
 }
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 35b5f806fdda1..b52afe316dc41 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1079,9 +1079,9 @@ static void mpls_get_stats(struct mpls_dev *mdev,
=20
 		p =3D per_cpu_ptr(mdev->stats, i);
 		do {
-			start =3D u64_stats_fetch_begin(&p->syncp);
+			start =3D u64_stats_fetch_begin_irq(&p->syncp);
 			local =3D p->stats;
-		} while (u64_stats_fetch_retry(&p->syncp, start));
+		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
=20
 		stats->rx_packets	+=3D local.rx_packets;
 		stats->rx_bytes		+=3D local.rx_bytes;
--=20
2.37.2

