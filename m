Return-Path: <netdev+bounces-9809-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EED9F72AB1C
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 13:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3569E1C20BE4
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 11:22:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA84125A9;
	Sat, 10 Jun 2023 11:22:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E71FD5;
	Sat, 10 Jun 2023 11:22:44 +0000 (UTC)
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA1E33598;
	Sat, 10 Jun 2023 04:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ejXHl
	lPedew2zZARz5FSqiDrl9loQ6Y6ONdoRA6fE/c=; b=Wn+/JbFHJNpWrtizXkBrS
	iEka2EspdeI7gqIKk3QbwQN5QH7MnodgVHLzKs++E6lwNNF1Eyqfn8wElY7c5Rjn
	pg2sl54ceQjw367UNoX2/Qzn1ncUyy30l23qJrQU47M2puFz30yNYVrynbVnB2ZO
	Db97JuUImjn2eiYGBg8p/g=
Received: from localhost.localdomain (unknown [202.112.238.192])
	by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wC3vTnyWIRktQIrAA--.13080S2;
	Sat, 10 Jun 2023 19:05:23 +0800 (CST)
From: Yi He <clangllvm@126.com>
To: ast@kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	song@kernel.org,
	yhs@fb.com,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Yi He <clangllvm@126.com>
Subject: [PATCH] Add a sysctl option to disable bpf offensive helpers.
Date: Sat, 10 Jun 2023 11:05:18 +0000
Message-Id: <20230610110518.123183-1-clangllvm@126.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wC3vTnyWIRktQIrAA--.13080S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKrW3JryUGr4kXr43uw43GFg_yoW3tF18pF
	97tryjyr40qF4IvrW7J3y8GryFkw4DXrW7Ca4kK3yfZF43XrZ2qr1kKF4agF1rZrZFg3ya
	vws2vFW5ua1Ika7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRjFAdUUUUU=
X-Originating-IP: [202.112.238.192]
X-CM-SenderInfo: xfod0wpooyzqqrswhudrp/1tbiYBSKy1pELSXNFAAAs6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
	HK_RANDOM_FROM,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some eBPF helper functions have been long regarded as problematic[1].
More than just used for powerful rootkit, these features can also be 
exploited to harm the containers by perform various attacks to the 
processes outside the container in the enrtire VM, such as process 
DoS, information theft, and container escape.  

When a container is granted to run eBPF tracing programs (which 
need CAP_SYS_ADMIN), it can use the eBPF KProbe programs to hijack the 
process outside the contianer and to escape the containers. This kind 
of risks is limited as privieleged containers are warned and can hardly
 be accessed by the attackers.

Even without CAP_SYS_ADMIN, since Linux 5.6, programs with with CAP_BPF + 
CAP_PERFMON can use dangerous eBPF helpers such as bpf_read_user to steal 
sensitive data (e.g., sshd/nginx private key) in other containers. 

Currently, eBPF users just enable CAP_SYS_ADMIN and also enable the offensive
features. Since lots of eBPF tools are distributed via containers, attackers 
may perform supply chain attacks to create and spread their eBPF malware, 
To prevent the abuse of these helpers, we introduce a new sysctl option 
(sysctl_offensive_bpf_disabled) to cofine the usages of five dangerous 
helpers:
- bpf_probe_write_user
- bpf_probe_read_user
- bpf_probe_read_kernel
- bpf_send_signal
- bpf_override_return

The default value of sysctl_offensive_bpf_disabled is 0, which means all the 
five helpers are enabled. By setting sysctl_offensive_bpf_disabled to 1, 
these helpers cannot be used util a reboot. By setting it to 2, these helpers
 cannot be used but privieleged users can modify this flag to 0.

For benign eBPF programs such as Cillium, they do not need these features and 
can set the sysctl_offensive_bpf_disabled to 1 after initialization.



[1] https://embracethered.com/blog/posts/2021/offensive-bpf/


Signed-off-by: fripSide <clangllvm@126.com>
---
 include/linux/bpf.h                       |  2 ++
 kernel/bpf/syscall.c                      | 33 +++++++++++++++++++++++
 kernel/configs/android-recommended.config |  1 +
 kernel/trace/bpf_trace.c                  | 21 ++++++++-------
 tools/testing/selftests/bpf/config        |  1 +
 5 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 456f33b9d205..61c723a589f8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2043,6 +2043,8 @@ bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 
 extern int sysctl_unprivileged_bpf_disabled;
 
