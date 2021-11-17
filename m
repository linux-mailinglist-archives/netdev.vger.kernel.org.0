Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E33453EEF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbhKQDc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhKQDc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 22:32:29 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE14C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:31 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id m14so1302624pfc.9
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 19:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=195m4L1AEz3C00l4iwV+xs/UMtYvFmbN/Wn3E0rnD3U=;
        b=US8q9I1cwxC6sQhwXgEwGuOjxiph6MDiK6nRXVEIMXlBxdv23OnY1JtrI8o8oa60Aw
         lRbGbfDRAvzyoBvGaYbFZcuyWcjWOI5TGkngPTI3ZXVW2MdhGFUw//rFwiyv3NG2bRXy
         7YWKT3906IMS9DrC7yXEL747y+hmTE1YHzQCXg3Q2mYvebFHFoERIqLF05+2PeCLOUgt
         2kQYwZ+T9HY/Ej9SiVCBpGMG6CiPxbu5gvnuCruAIv1vqS4SNG+JHp73Au3/XlqLXoyt
         FF0RSU9Xfu6JprZW2pz4RGdq6J7NLJ4hM7/MPSSgUXrT88Vzzad+9QWsqMKRj+5o2YW4
         oDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=195m4L1AEz3C00l4iwV+xs/UMtYvFmbN/Wn3E0rnD3U=;
        b=ZTX5gB3TNqgdgY7M845EiFavxk03iMLkNR++cKH1z5IV/zkWyfld1ezfuA7lmBzrEt
         aalUSXa1jwWwDuz/2LHyH1TSq8kiiGuIfB3lNRArzWDmlQHUV5IEdoaUp1/cYcI9hR1S
         XGxhjx1NY2cixZ80I84o4c2zbetUuR2JXn19+q0zdR8wQbPQJy4FTwGEeAGDiWCj55m7
         XpE54Kx3t/HJoEbKLe8talV+o1ssiPbe11+oZfjz2Kgt9kqHope/yM3Ss5ZnO4MOyO6c
         8CBFZWuiHiBgdbgOq0uWWhj2IEtDZjxPexRViaPZdVBM3Z2FU75XuTgxid3Z7R+G2v8n
         6ZCg==
X-Gm-Message-State: AOAM530weNrmCrKAdD7ju//Wm4Lft01IMGUf2n9oP/tZXsI6mSFgfEdq
        MvfPOW5Ewf0lZ0m8kkhpFyM=
X-Google-Smtp-Source: ABdhPJw/n544tCUUS+YIPc0VzE0G8nHnbpYtPRDJVha88oDjqT6ckGytDZ36Gpv4rRpqQ/eGpJW0QQ==
X-Received: by 2002:a62:1614:0:b0:4a2:fa59:c1ad with SMTP id 20-20020a621614000000b004a2fa59c1admr4067785pfw.80.1637119771168;
        Tue, 16 Nov 2021 19:29:31 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:bea:143e:3360:c708])
        by smtp.gmail.com with ESMTPSA id mi18sm4042394pjb.13.2021.11.16.19.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 19:29:30 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: annotate accesses to queue->trans_start
Date:   Tue, 16 Nov 2021 19:29:22 -0800
Message-Id: <20211117032924.1740327-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211117032924.1740327-1-eric.dumazet@gmail.com>
References: <20211117032924.1740327-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In following patches, dev_watchdog() will no longer stop all queues.
It will read queue->trans_start locklessly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |  2 +-
 drivers/net/ethernet/atheros/ag71xx.c            |  2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   |  4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c  |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c               |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c        |  4 ++--
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c    |  6 +++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c         |  2 +-
 drivers/net/virtio_net.c                         |  2 +-
 drivers/net/wireless/marvell/mwifiex/init.c      |  2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c        |  2 +-
 include/linux/netdevice.h                        | 16 +++++++++++++---
 net/sched/sch_generic.c                          |  8 ++++----
 14 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 220dc42af31ae1200ca05441000bb2a1abd0fd89..ff2d099aab218b30783266d5f905e3f0846f0951 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -869,7 +869,7 @@ static void xgene_enet_timeout(struct net_device *ndev, unsigned int txqueue)
 
 	for (i = 0; i < pdata->txq_cnt; i++) {
 		txq = netdev_get_tx_queue(ndev, i);
-		txq->trans_start = jiffies;
+		txq_trans_cond_update(txq);
 		netif_tx_start_queue(txq);
 	}
 }
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 88d2ab7483994a850efcea1228d9718e0f6bc2ae..e4f30bb7498fec02742376a37a22495cba38a9ea 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -766,7 +766,7 @@ static bool ag71xx_check_dma_stuck(struct ag71xx *ag)
 	unsigned long timestamp;
 	u32 rx_sm, tx_sm, rx_fd;
 
