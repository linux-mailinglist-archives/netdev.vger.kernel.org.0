Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097CA478279
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhLQBu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhLQBut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:49 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AC2C061574;
        Thu, 16 Dec 2021 17:50:49 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id gn2so801184pjb.5;
        Thu, 16 Dec 2021 17:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xo5q60afEWgREzM5sLe/IoVcylIUjR0QOUufH5H48v8=;
        b=n5WVx06XhLhjmh4kbyc8H0DLfAXGZt3B535uXQ0OqqF8rcOoIIEq38dwMXVQA3PiD4
         ECILz0huM2l7rR/cAoRQ8IG15Y7xJphnnbev6KtRMRqN+5XT7bK0//jlGdnoh2TntKZk
         M4xnp4upjJWN+2eKm7e47LbMb9hwidD6bv5+Rz0MElzSwkVYpsXCdpbOTL5XIhEmqZmP
         IKXixwDaaO5NlHYzjzdRJSPae/o+dSEYJDGHvhfdo4WOOl894/huv2Jyj9+yt8ToxwTA
         SIHC2miKWf3i7otC1ulay8gqhEQwrZh4evoobDPnzLXNE9HmZRQmHRhDg7NJln5H3rXl
         nt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xo5q60afEWgREzM5sLe/IoVcylIUjR0QOUufH5H48v8=;
        b=RxXLRIMZN68VbzN9D8kHeYrOQ2Oef0RvefgwhpMw63nVX6/sWE0/J2dsrglQr5NyFJ
         tmS7jhH4MSqgOoIy8KnymfAbUmbu35qWLma0ZxqLMlCcWvLjEbsQo1oIuNOapL4Dy0GJ
         eNk2Kv871mskIhYj/qT/sJYraL/sQsBP595Y+8kFLdTtDeY0FpJUkk+4+bm8QVI7d2VJ
         Vn+zuXPVSGBerOjDFPhK+ToXgxLuhkIdCYXdGcXWDEAimJ/ef229HB5uDX5C13rGResg
         zl1saDH/op0muA+uyrC48grLhrFCIT08AKvZsESpexSfPxTzL5clxxVWxfc0weiArMKT
         /G/w==
X-Gm-Message-State: AOAM531RC6DJJCCem/QcJGoGsB/inXvswVGYKSS+D/a//Yl7GogXq1XY
        SxNZFjznRw67TpWyKO6mOTWuta3xw40=
X-Google-Smtp-Source: ABdhPJzlKDqi79DkTXBKHLFvLRLDGSLyLVf8Ty3TKrKWQCKDzcAf99YXRJGMjxjv9lcDRR1pKEa3qA==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr1048425pjb.99.1639705848966;
        Thu, 16 Dec 2021 17:50:48 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id u32sm7957445pfg.220.2021.12.16.17.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:48 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 05/10] bpf: Add reference tracking support to kfunc
Date:   Fri, 17 Dec 2021 07:20:26 +0530
Message-Id: <20211217015031.1278167-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15043; h=from:subject; bh=Bdkkg0jFMETEDIFRk1yA8EuNFLsqhHSF/66IVc0vrPY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFLM7oXV/hFCh9JaIkTivTH2t3NbpbnlcCREmH yBTVIV2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8Ryg8ED/ 4lc3DCNGky/P4PKYWoufLvykHjWIuw9b+KpfXfENQAeurf8uxigQjJog1O1K3ssA14pAk8M5cdrz0p ELtfNnMyZwcLk8Hi15APW7prTYDfeS2mXRITMuZAAItoYVDYkmKdmkSi8/a0MJnfMNhUi3eK7rlhB8 B3bJAW/+fCPlShEmYte9oGFSAhre8OQybpyA3FvCkN75rA05YGcPvjhtz2nIPoqTg6V/n96OzyE+6O eJQ2qUyaXCH3NF7W6qxj1AT+Gzi0Iow9w+gM+KCcUIzA2WBfMTFmtCJKPY5pDozZHGsqfB1kn5JAHc ZZO7dHPXll4VttuOdiKugaIXEPlWOc2HfvQrBeYWNX5kG2EkWFEE6KssmqgwG7USB77XsGN6ZZCv4S fQJibH7q8vQOZCQSbh2MA9wL6Dja8mmyJl4LEoK2HmWqNNLrDXudI5ADM5hW5pjbBLdi85/BojLD0+ tnysscgCkBrySmOx0DFgUUxIjh5oMOI9NtQ9Y6RQ8t9I3f5km/PDXTS1pmmfjWCrrsrVrh7g+ZcjAw 3PrNfbIqa+e5Ffo4ucymUG6THB15JSqUNI2JIJu/jz5yZUuXczDON+/Lht6TDAUiUcArpfPBenI6eW W0AT5ng/d7ESJF072kYYiTKnEMbz4hfk/KxOOQaLK/eOo/Xdf+wVSOP9rbyQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds verifier support for PTR_TO_BTF_ID return type of kfunc
to be a reference, by reusing acquire_reference_state/release_reference
support for existing in-kernel bpf helpers.

