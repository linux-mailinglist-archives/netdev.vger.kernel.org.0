Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD57A53EA
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfIBKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:22:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730645AbfIBKW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:22:57 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AD5E289AC8
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 10:22:56 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id l6so4448772wrn.2
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 03:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HyAV6va8IcvZ2YqGsNWpFZSBGZz9dsnZQFUKW5YhWZI=;
        b=Zb5KbgFbxfEeg8LWQ+GKJ5gjzwmKZzwwJ9Px9UbcnwQ8e7FeXzfArl6CuCIOhr1t+3
         CrGeXaTmvLiza3vBhRm8Ct9eiO0XFKaPhSku3uSFr7OfZG+Pdb9ZIbdAQ3VtnubzNtDg
         rNpYH1KzKWCmB5+5WBIlFO6bEK8y5Zc0YenZHSZhWHas+wcQbO2VOUgRxHRtJoCxc/AI
         IN97kHpUBKgkX2G0zjwEH9csKtr0VOb3xSV7TfN1f+m+/qKSwE5jFbgnRxU+DHxYqA1R
         rG/wfnBzVPc0oVJN4qFG+WkfqTZXiUXJI207TzEhnABgviLq05qaMZhE/9wuf54F9/y5
         LadQ==
X-Gm-Message-State: APjAAAX1a1gFZ1NG9GzHMDLfrmtaVXKALqii8r4mvn3e42d4bR1vDF5E
        vtmb2TvSHtHRJRDAoJEMGOduoFntmcltVJqwpnWMKRULYhACGyKdG6iD/PWFNFhwEkMJ+2v2AFa
        kxAqM8CqBbgKdt8MT
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr37290756wru.27.1567419774928;
        Mon, 02 Sep 2019 03:22:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKaul/VEQ3YuTs/rjyr2GOjMy2S/Ih5G3NO8d7HlADmkQxPewt9n0IhiCAMm74HyrckYvdOw==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr37290710wru.27.1567419774504;
        Mon, 02 Sep 2019 03:22:54 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id h23sm15824669wml.43.2019.09.02.03.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 03:22:53 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/2] mvpp2: percpu buffers
Date:   Mon,  2 Sep 2019 12:21:37 +0200
Message-Id: <20190902102137.841-3-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190902102137.841-1-mcroce@redhat.com>
References: <20190902102137.841-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every mvpp2 unit can use up to 8 buffers mapped by the BM (the HW buffer
manager). The HW will place the frames in the buffer pool depending on the
frame size: short (< 128 bytes), long (< 1664) or jumbo (up to 9856).

As any unit can have up to 4 ports, the driver allocates only 2 pools,
one for small and one long frames, and share them between ports.
When the first port MTU is set higher than 1664 bytes, a third pool is
allocated for jumbo frames.

This shared allocation makes impossible to use percpu allocators,
and creates contention between HW queues.

If possible, i.e. if the number of possible CPU are less than 8 and jumbo
frames are not used, switch to a new scheme: allocate 8 per-cpu pools for
short and long frames and bind every pool to an RXQ.

