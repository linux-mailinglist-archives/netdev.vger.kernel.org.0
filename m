Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B15EDBC0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 13:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiI1L24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 07:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI1L2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 07:28:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C48DB56F8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 04:28:53 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4McvKH2WdYz1P6sB;
        Wed, 28 Sep 2022 19:24:35 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 19:28:51 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>
Subject: [net-next 2/2] net-sysfs: Convert to use sysfs_emit() APIs
Date:   Wed, 28 Sep 2022 19:49:44 +0800
Message-ID: <1664365784-31179-2-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1664365784-31179-1-git-send-email-wangyufen@huawei.com>
References: <1664365784-31179-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the value
to be returned to user space.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 net/core/net-sysfs.c | 58 ++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index d61afd2..8409d41 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -59,7 +59,7 @@ static ssize_t netdev_show(const struct device *dev,
 #define NETDEVICE_SHOW(field, format_string)				\
 static ssize_t format_##field(const struct net_device *dev, char *buf)	\
 {									\
-	return sprintf(buf, format_string, dev->field);			\
+	return sysfs_emit(buf, format_string, dev->field);		\
 }									\
 static ssize_t field##_show(struct device *dev,				\
 			    struct device_attribute *attr, char *buf)	\
@@ -118,13 +118,13 @@ static ssize_t iflink_show(struct device *dev, struct device_attribute *attr,
 {
 	struct net_device *ndev = to_net_dev(dev);
 
-	return sprintf(buf, fmt_dec, dev_get_iflink(ndev));
+	return sysfs_emit(buf, fmt_dec, dev_get_iflink(ndev));
 }
 static DEVICE_ATTR_RO(iflink);
 
 static ssize_t format_name_assign_type(const struct net_device *dev, char *buf)
 {
-	return sprintf(buf, fmt_dec, dev->name_assign_type);
+	return sysfs_emit(buf, fmt_dec, dev->name_assign_type);
 }
 
 static ssize_t name_assign_type_show(struct device *dev,
@@ -194,7 +194,7 @@ static ssize_t carrier_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 
 	if (netif_running(netdev))
-		return sprintf(buf, fmt_dec, !!netif_carrier_ok(netdev));
+		return sysfs_emit(buf, fmt_dec, !!netif_carrier_ok(netdev));
 
 	return -EINVAL;
 }
@@ -219,7 +219,7 @@ static ssize_t speed_show(struct device *dev,
 		struct ethtool_link_ksettings cmd;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd))
-			ret = sprintf(buf, fmt_dec, cmd.base.speed);
+			ret = sysfs_emit(buf, fmt_dec, cmd.base.speed);
 	}
 	rtnl_unlock();
 	return ret;
@@ -258,7 +258,7 @@ static ssize_t duplex_show(struct device *dev,
 				duplex = "unknown";
 				break;
 			}
-			ret = sprintf(buf, "%s\n", duplex);
+			ret = sysfs_emit(buf, "%s\n", duplex);
 		}
 	}
 	rtnl_unlock();
@@ -272,7 +272,7 @@ static ssize_t testing_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 
 	if (netif_running(netdev))
-		return sprintf(buf, fmt_dec, !!netif_testing(netdev));
+		return sysfs_emit(buf, fmt_dec, !!netif_testing(netdev));
 
 	return -EINVAL;
 }
@@ -284,7 +284,7 @@ static ssize_t dormant_show(struct device *dev,
 	struct net_device *netdev = to_net_dev(dev);
 
 	if (netif_running(netdev))
-		return sprintf(buf, fmt_dec, !!netif_dormant(netdev));
+		return sysfs_emit(buf, fmt_dec, !!netif_dormant(netdev));
 
 	return -EINVAL;
 }
@@ -315,7 +315,7 @@ static ssize_t operstate_show(struct device *dev,
 	if (operstate >= ARRAY_SIZE(operstates))
 		return -EINVAL; /* should not happen */
 
-	return sprintf(buf, "%s\n", operstates[operstate]);
+	return sysfs_emit(buf, "%s\n", operstates[operstate]);
 }
 static DEVICE_ATTR_RO(operstate);
 
@@ -325,9 +325,9 @@ static ssize_t carrier_changes_show(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 
-	return sprintf(buf, fmt_dec,
-		       atomic_read(&netdev->carrier_up_count) +
-		       atomic_read(&netdev->carrier_down_count));
+	return sysfs_emit(buf, fmt_dec,
+			  atomic_read(&netdev->carrier_up_count) +
+			  atomic_read(&netdev->carrier_down_count));
 }
 static DEVICE_ATTR_RO(carrier_changes);
 
@@ -337,7 +337,7 @@ static ssize_t carrier_up_count_show(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 
-	return sprintf(buf, fmt_dec, atomic_read(&netdev->carrier_up_count));
+	return sysfs_emit(buf, fmt_dec, atomic_read(&netdev->carrier_up_count));
 }
 static DEVICE_ATTR_RO(carrier_up_count);
 
@@ -347,7 +347,7 @@ static ssize_t carrier_down_count_show(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 
-	return sprintf(buf, fmt_dec, atomic_read(&netdev->carrier_down_count));
+	return sysfs_emit(buf, fmt_dec, atomic_read(&netdev->carrier_down_count));
 }
 static DEVICE_ATTR_RO(carrier_down_count);
 
@@ -462,7 +462,7 @@ static ssize_t ifalias_show(struct device *dev,
 
 	ret = dev_get_alias(netdev, tmp, sizeof(tmp));
 	if (ret > 0)
-		ret = sprintf(buf, "%s\n", tmp);
+		ret = sysfs_emit(buf, "%s\n", tmp);
 	return ret;
 }
 static DEVICE_ATTR_RW(ifalias);