Verifier ops struct is extended with three callbacks:

- is_acquire_kfunc
  Return true if kfunc_btf_id, module pair is an acquire kfunc.  This
  will acquire_reference_state for the returned PTR_TO_BTF_ID (this is
  the only allow return value). Note that acquire kfunc must always
  return a PTR_TO_BTF_ID{_OR_NULL}, otherwise the program is rejected.

- is_release_kfunc
  Return true if kfunc_btf_id, module pair is a release kfunc.  This
  will release the reference to the passed in PTR_TO_BTF_ID which has a
  reference state (from earlier acquire kfunc).
  The btf_check_func_arg_match returns the regno (of argument register,
  hence > 0) if the kfunc is a release kfunc, and a proper referenced
  PTR_TO_BTF_ID is being passed to it.
  This is similar to how helper call check uses bpf_call_arg_meta to
  store the ref_obj_id that is later used to release the reference.
  Similar to in-kernel helper, we only allow passing one referenced
  PTR_TO_BTF_ID as an argument. It can also be passed in to normal
  kfunc, but in case of release kfunc there must always be one
  PTR_TO_BTF_ID argument that is referenced.

- is_kfunc_ret_type_null
  For kfunc returning PTR_TO_BTF_ID, tells if it can be NULL, hence
  force caller to mark the pointer not null (using check) before
  accessing it. Note that taking into account the case fixed by commit
  93c230e3f5bd ("bpf: Enforce id generation for all may-be-null register type")
  we assign a non-zero id for mark_ptr_or_null_reg logic. Later, if more
  return types are supported by kfunc, which have a _OR_NULL variant, it
  might be better to move this id generation under a common
  reg_type_may_be_null check, similar to the case in the commit.

Later patches will implement these callbacks.

Referenced PTR_TO_BTF_ID is currently only limited to kfunc, but can be
extended in the future to other BPF helpers as well.  For now, we can
rely on the btf_struct_ids_match check to ensure we get the pointer to
the expected struct type. In the future, care needs to be taken to avoid
ambiguity for reference PTR_TO_BTF_ID passed to release function, in
case multiple candidates can release same BTF ID.

e.g. there might be two release kfuncs (or kfunc and helper):

foo(struct abc *p);
bar(struct abc *p);

... such that both release a PTR_TO_BTF_ID with btf_id of struct abc. In
this case we would need to track the acquire function corresponding to
the release function to avoid type confusion, and store this information
in the register state so that an incorrect program can be rejected. This
is not a problem right now, hence it is left as an exercise for the
future patch introducing such a case in the kernel.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h   |  6 ++++-
 include/linux/btf.h   | 30 +++++++++++++++++++++-
 kernel/bpf/btf.c      | 60 ++++++++++++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 54 +++++++++++++++++++++++++++++++++-----
 4 files changed, 135 insertions(+), 15 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 965fffaf0308..015cb633838b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -521,6 +521,9 @@ struct bpf_verifier_ops {
 				 enum bpf_access_type atype,
 				 u32 *next_btf_id);
 	bool (*check_kfunc_call)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_acquire_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_release_kfunc)(u32 kfunc_btf_id, struct module *owner);
+	bool (*is_kfunc_ret_type_null)(u32 kfunc_btf_id, struct module *owner);
 };
 
 struct bpf_prog_offload_ops {
@@ -1712,7 +1715,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs);
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5fefa6c2e62c..64c3784799c5 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -321,7 +321,10 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 #endif
 
 enum kfunc_btf_id_set_type {
-	BTF_SET_CHECK,
+	BTF_SET_CHECK,    /* Allowed kfunc set */
+	BTF_SET_ACQUIRE,  /* Acquire kfunc set */
+	BTF_SET_RELEASE,  /* Release kfunc set */
+	BTF_SET_RET_NULL, /* kfunc with 'return type PTR_TO_BTF_ID_OR_NULL' set */
 	__BTF_SET_MAX,
 };
 