When the first port MTU is set higher than 1664 bytes, the allocation
scheme is reverted to the old behaviour (3 shared pools), and when all
ports MTU are lowered, the per-cpu buffers are allocated again.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   4 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 241 ++++++++++++++++--
 2 files changed, 222 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4d9564ba68f6..c89dd7169e3c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -683,6 +683,7 @@ enum mvpp2_prs_l3_cast {
 #define MVPP2_BM_SHORT_BUF_NUM		2048
 #define MVPP2_BM_POOL_SIZE_MAX		(16*1024 - MVPP2_BM_POOL_PTR_ALIGN/4)
 #define MVPP2_BM_POOL_PTR_ALIGN		128
+#define MVPP2_BM_MAX_POOLS		8
 
 /* BM cookie (32 bits) definition */
 #define MVPP2_BM_COOKIE_POOL_OFFS	8
@@ -787,6 +788,9 @@ struct mvpp2 {
 	/* Aggregated TXQs */
 	struct mvpp2_tx_queue *aggr_txqs;
 
+	/* Are we using page_pool with per-cpu pools? */
+	int percpu_pools;
+
 	/* BM pools */
 	struct mvpp2_bm_pool *bm_pools;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 871f14cc7284..637d9269d4d3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -292,6 +292,26 @@ static void mvpp2_txq_inc_put(struct mvpp2_port *port,
 		txq_pcpu->txq_put_index = 0;
 }
 
+/* Get number of maximum RXQ */
+static int mvpp2_get_nrxqs(struct mvpp2 *priv)
+{
+	unsigned int nrxqs;
+
+	if (priv->hw_version == MVPP22 && queue_mode == MVPP2_QDIST_SINGLE_MODE)
+		return 1;
+
+	/* According to the PPv2.2 datasheet and our experiments on
+	 * PPv2.1, RX queues have an allocation granularity of 4 (when
+	 * more than a single one on PPv2.2).
+	 * Round up to nearest multiple of 4.
+	 */
+	nrxqs = (num_possible_cpus() + 3) & ~0x3;
+	if (nrxqs > MVPP2_PORT_MAX_RXQ)
+		nrxqs = MVPP2_PORT_MAX_RXQ;
+
+	return nrxqs;
+}
+
 /* Get number of physical egress port */
 static inline int mvpp2_egress_port(struct mvpp2_port *port)
 {
@@ -496,12 +516,15 @@ static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 
 static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 {
-	int i, err, size;
+	int i, err, size, poolnum = MVPP2_BM_POOLS_NUM;
 	struct mvpp2_bm_pool *bm_pool;
 
+	if (priv->percpu_pools)
+		poolnum = mvpp2_get_nrxqs(priv) * 2;
+
 	/* Create all pools with maximum size */
 	size = MVPP2_BM_POOL_SIZE_MAX;
-	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
+	for (i = 0; i < poolnum; i++) {
 		bm_pool = &priv->bm_pools[i];
 		bm_pool->id = i;
 		err = mvpp2_bm_pool_create(dev, priv, bm_pool, size);
@@ -520,9 +543,15 @@ static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 
 static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
-	int i, err;
+	int i, err, poolnum = MVPP2_BM_POOLS_NUM;
 
-	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
+	if (priv->percpu_pools)
+		poolnum = mvpp2_get_nrxqs(priv) * 2;
+
+	dev_info(dev, "using %d %s buffers\n", poolnum,
+		 priv->percpu_pools ? "per-cpu" : "shared");
+
+	for (i = 0; i < poolnum; i++) {
 		/* Mask BM all interrupts */
 		mvpp2_write(priv, MVPP2_BM_INTR_MASK_REG(i), 0);
 		/* Clear BM cause register */
@@ -530,7 +559,7 @@ static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 	}
 
 	/* Allocate and initialize BM pools */
-	priv->bm_pools = devm_kcalloc(dev, MVPP2_BM_POOLS_NUM,
+	priv->bm_pools = devm_kcalloc(dev, poolnum,
 				      sizeof(*priv->bm_pools), GFP_KERNEL);
 	if (!priv->bm_pools)
 		return -ENOMEM;
@@ -676,6 +705,13 @@ static int mvpp2_bm_bufs_add(struct mvpp2_port *port,
 	phys_addr_t phys_addr;
 	void *buf;
 
+	if (port->priv->percpu_pools &&
+	    bm_pool->pkt_size > MVPP2_BM_LONG_PKT_SIZE) {
+		netdev_err(port->dev,
+			   "attempted to use jumbo frames with per-cpu pools");
+		return 0;
+	}
+
 	buf_size = MVPP2_RX_BUF_SIZE(bm_pool->pkt_size);
 	total_size = MVPP2_RX_TOTAL_SIZE(buf_size);
 
@@ -719,7 +755,64 @@ mvpp2_bm_pool_use(struct mvpp2_port *port, unsigned pool, int pkt_size)
 	struct mvpp2_bm_pool *new_pool = &port->priv->bm_pools[pool];
 	int num;
 
-	if (pool >= MVPP2_BM_POOLS_NUM) {
+	if ((port->priv->percpu_pools && pool > mvpp2_get_nrxqs(port->priv) * 2) ||
+	    (!port->priv->percpu_pools && pool >= MVPP2_BM_POOLS_NUM)) {
+		netdev_err(port->dev, "Invalid pool %d\n", pool);
+		return NULL;
+	}
+
+	/* Allocate buffers in case BM pool is used as long pool, but packet
+	 * size doesn't match MTU or BM pool hasn't being used yet
+	 */
+	if (new_pool->pkt_size == 0) {
+		int pkts_num;
+
+		/* Set default buffer number or free all the buffers in case
+		 * the pool is not empty
+		 */
+		pkts_num = new_pool->buf_num;
+		if (pkts_num == 0) {
+			if (port->priv->percpu_pools) {
+				if (pool < port->nrxqs)
+					pkts_num = mvpp2_pools[MVPP2_BM_SHORT].buf_num;
+				else
+					pkts_num = mvpp2_pools[MVPP2_BM_LONG].buf_num;
+			} else {
+				pkts_num = mvpp2_pools[pool].buf_num;
+			}
+		} else {
+			mvpp2_bm_bufs_free(port->dev->dev.parent,
+					   port->priv, new_pool, pkts_num);
+		}
+
+		new_pool->pkt_size = pkt_size;
+		new_pool->frag_size =
+			SKB_DATA_ALIGN(MVPP2_RX_BUF_SIZE(pkt_size)) +
+			MVPP2_SKB_SHINFO_SIZE;
+
+		/* Allocate buffers for this pool */
+		num = mvpp2_bm_bufs_add(port, new_pool, pkts_num);
+		if (num != pkts_num) {
+			WARN(1, "pool %d: %d of %d allocated\n",
+			     new_pool->id, num, pkts_num);
+			return NULL;
+		}
+	}
+
+	mvpp2_bm_pool_bufsize_set(port->priv, new_pool,
+				  MVPP2_RX_BUF_SIZE(new_pool->pkt_size));
+
+	return new_pool;
+}
+
+static struct mvpp2_bm_pool *
+mvpp2_bm_pool_use_percpu(struct mvpp2_port *port, int type,
+			 unsigned int pool, int pkt_size)
+{
+	struct mvpp2_bm_pool *new_pool = &port->priv->bm_pools[pool];
+	int num;
+
+	if (pool > port->nrxqs * 2) {
 		netdev_err(port->dev, "Invalid pool %d\n", pool);
 		return NULL;
 	}
@@ -735,7 +828,7 @@ mvpp2_bm_pool_use(struct mvpp2_port *port, unsigned pool, int pkt_size)
 		 */
 		pkts_num = new_pool->buf_num;
 		if (pkts_num == 0)
-			pkts_num = mvpp2_pools[pool].buf_num;
+			pkts_num = mvpp2_pools[type].buf_num;
 		else
 			mvpp2_bm_bufs_free(port->dev->dev.parent,
 					   port->priv, new_pool, pkts_num);
@@ -760,11 +853,11 @@ mvpp2_bm_pool_use(struct mvpp2_port *port, unsigned pool, int pkt_size)
 	return new_pool;
 }
 
-/* Initialize pools for swf */
-static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
+/* Initialize pools for swf, shared buffers variant */
+static int mvpp2_swf_bm_pool_init_shared(struct mvpp2_port *port)
 {
-	int rxq;
 	enum mvpp2_bm_pool_log_num long_log_pool, short_log_pool;
+	int rxq;
 
 	/* If port pkt_size is higher than 1518B:
 	 * HW Long pool - SW Jumbo pool, HW Short pool - SW Long pool
@@ -808,6 +901,47 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 	return 0;
 }
 
+/* Initialize pools for swf, percpu buffers variant */
+static int mvpp2_swf_bm_pool_init_percpu(struct mvpp2_port *port)
+{
+	struct mvpp2_bm_pool *p;
+	int i;
+
+	for (i = 0; i < port->nrxqs; i++) {
+		p = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_SHORT, i,
+					     mvpp2_pools[MVPP2_BM_SHORT].pkt_size);
+		if (!p)
+			return -ENOMEM;
+
+		port->priv->bm_pools[i].port_map |= BIT(port->id);
+		mvpp2_rxq_short_pool_set(port, i, port->priv->bm_pools[i].id);
+	}
+
+	for (i = 0; i < port->nrxqs; i++) {
+		p = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_LONG, i + port->nrxqs,
+					     mvpp2_pools[MVPP2_BM_LONG].pkt_size);
+		if (!p)
+			return -ENOMEM;
+
+		port->priv->bm_pools[i + port->nrxqs].port_map |= BIT(port->id);
+		mvpp2_rxq_long_pool_set(port, i,
+					port->priv->bm_pools[i + port->nrxqs].id);
+	}
+
+	port->pool_long = NULL;
+	port->pool_short = NULL;
+
+	return 0;
+}
+
+static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
+{
+	if (port->priv->percpu_pools)
+		return mvpp2_swf_bm_pool_init_percpu(port);
+	else
+		return mvpp2_swf_bm_pool_init_shared(port);
+}
+
 static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 			      enum mvpp2_bm_pool_log_num new_long_pool)
 {
@@ -834,6 +968,9 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 	enum mvpp2_bm_pool_log_num new_long_pool;
 	int pkt_size = MVPP2_RX_PKT_SIZE(mtu);
 
+	if (port->priv->percpu_pools)
+		goto out_set;
+
 	/* If port MTU is higher than 1518B:
 	 * HW Long pool - SW Jumbo pool, HW Short pool - SW Long pool
 	 * else: HW Long pool - SW Long pool, HW Short pool - SW Short pool
@@ -863,6 +1000,7 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		mvpp2_set_hw_csum(port, new_long_pool);
 	}
 
+out_set:
 	dev->mtu = mtu;
 	dev->wanted_features = dev->features;
 
@@ -3706,10 +3844,48 @@ static int mvpp2_set_mac_address(struct net_device *dev, void *p)
 	return err;
 }
 
+/* Shut down all the ports, reconfigure the pools as percpu or shared,
+ * then bring up again all ports.
+ */
+static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
+{
+	int numbufs = MVPP2_BM_POOLS_NUM, i;
+	struct mvpp2_port *port = NULL;
+	bool status[MVPP2_MAX_PORTS];
+
+	for (i = 0; i < priv->port_count; i++) {
+		port = priv->port_list[i];
+		status[i] = netif_running(port->dev);
+		if (status[i])
+			mvpp2_stop(port->dev);
+	}
+
+	/* nrxqs is the same for all ports */
+	if (priv->percpu_pools)
+		numbufs = port->nrxqs * 2;
+
+	for (i = 0; i < numbufs; i++)
+		mvpp2_bm_pool_destroy(port->dev->dev.parent, priv, &priv->bm_pools[i]);
+
+	devm_kfree(port->dev->dev.parent, priv->bm_pools);
+	priv->percpu_pools = percpu;
+	mvpp2_bm_init(port->dev->dev.parent, priv);
+
+	for (i = 0; i < priv->port_count; i++) {
+		port = priv->port_list[i];
+		mvpp2_swf_bm_pool_init(port);
+		if (status[i])
+			mvpp2_open(port->dev);
+	}
+
+	return 0;
+}
+
 static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	bool running = netif_running(dev);
+	struct mvpp2 *priv = port->priv;
 	int err;
 
 	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
@@ -3718,6 +3894,31 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
+		if (priv->percpu_pools) {
+			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
+			mvpp2_bm_switch_buffers(priv, false);
+		}
+	} else {
+		bool jumbo = false;
+		int i;
+
+		for (i = 0; i < priv->port_count; i++)
+			if (priv->port_list[i] != port &&
+			    MVPP2_RX_PKT_SIZE(priv->port_list[i]->dev->mtu) >
+			    MVPP2_BM_LONG_PKT_SIZE) {
+				jumbo = true;
+				break;
+			}
+
+		/* No port is using jumbo frames */
+		if (!jumbo) {
+			dev_info(port->dev->dev.parent,
+				 "all ports have a low MTU, switching to per-cpu buffers");
+			mvpp2_bm_switch_buffers(priv, true);
+		}
+	}
+
 	if (running)
 		mvpp2_stop_dev(port);
 
@@ -5025,18 +5226,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	}
 
 	ntxqs = MVPP2_MAX_TXQ;
-	if (priv->hw_version == MVPP22 && queue_mode == MVPP2_QDIST_SINGLE_MODE) {
-		nrxqs = 1;
-	} else {
-		/* According to the PPv2.2 datasheet and our experiments on
-		 * PPv2.1, RX queues have an allocation granularity of 4 (when
-		 * more than a single one on PPv2.2).
-		 * Round up to nearest multiple of 4.
-		 */
-		nrxqs = (num_possible_cpus() + 3) & ~0x3;
-		if (nrxqs > MVPP2_PORT_MAX_RXQ)
-			nrxqs = MVPP2_PORT_MAX_RXQ;
-	}
+	nrxqs = mvpp2_get_nrxqs(priv);
 
 	dev = alloc_etherdev_mqs(sizeof(*port), ntxqs, nrxqs);
 	if (!dev)
@@ -5202,7 +5392,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		dev->features |= NETIF_F_NTUPLE;
 	}
 
-	mvpp2_set_hw_csum(port, port->pool_long->id);
+	if (!port->priv->percpu_pools)
+		mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
@@ -5582,6 +5773,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 			priv->sysctrl_base = NULL;
 	}
 
+	if (priv->hw_version == MVPP22 &&
+	    mvpp2_get_nrxqs(priv) * 2 <= MVPP2_BM_MAX_POOLS)
+		priv->percpu_pools = 1;
+
 	mvpp2_setup_bm_pool();
 
 
-- 
2.21.0

