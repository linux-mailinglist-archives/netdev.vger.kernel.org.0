Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039176C8313
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCXROO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjCXROK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:14:10 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E21330C7;
        Fri, 24 Mar 2023 10:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zpw7UJHpNCsuK12IwmFIZtgc19D462of/HdTtuXJML8=; b=stQ+A4NNFGZ7p6CCzfug6vDQwq
        tQdOTxfKhYshmva9Xa7SkkpxZ14/JRbZM0DcFXTnqiHThGyZH1CLDkW85Qm/oY49R87xmxOluA9qm
        bKon/7oVPFwdlbTxTNs/06FFxcY9CCqgPevBQSaPP358qxzjwV4mY628UAnQeOINKPyc=;
Received: from p200300daa7147b00f53b1e71cf2162bd.dip0.t-ipconnect.de ([2003:da:a714:7b00:f53b:1e71:cf21:62bd] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfkyZ-006RMo-Gf; Fri, 24 Mar 2023 18:13:15 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net/core: add optional threading for backlog processing
Date:   Fri, 24 Mar 2023 18:13:14 +0100
Message-Id: <20230324171314.73537-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dealing with few flows or an imbalance on CPU utilization, static RPS
CPU assignment can be too inflexible. Add support for enabling threaded NAPI
for backlog processing in order to allow the scheduler to better balance
processing. This helps better spread the load across idle CPUs.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
PATCH:
 - add missing process_queue_empty initialization
 - fix kthread leak
 - add documentation
RFC v3:
 - make patch more generic, applies to backlog processing in general
 - fix process queue access on flush
RFC v2:
 - fix rebase error in rps locking
 Documentation/admin-guide/sysctl/net.rst |  9 +++
 Documentation/networking/scaling.rst     | 20 ++++++
 include/linux/netdevice.h                |  2 +
 net/core/dev.c                           | 82 ++++++++++++++++++++++--
 net/core/sysctl_net_core.c               | 27 ++++++++
 5 files changed, 135 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 466c560b0c30..6d037633a52f 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -47,6 +47,15 @@ Table : Subdirectories in /proc/sys/net
 1. /proc/sys/net/core - Network core options
 ============================================
 
+backlog_threaded
+----------------
+
+This offloads processing of backlog (input packets steered by RPS, or
+queued because the kernel is receiving more than it can handle on the
+incoming CPU) to threads (one for each CPU) instead of processing them
+in softirq context. This can improve load balancing by allowing the
+scheduler to better spread the load across idle CPUs.
+
 bpf_jit_enable
 --------------
 
diff --git a/Documentation/networking/scaling.rst b/Documentation/networking/scaling.rst
index 3d435caa3ef2..ded6fc713304 100644
--- a/Documentation/networking/scaling.rst
+++ b/Documentation/networking/scaling.rst
@@ -244,6 +244,26 @@ Setting net.core.netdev_max_backlog to either 1000 or 10000
 performed well in experiments.
 
 
+Threaded Backlog
+~~~~~~~~~~~~~~~~
+
+When dealing with few flows or an imbalance on CPU utilization, static
+RPS CPU assignment can be too inflexible. Making backlog processing
+threaded can improve load balancing by allowing the scheduler to spread
+the load across idle CPUs.
+
+
+Suggested Configuration
+~~~~~~~~~~~~~~~~~~~~~~~
+
+If you have CPUs fully utilized with network processing, you can enable
+threaded backlog processing by setting /proc/sys/net/core/backlog_threaded
+to 1. Afterwards, RPS CPU configuration bits no longer refer to CPU
+numbers, but to backlog threads named napi/backlog-<n>.
+If necessary, you can change the CPU affinity of these threads to limit
+them to specific CPU cores.
+
+
 RFS: Receive Flow Steering
 ==========================
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 674ee5daa7b1..1f67a8c1349e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -524,6 +524,7 @@ static inline bool napi_complete(struct napi_struct *n)
 }
 
 int dev_set_threaded(struct net_device *dev, bool threaded);
+int backlog_set_threaded(bool threaded);
 
 /**
  *	napi_disable - prevent NAPI from scheduling
@@ -3214,6 +3215,7 @@ struct softnet_data {
 	unsigned int		cpu;
 	unsigned int		input_queue_tail;
 #endif
+	unsigned int		process_queue_empty;
 	unsigned int		received_rps;
 	unsigned int		dropped;
 	struct sk_buff_head	input_pkt_queue;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7172334a418f..b029a374b5f2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4591,7 +4591,7 @@ static int napi_schedule_rps(struct softnet_data *sd)
 	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
 #ifdef CONFIG_RPS
-	if (sd != mysd) {
+	if (sd != mysd && !test_bit(NAPI_STATE_THREADED, &sd->backlog.state)) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
@@ -5772,6 +5772,8 @@ static DEFINE_PER_CPU(struct work_struct, flush_works);
 /* Network device is going away, flush any packets still pending */
 static void flush_backlog(struct work_struct *work)
 {
+	unsigned int process_queue_empty;
+	bool threaded, flush_processq;
 	struct sk_buff *skb, *tmp;
 	struct softnet_data *sd;
 
@@ -5786,8 +5788,17 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
+
+	threaded = test_bit(NAPI_STATE_THREADED, &sd->backlog.state);
+	flush_processq = threaded &&
+			 !skb_queue_empty_lockless(&sd->process_queue);
+	if (flush_processq)
+		process_queue_empty = sd->process_queue_empty;
 	rps_unlock_irq_enable(sd);
 
+	if (threaded)
+		goto out;
+
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
 		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->process_queue);