@@ -331,6 +334,9 @@ struct kfunc_btf_id_set {
 		struct btf_id_set *sets[__BTF_SET_MAX];
 		struct {
 			struct btf_id_set *set;
+			struct btf_id_set *acq_set;
+			struct btf_id_set *rel_set;
+			struct btf_id_set *null_set;
 		};
 	};
 	struct module *owner;
@@ -348,6 +354,12 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 				 struct kfunc_btf_id_set *s);
 bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 			      struct module *owner);
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner);
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner);
 
 extern struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list;
 extern struct kfunc_btf_id_list prog_test_kfunc_list;
@@ -365,6 +377,22 @@ static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
 {
 	return false;
 }
+static inline bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist,
+					    u32 kfunc_id, struct module *owner)
+{
+	return false;
+}
+static inline bool
+bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			       struct module *owner)
+{
+	return false;
+}
 
 static struct kfunc_btf_id_list bpf_tcp_ca_kfunc_list __maybe_unused;
 static struct kfunc_btf_id_list prog_test_kfunc_list __maybe_unused;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 04e80dd6de2e..4983b54c1d81 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5639,14 +5639,17 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
-				    bool ptr_to_mem_ok)
+				    bool ptr_to_mem_ok,
+				    struct module *btf_mod)
 {
 	struct bpf_verifier_log *log = &env->log;
+	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
-	u32 i, nargs, ref_id;
+	int ref_regno = 0;
+	bool rel = false;
 
 	t = btf_type_by_id(btf, func_id);
 	if (!t || !btf_type_is_func(t)) {
@@ -5724,6 +5727,16 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			if (reg->type == PTR_TO_BTF_ID) {
 				reg_btf = reg->btf;
 				reg_ref_id = reg->btf_id;
+				/* Ensure only one argument is referenced PTR_TO_BTF_ID */
+				if (reg->ref_obj_id) {
+					if (ref_obj_id) {
+						bpf_log(log, "verifier internal error: more than one arg with ref_obj_id R%d %u %u\n",
+							regno, reg->ref_obj_id, ref_obj_id);
+						return -EFAULT;
+					}
+					ref_regno = regno;
+					ref_obj_id = reg->ref_obj_id;
+				}
 			} else {
 				reg_btf = btf_vmlinux;
 				reg_ref_id = *reg2btf_ids[reg->type];
@@ -5793,7 +5806,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		}
 	}
 
-	return 0;
+	/* Either both are set, or neither */
+	WARN_ON_ONCE((ref_obj_id && !ref_regno) || (!ref_obj_id && ref_regno));
+	if (is_kfunc) {
+		rel = env->ops->is_release_kfunc &&
+			env->ops->is_release_kfunc(func_id, btf_mod);
+		/* We already made sure ref_obj_id is set only for one argument */
+		if (rel && !ref_obj_id) {
+			bpf_log(log, "release kernel function %s expects refcounted PTR_TO_BTF_ID\n",
+				func_name);
+			return -EINVAL;
+		}
+		/* Allow (!rel && ref_obj_id), so that passing such referenced PTR_TO_BTF_ID to
+		 * other kfuncs works
+		 */
+	}
+	/* returns argument register number > 0 in case of reference release kfunc */
+	return rel ? ref_regno : 0;
 }
 
 /* Compare BTF of a function with given bpf_reg_state.
@@ -5823,7 +5852,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -5836,9 +5865,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs)
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod)
 {
-	return btf_check_func_arg_match(env, btf, func_id, regs, true);
+	return btf_check_func_arg_match(env, btf, func_id, regs, true, btf_mod);
 }
 
 /* Convert BTF of a function into bpf_reg_state if possible
@@ -6503,6 +6533,24 @@ bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
 	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
+bool bpf_is_mod_acquire_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_ACQUIRE);
+}
+
+bool bpf_is_mod_release_kfunc(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RELEASE);
+}
+
+bool bpf_is_mod_kfunc_ret_type_null(struct kfunc_btf_id_list *klist,
+				    u32 kfunc_id, struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_RET_NULL);
+}
+
 #define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
 	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
 					  __MUTEX_INITIALIZER(name.mutex) };   \
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0fc2e581a10e..3ea98e45889d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -467,7 +467,9 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+		type == PTR_TO_MEM_OR_NULL ||
+		type == PTR_TO_BTF_ID ||
+		type == PTR_TO_BTF_ID_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -6768,16 +6770,18 @@ static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 regno,
 	}
 }
 
-static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
+static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
+			    int *insn_idx_p)
 {
 	const struct btf_type *t, *func, *func_proto, *ptr_type;
 	struct bpf_reg_state *regs = cur_regs(env);
 	const char *func_name, *ptr_type_name;
 	u32 i, nargs, func_id, ptr_type_id;
+	int err, insn_idx = *insn_idx_p;
 	struct module *btf_mod = NULL;
 	const struct btf_param *args;
 	struct btf *desc_btf;
-	int err;
+	bool acq;
 
 	/* skip for now, but return error when we find this in fixup_kfunc_call */
 	if (!insn->imm)
