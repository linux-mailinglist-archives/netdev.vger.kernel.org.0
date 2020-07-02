Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C3B2125EC
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 16:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgGBOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 10:15:39 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:36653 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbgGBOPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 10:15:38 -0400
Received: by mail-ej1-f66.google.com with SMTP id dr13so29846671ejc.3;
        Thu, 02 Jul 2020 07:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xKBi0nSTMNFgZZlMu5ixIplMnKQbkbUnfaBBIy3bv9I=;
        b=ZNpBSueOK+m2roziYrnLxkzX5HaA81iI7jjEtYm7mqpzOd9ybC+oiEDexwDSs4/fOY
         CH5rbYJVhctLszOURcsDr7bWmTctBQwn8QpLpDQTrK49Zvajv8uiLoJOB96UBUT8Jmw3
         Updsd5BDWFDlIeyILy5NNF8Hm9wI3+cYEaH8LICLXrK8Vts/ILhvM6OjgMiK6/3S0jlu
         bnDEsVSzDHA7db2g7UJwm8vp7SBU5DoSf/wAnR7sqvr+YVAA1idVcuaIzdch7177RgvX
         iWZqvQVrSTDN5Ifo8Hx3vqoTEKqHgGXgU7+HhzTJH30GSP4C7E7o5Lj9+YzmgFq9DDdD
         gQ/g==
X-Gm-Message-State: AOAM5310rbVAflHigUgcxOrnvR+LrlRLi8UIOSqhSVKZt+U1RmxAHw6d
        fYg0HQpXH+0X4rMJBH+OVW0igUzU1ksFTg==
X-Google-Smtp-Source: ABdhPJw79E6H0yTBcGr91I/9Ml3iDqZMy4Iqflxu2Za9eIDOkY+bQALg7WyifFLvILxlLRZcgDVzEw==
X-Received: by 2002:a17:906:2b12:: with SMTP id a18mr27352485ejg.186.1593699334300;
        Thu, 02 Jul 2020 07:15:34 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id fi29sm6841274ejb.83.2020.07.02.07.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 07:15:33 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v2 5/5] mvpp2: xdp ethtool stats
Date:   Thu,  2 Jul 2020 16:12:44 +0200
Message-Id: <20200702141244.51295-6-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702141244.51295-1-mcroce@linux.microsoft.com>
References: <20200702141244.51295-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Add ethtool statistics for XDP.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   8 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 158 ++++++++++++++++--
 2 files changed, 148 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index c52955b33fab..ebec47087b27 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -846,6 +846,14 @@ struct mvpp2_pcpu_stats {
 	u64	rx_bytes;
 	u64	tx_packets;
 	u64	tx_bytes;
+	/* XDP */
+	u64	xdp_redirect;
+	u64	xdp_pass;
+	u64	xdp_drop;
+	u64	xdp_xmit;
+	u64	xdp_xmit_err;
+	u64	xdp_tx;
+	u64	xdp_tx_err;
 };
 
 /* Per-CPU port control */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d49a814311be..d8e238ed533e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1485,6 +1485,16 @@ static void mvpp2_port_loopback_set(struct mvpp2_port *port,
 	writel(val, port->base + MVPP2_GMAC_CTRL_1_REG);
 }
 
