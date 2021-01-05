Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A412EA640
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbhAEIBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727418AbhAEIBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 03:01:02 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62E4C061793
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 00:00:36 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id v19so20750275pgj.12
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 00:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nlfo9/mhaNQaOLW+/54quz4laF3lE7RfS8AoXKz4As=;
        b=Hi0eGK430kFj6mC4/oLfF2qLXsWo+5dT6yQOBbNBpTi1WqbIQ6jYL9ed//fSkUvlto
         KVrHkUTIkNgx6u1ScApiowjWaJC9JtA7PmJ1XNHJ9yZMdIeIFoiVWYr5E+7q1bSnhuMK
         91+ZMtWrXqdqnEqaMd3R+/EzHS6Wz9zzGcs5Wa/DAvojVGTvRxAJmdBDiosWWhZLWjXa
         8bKn2PhEN6PlZapkaWxsIkwKqYFl7LGemCJpvfpaddbNuUIcn8ufSjw9f5zOiiUd1xwB
         tLrXgqKZT4+ytoXCD8dz0NXBQMlgQU97GeQt/YYd1gfdAnypSrwEcZdNWn43M6aT2HRk
         mrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3nlfo9/mhaNQaOLW+/54quz4laF3lE7RfS8AoXKz4As=;
        b=n+V0vXMAxCnpEB7PboB8ZUgajbK4bmtI1q/7/47a4rXBrb2nVPcJS0MbTZPgB8FKtg
         n5wkD8U4Dh86Iwj5KevA+sTlXGh5LPMP1GBJMwsPU+jqLdL/LVyEu0QyV8RHyxjJaQ+s
         szRL0rClTqgZpwq97PYHIodg5lvFZH44fMs8yn6nrbFfxQEDUi1OXVp7/yZr+XJcZYVl
         lqw6whKOP2IbQnJWnTlxD0Lnry+FdyfoelzME+TnZH0+tMzua0cMvDg/XmgzAZUmT/gS
         yCwoWCRh20UBYVXqWGeHOGeSkAlExKXw470da/20Q0Sh5HOtjg3/FQEuhS7uemfINOL5
         dktw==
X-Gm-Message-State: AOAM533Wz73osilCB9/SQug1ldCSOK8HlnNcWSBdx8a+1o6kPk6xzeVD
        DwUQPFjZPMVwaYWU5yryP7gmAg==
X-Google-Smtp-Source: ABdhPJxbt3vW5nq4MrAq9EWw9m+WRWOMgVjJ7121HntrlM+d0R45S/o9d6jS0LCaMSvjcXNfl8YUmA==
X-Received: by 2002:aa7:96d8:0:b029:19e:bc79:cf7 with SMTP id h24-20020aa796d80000b029019ebc790cf7mr44470361pfq.22.1609833636366;
        Tue, 05 Jan 2021 00:00:36 -0800 (PST)
Received: from C02X655XJG5H.bytedance.net ([61.120.150.71])
        by smtp.gmail.com with ESMTPSA id r20sm56546403pgb.3.2021.01.05.00.00.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Jan 2021 00:00:35 -0800 (PST)
From:   Xichen Lin <linxichen.01@bytedance.com>
X-Google-Original-From: Xichen Lin <linxichen.01@bytedance>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        wangdongdong.6@bytedance.com, cong.wang@bytedance.com,
        Xichen Lin <linxichen.01@bytedance.com>
Subject: [PATCH] bpf: Add signature checking for BPF programs
Date:   Tue,  5 Jan 2021 16:00:27 +0800
Message-Id: <20210105080027.36692-1-linxichen.01@bytedance.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xichen Lin <linxichen.01@bytedance.com>

Check the signature of a BPF program against the same set of keys for
module signature checking.

Currently the format of a signed BPF program is similar to that of
a signed kernel module, composed of BPF bytecode, signature,
module_signature structure and a magic string, in order, aligned to
struct sock_filter.

Signed-off-by: Xichen Lin <linxichen.01@bytedance.com>
---
 include/linux/bpf_sig.h | 26 ++++++++++++++++++
 init/Kconfig            | 10 +++++++
 kernel/bpf/Makefile     |  3 +++
 kernel/bpf/bpf_sig.c    | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c    |  5 ++++
 kernel/sysctl.c         | 14 ++++++++++
 6 files changed, 128 insertions(+)
 create mode 100644 include/linux/bpf_sig.h
 create mode 100644 kernel/bpf/bpf_sig.c

diff --git a/include/linux/bpf_sig.h b/include/linux/bpf_sig.h
new file mode 100644
index 000000000000..da87ba50f340
--- /dev/null
+++ b/include/linux/bpf_sig.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2020 Bytedance
+ */
+
+#ifndef _LINUX_BPF_SIG_H
+#define _LINUX_BPF_SIG_H
+
+#include <linux/bpf.h>
+
+#define BPF_PROG_SIG_STRING "~BPF signature appended~\n"
+
+#ifdef CONFIG_BPF_SIGNATURE
+extern int sysctl_bpf_signature_enable;
+#endif /* CONFIG_BPF_SIGNATURE */
+
+#ifdef CONFIG_BPF_SIGNATURE
+int bpf_check_prog_sig(struct bpf_prog *prog);
+#else
+static inline int bpf_check_prog_sig(struct bpf_prog *prog)
+{
+	return 0;
+}
+#endif /* CONFIG_BPF_SIGNATURE */
+#endif /* _LINUX_BPF_SIG_H */
diff --git a/init/Kconfig b/init/Kconfig
index b77c60f8b963..24225c966803 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2212,6 +2212,16 @@ config MODULE_SIG_HASH
 	default "sha384" if MODULE_SIG_SHA384
 	default "sha512" if MODULE_SIG_SHA512
 
