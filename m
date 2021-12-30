Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082FD4818A4
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhL3ChS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbhL3ChQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:16 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F953C06173E;
        Wed, 29 Dec 2021 18:37:15 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 200so20257488pgg.3;
        Wed, 29 Dec 2021 18:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7v1RMRkuFj4G6xAOfpI/bF6UhKve5y7okLLeaIxFT3A=;
        b=Ebujbor4hyvwEX+lPWMaGPDZKKwsx+o+oPNJd2Jiz6fdbSFK/oquEp8Z60ECN0TmxF
         C13kw1uEDGS5eOzOd/J3dq+XOAmu+PBTspote3UGk1Guveq7+/jG4n7V3iJwAw0rExaj
         gpxfzYOHtWYfqCCGRcakRgYMgskpRSDx27od+i52o+vI5o2D9DR12wg+y+kb2O0Cmonw
         GkjHq9txGHq+xoFWqlK5ogFXiMA1hhecb71syxg3yMkF6k5qu5qpeuSPe+LYTVRHudPh
         8TnlTSzwWAZR/N+dvY4ZmnbvG9JiIzztYAgxJ2d15ldZQgpZQ85wTRORZ6rveYpGKqfm
         +ViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7v1RMRkuFj4G6xAOfpI/bF6UhKve5y7okLLeaIxFT3A=;
        b=lCLS9vQnrzKBcHCqwDtgOwD9wyCGW2EtWRVEpaBPaOf8o/jBU3qLvm/H1irE+H8XUu
         txzXBM6miLnm99CNjaJ+x89GfISBAYo4txgpHu3f+IOyBDHPc46ctvJDEZzd51tW0W+H
         FEhfemxOT6Xm07F/z0Rtqxx7BNHTclF24SRyWvhbROtop1MlxTAvjcFsUSrNxeQGz9WK
         cuCrS4kaZOO2G9cFspgCXbVNCkKREnYA+jlHBiHH5x8pcUDqh9+mpHDlDbm+WL4/pU8g
         wjJCdxBqiF24NSTBoaD6f6pmyPMHkByKK+t5S9lxnmphjOvcjt/6oKlzgiRq3SLEmLm2
         mg0Q==
X-Gm-Message-State: AOAM533D1MvgUktucq1FGu3Uf3MOQYSouUJgqF314dKiH21yOTNLbh0I
        oWJ6LF4p8pu3fYyO48FnsDc9+R4tsEA=
X-Google-Smtp-Source: ABdhPJzSiaCr7IHSwfzGjVW1+Hg3lQFxShzx0nTyw6gvX2tiFofJbuOsfLNa1/1euC5B2/tgsAjUhQ==
X-Received: by 2002:a63:6a49:: with SMTP id f70mr25921548pgc.244.1640831834762;
        Wed, 29 Dec 2021 18:37:14 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id c17sm25977793pfc.163.2021.12.29.18.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:14 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 2/9] bpf: Prepare kfunc BTF ID sets when parsing kernel BTF
Date:   Thu, 30 Dec 2021 08:06:58 +0530
Message-Id: <20211230023705.3860970-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14942; h=from:subject; bh=yfZs0iMFP/tsKe7SiiX8t+sBleMKMgjpw7VLf3GL+Cg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr9eB1u1lrO8gIOriHiqjl4CdC9C0X8EhmcBPz7 fPG1lUeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/QAKCRBM4MiGSL8RygIMD/ 42y0cJ8e8ZVS1Kfij4T4wwF1WFHof5TRa+sGcxL1VNQGuy/AOY0x7zSg7I+rU8JhiJwL7m7hqG2M6e nfKKbvR+KXZZndDniIy8Hy7yzc+gFY4NRAzxSiv9sQxFroRpj2+zEbj7lgLaiQTHiekSvm7r0BbBqu yLX5pmfrV6y6nKTsEtiXVIapFqE81B/j4wCOPpGfVqGi4LCj7W/iFl4L5QFvmN/wkS22eqHNHh3XVU zPoZ/E62ZYjtUs+EefqmyCOnh7ca9hHbdDow1ltV4fMz4lM936TAfHqKoF+Ss7+aEca4ap3OgI79yb AP2uGF6HhoWCKVOBl26lQDOG8qseL1JfEBgXopNonpowQmlc/ixqpnjU8tvtIpGON1Kl1OlMOX3qZv dnTqXPxQ5qSsKMTnKVKZQMOy3GKlUxVCiYmJlPFBLLIo3ODEc6dhyuGKd8BSiwuTvlS/6mO+Qcpxu8 8gR1U8B38ZWR0skuKvas0Ke0DIrmVsuHpuiJwuzF/m9xAXYZw0SWRaXWapV1/L2ixuDo4/mS7wN9t0 xmSN6i4Tw/Cs/BA2pqNReeJN/muusPa5ogRDhhY9LZ51QOWG/03F7NbSh5lLqu49vgMA6mYrdVzcWJ 1ZGJ0a9W9NBlprTjegur/dm730IBZDIRhSG5p6JkShgonqp5R9mJf4pG/F5A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit prepares the BTF parsing functions for vmlinux and module
BTFs to find all kfunc BTF ID sets from the vmlinux and module symbols
and concatentate all sets into single unified set which is sorted and
keyed by the 'hook' it is meant for, and 'type' of set.

