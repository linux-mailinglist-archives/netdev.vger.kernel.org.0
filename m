Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26820DD81
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgF2S7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:59:48 -0400
Received: from inva021.nxp.com ([92.121.34.21]:35558 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbgF2S7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:59:45 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1063C20103B;
        Mon, 29 Jun 2020 12:40:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 04775200191;
        Mon, 29 Jun 2020 12:40:05 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CA566205D4;
        Mon, 29 Jun 2020 12:40:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] dpaa2-eth: add software counter for Tx frames converted to S/G
Date:   Mon, 29 Jun 2020 13:39:54 +0300
Message-Id: <20200629103954.18021-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200629103954.18021-1-ioana.ciornei@nxp.com>
References: <20200629103954.18021-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the previous commit, in case of insufficient SKB headroom on the Tx
path instead of reallocing the SKB we now send a S/G frame descriptor.
Export the number of occurences of this case as a per CPU counter (in
debugfs) and a total number in the ethtool statistics - "tx converted sg
frames'.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 7 ++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c         | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h         | 3 +++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c     | 2 ++
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 5cb357c74dec..56d9927fbfda 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -19,14 +19,14 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Per-CPU stats for %s\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s\n",
+	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s%16s%16s%16s\n",
 		   "CPU", "Rx", "Rx Err", "Rx SG", "Tx", "Tx Err", "Tx conf",
-		   "Tx SG", "Enq busy");
+		   "Tx SG", "Tx converted to SG", "Enq busy");
 
 	for_each_online_cpu(i) {
 		stats = per_cpu_ptr(priv->percpu_stats, i);
 		extras = per_cpu_ptr(priv->percpu_extras, i);
-		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu\n",
+		seq_printf(file, "%3d%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu%16llu\n",
 			   i,
 			   stats->rx_packets,
 			   stats->rx_errors,
@@ -35,6 +35,7 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 			   stats->tx_errors,
 			   extras->tx_conf_frames,
 			   extras->tx_sg_frames,
+			   extras->tx_converted_sg_frames,
 			   extras->tx_portal_busy);
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 4a264b75c035..bc1f1e0117b6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -960,6 +960,8 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 		err = build_sg_fd_single_buf(priv, skb, &fd);
 		percpu_extras->tx_sg_frames++;
 		percpu_extras->tx_sg_bytes += skb->len;
+		percpu_extras->tx_converted_sg_frames++;
+		percpu_extras->tx_converted_sg_bytes += skb->len;
 	} else {
 		err = build_single_fd(priv, skb, &fd);
 	}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9e4ceb92f240..9138a35a68f9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -285,6 +285,9 @@ struct dpaa2_eth_drv_stats {
 	__u64	tx_sg_bytes;
 	__u64	rx_sg_frames;
 	__u64	rx_sg_bytes;
+	/* Linear skbs sent as a S/G FD due to insufficient headroom */
+	__u64	tx_converted_sg_frames;
+	__u64	tx_converted_sg_bytes;
 	/* Enqueues retried due to portal busy */
 	__u64	tx_portal_busy;
 };
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index c4cbbcaa9a3f..8356f1fbbee1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -45,6 +45,8 @@ static char dpaa2_ethtool_extras[][ETH_GSTRING_LEN] = {
 	"[drv] tx sg bytes",
 	"[drv] rx sg frames",
 	"[drv] rx sg bytes",
+	"[drv] tx converted sg frames",
+	"[drv] tx converted sg bytes",
 	"[drv] enqueue portal busy",
 	/* Channel stats */
 	"[drv] dequeue portal busy",
-- 
2.25.1

