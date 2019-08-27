Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1BC9F48F
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 22:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730495AbfH0Uxi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Aug 2019 16:53:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:24650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbfH0Uxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 16:53:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7RKoINA005564
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:53:37 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2un3vjjjx5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 13:53:37 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 27 Aug 2019 13:52:17 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DF829760EB7; Tue, 27 Aug 2019 13:52:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <luto@amacapital.net>
CC:     <davem@davemloft.net>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>, <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date:   Tue, 27 Aug 2019 13:52:13 -0700
Message-ID: <20190827205213.456318-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-27_04:2019-08-27,2019-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 clxscore=1034 phishscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 mlxscore=0 suspectscore=4 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908270198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce CAP_BPF that allows loading all types of BPF programs,
create most map types, load BTF, iterate programs and maps.
CAP_BPF alone is not enough to attach or run programs.

Networking:

CAP_BPF and CAP_NET_ADMIN are necessary to:
- attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
- run networking bpf programs (like xdp, skb, flow_dissector)

Tracing:

CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
are necessary to:
- attach bpf program to raw tracepoint
- use bpf_trace_printk() in all program types (not only tracing programs)
- create bpf stackmap

To attach bpf to perf_events perf_event_open() needs to succeed as usual.

CAP_BPF controls BPF side.
CAP_NET_ADMIN controls intersection where BPF calls into networking.
perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.

In the future CAP_TRACING could be introduced to control
creation of kprobe/uprobe and attaching bpf to perf_events.
In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
Whereas probe_read() would be controlled by CAP_TRACING.
CAP_TRACING would also control generic kprobe+probe_read.
CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
that want to use bpf_probe_read.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
I would prefer to introduce CAP_TRACING soon, since it
will make tracing and networking permission model symmetrical.

 include/linux/filter.h                      |  1 +
 include/uapi/linux/capability.h             |  5 ++-
 kernel/bpf/arraymap.c                       |  2 +-
 kernel/bpf/cgroup.c                         |  2 +-
 kernel/bpf/core.c                           | 10 ++++--
 kernel/bpf/cpumap.c                         |  2 +-
 kernel/bpf/hashtab.c                        |  4 +--
 kernel/bpf/lpm_trie.c                       |  2 +-
 kernel/bpf/queue_stack_maps.c               |  2 +-
 kernel/bpf/reuseport_array.c                |  2 +-
 kernel/bpf/stackmap.c                       |  2 +-
 kernel/bpf/syscall.c                        | 32 ++++++++++-------
 kernel/bpf/verifier.c                       |  4 +--
 kernel/trace/bpf_trace.c                    |  2 +-
 net/core/bpf_sk_storage.c                   |  2 +-
 net/core/filter.c                           | 10 +++---
 security/selinux/include/classmap.h         |  4 +--
 tools/testing/selftests/bpf/test_verifier.c | 39 ++++++++++++++++-----
 18 files changed, 84 insertions(+), 43 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 92c6e31fb008..16cea50af014 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -857,6 +857,7 @@ static inline bool bpf_dump_raw_ok(void)
 	return kallsyms_show_value() == 1;
 }
 
+bool cap_bpf_tracing(void);
 struct bpf_prog *bpf_patch_insn_single(struct bpf_prog *prog, u32 off,
 				       const struct bpf_insn *patch, u32 len);
 int bpf_remove_insns(struct bpf_prog *prog, u32 off, u32 cnt);
diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 240fdb9a60f6..b3390f34c9f5 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -366,8 +366,11 @@ struct vfs_ns_cap_data {
 
 #define CAP_AUDIT_READ		37
 
+/* Allow bpf() syscall except attach and tracing */
 
-#define CAP_LAST_CAP         CAP_AUDIT_READ
+#define CAP_BPF			38
+
+#define CAP_LAST_CAP         CAP_BPF
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..045e30b7160d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -73,7 +73,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
 	int ret, numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
-	bool unpriv = !capable(CAP_SYS_ADMIN);
+	bool unpriv = !capable(CAP_BPF);
 	u64 cost, array_size, mask64;
 	struct bpf_map_memory mem;
 	struct bpf_array *array;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6a6a154cfa7b..97f733354421 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -795,7 +795,7 @@ cgroup_base_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
 	case BPF_FUNC_trace_printk:
-		if (capable(CAP_SYS_ADMIN))
+		if (cap_bpf_tracing())
 			return bpf_get_trace_printk_proto();
 		/* fall through */
 	default:
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8191a7db2777..5756c8a56f44 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 	if (!bpf_prog_kallsyms_candidate(fp) ||
-	    !capable(CAP_SYS_ADMIN))
+	    !capable(CAP_BPF))
 		return;
 
 	spin_lock_bh(&bpf_lock);
@@ -768,7 +768,7 @@ static int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!capable(CAP_BPF)) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
@@ -2104,6 +2104,12 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
 
