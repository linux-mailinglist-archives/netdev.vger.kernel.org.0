Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CDA4F76D3
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiDGHKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbiDGHKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:10:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCE321836;
        Thu,  7 Apr 2022 00:08:09 -0700 (PDT)
Received: from kwepemi500017.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KYss60v2WzdZhQ;
        Thu,  7 Apr 2022 15:07:38 +0800 (CST)
Received: from linux-suse12sp5.huawei.com (10.67.133.175) by
 kwepemi500017.china.huawei.com (7.221.188.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Apr 2022 15:08:05 +0800
From:   Yan Zhu <zhuyan34@huawei.com>
To:     <mcgrof@kernel.org>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <keescook@chromium.org>, <kpsingh@kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liucheng32@huawei.com>, <netdev@vger.kernel.org>,
        <nixiaoming@huawei.com>, <songliubraving@fb.com>,
        <xiechengliang1@huawei.com>, <yhs@fb.com>, <yzaikin@google.com>,
        <zengweilin@huawei.com>, <zhuyan34@huawei.com>,
        <leeyou.li@huawei.com>, <laiyuanyuan.lai@huawei.com>
Subject: [PATCH v4 sysctl-next] bpf: move bpf sysctls from kernel/sysctl.c to bpf module
Date:   Thu, 7 Apr 2022 15:07:59 +0800
Message-ID: <20220407070759.29506-1-zhuyan34@huawei.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
References: <Yk4XE/hKGOQs5oq0@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.133.175]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500017.china.huawei.com (7.221.188.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're moving sysctls out of kernel/sysctl.c as its a mess. We
already moved all filesystem sysctls out. And with time the goal is
to move all sysctls out to their own subsystem/actual user.

kernel/sysctl.c has grown to an insane mess and its easy to run
into conflicts with it. The effort to move them out is part of this.

Signed-off-by: Yan Zhu <zhuyan34@huawei.com>

---
v1->v2:
  1.Added patch branch identifier sysctl-next.
  2.Re-describe the reason for the patch submission.

v2->v3:
  Re-describe the reason for the patch submission.

v3->v4:
  1.Remove '#include <linux/bpf.h>' in kernel/sysctl.c
  2.re-adaptive the patch
---
 kernel/bpf/syscall.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c      | 79 -----------------------------------------------
 2 files changed, 87 insertions(+), 79 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cdaa1152436a..e9621cfa09f2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4908,3 +4908,90 @@ const struct bpf_verifier_ops bpf_syscall_verifier_ops = {
 const struct bpf_prog_ops bpf_syscall_prog_ops = {
 	.test_run = bpf_prog_test_run_syscall,
 };
+
+#ifdef CONFIG_SYSCTL
+static int bpf_stats_handler(struct ctl_table *table, int write,
+			     void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct static_key *key = (struct static_key *)table->data;
+	static int saved_val;
+	int val, ret;
+	struct ctl_table tmp = {
+		.data   = &val,
+		.maxlen = sizeof(val),
+		.mode   = table->mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&bpf_stats_enabled_mutex);
+	val = saved_val;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret && val != saved_val) {
+		if (val)
+			static_key_slow_inc(key);
+		else
+			static_key_slow_dec(key);
+		saved_val = val;
+	}
+	mutex_unlock(&bpf_stats_enabled_mutex);
+	return ret;
+}
+
+void __weak unpriv_ebpf_notify(int new_state)
+{
+}
+
+static int bpf_unpriv_handler(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, unpriv_enable = *(int *)table->data;
+	bool locked_state = unpriv_enable == 1;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &unpriv_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		if (locked_state && unpriv_enable != 1)
+			return -EPERM;
+		*(int *)table->data = unpriv_enable;
+	}
+
+	unpriv_ebpf_notify(unpriv_enable);
+
+	return ret;
+}
+
+static struct ctl_table bpf_syscall_table[] = {
+	{
+		.procname	= "unprivileged_bpf_disabled",
+		.data		= &sysctl_unprivileged_bpf_disabled,
+		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
+		.mode		= 0644,
+		.proc_handler	= bpf_unpriv_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{
+		.procname	= "bpf_stats_enabled",
+		.data		= &bpf_stats_enabled_key.key,
+		.maxlen		= sizeof(bpf_stats_enabled_key),
+		.mode		= 0644,
+		.proc_handler	= bpf_stats_handler,
+	},
+	{ }
+};
+
+static int __init bpf_syscall_sysctl_init(void)
+{
+	register_sysctl_init("kernel", bpf_syscall_table);
+	return 0;
+}
+late_initcall(bpf_syscall_sysctl_init);
+#endif /* CONFIG_SYSCTL */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 21172d3dad6e..c0fdf465a93d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -62,7 +62,6 @@
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
 #include <linux/kexec.h>
-#include <linux/bpf.h>
 #include <linux/mount.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/latencytop.h>
@@ -139,66 +138,6 @@ static const int max_extfrag_threshold = 1000;
 
 #endif /* CONFIG_SYSCTL */
 
-#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
-static int bpf_stats_handler(struct ctl_table *table, int write,
-			     void *buffer, size_t *lenp, loff_t *ppos)
-{
-	struct static_key *key = (struct static_key *)table->data;
-	static int saved_val;
-	int val, ret;
-	struct ctl_table tmp = {
-		.data   = &val,
-		.maxlen = sizeof(val),
-		.mode   = table->mode,
-		.extra1 = SYSCTL_ZERO,
-		.extra2 = SYSCTL_ONE,
-	};
-
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	mutex_lock(&bpf_stats_enabled_mutex);
-	val = saved_val;
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
-	if (write && !ret && val != saved_val) {
-		if (val)
-			static_key_slow_inc(key);
-		else
-			static_key_slow_dec(key);
-		saved_val = val;
-	}
-	mutex_unlock(&bpf_stats_enabled_mutex);
-	return ret;
-}
-
-void __weak unpriv_ebpf_notify(int new_state)
-{
-}
-
-static int bpf_unpriv_handler(struct ctl_table *table, int write,
-			      void *buffer, size_t *lenp, loff_t *ppos)
-{
-	int ret, unpriv_enable = *(int *)table->data;
-	bool locked_state = unpriv_enable == 1;
-	struct ctl_table tmp = *table;
-
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	tmp.data = &unpriv_enable;
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
-	if (write && !ret) {
-		if (locked_state && unpriv_enable != 1)
-			return -EPERM;
-		*(int *)table->data = unpriv_enable;
-	}
-
-	unpriv_ebpf_notify(unpriv_enable);
-
-	return ret;
-}
-#endif /* CONFIG_BPF_SYSCALL && CONFIG_SYSCTL */
-
 /*
  * /proc/sys support
  */
@@ -2112,24 +2051,6 @@ static struct ctl_table kern_table[] = {
 		.extra2		= SYSCTL_ONE,
 	},
 #endif
-#ifdef CONFIG_BPF_SYSCALL
-	{
-		.procname	= "unprivileged_bpf_disabled",
-		.data		= &sysctl_unprivileged_bpf_disabled,
-		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
-		.mode		= 0644,
-		.proc_handler	= bpf_unpriv_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
-		.procname	= "bpf_stats_enabled",
-		.data		= &bpf_stats_enabled_key.key,
-		.maxlen		= sizeof(bpf_stats_enabled_key),
-		.mode		= 0644,
-		.proc_handler	= bpf_stats_handler,
-	},
-#endif
 #if defined(CONFIG_TREE_RCU)
 	{
 		.procname	= "panic_on_rcu_stall",
-- 
2.12.3

