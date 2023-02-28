Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772956A5D4D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjB1Qis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjB1Qio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:38:44 -0500
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB283A84;
        Tue, 28 Feb 2023 08:38:21 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0Vck898W_1677602296;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vck898W_1677602296)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 00:38:17 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 2/4] bpf: add SMC support in BPF struct_ops
Date:   Wed,  1 Mar 2023 00:38:09 +0800
Message-Id: <1677602291-1666-3-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
References: <1677602291-1666-1-git-send-email-alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "D. Wythe" <alibuda@linux.alibaba.com>

This PATCH attempts to introduce BPF injection capability for SMC.
Considering that the SMC protocol is not suitable for all scenarios,
especially for short-lived. However, for most applications, they cannot
guarantee that there are no such scenarios at all. Therefore, apps
may need some specific strategies to decide shall we need to use SMC
or not, for example, apps can limit the scope of the SMC to a specific
IP address or port.

Based on the consideration of transparent replacement, we hope that apps
can remain transparent even if they need to formulate some specific
strategies for SMC using. That is, do not need to recompile their code.

On the other hand, we need to ensure the scalability of strategies
implementation. Although it is simple to use socket options or sysctl,
it will bring more complexity to subsequent expansion.

Fortunately, BPF can solve these concerns very well, users can write
thire own strategies in eBPF to choose whether to use SMC or not.
And it's quite easy for them to modify their strategies in the future.

This PATCH implement injection capability for SMC via struct_ops.
In that way, we can add new injection scenarios in the future.

Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
---
 include/linux/btf_ids.h           |  12 ++++
 include/net/smc.h                 |  38 ++++++++++
 kernel/bpf/bpf_struct_ops_types.h |   4 ++
 net/Makefile                      |   5 ++
 net/smc/bpf_smc_struct_ops.c      | 148 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 207 insertions(+)
 create mode 100644 net/smc/bpf_smc_struct_ops.c

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 3a4f7cd..d4cf0a9 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -264,6 +264,18 @@ enum {
 MAX_BTF_TRACING_TYPE,
 };
 
+#if IS_ENABLED(CONFIG_SMC)
+enum {
+#define BTF_SMC_TYPE(name, type) name,
+BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)
+BTF_SMC_TYPE(BTF_SMC_TYPE_CONNECTION, smc_connection)
+BTF_SMC_TYPE(BTF_SMC_TYPE_HOST_CURSOR, smc_host_cursor)
+#undef BTF_SMC_TYPE
+MAX_BTF_SMC_TYPE,
+};
+extern u32 btf_smc_ids[];
+#endif
+
 extern u32 btf_tracing_ids[];
 extern u32 bpf_cgroup_btf_id[];
 extern u32 bpf_local_storage_map_btf_id[];
diff --git a/include/net/smc.h b/include/net/smc.h
index eccbd37..1891f49 100644
--- a/include/net/smc.h
+++ b/include/net/smc.h
@@ -16,6 +16,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/bpf.h>
 #include "linux/ism.h"
 
 #ifdef ATOMIC64_INIT
@@ -315,4 +316,41 @@ struct smc_sock {				/* smc sock container */
 						 */
 };
 
+#define SMC_SOCK_CLOSED_TIMING	(0)
+
+#ifdef CONFIG_BPF_SYSCALL
+
+/* BPF struct ops for smc protocol negotiator */
+struct smc_sock_negotiator_ops {
+	/* ret for negotiate */
+	int (*negotiate)(struct smc_sock *sk);
+
+	/* info gathering timing */
+	void (*collect_info)(struct sock *sk, int timing);
+};
+
+/* Query if current sock should go with SMC protocol
+ * SK_PASS for yes, otherwise for no.
+ */
+int smc_sock_should_select_smc(const struct smc_sock *smc);
+
+/* At some specific points in time,
+ * let negotiator can perform info gathering
+ * on target sock.
+ */
+void smc_sock_perform_collecting_info(const struct sock *sk, int timing);
+
+#else
+
+static inline int smc_sock_should_select_smc(const struct smc_sock *smc)
+{
+	return SK_PASS;
+}
+
+static inline void smc_sock_perform_collecting_info(const struct sock *sk, int timing)
+{
+}
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 #endif	/* _SMC_H */
diff --git a/kernel/bpf/bpf_struct_ops_types.h b/kernel/bpf/bpf_struct_ops_types.h
index 5678a9d..35cdd15 100644
--- a/kernel/bpf/bpf_struct_ops_types.h
+++ b/kernel/bpf/bpf_struct_ops_types.h
@@ -9,4 +9,8 @@
 #include <net/tcp.h>
 BPF_STRUCT_OPS_TYPE(tcp_congestion_ops)
 #endif
+#if IS_ENABLED(CONFIG_SMC)
+#include <net/smc.h>
+BPF_STRUCT_OPS_TYPE(smc_sock_negotiator_ops)
+#endif
 #endif
diff --git a/net/Makefile b/net/Makefile
index 0914bea..47a4c00 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -52,6 +52,11 @@ obj-$(CONFIG_TIPC)		+= tipc/
 obj-$(CONFIG_NETLABEL)		+= netlabel/
 obj-$(CONFIG_IUCV)		+= iucv/
 obj-$(CONFIG_SMC)		+= smc/
