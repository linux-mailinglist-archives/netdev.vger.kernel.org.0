Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0671D0568
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgEMDTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725898AbgEMDTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:19:38 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6F3C061A0C;
        Tue, 12 May 2020 20:19:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w65so7366623pfc.12;
        Tue, 12 May 2020 20:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vQnntyTfAW5ou6Kce5kj2/EfQWBGCPkhgP4HgV1Jlpw=;
        b=V87SjueNnBp6fRcKQZz5W/ICThnv1xQhA2M0ol7GW1w7s745cYTkEJnP/Wh5EP15cL
         oS9qnADoxe8M4tQTvlVsbTy/U8Gj2JpZWQkjcoZ+V1idH7OfwPxV9bmrTei9wt0rXu9y
         BDPKnWzULOtPapoAC8RLWN58KTFBQewMPqwOBBBkUC4plbNEfDjKa3uZh8DwsTwmL/mS
         fdqB3v3+i8y8YQNdei9l1Oo5RA4go0FWj43fgPiN5RAmAzdaX3RDxPKAit1zo8gey9hW
         MlDmV6vv71I3Y76jimLw6R6nZVAj4FETO9i2aqDxecG5HRYC4IY/D+GNO0boNlfIS+yi
         tPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vQnntyTfAW5ou6Kce5kj2/EfQWBGCPkhgP4HgV1Jlpw=;
        b=JSDcoE06PM5q8sZLhqCv2DnvJf/li3W5I/GjoTYw0EwVNXEgsmnujKqi33sPeAvwMv
         nmXZ/+li7yey3G+0QCEpGImUtjX8KeoNPqiqHMOTYNPnCDdRSqXGgYPBeYrpvPj+4HCk
         HXTzpeARa6f8eZdVd1RS/Uttl+rPN17IjJFZBFmAJgnlUmOMnjA0p/z55T2Lstgvcd8J
         BwvNUMmUEUUzy9lPt5dm20GgFQ9oZBP6AZob052J8ge8NLQQt9bq3mIayp7QSuhi2sYr
         PMh1G8gMVDIV2NLmd16dMPq0jnAGJqzsGKInqtG7LT5V4dEu+9PLwtJbB8QzkpKbWUbt
         LymA==
X-Gm-Message-State: AGi0PuZ0REsUNa7fb9EBSENxsq3AXzff556+ETRgWGnKeusVzHo/9twY
        kW9cBL+RLNIyrSO5YRONu20=
X-Google-Smtp-Source: APiQypLvjn527Dg4zEP4g+XIykwz5/4HKP8di1s+cGPYyZRNYDsKVb/TyhTqsPAZ0hgQocsAARJPWQ==
X-Received: by 2002:a63:d24b:: with SMTP id t11mr21557982pgi.312.1589339977936;
        Tue, 12 May 2020 20:19:37 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.1])
        by smtp.gmail.com with ESMTPSA id f70sm13206415pfa.17.2020.05.12.20.19.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 20:19:37 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v6 bpf-next 2/3] bpf: implement CAP_BPF
Date:   Tue, 12 May 2020 20:19:29 -0700
Message-Id: <20200513031930.86895-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Implement permissions as stated in uapi/linux/capability.h
In order to do that the verifier allow_ptr_leaks flag is split
into four flags and they are set as:
  env->allow_ptr_leaks = bpf_allow_ptr_leaks();
  env->bypass_spec_v1 = bpf_bypass_spec_v1();
  env->bypass_spec_v4 = bpf_bypass_spec_v4();
  env->bpf_capable = bpf_capable();

The first three currently equivalent to perfmon_capable(), since leaking kernel
pointers and reading kernel memory via side channel attacks is roughly
equivalent to reading kernel memory with cap_perfmon.

'bpf_capable' enables bounded loops, precision tracking, bpf to bpf calls and
other verifier features. 'allow_ptr_leaks' enable ptr leaks, ptr conversions,
subtraction of pointers. 'bypass_spec_v1' disables speculative analysis in the
verifier, run time mitigations in bpf array, and enables indirect variable
access in bpf programs. 'bypass_spec_v4' disables emission of sanitation code
by the verifier.