The 'hook' is one of the many program types, e.g. XDP and TC/SCHED_CLS,
STRUCT_OPS, and 'types' are check (allowed or not), acquire, release,
and ret_null (with PTR_TO_BTF_ID_OR_NULL return type).

A maximum of BTF_KFUNC_SET_MAX_CNT (32) kfunc BTF IDs are permitted in a
set of certain hook and type. They are also allocated on demand, and
otherwise set as NULL.

A new btf_kfunc_id_set_contains function is exposed for use in verifier,
this new method is faster than the existing list searching method, and
is also automatic. It also lets other code not care whether the set is
unallocated or not.

Next commit will update the kernel users to make use of this
infrastructure.

Finally, add __maybe_unused annotation for BTF ID macros for the
!CONFIG_DEBUG_INFO_BTF case , so that they don't produce warnings during
build time.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

fixup maybe_unused
---
 include/linux/btf.h     |  25 ++++
 include/linux/btf_ids.h |  20 ++-
 kernel/bpf/btf.c        | 275 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 312 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 0c74348cbc9d..48ac2dc437a2 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -300,6 +300,21 @@ static inline const struct btf_var_secinfo *btf_type_var_secinfo(
 	return (const struct btf_var_secinfo *)(t + 1);
 }
 
+enum btf_kfunc_hook {
+	BTF_KFUNC_HOOK_XDP,
+	BTF_KFUNC_HOOK_TC,
+	BTF_KFUNC_HOOK_STRUCT_OPS,
+	_BTF_KFUNC_HOOK_MAX,
+};
+
+enum btf_kfunc_type {
+	BTF_KFUNC_TYPE_CHECK,
+	BTF_KFUNC_TYPE_ACQUIRE,
+	BTF_KFUNC_TYPE_RELEASE,
+	BTF_KFUNC_TYPE_RET_NULL,
+	_BTF_KFUNC_TYPE_MAX,
+};
+
 #ifdef CONFIG_BPF_SYSCALL
 struct bpf_prog;
 
@@ -307,6 +322,9 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
+bool btf_kfunc_id_set_contains(const struct btf *btf,
+			       enum bpf_prog_type prog_type,
+			       enum btf_kfunc_type type, u32 kfunc_btf_id);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -318,6 +336,13 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 {
 	return NULL;
 }
