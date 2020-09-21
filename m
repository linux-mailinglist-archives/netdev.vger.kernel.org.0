Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08278272372
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 14:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgIUMN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 08:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbgIUMNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 08:13:22 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C58FC0613D0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:21 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so12398044wmk.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 05:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7GLKdGadtRCqywVtKFbT45dprprab2ZMte08bVbSQ7k=;
        b=edAb7iXPIsRrGVwjZ/X9knnd1/szvOpGjgTPvznlKPrMtx6F0T4Hp1HwfI1nBcjThK
         2IQcKb/B261jbEXgPSiSGwxrQAyyVte+QggjOMdBldsSCLeelIavTG5DO7lGm1lVKzwo
         PUJGTSm+Mt5N8aHfs1pC575UxKINdJsZmqJ1M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7GLKdGadtRCqywVtKFbT45dprprab2ZMte08bVbSQ7k=;
        b=mq3jgGPj8VPrOHp+Z6HXe3+F3MkkgzZHzPG1nSVrnDJEcTbyx3yfgNY7nDxpuilwiy
         LqOOFJWe9jz5McR7IBr7B+61Xn0U5+qZKJ6i6qHL+YnzKGdj1w7LgaR4g7tS8td464Oi
         vRzje3Mz9uaGMdvlzc3XHb1W/u1JRAucD0NZ179dUXA3JFMbEWcDHwjPuhSvBUGt8mvh
         NtQcxkoIXI8IGRejt3STSAXDAw5vlYgcrZPPZsabUm09+krOjvoZiQH9dEFTRsr9VbX3
         4yCjYJN3dbxOnjWUKlOZAgonCg2LcFHnEeyov+vzZqY7ATQ3tf+GlYbAiZj0RPRmbSAv
         hABg==
X-Gm-Message-State: AOAM533+JymOdbm2LQ9Gi2nqOb1gW98o5PL452qEGUWEWtcR2Zq2lPLj
        3JUoLQuB/d9B+Rg2T95PufrycQ==
X-Google-Smtp-Source: ABdhPJwziIGeta9/FLnysQOcduZwQuChpkppcMQShdGRhsFuL2iNpYeO6GvejGv/XCPxVKUnz4ZSdA==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr31644025wmc.154.1600690400028;
        Mon, 21 Sep 2020 05:13:20 -0700 (PDT)
Received: from antares.lan (5.4.6.2.d.5.3.3.f.8.1.6.b.2.d.8.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:8d2b:618f:335d:2645])
        by smtp.gmail.com with ESMTPSA id t15sm18466557wmj.15.2020.09.21.05.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 05:13:19 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v4 04/11] bpf: allow specifying a BTF ID per argument in function protos
Date:   Mon, 21 Sep 2020 13:12:20 +0100
Message-Id: <20200921121227.255763-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921121227.255763-1-lmb@cloudflare.com>
References: <20200921121227.255763-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function prototypes using ARG_PTR_TO_BTF_ID currently use two ways to signal
which BTF IDs are acceptable. First, bpf_func_proto.btf_id is an array of
IDs, one for each argument. This array is only accessed up to the highest
numbered argument that uses ARG_PTR_TO_BTF_ID and may therefore be less than
five arguments long. It usually points at a BTF_ID_LIST. Second, check_btf_id
is a function pointer that is called by the verifier if present. It gets the
actual BTF ID of the register, and the argument number we're currently checking.
It turns out that the only user check_arg_btf_id ignores the argument, and is
simply used to check whether the BTF ID has a struct sock_common at it's start.

Replace both of these mechanisms with an explicit BTF ID for each argument
in a function proto. Thanks to btf_struct_ids_match this is very flexible:
check_arg_btf_id can be replaced by requiring struct sock_common.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h            | 18 +++++++-------
 kernel/bpf/bpf_inode_storage.c |  8 +++----
 kernel/bpf/btf.c               | 13 ----------
 kernel/bpf/stackmap.c          |  5 ++--
 kernel/bpf/verifier.c          | 44 +++++++++++++++++-----------------
 kernel/trace/bpf_trace.c       | 15 ++++--------
 net/core/bpf_sk_storage.c      |  8 ++-----
 net/core/filter.c              | 31 +++++++-----------------
 net/ipv4/bpf_tcp_ca.c          | 19 ++++-----------
 9 files changed, 58 insertions(+), 103 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4cbf92f5ecdb..732e2f144b6d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -326,12 +326,16 @@ struct bpf_func_proto {
 		};
 		enum bpf_arg_type arg_type[5];
 	};
