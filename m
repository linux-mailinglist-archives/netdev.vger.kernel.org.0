Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B62DD529
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgLQQ0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:26:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgLQQ0L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 11:26:11 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 2/4] net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
Date:   Thu, 17 Dec 2020 17:25:19 +0100
Message-Id: <20201217162521.1134496-3-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217162521.1134496-1-atenart@kernel.org>
References: <20201217162521.1134496-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accesses to dev->xps_cpus_map (when using dev->num_tc) should be
protected by the rtnl lock, like we do for netif_set_xps_queue. I didn't
see an actual bug being triggered, but let's be safe here and take the
rtnl lock while accessing the map in sysfs.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7cc15dec1717..65886bfbf822 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1317,8 +1317,8 @@ static const struct attribute_group dql_group = {
 static ssize_t xps_cpus_show(struct netdev_queue *queue,
 			     char *buf)
 {
+	int cpu, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
-	int cpu, len, num_tc = 1, tc = 0;
 	struct xps_dev_maps *dev_maps;
 	cpumask_var_t mask;
 	unsigned long index;
@@ -1328,22 +1328,31 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 
 	index = get_netdev_queue_index(queue);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-		if (num_tc < 0)
-			return -EINVAL;
+		if (num_tc < 0) {
+			ret = -EINVAL;
+			goto err_rtnl_unlock;
+		}
 
 		/* If queue belongs to subordinate dev use its map */
 		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
+		if (tc < 0) {
+			ret = -EINVAL;
+			goto err_rtnl_unlock;
+		}
 	}
 
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
-		return -ENOMEM;
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		ret = -ENOMEM;
+		goto err_rtnl_unlock;
+	}
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_cpus_map);
@@ -1366,9 +1375,15 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue,
 	}
 	rcu_read_unlock();
 
+	rtnl_unlock();
+
 	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
 	return len < PAGE_SIZE ? len : -EINVAL;
+
+err_rtnl_unlock:
+	rtnl_unlock();
+	return ret;
 }
 
 static ssize_t xps_cpus_store(struct netdev_queue *queue,
-- 
2.29.2

