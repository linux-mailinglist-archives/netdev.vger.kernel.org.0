Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A566769A8D7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 11:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjBQKGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 05:06:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBQKGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 05:06:19 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8918E5D3F6;
        Fri, 17 Feb 2023 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PRVqmMNDCPYhAWM5WjRjrsTD6UQjhx1vN2jn0yOppqY=; b=Z+u8/bWriVKgxcw8R8H4Ns1xlp
        GYKbfhOuura8hxOOfarzWIOrsuleJiia2JbLFDMOee8Sth70H8FFIjgsyOsm8fL/G7seh1AqNgJtF
        1VFAHz0wVbfS5teX/veBmTND5oCegBmE7pDnmApG8vfm8hoq73TFof1whyoEgCaUUe70=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pSxd2-0099z5-So; Fri, 17 Feb 2023 11:06:08 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [RFC v2] net/core: add optional threading for rps backlog processing
Date:   Fri, 17 Feb 2023 11:06:05 +0100
Message-Id: <20230217100606.1234-1-nbd@nbd.name>
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

RFC v2:
 - fix rebase error in rps locking

 include/linux/netdevice.h  |  1 +
 net/core/dev.c             | 61 ++++++++++++++++++++++++++++++++++----
 net/core/sysctl_net_core.c | 27 +++++++++++++++++
 3 files changed, 84 insertions(+), 5 deletions(-)

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
index 357081b0113c..c138e40536e4 100644
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
@@ -6356,6 +6355,55 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
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
+		unsigned long flags;
+
+		rps_lock_irqsave(sd, &flags);
+		if (threaded)
+			n->state |= NAPIF_STATE_THREADED;
+		else
+			n->state &= ~NAPIF_STATE_THREADED;
+		rps_lock_irq_restore(sd, &flags);
+	}
+
+	return err;
+}
+#endif
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {
@@ -11114,6 +11162,9 @@ static int dev_cpu_dead(unsigned int oldcpu)
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

