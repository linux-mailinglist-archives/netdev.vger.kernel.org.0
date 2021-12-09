Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0803746F11C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242562AbhLIRNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242497AbhLIRNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:22 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93F0C061746;
        Thu,  9 Dec 2021 09:09:48 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso5370047pjb.2;
        Thu, 09 Dec 2021 09:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0H+SFpDipuPYsh8XkEmXGCZW+0yEheTtzHYQkBTHQ4Q=;
        b=a5DHLNYxVxtasrkCKuBWetvh7dFZfHmRPK6Qd+Xb7FhNogkZ7cina+n1ffPT5WGsDx
         cWaM/kr/W/VbnPN8VLYl7TPe0IutAhjqgFxEPt78gHytP3+FDXCVoXQdZHSFQEdFM3R+
         EgmROkjKnWxWcoH2aaUY0u00UB+DDPrsEy/wWHaOhXmUbwa/7O7O2kTvQIYn7pQ4ui/h
         mtlfAodlv3Xn/syGQA6WwnrSbs5058a0l05i5/6r0ntfDkKbHxCeiMxLdi2rvW4Z7Ogx
         mMkBnxI01iW64HUHlxaItGX/rhmjSlYWsu6nPhRBKCpW9nop0/DSHrpC854JrKl50D1u
         IMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0H+SFpDipuPYsh8XkEmXGCZW+0yEheTtzHYQkBTHQ4Q=;
        b=2uPLSW1/obbOwQmszl5nFF9ZIZH+Jn7OkWFoxm5SDojbY3+CSbKeo41CB/hJCVbuXf
         odRhzBiSPInTjaB4kK3BLjMdOJKQuFFMTEsGcOGqxMTo+9cfD+uScIdAE0WwVmiLgSoR
         SIztCdw/ZF5xlvBUN3sqNZeoYCFYTkSAmluvbeI2BSROM+mcLeZpwWIilYQPmawZV8rQ
         catxrjsbAHWJ/MI3pyJP5/pPnb8UpwaJo+h6iqObbXJMbbadACgBsCgfbL8+NjJWCKLZ
         SaDuCaoRtwCj/hzJNQakh5moaSVtBVtSFVDdjB5ATmaJAdi4FpRwN/m4yJvDDWQq4JUB
         eGaQ==
X-Gm-Message-State: AOAM532W4dvQrM25/XOhzoptQRQD5xU6JT4OgZapmA293WyVplk7bvSm
        9hBVk/zVET0QEP/1A+A2pKIa6sadntI=
X-Google-Smtp-Source: ABdhPJxu60uiLtqof1I9SerrWke5k6tVmnT6IOMMISisfIdon/F43qJRwpcHmsh29bYHKIrNmCBb0g==
X-Received: by 2002:a17:902:b097:b0:141:ec7d:a055 with SMTP id p23-20020a170902b09700b00141ec7da055mr68573375plr.3.1639069787935;
        Thu, 09 Dec 2021 09:09:47 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id v1sm242991pfg.169.2021.12.09.09.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:47 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v2 5/9] bpf: Add reference tracking support to kfunc
Date:   Thu,  9 Dec 2021 22:39:25 +0530
Message-Id: <20211209170929.3485242-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11685; h=from:subject; bh=RHz3L3B2ci98scRvg5Gv4lNxHl0BK0yeenPvv4x+mp0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHNXEpPGm2qsT0NLj2nAqQOEII4HrvaBYrLE8a Q6rwzyCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8Ryi0ZD/ 9sn8N+SXgsYWNmXJ8cKrxax0n7UwiCjMjZyy3HF8fLjYIIXbL0etz8hhKZv7DGqcTDNCrRr1w+RQj4 sQeSIojcBqAaF8a4ssCgTA0YDN02maZnUhT9uN7omZlvlC/PEIIxvCtihFWK0BMEiIqqqiQIdDdC9v KDwczTT4h02e8v4fem3kCkSVdWt990pFMJgdvYEbK0Alo8hcqY2Sl4TXPYKG934R6BQ8mFf5qPR5CW T48bzqAPQ4tIzPIZFnGS8KrlkQ9OSnRfB7IeYvRSslcTKDxqx7HckEWki6jrGqXSisbMtaFyH3QtWy C4Fmu+kJXjOb8fyInXi15kHaPKZ8RcV6NvHDUBErpfubLJNVUezOYuLmW+Z/1poBnXHi/s7zeFFIkn dGSi1KXBccr2mvlFTrCQoqaKa3/jRRlp5feh9hNUjXOZFStihqQb4aqqC6cUCzQ4bSVOMxTZjLKVy/ /Q6gm5KLeRgnuhBvrTvYnI324uMwuPWbGABBspsjJNfPnbn/N0rFHnbcrXVsI2e6KX81bmSd1VYBIu Nidtt8+3INZeBBAimrLuSWGpck5RKlP6VYd31/3Dsq7xdSyWwvXUxWbJB/m3o7jblHzxVSN3QT7WUT krXM78TH8QfYiuO9aUGsiYDPGn/n9NvUh3UCDwQda6RBPpBEvY5BBqBIhiAQ==
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
  93c230e3f5bd6, we assign a non-zero id for mark_ptr_or_null_reg logic.
  Later, if more return types are supported by kfunc, which have a
  _OR_NULL variant, it might be better to move this id generation under
  a common reg_type_may_be_null check, similar to the case in the
  commit.

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
 kernel/bpf/btf.c      | 42 ++++++++++++++++++++++++++++-----
 kernel/bpf/verifier.c | 54 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8bbf08fbab66..6a14072c72a0 100644
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
@@ -1717,7 +1720,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 				struct bpf_reg_state *regs);
 int btf_check_kfunc_arg_match(struct bpf_verifier_env *env,
 			      const struct btf *btf, u32 func_id,
-			      struct bpf_reg_state *regs);
+			      struct bpf_reg_state *regs,
+			      struct module *btf_mod);
 int btf_prepare_func_args(struct bpf_verifier_env *env, int subprog,
 			  struct bpf_reg_state *reg);
 int btf_check_type_match(struct bpf_verifier_log *log, const struct bpf_prog *prog,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index df9a3f77fc4a..a790ba6d93d8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5640,14 +5640,17 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
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
@@ -5725,6 +5728,16 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
@@ -5794,7 +5807,23 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
@@ -5824,7 +5853,7 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 		return -EINVAL;
 
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
-	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global);
+	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, NULL);
 
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
@@ -5837,9 +5866,10 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 
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
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 074a78a0efa4..b8685fb7ff15 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -466,7 +466,9 @@ static bool reg_type_may_be_refcounted_or_null(enum bpf_reg_type type)
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_TCP_SOCK_OR_NULL ||
 		type == PTR_TO_MEM ||
-		type == PTR_TO_MEM_OR_NULL;
+		type == PTR_TO_MEM_OR_NULL ||
+		type == PTR_TO_BTF_ID ||
+		type == PTR_TO_BTF_ID_OR_NULL;
 }
 
 static bool arg_type_may_be_refcounted(enum bpf_arg_type type)
@@ -6753,16 +6755,18 @@ static void mark_btf_func_reg_size(struct bpf_verifier_env *env, u32 regno,
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
@@ -6784,16 +6788,37 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
@@ -6808,11 +6833,26 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn)
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
@@ -11457,7 +11497,7 @@ static int do_check(struct bpf_verifier_env *env)
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

