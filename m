Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06116482BFB
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbiABQVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiABQVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:38 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00DBC06179C;
        Sun,  2 Jan 2022 08:21:33 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so13023327pji.3;
        Sun, 02 Jan 2022 08:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n7Mp9SYoYel6QSWXN8w2bTOBrzkx1XWaKbNWWSdz8HQ=;
        b=ULUIiECpCKI1aVW9Qti8DqG4iBPyH4BXtzjuts7tKiNc3CSsGJDElMiApa+VUfpQew
         4wOWwPZp50V1Obg/kI9FKBSaZp4oQag9Ma+UqeMrCfBrU/5G/JrRf3MA611Zh2tGHZJe
         e4Dxdga5gPT0dKTwwSYijyBbcv8Lz6I4KcL51sRaR5hmu3jEPszIncuGOGi5BjYd4a43
         JY3LsudXDVic1ujKIBSkCRcWzSEjGGlMacYXOUpJcTzvU53g2yboHHWIuVUrCQm/mLA2
         tRlxPjzN6Eo+Ci5GfOChbKryC2RiYFbjwzG/Em0723PMFA5etfs2K0LmHeV/lkxj0cpe
         k6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n7Mp9SYoYel6QSWXN8w2bTOBrzkx1XWaKbNWWSdz8HQ=;
        b=EaShoHo30u8d83LYic0pEbfv1s3uKME8cObE6yJZZnORJu5zCAOZpzxnZaYD3j5JHV
         inzrTm3KKMCml9410Fq5zqLmmKLI+IeGf9GJ+ZmYOHkhw80NNhjR4QgHWPKU1HdLE2Tx
         sPq5/4gyoatgw+wiGRmcmSZifNOBf/FwWxztXNtm/7qsQ3Jnz3uMntpTrNJN3lor/hZJ
         eTOUIFQYSp4fmdNYmXCxn4z6fO/sw0mo8jaeLs6icfQuuEFOr1etFLs79vGceeNDnJyK
         jVUKltvDkBSpyzAELKHLDiis+y6uT7q2Joi37sE1ysXCqnEWQeI6yKO/A/CTFxYWSfqu
         s5yQ==
X-Gm-Message-State: AOAM533lU+M144yc+WX1hlNQCZNA/xYWhcjwmiJ59d/sFRmn7JBYmXpv
        9qo/4zNsGFW/cTolrYwm1Ismg/QYO28=
X-Google-Smtp-Source: ABdhPJwHOL+KC7Ex5CzLb/aXosGMKu2quX+KWoW1EUGO0+P+GNFgJoZ/0w5TcAZk/0EBsLjngAlcQw==
X-Received: by 2002:a17:90b:1651:: with SMTP id il17mr52335581pjb.190.1641140493157;
        Sun, 02 Jan 2022 08:21:33 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id q13sm13823237pfj.65.2022.01.02.08.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:32 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 05/11] bpf: Introduce mem, size argument pair support for kfunc
Date:   Sun,  2 Jan 2022 21:51:09 +0530
Message-Id: <20220102162115.1506833-6-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10036; h=from:subject; bh=23S8UgWWLoXJNfGC70fiyCXYKr/domF8pt9WPpqWrvo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCKrK2blCuu3Kqtitb47AxKsg+074p6UH/LdMI6 KnvC8dSJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQigAKCRBM4MiGSL8RyioHD/ 9tMQlsUcINNE7FLENOwI5PazDvM1TDyBz11lCfXLbHIF81Q9BKGQOcjjLm7lZrWHlMWbHN19/Tr53V Hy1Zz6NXL1PAJ6umbWcmDFjLl/byiIu3KaqRJaht/xj/AXB0CihgAYRJqlrxqZAPVlJ+A3cNkpQe1K o9T/EVp9QQt6Yc1pCrvPSVD3yLAI+ewDq2T9Eh4MDNZdfOp7VAuLMZHJJzigx7Q4wdRa2ZDTu+UAib ALGr9GjGG/iBOVwXYFgv5oY76ZdwSKQKkMVylCoSPA7w4piVnmX76cUhmjqGp6IK1H1A7ix5SNnQoZ CWqma6ZIne0CDJ87zUG+S4hWrjuVTkYcDQGIjfFnNexgeDUXUR5eexV0/H1OJqRCMrJrxY8ArJhtTf Yf8aD5VXfbbieqgqtM4An++v79rvbRCSj6d9Ie6pufHPIaRHrMQFsCZmJEUYUvr4nmltdzs1Ppzv8K 1xURwh1AC4MRJlxHDmriecLoDoiese7hq0Kj7PhjrxabJo4GOjiu9Akf1sAm2be6neqpFB9FgEw8Oo JqpbMxixbyF36iKcMA1yh5l9A/v/V2ygkodA+JhfLrmgPXAMRUmQzp7dbWxDEzQUTjkk6NuP5okWOM CIw/pFg4s9fJDzpkNi38nzqyIHtL8tCgVrTdz/NffPfxeltgGjdnaVP011bg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF helpers can associate two adjacent arguments together to pass memory
of certain size, using ARG_PTR_TO_MEM and ARG_CONST_SIZE arguments.
Since we don't use bpf_func_proto for kfunc, we need to leverage BTF to
implement similar support.