+static inline bool btf_kfunc_id_set_contains(const struct btf *btf,
+					     enum bpf_prog_type prog_type,
+					     enum btf_kfunc_type type,
+					     u32 kfunc_btf_id)
+{
+	return false;
+}
 #endif
 
 struct kfunc_btf_id_set {
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 919c0fde1c51..835fbf626ef1 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -11,6 +11,7 @@ struct btf_id_set {
 #ifdef CONFIG_DEBUG_INFO_BTF
 
 #include <linux/compiler.h> /* for __PASTE */
+#include <linux/compiler_attributes.h> /* for __maybe_unused */
 
 /*
  * Following macros help to define lists of BTF IDs placed
@@ -144,17 +145,24 @@ asm(							\
 ".popsection;                                 \n");	\
 extern struct btf_id_set name;
 
+#define BTF_KFUNC_SET_START(hook, type, name)			\
+	BTF_SET_START(btf_kfunc_set_##hook##_##type##_##name)
+#define BTF_KFUNC_SET_END(hook, type, name)                     \
+	BTF_SET_END(btf_kfunc_set_##hook##_##type##_##name)
+
 #else
 
-#define BTF_ID_LIST(name) static u32 name[5];
+#define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
 #define BTF_ID(prefix, name)
 #define BTF_ID_UNUSED
-#define BTF_ID_LIST_GLOBAL(name, n) u32 name[n];
-#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 name[1];
-#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 name[1];
-#define BTF_SET_START(name) static struct btf_id_set name = { 0 };
-#define BTF_SET_START_GLOBAL(name) static struct btf_id_set name = { 0 };
+#define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
+#define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 __maybe_unused name[1];
+#define BTF_ID_LIST_GLOBAL_SINGLE(name, prefix, typename) u32 __maybe_unused name[1];
+#define BTF_SET_START(name) static struct btf_id_set __maybe_unused name = { 0 };
+#define BTF_SET_START_GLOBAL(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_END(name)
+#define BTF_KFUNC_SET_START(hook, type, name) BTF_SET_START(name)
+#define BTF_KFUNC_SET_END(hook, type, name) BTF_SET_END(name)
 
 #endif /* CONFIG_DEBUG_INFO_BTF */
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 33bb8ae4a804..c03c7b5a417c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2018 Facebook */
 
+#include <linux/kallsyms.h>
+#include <linux/module.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_perf_event.h>
@@ -198,6 +200,8 @@
 DEFINE_IDR(btf_idr);
 DEFINE_SPINLOCK(btf_idr_lock);
 
+struct btf_kfunc_set_tab;
+
 struct btf {
 	void *data;
 	struct btf_type **types;
@@ -212,6 +216,7 @@ struct btf {
 	refcount_t refcnt;
 	u32 id;
 	struct rcu_head rcu;
+	struct btf_kfunc_set_tab *kfunc_set_tab;
 
 	/* split BTF support */
 	struct btf *base_btf;
@@ -221,6 +226,31 @@ struct btf {
 	bool kernel_btf;
 };
 
+#define BTF_KFUNC_SET_PREFIX "btf_kfunc_set_"
+
+BTF_ID_LIST_SINGLE(btf_id_set_id, struct, btf_id_set)
+
+static const char *kfunc_hook_str[_BTF_KFUNC_HOOK_MAX] = {
+	[BTF_KFUNC_HOOK_XDP]        = "xdp_",
+	[BTF_KFUNC_HOOK_TC]         = "tc_",
+	[BTF_KFUNC_HOOK_STRUCT_OPS] = "struct_ops_",
+};
+
+static const char *kfunc_type_str[_BTF_KFUNC_TYPE_MAX] = {
+	[BTF_KFUNC_TYPE_CHECK]    = "check_",
+	[BTF_KFUNC_TYPE_ACQUIRE]  = "acquire_",
+	[BTF_KFUNC_TYPE_RELEASE]  = "release_",
+	[BTF_KFUNC_TYPE_RET_NULL] = "ret_null_",
+};
+
+enum {
+	BTF_KFUNC_SET_MAX_CNT = 32,
+};
+
+struct btf_kfunc_set_tab {
+	struct btf_id_set *sets[_BTF_KFUNC_HOOK_MAX][_BTF_KFUNC_TYPE_MAX];
+};
+
 enum verifier_phase {
 	CHECK_META,
 	CHECK_TYPE,
@@ -1531,8 +1561,21 @@ static void btf_free_id(struct btf *btf)
 	spin_unlock_irqrestore(&btf_idr_lock, flags);
 }
 
+static void btf_free_kfunc_set_tab(struct btf_kfunc_set_tab *tab)
+{
+	int hook, type;
+
+	if (!tab)
+		return;
+	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
+		for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++)
+			kfree(tab->sets[hook][type]);
+	}
+}
+
 static void btf_free(struct btf *btf)
 {
+	btf_free_kfunc_set_tab(btf->kfunc_set_tab);
 	kvfree(btf->types);
 	kvfree(btf->resolved_sizes);
 	kvfree(btf->resolved_ids);
@@ -4675,6 +4718,223 @@ static int btf_translate_to_vmlinux(struct bpf_verifier_log *log,
 BTF_ID_LIST(bpf_ctx_convert_btf_id)
 BTF_ID(struct, bpf_ctx_convert)
 
+struct btf_parse_kfunc_data {
+	struct btf *btf;
+	struct bpf_verifier_log *log;
+};
+
+static int btf_populate_kfunc_sets(struct btf *btf,
+				   struct bpf_verifier_log *log,
+				   enum btf_kfunc_hook hook,
+				   enum btf_kfunc_type type,
+				   struct btf_id_set *add_set)
+{
+	struct btf_id_set *set, *tmp_set;
+	struct btf_kfunc_set_tab *tab;
+	u32 set_cnt;
+	int ret;
+
+	if (WARN_ON_ONCE(hook >= _BTF_KFUNC_HOOK_MAX || type >= _BTF_KFUNC_TYPE_MAX))
+		return -EINVAL;
+	if (!add_set->cnt)
+		return 0;
+
+	tab = btf->kfunc_set_tab;
+	if (!tab) {
+		tab = kzalloc(sizeof(*tab), GFP_KERNEL | __GFP_NOWARN);
+		if (!tab)
+			return -ENOMEM;
+		btf->kfunc_set_tab = tab;
+	}
+
+	set = tab->sets[hook][type];
+	set_cnt = set ? set->cnt : 0;
+
+	if (set_cnt > U32_MAX - add_set->cnt) {
+		ret = -EOVERFLOW;
+		goto end;
+	}
+
+	if (set_cnt + add_set->cnt > BTF_KFUNC_SET_MAX_CNT) {
+		bpf_log(log, "max kfunc (%d) for hook '%s' type '%s' exceeded\n",
+			BTF_KFUNC_SET_MAX_CNT, kfunc_hook_str[hook], kfunc_type_str[type]);
+		ret = -E2BIG;
+		goto end;
+	}
+
+	/* Grow set */
+	tmp_set = krealloc(set, offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
+			   GFP_KERNEL | __GFP_NOWARN);
+	if (!tmp_set) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	/* For newly allocated set, initialize set->cnt to 0 */
+	if (!set)
+		tmp_set->cnt = 0;
+
+	tab->sets[hook][type] = tmp_set;
+	set = tmp_set;
+
+	/* Concatenate the two sets */
+	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
+	set->cnt += add_set->cnt;
+
+	return 0;
+end:
+	btf_free_kfunc_set_tab(tab);
+	btf->kfunc_set_tab = NULL;
+	return ret;
+}
+
+static int btf_kfunc_ids_cmp(const void *a, const void *b)
+{
+	const u32 *id1 = a;
+	const u32 *id2 = b;
+
+	if (*id1 < *id2)
+		return -1;
+	if (*id1 > *id2)
+		return 1;
+	return 0;
+}
+
+static int btf_parse_kfunc_sets_cb(void *data, const char *symbol_name,
+				   struct module *mod,
+				   unsigned long symbol_value)
+{
+	int pfx_size = sizeof(BTF_KFUNC_SET_PREFIX) - 1;
+	struct btf_id_set *set = (void *)symbol_value;
+	struct btf_parse_kfunc_data *bdata = data;
+	const char *orig_name = symbol_name;
+	int i, hook, type;
+
+	BUILD_BUG_ON(ARRAY_SIZE(kfunc_hook_str) != _BTF_KFUNC_HOOK_MAX);
+	BUILD_BUG_ON(ARRAY_SIZE(kfunc_type_str) != _BTF_KFUNC_TYPE_MAX);
+
+	if (strncmp(symbol_name, BTF_KFUNC_SET_PREFIX, pfx_size))
+		return 0;
+
+	/* Identify hook */
+	symbol_name += pfx_size;
+	if (!*symbol_name) {
+		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
+		return -EINVAL;
+	}
+	for (i = 0; i < ARRAY_SIZE(kfunc_hook_str); i++) {
+		pfx_size = strlen(kfunc_hook_str[i]);
+		if (strncmp(symbol_name, kfunc_hook_str[i], pfx_size))
+			continue;
+		break;
+	}
+	if (i == ARRAY_SIZE(kfunc_hook_str)) {
+		bpf_log(bdata->log, "invalid hook '%s' for kfunc_btf_id_set %s\n", symbol_name,
+			orig_name);
+		return -EINVAL;
+	}
+	hook = i;
+
+	/* Identify type */
+	symbol_name += pfx_size;
+	if (!*symbol_name) {
+		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
+		return -EINVAL;
+	}
+	for (i = 0; i < ARRAY_SIZE(kfunc_type_str); i++) {
+		pfx_size = strlen(kfunc_type_str[i]);
+		if (strncmp(symbol_name, kfunc_type_str[i], pfx_size))
+			continue;
+		break;
+	}
+	if (i == ARRAY_SIZE(kfunc_type_str)) {
+		bpf_log(bdata->log, "invalid type '%s' for kfunc_btf_id_set %s\n", symbol_name,
+			orig_name);
+		return -EINVAL;
+	}
+	type = i;
+
+	return btf_populate_kfunc_sets(bdata->btf, bdata->log, hook, type, set);
+}
+
+static int btf_parse_kfunc_sets(struct btf *btf, struct module *mod,
+				struct bpf_verifier_log *log)
+{
+	struct btf_parse_kfunc_data data = { .btf = btf, .log = log, };
+	struct btf_kfunc_set_tab *tab;
+	int hook, type, ret;
+
+	if (!btf_is_kernel(btf))
+		return -EINVAL;
+	if (WARN_ON_ONCE(btf_is_module(btf) && !mod)) {
+		bpf_log(log, "btf internal error: no module for module BTF %s\n", btf->name);
+		return -EFAULT;
+	}
+	if (mod)
+		ret = module_kallsyms_on_each_symbol(mod, btf_parse_kfunc_sets_cb, &data);
+	else
+		ret = kallsyms_on_each_symbol(btf_parse_kfunc_sets_cb, &data);
+
+	tab = btf->kfunc_set_tab;
+	if (!ret && tab) {
+		/* Sort all populated sets */
+		for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
+			for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++) {
+				struct btf_id_set *set = tab->sets[hook][type];
+
+				/* Not all sets may be populated */
+				if (!set)
+					continue;
+				sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_kfunc_ids_cmp,
+				     NULL);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static bool __btf_kfunc_id_set_contains(const struct btf *btf,
+					enum btf_kfunc_hook hook,
+					enum btf_kfunc_type type,
+					u32 kfunc_btf_id)
+{
+	struct btf_id_set *set;
+
+	if (WARN_ON_ONCE(hook >= _BTF_KFUNC_HOOK_MAX || type >= _BTF_KFUNC_TYPE_MAX))
+		return false;
+	if (!btf->kfunc_set_tab)
+		return false;
+	set = btf->kfunc_set_tab->sets[hook][type];
+	if (!set)
+		return false;
+	return btf_id_set_contains(set, kfunc_btf_id);
+}
+
+bool btf_kfunc_id_set_contains(const struct btf *btf,
+			       enum bpf_prog_type prog_type,
+			       enum btf_kfunc_type type,
+			       u32 kfunc_btf_id)
+{
+	enum btf_kfunc_hook hook;
+
+	switch (prog_type) {
+	case BPF_PROG_TYPE_XDP:
+		hook = BTF_KFUNC_HOOK_XDP;
+		break;
+	case BPF_PROG_TYPE_SCHED_CLS:
+		hook = BTF_KFUNC_HOOK_TC;
+		break;
+	case BPF_PROG_TYPE_STRUCT_OPS:
+		hook = BTF_KFUNC_HOOK_STRUCT_OPS;
+		break;
+	default:
+		return false;
+	}
+
+	return __btf_kfunc_id_set_contains(btf, hook, type, kfunc_btf_id);
+}
+
 struct btf *btf_parse_vmlinux(void)
 {
 	struct btf_verifier_env *env = NULL;
@@ -4725,6 +4985,10 @@ struct btf *btf_parse_vmlinux(void)
 
 	bpf_struct_ops_init(btf, log);
 
+	err = btf_parse_kfunc_sets(btf, NULL, log);
+	if (err < 0)
+		goto errout;
+
 	refcount_set(&btf->refcnt, 1);
 
 	err = btf_alloc_id(btf);
@@ -4737,6 +5001,7 @@ struct btf *btf_parse_vmlinux(void)
 errout:
 	btf_verifier_env_free(env);
 	if (btf) {
+		btf_free_kfunc_set_tab(btf->kfunc_set_tab);
 		kvfree(btf->types);
 		kfree(btf);
 	}
@@ -4745,7 +5010,8 @@ struct btf *btf_parse_vmlinux(void)
 
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 
-static struct btf *btf_parse_module(const char *module_name, const void *data, unsigned int data_size)
+static struct btf *btf_parse_module(struct module *mod, const char *module_name,
+				    const void *data, unsigned int data_size)
 {
 	struct btf_verifier_env *env = NULL;
 	struct bpf_verifier_log *log;
@@ -4800,6 +5066,10 @@ static struct btf *btf_parse_module(const char *module_name, const void *data, u
 	if (err)
 		goto errout;
 
+	err = btf_parse_kfunc_sets(btf, mod, log);
+	if (err)
+		goto errout;
+
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
 	return btf;
@@ -4807,6 +5077,7 @@ static struct btf *btf_parse_module(const char *module_name, const void *data, u
 errout:
 	btf_verifier_env_free(env);
 	if (btf) {
+		btf_free_kfunc_set_tab(btf->kfunc_set_tab);
 		kvfree(btf->data);
 		kvfree(btf->types);
 		kfree(btf);
@@ -6243,7 +6514,7 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			err = -ENOMEM;
 			goto out;
 		}
-		btf = btf_parse_module(mod->name, mod->btf_data, mod->btf_data_size);
+		btf = btf_parse_module(mod, mod->name, mod->btf_data, mod->btf_data_size);
 		if (IS_ERR(btf)) {
 			pr_warn("failed to validate module [%s] BTF: %ld\n",
 				mod->name, PTR_ERR(btf));
-- 
2.34.1

