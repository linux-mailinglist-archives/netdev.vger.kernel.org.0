Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE9BCF986
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbfJHMLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:11:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54034 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbfJHMLK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5CACA1A024F;
        Tue,  8 Oct 2019 14:11:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 447A51A002E;
        Tue,  8 Oct 2019 14:11:08 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 0270D205DB;
        Tue,  8 Oct 2019 14:11:07 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        linux-kernel@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH 07/20] dpaa_eth: use only one buffer pool per interface
Date:   Tue,  8 Oct 2019 15:10:28 +0300
Message-Id: <1570536641-25104-8-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the DPAA Ethernet driver is using three buffer pools
for each interface, with three different sizes for the buffers
provided for the FMan reception path. This patch reduces the
number of buffer pools to one per interface. This change is in
preparation of another, that will be switching from netdev_frags
to page backed buffers for the receive path.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     | 95 ++++++++--------------
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h     |  4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |  6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 44 +++++-----
 4 files changed, 57 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 639cafaa59b8..7bfe437b0a50 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -178,23 +178,7 @@ struct fm_port_fqs {
 /* All the dpa bps in use at any moment */
 static struct dpaa_bp *dpaa_bp_array[BM_MAX_NUM_OF_POOLS];
 
-/* The raw buffer size must be cacheline aligned */
 #define DPAA_BP_RAW_SIZE 4096
-/* When using more than one buffer pool, the raw sizes are as follows:
- * 1 bp: 4KB
- * 2 bp: 2KB, 4KB
- * 3 bp: 1KB, 2KB, 4KB
- * 4 bp: 1KB, 2KB, 4KB, 8KB
- */
-static inline size_t bpool_buffer_raw_size(u8 index, u8 cnt)
-{
-	size_t res = DPAA_BP_RAW_SIZE / 4;
-	u8 i;
-
-	for (i = (cnt < 3) ? cnt : 3; i < 3 + index; i++)
-		res *= 2;
-	return res;
-}
 
 /* FMan-DMA requires 16-byte alignment for Rx buffers, but SKB_DATA_ALIGN is
  * even stronger (SMP_CACHE_BYTES-aligned), so we just get away with that,
@@ -596,10 +580,7 @@ static void dpaa_bp_free(struct dpaa_bp *dpaa_bp)
 
 static void dpaa_bps_free(struct dpaa_priv *priv)
 {
-	int i;
-
-	for (i = 0; i < DPAA_BPS_NUM; i++)
-		dpaa_bp_free(priv->dpaa_bps[i]);
+	dpaa_bp_free(priv->dpaa_bp);
 }
 
 /* Use multiple WQs for FQ assignment:
@@ -1197,15 +1178,15 @@ static int dpaa_eth_init_tx_port(struct fman_port *port, struct dpaa_fq *errq,
 	return err;
 }
 
-static int dpaa_eth_init_rx_port(struct fman_port *port, struct dpaa_bp **bps,
-				 size_t count, struct dpaa_fq *errq,
+static int dpaa_eth_init_rx_port(struct fman_port *port, struct dpaa_bp *bp,
+				 struct dpaa_fq *errq,
 				 struct dpaa_fq *defq, struct dpaa_fq *pcdq,
 				 struct dpaa_buffer_layout *buf_layout)
 {
 	struct fman_buffer_prefix_content buf_prefix_content;
 	struct fman_port_rx_params *rx_p;
 	struct fman_port_params params;
-	int i, err;
+	int err;
 
 	memset(&params, 0, sizeof(params));
 	memset(&buf_prefix_content, 0, sizeof(buf_prefix_content));
@@ -1224,12 +1205,9 @@ static int dpaa_eth_init_rx_port(struct fman_port *port, struct dpaa_bp **bps,
 		rx_p->pcd_fqs_count = DPAA_ETH_PCD_RXQ_NUM;
 	}
 
-	count = min(ARRAY_SIZE(rx_p->ext_buf_pools.ext_buf_pool), count);
-	rx_p->ext_buf_pools.num_of_pools_used = (u8)count;
-	for (i = 0; i < count; i++) {
-		rx_p->ext_buf_pools.ext_buf_pool[i].id =  bps[i]->bpid;
-		rx_p->ext_buf_pools.ext_buf_pool[i].size = (u16)bps[i]->size;
-	}
+	rx_p->ext_buf_pools.num_of_pools_used = 1;
+	rx_p->ext_buf_pools.ext_buf_pool[0].id =  bp->bpid;
+	rx_p->ext_buf_pools.ext_buf_pool[0].size = (u16)bp->size;
 
 	err = fman_port_config(port, &params);
 	if (err) {
@@ -1252,7 +1230,7 @@ static int dpaa_eth_init_rx_port(struct fman_port *port, struct dpaa_bp **bps,
 }
 
 static int dpaa_eth_init_ports(struct mac_device *mac_dev,
-			       struct dpaa_bp **bps, size_t count,
+			       struct dpaa_bp *bp,
 			       struct fm_port_fqs *port_fqs,
 			       struct dpaa_buffer_layout *buf_layout,
 			       struct device *dev)
@@ -1266,7 +1244,7 @@ static int dpaa_eth_init_ports(struct mac_device *mac_dev,
 	if (err)
 		return err;
 
-	err = dpaa_eth_init_rx_port(rxport, bps, count, port_fqs->rx_errq,
+	err = dpaa_eth_init_rx_port(rxport, bp, port_fqs->rx_errq,
 				    port_fqs->rx_defq, port_fqs->rx_pcdq,
 				    &buf_layout[RX]);
 
@@ -1583,17 +1561,16 @@ static int dpaa_eth_refill_bpools(struct dpaa_priv *priv)
 {
 	struct dpaa_bp *dpaa_bp;
 	int *countptr;
-	int res, i;
+	int res;
+
+	dpaa_bp = priv->dpaa_bp;
+	if (!dpaa_bp)
+		return -EINVAL;
+	countptr = this_cpu_ptr(dpaa_bp->percpu_count);
+	res  = dpaa_eth_refill_bpool(dpaa_bp, countptr);
+	if (res)
+		return res;
 
-	for (i = 0; i < DPAA_BPS_NUM; i++) {
-		dpaa_bp = priv->dpaa_bps[i];
-		if (!dpaa_bp)
-			return -EINVAL;
-		countptr = this_cpu_ptr(dpaa_bp->percpu_count);
-		res  = dpaa_eth_refill_bpool(dpaa_bp, countptr);
-		if (res)
-			return res;
-	}
 	return 0;
 }
 
@@ -2761,13 +2738,13 @@ static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
 
 static int dpaa_eth_probe(struct platform_device *pdev)
 {
-	struct dpaa_bp *dpaa_bps[DPAA_BPS_NUM] = {NULL};
+	struct dpaa_bp *dpaa_bp = NULL;
 	struct net_device *net_dev = NULL;
 	struct dpaa_fq *dpaa_fq, *tmp;
 	struct dpaa_priv *priv = NULL;
 	struct fm_port_fqs port_fqs;
 	struct mac_device *mac_dev;
-	int err = 0, i, channel;
+	int err = 0, channel;
 	struct device *dev;
 
 	dev = &pdev->dev;
@@ -2856,23 +2833,21 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	priv->buf_layout[TX].priv_data_size = DPAA_TX_PRIV_DATA_SIZE; /* Tx */
 
 	/* bp init */
-	for (i = 0; i < DPAA_BPS_NUM; i++) {
-		dpaa_bps[i] = dpaa_bp_alloc(dev);
-		if (IS_ERR(dpaa_bps[i])) {
-			err = PTR_ERR(dpaa_bps[i]);
-			goto free_dpaa_bps;
-		}
-		/* the raw size of the buffers used for reception */
-		dpaa_bps[i]->raw_size = bpool_buffer_raw_size(i, DPAA_BPS_NUM);
-		/* avoid runtime computations by keeping the usable size here */
-		dpaa_bps[i]->size = dpaa_bp_size(dpaa_bps[i]->raw_size);
-		dpaa_bps[i]->priv = priv;
-
-		err = dpaa_bp_alloc_pool(dpaa_bps[i]);
-		if (err < 0)
-			goto free_dpaa_bps;
-		priv->dpaa_bps[i] = dpaa_bps[i];
+	dpaa_bp = dpaa_bp_alloc(dev);
+	if (IS_ERR(dpaa_bp)) {
+		err = PTR_ERR(dpaa_bp);
+		goto free_dpaa_bps;
 	}
+	/* the raw size of the buffers used for reception */
+	dpaa_bp->raw_size = DPAA_BP_RAW_SIZE;
+	/* avoid runtime computations by keeping the usable size here */
+	dpaa_bp->size = dpaa_bp_size(dpaa_bp->raw_size);
+	dpaa_bp->priv = priv;
+
+	err = dpaa_bp_alloc_pool(dpaa_bp);
+	if (err < 0)
+		goto free_dpaa_bps;
+	priv->dpaa_bp = dpaa_bp;
 
 	INIT_LIST_HEAD(&priv->dpaa_fq_list);
 
@@ -2930,7 +2905,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[RX]);
 
 	/* All real interfaces need their ports initialized */
-	err = dpaa_eth_init_ports(mac_dev, dpaa_bps, DPAA_BPS_NUM, &port_fqs,
+	err = dpaa_eth_init_ports(mac_dev, dpaa_bp, &port_fqs,
 				  &priv->buf_layout[0], dev);
 	if (err)
 		goto free_dpaa_fqs;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
index 1bdfead1d334..fc2cc4c48e06 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
@@ -47,8 +47,6 @@
 /* Total number of Tx queues */
 #define DPAA_ETH_TXQ_NUM	(DPAA_TC_NUM * DPAA_TC_TXQ_NUM)
 
-#define DPAA_BPS_NUM 3 /* number of bpools per interface */
-
 /* More detailed FQ types - used for fine-grained WQ assignments */
 enum dpaa_fq_type {
 	FQ_TYPE_RX_DEFAULT = 1, /* Rx Default FQs */
@@ -148,7 +146,7 @@ struct dpaa_buffer_layout {
 
 struct dpaa_priv {
 	struct dpaa_percpu_priv __percpu *percpu_priv;
-	struct dpaa_bp *dpaa_bps[DPAA_BPS_NUM];
+	struct dpaa_bp *dpaa_bp;
 	/* Store here the needed Tx headroom for convenience and speed
 	 * (even though it can be computed based on the fields of buf_layout)
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
index 0d9b185e317f..ee62d25cac81 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c
@@ -131,11 +131,9 @@ static ssize_t dpaa_eth_show_bpids(struct device *dev,
 {
 	struct dpaa_priv *priv = netdev_priv(to_net_dev(dev));
 	ssize_t bytes = 0;
-	int i = 0;
 
-	for (i = 0; i < DPAA_BPS_NUM; i++)
-		bytes += snprintf(buf + bytes, PAGE_SIZE - bytes, "%u\n",
-				  priv->dpaa_bps[i]->bpid);
+	bytes += snprintf(buf + bytes, PAGE_SIZE - bytes, "%u\n",
+				  priv->dpaa_bp->bpid);
 
 	return bytes;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 7ce2e99b594d..bc6ed1df53ca 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -223,7 +223,7 @@ static int dpaa_get_sset_count(struct net_device *net_dev, int type)
 	unsigned int total_stats, num_stats;
 
 	num_stats   = num_online_cpus() + 1;
-	total_stats = num_stats * (DPAA_STATS_PERCPU_LEN + DPAA_BPS_NUM) +
+	total_stats = num_stats * (DPAA_STATS_PERCPU_LEN + 1) +
 			DPAA_STATS_GLOBAL_LEN;
 
 	switch (type) {
@@ -235,10 +235,10 @@ static int dpaa_get_sset_count(struct net_device *net_dev, int type)
 }
 
 static void copy_stats(struct dpaa_percpu_priv *percpu_priv, int num_cpus,
-		       int crr_cpu, u64 *bp_count, u64 *data)
+		       int crr_cpu, u64 bp_count, u64 *data)
 {
 	int num_values = num_cpus + 1;
-	int crr = 0, j;
+	int crr = 0;
 
 	/* update current CPU's stats and also add them to the total values */
 	data[crr * num_values + crr_cpu] = percpu_priv->in_interrupt;
@@ -262,23 +262,21 @@ static void copy_stats(struct dpaa_percpu_priv *percpu_priv, int num_cpus,
 	data[crr * num_values + crr_cpu] = percpu_priv->stats.rx_errors;
 	data[crr++ * num_values + num_cpus] += percpu_priv->stats.rx_errors;
 
-	for (j = 0; j < DPAA_BPS_NUM; j++) {
-		data[crr * num_values + crr_cpu] = bp_count[j];
-		data[crr++ * num_values + num_cpus] += bp_count[j];
-	}
+	data[crr * num_values + crr_cpu] = bp_count;
+	data[crr++ * num_values + num_cpus] += bp_count;
 }
 
 static void dpaa_get_ethtool_stats(struct net_device *net_dev,
 				   struct ethtool_stats *stats, u64 *data)
 {
-	u64 bp_count[DPAA_BPS_NUM], cg_time, cg_num;
 	struct dpaa_percpu_priv *percpu_priv;
 	struct dpaa_rx_errors rx_errors;
 	unsigned int num_cpus, offset;
+	u64 bp_count, cg_time, cg_num;
 	struct dpaa_ern_cnt ern_cnt;
 	struct dpaa_bp *dpaa_bp;
 	struct dpaa_priv *priv;
-	int total_stats, i, j;
+	int total_stats, i;
 	bool cg_status;
 
 	total_stats = dpaa_get_sset_count(net_dev, ETH_SS_STATS);
@@ -292,12 +290,10 @@ static void dpaa_get_ethtool_stats(struct net_device *net_dev,
 
 	for_each_online_cpu(i) {
 		percpu_priv = per_cpu_ptr(priv->percpu_priv, i);
-		for (j = 0; j < DPAA_BPS_NUM; j++) {
-			dpaa_bp = priv->dpaa_bps[j];
-			if (!dpaa_bp->percpu_count)
-				continue;
-			bp_count[j] = *(per_cpu_ptr(dpaa_bp->percpu_count, i));
-		}
+		dpaa_bp = priv->dpaa_bp;
+		if (!dpaa_bp->percpu_count)
+			continue;
+		bp_count = *(per_cpu_ptr(dpaa_bp->percpu_count, i));
 		rx_errors.dme += percpu_priv->rx_errors.dme;
 		rx_errors.fpe += percpu_priv->rx_errors.fpe;
 		rx_errors.fse += percpu_priv->rx_errors.fse;
@@ -315,7 +311,7 @@ static void dpaa_get_ethtool_stats(struct net_device *net_dev,
 		copy_stats(percpu_priv, num_cpus, i, bp_count, data);
 	}
 
-	offset = (num_cpus + 1) * (DPAA_STATS_PERCPU_LEN + DPAA_BPS_NUM);
+	offset = (num_cpus + 1) * (DPAA_STATS_PERCPU_LEN + 1);
 	memcpy(data + offset, &rx_errors, sizeof(struct dpaa_rx_errors));
 
 	offset += sizeof(struct dpaa_rx_errors) / sizeof(u64);
@@ -363,18 +359,16 @@ static void dpaa_get_strings(struct net_device *net_dev, u32 stringset,
 		memcpy(strings, string_cpu, ETH_GSTRING_LEN);
 		strings += ETH_GSTRING_LEN;
 	}
-	for (i = 0; i < DPAA_BPS_NUM; i++) {
-		for (j = 0; j < num_cpus; j++) {
-			snprintf(string_cpu, ETH_GSTRING_LEN,
-				 "bpool %c [CPU %d]", 'a' + i, j);
-			memcpy(strings, string_cpu, ETH_GSTRING_LEN);
-			strings += ETH_GSTRING_LEN;
-		}
-		snprintf(string_cpu, ETH_GSTRING_LEN, "bpool %c [TOTAL]",
-			 'a' + i);
+	for (j = 0; j < num_cpus; j++) {
+		snprintf(string_cpu, ETH_GSTRING_LEN,
+			 "bpool [CPU %d]", j);
 		memcpy(strings, string_cpu, ETH_GSTRING_LEN);
 		strings += ETH_GSTRING_LEN;
 	}
+	snprintf(string_cpu, ETH_GSTRING_LEN, "bpool [TOTAL]");
+	memcpy(strings, string_cpu, ETH_GSTRING_LEN);
+	strings += ETH_GSTRING_LEN;
+
 	memcpy(strings, dpaa_stats_global, size);
 }
 
-- 
2.1.0

