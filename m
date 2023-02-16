Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400FA699B6D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBPRmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBPRmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:42:00 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328B33B855
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gM8mfERGJclmD/Zn4nsFX6dZUDP7+tXhhi5lZm/Ks6U=; b=qk+lUWyQ1qDcq8WSPNV0RHoG3k
        Tx+LeBOKv7TxLklnvLUYWJ5FlrQqHV3EkgWBm2u7k2zaF7DpWjOv6uKER/jTS8l4F06h8wak3onKr
        sC82BeLYAEf04rpgIP+sBvMaR6Q7EBLbxCmAzx8h+dapY4h0a0NYv2Q7pVS2oT/o8Xp4=;
Received: from p54ae9560.dip0.t-ipconnect.de ([84.174.149.96] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pSiGa-008tyx-NG
        for netdev@vger.kernel.org; Thu, 16 Feb 2023 18:41:56 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [RFC] net/core: add optional threading for rps backlog processing
Date:   Thu, 16 Feb 2023 18:41:54 +0100
Message-Id: <20230216174154.89956-1-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dealing with few flows or an imbalance on CPU utilization, static RPS
CPU assignment can be too inflexible. Add support for enabling threaded NAPI
for RPS backlog processing in order to allow the scheduler to better balance
processing. This helps better spread the load across idle CPUs.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/netdevice.h  |  1 +
 net/core/dev.c             | 60 ++++++++++++++++++++++++++++++++++----
 net/core/sysctl_net_core.c | 27 +++++++++++++++++
 3 files changed, 83 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d9cdbc047b49..9ee2162c907e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -522,6 +522,7 @@ static inline bool napi_complete(struct napi_struct *n)
 }
 
 int dev_set_threaded(struct net_device *dev, bool threaded);
+int rps_set_threaded(bool threaded);
 
 /**
  *	napi_disable - prevent NAPI from scheduling
diff --git a/net/core/dev.c b/net/core/dev.c
index 357081b0113c..5387e15d5e40 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4597,7 +4597,7 @@ static int napi_schedule_rps(struct softnet_data *sd)
 	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
 #ifdef CONFIG_RPS
-	if (sd != mysd) {
+	if (sd != mysd && !test_bit(NAPI_STATE_THREADED, &sd->backlog.state)) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
@@ -5936,13 +5936,12 @@ static int process_backlog(struct napi_struct *napi, int quota)
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
@@ -6356,6 +6355,54 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
+#ifdef CONFIG_RPS
+int rps_set_threaded(bool threaded)
+{
+	static bool rps_threaded;
+	int err = 0;
+	int i;
+
+	if (rps_threaded == threaded)
+		return 0;
+
+	for_each_possible_cpu(i) {
+		struct softnet_data *sd = &per_cpu(softnet_data, i);
+		struct napi_struct *n = &sd->backlog;
+
+		n->thread = kthread_run(napi_threaded_poll, n, "napi/rps-%d", i);
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
+	rps_threaded = threaded;
+
+	/* Make sure kthread is created before THREADED bit
+	 * is set.
+	 */
+	smp_mb__before_atomic();
+
+	for_each_possible_cpu(i) {
+		struct softnet_data *sd = &per_cpu(softnet_data, i);
+		struct napi_struct *n = &sd->backlog;
+
+		rps_lock(sd);
+		if (threaded)
+			n->state |= NAPIF_STATE_THREADED;
+		else
+			n->state &= ~NAPIF_STATE_THREADED;
+		rps_unlock(sd);
+	}
+
+	return err;
+}
+#endif
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -11114,6 +11161,9 @@ static int dev_cpu_dead(unsigned int oldcpu)
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_enable();
 
+	if (test_bit(NAPI_STATE_THREADED, &oldsd->backlog.state))
+		return 0;
+
 #ifdef CONFIG_RPS
 	remsd = oldsd->rps_ipi_list;
 	oldsd->rps_ipi_list = NULL;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7130e6d9e263..438957535e74 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -30,6 +30,7 @@ static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
+static int rps_threaded;
 
 static int net_msg_warn;	/* Unused, but still a sysctl */
 
@@ -163,6 +164,23 @@ static int rps_sock_flow_sysctl(struct ctl_table *table, int write,
 
 	return ret;
 }
+
+static int rps_threaded_sysctl(struct ctl_table *table, int write,
+			       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	static DEFINE_MUTEX(rps_threaded_mutex);
+	int ret;
+
+	mutex_lock(&rps_threaded_mutex);
+
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (write && !ret)
+		ret = rps_set_threaded(rps_threaded);
+
+	mutex_unlock(&rps_threaded_mutex);
+
+	return ret;
+}
 #endif /* CONFIG_RPS */
 
 #ifdef CONFIG_NET_FLOW_LIMIT
@@ -513,6 +531,15 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= rps_default_mask_sysctl
 	},
+	{
+		.procname	= "rps_threaded",
+		.data		= &rps_threaded,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= rps_threaded_sysctl,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
+	},
 #endif
 #ifdef CONFIG_NET_FLOW_LIMIT
 	{
-- 
2.39.0

