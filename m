Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E082E93FD
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhADLT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:19:27 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10015 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADLT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:19:27 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8Y581jVQzj2vP;
        Mon,  4 Jan 2021 19:17:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 19:18:34 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Yuqi Jin <jinyuqi@huawei.com>, Dave Hansen <dave.hansen@intel.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        "Michal Hocko" <mhocko@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        "Shaokun Zhang" <zhangshaokun@hisilicon.com>
Subject: [PATCH v8] lib: optimize cpumask_local_spread()
Date:   Mon, 4 Jan 2021 19:18:29 +0800
Message-ID: <1609759109-62925-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yuqi Jin <jinyuqi@huawei.com>

In multi-processor and NUMA system, I/O driver will find cpu cores that
which shall be bound IRQ. When cpu cores in the local numa have been
used up, it is better to find the node closest to the local numa node
for performance, instead of choosing any online cpu immediately.

On arm64 or x86 platform that has 2-sockets and 4-NUMA nodes, if the
network card is located in node2 of socket1, while the number queues
of network card is greater than the number of cores of node2, when all
cores of node2 has been bound to the queues, the remaining queues will
be bound to the cores of node0. That's not friendly to performance.
Let's improve it and find the nearest unused node through NUMA distance
for the non-local NUMA nodes.

On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
system(0 - 1). The topology of this server is followed:
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
node 0 size: 63379 MB
node 0 free: 61899 MB
node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 64509 MB
node 1 free: 63942 MB
node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 2 size: 64509 MB
node 2 free: 63056 MB
node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
node 3 size: 63997 MB
node 3 free: 63420 MB
node distances:
node   0   1   2   3
  0:  10  16  32  33
  1:  16  10  25  32
  2:  32  25  10  16
  3:  33  32  16  10

We perform PS (parameter server) business test, the behavior of the
service is that the client initiates a request through the network card,
the server responds to the request after calculation.  When two PS
processes run on node2 and node3 separately and the network card is
located on 'node2' which is in cpu1, the performance of node2 (26W QPS)
and node3 (22W QPS) is different.

It is better that the NIC queues are bound to the cpu1 cores in turn, then
XPS will also be properly initialized, while cpumask_local_spread only
considers the local node. When the number of NIC queues exceeds the
number of cores in the local node, it returns to the online core directly.
So when PS runs on node3 sending a calculated request, the performance is
not as good as the node2.

The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
patch, before the patch:

Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
0
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
1
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
22
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
23
After the patch:
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
72
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
73
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
94
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
95

So the performance of the node3 is the same as node2 that is 26W QPS when
the network card is still in 'node2' with the patch.

Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
ChangeLog from v7:
    1. Fix confusing comments
    2. Improve the loop for choosing the nearest node.

ChangeLog from v6:
    1. Addressed Dave comments
    2. Fix the warning from Hulk Robot
    3. Simply the git log.

ChangeLog from v5:
    1. Rebase to 5.10-rc2

ChangeLog from v4:
    1. Rebase to 5.6-rc3 

ChangeLog from v3:
    1. Make spread_lock local to cpumask_local_spread();
    2. Add more descriptions on the affinities change in log;

ChangeLog from v2:
    1. Change the variables as static and use spinlock to protect;
    2. Give more explantation on test and performance;

 include/linux/cpumask.h |  2 +-
 lib/cpumask.c           | 73 ++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 383684e30f12..ab0c2a39bfb4 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -189,7 +189,7 @@ static inline unsigned int cpumask_any_but(const struct cpumask *mask,
 	return 1;
 }
 
-static inline unsigned int cpumask_local_spread(unsigned int i, int node)
+static inline unsigned int cpumask_local_spread(unsigned int cpu_index, int node)
 {
 	return 0;
 }
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 35924025097b..1885c314e410 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -193,47 +193,82 @@ void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 }
 #endif
 
+static int find_nearest_node(int node, nodemask_t nodes)
+{
+	int i, min_dist, node_id = -1;
+
+	/* Choose the first unused node to compare */
+	for (i = 0; i < nr_node_ids; i++)
+		if (!node_isset(i, nodes)) {
+			min_dist = node_distance(node, i);
+			node_id = i;
+			break;
+		}
+
+	/* Compare and return the nearest node */
+	for (i = 0; i < nr_node_ids; i++)
+		if (!node_isset(i, nodes) &&
+			node_distance(node, i) < min_dist) {
+			min_dist = node_distance(node, i);
+			node_id = i;
+		}
+
+	return node_id;
+}
+
 /**
  * cpumask_local_spread - select the i'th cpu with local numa cpu's first
- * @i: index number
+ * @cpu_index: index number
  * @node: local numa_node
  *
  * This function selects an online CPU according to a numa aware policy;
- * local cpus are returned first, followed by non-local ones, then it
- * wraps around.
+ * Loop through all the online CPUs on the system. Start with the CPUs on
+ * 'node', then fall back to CPUs on NUMA nodes which are increasingly far
+ * away.
  *
- * It's not very efficient, but useful for setup.
+ * This function is not very efficient, especially for large 'cpu_index'
+ * because it loops over the same CPUs on each call and does not remember
+ * its state from previous calls, but it is useful for setup.
  */
-unsigned int cpumask_local_spread(unsigned int i, int node)
+unsigned int cpumask_local_spread(unsigned int cpu_index, int node)
 {
-	int cpu, hk_flags;
+	int cpu, hk_flags, j, ncpus, id;
 	const struct cpumask *mask;
+	struct cpumask nmsk;
+	nodemask_t nodes_msk;
 
 	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
 	mask = housekeeping_cpumask(hk_flags);
 	/* Wrap: we always want a cpu. */
-	i %= cpumask_weight(mask);
+	cpu_index %= cpumask_weight(mask);
 
 	if (node == NUMA_NO_NODE) {
 		for_each_cpu(cpu, mask) {
-			if (i-- == 0)
+			if (cpu_index-- == 0)
 				return cpu;
 		}
 	} else {
-		/* NUMA first. */
-		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
-			if (i-- == 0)
-				return cpu;
-		}
-
-		for_each_cpu(cpu, mask) {
-			/* Skip NUMA nodes, done above. */
-			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
+		/* select node according to the distance from local node */
+		nodes_clear(nodes_msk);
+		for (j = 0; j < nr_node_ids; j++) {
+			id = find_nearest_node(node, nodes_msk);
+			if (id < 0)
+				break;
+			cpumask_and(&nmsk, mask, cpumask_of_node(id));
+			ncpus = cpumask_weight(&nmsk);
+			if (cpu_index >= ncpus) {
+				cpu_index -= ncpus;
+				node_set(id, nodes_msk);
 				continue;
+			}
+			for_each_cpu(cpu, &nmsk)
+				if (cpu_index-- == 0)
+					return cpu;
+		}
 
-			if (i-- == 0)
+		for_each_cpu(cpu, mask)
+			if (cpu_index-- == 0)
 				return cpu;
-		}
 	}
 	BUG();
 }
-- 
2.7.4