+extern int sysctl_offensive_bpf_disabled;
+
 static inline bool bpf_allow_ptr_leaks(void)
 {
 	return perfmon_capable();
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 14f39c1e573e..6b8c8ee1ea22 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -58,6 +58,9 @@ static DEFINE_SPINLOCK(link_idr_lock);
 int sysctl_unprivileged_bpf_disabled __read_mostly =
 	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
+int sysctl_offensive_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_OFFENSIVE_BPF_OFF) ? 2 : 0;
+
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
 #define BPF_MAP_TYPE(_id, _ops) \
@@ -5385,6 +5388,27 @@ static int bpf_unpriv_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int bpf_offensive_handler(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, offensive_enable = *(int *)table->data;
+	bool locked_state = offensive_enable == 1;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &offensive_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		if (locked_state && offensive_enable != 1)
+			return -EPERM;
+		*(int *)table->data = offensive_enable;
+	}
+
+	return ret;
+}
+
 static struct ctl_table bpf_syscall_table[] = {
 	{
 		.procname	= "unprivileged_bpf_disabled",
@@ -5395,6 +5419,15 @@ static struct ctl_table bpf_syscall_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
 	},
+	{
+		.procname	= "offensive_bpf_disabled",
+		.data		= &sysctl_offensive_bpf_disabled,
+		.maxlen		= sizeof(sysctl_offensive_bpf_disabled),
+		.mode		= 0644,
+		.proc_handler	= bpf_offensive_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
 	{
 		.procname	= "bpf_stats_enabled",
 		.data		= &bpf_stats_enabled_key.key,
diff --git a/kernel/configs/android-recommended.config b/kernel/configs/android-recommended.config
index e400fbbc8aba..cca75258af72 100644
--- a/kernel/configs/android-recommended.config
+++ b/kernel/configs/android-recommended.config
@@ -1,5 +1,6 @@
 #  KEEP ALPHABETICALLY SORTED
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
+# CONFIG_BPF_OFFENSIVE_BPF_OFF is not set
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_LEGACY_PTYS is not set
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 8deb22a99abe..5bdd0bee3e45 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1432,17 +1432,18 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
 	case BPF_FUNC_probe_write_user:
-		return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
-		       NULL : bpf_get_probe_write_proto();
+		return (security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ||
+		       sysctl_offensive_bpf_disabled) ? NULL : bpf_get_probe_write_proto();
 	case BPF_FUNC_probe_read_user:
-		return &bpf_probe_read_user_proto;
+		return sysctl_offensive_bpf_disabled ? NULL : &bpf_probe_read_user_proto;
 	case BPF_FUNC_probe_read_kernel:
-		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
-		       NULL : &bpf_probe_read_kernel_proto;
+		return (security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ||
+		       sysctl_offensive_bpf_disabled) ? NULL : &bpf_probe_read_kernel_proto;
 	case BPF_FUNC_probe_read_user_str:
-		return &bpf_probe_read_user_str_proto;
+		return sysctl_offensive_bpf_disabled ? NULL : &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
-		return security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ?
+		return (security_locked_down(LOCKDOWN_BPF_READ_KERNEL) < 0 ||
+		       sysctl_offensive_bpf_disabled) ?
 		       NULL : &bpf_probe_read_kernel_str_proto;
 #ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	case BPF_FUNC_probe_read:
@@ -1459,9 +1460,9 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_cgrp_storage_delete_proto;
 #endif
 	case BPF_FUNC_send_signal:
-		return &bpf_send_signal_proto;
+		return sysctl_offensive_bpf_disabled ? NULL : &bpf_send_signal_proto;
 	case BPF_FUNC_send_signal_thread:
-		return &bpf_send_signal_thread_proto;
+		return sysctl_offensive_bpf_disabled ? NULL : &bpf_send_signal_thread_proto;
 	case BPF_FUNC_perf_event_read_value:
 		return &bpf_perf_event_read_value_proto;
 	case BPF_FUNC_get_ns_current_pid_tgid:
@@ -1527,7 +1528,7 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_stack_proto;
 #ifdef CONFIG_BPF_KPROBE_OVERRIDE
 	case BPF_FUNC_override_return:
-		return &bpf_override_return_proto;
+		return sysctl_offensive_bpf_disabled ? NULL : &bpf_override_return_proto;
 #endif
 	case BPF_FUNC_get_func_ip:
 		return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 63cd4ab70171..1a15d7451f19 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -9,6 +9,7 @@ CONFIG_BPF_LSM=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
+# CONFIG_BPF_OFFENSIVE_BPF_OFF is not set
 CONFIG_CGROUP_BPF=y
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA256=y
-- 
2.34.1


