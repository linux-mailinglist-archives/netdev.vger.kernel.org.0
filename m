Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D272DD526
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgLQQ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgLQQ0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 11:26:16 -0500
From:   Antoine Tenart <atenart@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 4/4] net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc
Date:   Thu, 17 Dec 2020 17:25:21 +0100
Message-Id: <20201217162521.1134496-5-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217162521.1134496-1-atenart@kernel.org>
References: <20201217162521.1134496-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Accesses to dev->xps_rxqs_map (when using dev->num_tc) should be
protected by the rtnl lock, like we do for netif_set_xps_queue. I didn't
see an actual bug being triggered, but let's be safe here and take the
rtnl lock while accessing the map in sysfs.

Fixes: 8af2c06ff4b1 ("net-sysfs: Add interface for Rx queue(s) map per Tx queue")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 62ca2f2c0ee6..daf502c13d6d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1429,22 +1429,29 @@ static struct netdev_queue_attribute xps_cpus_attribute __ro_after_init
 
 static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 {
+	int j, len, ret, num_tc = 1, tc = 0;
 	struct net_device *dev = queue->dev;
 	struct xps_dev_maps *dev_maps;
 	unsigned long *mask, index;
-	int j, len, num_tc = 1, tc = 0;
 
 	index = get_netdev_queue_index(queue);
 
+	if (!rtnl_trylock())
+		return restart_syscall();
+
 	if (dev->num_tc) {
 		num_tc = dev->num_tc;
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
-			return -EINVAL;
+		if (tc < 0) {
+			ret = -EINVAL;
+			goto err_rtnl_unlock;
+		}
 	}
 	mask = bitmap_zalloc(dev->num_rx_queues, GFP_KERNEL);
-	if (!mask)
-		return -ENOMEM;
+	if (!mask) {
+		ret = -ENOMEM;
+		goto err_rtnl_unlock;
+	}
 
 	rcu_read_lock();
 	dev_maps = rcu_dereference(dev->xps_rxqs_map);
@@ -1470,10 +1477,16 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 out_no_maps:
 	rcu_read_unlock();
 
+	rtnl_unlock();
+
 	len = bitmap_print_to_pagebuf(false, buf, mask, dev->num_rx_queues);
 	bitmap_free(mask);
 
 	return len < PAGE_SIZE ? len : -EINVAL;
+
+err_rtnl_unlock:
+	rtnl_unlock();
+	return ret;
 }
 
 static ssize_t xps_rxqs_store(struct netdev_queue *queue, const char *buf,
-- 
2.29.2

