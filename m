Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EE2535591
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349146AbiEZVf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239426AbiEZVfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D31E64C8;
        Thu, 26 May 2022 14:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8FCFB82208;
        Thu, 26 May 2022 21:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FF2C34116;
        Thu, 26 May 2022 21:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600950;
        bh=mqF8jilsCws+g9Zxa8PAKLUjKcoZ29u8HpwxolUv1LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xk5p1Rx4Ia8G6b+1VoVvU88Q4hlFaq4LKttOOwhvfD15q1MsCYkwPcMcz+D/lOSqa
         QzGOShG5QaKCMYXu5bYsIRITQACgGpukxdQ3AqEyy/MtOP6isC76vxqIRudc6MAfEl
         kYi63413IL4yxjPbA7h3aZUpmtJSdoTwp1dcNSCxJVbUZa6XyqYmddCTROuoBTOThx
         GYekzTP3AZVuZmsJWrHYzaoAUyKpiLrH22nuTmY3SJdFG0afbCwFyxgzzXWacvYBlA
         EWGEv4gt+G0R541U7/keKeY/ZLxTSGl5iAEkD/C61HoRXaUz6YWo700OE7PsULSJaq
         rvBAOh9D8gxtw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 06/14] bpf: Whitelist some fields in nf_conn for BPF_WRITE
Date:   Thu, 26 May 2022 23:34:54 +0200
Message-Id: <2954ab26de09afeecf3a56ba93624f9629072102.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Since we want to allow user to set some fields in nf_conn after it is
allocated but before it is inserted, we can permit BPF_WRITE for normal
nf_conn, and then mark return value as read only on insert, preventing
further BPF_WRITE. This way, nf_conn can be written to using normal
BPF instructions after allocation, but not after insertion.

Note that we special nf_conn a bit here, inside the btf_struct_access
callback for XDP and TC programs. Since this is the only struct for
these programs requiring such adjustments, making this mechanism
more generic has been left as an exercise for a future patch adding
custom callbacks for more structs.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/bpf.h                      | 12 ++---
 include/linux/filter.h                   |  3 ++
 include/net/netfilter/nf_conntrack_bpf.h |  5 +++
 kernel/bpf/verifier.c                    |  6 ++-
 net/core/filter.c                        | 28 ++++++++++++
 net/netfilter/nf_conntrack_bpf.c         | 56 +++++++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c        |  2 +
 7 files changed, 105 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 49e3e7f4b0f9..bc5d8d0e63d1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -640,6 +640,12 @@ struct bpf_prog_ops {
 			union bpf_attr __user *uattr);
 };
 
