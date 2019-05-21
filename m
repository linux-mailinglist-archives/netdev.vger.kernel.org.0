Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9182594B
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfEUUl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:41:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57208 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEUUk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:26 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdF09008315;
        Tue, 21 May 2019 20:39:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=EgNZYmbnBfnr5X9kPN54HG5OXTwdKL9pFw9yTMe8ELQ=;
 b=2diQZxcGh0wTLXtjZb5yx4QVL9iSPDOVVknP543m2r0ctac5QGLsjRU7N3ovq4oH6ARc
 GzBFz9n7ENYICCXzij/1GLGGA8+eM948s1ncAHzbT/oai0CUwov/XA7K3a+Y6GjwR6aY
 pCWXAbHP2lkjDlVxbC7RaszoPHEnTjRZHlqWuEKMaTiZDQh06l8kdvS8oaZ62ZZW6qS1
 8vMUehc67AQg/40BNlFWxxiS4C/YCZznXgkSLLmLbxmP0ZyCmHSSDo6WFQGKI3NuXes8
 TxjfoJLvg3wVpuBxwb3ePk1zSLEhPTuO0ANq30UavLQYnakwZfM1jshtCnJXT6IbKtyx hA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sj7jdr7a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKbmSF063858;
        Tue, 21 May 2019 20:39:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2sks1jnp7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:39:35 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKdZhO066993;
        Tue, 21 May 2019 20:39:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sks1jnp7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:39:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LKdX9Y027694;
        Tue, 21 May 2019 20:39:33 GMT
Message-Id: <201905212039.x4LKdX9Y027694@aserv0122.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:39:33 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:39:33 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 01/11] bpf: context casting for tail call
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently BPF programs are executed with a context that is provided by
code that initiates the execution.  Tracing tools that want to make use
of existing probes and events that allow BPF programs to be attached to
them are thus limited to the context information provided by the probe
or event source.  Often, more context is needed to allow tracing tools
the ablity to implement more complex constructs (e.g. more state-full
tracing).

This patch extends the tail-call mechanism to allow a BPF program of
one type to call a BPF program of another type.

BPF program types can specify two new operations in struct bpf_prog_ops:
- bool is_valid_tail_call(enum bpf_prog_type stype)
    This function is called from bpf_prog_array_valid_tail_call()
            which is called from bpf_check_tail_call()
            which is called from bpf_prog_select_runtime()
            which is called from bpf_prog_load() right after the
    verifier finishes processing the program.  It is called for every
    map of type BPF_MAP_TYPE_PROG_ARRAY, and is passed the type of the
    program that is being loaded and therefore will be the origin of
    tail calls.  It returns true if tail calls from the source BPF
    program type to the implementing program type are allowed.

- void *convert_ctx(enum bpf_prog_type stype, void *ctx)
    This function is called during the execution of a BPF tail-call.
    It returns a valid context for the implementing BPF program type,
    based on the passed context pointer (ctx) for BPF program type
    stype.

The program array holding BPF programs that you can tail-call into
continues to require that all programs are of the same type.  But when
a compatibility check is made in a program that performs a tail-call,
the is_valid_tail_call() function is called (if available) to allow
the target type to determine whether it can handle the conversion of
a context from the source type to the target type.  If the function is
not implemented by the program type, casting is denied.

During execution, the convert_ctx() function is called (if available)
to perform the conversion of the current context to the context that the
target type expects.  Since the program type of the executing BPF program
is not explicitly known during execution, the verifier inserts an
instruction right before the tail-call to assign the current BPF program
type to R4.

The interpreter calls convert_ctx() using the program type in R4 as
source program type, the program type associated with the program array
as target program type, and the context as provided in R1.

A helper (finalize_context) is added to allow tail called programs to
perform context setup based on information that is passed in from the
calling program by means of a map that is indexed by CPU id.  The actual
content of the map is defined by the BPF program type implementation
for the program type that is being called.

The bpf_prog_types array is now being exposed to the rest of the BPF
code (where before it was local to just the syscall handling) because
the is_valid_tail_call() and convert_ctx() operations need to be
accessible.

There is no noticeable effect on BPF program types that do not implement
this new feature.

A JIT implementation is not available yet in this first iteration.

v2: Fixed compilation when CONFIG_BPF_SYSCALL=n.
    Fixed casting issue on platforms with 32-bit pointers.