@@ -5795,7 +5806,16 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
+
+out:
 	local_bh_enable();
+
+	while (flush_processq) {
+		msleep(1);
+		rps_lock_irq_disable(sd);
+		flush_processq = process_queue_empty == sd->process_queue_empty;
+		rps_unlock_irq_enable(sd);
+	}
 }
 
 static bool flush_required(int cpu)
@@ -5927,16 +5947,16 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		}
 
 		rps_lock_irq_disable(sd);
+		sd->process_queue_empty++;
 		if (skb_queue_empty(&sd->input_pkt_queue)) {
 			/*
 			 * Inline a custom version of __napi_complete().
-			 * only current cpu owns and manipulates this napi,
-			 * and NAPI_STATE_SCHED is the only possible flag set
-			 * on backlog.
+			 * only current cpu owns and manipulates this napi.
 			 * We can use a plain write instead of clear_bit(),
 			 * and we dont need an smp_mb() memory barrier.
 			 */
-			napi->state = 0;
+			napi->state &= ~(NAPIF_STATE_SCHED |
+					 NAPIF_STATE_SCHED_THREADED);
 			again = false;
 		} else {
 			skb_queue_splice_tail_init(&sd->input_pkt_queue,
@@ -6350,6 +6370,55 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
+int backlog_set_threaded(bool threaded)
+{
+	static bool backlog_threaded;
+	int err = 0;
+	int i;
+
+	if (backlog_threaded == threaded)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		struct softnet_data *sd = &per_cpu(softnet_data, i);
+		struct napi_struct *n = &sd->backlog;
+
+		if (n->thread)
+			continue;
+		n->thread = kthread_run(napi_threaded_poll, n, "napi/backlog-%d", i);
+		if (IS_ERR(n->thread)) {
+			err = PTR_ERR(n->thread);
+			pr_err("kthread_run failed with err %d\n", err);
+			n->thread = NULL;
+			threaded = false;
+			break;
+		}
+
+	}
+
+	backlog_threaded = threaded;
+
+	/* Make sure kthread is created before THREADED bit
+	 * is set.
+	 */
+	smp_mb__before_atomic();
+
+	for_each_possible_cpu(i) {
+		struct softnet_data *sd = &per_cpu(softnet_data, i);
+		struct napi_struct *n = &sd->backlog;
+		unsigned long flags;
+
+		rps_lock_irqsave(sd, &flags);
+		if (threaded)
+			n->state |= NAPIF_STATE_THREADED;
+		else
+			n->state &= ~NAPIF_STATE_THREADED;
+		rps_unlock_irq_restore(sd, &flags);
+	}
+
+	return err;
+}
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -11108,6 +11177,9 @@ static int dev_cpu_dead(unsigned int oldcpu)
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
 
+	if (test_bit(NAPI_STATE_THREADED, &oldsd->backlog.state))
+		return 0;
+
 #ifdef CONFIG_RPS
 	remsd = oldsd->rps_ipi_list;
 	oldsd->rps_ipi_list = NULL;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 74842b453407..77114cd0b021 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -30,6 +30,7 @@ static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
+static int backlog_threaded;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -188,6 +189,23 @@ static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 }
 #endif /* CONFIG_RPS */
 
+static int backlog_threaded_sysctl(struct ctl_table *table, int write,
+			       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	static DEFINE_MUTEX(backlog_threaded_mutex);
+	int ret;
+
+	mutex_lock(&backlog_threaded_mutex);
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (write && !ret)
+		ret = backlog_set_threaded(backlog_threaded);
+
+	mutex_unlock(&backlog_threaded_mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_NET_FLOW_LIMIT
 static DEFINE_MUTEX(flow_limit_update_mutex);
 
@@ -532,6 +550,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= rps_sock_flow_sysctl
 	},
 #endif
+	{
+		.procname	= "backlog_threaded",
+		.data		= &backlog_threaded,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= backlog_threaded_sysctl,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 #ifdef CONFIG_NET_FLOW_LIMIT
 	{
 		.procname	= "flow_limit_cpu_bitmap",
-- 
2.39.0