@@ -6799,16 +6803,37 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		return -EACCES;
 	}
 
+	/* Is this an acquire kfunc? */
+	acq = env->ops->is_acquire_kfunc &&
+		env->ops->is_acquire_kfunc(func_id, btf_mod);
+
 	/* Check the arguments */
-	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs);
-	if (err)
+	err = btf_check_kfunc_arg_match(env, desc_btf, func_id, regs, btf_mod);
+	if (err < 0)
 		return err;
+	/* In case of release function, we get register number of refcounted
+	 * PTR_TO_BTF_ID back from btf_check_kfunc_arg_match, do the release now
+	 */
+	if (err) {
+		err = release_reference(env, regs[err].ref_obj_id);
+		if (err) {
+			verbose(env, "kfunc %s#%d reference has not been acquired before\n",
+				func_name, func_id);
+			return err;
+		}
+	}
 
 	for (i = 0; i < CALLER_SAVED_REGS; i++)
 		mark_reg_not_init(env, regs, caller_saved[i]);
 
 	/* Check return type */
 	t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
+
+	if (acq && !btf_type_is_ptr(t)) {
+		verbose(env, "acquire kernel function does not return PTR_TO_BTF_ID\n");
+		return -EINVAL;
+	}
+
 	if (btf_type_is_scalar(t)) {
 		mark_reg_unknown(env, regs, BPF_REG_0);
 		mark_btf_func_reg_size(env, BPF_REG_0, t->size);
@@ -6823,11 +6848,26 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
 				ptr_type_name);
 			return -EINVAL;
 		}
+		if (env->ops->is_kfunc_ret_type_null &&
+		    env->ops->is_kfunc_ret_type_null(func_id, btf_mod)) {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID_OR_NULL;
+			/* For mark_ptr_or_null_reg, see 93c230e3f5bd6 */
+			regs[BPF_REG_0].id = ++env->id_gen;
+		} else {
+			regs[BPF_REG_0].type = PTR_TO_BTF_ID;
+		}
 		mark_reg_known_zero(env, regs, BPF_REG_0);
 		regs[BPF_REG_0].btf = desc_btf;
-		regs[BPF_REG_0].type = PTR_TO_BTF_ID;
 		regs[BPF_REG_0].btf_id = ptr_type_id;
 		mark_btf_func_reg_size(env, BPF_REG_0, sizeof(void *));
+		if (acq) {
+			int id = acquire_reference_state(env, insn_idx);
+
+			if (id < 0)
+				return id;
+			regs[BPF_REG_0].id = id;
+			regs[BPF_REG_0].ref_obj_id = id;
+		}
 	} /* else { add_kfunc_call() ensures it is btf_type_is_void(t) } */
 
 	nargs = btf_type_vlen(func_proto);
@@ -11472,7 +11512,7 @@ static int do_check(struct bpf_verifier_env *env)
 				if (insn->src_reg == BPF_PSEUDO_CALL)
 					err = check_func_call(env, insn, &env->insn_idx);
 				else if (insn->src_reg == BPF_PSEUDO_KFUNC_CALL)
-					err = check_kfunc_call(env, insn);
+					err = check_kfunc_call(env, insn, &env->insn_idx);
 				else
 					err = check_helper_call(env, insn, &env->insn_idx);
 				if (err)
-- 
2.34.1

