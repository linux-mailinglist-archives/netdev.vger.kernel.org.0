Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDFE207A1C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405463AbgFXRTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405391AbgFXRTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE8FC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f2so1299217plr.8
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioFTKN5RCu0a7L5Oh0HoLLLpAlODISnRUTDIV10EYKA=;
        b=sPl29O/mx8F2uru+TrWX4LXSKhPye0yGhnAtyug/AWAjyMQ1adSirI0F3rUxBiRR4q
         SaBuVzauWxsQb2E4PN8v+WwpShaXwmE2H6wmR/vLiFpdtWsUuxPQc6ul2PHEY9S9OxJ6
         15hSnidYFjpOVMlffl5gbJBqNjSBmFqw+vaURBXJZRXhLdzqYNvvvR6jA4jtmFw+Ldf6
         Jztt/BytR6iSZLsjhfrciRTbnO128ecpgA6gPRaYpXPMBmx2SVynFUqQ/ZarNunygaWj
         lxX87F4AHXqjg0+6jzPdydam85lKiaU7fKBQJsCMuAhnXc33DfTEvN+aX/kB36Jnft0Y
         OdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioFTKN5RCu0a7L5Oh0HoLLLpAlODISnRUTDIV10EYKA=;
        b=jKYk4qeRpua6YrsojBKwXYkjuOYEi5Ck+TkTL6vYjTHGsirq6Xl12j+GfsbLsFUBdT
         bLa/grEwmTlXgO36wwwOn31BklOf7uttNyvnRjRbmUhPeRrbrKWEOkkZOf7wHOlmYZza
         t7Xi4jdx2X62KUaWBxoTH6UK6CU9sUI1MBjGpaBoE6c/7LwRPu4FmIRlJKujfZS/N8ZM
         +FVRAk0urIgRhFgLa0s65Kh/G2kZHdTMG97xlFSRaEOyAy7fIc72Dq8VcAqqC8riEO8q
         GmZawEl5A/eLOnGAm4yuTtRHnGBtXqOPrz3ZcKSQKpI43jqPv34gyTiC+Ho9N+zQV8Ze
         e92Q==
X-Gm-Message-State: AOAM531pePoNLjKandnyiMU9KKVxCbHMa3yHazl6Ua4a+27uKfDbxKtc
        TWW3SmSIpQPKnAG/cy9SvOi/KGqOzYM=
X-Google-Smtp-Source: ABdhPJxK2iyD66bnB4O7ENYc0JXMaGhK8R1kOrrOMADFEwYYmGMzvheXxkTsDozG+Ebp66MI19LCTg==
X-Received: by 2002:a17:902:c082:: with SMTP id j2mr29319573pld.175.1593019169376;
        Wed, 24 Jun 2020 10:19:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:28 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 05/11] net: Infrastructure for per queue aRFS
Date:   Wed, 24 Jun 2020 10:17:44 -0700
Message-Id: <20200624171749.11927-6-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Infrastructure changes to allow aRFS to be based on Per Thread Queues
instead of just CPU. The basic change is to create a field in
rps_dev_flow to hold either a CPU or a queue index (not just a CPU
that is).

Changes include:
	- Replace u16 cpu field in rps_dev_flow structure with
	  rps_cpu_qid structure that contains either a CPU or a device
	  queue index. Note the structure is still sixteen bits
	- Helper functions to clear and set the cpu in the
	  rps_cpu_qid of rps_dev_flow
	- Create a sock_masks structure that contains the partition
	  of the thirty-two bit entry in rps_sock_flow_table. The
	  structure contains two masks, one to extract the upper bits
	  of the hash and one to extract the CPU number or queue index
	- Replace rps_cpu_mask with sock_masks from rps_sock_flow_table
	- Add rps_max_num_queues which will be used when creating
	  sock_masks for queue entries in rps_sock_flow_table
