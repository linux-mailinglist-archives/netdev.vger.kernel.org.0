Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CB46CBAE3
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbjC1JaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjC1J3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:25 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEE56EA5;
        Tue, 28 Mar 2023 02:28:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VesbhfA_1679995732;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VesbhfA_1679995732)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:53 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 04/16] virtio_net: separating cpu-related funs
Date:   Tue, 28 Mar 2023 17:28:35 +0800
Message-Id: <20230328092847.91643-5-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a file virtnet_common.c to save the common funcs.
This patch moves the cpu-related funs into it.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/Makefile         |   2 +-
 drivers/net/virtio/virtnet.c        | 132 ++------------------------
 drivers/net/virtio/virtnet_common.c | 138 ++++++++++++++++++++++++++++
 drivers/net/virtio/virtnet_common.h |  14 +++
 4 files changed, 163 insertions(+), 123 deletions(-)
 create mode 100644 drivers/net/virtio/virtnet_common.c
 create mode 100644 drivers/net/virtio/virtnet_common.h

diff --git a/drivers/net/virtio/Makefile b/drivers/net/virtio/Makefile
index ccd45c0e5064..3bef2b51876c 100644
--- a/drivers/net/virtio/Makefile
+++ b/drivers/net/virtio/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
 
-virtio_net-y := virtnet.o
+virtio_net-y := virtnet.o virtnet_common.o
diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 92ef95c163b6..3fcf70782d97 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -14,7 +14,6 @@
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
-#include <linux/cpu.h>
 #include <linux/filter.h>
 #include <linux/kernel.h>
 #include <net/route.h>
@@ -22,6 +21,7 @@
 #include <net/net_failover.h>
 
 #include "virtnet.h"
+#include "virtnet_common.h"
 
 static int napi_weight = NAPI_POLL_WEIGHT;
 module_param(napi_weight, int, 0444);
@@ -2233,108 +2233,6 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev,
 	return 0;
 }
 
