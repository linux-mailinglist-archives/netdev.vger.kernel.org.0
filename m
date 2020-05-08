Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A01F1CBA37
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHVxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:53:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76499C05BD43;
        Fri,  8 May 2020 14:53:48 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so1319825plt.5;
        Fri, 08 May 2020 14:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SaU8dSMBGRhJpOTdOTDCbehDrwSDEEsYx/s/19z/h40=;
        b=qGoK8+kYiWTKAskVH8MbcV8JaBr2wQS9R6pArc+hZeDDarivHUtWQpGKXpEKSJA17e
         j/VE5y+XcSOkZoN3VJbAH9FBPOUZU+j11jj3o2AwQ1zArpscBJA2/3onHG0iZ/BOnbjA
         4pYEAPP+kC3FJLgFgERnoaC1rW5ea54Y33repMsyJ3nGRzA6XFoxOolNn5x5LDNp2aaT
         ZDo2S4hTzu8wSEzyb8gbwwuv0/MFz6MdtjHyfumYxzn+8LZqs9ONNCb5gUoSPRW7T/om
         Upb4CDRZ92RMH7JLpWZ3dV4Z5omhzgRHef8+NBC/YxILK4VmE9VSfoMR6Qwjrx4TcIPZ
         eIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SaU8dSMBGRhJpOTdOTDCbehDrwSDEEsYx/s/19z/h40=;
        b=uSf732yHhdcOX2UOKbU9sktML7iu3leE7Rm1JYHau17e0AMwNPGYC57xxYbKqlexvu
         YvH5u0F0wnoK7iqZxf/g7uGUu/rNiLOBPnYUbqFHIUw9mCqlMvcBCbzZJ0R0jDScZw8f
         VxRZBuZssFMw6aNv1++USLbatG/3L2MA4OEsnG/Y4ae5rB/L6DdBheztzDreTbxr9HmY
         H0nzu+T96MXi291V8xf4gc8zgbJaQY+YDwy8Bm/vgsbx7fKrdca7Jp8SbvM7avq9od+H
         G8AjSx690q62OxE670EmKbM1LMsabez5Y4bw3ogxwt/YM57ptE8TYkbJjTrvdoeorH7F
         jtkw==
X-Gm-Message-State: AGi0PublvyOnSUkLHvgNoDtQ/0IQOEkC3EAVVUiw7AEuDPk56r3T8jJl
        HO0yc3ymn8xGvRhwtPtvUvo=
X-Google-Smtp-Source: APiQypLjLrDpmTIKkMYPGqlh+U733gnAu/ZGi+HHC0fdEcHotCxtS9CdRs/5dEh7APlLjYAoPdI4aw==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr4290484plp.184.1588974827753;
        Fri, 08 May 2020 14:53:47 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 20sm2720763pfx.116.2020.05.08.14.53.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 May 2020 14:53:46 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com
Subject: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Date:   Fri,  8 May 2020 14:53:39 -0700
Message-Id: <20200508215340.41921-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Implement permissions as stated in uapi/linux/capability.h
In order to do that the verifier allow_ptr_leaks flag is split
into allow_ptr_leaks and bpf_capable flags and they are set as:
  env->allow_ptr_leaks = perfmon_capable();
  env->bpf_capable = bpf_capable();

bpf_capable enables bounded loops, variable stack access and other verifier features.
allow_ptr_leaks enable ptr leaks, ptr conversions, subtraction of pointers, etc.
It also disables side channel mitigations.