v3: Renamed the new program type operations to be more descriptive.
    Added finalize_context() helper.

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/linux/bpf.h                       |  3 +++
 include/uapi/linux/bpf.h                  | 11 ++++++++-
 kernel/bpf/core.c                         | 29 ++++++++++++++++++++++-
 kernel/bpf/syscall.c                      |  2 +-
 kernel/bpf/verifier.c                     | 16 +++++++++----
 tools/include/uapi/linux/bpf.h            | 11 ++++++++-
 tools/testing/selftests/bpf/bpf_helpers.h |  2 ++
 7 files changed, 66 insertions(+), 8 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 59631dd0777c..7a40a3cd7ff2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -294,6 +294,8 @@ bpf_ctx_record_field_size(struct bpf_insn_access_aux *aux, u32 size)
 struct bpf_prog_ops {
 	int (*test_run)(struct bpf_prog *prog, const union bpf_attr *kattr,
 			union bpf_attr __user *uattr);
+	bool (*is_valid_tail_call)(enum bpf_prog_type stype);
+	void *(*convert_ctx)(enum bpf_prog_type stype, void *ctx);
 };
 
 struct bpf_verifier_ops {
@@ -571,6 +573,7 @@ extern const struct file_operations bpf_prog_fops;
 #undef BPF_PROG_TYPE
 #undef BPF_MAP_TYPE
 
+extern const struct bpf_prog_ops * const bpf_prog_types[];
 extern const struct bpf_prog_ops bpf_offload_prog_ops;
 extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
 extern const struct bpf_verifier_ops xdp_analyzer_ops;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 63e0cf66f01a..61abe6b56948 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2672,6 +2672,14 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *
+ * int bpf_finalize_context(void *ctx, struct bpf_map *map)
+ *	Description
+ *		Perform any final context setup after a tail call took
+ *		place from another BPF program type into a program of
+ *		the implementing program type.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2782,7 +2790,8 @@ union bpf_attr {
 	FN(strtol),			\
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
-	FN(sk_storage_delete),
+	FN(sk_storage_delete),		\
+	FN(finalize_context),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 242a643af82f..225b1be766b0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1456,10 +1456,12 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		CONT;
 
 	JMP_TAIL_CALL: {
+		void *ctx = (void *) (unsigned long) BPF_R1;
 		struct bpf_map *map = (struct bpf_map *) (unsigned long) BPF_R2;
 		struct bpf_array *array = container_of(map, struct bpf_array, map);
 		struct bpf_prog *prog;
 		u32 index = BPF_R3;
+		u32 type = BPF_R4;
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
@@ -1471,6 +1473,13 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		prog = READ_ONCE(array->ptrs[index]);
 		if (!prog)
 			goto out;
+		if (prog->aux->ops->convert_ctx) {
+			ctx = prog->aux->ops->convert_ctx(type, ctx);
+			if (!ctx)
+				goto out;
+
+			BPF_R1 = (u64) (uintptr_t) ctx;
+		}
 
 		/* ARG1 at this point is guaranteed to point to CTX from
 		 * the verifier side due to the fact that the tail call is
@@ -1667,6 +1676,23 @@ bool bpf_prog_array_compatible(struct bpf_array *array,
 	       array->owner_jited == fp->jited;
 }
 
+bool bpf_prog_array_valid_tail_call(struct bpf_array *array,
+				    const struct bpf_prog *fp)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	const struct bpf_prog_ops *ops;
+
+	if (array->owner_jited != fp->jited)
+		return false;
+
+	ops = bpf_prog_types[array->owner_prog_type];
+	if (ops->is_valid_tail_call)
+		return ops->is_valid_tail_call(fp->type);
+#endif
+
+	return false;
+}
+
 static int bpf_check_tail_call(const struct bpf_prog *fp)
 {
 	struct bpf_prog_aux *aux = fp->aux;
@@ -1680,7 +1706,8 @@ static int bpf_check_tail_call(const struct bpf_prog *fp)
 			continue;
 
 		array = container_of(map, struct bpf_array, map);
-		if (!bpf_prog_array_compatible(array, fp))
+		if (!bpf_prog_array_compatible(array, fp) &&
+		    !bpf_prog_array_valid_tail_call(array, fp))
 			return -EINVAL;
 	}
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ad3ccf82f31d..f76fd30ad372 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1179,7 +1179,7 @@ static int map_freeze(const union bpf_attr *attr)
 	return err;
 }
 
-static const struct bpf_prog_ops * const bpf_prog_types[] = {
+const struct bpf_prog_ops * const bpf_prog_types[] = {
 #define BPF_PROG_TYPE(_id, _name) \
 	[_id] = & _name ## _prog_ops,
 #define BPF_MAP_TYPE(_id, _ops)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 95f9354495ad..f9e5536fd1af 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7982,9 +7982,10 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			insn->imm = 0;
 			insn->code = BPF_JMP | BPF_TAIL_CALL;
 
+			cnt = 0;
 			aux = &env->insn_aux_data[i + delta];
 			if (!bpf_map_ptr_unpriv(aux))
-				continue;
+				goto privileged;
 
 			/* instead of changing every JIT dealing with tail_call
 			 * emit two extra insns:
@@ -7999,13 +8000,20 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 
 			map_ptr = BPF_MAP_PTR(aux->map_state);
 			insn_buf[0] = BPF_JMP_IMM(BPF_JGE, BPF_REG_3,
-						  map_ptr->max_entries, 2);
+						  map_ptr->max_entries, 3);
 			insn_buf[1] = BPF_ALU32_IMM(BPF_AND, BPF_REG_3,
 						    container_of(map_ptr,
 								 struct bpf_array,
 								 map)->index_mask);
-			insn_buf[2] = *insn;
-			cnt = 3;
+			cnt = 2;
+
+privileged:
+			/* store the BPF program type of the current program in
+			 * R4 so it is known in case this tail call requires
+			 * casting the context to a different program type
+			 */
+			insn_buf[cnt++] = BPF_MOV64_IMM(BPF_REG_4, prog->type);
+			insn_buf[cnt++] = *insn;
 			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
 			if (!new_prog)
 				return -ENOMEM;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 63e0cf66f01a..61abe6b56948 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2672,6 +2672,14 @@ union bpf_attr {
  *		0 on success.
  *
  *		**-ENOENT** if the bpf-local-storage cannot be found.
+ *
+ * int bpf_finalize_context(void *ctx, struct bpf_map *map)
+ *	Description
+ *		Perform any final context setup after a tail call took
+ *		place from another BPF program type into a program of
+ *		the implementing program type.
+ *	Return
+ *		0 on success, or a negative error in case of failure.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2782,7 +2790,8 @@ union bpf_attr {
 	FN(strtol),			\
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
-	FN(sk_storage_delete),
+	FN(sk_storage_delete),		\
+	FN(finalize_context),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6e80b66d7fb1..d98a62b3b56c 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -216,6 +216,8 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 	(void *) BPF_FUNC_sk_storage_get;
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
+static int (*bpf_finalize_context)(void *ctx, void *map) =
+	(void *) BPF_FUNC_finalize_context;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
-- 
2.20.1

