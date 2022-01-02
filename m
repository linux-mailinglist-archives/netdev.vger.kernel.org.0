Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BC1482BF4
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiABQVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiABQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:28 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC9EC061761;
        Sun,  2 Jan 2022 08:21:28 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 200so28374171pgg.3;
        Sun, 02 Jan 2022 08:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+/Zw8UM3J4/LUvMZsrifcrvpP6kwlH02zfBWvw6UGs=;
        b=eUtPiOPbiHPa7NlMIrPihgbhtcgo5aRRjHBlTE2I1u9j8N/RkcDD+Bw2OFzJAo7NIZ
         thc2fWWn+PraIoy8dVNsF3R4WaLgyMTiUFZGZbPwEq8EG50/XKGut0d4aLjPu8maWPl5
         r3do7uTJrawNxc4+NGMGrhs8+rdf/xXeNLt9dFKdGoXYVx/Le9CvfMKsC2qPm5YHl+wp
         3gTtvp8fSxV031niNB1aCqNacPxHo4LpEUyBtqENFNEvA+l7AKeUUr3XGxMmj9K162IR
         iESVnrF8se0o8HvN0cD/XbC+ekqJugpGIrIzC5KKoHwV3+YJv8Z8K5QY+E5FfOdmCYLh
         9ZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+/Zw8UM3J4/LUvMZsrifcrvpP6kwlH02zfBWvw6UGs=;
        b=nvRFImudrcp2FwjqNYEsjqjJP4Buj30ipT5n/fUXQhJJfs4Vjq/cDhB98NymSMhmfN
         80/VP1O9m9+i4AaYuX4+ByHGNFjDDVQ/p+1Tz7EQq5tXZycxmQVk0AwDniOVQtpELSuM
         X618ZmAI7H1RTK6F8dy+2sxSGZAomTxADCvGowx0RDnIVkdW/Vzg3l9KOAulivW56buj
         Ak0BL8Z/4am/PMj+HiH1+KY4medz95IrtI0zBAZeLM7j/eQ51HVm4dFkOZ8yx59hjpkE
         m47ft5hO23jfQgVds6rMxSPCQjVubQ6lE7SilMzRn8yKJvnsGpEx8ipPz3kA2dV67cZJ
         /5rA==
X-Gm-Message-State: AOAM532xri2aDoSUf9U34t+NPh4r8NtGg+oDIoLWIz/p9n4smBJhoLOq
        d8IKNfCb8zfHMVaHrw4jfTBY6BmpXnM=
X-Google-Smtp-Source: ABdhPJwHVMlid4fnFUUnvi7cRIlY4FvLpiNj52M2uNjx8FIUN50fPdcZgvfQXgqI6sIicWuwtUc1Zw==
X-Received: by 2002:a63:89c8:: with SMTP id v191mr38020989pgd.402.1641140487188;
        Sun, 02 Jan 2022 08:21:27 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id 24sm12550937pgv.60.2022.01.02.08.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:26 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 03/11] bpf: Populate kfunc BTF ID sets in struct btf
Date:   Sun,  2 Jan 2022 21:51:07 +0530
Message-Id: <20220102162115.1506833-4-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15704; h=from:subject; bh=g++erK1gaswYjoFOeqPkm7BF2fjwyiwtPpnGTdqgdDE=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCJ1+edRumNfOMYFRCdEJY4PY3rsTmk0JX/1ov6 3dTjsZeJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQiQAKCRBM4MiGSL8RyvUvD/ 9m8R9GvNAboFNcxrRBXlBtW7KeEy1DV/kHOjBsAcwkUnl5CEOUQYl20NxKWWpVXU0o0ajbjWPovMoa j5ZfgJ1xUvguZbOhSAh2bh7a6k27ZH9DpLbbujGXRmoWfyERyaGD4bGJ+BDd+58Z81o3cKcuwK/50X bjGT2jhFxLOuVKmj8SqazLXSQbxZlOyvPHWGzuFYhHkvfDgsPJHWP7seGMIy+k9bhjBQMbzQWcQ2WL 9xtlH+aICyi4vFqnQrK+aSaAje7HY4syz14LBk5plrsxVmC17O6p3udGHGwMA1HdmF44YfBPdXSCO0 K3Fcbk6ZgVGaFhS7CpCYpmjQ4EeJAo8mJRs/tVjVROIM5z/9YA8iR8LFqiWqQj1YCGxt9fD3b5gFCd i+pL5f2VuzqKCNMcKqD/t6pVk5N45KBi0D62isIHr5VxYX7JjM0nFtbWtm4lhePXST/wLmsmGSCtF5 Yggh1SYR3QMtk+nHrpnsAMlenOsbvxJkPUf8GqJBKOIl8NtDcixliygV5zBNKdMKmGk21eu+gsqiHT ETao2Fa/gCDD0nt6D0NNvZw9CCRfcOBamXpPX4ljWxD0tWahAX+B4bbHJOnQvMZWejwib2IFFUqRun dXK6fhI4NiZP4QfgWPUao0e9faS0MyOGcRuBWukm6pwtkMmKOjWmKW/NY14w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares the kernel to support putting all kinds of kfunc BTF
ID sets in the struct btf itself. The various kernel subsystems will
make register_btf_kfunc_id_set call in the initcalls (for built-in code
and modules).

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

