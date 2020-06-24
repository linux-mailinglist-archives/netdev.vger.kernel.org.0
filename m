Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FA5207A1F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405483AbgFXRTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405475AbgFXRTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F39C061795
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ne5so1409257pjb.5
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uWEQN00J+EsTD7vc+2ZqKDA1RdwxuktjAkTxSvFMBrY=;
        b=cwsVEsDd05a8SHzQwLET/o5+fbJx1bp956sls0WQ9hI9wfDNkFYd/LSlHTtou+AgMB
         nFQcuj06TeKnXxCXTFtiKbCHqqoiMJnkhL90xFPQNcSC0NOkLUzzWeSoaavoDrJwP7dD
         JiGSZKX5sghpjnKJ1Y8Hg6WTyBFWr5RbM4TIgcFtVGNflSQlqOlHmMs20V7rWMVNbmQ9
         UAR1RHtdeYpJQVBJ5k0w4NVEppPJeQ/8ZD8S91Df0tC1kG6s2paWYkufe+Y5HkYMXe2F
         pTkcFf4opTAXSI7H2D6Ckjgb+FHSbn5TzGjPSX79QEwP6pCI8QoUxMSy6yUA865mlMRg
         5a7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uWEQN00J+EsTD7vc+2ZqKDA1RdwxuktjAkTxSvFMBrY=;
        b=GvPmuwihmYoVHQ3bukbB+cpgW4xCASez3ILlrdEYxrkDO/hS2tT5g/gLOSxaRBf+mf
         TyI2WXKt3IUD3/XWzvCbMaLaQ8yyifNF82/eDnfraOsm6573BfLB2hp1s5FpG7Au8c3G
         /aiHyKtxrwPV/nF9Z/r/NJi4y/jYQ28v0m2v84z2KZld4DtN3hDyuWjSXvseDLnKgosv
         NnhJb4hMox4D8rhoTLIIN5/PLXCQJmdWPMhmK7DWlSKs99Gmvcdy9tAgPfdFLPk5oNH2
         uxrNgk3oAHrtIIkxQlmMPMCWdQyMy6UCTbWEgt/AUF9mPeLrqxDdbSGn0rrtqBwqnA12
         vyPQ==
X-Gm-Message-State: AOAM530a5tYMABAn7+eYiujWee9pCSaTKAbcPp6hA1Ju49A7vA9rhmtX
        pojTG96fsTdb0KHjQWmRuxQO7VtrHwQ=
X-Google-Smtp-Source: ABdhPJy7ytS2Ni71K6mk+qkz7jf5KuIOMyPQ/xUACDDcqjCjZ36nNbnuzWv8T4t6N9aUvAbPxUEPvw==
X-Received: by 2002:a17:90a:4f4b:: with SMTP id w11mr29868537pjl.11.1593019176774;
        Wed, 24 Jun 2020 10:19:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:36 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 07/11] net: Introduce global queues
Date:   Wed, 24 Jun 2020 10:17:46 -0700
Message-Id: <20200624171749.11927-8-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Global queues, or gqids, are an abstract representation of NIC
device queues. They are global in the sense that the each gqid
can be map to a queue in each device, i.e. if there are multiple
devices in the system, a gqid can map to a different queue, a dqid,
in each device in a one to many mapping.  gqids are used for
configuring packet steering on both send and receive in a generic
way not bound to a particular device.

Each transmit or receive device queue may be reversed mapped to
one gqid. Each device maintains a table mapping gqids to local
device queues, those tables are used in the data path to convert
a gqid receive or transmit queue into a device queue relative to
the sending or receiving device.

Changes in the patch:
	- Add a simple index to netdev_queue and netdev_rx_queue
	  This serves as the dqid (it's just the index in the
	  receive or transmit queue array for the device)
	- Add gqid to netdev_queue and netdev_rx_queue. This is the
	  mapping of a device queue to gqid. If gqid is NO_QUEUE
	  then the gqid is unmapped
	- The per device gqid to dqid maps are maintained in an
	  array of netdev_queue_map structures in a net_devce for
	  both transmit and receive
	- Functions that return a dqid where input is gqid and
	  a net_device
	- Sysfs to set device queue mappings in global_queue_mapping
	  attribyte of the sysfs rx- and tx- queue directory
	- Create per device gqid to dqid maps in the sysfs function