+config BPF_SIGNATURE
+	bool "BPF program signature verification"
+	depends on MODULE_SIG
+	help
+	  Check BPF programs for valid signatures upon load: the signature
+	  is appended to the end of the BPF program similar to module signing.
+
+	  BPF signature checking will use the same kernel facilities as
+	  module signature checking as well as the keys and hash functions.
+
 config MODULE_COMPRESS
 	bool "Compress modules on installation"
 	help
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index d1249340fd6b..c6d2b200e795 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -37,3 +37,6 @@ obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
 obj-${CONFIG_BPF_LSM} += bpf_lsm.o
 endif
 obj-$(CONFIG_BPF_PRELOAD) += preload/
+ifeq ($(CONFIG_BPF_SIGNATURE),y)
+obj-$(CONFIG_BPF_SIGNATURE) += bpf_sig.o
+endif
diff --git a/kernel/bpf/bpf_sig.c b/kernel/bpf/bpf_sig.c
new file mode 100644
index 000000000000..7fcfc1b5d5d8
--- /dev/null
+++ b/kernel/bpf/bpf_sig.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2021 Bytedance */
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/bpf_sig.h>
+#include <linux/module_signature.h>
+#include <linux/verification.h>
+
+int sysctl_bpf_signature_enable;
+
+static bool bpf_strip_prog_ms(struct bpf_prog *prog, unsigned int *sig_len_ptr)
+{
+	void *data = (void *) prog->insns;
+	unsigned int prog_len = bpf_prog_size(prog->len) - sizeof(struct bpf_prog);
+	unsigned int rounded_ms_len = round_up(sizeof(struct module_signature),
+					       sizeof(struct sock_filter));
+	struct module_signature *ms = (struct module_signature *)
+		(data + prog_len - rounded_ms_len);
+	unsigned int rounded_sig_len;
+
+	*sig_len_ptr = be32_to_cpu(ms->sig_len);
+	rounded_sig_len = round_up(*sig_len_ptr, sizeof(struct sock_filter));
+
+	if (mod_check_sig(ms, prog_len, "bpf"))
+		return false;
+
+	if (prog_len > rounded_ms_len + rounded_sig_len) {
+		prog->len -= rounded_ms_len / sizeof(struct sock_filter);
+		prog->len -= rounded_sig_len / sizeof(struct sock_filter);
+		return true;
+	}
+
+	return false;
+}
+
+static bool bpf_strip_prog_sig(struct bpf_prog *prog, unsigned int *sig_len_ptr)
+{
+	void *data = (void *) prog->insns;
+	const unsigned int marker_len = sizeof(BPF_PROG_SIG_STRING) - 1;
+	const unsigned int rounded_marker_len = round_up(marker_len,
+							 sizeof(struct sock_filter));
+	unsigned int prog_len = bpf_prog_size(prog->len) - sizeof(struct bpf_prog);
+
+	if (prog_len > rounded_marker_len &&
+	    memcmp(data + prog_len - rounded_marker_len,
+		   BPF_PROG_SIG_STRING, marker_len) == 0) {
+		prog->len -= rounded_marker_len / sizeof(struct sock_filter);
+		return bpf_strip_prog_ms(prog, sig_len_ptr);
+	}
+
+	return false;
+}
+
+int bpf_check_prog_sig(struct bpf_prog *prog)
+{
+	bool stripped;
+	unsigned int sig_len;
+
+	stripped = bpf_strip_prog_sig(prog, &sig_len);
+	if (!sysctl_bpf_signature_enable)
+		return 0;
+	if (!stripped)
+		return -ENODATA;
+	return verify_pkcs7_signature(prog->insns, prog->len * sizeof(struct sock_filter),
+				      prog->insns + prog->len,
+				      sig_len, VERIFY_USE_SECONDARY_KEYRING,
+				      VERIFYING_MODULE_SIGNATURE,
+				      NULL, NULL);
+}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4caf06fe4152..2ce0afb12248 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -32,6 +32,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/bpf_sig.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2201,6 +2202,10 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (err < 0)
 		goto free_prog_sec;
 
+	err = bpf_check_prog_sig(prog);
+	if (err < 0)
+		goto free_prog;
+
 	/* run eBPF verifier */
 	err = bpf_check(&prog, attr, uattr);
 	if (err < 0)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c9fbdd848138..d447d26dd0eb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -103,6 +103,9 @@
 #ifdef CONFIG_LOCKUP_DETECTOR
 #include <linux/nmi.h>
 #endif
+#ifdef CONFIG_BPF_SIGNATURE
+#include <linux/bpf_sig.h>
+#endif /* CONFIG_BPF_SIGNATURE */
 
 #if defined(CONFIG_SYSCTL)
 
@@ -2621,6 +2624,17 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_BPF_SYSCALL
+#ifdef CONFIG_BPF_SIGNATURE
+	{
+		.procname	= "bpf_signature_enable",
+		.data		= &sysctl_bpf_signature_enable,
+		.maxlen		= sizeof(sysctl_bpf_signature_enable),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif /* CONFIG_BPF_SIGNATURE */
 	{
 		.procname	= "unprivileged_bpf_disabled",
 		.data		= &sysctl_unprivileged_bpf_disabled,
-- 
2.11.0