That means that the networking BPF program loaded with CAP_BPF + CAP_NET_ADMIN will
have speculative checks done by the verifier and other spectre mitigation applied.
Such networking BPF program will not be able to leak kernel pointers.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 drivers/media/rc/bpf-lirc.c   |  2 +-
 include/linux/bpf_verifier.h  |  1 +
 kernel/bpf/arraymap.c         |  2 +-
 kernel/bpf/bpf_struct_ops.c   |  2 +-
 kernel/bpf/core.c             |  4 +-
 kernel/bpf/cpumap.c           |  2 +-
 kernel/bpf/hashtab.c          |  4 +-
 kernel/bpf/helpers.c          |  4 +-
 kernel/bpf/lpm_trie.c         |  2 +-
 kernel/bpf/queue_stack_maps.c |  2 +-
 kernel/bpf/reuseport_array.c  |  2 +-
 kernel/bpf/stackmap.c         |  2 +-
 kernel/bpf/syscall.c          | 87 ++++++++++++++++++++++++++---------
 kernel/bpf/verifier.c         | 24 +++++-----
 kernel/trace/bpf_trace.c      |  3 ++
 net/core/bpf_sk_storage.c     |  4 +-
 net/core/filter.c             |  4 +-
 17 files changed, 102 insertions(+), 49 deletions(-)

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
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 6abd5a778fcd..c32a7880fa62 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -375,6 +375,7 @@ struct bpf_verifier_env {
 	u32 used_map_cnt;		/* number of used maps */
 	u32 id_gen;			/* used to generate unique reg IDs */
 	bool allow_ptr_leaks;
+	bool bpf_capable;
 	bool seen_direct_write;
 	struct bpf_insn_aux_data *insn_aux_data; /* array of per-insn state */
 	const struct bpf_line_info *prev_linfo;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..264a9254dc39 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -77,7 +77,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
 	int ret, numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
-	bool unpriv = !capable(CAP_SYS_ADMIN);
+	bool unpriv = !bpf_capable();
 	u64 cost, array_size, mask64;
 	struct bpf_map_memory mem;
 	struct bpf_array *array;
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
index 6aa11de67315..8f421dd0c4cf 100644
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
@@ -824,7 +824,7 @@ static int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!bpf_capable()) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
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
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..24d244daceff 100644
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
index bb1ab7da6103..5b8782c29cf9 100644
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
@@ -2745,9 +2802,6 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	struct bpf_prog *prog;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_PROG_ATTACH))
 		return -EINVAL;
 
@@ -2802,9 +2856,6 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 {
 	enum bpf_prog_type ptype;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_PROG_DETACH))
 		return -EINVAL;
 
@@ -2817,6 +2868,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_LIRC_MODE2:
 		return lirc_prog_detach(attr);
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
 		return skb_flow_dissector_bpf_prog_detach(attr);
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
@@ -2880,8 +2933,6 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
 	struct bpf_prog *prog;
 	int ret = -ENOTSUPP;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
 		return -EINVAL;
 
@@ -3163,7 +3214,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	info.run_time_ns = stats.nsecs;
 	info.run_cnt = stats.cnt;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
 		info.xlated_prog_len = 0;
 		info.nr_jited_ksyms = 0;
@@ -3522,7 +3573,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!bpf_capable())
 		return -EPERM;
 
 	return btf_new_fd(attr);
@@ -3736,9 +3787,6 @@ static int link_create(union bpf_attr *attr)
 	struct bpf_prog *prog;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_LINK_CREATE))
 		return -EINVAL;
 
@@ -3784,9 +3832,6 @@ static int link_update(union bpf_attr *attr)
 	u32 flags;
 	int ret;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (CHECK_ATTR(BPF_LINK_UPDATE))
 		return -EINVAL;
 
@@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	union bpf_attr attr;
 	int err;
 
-	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
+	if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
 		return -EPERM;
 
 	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 70ad009577f8..a6893746cd87 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1293,7 +1293,7 @@ static void __mark_reg_unknown(const struct bpf_verifier_env *env,
 	reg->type = SCALAR_VALUE;
 	reg->var_off = tnum_unknown;
 	reg->frameno = 0;
-	reg->precise = env->subprog_cnt > 1 || !env->allow_ptr_leaks;
+	reg->precise = env->subprog_cnt > 1 || !env->bpf_capable;
 	__mark_reg_unbounded(reg);
 }
 