-	int *btf_id; /* BTF ids of arguments */
-	bool (*check_btf_id)(u32 btf_id, u32 arg); /* if the argument btf_id is
-						    * valid. Often used if more
-						    * than one btf id is permitted
-						    * for this argument.
-						    */
+	union {
+		struct {
+			u32 *arg1_btf_id;
+			u32 *arg2_btf_id;
+			u32 *arg3_btf_id;
+			u32 *arg4_btf_id;
+			u32 *arg5_btf_id;
+		};
+		u32 *arg_btf_id[5];
+	};
 	int *ret_btf_id; /* return value btf_id */
 	bool (*allowed)(const struct bpf_prog *prog);
 };
@@ -1381,8 +1385,6 @@ int btf_struct_access(struct bpf_verifier_log *log,
 		      u32 *next_btf_id);
 bool btf_struct_ids_match(struct bpf_verifier_log *log,
 			  int off, u32 id, u32 need_type_id);
-int btf_resolve_helper_id(struct bpf_verifier_log *log,
-			  const struct bpf_func_proto *fn, int);
 
 int btf_distill_func_proto(struct bpf_verifier_log *log,
 			   struct btf *btf,
diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index 75be02799c0f..6edff97ad594 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -249,9 +249,7 @@ const struct bpf_map_ops inode_storage_map_ops = {
 	.map_owner_storage_ptr = inode_storage_ptr,
 };
 
-BTF_ID_LIST(bpf_inode_storage_btf_ids)
-BTF_ID_UNUSED
-BTF_ID(struct, inode)
+BTF_ID_LIST_SINGLE(bpf_inode_storage_btf_ids, struct, inode)
 
 const struct bpf_func_proto bpf_inode_storage_get_proto = {
 	.func		= bpf_inode_storage_get,
@@ -259,9 +257,9 @@ const struct bpf_func_proto bpf_inode_storage_get_proto = {
 	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
 	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
-	.btf_id		= bpf_inode_storage_btf_ids,
 };
 
 const struct bpf_func_proto bpf_inode_storage_delete_proto = {
@@ -270,5 +268,5 @@ const struct bpf_func_proto bpf_inode_storage_delete_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_PTR_TO_BTF_ID,
-	.btf_id		= bpf_inode_storage_btf_ids,
+	.arg2_btf_id	= &bpf_inode_storage_btf_ids[0],
 };
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index a2330f6fe2e6..5d3c36e13139 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4193,19 +4193,6 @@ bool btf_struct_ids_match(struct bpf_verifier_log *log,
 	return true;
 }
 
-int btf_resolve_helper_id(struct bpf_verifier_log *log,
-			  const struct bpf_func_proto *fn, int arg)
-{
-	int id;
-
-	if (fn->arg_type[arg] != ARG_PTR_TO_BTF_ID || !btf_vmlinux)
-		return -EINVAL;
-	id = fn->btf_id[arg];
-	if (!id || id > btf_vmlinux->nr_types)
-		return -EINVAL;
-	return id;
-}
-
 static int __get_type_size(struct btf *btf, u32 btf_id,
 			   const struct btf_type **bad_type)
 {
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index a2fa006f430e..06065fa27124 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -665,18 +665,17 @@ BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
 	return __bpf_get_stack(regs, task, NULL, buf, size, flags);
 }
 
-BTF_ID_LIST(bpf_get_task_stack_btf_ids)
-BTF_ID(struct, task_struct)
+BTF_ID_LIST_SINGLE(bpf_get_task_stack_btf_ids, struct, task_struct)
 
 const struct bpf_func_proto bpf_get_task_stack_proto = {
 	.func		= bpf_get_task_stack,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_get_task_stack_btf_ids[0],
 	.arg2_type	= ARG_PTR_TO_UNINIT_MEM,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
 	.arg4_type	= ARG_ANYTHING,
-	.btf_id		= bpf_get_task_stack_btf_ids,
 };
 
 BPF_CALL_4(bpf_get_stack_pe, struct bpf_perf_event_data_kern *, ctx,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c997f81c500b..9f95d6d55c5f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -238,7 +238,6 @@ struct bpf_call_arg_meta {
 	u64 msize_max_value;
 	int ref_obj_id;
 	int func_id;
-	u32 btf_id;
 };
 
 struct btf *btf_vmlinux;
@@ -4002,29 +4001,23 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 				goto err_type;
 		}
 	} else if (arg_type == ARG_PTR_TO_BTF_ID) {
-		bool ids_match = false;
+		const u32 *btf_id = fn->arg_btf_id[arg];
 
 		expected_type = PTR_TO_BTF_ID;
 		if (type != expected_type)
 			goto err_type;
-		if (!fn->check_btf_id) {
-			if (reg->btf_id != meta->btf_id) {
-				ids_match = btf_struct_ids_match(&env->log, reg->off, reg->btf_id,
-								 meta->btf_id);
-				if (!ids_match) {
-					verbose(env, "Helper has type %s got %s in R%d\n",
-						kernel_type_name(meta->btf_id),
-						kernel_type_name(reg->btf_id), regno);
-					return -EACCES;
-				}
-			}
-		} else if (!fn->check_btf_id(reg->btf_id, arg)) {
-			verbose(env, "Helper does not support %s in R%d\n",
-				kernel_type_name(reg->btf_id), regno);
 
+		if (!btf_id) {
+			verbose(env, "verifier internal error: missing BTF ID\n");
+			return -EFAULT;
+		}
+
+		if (!btf_struct_ids_match(&env->log, reg->off, reg->btf_id, *btf_id)) {
+			verbose(env, "R%d is of type %s but %s is expected\n",
+				regno, kernel_type_name(reg->btf_id), kernel_type_name(*btf_id));
 			return -EACCES;
 		}
-		if ((reg->off && !ids_match) || !tnum_is_const(reg->var_off) || reg->var_off.value) {
+		if (!tnum_is_const(reg->var_off) || reg->var_off.value) {
 			verbose(env, "R%d is a pointer to in-kernel struct with non-zero offset\n",
 				regno);
 			return -EACCES;
@@ -4493,10 +4486,22 @@ static bool check_refcount_ok(const struct bpf_func_proto *fn, int func_id)
 	return count <= 1;
 }
 
+static bool check_btf_id_ok(const struct bpf_func_proto *fn)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
+		if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
+			return false;
+
+	return true;
+}
+
 static int check_func_proto(const struct bpf_func_proto *fn, int func_id)
 {
 	return check_raw_mode_ok(fn) &&
 	       check_arg_pair_ok(fn) &&
+	       check_btf_id_ok(fn) &&
 	       check_refcount_ok(fn, func_id) ? 0 : -EINVAL;
 }
 
@@ -4892,11 +4897,6 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
 	meta.func_id = func_id;
 	/* check args */
 	for (i = 0; i < 5; i++) {
-		if (!fn->check_btf_id) {
-			err = btf_resolve_helper_id(&env->log, fn, i);
-			if (err > 0)
-				meta.btf_id = err;
-		}
 		err = check_func_arg(env, i, &meta, fn);
 		if (err)
 			return err;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b2a5380eb187..ebf9be4d0d6a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -743,19 +743,18 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
 	return err;
 }
 
-BTF_ID_LIST(bpf_seq_printf_btf_ids)
-BTF_ID(struct, seq_file)
+BTF_ID_LIST_SINGLE(btf_seq_file_ids, struct, seq_file)
 
 static const struct bpf_func_proto bpf_seq_printf_proto = {
 	.func		= bpf_seq_printf,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &btf_seq_file_ids[0],
 	.arg2_type	= ARG_PTR_TO_MEM,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type      = ARG_PTR_TO_MEM_OR_NULL,
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
-	.btf_id		= bpf_seq_printf_btf_ids,
 };
 
 BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
@@ -763,17 +762,14 @@ BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
 	return seq_write(m, data, len) ? -EOVERFLOW : 0;
 }
 
-BTF_ID_LIST(bpf_seq_write_btf_ids)
-BTF_ID(struct, seq_file)
-
 static const struct bpf_func_proto bpf_seq_write_proto = {
 	.func		= bpf_seq_write,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &btf_seq_file_ids[0],
 	.arg2_type	= ARG_PTR_TO_MEM,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
-	.btf_id		= bpf_seq_write_btf_ids,
 };
 
 static __always_inline int
@@ -1130,17 +1126,16 @@ static bool bpf_d_path_allowed(const struct bpf_prog *prog)
 	return btf_id_set_contains(&btf_allowlist_d_path, prog->aux->attach_btf_id);
 }
 
-BTF_ID_LIST(bpf_d_path_btf_ids)
-BTF_ID(struct, path)
+BTF_ID_LIST_SINGLE(bpf_d_path_btf_ids, struct, path)
 
 static const struct bpf_func_proto bpf_d_path_proto = {
 	.func		= bpf_d_path,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_d_path_btf_ids[0],
 	.arg2_type	= ARG_PTR_TO_MEM,
 	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
-	.btf_id		= bpf_d_path_btf_ids,
 	.allowed	= bpf_d_path_allowed,
 };
 
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4a86ea34f29e..d653a583dbc9 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -378,19 +378,15 @@ const struct bpf_func_proto bpf_sk_storage_delete_proto = {
 	.arg2_type	= ARG_PTR_TO_SOCKET,
 };
 
-BTF_ID_LIST(sk_storage_btf_ids)
-BTF_ID_UNUSED
-BTF_ID(struct, sock)
-
 const struct bpf_func_proto sk_storage_get_btf_proto = {
 	.func		= bpf_sk_storage_get,
 	.gpl_only	= false,
 	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_PTR_TO_BTF_ID,
+	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
 	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
-	.btf_id		= sk_storage_btf_ids,
 };
 
 const struct bpf_func_proto sk_storage_delete_btf_proto = {
@@ -399,7 +395,7 @@ const struct bpf_func_proto sk_storage_delete_btf_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,
 	.arg2_type	= ARG_PTR_TO_BTF_ID,
-	.btf_id		= sk_storage_btf_ids,
+	.arg2_btf_id	= &btf_sock_ids[BTF_SOCK_TYPE_SOCK],
 };
 
 struct bpf_sk_storage_diag {
diff --git a/net/core/filter.c b/net/core/filter.c
index d266c6941967..6014e5f40c58 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3803,19 +3803,18 @@ static const struct bpf_func_proto bpf_skb_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-BTF_ID_LIST(bpf_skb_output_btf_ids)
-BTF_ID(struct, sk_buff)
+BTF_ID_LIST_SINGLE(bpf_skb_output_btf_ids, struct, sk_buff)
 
 const struct bpf_func_proto bpf_skb_output_proto = {
 	.func		= bpf_skb_event_output,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_skb_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_MEM,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
-	.btf_id		= bpf_skb_output_btf_ids,
 };
 
 static unsigned short bpf_tunnel_key_af(u64 flags)
@@ -4199,19 +4198,18 @@ static const struct bpf_func_proto bpf_xdp_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-BTF_ID_LIST(bpf_xdp_output_btf_ids)
-BTF_ID(struct, xdp_buff)
+BTF_ID_LIST_SINGLE(bpf_xdp_output_btf_ids, struct, xdp_buff)
 
 const struct bpf_func_proto bpf_xdp_output_proto = {
 	.func		= bpf_xdp_event_output,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &bpf_xdp_output_btf_ids[0],
 	.arg2_type	= ARG_CONST_MAP_PTR,
 	.arg3_type	= ARG_ANYTHING,
 	.arg4_type	= ARG_PTR_TO_MEM,
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
-	.btf_id		= bpf_xdp_output_btf_ids,
 };
 
 BPF_CALL_1(bpf_get_socket_cookie, struct sk_buff *, skb)
@@ -9897,17 +9895,6 @@ BTF_SOCK_TYPE_xxx
 u32 btf_sock_ids[MAX_BTF_SOCK_TYPE];
 #endif
 
-static bool check_arg_btf_id(u32 btf_id, u32 arg)
-{
-	int i;
-
-	/* only one argument, no need to check arg */
-	for (i = 0; i < MAX_BTF_SOCK_TYPE; i++)
-		if (btf_sock_ids[i] == btf_id)
-			return true;
-	return false;
-}
-
 BPF_CALL_1(bpf_skc_to_tcp6_sock, struct sock *, sk)
 {
 	/* tcp6_sock type is not generated in dwarf and hence btf,
@@ -9926,7 +9913,7 @@ const struct bpf_func_proto bpf_skc_to_tcp6_sock_proto = {
 	.gpl_only		= false,
 	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
 	.arg1_type		= ARG_PTR_TO_BTF_ID,
-	.check_btf_id		= check_arg_btf_id,
+	.arg1_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP6],
 };
 
@@ -9943,7 +9930,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_sock_proto = {
 	.gpl_only		= false,
 	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
 	.arg1_type		= ARG_PTR_TO_BTF_ID,
-	.check_btf_id		= check_arg_btf_id,
+	.arg1_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP],
 };
 
@@ -9967,7 +9954,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_timewait_sock_proto = {
 	.gpl_only		= false,
 	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
 	.arg1_type		= ARG_PTR_TO_BTF_ID,
-	.check_btf_id		= check_arg_btf_id,
+	.arg1_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP_TW],
 };
 
@@ -9991,7 +9978,7 @@ const struct bpf_func_proto bpf_skc_to_tcp_request_sock_proto = {
 	.gpl_only		= false,
 	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
 	.arg1_type		= ARG_PTR_TO_BTF_ID,
-	.check_btf_id		= check_arg_btf_id,
+	.arg1_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_TCP_REQ],
 };
 
@@ -10013,6 +10000,6 @@ const struct bpf_func_proto bpf_skc_to_udp6_sock_proto = {
 	.gpl_only		= false,
 	.ret_type		= RET_PTR_TO_BTF_ID_OR_NULL,
 	.arg1_type		= ARG_PTR_TO_BTF_ID,
-	.check_btf_id		= check_arg_btf_id,
+	.arg1_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.ret_btf_id		= &btf_sock_ids[BTF_SOCK_TYPE_UDP6],
 };
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index e3939f76b024..74a2ef598c31 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -28,23 +28,18 @@ static u32 unsupported_ops[] = {
 static const struct btf_type *tcp_sock_type;
 static u32 tcp_sock_id, sock_id;
 
-static int btf_sk_storage_get_ids[5];
 static struct bpf_func_proto btf_sk_storage_get_proto __read_mostly;
-
-static int btf_sk_storage_delete_ids[5];
 static struct bpf_func_proto btf_sk_storage_delete_proto __read_mostly;
 
-static void convert_sk_func_proto(struct bpf_func_proto *to, int *to_btf_ids,
-				  const struct bpf_func_proto *from)
+static void convert_sk_func_proto(struct bpf_func_proto *to, const struct bpf_func_proto *from)
 {
 	int i;
 
 	*to = *from;
-	to->btf_id = to_btf_ids;
 	for (i = 0; i < ARRAY_SIZE(to->arg_type); i++) {
 		if (to->arg_type[i] == ARG_PTR_TO_SOCKET) {
 			to->arg_type[i] = ARG_PTR_TO_BTF_ID;
-			to->btf_id[i] = tcp_sock_id;
+			to->arg_btf_id[i] = &tcp_sock_id;
 		}
 	}
 }
@@ -64,12 +59,8 @@ static int bpf_tcp_ca_init(struct btf *btf)
 	tcp_sock_id = type_id;
 	tcp_sock_type = btf_type_by_id(btf, tcp_sock_id);
 
-	convert_sk_func_proto(&btf_sk_storage_get_proto,
-			      btf_sk_storage_get_ids,
-			      &bpf_sk_storage_get_proto);
-	convert_sk_func_proto(&btf_sk_storage_delete_proto,
-			      btf_sk_storage_delete_ids,
-			      &bpf_sk_storage_delete_proto);
+	convert_sk_func_proto(&btf_sk_storage_get_proto, &bpf_sk_storage_get_proto);
+	convert_sk_func_proto(&btf_sk_storage_delete_proto, &bpf_sk_storage_delete_proto);
 
 	return 0;
 }
@@ -185,8 +176,8 @@ static const struct bpf_func_proto bpf_tcp_send_ack_proto = {
 	/* In case we want to report error later */
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &tcp_sock_id,
 	.arg2_type	= ARG_ANYTHING,
-	.btf_id		= &tcp_sock_id,
 };
 
 static const struct bpf_func_proto *
-- 
2.25.1