The ARG_CONST_SIZE processing for helpers is refactored into a common
check_mem_size_reg helper that is shared with kfunc as well. kfunc
ptr_to_mem support follows logic similar to global functions, where
verification is done as if pointer is not null, even when it may be
null.

This leads to a simple to follow rule for writing kfunc: always check
the argument pointer for NULL, except when it is PTR_TO_CTX. Also, the
PTR_TO_CTX case is also only safe when the helper expecting pointer to
program ctx is not exposed to other programs where same struct is not
ctx type. In that case, the type check will fall through to other cases
and would permit passing other types of pointers, possibly NULL at
runtime.

Currently, we require the size argument to be suffixed with "__sz" in
the parameter name. This information is then recorded in kernel BTF and
verified during function argument checking. In the future we can use BTF
tagging instead, and modify the kernel function definitions. This will
be a purely kernel-side change.

This allows us to have some form of backwards compatibility for
structures that are passed in to the kernel function with their size,
and allow variable length structures to be passed in if they are
accompanied by a size parameter.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf_verifier.h |   2 +
 kernel/bpf/btf.c             |  48 +++++++++++++-
 kernel/bpf/verifier.c        | 124 ++++++++++++++++++++++-------------
 3 files changed, 126 insertions(+), 48 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 143401d4c9d9..857fd687bdc2 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -521,6 +521,8 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno);
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6aa462f2b246..356e6af5b8ba 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5640,6 +5640,32 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
 	return true;
 }
 
+static bool is_kfunc_arg_mem_size(const struct btf *btf,
+				  const struct btf_param *arg,
+				  const struct bpf_reg_state *reg)
+{
+	int len, sfx_len = sizeof("__sz") - 1;
+	const struct btf_type *t;
+	const char *param_name;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	/* In the future, this can be ported to use BTF tagging */
+	param_name = btf_name_by_offset(btf, arg->name_off);
+	if (str_is_empty(param_name))
+		return false;
+	len = strlen(param_name);
+	if (len < sfx_len)
+		return false;
+	param_name += len - sfx_len;
+	if (strncmp(param_name, "__sz", sfx_len))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
@@ -5751,17 +5777,33 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			u32 type_size;
 
 			if (is_kfunc) {
+				bool arg_mem_size = i + 1 < nargs && is_kfunc_arg_mem_size(btf, &args[i + 1], &regs[regno + 1]);
+
 				/* Permit pointer to mem, but only when argument
 				 * type is pointer to scalar, or struct composed
 				 * (recursively) of scalars.
+				 * When arg_mem_size is true, the pointer can be
+				 * void *.
 				 */
 				if (!btf_type_is_scalar(ref_t) &&
-				    !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {
+				    !__btf_type_is_scalar_struct(log, btf, ref_t, 0) &&
+				    (arg_mem_size ? !btf_type_is_void(ref_t) : 1)) {
 					bpf_log(log,
-						"arg#%d pointer type %s %s must point to scalar or struct with scalar\n",
-						i, btf_type_str(ref_t), ref_tname);
+						"arg#%d pointer type %s %s must point to %sscalar, or struct with scalar\n",
+						i, btf_type_str(ref_t), ref_tname, arg_mem_size ? "void, " : "");
 					return -EINVAL;
 				}
+
+				/* Check for mem, len pair */
+				if (arg_mem_size) {
+					if (check_kfunc_mem_size_reg(env, &regs[regno + 1], regno + 1)) {
+						bpf_log(log, "arg#%d arg#%d memory, len pair leads to invalid memory access\n",
+							i, i + 1);
+						return -EINVAL;
+					}
+					i++;
+					continue;
+				}
 			}
 
 			resolve_ret = btf_resolve_size(btf, ref_t, &type_size);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e2a8247b7824..80c9a2c00848 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4850,6 +4850,62 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 	}
 }
 