+bool cap_bpf_tracing(void)
+{
+	return capable(CAP_SYS_ADMIN) ||
+	       (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
+}
+
 /* All definitions of tracepoints related to BPF. */
 #define CREATE_TRACE_POINTS
 #include <linux/bpf_trace.h>
diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index ef49e17ae47c..ca483c9a9c2e 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -84,7 +84,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 	int ret, cpu;
 	u64 cost;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return ERR_PTR(-EPERM);
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c9..f459315625ac 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -244,9 +244,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
 		     offsetof(struct htab_elem, hash_node.pprev));
 
-	if (lru && !capable(CAP_SYS_ADMIN))
+	if (lru && !capable(CAP_BPF))
 		/* LRU implementation is much complicated than other
-		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
+		 * maps.  Hence, limit to CAP_BPF.
 		 */
 		return -EPERM;
 
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 56e6c75d354d..a45fa5464d98 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -543,7 +543,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	u64 cost = sizeof(*trie), cost_per_node;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return ERR_PTR(-EPERM);
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..ca0ba9edca86 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -45,7 +45,7 @@ static bool queue_stack_map_is_full(struct bpf_queue_stack *qs)
 /* Called from syscall */
 static int queue_stack_map_alloc_check(union bpf_attr *attr)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 50c083ba978c..bfad7d41a061 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -154,7 +154,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 	struct bpf_map_memory mem;
 	u64 array_size;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return ERR_PTR(-EPERM);
 
 	array_size = sizeof(*array);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 052580c33d26..c540b2b3fc4a 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -90,7 +90,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 	u64 cost, n_buckets;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!cap_bpf_tracing())
 		return ERR_PTR(-EPERM);
 
 	if (attr->map_flags & ~STACK_CREATE_FLAG_MASK)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c0f62fd67c6b..ef7b06ca30e5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1176,7 +1176,7 @@ static int map_freeze(const union bpf_attr *attr)
 		err = -EBUSY;
 		goto err_put;
 	}
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable(CAP_BPF)) {
 		err = -EPERM;
 		goto err_put;
 	}
@@ -1634,7 +1634,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
 	    (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable(CAP_BPF))
 		return -EPERM;
 
 	/* copy eBPF program license from user space */
@@ -1647,11 +1647,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	is_gpl = license_is_gpl_compatible(license);
 
 	if (attr->insn_cnt == 0 ||
-	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
+	    attr->insn_cnt > (capable(CAP_BPF) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable(CAP_BPF))
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
@@ -1802,6 +1802,9 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	char tp_name[128];
 	int tp_fd, err;
 
+	if (!cap_bpf_tracing())
+		return -EPERM;
+
 	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
 			      sizeof(tp_name) - 1) < 0)
 		return -EFAULT;
@@ -2080,7 +2083,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
 	struct bpf_prog *prog;
 	int ret = -ENOTSUPP;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_NET_ADMIN) || !capable(CAP_BPF))
+		/* test_run callback is available for networking progs only.
+		 * Add cap_bpf_tracing() above when tracing progs become runable.
+		 */
 		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
 		return -EINVAL;
@@ -2117,7 +2123,7 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
 	if (CHECK_ATTR(BPF_OBJ_GET_NEXT_ID) || next_id >= INT_MAX)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	next_id++;
@@ -2143,7 +2149,7 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_PROG_GET_FD_BY_ID))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	spin_lock_bh(&prog_idr_lock);
@@ -2177,7 +2183,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	    attr->open_flags & ~BPF_OBJ_FLAG_MASK)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	f_flags = bpf_get_file_flag(attr->open_flags);
@@ -2352,7 +2358,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	info.run_time_ns = stats.nsecs;
 	info.run_cnt = stats.cnt;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable(CAP_BPF)) {
 		info.jited_prog_len = 0;
 		info.xlated_prog_len = 0;
 		info.nr_jited_ksyms = 0;
@@ -2670,7 +2676,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	return btf_new_fd(attr);
@@ -2683,7 +2689,7 @@ static int bpf_btf_get_fd_by_id(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_GET_FD_BY_ID))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	return btf_get_fd_by_id(attr->btf_id);
@@ -2752,7 +2758,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (CHECK_ATTR(BPF_TASK_FD_QUERY))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!cap_bpf_tracing())
 		return -EPERM;
 
 	if (attr->task_fd_query.flags != 0)
@@ -2820,7 +2826,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	union bpf_attr attr = {};
 	int err;
 
-	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
+	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_BPF))
 		return -EPERM;
 
 	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 10c0ff93f52b..5810e8cc9342 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -987,7 +987,7 @@ static void __mark_reg_unbounded(struct bpf_reg_state *reg)
 	reg->umax_value = U64_MAX;
 
 	/* constant backtracking is enabled for root only for now */
-	reg->precise = capable(CAP_SYS_ADMIN) ? false : true;
+	reg->precise = capable(CAP_BPF) ? false : true;
 }
 
 /* Mark a register as having a completely unknown (scalar) value. */