@@ -1425,8 +1425,9 @@ static int check_subprogs(struct bpf_verifier_env *env)
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
@@ -1960,7 +1961,7 @@ static int __mark_chain_precision(struct bpf_verifier_env *env, int regno,
 	bool new_marks = false;
 	int i, err;
 
-	if (!env->allow_ptr_leaks)
+	if (!env->bpf_capable)
 		/* backtracking is root only for now */
 		return 0;
 
@@ -2208,7 +2209,7 @@ static int check_stack_write(struct bpf_verifier_env *env,
 		reg = &cur->regs[value_regno];
 
 	if (reg && size == BPF_REG_SIZE && register_is_const(reg) &&
-	    !register_is_null(reg) && env->allow_ptr_leaks) {
+	    !register_is_null(reg) && env->bpf_capable) {
 		if (dst_reg != BPF_REG_FP) {
 			/* The backtracking logic can only recognize explicit
 			 * stack slot address like [fp - 8]. Other spill of
@@ -3428,7 +3429,7 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		 * Spectre masking for stack ALU.
 		 * See also retrieve_ptr_limit().
 		 */
-		if (!env->allow_ptr_leaks) {
+		if (!env->bpf_capable) {
 			char tn_buf[48];
 
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
@@ -7229,7 +7230,7 @@ static int push_insn(int t, int w, int e, struct bpf_verifier_env *env,
 		insn_stack[env->cfg.cur_stack++] = w;
 		return 1;
 	} else if ((insn_state[w] & 0xF0) == DISCOVERED) {
-		if (loop_ok && env->allow_ptr_leaks)
+		if (loop_ok && env->bpf_capable)
 			return 0;
 		verbose_linfo(env, t, "%d: ", t);
 		verbose_linfo(env, w, "%d: ", w);
@@ -8338,7 +8339,7 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 	if (env->max_states_per_insn < states_cnt)
 		env->max_states_per_insn = states_cnt;
 
-	if (!env->allow_ptr_leaks && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
+	if (!env->bpf_capable && states_cnt > BPF_COMPLEXITY_LIMIT_STATES)
 		return push_jmp_history(env, cur);
 
 	if (!add_new_state)
@@ -9998,7 +9999,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
 			aux = &env->insn_aux_data[i + delta];
-			if (env->allow_ptr_leaks && !expect_blinding &&
+			if (env->bpf_capable && !expect_blinding &&
 			    prog->jit_requested &&
 			    !bpf_map_key_poisoned(aux) &&
 			    !bpf_map_ptr_poisoned(aux) &&
@@ -10725,7 +10726,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
-	is_priv = capable(CAP_SYS_ADMIN);
+	is_priv = bpf_capable();
 
 	if (!btf_vmlinux && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
 		mutex_lock(&bpf_verifier_lock);
@@ -10766,7 +10767,8 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 	if (attr->prog_flags & BPF_F_ANY_ALIGNMENT)
 		env->strict_alignment = false;
 
-	env->allow_ptr_leaks = is_priv;
+	env->allow_ptr_leaks = perfmon_capable();
+	env->bpf_capable = bpf_capable();
 
 	if (is_priv)
 		env->test_state_freq = attr->prog_flags & BPF_F_TEST_STATE_FREQ;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e875c95d3ced..58c51837fa18 100644
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
index dfaf5df13722..121a7ad404a8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6626,7 +6626,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		return false;
 	case bpf_ctx_range(struct __sk_buff, data):
 	case bpf_ctx_range(struct __sk_buff, data_end):
-		if (!capable(CAP_SYS_ADMIN))
+		if (!bpf_capable())
 			return false;
 		break;
 	}
@@ -6638,7 +6638,7 @@ static bool cg_skb_is_valid_access(int off, int size,
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