+enum {
+	ETHTOOL_XDP_REDIRECT,
+	ETHTOOL_XDP_PASS,
+	ETHTOOL_XDP_DROP,
+	ETHTOOL_XDP_TX,
+	ETHTOOL_XDP_TX_ERR,
+	ETHTOOL_XDP_XMIT,
+	ETHTOOL_XDP_XMIT_ERR,
+};
+
 struct mvpp2_ethtool_counter {
 	unsigned int offset;
 	const char string[ETH_GSTRING_LEN];
@@ -1577,10 +1587,21 @@ static const struct mvpp2_ethtool_counter mvpp2_ethtool_rxq_regs[] = {
 	{ MVPP2_RX_PKTS_BM_DROP_CTR, "rxq_%d_packets_bm_drops" },
 };
 
+static const struct mvpp2_ethtool_counter mvpp2_ethtool_xdp[] = {
+	{ ETHTOOL_XDP_REDIRECT, "rx_xdp_redirect", },
+	{ ETHTOOL_XDP_PASS, "rx_xdp_pass", },
+	{ ETHTOOL_XDP_DROP, "rx_xdp_drop", },
+	{ ETHTOOL_XDP_TX, "rx_xdp_tx", },
+	{ ETHTOOL_XDP_TX_ERR, "rx_xdp_tx_errors", },
+	{ ETHTOOL_XDP_XMIT, "tx_xdp_xmit", },
+	{ ETHTOOL_XDP_XMIT_ERR, "tx_xdp_xmit_errors", },
+};
+
 #define MVPP2_N_ETHTOOL_STATS(ntxqs, nrxqs)	(ARRAY_SIZE(mvpp2_ethtool_mib_regs) + \
 						 ARRAY_SIZE(mvpp2_ethtool_port_regs) + \
 						 (ARRAY_SIZE(mvpp2_ethtool_txq_regs) * (ntxqs)) + \
-						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)))
+						 (ARRAY_SIZE(mvpp2_ethtool_rxq_regs) * (nrxqs)) + \
+						 ARRAY_SIZE(mvpp2_ethtool_xdp))
 
 static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 				      u8 *data)
@@ -1619,10 +1640,57 @@ static void mvpp2_ethtool_get_strings(struct net_device *netdev, u32 sset,
 			data += ETH_GSTRING_LEN;
 		}
 	}