@@ -9233,7 +9233,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
-	is_priv = capable(CAP_SYS_ADMIN);
+	is_priv = capable(CAP_BPF);
 
 	/* grab the mutex to protect few globals used by verifier */
 	if (!is_priv)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..2bf58ff5bf75 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1246,7 +1246,7 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 	u32 *ids, prog_cnt, ids_len;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!cap_bpf_tracing())
 		return -EPERM;
 	if (event->attr.type != PERF_TYPE_TRACEPOINT)
 		return -EINVAL;
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index da5639a5bd3b..0b29f6abbeba 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -616,7 +616,7 @@ static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 	    !attr->btf_key_type_id || !attr->btf_value_type_id)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return -EPERM;
 
 	if (attr->value_size >= KMALLOC_MAX_SIZE -
diff --git a/net/core/filter.c b/net/core/filter.c
index 0c1059cdad3d..986277abfde2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5990,7 +5990,7 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		break;
 	}
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_BPF))
 		return NULL;
 
 	switch (func_id) {
@@ -5999,7 +5999,9 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
 	case BPF_FUNC_trace_printk:
-		return bpf_get_trace_printk_proto();
+		if (cap_bpf_tracing())
+			return bpf_get_trace_printk_proto();
+		/* fall through */
 	default:
 		return NULL;
 	}
@@ -6563,7 +6565,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		return false;
 	case bpf_ctx_range(struct __sk_buff, data):
 	case bpf_ctx_range(struct __sk_buff, data_end):
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_BPF))
 			return false;
 		break;
 	}
@@ -6575,7 +6577,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
 			break;
 		case bpf_ctx_range(struct __sk_buff, tstamp):
-			if (!capable(CAP_SYS_ADMIN))
+			if (!capable(CAP_BPF))
 				return false;
 			break;
 		default:
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 201f7e588a29..1c925bc04072 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -26,9 +26,9 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read"
+		"wake_alarm", "block_suspend", "audit_read", "bpf"
 
-#if CAP_LAST_CAP > CAP_AUDIT_READ
+#if CAP_LAST_CAP > CAP_BPF
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 44e2d640b088..b31b961f1020 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -805,10 +805,18 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 }
 
+struct libcap {
+	struct __user_cap_header_struct hdr;
+	struct __user_cap_data_struct data[2];
+};
+
 static int set_admin(bool admin)
 {
 	cap_t caps;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
+	/* need CAP_BPF to load progs and CAP_NET_ADMIN to run networking progs */
+	const cap_value_t cap_val[] = {38/*CAP_BPF*/, CAP_NET_ADMIN};
+	const cap_value_t cap_val_admin = CAP_SYS_ADMIN;
+	struct libcap *cap;
 	int ret = -1;
 
 	caps = cap_get_proc();
@@ -816,11 +824,23 @@ static int set_admin(bool admin)
 		perror("cap_get_proc");
 		return -1;
 	}
-	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val,
+	cap = (struct libcap *)caps;
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_val_admin, CAP_CLEAR)) {
+		perror("cap_set_flag clear admin");
+		goto out;
+	}
+	if (cap_set_flag(caps, CAP_EFFECTIVE, 2, cap_val,
 				admin ? CAP_SET : CAP_CLEAR)) {
-		perror("cap_set_flag");
+		perror("cap_set_flag set_or_clear bpf+net");
 		goto out;
 	}
+	/* libcap is likely old and simply ignores CAP_BPF,
+	 * so update effective bits manually
+	 */
+	if (admin)
+		cap->data[1].effective |= 1 << (38 - 32);
+	else
+		cap->data[1].effective &= ~(1 << (38 - 32));
 	if (cap_set_proc(caps)) {
 		perror("cap_set_proc");
 		goto out;
@@ -1013,8 +1033,9 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 static bool is_admin(void)
 {
 	cap_t caps;
-	cap_flag_value_t sysadmin = CAP_CLEAR;
-	const cap_value_t cap_val = CAP_SYS_ADMIN;
+	cap_flag_value_t bpf_priv = CAP_CLEAR;
+	cap_flag_value_t net_priv = CAP_CLEAR;
+	struct libcap *cap;
 
 #ifdef CAP_IS_SUPPORTED
 	if (!CAP_IS_SUPPORTED(CAP_SETFCAP)) {
@@ -1027,11 +1048,13 @@ static bool is_admin(void)
 		perror("cap_get_proc");
 		return false;
 	}
-	if (cap_get_flag(caps, cap_val, CAP_EFFECTIVE, &sysadmin))
-		perror("cap_get_flag");
+	cap = (struct libcap *)caps;
+	bpf_priv = cap->data[1].effective & (1 << (38/* CAP_BPF */ - 32));
+	if (cap_get_flag(caps, CAP_NET_ADMIN, CAP_EFFECTIVE, &net_priv))
+		perror("cap_get_flag NET");
 	if (cap_free(caps))
 		perror("cap_free");
-	return (sysadmin == CAP_SET);
+	return bpf_priv == CAP_SET && net_priv == CAP_SET;
 }
 
 static void get_unpriv_disabled()
-- 
2.20.0

