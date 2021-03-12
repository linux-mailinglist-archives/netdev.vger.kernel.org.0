Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482933390B9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhCLPFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhCLPFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D45464F78;
        Fri, 12 Mar 2021 15:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561520;
        bh=HglvgNnzmFDnsMQHBlOkGPxvrTxsc96RCxg7FlJWmEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJbVmTg/6m3n6dlX1EeIKEe0BZXtEmKGlxSUlSl4/gHI9fFeocC1r4T1fVupGMDqr
         BcrK1femPDUYIIMcs512QJDH6D07wOwTN6N62aQ0ZhNhc2mjS2AfLbkBgtzLhPTzHn
         pvMAdZB+8x4FszP2gn/+2eOQAOOFISiTzLXqLn/+oMQiCjLchCAsRVRHzGttxbJHZ/
         0Lrm/3q9Zg6/vFyAqC3mwCwYndxbhXcZ5/yya1Cu07n6cW0YSXWfmwg/QAJsfEEQbc
         OyadaiFomdmBtXJqMWzzQj1aQ2gI+OjHn5/Xsl+xmJQrftegkurlP8z6Mr6MqNX8VV
         2/ropg6hPmaPw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 12/16] net-sysfs: move the xps cpus/rxqs retrieval in a common function
Date:   Fri, 12 Mar 2021 16:04:40 +0100
Message-Id: <20210312150444.355207-13-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the xps_cpus_show and xps_rxqs_show functions share the same
logic. Having it in two different functions does not help maintenance.
This patch moves their common logic into a new function, xps_queue_show,
to improve this.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 125 +++++++++++++++++--------------------------
 1 file changed, 48 insertions(+), 77 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 094fea082649..562a42fcd437 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1361,44 +1361,27 @@ static const struct attribute_group dql_group = {
 #endif /* CONFIG_BQL */
 
 #ifdef CONFIG_XPS
-static ssize_t xps_cpus_show(struct netdev_queue *queue,
-			     char *buf)
+static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
+			      int tc, char *buf, enum xps_map_type type)
 {
-	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
-	unsigned int index, nr_ids;
-	int j, len, ret, tc = 0;
 	unsigned long *mask;
-
-	if (!netif_is_multiqueue(dev))
-		return -ENOENT;
-
-	index = get_netdev_queue_index(queue);
-
-	if (!rtnl_trylock())
-		return restart_syscall();
-
-	/* If queue belongs to subordinate dev use its map */
-	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
-
-	tc = netdev_txq_to_tc(dev, index);
-	if (tc < 0) {
-		rtnl_unlock();
-		return -EINVAL;
-	}
-
-	/* Make sure the subordinate device can't be freed */
-	get_device(&dev->dev);
-	rtnl_unlock();
+	unsigned int nr_ids;
+	int j, len;
 
 	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_maps[XPS_CPUS]);
-	nr_ids = dev_maps ? dev_maps->nr_ids : nr_cpu_ids;
+	dev_maps = rcu_dereference(dev->xps_maps[type]);
+
+	/* Default to nr_cpu_ids/dev->num_rx_queues and do not just return 0
+	 * when dev_maps hasn't been allocated yet, to be backward compatible.
+	 */
+	nr_ids = dev_maps ? dev_maps->nr_ids :
+		 (type == XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
 
 	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
 	if (!mask) {
-		ret = -ENOMEM;
-		goto err_rcu_unlock;
+		rcu_read_unlock();
+		return -ENOMEM;
 	}
 
 	if (!dev_maps || tc >= dev_maps->num_tc)
@@ -1421,16 +1404,44 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	}
 out_no_maps:
 	rcu_read_unlock();
-	put_device(&dev->dev);
 
 	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
 	bitmap_free(mask);
+
 	return len < PAGE_SIZE ? len : -EINVAL;
+}
+
+static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
+{
+	struct net_device *dev = queue->dev;
+	unsigned int index;
+	int len, tc;
+
+	if (!netif_is_multiqueue(dev))
+		return -ENOENT;
+
+	index = get_netdev_queue_index(queue);
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	/* If queue belongs to subordinate dev use its map */
+	dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
+
+	tc = netdev_txq_to_tc(dev, index);
+	if (tc < 0) {
+		rtnl_unlock();
+		return -EINVAL;
+	}
+
+	/* Make sure the subordinate device can't be freed */
+	get_device(&dev->dev);
+	rtnl_unlock();
+
+	len = xps_queue_show(dev, index, tc, buf, XPS_CPUS);
 
-err_rcu_unlock:
-	rcu_read_unlock();
 	put_device(&dev->dev);
-	return ret;
+	return len;
 }
 
 static ssize_t xps_cpus_store(struct netdev_queue *queue,
@@ -1477,10 +1488,8 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
 	struct net_device *dev = queue->dev;
-	struct xps_dev_maps *dev_maps;
-	unsigned int index, nr_ids;
-	int j, len, ret, tc = 0;
-	unsigned long *mask;
+	unsigned int index;
+	int tc;
 
 	index = get_netdev_queue_index(queue);
 
@@ -1492,45 +1501,7 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	if (tc < 0)
 		return -EINVAL;
 
-	rcu_read_lock();
-	dev_maps = rcu_dereference(dev->xps_maps[XPS_RXQS]);
-	nr_ids = dev_maps ? dev_maps->nr_ids : dev->num_rx_queues;
-
-	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
-	if (!mask) {
-		ret = -ENOMEM;
-		goto err_rcu_unlock;
-	}
-
-	if (!dev_maps || tc >= dev_maps->num_tc)
-		goto out_no_maps;
-
-	for (j = 0; j < nr_ids; j++) {
-		int i, tci = j * dev_maps->num_tc + tc;
-		struct xps_map *map;
-
-		map = rcu_dereference(dev_maps->attr_map[tci]);
-		if (!map)
-			continue;
-
-		for (i = map->len; i--;) {
-			if (map->queues[i] == index) {
-				set_bit(j, mask);
-				break;
-			}
-		}
-	}
-out_no_maps:
-	rcu_read_unlock();
-
-	len = bitmap_print_to_pagebuf(false, buf, mask, nr_ids);
-	bitmap_free(mask);
-
-	return len < PAGE_SIZE ? len : -EINVAL;
-
-err_rcu_unlock:
-	rcu_read_unlock();
-	return ret;
+	return xps_queue_show(dev, index, tc, buf, XPS_RXQS);
 }
 
 static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
-- 
2.29.2