That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN
will have speculative checks done by the verifier and other spectre mitigation
applied. Such networking BPF program will not be able to leak kernel pointers
and will not be able to access arbitrary kernel memory.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 drivers/media/rc/bpf-lirc.c   |  2 +-
 include/linux/bpf.h           | 18 +++++++-
 include/linux/bpf_verifier.h  |  3 ++
 kernel/bpf/arraymap.c         | 10 ++--
 kernel/bpf/bpf_struct_ops.c   |  2 +-
 kernel/bpf/core.c             |  2 +-
 kernel/bpf/cpumap.c           |  2 +-
 kernel/bpf/hashtab.c          |  4 +-
 kernel/bpf/helpers.c          |  4 +-
 kernel/bpf/lpm_trie.c         |  2 +-
 kernel/bpf/map_in_map.c       |  2 +-
 kernel/bpf/queue_stack_maps.c |  2 +-
 kernel/bpf/reuseport_array.c  |  2 +-
 kernel/bpf/stackmap.c         |  2 +-
 kernel/bpf/syscall.c          | 87 ++++++++++++++++++++++++++---------
 kernel/bpf/verifier.c         | 37 ++++++++-------
 kernel/trace/bpf_trace.c      |  3 ++
 net/core/bpf_sk_storage.c     |  4 +-
 net/core/filter.c             |  4 +-
 19 files changed, 132 insertions(+), 60 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 069c42f22a8c..5bb144435c16 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -110,7 +110,7 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_prandom_u32:
 		return &bpf_get_prandom_u32_proto;
 	case BPF_FUNC_trace_printk:
-		if (capable(CAP_SYS_ADMIN))
+		if (perfmon_capable())
 			return bpf_get_trace_printk_proto();
 		/* fall through */
 	default:
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cf4b6e44f2bc..7318b11b0298 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -19,6 +19,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
+#include <linux/capability.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -119,7 +120,7 @@ struct bpf_map {
 	struct bpf_map_memory memory;
 	char name[BPF_OBJ_NAME_LEN];
 	u32 btf_vmlinux_value_type_id;
-	bool unpriv_array;
+	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 22 bytes hole */
 
@@ -1088,6 +1089,21 @@ struct bpf_map *bpf_map_get_curr_or_next(u32 *id);
 
 extern int sysctl_unprivileged_bpf_disabled;
 
+static inline bool bpf_allow_ptr_leaks(void)
+{
+	return perfmon_capable();
+}
+
+static inline bool bpf_bypass_spec_v1(void)
+{
+	return perfmon_capable();
+}
+
+static inline bool bpf_bypass_spec_v4(void)
+{
+	return perfmon_capable();
+}
+
 int bpf_map_new_fd(struct bpf_map *map, int flags);
 int bpf_prog_new_fd(struct bpf_prog *prog);
 
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6abd5a778fcd..ea833087e853 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -375,6 +375,9 @@ struct bpf_verifier_env {
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
 	bool allow_ptr_leaks;
+	bool bpf_capable;
+	bool bypass_spec_v1;
+	bool bypass_spec_v4;
 	bool seen_direct_write;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
 	const struct bpf_line_info *prev_linfo;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..1d5bb0d983b2 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
 	int ret, numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
-	bool unpriv = !capable(CAP_SYS_ADMIN);
+	bool bypass_spec_v1 = bpf_bypass_spec_v1();
 	u64 cost, array_size, mask64;
 	struct bpf_map_memory mem;
 	struct bpf_array *array;
@@ -95,7 +95,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	mask64 -= 1;
 
 	index_mask = mask64;
-	if (unpriv) {
+	if (!bypass_spec_v1) {
 		/* round up array size to nearest power of 2,
 		 * since cpu will speculate within index_mask limits
 		 */
@@ -149,7 +149,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-ENOMEM);
 	}
 	array->index_mask = index_mask;
-	array->map.unpriv_array = unpriv;
+	array->map.bypass_spec_v1 = bypass_spec_v1;
 
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&array->map, attr);
@@ -219,7 +219,7 @@ static u32 array_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
 
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
-	if (map->unpriv_array) {
+	if (!map->bypass_spec_v1) {
 		*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 4);
 		*insn++ = BPF_ALU32_IMM(BPF_AND, ret, array->index_mask);
 	} else {
@@ -1053,7 +1053,7 @@ static u32 array_of_map_gen_lookup(struct bpf_map *map,
 
 	*insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
 	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
-	if (map->unpriv_array) {
+	if (!map->bypass_spec_v1) {
 		*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 6);
 		*insn++ = BPF_ALU32_IMM(BPF_AND, ret, array->index_mask);
 	} else {
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 26cb51f2db72..c6b0decaa46a 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -557,7 +557,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 	struct bpf_map *map;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	st_ops = bpf_struct_ops_find_value(attr->btf_vmlinux_value_type_id);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 6aa11de67315..c40ff4cf9880 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 	if (!bpf_prog_kallsyms_candidate(fp) ||
-	    !capable(CAP_SYS_ADMIN))
+	    !bpf_capable())
 		return;
 
 	bpf_prog_ksym_set_addr(fp);
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 3fe0b006d2d2..be8fdceefe55 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -85,7 +85,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	u64 cost;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d541c8486c95..b4b288a3c3c9 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -359,9 +359,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
 		     offsetof(struct htab_elem, hash_node.pprev));
 
-	if (lru && !capable(CAP_SYS_ADMIN))
+	if (lru && !bpf_capable())
 		/* LRU implementation is much complicated than other
-		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
+		 * maps.  Hence, limit to CAP_BPF.
 		 */
 		return -EPERM;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5c0290e0696e..886949fdcece 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -633,7 +633,7 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		break;
 	}
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return NULL;
 
 	switch (func_id) {
@@ -642,6 +642,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
 	case BPF_FUNC_trace_printk:
+		if (!perfmon_capable())
+			return NULL;
 		return bpf_get_trace_printk_proto();
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 65c236cf341e..c8cc4e4cf98d 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -543,7 +543,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	u64 cost = sizeof(*trie), cost_per_node;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index b3c48d1533cb..17738c93bec8 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -60,7 +60,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 	/* Misc members not needed in bpf_map_meta_equal() check. */
 	inner_map_meta->ops = inner_map->ops;
 	if (inner_map->ops == &array_map_ops) {
-		inner_map_meta->unpriv_array = inner_map->unpriv_array;
+		inner_map_meta->bypass_spec_v1 = inner_map->bypass_spec_v1;
 		container_of(inner_map_meta, struct bpf_array, map)->index_mask =
 		     container_of(inner_map, struct bpf_array, map)->index_mask;
 	}
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index 30e1373fd437..05c8e043b9d2 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -45,7 +45,7 @@ static bool queue_stack_map_is_full(struct bpf_queue_stack *qs)
 /* Called from syscall */
 static int queue_stack_map_alloc_check(union bpf_attr *attr)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return -EPERM;
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 01badd3eda7a..21cde24386db 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -154,7 +154,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 	struct bpf_map_memory mem;
 	u64 array_size;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	array_size = sizeof(*array);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index db76339fe358..7b8381ce40a0 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -93,7 +93,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 	u64 cost, n_buckets;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	if (attr->map_flags & ~STACK_CREATE_FLAG_MASK)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index de2a75500233..422414cc7010 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1534,7 +1534,7 @@ static int map_freeze(const union bpf_attr *attr)
 		err = -EBUSY;
 		goto err_put;
 	}
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!bpf_capable()) {
 		err = -EPERM;
 		goto err_put;
 	}