+
+	for (i = 0; i < ARRAY_SIZE(mvpp2_ethtool_xdp); i++) {
+		strscpy(data, mvpp2_ethtool_xdp[i].string,
+			ETH_GSTRING_LEN);
+		data += ETH_GSTRING_LEN;
+	}
+}
+
+static void
+mvpp2_get_xdp_stats(struct mvpp2_port *port, struct mvpp2_pcpu_stats *xdp_stats)
+{
+	unsigned int start;
+	unsigned int cpu;
+
+	/* Gather XDP Statistics */
+	for_each_possible_cpu(cpu) {
+		struct mvpp2_pcpu_stats *cpu_stats;
+		u64	xdp_redirect;
+		u64	xdp_pass;
+		u64	xdp_drop;
+		u64	xdp_xmit;
+		u64	xdp_xmit_err;
+		u64	xdp_tx;
+		u64	xdp_tx_err;
+
+		cpu_stats = per_cpu_ptr(port->stats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
+			xdp_redirect = cpu_stats->xdp_redirect;
+			xdp_pass   = cpu_stats->xdp_pass;
+			xdp_drop = cpu_stats->xdp_drop;
+			xdp_xmit   = cpu_stats->xdp_xmit;
+			xdp_xmit_err   = cpu_stats->xdp_xmit_err;
+			xdp_tx   = cpu_stats->xdp_tx;
+			xdp_tx_err   = cpu_stats->xdp_tx_err;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
+
+		xdp_stats->xdp_redirect += xdp_redirect;
+		xdp_stats->xdp_pass   += xdp_pass;
+		xdp_stats->xdp_drop += xdp_drop;
+		xdp_stats->xdp_xmit   += xdp_xmit;
+		xdp_stats->xdp_xmit_err   += xdp_xmit_err;
+		xdp_stats->xdp_tx   += xdp_tx;
+		xdp_stats->xdp_tx_err   += xdp_tx_err;
+	}
 }
 
 static void mvpp2_read_stats(struct mvpp2_port *port)
 {
+	struct mvpp2_pcpu_stats xdp_stats = {};
+	const struct mvpp2_ethtool_counter *s;
 	u64 *pstats;
 	int i, q;
 
@@ -1650,6 +1718,37 @@ static void mvpp2_read_stats(struct mvpp2_port *port)
 			*pstats++ += mvpp2_read_index(port->priv,
 						      port->first_rxq + q,
 						      mvpp2_ethtool_rxq_regs[i].offset);
+
+	/* Gather XDP Statistics */
+	mvpp2_get_xdp_stats(port, &xdp_stats);
+
+	for (i = 0, s = mvpp2_ethtool_xdp;
+		 s < mvpp2_ethtool_xdp + ARRAY_SIZE(mvpp2_ethtool_xdp);
+	     s++, i++) {
+		switch (s->offset) {
+		case ETHTOOL_XDP_REDIRECT:
+			*pstats++ = xdp_stats.xdp_redirect;
+			break;
+		case ETHTOOL_XDP_PASS:
+			*pstats++ = xdp_stats.xdp_pass;
+			break;
+		case ETHTOOL_XDP_DROP:
+			*pstats++ = xdp_stats.xdp_drop;
+			break;
+		case ETHTOOL_XDP_TX:
+			*pstats++ = xdp_stats.xdp_tx;
+			break;
+		case ETHTOOL_XDP_TX_ERR:
+			*pstats++ = xdp_stats.xdp_tx_err;
+			break;
+		case ETHTOOL_XDP_XMIT:
+			*pstats++ = xdp_stats.xdp_xmit;
+			break;
+		case ETHTOOL_XDP_XMIT_ERR:
+			*pstats++ = xdp_stats.xdp_xmit_err;
+			break;
+		}
+	}
 }
 
 static void mvpp2_gather_hw_statistics(struct work_struct *work)
@@ -3063,7 +3162,6 @@ static u32 mvpp2_skb_tx_csum(struct mvpp2_port *port, struct sk_buff *skb)
 static void mvpp2_xdp_finish_tx(struct mvpp2_port *port, u16 txq_id, int nxmit, int nxmit_byte)
 {
 	unsigned int thread = mvpp2_cpu_to_thread(port->priv, smp_processor_id());
-	struct mvpp2_pcpu_stats *stats = per_cpu_ptr(port->stats, thread);
 	struct mvpp2_tx_queue *aggr_txq;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	struct mvpp2_tx_queue *txq;
@@ -3085,11 +3183,6 @@ static void mvpp2_xdp_finish_tx(struct mvpp2_port *port, u16 txq_id, int nxmit,
 	if (txq_pcpu->count >= txq_pcpu->stop_threshold)
 		netif_tx_stop_queue(nq);
 
-	u64_stats_update_begin(&stats->syncp);
-	stats->tx_bytes += nxmit_byte;
-	stats->tx_packets += nxmit;
-	u64_stats_update_end(&stats->syncp);
-
 	/* Finalize TX processing */
 	if (!port->has_tx_irqs && txq_pcpu->count >= txq->done_pkts_coal)
 		mvpp2_txq_done(port, txq, txq_pcpu);
@@ -3162,6 +3255,7 @@ mvpp2_xdp_submit_frame(struct mvpp2_port *port, u16 txq_id,
 static int
 mvpp2_xdp_xmit_back(struct mvpp2_port *port, struct xdp_buff *xdp)
 {
+	struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 	struct xdp_frame *xdpf;
 	u16 txq_id;
 	int ret;
@@ -3176,8 +3270,19 @@ mvpp2_xdp_xmit_back(struct mvpp2_port *port, struct xdp_buff *xdp)
 	txq_id = mvpp2_cpu_to_thread(port->priv, smp_processor_id()) + (port->ntxqs / 2);
 
 	ret = mvpp2_xdp_submit_frame(port, txq_id, xdpf, false);
-	if (ret == MVPP2_XDP_TX)
+	if (ret == MVPP2_XDP_TX) {
+		u64_stats_update_begin(&stats->syncp);
+		stats->tx_bytes += xdpf->len;
+		stats->tx_packets++;
+		stats->xdp_tx++;
+		u64_stats_update_end(&stats->syncp);
+
 		mvpp2_xdp_finish_tx(port, txq_id, 1, xdpf->len);
+	} else {
+		u64_stats_update_begin(&stats->syncp);
+		stats->xdp_tx_err++;
+		u64_stats_update_end(&stats->syncp);
+	}
 
 	return ret;
 }
@@ -3188,6 +3293,7 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	int i, nxmit_byte = 0, nxmit = num_frame;
+	struct mvpp2_pcpu_stats *stats;
 	u16 txq_id;
 	u32 ret;
 
@@ -3212,16 +3318,24 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 		}
 	}
 
-	if (nxmit > 0)
+	if (likely(nxmit > 0))
 		mvpp2_xdp_finish_tx(port, txq_id, nxmit, nxmit_byte);
 
+	stats = this_cpu_ptr(port->stats);
+	u64_stats_update_begin(&stats->syncp);
+	stats->tx_bytes += nxmit_byte;
+	stats->tx_packets += nxmit;
+	stats->xdp_xmit += nxmit;
+	stats->xdp_xmit_err += num_frame - nxmit;
+	u64_stats_update_end(&stats->syncp);
+
 	return nxmit;
 }
 
 static int
 mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 	      struct bpf_prog *prog, struct xdp_buff *xdp,
-	      struct page_pool *pp)
+	      struct page_pool *pp, struct mvpp2_pcpu_stats *stats)
 {
 	unsigned int len, sync, err;
 	struct page *page;
@@ -3236,6 +3350,7 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 
 	switch (act) {
 	case XDP_PASS:
+		stats->xdp_pass++;
 		ret = MVPP2_XDP_PASS;
 		break;
 	case XDP_REDIRECT:
@@ -3246,6 +3361,7 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 			page_pool_put_page(pp, page, sync, true);
 		} else {
 			ret = MVPP2_XDP_REDIR;
+			stats->xdp_redirect++;
 		}
 		break;
 	case XDP_TX:
@@ -3265,6 +3381,7 @@ mvpp2_run_xdp(struct mvpp2_port *port, struct mvpp2_rx_queue *rxq,
 		page = virt_to_head_page(xdp->data);
 		page_pool_put_page(pp, page, sync, true);
 		ret = MVPP2_XDP_DROPPED;
+		stats->xdp_drop++;
 		break;
 	}
 
@@ -3276,14 +3393,13 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		    int rx_todo, struct mvpp2_rx_queue *rxq)
 {
 	struct net_device *dev = port->dev;
+	struct mvpp2_pcpu_stats ps = {};
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
 	struct xdp_buff xdp;
 	int rx_received;
 	int rx_done = 0;
 	u32 xdp_ret = 0;
-	u32 rcvd_pkts = 0;
-	u32 rcvd_bytes = 0;
 
 	rcu_read_lock();
 
@@ -3358,7 +3474,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 			xdp_set_data_meta_invalid(&xdp);
 
-			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp);
+			ret = mvpp2_run_xdp(port, rxq, xdp_prog, &xdp, pp, &ps);
 
 			if (ret) {
 				xdp_ret |= ret;
@@ -3368,6 +3484,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					goto err_drop_frame;
 				}
 
