Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90E37B01C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhEKUgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 16:36:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:42888 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKUgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 16:36:45 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgZ6P-000427-Qn; Tue, 11 May 2021 22:35:37 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     andrii@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/2] bpf: Add kconfig knob for disabling unpriv bpf by default
Date:   Tue, 11 May 2021 22:35:17 +0200
Message-Id: <74ec548079189e4e4dffaeb42b8987bb3c852eee.1620765074.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <f23f58765a4d59244ebd8037da7b6a6b2fb58446.1620765074.git.daniel@iogearbox.net>
References: <f23f58765a4d59244ebd8037da7b6a6b2fb58446.1620765074.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26167/Tue May 11 13:12:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a kconfig knob which allows for unprivileged bpf to be disabled by default.
If set, the knob sets /proc/sys/kernel/unprivileged_bpf_disabled to value of 2.

This still allows a transition of 2 -> {0,1} through an admin. Similarly,
this also still keeps 1 -> {1} behavior intact, so that once set to permanently
disabled, it cannot be undone aside from a reboot.

We've also added extra2 with max of 2 for the procfs handler, so that an admin
still has a chance to toggle between 0 <-> 2.

Either way, as an additional alternative, applications can make use of CAP_BPF
that we added a while ago.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 Documentation/admin-guide/sysctl/kernel.rst | 17 +++++++++---
 kernel/bpf/Kconfig                          | 10 +++++++
 kernel/bpf/syscall.c                        |  3 ++-
 kernel/sysctl.c                             | 29 +++++++++++++++++----
 4 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 1d56a6b73a4e..24ab20d7a50a 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1457,11 +1457,22 @@ unprivileged_bpf_disabled
 =========================
 
 Writing 1 to this entry will disable unprivileged calls to ``bpf()``;
-once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` will return
-``-EPERM``.
+once disabled, calling ``bpf()`` without ``CAP_SYS_ADMIN`` or ``CAP_BPF``
+will return ``-EPERM``. Once set to 1, this can't be cleared from the
+running kernel anymore.
 
-Once set, this can't be cleared.
+Writing 2 to this entry will also disable unprivileged calls to ``bpf()``,
+however, an admin can still change this setting later on, if needed, by
+writing 0 or 1 to this entry.
 
+If ``BPF_UNPRIV_DEFAULT_OFF`` is enabled in the kernel config, then this
+entry will default to 2 instead of 0.
+
+= =============================================================
+0 Unprivileged calls to ``bpf()`` are enabled
+1 Unprivileged calls to ``bpf()`` are disabled without recovery
+2 Unprivileged calls to ``bpf()`` are disabled
+= =============================================================
 
 watchdog
 ========
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index b4edaefc6255..26b591e23f16 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -61,6 +61,16 @@ config BPF_JIT_DEFAULT_ON
 	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
 	depends on HAVE_EBPF_JIT && BPF_JIT
 
+config BPF_UNPRIV_DEFAULT_OFF
+	bool "Disable unprivileged BPF by default"
+	depends on BPF_SYSCALL
+	help
+	  Disables unprivileged BPF by default by setting the corresponding
+	  /proc/sys/kernel/unprivileged_bpf_disabled knob to 2. An admin can
+	  still reenable it by setting it to 0 later on, or permanently
+	  disable it by setting it to 1 (from which no other transition to
+	  0 is possible anymore).
+
 source "kernel/bpf/preload/Kconfig"
 
 config BPF_LSM
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 941ca06d9dfa..ea04b0deb5ce 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -50,7 +50,8 @@ static DEFINE_SPINLOCK(map_idr_lock);
 static DEFINE_IDR(link_idr);
 static DEFINE_SPINLOCK(link_idr_lock);
 
-int sysctl_unprivileged_bpf_disabled __read_mostly;
+int sysctl_unprivileged_bpf_disabled __read_mostly =
+	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f91d327273c1..6df7c81f7cdd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -225,7 +225,27 @@ static int bpf_stats_handler(struct ctl_table *table, int write,
 	mutex_unlock(&bpf_stats_enabled_mutex);
 	return ret;
 }
-#endif
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
+	return ret;
+}
+#endif /* CONFIG_BPF_SYSCALL && CONFIG_SYSCTL */
 
 /*
  * /proc/sys support
@@ -2600,10 +2620,9 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_unprivileged_bpf_disabled,
 		.maxlen		= sizeof(sysctl_unprivileged_bpf_disabled),
 		.mode		= 0644,
-		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ONE,
-		.extra2		= SYSCTL_ONE,
+		.proc_handler	= bpf_unpriv_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &two,
 	},
 	{
 		.procname	= "bpf_stats_enabled",
-- 
2.21.0

