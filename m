Return-Path: <netdev+bounces-2035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFC970004A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC3F281764
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4577461;
	Fri, 12 May 2023 06:25:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F36A63DE;
	Fri, 12 May 2023 06:25:01 +0000 (UTC)
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BB43ABF;
	Thu, 11 May 2023 23:24:56 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0ViNyZNW_1683872691;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0ViNyZNW_1683872691)
          by smtp.aliyun-inc.com;
          Fri, 12 May 2023 14:24:51 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: kgraul@linux.ibm.com,
	wenjia@linux.ibm.com,
	jaka@linux.ibm.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	pabeni@redhat.com,
	song@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	yhs@fb.com,
	edumazet@google.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	jolsa@kernel.org,
	guwen@linux.alibaba.com
Cc: kuba@kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH bpf-next v1 2/5] net/smc: allow smc to negotiate protocols on policies
Date: Fri, 12 May 2023 14:24:41 +0800
Message-Id: <1683872684-64872-3-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
References: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

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
 include/net/smc.h        |  32 +++++++++++
 net/Makefile             |   1 +
 net/smc/Kconfig          |  11 ++++
 net/smc/af_smc.c         | 134 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/smc/smc_negotiator.c | 119 +++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_negotiator.h | 116 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 412 insertions(+), 1 deletion(-)
 create mode 100644 net/smc/smc_negotiator.c
 create mode 100644 net/smc/smc_negotiator.h

diff --git a/include/net/smc.h b/include/net/smc.h
index 6d076f5..191061c 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -296,6 +296,8 @@ struct smc_sock {				/* smc sock container */
 	atomic_t                queued_smc_hs;  /* queued smc handshakes */
 	struct inet_connection_sock_af_ops		af_ops;
 	const struct inet_connection_sock_af_ops	*ori_af_ops;
+	/* protocol negotiator ops */
+	const struct smc_sock_negotiator_ops *negotiator_ops;
 						/* original af ops */
 	int			sockopt_defer_accept;
 						/* sockopt TCP_DEFER_ACCEPT
@@ -316,4 +318,34 @@ struct smc_sock {				/* smc sock container */
 						 */
 };
 
+#ifdef CONFIG_SMC_BPF
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
+#else
+struct smc_sock_negotiator_ops {};
+#endif
+
 #endif	/* _SMC_H */
diff --git a/net/Makefile b/net/Makefile
index 4c4dc53..222916a 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_SMC)		+= smc/
+obj-$(CONFIG_SMC_BPF)		+= smc/smc_negotiator.o
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
 obj-$(CONFIG_CAIF)		+= caif/
diff --git a/net/smc/Kconfig b/net/smc/Kconfig
index 1ab3c5a..bdcc9f1 100644
--- a/net/smc/Kconfig
+++ b/net/smc/Kconfig
@@ -19,3 +19,14 @@ config SMC_DIAG
 	  smcss.
 
 	  if unsure, say Y.
+
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
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 50c38b6..7406fd4 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -52,6 +52,7 @@
 #include "smc_close.h"
 #include "smc_stats.h"
 #include "smc_tracepoint.h"
