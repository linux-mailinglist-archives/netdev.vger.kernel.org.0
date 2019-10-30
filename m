Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D733EEA635
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfJ3WcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:32:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47426 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726973AbfJ3WcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:32:18 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9UMS4Zs029469
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:17 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vyk8a01px-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:17 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 30 Oct 2019 15:32:16 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 26365760903; Wed, 30 Oct 2019 15:32:15 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/2] bpf: replace prog_raw_tp+btf_id with prog_tracing
Date:   Wed, 30 Oct 2019 15:32:11 -0700
Message-ID: <20191030223212.953010-2-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191030223212.953010-1-ast@kernel.org>
References: <20191030223212.953010-1-ast@kernel.org>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 suspectscore=1 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910300199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf program type raw_tp together with 'expected_attach_type'
was the most appropriate api to indicate BTF-enabled raw_tp programs.
But during development it became apparent that 'expected_attach_type'
cannot be used and new 'attach_btf_id' field had to be introduced.
Which means that the information is duplicated in two fields where
one of them is ignored.
Clean it up by introducing new program type where both
'expected_attach_type' and 'attach_btf_id' fields have
specific meaning.
In the future 'expected_attach_type' will be extended
with other attach points that have similar semantics to raw_tp.
This patch is replacing BTF-enabled BPF_PROG_TYPE_RAW_TRACEPOINT with
prog_type = BPF_RPOG_TYPE_TRACING
expected_attach_type = BPF_TRACE_RAW_TP
attach_btf_id = btf_id of raw tracepoint inside the kernel
Future patches will add
expected_attach_type = BPF_TRACE_FENTRY or BPF_TRACE_FEXIT
where programs have the same input context and the same helpers,
but different attach points.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h       |  5 +++++
 include/linux/bpf_types.h |  1 +
 include/uapi/linux/bpf.h  |  2 ++
 kernel/bpf/syscall.c      |  6 +++---
 kernel/bpf/verifier.c     | 34 +++++++++++++++++++++---------
 kernel/trace/bpf_trace.c  | 44 ++++++++++++++++++++++++++++++++-------
 6 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 171be30fe0ae..80158cff44bd 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -373,6 +373,11 @@ enum bpf_cgroup_storage_type {
 
 #define MAX_BPF_CGROUP_STORAGE_TYPE __BPF_CGROUP_STORAGE_MAX
 
+/* The longest tracepoint has 12 args.
+ * See include/trace/bpf_probe.h
+ */
+#define MAX_BPF_FUNC_ARGS 12
+
 struct bpf_prog_stats {
 	u64 cnt;
 	u64 nsecs;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 36a9c2325176..de14872b01ba 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -26,6 +26,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_TRACEPOINT, tracepoint)
 BPF_PROG_TYPE(BPF_PROG_TYPE_PERF_EVENT, perf_event)
 BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT, raw_tracepoint)
 BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