@@ -2009,6 +2009,53 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 	}
 }
 
+static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
+{
+	switch (prog_type) {
+	case BPF_PROG_TYPE_SCHED_CLS:
+	case BPF_PROG_TYPE_SCHED_ACT:
+	case BPF_PROG_TYPE_XDP:
+	case BPF_PROG_TYPE_LWT_IN:
+	case BPF_PROG_TYPE_LWT_OUT:
+	case BPF_PROG_TYPE_LWT_XMIT:
+	case BPF_PROG_TYPE_LWT_SEG6LOCAL:
+	case BPF_PROG_TYPE_SK_SKB:
+	case BPF_PROG_TYPE_SK_MSG:
+	case BPF_PROG_TYPE_SK_REUSEPORT:
+	case BPF_PROG_TYPE_LIRC_MODE2:
+	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_CGROUP_DEVICE:
+	case BPF_PROG_TYPE_CGROUP_SOCK:
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_EXT: /* extends any prog */
+		return true;
+	case BPF_PROG_TYPE_CGROUP_SKB: /* always unpriv */
+	default:
+		return false;
+	}
+}
+
+static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
+{
+	switch (prog_type) {
+	case BPF_PROG_TYPE_KPROBE:
+	case BPF_PROG_TYPE_TRACEPOINT:
+	case BPF_PROG_TYPE_PERF_EVENT:
+	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+	case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
+	case BPF_PROG_TYPE_TRACING:
+	case BPF_PROG_TYPE_LSM:
+	case BPF_PROG_TYPE_STRUCT_OPS: /* has access to struct sock */
+	case BPF_PROG_TYPE_EXT: /* extends any prog */
+		return true;
+	default:
+		return false;
+	}
+}
+
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
 
@@ -2031,7 +2078,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
 	    (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !bpf_capable())
 		return -EPERM;
 
 	/* copy eBPF program license from user space */