+static int check_mem_size_reg(struct bpf_verifier_env *env,
+			      struct bpf_reg_state *reg, u32 regno,
+			      bool zero_size_allowed,
+			      struct bpf_call_arg_meta *meta)
+{
+	int err;
+
+	/* This is used to refine r0 return value bounds for helpers
+	 * that enforce this value as an upper bound on return values.
+	 * See do_refine_retval_range() for helpers that can refine
+	 * the return value. C type of helper is u32 so we pull register
+	 * bound from umax_value however, if negative verifier errors
+	 * out. Only upper bounds can be learned because retval is an
+	 * int type and negative retvals are allowed.
+	 */
+	if (meta)
+		meta->msize_max_value = reg->umax_value;
+
+	/* The register is SCALAR_VALUE; the access check
+	 * happens using its boundaries.
+	 */
+	if (!tnum_is_const(reg->var_off))
+		/* For unprivileged variable accesses, disable raw
+		 * mode so that the program is required to
+		 * initialize all the memory that the helper could
+		 * just partially fill up.
+		 */
+		meta = NULL;
+
+	if (reg->smin_value < 0) {
+		verbose(env, "R%d min value is negative, either use unsigned or 'var &= const'\n",
+			regno);
+		return -EACCES;
+	}
+
+	if (reg->umin_value == 0) {
+		err = check_helper_mem_access(env, regno - 1, 0,
+					      zero_size_allowed,
+					      meta);
+		if (err)
+			return err;
+	}
+
+	if (reg->umax_value >= BPF_MAX_VAR_SIZ) {
+		verbose(env, "R%d unbounded memory access, use 'var &= const' or 'if (var < const)'\n",
+			regno);
+		return -EACCES;
+	}
+	err = check_helper_mem_access(env, regno - 1,
+				      reg->umax_value,
+				      zero_size_allowed, meta);
+	if (!err)
+		err = mark_chain_precision(env, regno);
+	return err;
+}
+
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size)
 {
@@ -4873,6 +4929,28 @@ int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 	return check_helper_mem_access(env, regno, mem_size, true, NULL);
 }
 
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno)
+{
+	struct bpf_reg_state *mem_reg = &cur_regs(env)[regno - 1];
+	bool may_be_null = type_may_be_null(mem_reg->type);
+	struct bpf_reg_state saved_reg;
+	int err;
+
+	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
+
+	if (may_be_null) {
+		saved_reg = *mem_reg;
+		mark_ptr_not_null_reg(mem_reg);
+	}
+
+	err = check_mem_size_reg(env, reg, regno, true, NULL);
+
+	if (may_be_null)
+		*mem_reg = saved_reg;
+	return err;
+}
+
 /* Implementation details:
  * bpf_map_lookup returns PTR_TO_MAP_VALUE_OR_NULL
  * Two bpf_map_lookups (even with the same key) will have different reg->id.
@@ -5394,51 +5472,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
 	} else if (arg_type_is_mem_size(arg_type)) {
 		bool zero_size_allowed = (arg_type == ARG_CONST_SIZE_OR_ZERO);
 
-		/* This is used to refine r0 return value bounds for helpers
-		 * that enforce this value as an upper bound on return values.
-		 * See do_refine_retval_range() for helpers that can refine
-		 * the return value. C type of helper is u32 so we pull register
-		 * bound from umax_value however, if negative verifier errors
-		 * out. Only upper bounds can be learned because retval is an
-		 * int type and negative retvals are allowed.
-		 */
-		meta->msize_max_value = reg->umax_value;
-
-		/* The register is SCALAR_VALUE; the access check
-		 * happens using its boundaries.
-		 */
-		if (!tnum_is_const(reg->var_off))
-			/* For unprivileged variable accesses, disable raw
-			 * mode so that the program is required to
-			 * initialize all the memory that the helper could
-			 * just partially fill up.
-			 */
-			meta = NULL;
-
-		if (reg->smin_value < 0) {
-			verbose(env, "R%d min value is negative, either use unsigned or 'var &= const'\n",
-				regno);
-			return -EACCES;
-		}
-
-		if (reg->umin_value == 0) {
-			err = check_helper_mem_access(env, regno - 1, 0,
-						      zero_size_allowed,
-						      meta);
-			if (err)
-				return err;
-		}
-
-		if (reg->umax_value >= BPF_MAX_VAR_SIZ) {
-			verbose(env, "R%d unbounded memory access, use 'var &= const' or 'if (var < const)'\n",
-				regno);
-			return -EACCES;
-		}
-		err = check_helper_mem_access(env, regno - 1,
-					      reg->umax_value,
-					      zero_size_allowed, meta);
-		if (!err)
-			err = mark_chain_precision(env, regno);
+		err = check_mem_size_reg(env, reg, regno, zero_size_allowed, meta);
 	} else if (arg_type_is_alloc_size(arg_type)) {
 		if (!tnum_is_const(reg->var_off)) {
 			verbose(env, "R%d is not a known constant'\n",
-- 
2.34.1