+typedef int (*btf_struct_access_t)(struct bpf_verifier_log *log,
+				   const struct btf *btf,
+				   const struct btf_type *t, int off, int size,
+				   enum bpf_access_type atype, u32 *next_btf_id,
+				   enum bpf_type_flag *flag);
+
 struct bpf_verifier_ops {
 	/* return eBPF function prototype for verification */
 	const struct bpf_func_proto *
@@ -660,11 +666,7 @@ struct bpf_verifier_ops {
 				  const struct bpf_insn *src,
 				  struct bpf_insn *dst,
 				  struct bpf_prog *prog, u32 *target_size);
-	int (*btf_struct_access)(struct bpf_verifier_log *log,
-				 const struct btf *btf,
-				 const struct btf_type *t, int off, int size,
-				 enum bpf_access_type atype,
-				 u32 *next_btf_id, enum bpf_type_flag *flag);
+	btf_struct_access_t btf_struct_access;
 };
 
 struct bpf_prog_offload_ops {
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ed0c0ff42ad5..95cbf9b28927 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1389,6 +1389,9 @@ struct bpf_sk_lookup_kern {
 
 extern struct static_key_false bpf_sk_lookup_enabled;
 
+extern btf_struct_access_t nf_conn_btf_struct_access;
+extern struct mutex nf_conn_btf_struct_access_mtx;
+
 /* Runners for BPF_SK_LOOKUP programs to invoke on socket lookup.
  *
  * Allowed return values for a BPF SK_LOOKUP program are SK_PASS and
diff --git a/include/net/netfilter/nf_conntrack_bpf.h b/include/net/netfilter/nf_conntrack_bpf.h
index a473b56842c5..15c027549250 100644
--- a/include/net/netfilter/nf_conntrack_bpf.h
+++ b/include/net/netfilter/nf_conntrack_bpf.h
@@ -10,6 +10,7 @@
     (IS_MODULE(CONFIG_NF_CONNTRACK) && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))
 
 extern int register_nf_conntrack_bpf(void);
+extern void unregister_nf_conntrack_bpf(void);
 
 #else
 
@@ -18,6 +19,10 @@ static inline int register_nf_conntrack_bpf(void)
 	return 0;
 }
 
+static inline void unregister_nf_conntrack_bpf(void)
+{
+}
+
 #endif
 
 #endif /* _NF_CONNTRACK_BPF_H */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9b8962e6bc14..8cc754d83521 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13342,6 +13342,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		bpf_convert_ctx_access_t convert_ctx_access;
+		enum bpf_prog_type prog_type;
 		bool ctx_access;
 
 		if (insn->code == (BPF_LDX | BPF_MEM | BPF_B) ||
@@ -13385,6 +13386,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		if (!ctx_access)
 			continue;
 
+		prog_type = resolve_prog_type(env->prog);
 		switch ((int)env->insn_aux_data[i + delta].ptr_type) {
 		case PTR_TO_CTX:
 			if (!ops->convert_ctx_access)
@@ -13409,7 +13411,9 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
-			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
+			} else if (prog_type != BPF_PROG_TYPE_STRUCT_OPS &&
+				   prog_type != BPF_PROG_TYPE_XDP &&
+				   prog_type != BPF_PROG_TYPE_SCHED_CLS) {
 				verbose(env, "Writes through BTF pointers are not allowed\n");
 				return -EINVAL;
 			}
diff --git a/net/core/filter.c b/net/core/filter.c
index 5af58eb48587..bacc39eb9526 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10453,6 +10453,32 @@ static u32 sk_msg_convert_ctx_access(enum bpf_access_type type,
 	return insn - insn_buf;
 }
 
+btf_struct_access_t nf_conn_btf_struct_access;
+/* Protects nf_conn_btf_struct_access */
+DEFINE_MUTEX(nf_conn_btf_struct_access_mtx);
+
+static int xdp_tc_btf_struct_access(struct bpf_verifier_log *log,
+				    const struct btf *btf,
+				    const struct btf_type *t, int off, int size,
+				    enum bpf_access_type atype,
+				    u32 *next_btf_id, enum bpf_type_flag *flag)
+{
+	int ret;
+
+	if (atype == BPF_READ || !READ_ONCE(nf_conn_btf_struct_access))
+		goto end;
+	mutex_lock(&nf_conn_btf_struct_access_mtx);
+	if (!nf_conn_btf_struct_access)
+		goto end_unlock;
+	ret = nf_conn_btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
+	mutex_unlock(&nf_conn_btf_struct_access_mtx);
+	return ret;
+end_unlock:
+	mutex_unlock(&nf_conn_btf_struct_access_mtx);
+end:
+	return btf_struct_access(log, btf, t, off, size, atype, next_btf_id, flag);
+}
+
 const struct bpf_verifier_ops sk_filter_verifier_ops = {
 	.get_func_proto		= sk_filter_func_proto,
 	.is_valid_access	= sk_filter_is_valid_access,
@@ -10470,6 +10496,7 @@ const struct bpf_verifier_ops tc_cls_act_verifier_ops = {
 	.convert_ctx_access	= tc_cls_act_convert_ctx_access,
 	.gen_prologue		= tc_cls_act_prologue,
 	.gen_ld_abs		= bpf_gen_ld_abs,
+	.btf_struct_access	= xdp_tc_btf_struct_access,
 };
 
 const struct bpf_prog_ops tc_cls_act_prog_ops = {
@@ -10481,6 +10508,7 @@ const struct bpf_verifier_ops xdp_verifier_ops = {
 	.is_valid_access	= xdp_is_valid_access,
 	.convert_ctx_access	= xdp_convert_ctx_access,
 	.gen_prologue		= bpf_noop_prologue,
+	.btf_struct_access	= xdp_tc_btf_struct_access,
 };
 
 const struct bpf_prog_ops xdp_prog_ops = {
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 195ec68d309d..fbf58eb74c79 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -9,7 +9,9 @@
 #include <linux/bpf.h>
 #include <linux/btf.h>
 #include <linux/types.h>
+#include <linux/filter.h>
 #include <linux/btf_ids.h>
+#include <linux/bpf_verifier.h>
 #include <linux/net_namespace.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
@@ -257,10 +259,62 @@ static const struct btf_kfunc_id_set nf_conntrack_tc_kfunc_set = {
 	.ret_null_set = &nf_ct_ret_null_kfunc_ids,
 };
 
+BTF_ID_LIST_SINGLE(nf_conn_btf_id, struct, nf_conn)
+
+static int nf_conn_bpf_btf_struct_access(struct bpf_verifier_log *log,
+					 const struct btf *btf,
+					 const struct btf_type *t, int off,
+					 int size, enum bpf_access_type atype,
+					 u32 *next_btf_id,
+					 enum bpf_type_flag *flag)
+{
+	const struct btf_type *nf_conn_t;
+	size_t end;
+
+	WARN_ON_ONCE(atype != BPF_WRITE);
+
+	nf_conn_t = btf_type_by_id(btf, nf_conn_btf_id[0]);
+	if (!nf_conn_t || nf_conn_t != t) {
+		bpf_log(log, "only read is supported");
+		return -EACCES;
+	}
+
+	switch (off) {
+	case offsetof(struct nf_conn, status):
+		end = offsetofend(struct nf_conn, status);
+		break;
+	default:
+		bpf_log(log, "no write support to nf_conn at off %d\n", off);
+		return -EACCES;
+	}
+
+	if (off + size > end) {
+		bpf_log(log,
+			"write access at off %d with size %d beyond the member of nf_conn ended at %zu\n",
+			off, size, end);
+		return -EACCES;
+	}
+
+	return NOT_INIT;
+}
+
 int register_nf_conntrack_bpf(void)
 {
 	int ret;
 
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &nf_conntrack_xdp_kfunc_set);
-	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_tc_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &nf_conntrack_tc_kfunc_set);
+	if (ret < 0)
+		return ret;
+	mutex_lock(&nf_conn_btf_struct_access_mtx);
+	nf_conn_btf_struct_access = nf_conn_bpf_btf_struct_access;
+	mutex_unlock(&nf_conn_btf_struct_access_mtx);
+	return 0;
+}
+
+void unregister_nf_conntrack_bpf(void)
+{
+	mutex_lock(&nf_conn_btf_struct_access_mtx);
+	nf_conn_btf_struct_access = NULL;
+	mutex_unlock(&nf_conn_btf_struct_access_mtx);
 }
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..91f890972f9e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2497,6 +2497,8 @@ void nf_conntrack_cleanup_start(void)
 
 void nf_conntrack_cleanup_end(void)
 {
+	unregister_nf_conntrack_bpf();
+
 	RCU_INIT_POINTER(nf_ct_hook, NULL);
 	cancel_delayed_work_sync(&conntrack_gc_work.dwork);
 	kvfree(nf_conntrack_hash);
-- 
2.35.3

