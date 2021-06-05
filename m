Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD52739C7CC
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFELNM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:12 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:47130 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230281AbhFELNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:11 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-szM1dAJAMbmo1x1MJsOcQg-1; Sat, 05 Jun 2021 07:11:17 -0400
X-MC-Unique: szM1dAJAMbmo1x1MJsOcQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07E21801817;
        Sat,  5 Jun 2021 11:11:15 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51248614FD;
        Sat,  5 Jun 2021 11:11:12 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 11/19] bpf: Add support to load multi func tracing program
Date:   Sat,  5 Jun 2021 13:10:26 +0200
Message-Id: <20210605111034.1810858-12-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
that allows the program to be loaded without specific function to be
attached to.

The verifier assumes the program is using all (6) available arguments
as unsigned long values. We can't add extra ip argument at this time,
because JIT on x86 would fail to process this function. Instead we
allow to access extra first 'ip' argument in btf_ctx_access.

Such program will be allowed to be attached to multiple functions
in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/btf.c               |  5 +++++
 kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c          |  3 ++-
 tools/include/uapi/linux/bpf.h |  7 +++++++
 6 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 6cbf3c81c650..23221e0e8d3c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -845,6 +845,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	struct hlist_node tramp_hlist;
+	bool multi_func;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2c1ba70abbf1..ad9340fb14d4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1109,6 +1109,13 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
+ * not expect BTF ID for the program, instead it assumes it's function
+ * with 6 u64 arguments. No trampoline is created for the program. Such
+ * program can be attached to multiple functions.
+ */
+#define BPF_F_MULTI_FUNC	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a6e39c5ea0bf..c233aaa6a709 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4679,6 +4679,11 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		args++;
 		nr_args--;
 	}
+	if (prog->aux->multi_func) {
+		if (arg == 0)
+			return true;
+		arg--;
+	}
 
 	if (arg > nr_args) {
 		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..8f59090280b5 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -31,6 +31,7 @@
 #include <linux/bpf-netns.h>
 #include <linux/rcupdate_trace.h>
 #include <linux/memcontrol.h>
+#include <linux/btf_ids.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -1979,7 +1980,8 @@ static int
 bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 			   enum bpf_attach_type expected_attach_type,
 			   struct btf *attach_btf, u32 btf_id,
-			   struct bpf_prog *dst_prog)
+			   struct bpf_prog *dst_prog,
+			   bool multi_func)
 {
 	if (btf_id) {
 		if (btf_id > BTF_MAX_TYPE)
@@ -1999,6 +2001,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		}
 	}
 
+	if (multi_func) {
+		if (prog_type != BPF_PROG_TYPE_TRACING)
+			return -EINVAL;
+		if (!attach_btf || btf_id)
+			return -EINVAL;
+		return 0;
+	}
+
 	if (attach_btf && (!btf_id || dst_prog))
 		return -EINVAL;
 
@@ -2114,6 +2124,16 @@ static bool is_perfmon_prog_type(enum bpf_prog_type prog_type)
 	}
 }
 
+#define DEFINE_BPF_MULTI_FUNC(args...)			\
+	extern int bpf_multi_func(args);		\
+	int __init bpf_multi_func(args) { return 0; }
+
+DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
+		      unsigned long a3, unsigned long a4,
+		      unsigned long a5, unsigned long a6)
+
+BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
+
 /* last field in 'union bpf_attr' used by this command */
 #define	BPF_PROG_LOAD_LAST_FIELD fd_array
 
@@ -2124,6 +2144,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	struct btf *attach_btf = NULL;
 	int err;
 	char license[128];
+	bool multi_func;
 	bool is_gpl;
 
 	if (CHECK_ATTR(BPF_PROG_LOAD))
@@ -2133,7 +2154,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_ANY_ALIGNMENT |
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
-				 BPF_F_TEST_RND_HI32))
+				 BPF_F_TEST_RND_HI32 |
+				 BPF_F_MULTI_FUNC))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2164,6 +2186,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
 
+	multi_func = attr->prog_flags & BPF_F_MULTI_FUNC;
+
 	/* attach_prog_fd/attach_btf_obj_fd can specify fd of either bpf_prog
 	 * or btf, we need to check which one it is
 	 */
@@ -2182,7 +2206,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				return -ENOTSUPP;
 			}
 		}
-	} else if (attr->attach_btf_id) {
+	} else if (attr->attach_btf_id || multi_func) {
 		/* fall back to vmlinux BTF, if BTF type ID is specified */
 		attach_btf = bpf_get_btf_vmlinux();
 		if (IS_ERR(attach_btf))
@@ -2195,7 +2219,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach(type, attr->expected_attach_type,
 				       attach_btf, attr->attach_btf_id,
-				       dst_prog)) {
+				       dst_prog, multi_func)) {
 		if (dst_prog)
 			bpf_prog_put(dst_prog);
 		if (attach_btf)
@@ -2215,10 +2239,11 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 
 	prog->expected_attach_type = attr->expected_attach_type;
 	prog->aux->attach_btf = attach_btf;
-	prog->aux->attach_btf_id = attr->attach_btf_id;
+	prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;
 	prog->aux->dst_prog = dst_prog;
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
+	prog->aux->multi_func = multi_func;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1de4b8c6ee42..194adddee2ec 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13276,7 +13276,8 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		if (!bpf_iter_prog_supported(prog))
 			return -EINVAL;
 		return 0;
-	}
+	} else if (prog->aux->multi_func)
+		return prog->type == BPF_PROG_TYPE_TRACING ? 0 : -EINVAL;
 
 	if (prog->type == BPF_PROG_TYPE_LSM) {
 		ret = bpf_lsm_verify_prog(&env->log, prog);
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2c1ba70abbf1..ad9340fb14d4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1109,6 +1109,13 @@ enum bpf_link_type {
  */
 #define BPF_F_SLEEPABLE		(1U << 4)
 
+/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
+ * not expect BTF ID for the program, instead it assumes it's function
+ * with 6 u64 arguments. No trampoline is created for the program. Such
+ * program can be attached to multiple functions.
+ */
+#define BPF_F_MULTI_FUNC	(1U << 5)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * the following extensions:
  *
-- 
2.31.1