---
 include/linux/netdevice.h  | 94 +++++++++++++++++++++++++++++++++-----
 net/core/dev.c             | 47 ++++++++++++-------
 net/core/net-sysfs.c       |  2 +-
 net/core/sysctl_net_core.c |  6 ++-
 4 files changed, 119 insertions(+), 30 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index bf5f2a85da97..d528aa61fea3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -674,18 +674,65 @@ struct rps_map {
 };
 #define RPS_MAP_SIZE(_num) (sizeof(struct rps_map) + ((_num) * sizeof(u16)))
 
+/* The rps_cpu_qid structure is sixteen bits and holds either a CPU number or
+ * a queue index. The use_qid field specifies which type of value is set (i.e.
+ * if use_qid is 1 then cpu_qid contains a fifteen bit queue identifier, and if
+ * use_qid is 0 then cpu_qid contains a fifteen bit CPU number). No entry is
+ * signified by RPS_NO_CPU_QID in val which is set to NO_QUEUE (0xffff). So the
+ * range of CPU numbers that can be stored is 0..32,767 (0x7fff) and the range
+ * of queue identifiers is 0..32,766. Note that CPU numbers are limited by
+ * CONFIG_NR_CPUS which currently has a maximum supported value of 8,192 (per
+ * arch/x86/Kconfig), so WARN_ON is used to check that a CPU number is less
+ * than 0x8000 when setting the cpu in rps_cpu_qid. The queue index is limited
+ * by configuration.
+ */
+struct rps_cpu_qid {
+	union {
+		u16 val;
+		struct {
+			u16 use_qid: 1;
+			union {
+				u16 cpu: 15;
+				u16 qid: 15;
+			};
+		};
+	};
+};
+
+#define RPS_NO_CPU_QID	NO_QUEUE	/* No CPU or qid in rps_cpu_qid */
+#define RPS_MAX_CPU	0x7fff		/* Maximum cpu in rps_cpu_qid */
+#define RPS_MAX_QID	0x7ffe		/* Maximum qid in rps_cpu_qid */
+
 /*
  * The rps_dev_flow structure contains the mapping of a flow to a CPU, the
  * tail pointer for that CPU's input queue at the time of last enqueue, and
  * a hardware filter index.
  */
 struct rps_dev_flow {
-	u16 cpu;
+	struct rps_cpu_qid cpu_qid;
 	u16 filter;
 	unsigned int last_qtail;
 };
 #define RPS_NO_FILTER 0xffff
 
+static inline void rps_dev_flow_clear(struct rps_dev_flow *dev_flow)
+{
+	dev_flow->cpu_qid.val = RPS_NO_CPU_QID;
+}
+
+static inline void rps_dev_flow_set_cpu(struct rps_dev_flow *dev_flow, u16 cpu)
+{
+	struct rps_cpu_qid cpu_qid;
+
+	if (WARN_ON(cpu > RPS_MAX_CPU))
+		return;
+
+	/* Set the rflow target to the CPU atomically */
+	cpu_qid.use_qid = 0;
+	cpu_qid.cpu = cpu;
+	dev_flow->cpu_qid = cpu_qid;
+}
+
 /*
  * The rps_dev_flow_table structure contains a table of flow mappings.
  */
@@ -697,34 +744,57 @@ struct rps_dev_flow_table {
 #define RPS_DEV_FLOW_TABLE_SIZE(_num) (sizeof(struct rps_dev_flow_table) + \
     ((_num) * sizeof(struct rps_dev_flow)))
 