-static void virtnet_clean_affinity(struct virtnet_info *vi)
-{
-	int i;
-
-	if (vi->affinity_hint_set) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtqueue_set_affinity(vi->rq[i].vq, NULL);
-			virtqueue_set_affinity(vi->sq[i].vq, NULL);
-		}
-
-		vi->affinity_hint_set = false;
-	}
-}
-
-static void virtnet_set_affinity(struct virtnet_info *vi)
-{
-	cpumask_var_t mask;
-	int stragglers;
-	int group_size;
-	int i, j, cpu;
-	int num_cpu;
-	int stride;
-
-	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
-		virtnet_clean_affinity(vi);
-		return;
-	}
-
-	num_cpu = num_online_cpus();
-	stride = max_t(int, num_cpu / vi->curr_queue_pairs, 1);
-	stragglers = num_cpu >= vi->curr_queue_pairs ?
-			num_cpu % vi->curr_queue_pairs :
-			0;
-	cpu = cpumask_first(cpu_online_mask);
-
-	for (i = 0; i < vi->curr_queue_pairs; i++) {
-		group_size = stride + (i < stragglers ? 1 : 0);
-
-		for (j = 0; j < group_size; j++) {
-			cpumask_set_cpu(cpu, mask);
-			cpu = cpumask_next_wrap(cpu, cpu_online_mask,
-						nr_cpu_ids, false);
-		}
-		virtqueue_set_affinity(vi->rq[i].vq, mask);
-		virtqueue_set_affinity(vi->sq[i].vq, mask);
-		__netif_set_xps_queue(vi->dev, cpumask_bits(mask), i, XPS_CPUS);
-		cpumask_clear(mask);
-	}
-
-	vi->affinity_hint_set = true;
-	free_cpumask_var(mask);
-}
-
-static int virtnet_cpu_online(unsigned int cpu, struct hlist_node *node)
-{
-	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
-						   node);
-	virtnet_set_affinity(vi);
-	return 0;
-}
-
-static int virtnet_cpu_dead(unsigned int cpu, struct hlist_node *node)
-{
-	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
-						   node_dead);
-	virtnet_set_affinity(vi);
-	return 0;
-}
-
-static int virtnet_cpu_down_prep(unsigned int cpu, struct hlist_node *node)
-{
-	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
-						   node);
-
-	virtnet_clean_affinity(vi);
-	return 0;
-}
-
-static enum cpuhp_state virtionet_online;
-
-static int virtnet_cpu_notif_add(struct virtnet_info *vi)
-{
-	int ret;
-
-	ret = cpuhp_state_add_instance_nocalls(virtionet_online, &vi->node);
-	if (ret)
-		return ret;
-	ret = cpuhp_state_add_instance_nocalls(CPUHP_VIRT_NET_DEAD,
-					       &vi->node_dead);
-	if (!ret)
-		return ret;
-	cpuhp_state_remove_instance_nocalls(virtionet_online, &vi->node);
-	return ret;
-}
-
-static void virtnet_cpu_notif_remove(struct virtnet_info *vi)
-{
-	cpuhp_state_remove_instance_nocalls(virtionet_online, &vi->node);
-	cpuhp_state_remove_instance_nocalls(CPUHP_VIRT_NET_DEAD,
-					    &vi->node_dead);
-}
-
 static void virtnet_get_ringparam(struct net_device *dev,
 				  struct ethtool_ringparam *ring,
 				  struct kernel_ethtool_ringparam *kernel_ring,
@@ -4091,34 +3989,24 @@ static __init int virtio_net_driver_init(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "virtio/net:online",
-				      virtnet_cpu_online,
-				      virtnet_cpu_down_prep);
-	if (ret < 0)
-		goto out;
-	virtionet_online = ret;
-	ret = cpuhp_setup_state_multi(CPUHP_VIRT_NET_DEAD, "virtio/net:dead",
-				      NULL, virtnet_cpu_dead);
+	ret = virtnet_cpuhp_setup();
 	if (ret)
-		goto err_dead;
+		return ret;
+
 	ret = register_virtio_driver(&virtio_net_driver);
-	if (ret)
-		goto err_virtio;
+	if (ret) {
+		virtnet_cpuhp_remove();
+		return ret;
+	}
+
 	return 0;
-err_virtio:
-	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
-err_dead:
-	cpuhp_remove_multi_state(virtionet_online);
-out:
-	return ret;
 }
 module_init(virtio_net_driver_init);
 
 static __exit void virtio_net_driver_exit(void)
 {
 	unregister_virtio_driver(&virtio_net_driver);
-	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
-	cpuhp_remove_multi_state(virtionet_online);
+	virtnet_cpuhp_remove();
 }
 module_exit(virtio_net_driver_exit);
 