Note that module code can only do single register_btf_kfunc_id_set call
per hook. This is why sort_set is only true for in-kernel vmlinux sets,
because there might be multiple sets for the same hook and type that
must be concatenated, hence sorting them is required to ensure bsearch
in btf_id_set_contains continues to work correctly.

Next commit will update the kernel users to make use of this
infrastructure.

Finally, add __maybe_unused annotation for BTF ID macros for the
!CONFIG_DEBUG_INFO_BTF case, so that they don't produce warnings during
build time.

The previous patch is also needed to provide synchronization against
initialization for module BTF's kfunc_set_tab introduced here, as
described below:

  The kfunc_set_tab pointer in struct btf is write-once (if we consider
  the registration phase (comprised of multiple register_btf_kfunc_id_set
  calls) as a single operation). In this sense, once it has been fully
  prepared, it isn't modified, only used for lookup (from the verifier
  context).

  For btf_vmlinux, it is initialized fully during the do_initcalls phase,
  which happens fairly early in the boot process, before any processes are
  present. This also eliminates the possibility of bpf_check being called
  at that point, thus relieving us of ensuring any synchronization between
  the registration and lookup function (btf_kfunc_id_set_contains).

  However, the case for module BTF is a bit tricky. The BTF is parsed,
  prepared, and published from the MODULE_STATE_COMING notifier callback.
  After this, the module initcalls are invoked, where our registration
  function will be called to populate the kfunc_set_tab for module BTF.

  At this point, BTF may be available to userspace while its corresponding
  module is still intializing. A BTF fd can then be passed to verifier
  using bpf syscall (e.g. for kfunc call insn).

  Hence, there is a race window where verifier may concurrently try to
  lookup the kfunc_set_tab. To prevent this race, we must ensure the
  operations are serialized, or waiting for the __init functions to
  complete.

  In the earlier registration API, this race was alleviated as verifier
  bpf_check_mod_kfunc_call didn't find the kfunc BTF ID until it was added
  by the registration function (called usually at the end of module __init
  function after all module resources have been initialized). If the
  verifier made the check_kfunc_call before kfunc BTF ID was added to the
  list, it would fail verification (saying call isn't allowed). The
  access to list was protected using a mutex.

  Now, it would still fail verification, but for a different reason
  (returning ENXIO due to the failed btf_try_get_module call in
  add_kfunc_call), because if the __init call is in progress the module
  will be in the middle of MODULE_STATE_COMING -> MODULE_STATE_LIVE
  transition, and the try_module_get_live call inside btf_try_get_module
  will fail.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h     |  46 ++++++++
 include/linux/btf_ids.h |  13 +--
 kernel/bpf/btf.c        | 228 +++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/verifier.c   |   1 +
 4 files changed, 280 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 0c74348cbc9d..01c8f8ad30c6 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -12,11 +12,40 @@
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
 
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
 struct btf;
 struct btf_member;
 struct btf_type;
 union bpf_attr;
 struct btf_show;
+struct btf_id_set;
+
+struct btf_kfunc_id_set {
+	struct module *owner;
+	union {
+		struct {
+			struct btf_id_set *check_set;
+			struct btf_id_set *acquire_set;
+			struct btf_id_set *release_set;
+			struct btf_id_set *ret_null_set;
+		};
+		struct btf_id_set *sets[_BTF_KFUNC_TYPE_MAX];
+	};
+};
 
 extern const struct file_operations btf_fops;
 
@@ -307,6 +336,11 @@ const struct btf_type *btf_type_by_id(const struct btf *btf, u32 type_id);
 const char *btf_name_by_offset(const struct btf *btf, u32 offset);
 struct btf *btf_parse_vmlinux(void);
 struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog);