+#include "smc_negotiator.h"
 #include "smc_sysctl.h"
 
 static DEFINE_MUTEX(smc_server_lgr_pending);	/* serialize link group
@@ -68,6 +69,119 @@
 static void smc_tcp_listen_work(struct work_struct *);
 static void smc_connect_work(struct work_struct *);
 
+#ifdef CONFIG_SMC_BPF
+
+/* Check if sock should use smc */
+int smc_sock_should_select_smc(const struct smc_sock *smc)
+{
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
+}
+
+void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing)
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
+
+int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name)
+{
+	struct smc_sock_negotiator_ops *ops;
+	int ret = -EINVAL;
+
+	/* already set */
+	if (READ_ONCE(smc->negotiator_ops))
+		smc_sock_cleanup_negotiator_ops(smc, /* might be still referenced */ false);
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
+
+void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, bool no_more)
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
+	/* if the socks may have references to the negotiator ops to be removed.
+	 * it means that we might need to wait for the readers of ops
+	 * to complete. It's slow though.
+	 */
+	if (unlikely(!no_more))
+		synchronize_rcu();
+	if (ops->release)
+		ops->release(&smc->sk);
+	bpf_module_put(ops, ops->owner);
+}
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
+#endif
+
 int smc_nl_dump_hs_limitation(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct smc_nl_dmp_ctx *cb_ctx = smc_nl_dmp_ctx(cb);
@@ -166,6 +280,9 @@ static bool smc_hs_congested(const struct sock *sk)
 	if (workqueue_congested(WORK_CPU_UNBOUND, smc_hs_wq))
 		return true;
 
+	if (!smc_sock_should_select_smc(smc))
+		return true;
+
 	return false;
 }
 
@@ -320,6 +437,9 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	/* trigger info gathering if needed.*/
+	smc_sock_perform_collecting_info(smc, SMC_SOCK_CLOSED_TIMING);
+
 	old_state = sk->sk_state;
 
 	/* cleanup for a dangling non-blocking connect */
@@ -356,6 +476,9 @@ static int smc_release(struct socket *sock)
 
 static void smc_destruct(struct sock *sk)
 {
+	/* cleanup negotiator_ops if set */
+	smc_sock_cleanup_negotiator_ops(smc_sk(sk), /* no longer used */ true);
+
 	if (sk->sk_state != SMC_CLOSED)
 		return;
 	if (!sock_flag(sk, SOCK_DEAD))
@@ -1627,7 +1750,14 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
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
@@ -1679,6 +1809,8 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	}
 	*new_smc = smc_sk(new_sk);
 
+	smc_sock_clone_negotiator_ops(lsk, new_sk);
+
 	mutex_lock(&lsmc->clcsock_release_lock);
 	if (lsmc->clcsock)
 		rc = kernel_accept(lsmc->clcsock, &new_clcsock, SOCK_NONBLOCK);