+BPF_PROG_TYPE(BPF_PROG_TYPE_TRACING, tracing)
 #endif
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..a6bf19dabaab 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_TRACING,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_TRACE_RAW_TP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ff5225759553..985d01ced196 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1571,7 +1571,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   u32 btf_id)
 {
 	switch (prog_type) {
-	case BPF_PROG_TYPE_RAW_TRACEPOINT:
+	case BPF_PROG_TYPE_TRACING:
 		if (btf_id > BTF_MAX_TYPE)
 			return -EINVAL;
 		break;
@@ -1833,13 +1833,13 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		return PTR_ERR(prog);
 
 	if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
+	    prog->type != BPF_PROG_TYPE_TRACING &&
 	    prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
 		err = -EINVAL;
 		goto out_put_prog;
 	}
 
-	if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT &&
-	    prog->aux->attach_btf_id) {
+	if (prog->type == BPF_PROG_TYPE_TRACING) {
 		if (attr->raw_tracepoint.name) {
 			/* raw_tp name should not be specified in raw_tp
 			 * programs that were verified via in-kernel BTF info
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6b0de04f8b91..2f2374967b36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9381,24 +9381,36 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog;
 	u32 btf_id = prog->aux->attach_btf_id;
+	const char prefix[] = "btf_trace_";
 	const struct btf_type *t;
 	const char *tname;
 
-	if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT && btf_id) {
-		const char prefix[] = "btf_trace_";
+	if (prog->type != BPF_PROG_TYPE_TRACING)
+		return 0;
 
-		t = btf_type_by_id(btf_vmlinux, btf_id);
-		if (!t) {
-			verbose(env, "attach_btf_id %u is invalid\n", btf_id);
-			return -EINVAL;
-		}
+	if (!btf_id) {
+		verbose(env, "Tracing programs must provide btf_id\n");
+		return -EINVAL;
+	}
+	t = btf_type_by_id(btf_vmlinux, btf_id);
+	if (!t) {
+		verbose(env, "attach_btf_id %u is invalid\n", btf_id);
+		return -EINVAL;
+	}
+	tname = btf_name_by_offset(btf_vmlinux, t->name_off);
+	if (!tname) {
+		verbose(env, "attach_btf_id %u doesn't have a name\n", btf_id);
+		return -EINVAL;
+	}
+
+	switch (prog->expected_attach_type) {
+	case BPF_TRACE_RAW_TP:
 		if (!btf_type_is_typedef(t)) {
 			verbose(env, "attach_btf_id %u is not a typedef\n",
 				btf_id);
 			return -EINVAL;
 		}
-		tname = btf_name_by_offset(btf_vmlinux, t->name_off);
-		if (!tname || strncmp(prefix, tname, sizeof(prefix) - 1)) {
+		if (strncmp(prefix, tname, sizeof(prefix) - 1)) {
 			verbose(env, "attach_btf_id %u points to wrong type name %s\n",
 				btf_id, tname);
 			return -EINVAL;
@@ -9419,8 +9431,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		prog->aux->attach_func_name = tname;
 		prog->aux->attach_func_proto = t;
 		prog->aux->attach_btf_trace = true;
+		return 0;
+	default:
+		return -EINVAL;
 	}
-	return 0;
 }
 
 int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 571c25d60710..f50bf19f7a05 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1055,10 +1055,6 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
 		return &bpf_perf_event_output_proto_raw_tp;
-#ifdef CONFIG_NET
-	case BPF_FUNC_skb_output:
-		return &bpf_skb_output_proto;
-#endif
 	case BPF_FUNC_get_stackid:
 		return &bpf_get_stackid_proto_raw_tp;
 	case BPF_FUNC_get_stack:
@@ -1068,20 +1064,44 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
+static const struct bpf_func_proto *
+tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+#ifdef CONFIG_NET
+	case BPF_FUNC_skb_output:
+		return &bpf_skb_output_proto;
+#endif
+	default:
+		return raw_tp_prog_func_proto(func_id, prog);
+	}
+}
+
 static bool raw_tp_prog_is_valid_access(int off, int size,
 					enum bpf_access_type type,
 					const struct bpf_prog *prog,
 					struct bpf_insn_access_aux *info)
 {
-	/* largest tracepoint in the kernel has 12 args */
-	if (off < 0 || off >= sizeof(__u64) * 12)
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
+		return false;
+	return true;
+}
+
+static bool tracing_prog_is_valid_access(int off, int size,
+					 enum bpf_access_type type,
+					 const struct bpf_prog *prog,
+					 struct bpf_insn_access_aux *info)
+{
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
 		return false;
 	if (type != BPF_READ)
 		return false;
 	if (off % size != 0)
 		return false;
-	if (!prog->aux->attach_btf_id)
-		return true;
 	return btf_ctx_access(off, size, type, prog, info);
 }
 
@@ -1093,6 +1113,14 @@ const struct bpf_verifier_ops raw_tracepoint_verifier_ops = {
 const struct bpf_prog_ops raw_tracepoint_prog_ops = {
 };
 
+const struct bpf_verifier_ops tracing_verifier_ops = {
+	.get_func_proto  = tracing_prog_func_proto,
+	.is_valid_access = tracing_prog_is_valid_access,
+};
+
+const struct bpf_prog_ops tracing_prog_ops = {
+};
+
 static bool raw_tp_writable_prog_is_valid_access(int off, int size,
 						 enum bpf_access_type type,
 						 const struct bpf_prog *prog,
-- 
2.17.1