@@ -514,7 +514,7 @@ static ssize_t phys_port_id_show(struct device *dev,
 
 		ret = dev_get_phys_port_id(netdev, &ppid);
 		if (!ret)
-			ret = sprintf(buf, "%*phN\n", ppid.id_len, ppid.id);
+			ret = sysfs_emit(buf, "%*phN\n", ppid.id_len, ppid.id);
 	}
 	rtnl_unlock();
 
@@ -543,7 +543,7 @@ static ssize_t phys_port_name_show(struct device *dev,
 
 		ret = dev_get_phys_port_name(netdev, name, sizeof(name));
 		if (!ret)
-			ret = sprintf(buf, "%s\n", name);
+			ret = sysfs_emit(buf, "%s\n", name);
 	}
 	rtnl_unlock();
 
@@ -573,7 +573,7 @@ static ssize_t phys_switch_id_show(struct device *dev,
 
 		ret = dev_get_port_parent_id(netdev, &ppid, false);
 		if (!ret)
-			ret = sprintf(buf, "%*phN\n", ppid.id_len, ppid.id);
+			ret = sysfs_emit(buf, "%*phN\n", ppid.id_len, ppid.id);
 	}
 	rtnl_unlock();
 
@@ -591,7 +591,7 @@ static ssize_t threaded_show(struct device *dev,
 		return restart_syscall();
 
 	if (dev_isalive(netdev))
-		ret = sprintf(buf, fmt_dec, netdev->threaded);
+		ret = sysfs_emit(buf, fmt_dec, netdev->threaded);
 
 	rtnl_unlock();
 	return ret;
@@ -673,7 +673,7 @@ static ssize_t netstat_show(const struct device *d,
 		struct rtnl_link_stats64 temp;
 		const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
 
-		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
+		ret = sysfs_emit(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
 	}
 	read_unlock(&dev_base_lock);
 	return ret;
@@ -824,7 +824,7 @@ static ssize_t show_rps_map(struct netdev_rx_queue *queue, char *buf)
 		for (i = 0; i < map->len; i++)
 			cpumask_set_cpu(map->cpus[i], mask);
 
-	len = snprintf(buf, PAGE_SIZE, "%*pb\n", cpumask_pr_args(mask));
+	len = sysfs_emit(buf, "%*pb\n", cpumask_pr_args(mask));
 	rcu_read_unlock();
 	free_cpumask_var(mask);
 
@@ -910,7 +910,7 @@ static ssize_t show_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 		val = (unsigned long)flow_table->mask + 1;
 	rcu_read_unlock();
 
-	return sprintf(buf, "%lu\n", val);
+	return sysfs_emit(buf, "%lu\n", val);
 }
 
 static void rps_dev_flow_table_release(struct rcu_head *rcu)
@@ -1208,7 +1208,7 @@ static ssize_t tx_timeout_show(struct netdev_queue *queue, char *buf)
 {
 	unsigned long trans_timeout = atomic_long_read(&queue->trans_timeout);
 
-	return sprintf(buf, fmt_ulong, trans_timeout);
+	return sysfs_emit(buf, fmt_ulong, trans_timeout);
 }
 
 static unsigned int get_netdev_queue_index(struct netdev_queue *queue)
@@ -1255,15 +1255,15 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 	 * belongs to the root device it will be reported with just the
 	 * traffic class, so just "0" for TC 0 for example.
 	 */
-	return num_tc < 0 ? sprintf(buf, "%d%d\n", tc, num_tc) :
-			    sprintf(buf, "%d\n", tc);
+	return num_tc < 0 ? sysfs_emit(buf, "%d%d\n", tc, num_tc) :
+			    sysfs_emit(buf, "%d\n", tc);
 }
 
 #ifdef CONFIG_XPS
 static ssize_t tx_maxrate_show(struct netdev_queue *queue,
 			       char *buf)
 {
-	return sprintf(buf, "%lu\n", queue->tx_maxrate);
+	return sysfs_emit(buf, "%lu\n", queue->tx_maxrate);
 }
 
 static ssize_t tx_maxrate_store(struct netdev_queue *queue,
@@ -1317,7 +1317,7 @@ static ssize_t tx_maxrate_store(struct netdev_queue *queue,
  */
 static ssize_t bql_show(char *buf, unsigned int value)
 {
-	return sprintf(buf, "%u\n", value);
+	return sysfs_emit(buf, "%u\n", value);
 }
 
 static ssize_t bql_set(const char *buf, const size_t count,
@@ -1346,7 +1346,7 @@ static ssize_t bql_show_hold_time(struct netdev_queue *queue,
 {
 	struct dql *dql = &queue->dql;
 
-	return sprintf(buf, "%u\n", jiffies_to_msecs(dql->slack_hold_time));
+	return sysfs_emit(buf, "%u\n", jiffies_to_msecs(dql->slack_hold_time));
 }
 
 static ssize_t bql_set_hold_time(struct netdev_queue *queue,
@@ -1374,7 +1374,7 @@ static ssize_t bql_show_inflight(struct netdev_queue *queue,
 {
 	struct dql *dql = &queue->dql;
 
-	return sprintf(buf, "%u\n", dql->num_queued - dql->num_completed);
+	return sysfs_emit(buf, "%u\n", dql->num_queued - dql->num_completed);
 }
 
 static struct netdev_queue_attribute bql_inflight_attribute __ro_after_init =
-- 
1.8.3.1