---
 include/linux/netdevice.h |  75 ++++++++++++++
 net/core/dev.c            |  20 +++-
 net/core/net-sysfs.c      | 199 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 290 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 48ba1c1fc644..ca163925211a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -606,6 +606,10 @@ struct netdev_queue {
 #endif
 #if defined(CONFIG_XPS) && defined(CONFIG_NUMA)
 	int			numa_node;
+#endif
+#ifdef CONFIG_RPS
+	u16			index;
+	u16			gqid;
 #endif
 	unsigned long		tx_maxrate;
 	/*
@@ -823,6 +827,8 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
 /* This structure contains an instance of an RX queue. */
 struct netdev_rx_queue {
 #ifdef CONFIG_RPS
+	u16			index;
+	u16			gqid;
 	struct rps_map __rcu		*rps_map;
 	struct rps_dev_flow_table __rcu	*rps_flow_table;
 #endif
@@ -875,6 +881,25 @@ struct xps_dev_maps {
 
 #endif /* CONFIG_XPS */
 
+#ifdef CONFIG_RPS
+/* Structure to map a global queue to a device queue */
+struct netdev_queue_map {
+	struct rcu_head rcu;
+	unsigned int max_ents;
+	unsigned int set_count;
+	u16 map[0];
+};
+
+/* Allocate queue map in blocks to avoid thrashing */
+#define QUEUE_MAP_ALLOC_BLOCK 128
+
+#define QUEUE_MAP_ALLOC_NUMBER(_num)					\
+	((((_num - 1) / QUEUE_MAP_ALLOC_BLOCK) + 1) * QUEUE_MAP_ALLOC_BLOCK)
+
+#define QUEUE_MAP_ALLOC_SIZE(_num) (sizeof(struct netdev_queue_map) +	\
+	(_num) * sizeof(u16))
+#endif /* CONFIG_RPS */
+
 #define TC_MAX_QUEUE	16
 #define TC_BITMASK	15
 /* HW offloaded queuing disciplines txq count and offset maps */
@@ -2092,6 +2117,10 @@ struct net_device {
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
+#ifdef CONFIG_RPS
+	struct netdev_queue_map __rcu *rx_gqueue_map;
+#endif
+
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_ingress;
 #endif
@@ -2122,6 +2151,9 @@ struct net_device {
 	struct xps_dev_maps __rcu *xps_cpus_map;
 	struct xps_dev_maps __rcu *xps_rxqs_map;
 #endif
+#ifdef CONFIG_RPS
+	struct netdev_queue_map __rcu *tx_gqueue_map;
+#endif
 #ifdef CONFIG_NET_CLS_ACT
 	struct mini_Qdisc __rcu	*miniq_egress;
 #endif
@@ -2218,6 +2250,36 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+#ifdef CONFIG_RPS
+static inline u16 netdev_gqid_to_dqid(const struct netdev_queue_map *map,
+				      u16 gqid)
+{
+	return (map && gqid < map->max_ents) ? map->map[gqid] : NO_QUEUE;
+}
+
+static inline u16 netdev_tx_gqid_to_dqid(const struct net_device *dev, u16 gqid)
+{
+	u16 dqid;
+
+	rcu_read_lock();
+	dqid = netdev_gqid_to_dqid(rcu_dereference(dev->tx_gqueue_map), gqid);
+	rcu_read_unlock();
+
+	return dqid;
+}
+
+static inline u16 netdev_rx_gqid_to_dqid(const struct net_device *dev, u16 gqid)
+{
+	u16 dqid;
+
+	rcu_read_lock();
+	dqid = netdev_gqid_to_dqid(rcu_dereference(dev->rx_gqueue_map), gqid);
+	rcu_read_unlock();
+
+	return dqid;
+}
+#endif
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
 	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
@@ -2290,6 +2352,19 @@ static inline void netdev_for_each_tx_queue(struct net_device *dev,
 		f(dev, &dev->_tx[i], arg);
 }
 
+static inline void netdev_for_each_tx_queue_index(struct net_device *dev,
+						  void (*f)(struct net_device *,
+							    struct netdev_queue *,
+							    unsigned int index,
+							    void *),
+						  void *arg)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++)
+		f(dev, &dev->_tx[i], i, arg);
+}
+
 #define netdev_lockdep_set_classes(dev)				\
 {								\
 	static struct lock_class_key qdisc_tx_busylock_key;	\
diff --git a/net/core/dev.c b/net/core/dev.c
index 946940bdd583..f64bf6608775 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9331,6 +9331,10 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 
 	for (i = 0; i < count; i++) {
 		rx[i].dev = dev;
+#ifdef CONFIG_RPS
+		rx[i].index = i;
+		rx[i].gqid = NO_QUEUE;
+#endif
 
 		/* XDP RX-queue setup */
 		err = xdp_rxq_info_reg(&rx[i].xdp_rxq, dev, i);
@@ -9363,7 +9367,8 @@ static void netif_free_rx_queues(struct net_device *dev)
 }
 
 static void netdev_init_one_queue(struct net_device *dev,
-				  struct netdev_queue *queue, void *_unused)
+				  struct netdev_queue *queue,
+				  unsigned int index, void *_unused)
 {
 	/* Initialize queue lock */
 	spin_lock_init(&queue->_xmit_lock);
@@ -9371,6 +9376,10 @@ static void netdev_init_one_queue(struct net_device *dev,
 	queue->xmit_lock_owner = -1;
 	netdev_queue_numa_node_write(queue, NUMA_NO_NODE);
 	queue->dev = dev;
+#ifdef CONFIG_RPS
+	queue->index = index;
+	queue->gqid = NO_QUEUE;
+#endif
 #ifdef CONFIG_BQL
 	dql_init(&queue->dql, HZ);
 #endif
@@ -9396,7 +9405,7 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 
 	dev->_tx = tx;
 
-	netdev_for_each_tx_queue(dev, netdev_init_one_queue, NULL);
+	netdev_for_each_tx_queue_index(dev, netdev_init_one_queue, NULL);
 	spin_lock_init(&dev->tx_global_lock);
 
 	return 0;
@@ -9884,7 +9893,7 @@ struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 	queue = kzalloc(sizeof(*queue), GFP_KERNEL);
 	if (!queue)
 		return NULL;
-	netdev_init_one_queue(dev, queue, NULL);
+	netdev_init_one_queue(dev, queue, 0, NULL);
 	RCU_INIT_POINTER(queue->qdisc, &noop_qdisc);
 	queue->qdisc_sleeping = &noop_qdisc;
 	rcu_assign_pointer(dev->ingress_queue, queue);
@@ -10041,6 +10050,11 @@ void free_netdev(struct net_device *dev)
 {
 	struct napi_struct *p, *n;
 
+#ifdef CONFIG_RPS
+	WARN_ON(rcu_dereference_protected(dev->tx_gqueue_map, 1));
+	WARN_ON(rcu_dereference_protected(dev->rx_gqueue_map, 1));
+#endif
+
 	might_sleep();
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 56d27463d466..3a9d3d9ee8e0 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -875,18 +875,166 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 	return len;
 }
 
+static void queue_map_release(struct rcu_head *rcu)
+{
+	struct netdev_queue_map *q_map = container_of(rcu,
+	    struct netdev_queue_map, rcu);
+	vfree(q_map);
+}
+
+static int set_device_queue_mapping(struct netdev_queue_map **pmap,
+				    u16 gqid, u16 dqid, u16 *p_gqid)
+{
+	static DEFINE_MUTEX(global_mapping_table);
+	struct netdev_queue_map *gq_map, *old_gq_map;
+	u16 old_gqid;
+	int ret = 0;
+
+	mutex_lock(&global_mapping_table);
+
+	old_gqid = *p_gqid;
+	if (old_gqid == gqid) {
+		/* Nothing changing */
+		goto out;
+	}
+
+	gq_map = rcu_dereference_protected(*pmap,
+					   lockdep_is_held(&global_mapping_table));
+	old_gq_map = gq_map;
+
+	if (gqid == NO_QUEUE) {
+		/* Remove any old mapping (we know that old_gqid cannot be
+		 * NO_QUEUE from above)
+		 */
+		if (!WARN_ON(!gq_map || old_gqid > gq_map->max_ents ||
+			     gq_map->map[old_gqid] != dqid)) {
+			/* Unset old mapping */
+			gq_map->map[old_gqid] = NO_QUEUE;
+			if (--gq_map->set_count == 0) {
+				/* Done with map so free */
+				rcu_assign_pointer(*pmap, NULL);
+				call_rcu(&gq_map->rcu, queue_map_release);
+			}
+		}
+		*p_gqid = NO_QUEUE;
+
+		goto out;
+	}
+
+	if (!gq_map || gqid >= gq_map->max_ents) {
+		unsigned int max_queues;
+		int i = 0;
+
+		/* Need to create or expand queue map */
+
+		max_queues = QUEUE_MAP_ALLOC_NUMBER(gqid + 1);
+
+		gq_map = vmalloc(QUEUE_MAP_ALLOC_SIZE(max_queues));
+		if (!gq_map) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		gq_map->max_ents = max_queues;
+
+		if (old_gq_map) {
+			/* Copy old map entries */
+
+			memcpy(gq_map->map, old_gq_map->map,
+			       old_gq_map->max_ents * sizeof(gq_map->map[0]));
+			gq_map->set_count = old_gq_map->set_count;
+			i = old_gq_map->max_ents;
+		} else {
+			gq_map->set_count = 0;
+		}
+
+		/* Initialize entries not copied from old map */
+		for (; i < max_queues; i++)
+			gq_map->map[i] = NO_QUEUE;
+	} else if (gq_map->map[gqid] != NO_QUEUE) {
+		/* The global qid is already mapped to another device qid */
+		ret = -EBUSY;
+		goto out;
+	}
+
+	/* Set map entry */
+	gq_map->map[gqid] = dqid;
+	gq_map->set_count++;
+
+	if (old_gqid != NO_QUEUE) {
+		/* We know old_gqid is not equal to gqid */
+		if (!WARN_ON(!old_gq_map ||
+			     old_gqid > old_gq_map->max_ents ||
+			     old_gq_map->map[old_gqid] != dqid)) {
+			/* Unset old mapping in (new) table */
+			gq_map->map[old_gqid] = NO_QUEUE;
+			gq_map->set_count--;
+		}
+	}
+
+	if (gq_map != old_gq_map) {
+		rcu_assign_pointer(*pmap, gq_map);
+		if (old_gq_map)
+			call_rcu(&old_gq_map->rcu, queue_map_release);
+	}
+
+	/* Save for caller */
+	*p_gqid = gqid;
+
+out:
+	mutex_unlock(&global_mapping_table);
+
+	return ret;
+}
+
+static ssize_t show_rx_queue_global_mapping(struct netdev_rx_queue *queue,
+					    char *buf)
+{
+	u16 gqid = queue->gqid;
+
+	if (gqid == NO_QUEUE)
+		return sprintf(buf, "none\n");
+	else
+		return sprintf(buf, "%u\n", gqid);
+}
+
+static ssize_t store_rx_queue_global_mapping(struct netdev_rx_queue *queue,
+					     const char *buf, size_t len)
+{
+	unsigned long gqid;
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = kstrtoul(buf, 0, &gqid);
+	if (ret < 0)
+		return ret;
+
+	if (gqid > RPS_MAX_QID || WARN_ON(queue->index > RPS_MAX_QID))
+		return -EINVAL;
+
+	ret = set_device_queue_mapping(&queue->dev->rx_gqueue_map,
+				       gqid, queue->index, &queue->gqid);
+	return ret ? : len;
+}
+
 static struct rx_queue_attribute rps_cpus_attribute __ro_after_init
 	= __ATTR(rps_cpus, 0644, show_rps_map, store_rps_map);
 
 static struct rx_queue_attribute rps_dev_flow_table_cnt_attribute __ro_after_init
 	= __ATTR(rps_flow_cnt, 0644,
 		 show_rps_dev_flow_table_cnt, store_rps_dev_flow_table_cnt);
+static struct rx_queue_attribute rx_queue_global_mapping_attribute __ro_after_init =
+	__ATTR(global_queue_mapping, 0644,
+	       show_rx_queue_global_mapping, store_rx_queue_global_mapping);
 #endif /* CONFIG_RPS */
 
 static struct attribute *rx_queue_default_attrs[] __ro_after_init = {
 #ifdef CONFIG_RPS
 	&rps_cpus_attribute.attr,
 	&rps_dev_flow_table_cnt_attribute.attr,
+	&rx_queue_global_mapping_attribute.attr,
 #endif
 	NULL
 };
@@ -896,8 +1044,11 @@ static void rx_queue_release(struct kobject *kobj)
 {
 	struct netdev_rx_queue *queue = to_rx_queue(kobj);
 #ifdef CONFIG_RPS
-	struct rps_map *map;
 	struct rps_dev_flow_table *flow_table;
+	struct rps_map *map;
+
+	set_device_queue_mapping(&queue->dev->rx_gqueue_map, NO_QUEUE,
+				 queue->index, &queue->gqid);
 
 	map = rcu_dereference_protected(queue->rps_map, 1);
 	if (map) {
@@ -1152,6 +1303,46 @@ static ssize_t traffic_class_show(struct netdev_queue *queue,
 				 sprintf(buf, "%u\n", tc);
 }
 
+#ifdef CONFIG_RPS
+static ssize_t show_queue_global_queue_mapping(struct netdev_queue *queue,
+					       char *buf)
+{
+	u16 gqid = queue->gqid;
+
+	if (gqid == NO_QUEUE)
+		return sprintf(buf, "none\n");
+	else
+		return sprintf(buf, "%u\n", gqid);
+	return 0;
+}
+
+static ssize_t store_queue_global_queue_mapping(struct netdev_queue *queue,
+						const char *buf, size_t len)
+{
+	unsigned long gqid;
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = kstrtoul(buf, 0, &gqid);
+	if (ret < 0)
+		return ret;
+
+	if (gqid > RPS_MAX_QID || WARN_ON(queue->index > RPS_MAX_QID))
+		return -EINVAL;
+
+	ret = set_device_queue_mapping(&queue->dev->tx_gqueue_map,
+				       gqid, queue->index, &queue->gqid);
+	return ret ? : len;
+}
+
+static struct netdev_queue_attribute global_queue_mapping_attribute __ro_after_init =
+	__ATTR(global_queue_mapping, 0644,
+	       show_queue_global_queue_mapping,
+	       store_queue_global_queue_mapping);
+#endif
+
 #ifdef CONFIG_XPS
 static ssize_t tx_maxrate_show(struct netdev_queue *queue,
 			       char *buf)
@@ -1483,6 +1674,9 @@ static struct netdev_queue_attribute xps_rxqs_attribute __ro_after_init
 static struct attribute *netdev_queue_default_attrs[] __ro_after_init = {
 	&queue_trans_timeout.attr,
 	&queue_traffic_class.attr,
+#ifdef CONFIG_RPS
+	&global_queue_mapping_attribute.attr,
+#endif
 #ifdef CONFIG_XPS
 	&xps_cpus_attribute.attr,
 	&xps_rxqs_attribute.attr,
@@ -1496,6 +1690,9 @@ static void netdev_queue_release(struct kobject *kobj)
 {
 	struct netdev_queue *queue = to_netdev_queue(kobj);
 
+	set_device_queue_mapping(&queue->dev->tx_gqueue_map, NO_QUEUE,
+				 queue->index, &queue->gqid);
+
 	memset(kobj, 0, sizeof(*kobj));
 	dev_put(queue->dev);
 }
-- 
2.25.1