@@ -2044,11 +2091,16 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	is_gpl = license_is_gpl_compatible(license);
 
 	if (attr->insn_cnt == 0 ||
-	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
+	    attr->insn_cnt > (bpf_capable() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
+	    !bpf_capable())
+		return -EPERM;
+
+	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN))
+		return -EPERM;
+	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
@@ -2682,6 +2734,11 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 		return attach_type == prog->expected_attach_type ? 0 : -EINVAL;
 	case BPF_PROG_TYPE_CGROUP_SKB:
+		if (!capable(CAP_NET_ADMIN))
+			/* cg-skb progs can be loaded by unpriv user.
+			 * check permissions at attach time.
+			 */
+			return -EPERM;
 		return prog->enforce_expected_attach_type &&
 			prog->expected_attach_type != attach_type ?
 			-EINVAL : 0;
@@ -2747,9 +2804,6 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	struct bpf_prog *prog;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_PROG_ATTACH))
 		return -EINVAL;
 
@@ -2804,9 +2858,6 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_PROG_DETACH))
 		return -EINVAL;
 
@@ -2819,6 +2870,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_LIRC_MODE2:
 		return lirc_prog_detach(attr);
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
 		return skb_flow_dissector_bpf_prog_detach(attr);
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
@@ -2882,8 +2935,6 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
 	struct bpf_prog *prog;
 	int ret = -ENOTSUPP;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
 		return -EINVAL;
 
@@ -3184,7 +3235,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	info.run_time_ns = stats.nsecs;
 	info.run_cnt = stats.cnt;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
 		info.xlated_prog_len = 0;
 		info.nr_jited_ksyms = 0;
@@ -3543,7 +3594,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return -EPERM;
 
 	return btf_new_fd(attr);
@@ -3766,9 +3817,6 @@ static int link_create(union bpf_attr *attr)
 	struct bpf_prog *prog;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_LINK_CREATE))
 		return -EINVAL;
 
@@ -3817,9 +3865,6 @@ static int link_update(union bpf_attr *attr)
 	u32 flags;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_LINK_UPDATE))
 		return -EINVAL;
 
@@ -3988,7 +4033,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	union bpf_attr attr;
 	int err;
 
-	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
+	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
 		return -EPERM;
 
 	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2a1826c76bb6..2c34c44974d1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1295,7 +1295,7 @@ static void __mark_reg_unknown(const struct bpf_verifier_env *env,
 	reg->type = SCALAR_VALUE;
 	reg->var_off = tnum_unknown;
 	reg->frameno = 0;
-	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks;
+	reg->precise = env->subprog_cnt > 1 || !env->bpf_capable;
 	__mark_reg_unbounded(reg);
 }
 
@@ -1427,8 +1427,9 @@ static int check_subprogs(struct bpf_verifier_env *env)
 			continue;
 		if (insn[i].src_reg != BPF_PSEUDO_CALL)
 			continue;
