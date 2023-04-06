Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2C96D9C67
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 17:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbjDFPaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238906AbjDFPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 11:30:51 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA497EEA;
        Thu,  6 Apr 2023 08:30:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfTVmhk_1680795042;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VfTVmhk_1680795042)
          by smtp.aliyun-inc.com;
          Thu, 06 Apr 2023 23:30:42 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC PATCH bpf-next 2/5] net/smc: net/smc: allow smc to negotiate protocols on policies
Date:   Thu,  6 Apr 2023 23:30:31 +0800
Message-Id: <1680795034-86384-3-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
References: <1680795034-86384-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

As we all know, the SMC protocol is not suitable for all scenarios,
especially for short-lived. However, for most applications, they cannot
guarantee that there are no such scenarios at all. Therefore, apps
may need some specific strategies to decide shall we need to use SMC
or not.

Just like the congestion control implementation in TCP, this patch
provides a generic negotiator implementation. If necessary,
we can provide different protocol negotiation strategies for
apps based on this implementation.

But most importantly, this patch provides the possibility of
eBPF injection, allowing users to implement their own protocol
negotiation policy in userspace.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/net/smc.h |  43 ++++++++++++
 net/Makefile      |   1 +
 net/smc/Kconfig   |  13 ++++
 net/smc/af_smc.c  |  68 ++++++++++++++++++-
 net/smc/bpf_smc.c | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100644 net/smc/bpf_smc.c

diff --git a/include/net/smc.h b/include/net/smc.h
index eccbd37..347050c 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -295,6 +295,8 @@ struct smc_sock {				/* smc sock container */
 	atomic_t                queued_smc_hs;  /* queued smc handshakes */
 	struct inet_connection_sock_af_ops		af_ops;
 	const struct inet_connection_sock_af_ops	*ori_af_ops;
+	/* protocol negotiator ops */
+	const struct smc_sock_negotiator_ops *negotiator_ops;
 						/* original af ops */
 	int			sockopt_defer_accept;
 						/* sockopt TCP_DEFER_ACCEPT
@@ -315,4 +317,45 @@ struct smc_sock {				/* smc sock container */
 						 */
 };
 
+#ifdef CONFIG_SMC_BPF
+
+#define SMC_NEGOTIATOR_NAME_MAX	(16)
+#define SMC_SOCK_CLOSED_TIMING	(0)
+
+/* BPF struct ops for smc protocol negotiator */
+struct smc_sock_negotiator_ops {
+
+	struct list_head	list;
+
+	/* ops name */
+	char		name[16];
+	/* key for name */
+	u32			key;
+
+	/* init with sk */
+	void (*init)(struct sock *sk);
+
+	/* release with sk */
+	void (*release)(struct sock *sk);
+
+	/* advice for negotiate */
+	int (*negotiate)(struct sock *sk);
+
+	/* info gathering timing */
+	void (*collect_info)(struct sock *sk, int timing);
+
+	/* module owner */
+	struct module *owner;
+};
+
+int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops *ops);
+int smc_sock_update_negotiator_ops(struct smc_sock_negotiator_ops *ops,
+					  struct smc_sock_negotiator_ops *old_ops);
+void smc_sock_unregister_negotiator_ops(struct smc_sock_negotiator_ops *ops);
+int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name);
+void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, int in_release);
+void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child);
+
+#endif
+
 #endif	/* _SMC_H */
diff --git a/net/Makefile b/net/Makefile
index 0914bea..a3b2d7a 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_SMC)		+= smc/
+obj-$(CONFIG_SMC_BPF)	+= smc/bpf_smc.o
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
 obj-$(CONFIG_CAIF)		+= caif/
diff --git a/net/smc/Kconfig b/net/smc/Kconfig
index 1ab3c5a..0a584bb 100644
--- a/net/smc/Kconfig
+++ b/net/smc/Kconfig
@@ -19,3 +19,16 @@ config SMC_DIAG
 	  smcss.
 
 	  if unsure, say Y.