-	timestamp = netdev_get_tx_queue(ag->ndev, 0)->trans_start;
+	timestamp = READ_ONCE(netdev_get_tx_queue(ag->ndev, 0)->trans_start);
 	if (likely(time_before(jiffies, timestamp + HZ / 10)))
 		return false;
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6b2927d863e2cc7569dadd4cd1e974dcc347274e..d6871437d9515df18c7819817799f9ade8bcb57e 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2325,7 +2325,7 @@ dpaa_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	txq = netdev_get_tx_queue(net_dev, queue_mapping);
 
 	/* LLTX requires to do our own update of trans_start */
-	txq->trans_start = jiffies;
+	txq_trans_cond_update(txq);
 
 	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
 		fd.cmd |= cpu_to_be32(FM_FD_CMD_UPD);
@@ -2531,7 +2531,7 @@ static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
 
 	/* Bump the trans_start */
 	txq = netdev_get_tx_queue(net_dev, smp_processor_id());
-	txq->trans_start = jiffies;
+	txq_trans_cond_update(txq);
 
 	err = dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);
 	if (err) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 13835a37b3a2fd13d557750fb3943172fc2eb700..d5100179f8d589dc4ea517f5bafca0612a5fcc38 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2679,7 +2679,7 @@ static bool hns3_get_tx_timeo_queue_info(struct net_device *ndev)
 		unsigned long trans_start;
 
 		q = netdev_get_tx_queue(ndev, i);
-		trans_start = q->trans_start;
+		trans_start = READ_ONCE(q->trans_start);
 		if (netif_xmit_stopped(q) &&
 		    time_after(jiffies,
 			       (trans_start + ndev->watchdog_timeo))) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3cca51735421a7435f4c7f32fa3f5af9003f2d37..c327fc8860da20e16b6801adc071bfb90dd05c36 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2058,7 +2058,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	tx_packets++;
 	tx_bytes += skb->len;
-	txq->trans_start = jiffies;
+	txq_trans_cond_update(txq);
 	ret = NETDEV_TX_OK;
 	goto out;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 836be0d3b29105d48530e2ce6b3f8db13c730e71..18a019a47182218ff85a83a00e75c99005e22a34 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2927,7 +2927,7 @@ static int igb_xdp_xmit_back(struct igb_adapter *adapter, struct xdp_buff *xdp)
 	nq = txring_txq(tx_ring);
 	__netif_tx_lock(nq, cpu);
 	/* Avoid transmit queue timeout since we share it with the slow path */
-	nq->trans_start = jiffies;
+	txq_trans_cond_update(nq);
 	ret = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
 	__netif_tx_unlock(nq);
 
@@ -2961,7 +2961,7 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 	__netif_tx_lock(nq, cpu);
 
 	/* Avoid transmit queue timeout since we share it with the slow path */
-	nq->trans_start = jiffies;
+	txq_trans_cond_update(nq);
 
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 4f4bc8726ec4fa2b20a32edb25780ad177f6860a..86060513328739ecd6702525a6902bd82c7d2db6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -565,7 +565,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 	snprintf(err_str, sizeof(err_str),
 		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u",
 		 sq->ch_ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
-		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
+		 jiffies_to_usecs(jiffies - READ_ONCE(sq->txq->trans_start)));
 
 	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 	return to_ctx.status;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 033c35c09a54876eeb87e30aad5ec8e8613f13b9..389d125310c151e54b428d19616fd07531051f54 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2356,7 +2356,7 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	bool work_done = true;
 
 	/* Avoids TX time-out as we are sharing with slow path */
-	nq->trans_start = jiffies;
+	txq_trans_cond_update(nq->trans_start);
 
 	budget = min(budget, stmmac_tx_avail(priv, queue));
 
@@ -4657,7 +4657,7 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 
 	__netif_tx_lock(nq, cpu);
 	/* Avoids TX time-out as we are sharing with slow path */
-	nq->trans_start = jiffies;
+	txq_trans_cond_update(nq->trans_start);
 
 	res = stmmac_xdp_xmit_xdpf(priv, queue, xdpf, false);
 	if (res == STMMAC_XDP_TX)