-		if (!env->allow_ptr_leaks) {
-			verbose(env, "function calls to other bpf functions are allowed for root only\n");
+		if (!env->bpf_capable) {
+			verbose(env,
+				"function calls to other bpf functions are allowed for CAP_BPF and CAP_SYS_ADMIN\n");
 			return -EPERM;
 		}
 		ret = add_subprog(env, i + insn[i].imm + 1);
@@ -1962,8 +1963,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	bool new_marks = false;
 	int i, err;
 
-	if (!env->allow_ptr_leaks)
-		/* backtracking is root only for now */
+	if (!env->bpf_capable)
 		return 0;
 
 	func = st->frame[st->curframe];
@@ -2211,7 +2211,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 		reg = &cur->regs[value_regno];
 
 	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
-	    !register_is_null(reg) && env->allow_ptr_leaks) {
+	    !register_is_null(reg) && env->bpf_capable) {
 		if (dst_reg != BPF_REG_FP) {
 			/* The backtracking logic can only recognize explicit
 			 * stack slot address like [fp - 8]. Other spill of
@@ -2237,7 +2237,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
-		if (!env->allow_ptr_leaks) {
+		if (!env->bypass_spec_v4) {
 			bool sanitize = false;
 
 			if (state->stack[spi].slot_type[0] == STACK_SPILL &&
@@ -3432,7 +3432,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		 * Spectre masking for stack ALU.
 		 * See also retrieve_ptr_limit().
 		 */
-		if (!env->allow_ptr_leaks) {
+		if (!env->bypass_spec_v1) {
 			char tn_buf[48];
 
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
@@ -4435,10 +4435,10 @@ record_func_map(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
 
 	if (!BPF_MAP_PTR(aux->map_ptr_state))
 		bpf_map_ptr_store(aux, meta->map_ptr,
-				  meta->map_ptr->unpriv_array);
+				  !meta->map_ptr->bypass_spec_v1);
 	else if (BPF_MAP_PTR(aux->map_ptr_state) != meta->map_ptr)
 		bpf_map_ptr_store(aux, BPF_MAP_PTR_POISON,
-				  meta->map_ptr->unpriv_array);
+				  !meta->map_ptr->bypass_spec_v1);
 	return 0;
 }
 
@@ -4807,7 +4807,7 @@ static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 static bool can_skip_alu_sanitation(const struct bpf_verifier_env *env,
 				    const struct bpf_insn *insn)
 {
-	return env->allow_ptr_leaks || BPF_SRC(insn->code) == BPF_K;
+	return env->bypass_spec_v1 || BPF_SRC(insn->code) == BPF_K;
 }
 
 static int update_alu_sanitation_state(struct bpf_insn_aux_data *aux,
@@ -5117,7 +5117,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	/* For unprivileged we require that resulting offset must be in bounds
 	 * in order to be able to sanitize access later on.
 	 */
-	if (!env->allow_ptr_leaks) {
+	if (!env->bypass_spec_v1) {
 		if (dst_reg->type == PTR_TO_MAP_VALUE &&
 		    check_map_access(env, dst, dst_reg->off, 1, false)) {
 			verbose(env, "R%d pointer arithmetic of map value goes out of range, "
@@ -7244,7 +7244,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
 		insn_stack[env->cfg.cur_stack++] = w;
 		return 1;
 	} else if ((insn_state[w] & 0xF0) == DISCOVERED) {
-		if (loop_ok && env->allow_ptr_leaks)
+		if (loop_ok && env->bpf_capable)
 			return 0;
 		verbose_linfo(env, t, "%d: ", t);
 		verbose_linfo(env, w, "%d: ", w);
@@ -8353,7 +8353,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	if (env->max_states_per_insn < states_cnt)
 		env->max_states_per_insn = states_cnt;
 
-	if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
+	if (!env->bpf_capable && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
 		return push_jmp_history(env, cur);
 
 	if (!add_new_state)
@@ -10014,7 +10014,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
-			if (env->allow_ptr_leaks && !expect_blinding &&
+			if (env->bpf_capable && !expect_blinding &&
 			    prog->jit_requested &&
 			    !bpf_map_key_poisoned(aux) &&
 			    !bpf_map_ptr_poisoned(aux) &&
@@ -10759,7 +10759,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
-	is_priv = capable(CAP_SYS_ADMIN);
+	is_priv = bpf_capable();
 
 	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
 		mutex_lock(&bpf_verifier_lock);
@@ -10800,7 +10800,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (attr->prog_flags & BPF_F_ANY_ALIGNMENT)
 		env->strict_alignment = false;
 
-	env->allow_ptr_leaks = is_priv;
+	env->allow_ptr_leaks = bpf_allow_ptr_leaks();
+	env->bypass_spec_v1 = bpf_bypass_spec_v1();
+	env->bypass_spec_v4 = bpf_bypass_spec_v4();
+	env->bpf_capable = bpf_capable();
 
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d961428fb5b6..9a84d7fb4869 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -315,6 +315,9 @@ static const struct bpf_func_proto bpf_probe_write_user_proto = {
 
 static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 {
+	if (!capable(CAP_SYS_ADMIN))
+		return NULL;
+
 	pr_warn_ratelimited("%s[%d] is installing a program with bpf_probe_write_user helper that may corrupt user memory!",
 			    current->comm, task_pid_nr(current));
 
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 756b63b6f7b3..d2c4d16dadba 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -625,7 +625,7 @@ static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 	    !attr->btf_key_type_id || !attr->btf_value_type_id)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return -EPERM;
 
 	if (attr->value_size > MAX_VALUE_SIZE)
@@ -978,7 +978,7 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_stgs)
 	/* bpf_sk_storage_map is currently limited to CAP_SYS_ADMIN as
 	 * the map_alloc_check() side also does.
 	 */
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
 
 	nla_for_each_nested(nla, nla_stgs, rem) {
diff --git a/net/core/filter.c b/net/core/filter.c
index da0634979f53..c3d33908efc6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6624,7 +6624,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		return false;
 	case bpf_ctx_range(struct __sk_buff, data):
 	case bpf_ctx_range(struct __sk_buff, data_end):
-		if (!capable(CAP_SYS_ADMIN))
+		if (!bpf_capable())
 			return false;
 		break;
 	}
@@ -6636,7 +6636,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
 			break;
 		case bpf_ctx_range(struct __sk_buff, tstamp):
-			if (!capable(CAP_SYS_ADMIN))
+			if (!bpf_capable())
 				return false;
 			break;
 		default:
-- 
2.23.0