+
+if SMC
+config SMC_BPF
+	bool "SMC: support eBPF" if SMC
+	depends on BPF_SYSCALL
+	default n
+	help
+	  Supports eBPF to allows user mode participation in SMC's protocol process
+	  via ebpf programs. Alternatively, obtain information about the SMC socks
+	  through the ebpf program.
+
+	  If unsure, say N.
+endif
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a4cccdf..567feef 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -68,6 +68,49 @@
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
+static int smc_sock_should_select_smc(const struct smc_sock *smc)
+{
+#ifdef CONFIG_SMC_BPF
+	const struct smc_sock_negotiator_ops *ops;
+	int ret;
+
+	rcu_read_lock();
+	ops = READ_ONCE(smc->negotiator_ops);
+
+	/* No negotiator_ops supply or no negotiate func set,
+	 * always pass it.
+	 */
+	if (!ops || !ops->negotiate) {
+		rcu_read_unlock();
+		return SK_PASS;
+	}
+
+	ret = ops->negotiate((struct sock *)&smc->sk);
+	rcu_read_unlock();
+	return ret;
+#else
+	return SK_PASS;
+#endif
+}
+
+#ifdef CONFIG_SMC_BPF
+static void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing)
+{
+	const struct smc_sock_negotiator_ops *ops;
+
+	rcu_read_lock();
+	ops = READ_ONCE(smc->negotiator_ops);
+
+	if (!ops || !ops->collect_info) {
+		rcu_read_unlock();
+		return;
+	}
+
+	ops->collect_info((struct sock *)&smc->sk, timing);
+	rcu_read_unlock();
+}
+#endif
+
 int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
@@ -166,6 +209,9 @@ static bool smc_hs_congested(const struct sock *sk)
 	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
 		return true;
 
+	if (!smc_sock_should_select_smc(smc))
+		return true;
+
 	return false;
 }
 
@@ -320,6 +366,11 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+#ifdef CONFIG_SMC_BPF
+	/* trigger info gathering if needed.*/
+	smc_sock_perform_collecting_info(smc, SMC_SOCK_CLOSED_TIMING);
+#endif
+
 	old_state = sk->sk_state;
 
 	/* cleanup for a dangling non-blocking connect */
@@ -360,6 +411,10 @@ static void smc_destruct(struct sock *sk)
 		return;
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
+#ifdef CONFIG_SMC_BPF
+	/* cleanup negotiator_ops if set */
+	smc_sock_cleanup_negotiator_ops(smc_sk(sk), /* in release */ 1);
+#endif
 }
 
 static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
@@ -1627,7 +1682,14 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
 	}
 
 	smc_copy_sock_settings_to_clc(smc);
-	tcp_sk(smc->clcsock->sk)->syn_smc = 1;
+	/* accept out connection as SMC connection */
+	if (smc_sock_should_select_smc(smc) == SK_PASS) {
+		tcp_sk(smc->clcsock->sk)->syn_smc = 1;
+	} else {
+		tcp_sk(smc->clcsock->sk)->syn_smc = 0;
+		smc_switch_to_fallback(smc, /* active fallback */ 0);
+	}
+
 	if (smc->connect_nonblock) {
 		rc = -EALREADY;
 		goto out;
@@ -1679,6 +1741,10 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	}
 	*new_smc = smc_sk(new_sk);
 
+#ifdef CONFIG_SMC_BPF
+	smc_sock_clone_negotiator_ops(lsk, new_sk);
+#endif
+
 	mutex_lock(&lsmc->clcsock_release_lock);
 	if (lsmc->clcsock)
 		rc = kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