+struct rps_sock_masks {
+	u32 mask;
+	u32 hash_mask;
+};
+
 /*
- * The rps_sock_flow_table contains mappings of flows to the last CPU
- * on which they were processed by the application (set in recvmsg).
- * Each entry is a 32bit value. Upper part is the high-order bits
- * of flow hash, lower part is CPU number.
- * rps_cpu_mask is used to partition the space, depending on number of
- * possible CPUs : rps_cpu_mask = roundup_pow_of_two(nr_cpu_ids) - 1
- * For example, if 64 CPUs are possible, rps_cpu_mask = 0x3f,
- * meaning we use 32-6=26 bits for the hash.
+ * The rps_sock_flow_table contains mappings of flows to the last CPU on which
+ * they were processed by the application (set in recvmsg), or the mapping of
+ * the flow to a per thread queue for the application. Each entry is a 32bit
+ * value. The high order bit indicates whether a CPU number or a queue index is
+ * stored. The next high-order bits contain the flow hash, and the lower bits
+ * contain the CPU number or queue index. The sock_flow table contains two
+ * sets of masks, one for CPU entries (cpu_masks) and one for queue entries
+ * (queue_masks), that are to used partition the space between the hash bits
+ * and the CPU number or queue index. For the cpu masks, cpu_masks.mask is set
+ * to roundup_pow_of_two(nr_cpu_ids) - 1 and the corresponding hash mask,
+ * cpu_masks.hash_mask, is set to (~cpu_masks.mask & ~RPS_SOCK_FLOW_USE_QID).
+ * For example, if 64 CPUs are possible, cpu_masks.mask == 0x3f, meaning we use
+ * 31-6=25 bits for the hash (so cpu_masks.hash_mask == 0x7fffffc0). Similarly,
+ * queue_masks in rps_sock_flow_table is used to partition the space when a
+ * queue index is present.
  */
 struct rps_sock_flow_table {
 	u32	mask;
+	struct	rps_sock_masks cpu_masks;
+	struct	rps_sock_masks queue_masks;
 
 	u32	ents[] ____cacheline_aligned_in_smp;
 };
 #define	RPS_SOCK_FLOW_TABLE_SIZE(_num) (offsetof(struct rps_sock_flow_table, ents[_num]))
 
-#define RPS_NO_CPU 0xffff
+#define RPS_SOCK_FLOW_USE_QID	(1 << 31)
+#define RPS_SOCK_FLOW_NO_IDENT	-1U
 
-extern u32 rps_cpu_mask;
 extern struct rps_sock_flow_table __rcu *rps_sock_flow_table;
+extern unsigned int rps_max_num_queues;
+
+static inline void rps_init_sock_masks(struct rps_sock_masks *masks, u32 num)
+{
+	u32 mask = roundup_pow_of_two(num) - 1;
+
+	masks->mask = mask;
+	masks->hash_mask = (~mask & ~RPS_SOCK_FLOW_USE_QID);
+}
 
 static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
 					u32 hash)
 {
 	if (table && hash) {
+		u32 val = hash & table->cpu_masks.hash_mask;
 		unsigned int index = hash & table->mask;
-		u32 val = hash & ~rps_cpu_mask;
 
 		/* We only give a hint, preemption can change CPU under us */
 		val |= raw_smp_processor_id();
diff --git a/net/core/dev.c b/net/core/dev.c
index 9f7a3e78e23a..946940bdd583 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4242,8 +4242,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 /* One global table that all flow-based protocols share. */
 struct rps_sock_flow_table __rcu *rps_sock_flow_table __read_mostly;
 EXPORT_SYMBOL(rps_sock_flow_table);
-u32 rps_cpu_mask __read_mostly;
-EXPORT_SYMBOL(rps_cpu_mask);
+unsigned int rps_max_num_queues;
 
 struct static_key_false rps_needed __read_mostly;
 EXPORT_SYMBOL(rps_needed);
@@ -4302,7 +4301,7 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 			per_cpu(softnet_data, next_cpu).input_queue_head;
 	}
 
-	rflow->cpu = next_cpu;
+	rps_dev_flow_set_cpu(rflow, next_cpu);
 	return rflow;
 }
 
