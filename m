Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE91575B2F
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 08:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiGOGEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 02:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiGOGEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 02:04:54 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77BB742AE9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 23:04:53 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:45278.143135399
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-36.111.140.9 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id E97782800BB;
        Fri, 15 Jul 2022 14:04:45 +0800 (CST)
X-189-SAVE-TO-SEND: +liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id b34ba5f1174643fba45020472b2e166d for netdev@vger.kernel.org;
        Fri, 15 Jul 2022 14:04:47 CST
X-Transaction-ID: b34ba5f1174643fba45020472b2e166d
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
From:   Yonglong Li <liyonglong@chinatelecom.cn>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alexanderduyck@fb.com,
        liyonglong@chinatelecom.cn
Subject: [PATCH v3] net: sort queues in xps maps
Date:   Fri, 15 Jul 2022 14:04:37 +0800
Message-Id: <1657865077-38272-1-git-send-email-liyonglong@chinatelecom.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the following case that set xps of each tx-queue with same cpu mask,
packets in the same tcp stream may be hash to different tx queue. Because
the order of queues in each xps map is not the same.

first set each tx-queue with different cpu mask
$ echo 0 > /sys/class/net/eth0/queues/tx-0/xps_cpus
$ echo 1 > /sys/class/net/eth0/queues/tx-1/xps_cpus
$ echo 2 > /sys/class/net/eth0/queues/tx-2/xps_cpus
$ echo 4 > /sys/class/net/eth0/queues/tx-3/xps_cpus
and then set each tx-queue with same cpu mask
$ echo f > /sys/class/net/eth0/queues/tx-0/xps_cpus
$ echo f > /sys/class/net/eth0/queues/tx-1/xps_cpus
$ echo f > /sys/class/net/eth0/queues/tx-2/xps_cpus
$ echo f > /sys/class/net/eth0/queues/tx-3/xps_cpus

at this point the order of each map queues is differnet, It will cause
packets in the same stream be hashed to diffetent tx queue:
attr_map[0].queues = [0,1,2,3]
attr_map[1].queues = [1,0,2,3]
attr_map[2].queues = [2,0,1,3]
attr_map[3].queues = [3,0,1,2]

It is more reasonable that pacekts in the same stream be hashed to the same
tx queue when all tx queue bind with the same CPUs.

v1 -> v2:
Jakub suggestion: factor out the second loop in __netif_set_xps_queue() -
starting from the "add tx-queue to CPU/rx-queue maps" comment into a helper
v2 -> v3:
keep the skip_tc in __netif_set_xps_queue()

Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
---
 net/core/dev.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 978ed06..f011513 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -150,6 +150,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/prandom.h>
 #include <linux/once_lite.h>
+#include <linux/sort.h>
 
 #include "dev.h"
 #include "net-sysfs.h"
@@ -199,6 +200,11 @@ static int call_netdevice_notifiers_extack(unsigned long val,
 
 static DECLARE_RWSEM(devnet_rename_sem);
 
+static int cmp_u16(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
 static inline void dev_base_seq_inc(struct net *net)
 {
 	while (++net->dev_base_seq == 0)
@@ -2537,6 +2543,28 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
 	}
 }
 
+static void update_xps_map(struct xps_map *map, int cpu, u16 index,
+			   int *numa_node_id, enum xps_map_type type)
+{
+	int pos = 0;
+
+	while ((pos < map->len) && (map->queues[pos] != index))
+		pos++;
+
+	if (pos == map->len)
+		map->queues[map->len++] = index;
+
+	sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
+#ifdef CONFIG_NUMA
+	if (type == XPS_CPUS) {
+		if (*numa_node_id == -2)
+			*numa_node_id = cpu_to_node(cpu);
+		else if (*numa_node_id != cpu_to_node(cpu))
+			*numa_node_id = -1;
+	}
+#endif
+}
+
 /* Must be called under cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, enum xps_map_type type)
@@ -2629,24 +2657,9 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		if (netif_attr_test_mask(j, mask, nr_ids) &&
 		    netif_attr_test_online(j, online_mask, nr_ids)) {
 			/* add tx-queue to CPU/rx-queue maps */
-			int pos = 0;
-
 			skip_tc = true;
-
 			map = xmap_dereference(new_dev_maps->attr_map[tci]);
-			while ((pos < map->len) && (map->queues[pos] != index))
-				pos++;
-
-			if (pos == map->len)
-				map->queues[map->len++] = index;
-#ifdef CONFIG_NUMA
-			if (type == XPS_CPUS) {
-				if (numa_node_id == -2)
-					numa_node_id = cpu_to_node(j);
-				else if (numa_node_id != cpu_to_node(j))
-					numa_node_id = -1;
-			}
-#endif
+			update_xps_map(map, j, index, &numa_node_id, type);
 		}
 
 		if (copy)
-- 
1.8.3.1