+bool btf_kfunc_id_set_contains(const struct btf *btf,
+			       enum bpf_prog_type prog_type,
+			       enum btf_kfunc_type type, u32 kfunc_btf_id);
+int register_btf_kfunc_id_set(enum btf_kfunc_hook hook,
+			      const struct btf_kfunc_id_set *s);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -318,6 +352,18 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
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
+static inline int register_btf_kfunc_id_set(enum btf_kfunc_hook hook,
+					    const struct btf_kfunc_id_set *s)
+{
+	return 0;
+}
 #endif
 
 struct kfunc_btf_id_set {
diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 919c0fde1c51..bc5d9cc34e4c 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -11,6 +11,7 @@ struct btf_id_set {
 #ifdef CONFIG_DEBUG_INFO_BTF
 
 #include <linux/compiler.h> /* for __PASTE */
+#include <linux/compiler_attributes.h> /* for __maybe_unused */
 
 /*
  * Following macros help to define lists of BTF IDs placed
@@ -146,14 +147,14 @@ extern struct btf_id_set name;
 
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
 
 #endif /* CONFIG_DEBUG_INFO_BTF */
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b5b423de53ab..02c33b2ad47e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -198,6 +198,14 @@
 DEFINE_IDR(btf_idr);
 DEFINE_SPINLOCK(btf_idr_lock);
 
+enum {
+	BTF_KFUNC_SET_MAX_CNT = 32,
+};
+
+struct btf_kfunc_set_tab {
+	struct btf_id_set *sets[_BTF_KFUNC_HOOK_MAX][_BTF_KFUNC_TYPE_MAX];
+};
+
 struct btf {
 	void *data;
 	struct btf_type **types;
@@ -212,6 +220,7 @@ struct btf {
 	refcount_t refcnt;
 	u32 id;
 	struct rcu_head rcu;
+	struct btf_kfunc_set_tab *kfunc_set_tab;
 
 	/* split BTF support */
 	struct btf *base_btf;
@@ -1531,8 +1540,23 @@ static void btf_free_id(struct btf *btf)
 	spin_unlock_irqrestore(&btf_idr_lock, flags);
 }
 
+static void btf_free_kfunc_set_tab(struct btf *btf)
+{
+	struct btf_kfunc_set_tab *tab = btf->kfunc_set_tab;
+	int hook, type;
+
+	if (!tab)
+		return;
+	for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
+		for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++)
+			kfree(tab->sets[hook][type]);
+	}
+	btf->kfunc_set_tab = NULL;
+}
+
 static void btf_free(struct btf *btf)
 {
+	btf_free_kfunc_set_tab(btf);
 	kvfree(btf->types);
 	kvfree(btf->resolved_sizes);
 	kvfree(btf->resolved_ids);
@@ -6341,8 +6365,11 @@ struct module *btf_try_get_module(const struct btf *btf)
 		/* We must only consider module whose __init routine has
 		 * finished, hence use try_module_get_live.
 		 */
-		if (try_module_get_live(btf_mod->module))
+		if (try_module_get_live(btf_mod->module)) {
+			/* pairs with smp_wmb in register_btf_kfunc_id_set */
+			smp_rmb();
 			res = btf_mod->module;
+		}
 
 		break;
 	}
@@ -6352,6 +6379,36 @@ struct module *btf_try_get_module(const struct btf *btf)
 	return res;
 }
 