@@ -4349,22 +4348,39 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 	sock_flow_table = rcu_dereference(rps_sock_flow_table);
 	if (flow_table && sock_flow_table) {
+		u32 next_cpu, comparator, ident;
 		struct rps_dev_flow *rflow;
-		u32 next_cpu;
-		u32 ident;
 
 		/* First check into global flow table if there is a match */
 		ident = sock_flow_table->ents[hash & sock_flow_table->mask];
-		if ((ident ^ hash) & ~rps_cpu_mask)
-			goto try_rps;
+		comparator = ((ident & RPS_SOCK_FLOW_USE_QID) ?
+				sock_flow_table->queue_masks.hash_mask :
+				sock_flow_table->cpu_masks.hash_mask);
 
-		next_cpu = ident & rps_cpu_mask;
+		if ((ident ^ hash) & comparator)
+			goto try_rps;
 
 		/* OK, now we know there is a match,
 		 * we can look at the local (per receive queue) flow table
 		 */
 		rflow = &flow_table->flows[hash & flow_table->mask];
-		tcpu = rflow->cpu;
+
+		/* The flow_sock entry may refer to either a queue or a
+		 * CPU. Proceed accordingly.
+		 */
+		if (ident & RPS_SOCK_FLOW_USE_QID) {
+			/* A queue identifier is in the sock_flow_table entry */
+
+			/* Don't use aRFS to set CPU in this case, skip to
+			 * trying RPS
+			 */
+			goto try_rps;
+		}
+
+		/* A CPU number is in the sock_flow_table entry */
+
+		next_cpu = ident & sock_flow_table->cpu_masks.mask;
+		tcpu = rflow->cpu_qid.use_qid ? NO_QUEUE : rflow->cpu_qid.cpu;
 
 		/*
 		 * If the desired CPU (where last recvmsg was done) is
@@ -4396,10 +4412,8 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 	if (map) {
 		tcpu = map->cpus[reciprocal_scale(hash, map->len)];
-		if (cpu_online(tcpu)) {
+		if (cpu_online(tcpu))
 			cpu = tcpu;
-			goto done;
-		}
 	}
 
 done:
@@ -4424,17 +4438,18 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index,
 {
 	struct netdev_rx_queue *rxqueue = dev->_rx + rxq_index;
 	struct rps_dev_flow_table *flow_table;
+	struct rps_cpu_qid cpu_qid;
 	struct rps_dev_flow *rflow;
 	bool expire = true;
-	unsigned int cpu;
 
 	rcu_read_lock();
 	flow_table = rcu_dereference(rxqueue->rps_flow_table);
 	if (flow_table && flow_id <= flow_table->mask) {
 		rflow = &flow_table->flows[flow_id];
-		cpu = READ_ONCE(rflow->cpu);
-		if (rflow->filter == filter_id && cpu < nr_cpu_ids &&
-		    ((int)(per_cpu(softnet_data, cpu).input_queue_head -
+		cpu_qid = READ_ONCE(rflow->cpu_qid);
+		if (rflow->filter == filter_id && !cpu_qid.use_qid &&
+		    cpu_qid.cpu < nr_cpu_ids &&
+		    ((int)(per_cpu(softnet_data, cpu_qid.cpu).input_queue_head -
 			   rflow->last_qtail) <
 		     (int)(10 * flow_table->mask)))
 			expire = false;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index e353b822bb15..56d27463d466 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -858,7 +858,7 @@ static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 
 		table->mask = mask;
 		for (count = 0; count <= mask; count++)
-			table->flows[count].cpu = RPS_NO_CPU;
+			rps_dev_flow_clear(&table->flows[count]);
 	} else {
 		table = NULL;
 	}
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 9c7d46fbb75a..d09471f29d89 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -65,12 +65,16 @@ static int rps_create_sock_flow_table(size_t size, size_t orig_size,
 				return -ENOMEM;
 
 			sock_table->mask = size - 1;
+			rps_init_sock_masks(&sock_table->cpu_masks,
+					    nr_cpu_ids);
+			rps_init_sock_masks(&sock_table->queue_masks,
+					    rps_max_num_queues);
 		} else {
 			sock_table = orig_table;
 		}
 
 		for (i = 0; i < size; i++)
-			sock_table->ents[i] = RPS_NO_CPU;
+			sock_table->ents[i] = RPS_NO_CPU_QID;
 	} else {
 		sock_table = NULL;
 	}
-- 
2.25.1