diff --git a/net/smc/smc_negotiator.c b/net/smc/smc_negotiator.c
new file mode 100644
index 0000000..a93a19e
--- /dev/null
+++ b/net/smc/smc_negotiator.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Support eBPF for Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  Author(s):  D. Wythe <alibuda@linux.alibaba.com>
+ */
+#include <linux/kernel.h>
+#include <linux/bpf.h>
+#include <linux/smc.h>
+#include <net/sock.h>
+
+#include "smc_negotiator.h"
+#include "smc.h"
+
+static DEFINE_SPINLOCK(smc_sock_negotiator_list_lock);
+static LIST_HEAD(smc_sock_negotiator_list);
+
+/* required smc_sock_negotiator_list_lock locked */
+static inline struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_key(u32 key)
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
+struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_name(const char *name)
+{
+	struct smc_sock_negotiator_ops *ops = NULL;
+
+	spin_lock(&smc_sock_negotiator_list_lock);
+	list_for_each_entry_rcu(ops, &smc_sock_negotiator_list, list) {
+		if (strcmp(ops->name, name) == 0)
+			break;
+	}
+	spin_unlock(&smc_sock_negotiator_list_lock);
+	return ops;
+}
+EXPORT_SYMBOL_GPL(smc_negotiator_ops_get_by_name);
+
+int smc_sock_validate_negotiator_ops(struct smc_sock_negotiator_ops *ops)
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
diff --git a/net/smc/smc_negotiator.h b/net/smc/smc_negotiator.h
new file mode 100644
index 0000000..b294ede
--- /dev/null
+++ b/net/smc/smc_negotiator.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Support eBPF for Shared Memory Communications over RDMA (SMC-R) and RoCE
+ *
+ *  Author(s):  D. Wythe <alibuda@linux.alibaba.com>
+ */
+
+#include <linux/types.h>
+#include <net/smc.h>
+
+/* Max length of negotiator name */
+#define SMC_NEGOTIATOR_NAME_MAX	(16)
+
+/* closing time */
+#define SMC_SOCK_CLOSED_TIMING	(0)
+
+#ifdef CONFIG_SMC_BPF
+
+/* Register a new SMC socket negotiator ops
+ * The registered ops can then be assigned to SMC sockets using
+ * smc_sock_assign_negotiator_ops() via name
+ * Return: 0 on success, negative error code on failure
+ */
+int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops *ops);
+
+/* Update an existing SMC socket negotiator ops
+ * This function is used to update an existing SMC socket negotiator ops. The new ops will
+ * replace the old ops who has the same name.
+ * Return: 0 on success, negative error code on failure.
+ */
+int smc_sock_update_negotiator_ops(struct smc_sock_negotiator_ops *ops,
+				   struct smc_sock_negotiator_ops *old_ops);
+
+/* Validate SMC negotiator operations
+ * This function is called to validate an SMC negotiator operations structure
+ * before it is assigned to a socket. It checks that all necessary function
+ * pointers are defined and not null.
+ * Returns 0 if the @ops argument is valid, or a negative error code otherwise.
+ */
+int smc_sock_validate_negotiator_ops(struct smc_sock_negotiator_ops *ops);
+
+/* Unregister an SMC socket negotiator ops
+ * This function is used to unregister an existing SMC socket negotiator ops.
+ * The ops will no longer be available for assignment to SMC sockets immediately.
+ */
+void smc_sock_unregister_negotiator_ops(struct smc_sock_negotiator_ops *ops);
+
+/* Get registered negotiator ops via name, caller should invoke it
+ * with RCU protected.
+ */
+struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_name(const char *name);
+
+/* Assign a negotiator ops to an SMC socket
+ * This function is used to assign a negotiator ops to an SMC socket.
+ * The ops must have been previously registered with
+ * smc_sock_register_negotiator_ops().
+ * Return: 0 on success, negative error code on failure.
+ */
+int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name);
+
+/* Remove negotiator ops who had assigned to @smc.
+ * @no_more implies that the caller explicitly states that the @smc have no references
+ * to the negotiator ops to be removed. This is not a mandatory option.
+ * When it sets to false, we will use RCU to protect ops, but in this case we have to
+ * always call synchronize_rcu(), which has a significant performance impact.
+ */
+void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, bool no_more);
+
+/* Clone negotiator ops of parnet sock to
+ * child sock.
+ */
+void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child);
+
+/* Check if sock should use smc */
+int smc_sock_should_select_smc(const struct smc_sock *smc);
+
+/* Collect information to assigned ops */
+void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing);
+
+#else
+static inline int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops *ops)
+{
+	return 0;
+}
+
+static inline int smc_sock_update_negotiator_ops(struct smc_sock_negotiator_ops *ops,
+						 struct smc_sock_negotiator_ops *old_ops)
+{
+	return 0;
+}
+
+static inline int smc_sock_validate_negotiator_ops(struct smc_sock_negotiator_ops *ops)
+{
+	return 0;
+}
+
+static inline void smc_sock_unregister_negotiator_ops(struct smc_sock_negotiator_ops *ops) {}
+
+static inline struct smc_sock_negotiator_ops *smc_negotiator_ops_get_by_name(const char *name)
+{
+	return NULL;
+}
+
+static inline int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const char *name)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void smc_sock_cleanup_negotiator_ops(struct smc_sock *smc, bool no_more) {}
+
+static inline void smc_sock_clone_negotiator_ops(struct sock *parent, struct sock *child) {}
+
+static inline int smc_sock_should_select_smc(const struct smc_sock *smc) { return SK_PASS; }
+
+static inline void smc_sock_perform_collecting_info(const struct smc_sock *smc, int timing) {}
+#endif
-- 
1.8.3.1