diff --git a/drivers/net/virtio/virtnet_common.c b/drivers/net/virtio/virtnet_common.c
new file mode 100644
index 000000000000..bf0bac0b8704
--- /dev/null
+++ b/drivers/net/virtio/virtnet_common.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+//
+#include <linux/cpu.h>
+#include <linux/netdevice.h>
+#include <linux/virtio.h>
+#include <linux/virtio_net.h>
+
+#include "virtnet.h"
+#include "virtnet_common.h"
+
+void virtnet_clean_affinity(struct virtnet_info *vi)
+{
+	int i;
+
+	if (vi->affinity_hint_set) {
+		for (i = 0; i < vi->max_queue_pairs; i++) {
+			virtqueue_set_affinity(vi->rq[i].vq, NULL);
+			virtqueue_set_affinity(vi->sq[i].vq, NULL);
+		}
+
+		vi->affinity_hint_set = false;
+	}
+}
+
+void virtnet_set_affinity(struct virtnet_info *vi)
+{
+	cpumask_var_t mask;
+	int stragglers;
+	int group_size;
+	int i, j, cpu;
+	int num_cpu;
+	int stride;
+
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL)) {
+		virtnet_clean_affinity(vi);
+		return;
+	}
+
+	num_cpu = num_online_cpus();
+	stride = max_t(int, num_cpu / vi->curr_queue_pairs, 1);
+	stragglers = num_cpu >= vi->curr_queue_pairs ?
+			num_cpu % vi->curr_queue_pairs :
+			0;
+	cpu = cpumask_first(cpu_online_mask);
+
+	for (i = 0; i < vi->curr_queue_pairs; i++) {
+		group_size = stride + (i < stragglers ? 1 : 0);
+
+		for (j = 0; j < group_size; j++) {
+			cpumask_set_cpu(cpu, mask);
+			cpu = cpumask_next_wrap(cpu, cpu_online_mask,
+						nr_cpu_ids, false);
+		}
+		virtqueue_set_affinity(vi->rq[i].vq, mask);
+		virtqueue_set_affinity(vi->sq[i].vq, mask);
+		__netif_set_xps_queue(vi->dev, cpumask_bits(mask), i, XPS_CPUS);
+		cpumask_clear(mask);
+	}
+
+	vi->affinity_hint_set = true;
+	free_cpumask_var(mask);
+}
+
+static int virtnet_cpu_online(unsigned int cpu, struct hlist_node *node)
+{
+	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
+						   node);
+	virtnet_set_affinity(vi);
+	return 0;
+}
+
+static int virtnet_cpu_dead(unsigned int cpu, struct hlist_node *node)
+{
+	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
+						   node_dead);
+	virtnet_set_affinity(vi);
+	return 0;
+}
+
+static int virtnet_cpu_down_prep(unsigned int cpu, struct hlist_node *node)
+{
+	struct virtnet_info *vi = hlist_entry_safe(node, struct virtnet_info,
+						   node);
+
+	virtnet_clean_affinity(vi);
+	return 0;
+}
+
+static enum cpuhp_state virtionet_online;
+
+int virtnet_cpu_notif_add(struct virtnet_info *vi)
+{
+	int ret;
+
+	ret = cpuhp_state_add_instance_nocalls(virtionet_online, &vi->node);
+	if (ret)
+		return ret;
+	ret = cpuhp_state_add_instance_nocalls(CPUHP_VIRT_NET_DEAD,
+					       &vi->node_dead);
+	if (!ret)
+		return ret;
+	cpuhp_state_remove_instance_nocalls(virtionet_online, &vi->node);
+	return ret;
+}
+
+void virtnet_cpu_notif_remove(struct virtnet_info *vi)
+{
+	cpuhp_state_remove_instance_nocalls(virtionet_online, &vi->node);
+	cpuhp_state_remove_instance_nocalls(CPUHP_VIRT_NET_DEAD,
+					    &vi->node_dead);
+}
+
+void virtnet_cpuhp_remove(void)
+{
+	cpuhp_remove_multi_state(CPUHP_VIRT_NET_DEAD);
+	cpuhp_remove_multi_state(virtionet_online);
+}
+
+int virtnet_cpuhp_setup(void)
+{
+	int ret;
+
+	ret = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN, "virtio/net:online",
+				      virtnet_cpu_online,
+				      virtnet_cpu_down_prep);
+	if (ret < 0)
+		return ret;
+
+	virtionet_online = ret;
+	ret = cpuhp_setup_state_multi(CPUHP_VIRT_NET_DEAD, "virtio/net:dead",
+				      NULL, virtnet_cpu_dead);
+	if (ret) {
+		cpuhp_remove_multi_state(virtionet_online);
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/virtio/virtnet_common.h b/drivers/net/virtio/virtnet_common.h
new file mode 100644
index 000000000000..0ee955950e5a
--- /dev/null
+++ b/drivers/net/virtio/virtnet_common.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __VIRTNET_COMMON_H__
+#define __VIRTNET_COMMON_H__
+
+void virtnet_clean_affinity(struct virtnet_info *vi);
+void virtnet_set_affinity(struct virtnet_info *vi);
+int virtnet_cpu_notif_add(struct virtnet_info *vi);
+void virtnet_cpu_notif_remove(struct virtnet_info *vi);
+
+void virtnet_cpuhp_remove(void);
+int virtnet_cpuhp_setup(void);
+
+#endif
-- 
2.32.0.3.g01195cf9f

