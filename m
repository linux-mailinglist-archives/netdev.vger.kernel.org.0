Return-Path: <netdev+bounces-557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 010356F81B0
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C5991C217B9
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A90C2E0;
	Fri,  5 May 2023 11:24:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A6FC2D1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:24:38 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4CB1A12A;
	Fri,  5 May 2023 04:24:35 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QCSwr195CzpW6K;
	Fri,  5 May 2023 19:23:24 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 5 May
 2023 19:24:31 +0800
From: Liu Jian <liujian56@huawei.com>
To: <corbet@lwn.net>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<quic_neeraju@quicinc.com>, <joel@joelfernandes.org>,
	<josh@joshtriplett.org>, <boqun.feng@gmail.com>, <rostedt@goodmis.org>,
	<mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
	<qiang1.zhang@intel.com>, <jstultz@google.com>, <tglx@linutronix.de>,
	<sboyd@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <peterz@infradead.org>,
	<frankwoo@google.com>, <Rhinewuwu@google.com>
CC: <liujian56@huawei.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rcu@vger.kernel.org>,
	<netdev@vger.kernel.org>
Subject: [PATCH 7/9] softirq,net: Use softirq_needs_break()
Date: Fri, 5 May 2023 19:33:13 +0800
Message-ID: <20230505113315.3307723-8-liujian56@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230505113315.3307723-1-liujian56@huawei.com>
References: <20230505113315.3307723-1-liujian56@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Peter Zijlstra <peterz@infradead.org>

SoftIRQs provide their own timeout/break code now, use that.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 Documentation/admin-guide/sysctl/net.rst | 11 +----------
 net/core/dev.c                           |  6 +-----
 net/core/dev.h                           |  1 -
 net/core/sysctl_net_core.c               |  8 --------
 4 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 466c560b0c30..095c60788c61 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -267,16 +267,7 @@ netdev_budget
 
 Maximum number of packets taken from all interfaces in one polling cycle (NAPI
 poll). In one polling cycle interfaces which are registered to polling are
-probed in a round-robin manner. Also, a polling cycle may not exceed
-netdev_budget_usecs microseconds, even if netdev_budget has not been
-exhausted.
-
-netdev_budget_usecs
----------------------
-
-Maximum number of microseconds in one NAPI polling cycle. Polling
-will exit when either netdev_budget_usecs have elapsed during the
-poll cycle or the number of packets processed reaches netdev_budget.
+probed in a round-robin manner.
 
 netdev_max_backlog
 ------------------
diff --git a/net/core/dev.c b/net/core/dev.c
index 735096d42c1d..70b6726beee6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4321,7 +4321,6 @@ int netdev_tstamp_prequeue __read_mostly = 1;
 unsigned int sysctl_skb_defer_max __read_mostly = 64;
 int netdev_budget __read_mostly = 300;
 /* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
-unsigned int __read_mostly netdev_budget_usecs = 2 * USEC_PER_SEC / HZ;
 int weight_p __read_mostly = 64;           /* old backlog weight */
 int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */
@@ -6659,8 +6658,6 @@ static int napi_threaded_poll(void *data)
 static __latent_entropy void net_rx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = this_cpu_ptr(&softnet_data);
-	unsigned long time_limit = jiffies +
-		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
@@ -6699,8 +6696,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		 * Allow this to run for 2 jiffies since which will allow
 		 * an average latency of 1.5/HZ.
 		 */
-		if (unlikely(budget <= 0 ||
-			     time_after_eq(jiffies, time_limit))) {
+		if (unlikely(budget <= 0 || softirq_needs_break(h))) {
 			sd->time_squeeze++;
 			break;
 		}
diff --git a/net/core/dev.h b/net/core/dev.h
index e075e198092c..e64a60c767ab 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -39,7 +39,6 @@ void dev_addr_check(struct net_device *dev);
 
 /* sysctls not referred to from outside net/core/ */
 extern int		netdev_budget;
-extern unsigned int	netdev_budget_usecs;
 extern unsigned int	sysctl_skb_defer_max;
 extern int		netdev_tstamp_prequeue;
 extern int		netdev_unregister_timeout_secs;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 782273bb93c2..59765c805f5b 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -595,14 +595,6 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &max_skb_frags,
 	},
-	{
-		.procname	= "netdev_budget_usecs",
-		.data		= &netdev_budget_usecs,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
 	{
 		.procname	= "fb_tunnels_only_for_init_net",
 		.data		= &sysctl_fb_tunnels_only_for_init_net,
-- 
2.34.1