+/* Returns struct btf corresponding to the struct module
+ *
+ * This function can return NULL or ERR_PTR. Note that caller must
+ * release reference for struct btf iff btf_is_module is true.
+ */
+static struct btf *btf_get_module_btf(const struct module *module)
+{
+	struct btf *btf = NULL;
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+	struct btf_module *btf_mod, *tmp;
+#endif
+
+	if (!module)
+		return bpf_get_btf_vmlinux();
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+	mutex_lock(&btf_module_mutex);
+	list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+		if (btf_mod->module != module)
+			continue;
+
+		btf_get(btf_mod->btf);
+		btf = btf_mod->btf;
+		break;
+	}
+	mutex_unlock(&btf_module_mutex);
+#endif
+
+	return btf;
+}
+
 BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
 {
 	struct btf *btf;
@@ -6419,7 +6476,174 @@ BTF_ID_LIST_GLOBAL(btf_tracing_ids, MAX_BTF_TRACING_TYPE)
 BTF_TRACING_TYPE_xxx
 #undef BTF_TRACING_TYPE
 
-/* BTF ID set registration API for modules */
+/* Kernel Function (kfunc) BTF ID set registration API */
+
+static int __btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
+				    enum btf_kfunc_type type,
+				    struct btf_id_set *add_set, bool sort_set)
+{
+	struct btf_kfunc_set_tab *tab;
+	struct btf_id_set *set;
+	u32 set_cnt;
+	int ret;
+
+	if (WARN_ON_ONCE(hook >= _BTF_KFUNC_HOOK_MAX || type >= _BTF_KFUNC_TYPE_MAX)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	if (WARN_ON_ONCE(btf_is_module(btf) && sort_set)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
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
+	if (WARN_ON_ONCE(set && !sort_set)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	set_cnt = set ? set->cnt : 0;
+
+	if (set_cnt > U32_MAX - add_set->cnt) {
+		ret = -EOVERFLOW;
+		goto end;
+	}
+
+	if (set_cnt + add_set->cnt > BTF_KFUNC_SET_MAX_CNT) {
+		ret = -E2BIG;
+		goto end;
+	}
+
+	/* Grow set */
+	set = krealloc(tab->sets[hook][type], offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
+		       GFP_KERNEL | __GFP_NOWARN);
+	if (!set) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	/* For newly allocated set, initialize set->cnt to 0 */
+	if (!tab->sets[hook][type])
+		set->cnt = 0;
+	tab->sets[hook][type] = set;
+
+	/* Concatenate the two sets */
+	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
+	set->cnt += add_set->cnt;
+
+	if (sort_set)
+		sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_id_cmp_func, NULL);
+
+	return 0;
+end:
+	btf_free_kfunc_set_tab(btf);
+	return ret;
+}
+
+static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
+				  const struct btf_kfunc_id_set *kset)
+{
+	bool sort_set = !btf_is_module(btf);
+	int type, ret;
+
+	for (type = 0; type < ARRAY_SIZE(kset->sets); type++) {
+		if (!kset->sets[type])
+			continue;
+
+		ret = __btf_populate_kfunc_set(btf, hook, type, kset->sets[type], sort_set);
+		if (ret)
+			break;
+	}
+	return ret;
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
+/* Caution:
+ * Reference to the module (obtained using btf_try_get_module) corresponding to
+ * the struct btf *MUST* be held when calling this function from verifier
+ * context. This is usually true as we stash references in prog's kfunc_btf_tab;
+ * keeping the reference for the duration of the call provides the necessary
+ * protection for looking up a well-formed btf->kfunc_set_tab.
+ */
+bool btf_kfunc_id_set_contains(const struct btf *btf,
+			       enum bpf_prog_type prog_type,
+			       enum btf_kfunc_type type, u32 kfunc_btf_id)
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
+	return __btf_kfunc_id_set_contains(btf, hook, type, kfunc_btf_id);
+}
+
+/* This function must be invoked only from initcalls/module init functions */
+int register_btf_kfunc_id_set(enum btf_kfunc_hook hook,
+			      const struct btf_kfunc_id_set *kset)
+{
+	struct btf *btf;
+	int ret;
+
+	btf = btf_get_module_btf(kset->owner);
+	if (IS_ERR_OR_NULL(btf))
+		return btf ? PTR_ERR(btf) : -ENOENT;
+
+	ret = btf_populate_kfunc_set(btf, hook, kset);
+	/* Make sure all updates are visible before we go to MODULE_STATE_LIVE,
+	 * pairs with smp_rmb in btf_try_get_module (for success case).
+	 *
+	 * btf_populate_kfunc_set(...)
+	 * smp_wmb()	<-----------.
+	 * mod->state = LIVE	    |		if (mod->state == LIVE)
+	 *			    |		  atomic_inc_nz(mod)
+	 *			    `--------->	  smp_rmb()
+	 *					  btf_kfunc_id_set_contains(...)
+	 */
+	smp_wmb();
+	/* reference is only taken for module BTF */
+	if (btf_is_module(btf))
+		btf_put(btf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
 
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 133599dfe2a2..da9948fe8468 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1777,6 +1777,7 @@ static struct btf *__find_kfunc_desc_btf(struct bpf_verifier_env *env,
 
 		mod = btf_try_get_module(btf);
 		if (!mod) {
+			verbose(env, "failed to get reference for BTF's module\n");
 			btf_put(btf);
 			return ERR_PTR(-ENXIO);
 		}
-- 
2.34.1