+ifneq ($(CONFIG_SMC),)
+ifeq ($(CONFIG_BPF_SYSCALL),y)
+obj-y				+= smc/bpf_smc_struct_ops.o
+endif
+endif
 obj-$(CONFIG_RFKILL)		+= rfkill/
 obj-$(CONFIG_NET_9P)		+= 9p/
 obj-$(CONFIG_CAIF)		+= caif/
diff --git a/net/smc/bpf_smc_struct_ops.c b/net/smc/bpf_smc_struct_ops.c
new file mode 100644
index 0000000..5772a42
--- /dev/null
+++ b/net/smc/bpf_smc_struct_ops.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf_ids.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <net/sock.h>
+#include <net/smc.h>
+
+extern struct bpf_struct_ops smc_sock_negotiator_ops;
+
+DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
+struct smc_sock_negotiator_ops *negotiator;
+
+/* convert sk to smc_sock */
+static inline struct smc_sock *smc_sk(const struct sock *sk)
+{
+	return (struct smc_sock *)sk;
+}
+
+/* register ops */
+static inline void smc_reg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
+{
+	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	negotiator = ops;
+	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+
+/* unregister ops */
+static inline void smc_unreg_passive_sk_ops(struct smc_sock_negotiator_ops *ops)
+{
+	write_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator == ops)
+		negotiator = NULL;
+	write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+
+int smc_sock_should_select_smc(const struct smc_sock *smc)
+{
+	int ret = SK_PASS;
+
+	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator && negotiator->negotiate)
+		ret = negotiator->negotiate((struct smc_sock *)smc);
+	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smc_sock_should_select_smc);
+
+void smc_sock_perform_collecting_info(const struct sock *sk, int timing)
+{
+	read_lock_bh(&smc_sock_negotiator_ops_rwlock);
+	if (negotiator && negotiator->collect_info)
+		negotiator->collect_info((struct sock *)sk, timing);
+	read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
+}
+EXPORT_SYMBOL_GPL(smc_sock_perform_collecting_info);
+
+/* define global smc ID for smc_struct_ops */
+BTF_ID_LIST_GLOBAL(btf_smc_ids, MAX_BTF_SMC_TYPE)
+#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
+BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)
+BTF_SMC_TYPE(BTF_SMC_TYPE_CONNECTION, smc_connection)
+BTF_SMC_TYPE(BTF_SMC_TYPE_HOST_CURSOR, smc_host_cursor)
+#undef BTF_SMC_TYPE
+
+static int bpf_smc_passive_sk_init(struct btf *btf)
+{
+	return 0;
+}
+
+/* register ops by BPF */
+static int bpf_smc_passive_sk_ops_reg(void *kdata)
+{
+	struct smc_sock_negotiator_ops *ops = kdata;
+
+	/* at least one ops need implement */
+	if (!ops->negotiate || !ops->collect_info) {
+		pr_err("At least one ops need implement.\n");
+		return -EINVAL;
+	}
+
+	smc_reg_passive_sk_ops(ops);
+	/* always success now */
+	return 0;
+}
+
+/* unregister ops by BPF */
+static void bpf_smc_passive_sk_ops_unreg(void *kdata)
+{
+	smc_unreg_passive_sk_ops(kdata);
+}
+
+static int bpf_smc_passive_sk_ops_check_member(const struct btf_type *t,
+					       const struct btf_member *member,
+					       const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_smc_passive_sk_ops_init_member(const struct btf_type *t,
+					      const struct btf_member *member,
+					      void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static const struct bpf_func_proto *
+smc_passive_sk_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static bool smc_passive_sk_ops_prog_is_valid_access(int off, int size, enum bpf_access_type type,
+						    const struct bpf_prog *prog,
+						    struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int smc_passive_sk_ops_prog_struct_access(struct bpf_verifier_log *log,
+						 const struct bpf_reg_state *reg,
+						 int off, int size, enum bpf_access_type atype,
+						 u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	/* only allow read now*/
+	if (atype == BPF_READ)
+		return btf_struct_access(log, reg, off, size, atype, next_btf_id, flag);
+
+	return -EACCES;
+}
+
+static const struct bpf_verifier_ops bpf_smc_passive_sk_verifier_ops = {
+	.get_func_proto  = smc_passive_sk_prog_func_proto,
+	.is_valid_access = smc_passive_sk_ops_prog_is_valid_access,
+	.btf_struct_access = smc_passive_sk_ops_prog_struct_access
+};
+
+struct bpf_struct_ops bpf_smc_sock_negotiator_ops = {
+	.verifier_ops = &bpf_smc_passive_sk_verifier_ops,
+	.init = bpf_smc_passive_sk_init,
+	.check_member = bpf_smc_passive_sk_ops_check_member,
+	.init_member = bpf_smc_passive_sk_ops_init_member,
+	.reg = bpf_smc_passive_sk_ops_reg,
+	.unreg = bpf_smc_passive_sk_ops_unreg,
+	.name = "smc_sock_negotiator_ops",
+};
-- 
1.8.3.1