new file mode 100644
index 0000000..e41c238
--- /dev/null
+++ b/net/smc/bpf_smc.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Support eBPF for Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  Copyright IBM Corp. 2016, 2018
+ *
+ *  Author(s):  D. Wythe <alibuda@linux.alibaba.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/bpf.h>
+#include <linux/smc.h>
+#include <net/sock.h>
+#include "smc.h"
+
+static DEFINE_SPINLOCK(smc_sock_negotiator_list_lock);
+static LIST_HEAD(smc_sock_negotiator_list);
+
+/* required smc_sock_negotiator_list_lock locked */
+static struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_key(u32 key)
+{
+	struct smc_sock_negotiator_ops *ops;
+
+	list_for_each_entry_rcu(ops, &smc_sock_negotiator_list, list) {
+		if (ops->key == key)
+			return ops;
+	}
+
+	return NULL;
+}
+
+/* required smc_sock_negotiator_list_lock locked */
+struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_name(const char *name)
+{
+	struct smc_sock_negotiator_ops *ops;
+
+	list_for_each_entry_rcu(ops, &smc_sock_negotiator_list, list) {
+		if (strcmp(ops->name, name) == 0)
+			return ops;
+	}
+
+	return NULL;
+}
+
+static int smc_sock_validate_negotiator_ops(struct smc_sock_negotiator_ops *ops)
+{
+	/* not required yet */
+	return 0;
+}
+
+/* register ops */
+int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops *ops)
+{
+	int ret;
+
+	ret = smc_sock_validate_negotiator_ops(ops);
+	if (ret)
+		return ret;
+
+	/* calt key by name hash */
+	ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
+
+	spin_lock(&smc_sock_negotiator_list_lock);
+	if (smc_negotiator_ops_get_by_key(ops->key)) {
+		pr_notice("smc: %s negotiator already registered\n", ops->name);
+		ret = -EEXIST;
+	} else {
+		list_add_tail_rcu(&ops->list, &smc_sock_negotiator_list);
+	}
+	spin_unlock(&smc_sock_negotiator_list_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smc_sock_register_negotiator_ops);
+
+/* unregister ops */
+void smc_sock_unregister_negotiator_ops(struct smc_sock_negotiator_ops *ops)
+{
+	spin_lock(&smc_sock_negotiator_list_lock);
+	list_del_rcu(&ops->list);
+	spin_unlock(&smc_sock_negotiator_list_lock);
+
+	/* Wait for outstanding readers to complete before the
+	 * ops gets removed entirely.
+	 */
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(smc_sock_unregister_negotiator_ops);
+
+int smc_sock_update_negotiator_ops(struct smc_sock_negotiator_ops *ops,
+				   struct smc_sock_negotiator_ops *old_ops)
+{
+	struct smc_sock_negotiator_ops *existing;
+	int ret;
+
+	ret = smc_sock_validate_negotiator_ops(ops);
+	if (ret)
+		return ret;
+
+	ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
+	if (unlikely(!ops->key))
+		return -EINVAL;
+
+	spin_lock(&smc_sock_negotiator_list_lock);
+	existing = smc_negotiator_ops_get_by_key(old_ops->key);
+	if (!existing || strcmp(existing->name, ops->name)) {
+		ret = -EINVAL;
+	} else if (existing != old_ops) {
+		pr_notice("invalid old negotiator to replace\n");
+		ret = -EINVAL;
+	} else {
+		list_add_tail_rcu(&ops->list, &smc_sock_negotiator_list);
+		list_del_rcu(&existing->list);
+	}
+
+	spin_unlock(&smc_sock_negotiator_list_lock);
+	if (ret)
+		return ret;
+
+	synchronize_rcu();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(smc_sock_update_negotiator_ops);
+
+/* assign ops to sock */
+int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name)
+{
+	struct smc_sock_negotiator_ops *ops;
+	int ret = -EINVAL;
+
+	/* already set */
+	if (READ_ONCE(smc->negotiator_ops))
+		smc_sock_cleanup_negotiator_ops(smc, /* in release */ 0);
+
+	/* Just for clear negotiator_ops */
+	if (!name || !strlen(name))
+		return 0;
+
+	rcu_read_lock();
+	ops = smc_negotiator_ops_get_by_name(name);
+	if (likely(ops)) {
+		if (unlikely(!bpf_try_module_get(ops, ops->owner))) {
+			ret = -EACCES;
+		} else {
+			WRITE_ONCE(smc->negotiator_ops, ops);
+			/* make sure ops can be seen */
+			smp_wmb();
+			if (ops->init)
+				ops->init(&smc->sk);
+			ret = 0;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smc_sock_assign_negotiator_ops);
+
+/* reset ops to sock */
+void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, int in_release)
+{
+	const struct smc_sock_negotiator_ops *ops;
+
+	ops = READ_ONCE(smc->negotiator_ops);
+
+	/* not all smc sock has negotiator_ops */
+	if (!ops)
+		return;
+
+	might_sleep();
+
+	/* Just ensure data integrity */
+	WRITE_ONCE(smc->negotiator_ops, NULL);
+	/* make sure NULL can be seen */
+	smp_wmb();
+	/* If the cleanup was not caused by the release of the sock,
+	 * it means that we may need to wait for the readers of ops
+	 * to complete.
+	 */
+	if (unlikely(!in_release))
+		synchronize_rcu();
+	if (ops->release)
+		ops->release(&smc->sk);
+	bpf_module_put(ops, ops->owner);
+}
+EXPORT_SYMBOL_GPL(smc_sock_cleanup_negotiator_ops);
+
+void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child)
+{
+	const struct smc_sock_negotiator_ops *ops;
+
+	rcu_read_lock();
+	ops = READ_ONCE(smc_sk(parent)->negotiator_ops);
+	if (ops && bpf_try_module_get(ops, ops->owner)) {
+		smc_sk(child)->negotiator_ops = ops;
+		if (ops->init)
+			ops->init(child);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(smc_sock_clone_negotiator_ops);
+
-- 
1.8.3.1

