Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC8AC2DE
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 01:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405306AbfIFXLJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 6 Sep 2019 19:11:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54660 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405290AbfIFXLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 19:11:08 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x86N9Va0015751
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 16:11:06 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uu6wu6qyj-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 16:11:06 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 6 Sep 2019 16:10:58 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 3FE51760B80; Fri,  6 Sep 2019 16:10:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <luto@amacapital.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-api@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/4] bpf: implement CAP_BPF
Date:   Fri, 6 Sep 2019 16:10:51 -0700
Message-ID: <20190906231053.1276792-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190906231053.1276792-1-ast@kernel.org>
References: <20190906231053.1276792-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_11:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=1 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060226
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement permissions as stated in uapi/linux/capability.h

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/arraymap.c         |  2 +-
 kernel/bpf/cgroup.c           |  2 +-
 kernel/bpf/core.c             |  4 ++--
 kernel/bpf/hashtab.c          |  4 ++--
 kernel/bpf/lpm_trie.c         |  2 +-
 kernel/bpf/queue_stack_maps.c |  2 +-
 kernel/bpf/reuseport_array.c  |  2 +-
 kernel/bpf/stackmap.c         |  2 +-
 kernel/bpf/syscall.c          | 32 +++++++++++++++++++-------------
 kernel/bpf/verifier.c         |  2 +-
 kernel/trace/bpf_trace.c      |  2 +-
 net/core/bpf_sk_storage.c     |  2 +-
 net/core/filter.c             | 10 ++++++----
 13 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a9..149f868a02dc 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -73,7 +73,7 @@ static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 	bool percpu = attr->map_type == BPF_MAP_TYPE_PERCPU_ARRAY;
 	int ret, numa_node = bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
-	bool unpriv = !capable(CAP_SYS_ADMIN);
+	bool unpriv = !capable_bpf();
 	u64 cost, array_size, mask64;
 	struct bpf_map_memory mem;
 	struct bpf_array *array;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6a6a154cfa7b..9c659ba5c146 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -795,7 +795,7 @@ cgroup_base_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_current_cgroup_id:
 		return &bpf_get_current_cgroup_id_proto;
 	case BPF_FUNC_trace_printk:
-		if (capable(CAP_SYS_ADMIN))
+		if (capable_bpf_tracing())
 			return bpf_get_trace_printk_proto();
 		/* fall through */
 	default:
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..6643099bc64b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -646,7 +646,7 @@ static bool bpf_prog_kallsyms_verify_off(const struct bpf_prog *fp)
 void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 {
 	if (!bpf_prog_kallsyms_candidate(fp) ||
-	    !capable(CAP_SYS_ADMIN))
+	    !capable_bpf())
 		return;
 
 	spin_lock_bh(&bpf_lock);
@@ -768,7 +768,7 @@ static int bpf_jit_charge_modmem(u32 pages)
 {
 	if (atomic_long_add_return(pages, &bpf_jit_current) >
 	    (bpf_jit_limit >> PAGE_SHIFT)) {
-		if (!capable(CAP_SYS_ADMIN)) {
+		if (!capable_bpf()) {
 			atomic_long_sub(pages, &bpf_jit_current);
 			return -EPERM;
 		}
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c9..0fae5c45f425 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -244,9 +244,9 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
 		     offsetof(struct htab_elem, hash_node.pprev));
 
-	if (lru && !capable(CAP_SYS_ADMIN))
+	if (lru && !capable_bpf())
 		/* LRU implementation is much complicated than other
-		 * maps.  Hence, limit to CAP_SYS_ADMIN for now.
+		 * maps.  Hence, limit to CAP_BPF.
 		 */
 		return -EPERM;
 
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 56e6c75d354d..11da3be8a4e5 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -543,7 +543,7 @@ static struct bpf_map *trie_alloc(union bpf_attr *attr)
 	u64 cost = sizeof(*trie), cost_per_node;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return ERR_PTR(-EPERM);
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..d83afac32863 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -45,7 +45,7 @@ static bool queue_stack_map_is_full(struct bpf_queue_stack *qs)
 /* Called from syscall */
 static int queue_stack_map_alloc_check(union bpf_attr *attr)
 {
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	/* check sanity of attributes */
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 50c083ba978c..b268fe4b2972 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -154,7 +154,7 @@ static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 	struct bpf_map_memory mem;
 	u64 array_size;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return ERR_PTR(-EPERM);
 
 	array_size = sizeof(*array);
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 052580c33d26..477063c63b27 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -90,7 +90,7 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 	u64 cost, n_buckets;
 	int err;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_tracing())
 		return ERR_PTR(-EPERM);
 
 	if (attr->map_flags & ~STACK_CREATE_FLAG_MASK)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..cd2d1b21f0f5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1176,7 +1176,7 @@ static int map_freeze(const union bpf_attr *attr)
 		err = -EBUSY;
 		goto err_put;
 	}
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable_bpf()) {
 		err = -EPERM;
 		goto err_put;
 	}