+				ps.rx_packets++;
+				ps.rx_bytes += rx_bytes;
 				continue;
 			}
 		}
@@ -3391,8 +3509,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 					       bm_pool->buf_size, DMA_FROM_DEVICE,
 					       DMA_ATTR_SKIP_CPU_SYNC);
 
-		rcvd_pkts++;
-		rcvd_bytes += rx_bytes;
+		ps.rx_packets++;
+		ps.rx_bytes += rx_bytes;
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
@@ -3414,12 +3532,16 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 	if (xdp_ret & MVPP2_XDP_REDIR)
 		xdp_do_flush_map();
 
-	if (rcvd_pkts) {
+	if (ps.rx_packets) {
 		struct mvpp2_pcpu_stats *stats = this_cpu_ptr(port->stats);
 
 		u64_stats_update_begin(&stats->syncp);
-		stats->rx_packets += rcvd_pkts;
-		stats->rx_bytes   += rcvd_bytes;
+		stats->rx_packets += ps.rx_packets;
+		stats->rx_bytes   += ps.rx_bytes;
+		/* xdp */
+		stats->xdp_redirect += ps.xdp_redirect;
+		stats->xdp_pass += ps.xdp_pass;
+		stats->xdp_drop += ps.xdp_drop;
 		u64_stats_update_end(&stats->syncp);
 	}
 
-- 
2.26.2