@@ -6293,7 +6293,7 @@ static int stmmac_xdp_xmit(struct net_device *dev, int num_frames,
 
 	__netif_tx_lock(nq, cpu);
 	/* Avoids TX time-out as we are sharing with slow path */
-	nq->trans_start = jiffies;
+	txq_trans_cond_update(nq);
 
 	for (i = 0; i < num_frames; i++) {
 		int res;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index c092cb61416a180a5ce1d0d28bd163e4a1dab302..750cea23e9cd02bba139a58553c4b1753956ad10 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -345,7 +345,7 @@ static void am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,
 
 	netif_txq = netdev_get_tx_queue(ndev, txqueue);
 	tx_chn = &common->tx_chns[txqueue];
-	trans_start = netif_txq->trans_start;
+	trans_start = READ_ONCE(netif_txq->trans_start);
 
 	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u dql_avail:%d free_desc:%zu\n",
 		   txqueue,
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1771d6e5224fd834a4dfca4ba578134439d4d201..03e38e38ee4b5a97567eb692cd84a55722a1a8b2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2694,7 +2694,7 @@ static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
 
 	netdev_err(dev, "TX timeout on queue: %u, sq: %s, vq: 0x%x, name: %s, %u usecs ago\n",
 		   txqueue, sq->name, sq->vq->index, sq->vq->name,
-		   jiffies_to_usecs(jiffies - txq->trans_start));
+		   jiffies_to_usecs(jiffies - READ_ONCE(txq->trans_start)));
 }
 
 static const struct net_device_ops virtnet_netdev = {
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index f006a3d72b4046f435739e9218e3be6bf7001adc..88c72d1827a00d608e90e03beb20202228cd8699 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -332,7 +332,7 @@ void mwifiex_set_trans_start(struct net_device *dev)
 	int i;
 
 	for (i = 0; i < dev->num_tx_queues; i++)
-		netdev_get_tx_queue(dev, i)->trans_start = jiffies;
+		txq_trans_cond_update(netdev_get_tx_queue(dev, i));
 
 	netif_trans_update(dev);
 }
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index d2726d01c7573fe8230e0a7e0f7f811c1ff8cffc..aabbea48223d2f7915285c883e2ae94111bd91b6 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -2515,7 +2515,7 @@ void rtllib_stop_all_queues(struct rtllib_device *ieee)
 	unsigned int i;
 
 	for (i = 0; i < ieee->dev->num_tx_queues; i++)
-		netdev_get_tx_queue(ieee->dev, i)->trans_start = jiffies;
+		txq_trans_cond_update(netdev_get_tx_queue(ieee->dev, i));
 
 	netif_tx_stop_all_queues(ieee->dev);
 }
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 143ac02c7f1cc90cf6704574fb0012e1ba830c70..83e6204c0ba3491b56eec5c7f94e55eab7159223 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4095,10 +4095,21 @@ static inline void __netif_tx_unlock_bh(struct netdev_queue *txq)
 	spin_unlock_bh(&txq->_xmit_lock);
 }
 
+/*
+ * txq->trans_start can be read locklessly from dev_watchdog()
+ */
 static inline void txq_trans_update(struct netdev_queue *txq)
 {
 	if (txq->xmit_lock_owner != -1)
-		txq->trans_start = jiffies;
+		WRITE_ONCE(txq->trans_start, jiffies);
+}
+
+static inline void txq_trans_cond_update(struct netdev_queue *txq)
+{
+	unsigned long now = jiffies;
+
+	if (READ_ONCE(txq->trans_start) != now)
+		WRITE_ONCE(txq->trans_start, now);
 }
 
 /* legacy drivers only, netdev_start_xmit() sets txq->trans_start */
@@ -4106,8 +4117,7 @@ static inline void netif_trans_update(struct net_device *dev)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(dev, 0);
 
-	if (txq->trans_start != jiffies)
-		txq->trans_start = jiffies;
+	txq_trans_cond_update(txq);
 }
 
 /**
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 1b4328bd495d54d44a9d51b53c8e8bc18b9cc294..02c46041f76e85571fd2862e02fb409bfd8e6611 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -434,9 +434,9 @@ unsigned long dev_trans_start(struct net_device *dev)
 		dev = vlan_dev_real_dev(dev);
 	else if (netif_is_macvlan(dev))
 		dev = macvlan_dev_real_dev(dev);
-	res = netdev_get_tx_queue(dev, 0)->trans_start;
+	res = READ_ONCE(netdev_get_tx_queue(dev, 0)->trans_start);
 	for (i = 1; i < dev->num_tx_queues; i++) {
-		val = netdev_get_tx_queue(dev, i)->trans_start;
+		val = READ_ONCE(netdev_get_tx_queue(dev, i)->trans_start);
 		if (val && time_after(val, res))
 			res = val;
 	}
@@ -462,7 +462,7 @@ static void dev_watchdog(struct timer_list *t)
 				struct netdev_queue *txq;
 
 				txq = netdev_get_tx_queue(dev, i);
-				trans_start = txq->trans_start;
+				trans_start = READ_ONCE(txq->trans_start);
 				if (netif_xmit_stopped(txq) &&
 				    time_after(jiffies, (trans_start +
 							 dev->watchdog_timeo))) {
@@ -1148,7 +1148,7 @@ static void transition_one_qdisc(struct net_device *dev,
 
 	rcu_assign_pointer(dev_queue->qdisc, new_qdisc);
 	if (need_watchdog_p) {
-		dev_queue->trans_start = 0;
+		WRITE_ONCE(dev_queue->trans_start, 0);
 		*need_watchdog_p = 1;
 	}
 }
-- 
2.34.0.rc1.387.gb447b232ab-goog