@@ -1635,7 +1635,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
 	    (attr->prog_flags & BPF_F_ANY_ALIGNMENT) &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable_bpf())
 		return -EPERM;
 
 	/* copy eBPF program license from user space */
@@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	is_gpl = license_is_gpl_compatible(license);
 
 	if (attr->insn_cnt == 0 ||
-	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
+	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
 		return -E2BIG;
 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
+	    !capable_bpf())
 		return -EPERM;
 
 	bpf_prog_load_fixup_attach_type(attr);
@@ -1809,6 +1809,9 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 	char tp_name[128];
 	int tp_fd, err;
 
+	if (!capable_bpf_tracing())
+		return -EPERM;
+
 	if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
 			      sizeof(tp_name) - 1) < 0)
 		return -EFAULT;
@@ -2087,7 +2090,10 @@ static int bpf_prog_test_run(const union bpf_attr *attr,
 	struct bpf_prog *prog;
 	int ret = -ENOTSUPP;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf_net_admin())
+		/* test_run callback is available for networking progs only.
+		 * Add capable_bpf_tracing() above when tracing progs become runable.
+		 */
 		return -EPERM;
 	if (CHECK_ATTR(BPF_PROG_TEST_RUN))
 		return -EINVAL;
@@ -2124,7 +2130,7 @@ static int bpf_obj_get_next_id(const union bpf_attr *attr,
 	if (CHECK_ATTR(BPF_OBJ_GET_NEXT_ID) || next_id >= INT_MAX)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	next_id++;
@@ -2150,7 +2156,7 @@ static int bpf_prog_get_fd_by_id(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_PROG_GET_FD_BY_ID))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	spin_lock_bh(&prog_idr_lock);
@@ -2184,7 +2190,7 @@ static int bpf_map_get_fd_by_id(const union bpf_attr *attr)
 	    attr->open_flags & ~BPF_OBJ_FLAG_MASK)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	f_flags = bpf_get_file_flag(attr->open_flags);
@@ -2359,7 +2365,7 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 	info.run_time_ns = stats.nsecs;
 	info.run_cnt = stats.cnt;
 
-	if (!capable(CAP_SYS_ADMIN)) {
+	if (!capable_bpf()) {
 		info.jited_prog_len = 0;
 		info.xlated_prog_len = 0;
 		info.nr_jited_ksyms = 0;
@@ -2677,7 +2683,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	return btf_new_fd(attr);
@@ -2690,7 +2696,7 @@ static int bpf_btf_get_fd_by_id(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_BTF_GET_FD_BY_ID))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	return btf_get_fd_by_id(attr->btf_id);
@@ -2759,7 +2765,7 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (CHECK_ATTR(BPF_TASK_FD_QUERY))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf_tracing())
 		return -EPERM;
 
 	if (attr->task_fd_query.flags != 0)
@@ -2827,7 +2833,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	union bpf_attr attr = {};
 	int err;
 
-	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
+	if (sysctl_unprivileged_bpf_disabled && !capable_bpf())
 		return -EPERM;
 
 	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3fb50757e812..7e519711c689 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9234,7 +9234,7 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
 		env->insn_aux_data[i].orig_idx = i;
 	env->prog = *prog;
 	env->ops = bpf_verifier_ops[env->prog->type];
-	is_priv = capable(CAP_SYS_ADMIN);
+	is_priv = capable_bpf();
 
 	/* grab the mutex to protect few globals used by verifier */
 	if (!is_priv)
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d14576..cdf8d6c8a430 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1246,7 +1246,7 @@ int perf_event_query_prog_array(struct perf_event *event, void __user *info)
 	u32 *ids, prog_cnt, ids_len;
 	int ret;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf_tracing())
 		return -EPERM;
 	if (event->attr.type != PERF_TYPE_TRACEPOINT)
 		return -EINVAL;
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index da5639a5bd3b..aa74be21f5b6 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -616,7 +616,7 @@ static int bpf_sk_storage_map_alloc_check(union bpf_attr *attr)
 	    !attr->btf_key_type_id || !attr->btf_value_type_id)
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return -EPERM;
 
 	if (attr->value_size >= KMALLOC_MAX_SIZE -
diff --git a/net/core/filter.c b/net/core/filter.c
index ed6563622ce3..b233ed8438f1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5990,7 +5990,7 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		break;
 	}
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable_bpf())
 		return NULL;
 
 	switch (func_id) {
@@ -5999,7 +5999,9 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
 	case BPF_FUNC_trace_printk:
-		return bpf_get_trace_printk_proto();
+		if (capable_bpf_tracing())
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
+		if (!capable_bpf())
 			return false;
 		break;
 	}
@@ -6575,7 +6577,7 @@ static bool cg_skb_is_valid_access(int off, int size,
 		case bpf_ctx_range_till(struct __sk_buff, cb[0], cb[4]):
 			break;
 		case bpf_ctx_range(struct __sk_buff, tstamp):
-			if (!capable(CAP_SYS_ADMIN))
+			if (!capable_bpf())
 				return false;
 			break;
 		default:
-- 
2.20.0

