Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CA4478276
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhLQBux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhLQBuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:46 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD48C061574;
        Thu, 16 Dec 2021 17:50:46 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id f11so890429pfc.9;
        Thu, 16 Dec 2021 17:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a+os5JmAgig/lrPw6oIJK9kXmnfaLb3ZDZO0mPwb9qk=;
        b=qHzXh2ehHLs3eULNYbo37p3ruLHbCrrMEn4FSuKejA7xuwGCXpX588da/Z5GM0rMrO
         e1Bho9oXCr4mJIgGEZvg2YqnU0hpX8hRQGEuNjFHc5fnYuZAHlD+aWHJePmrZaADPjuc
         7/ZWWS4cjRZ3keaK9qD8ty2PRVS0w4qLWXsIq7gYSnjrDbU0eYkg1MwIOqRYPi7p7AJ3
         K1e9dYPnhTu48O81GZVwuM1n8DEkO3PtIHtos+3+xplN53gp7nHDcQIOVnTM/o4PRuDy
         6Y23ABMIMz4WpHWTwNMcQeY8Ln6SItDVE7S4j9k5oK+Jxol+TAKnxcsy5wegg/nC9SXX
         pC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+os5JmAgig/lrPw6oIJK9kXmnfaLb3ZDZO0mPwb9qk=;
        b=7isQ+NCRkAy8ylH/6ONrki/vDs/uEr+PPc1qVUJoDX+9Rq3bP1Dn0V3T7bgdMEGutp
         YS61aSphM697BXSiSF+yBVATAe8FposKVViRuqUTKYj3oKnra4dCFHAdRdoJu0ByXO9g
         KViMq1II8HfzQw/ksHGiVOObNP1mNtPCXay8EYKXUh0cAhhycWIxbrjXkoC52rSofh7x
         SVslWLkQ+/EAc0wrwTX28jXSMXv6f6GLhGx8Pg+a4UDDSoktKF3ki1OR8M09U/h0QxlE
         oLENaevUdnwZNcJW/5vLBUKv/IFz5Vy7HVFhiSXV46kr7v4HrCZpMeRJJuyfyr6XwHql
         KfsQ==
X-Gm-Message-State: AOAM530tzwP8ut3Kkfmb7A9bQiCJ/FiydNh7FbICaViE4LsFUKb2Apjy
        pmRyc0+uiPjzUkPW313Cjw4UDEJOcLI=
X-Google-Smtp-Source: ABdhPJwi6J2o98x8Qhp1GwOjVS5Werw/1hn2bDDKfZ5eBYQoJVDcoFCOa5/4ZcAY8zX01zBskLxnzw==
X-Received: by 2002:a63:8a49:: with SMTP id y70mr837086pgd.301.1639705845911;
        Thu, 16 Dec 2021 17:50:45 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id 32sm6234399pgs.48.2021.12.16.17.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:45 -0800 (PST)
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
Subject: [PATCH bpf-next v4 04/10] bpf: Introduce mem, size argument pair support for kfunc
Date:   Fri, 17 Dec 2021 07:20:25 +0530
Message-Id: <20211217015031.1278167-5-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9878; h=from:subject; bh=8mu3X2QcuxXS+MZ+ISUAUDKcJrUPw4+9mXiEwYQrvMM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vF/ctCVsfjgvEnxOiDxcsgLd3utzNdM0Z6ddD/ hDuuBOmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8RyjtzEA CD0wOmBV0rlWeGtgKyYeu3r6f0xWddLkv3D2j36+dLo++pJ3gstcsJ07pXQEvTJhZS6Kg3Z8OyWZ7w N5Z8znJ1PIUAAX9TlY8/lx11o/qVo9XS+XKVkLGIsISfRzoX6x6abhQ+G0gpGAyW+FmE9hQG1Swv+e hU7HWa8EaM4CmDKAcjeNQboxwdPxUgrShF9OfIpeNTkbsW8B0fl2R1qHkVnnLFCjRtU0HGXM5S11Fg 59+n88EbzzFs1cbvVXE3uVZGthKa6OSUxdSJI7Fi03KUasCbk1ewLoVEjlzTE7KLWO4/ziz2/0pEmp ECGx9ZtiBxwupo8G0csLvp6I2CrfGCnJx0QgaYc9Bri+iLn4MQUeAj7FmvTuEHnBRrfExhdElhmE/s T3k/c254m1Z3NyyrjNTRsYg6BMp/XnaFEkSuz3H1zfDylV6ncPS2HZiuOivowc6CaQY+LgRm9jRR8C 77lPnUvEJQUOs3fWL+wi2vyJQ3PHPVfvDiVldOV6+DlQz0ngMHoG9M8jTFkIuy+yrsbP+4AK+mm9ab 3N0EJo8brSvgmchcnkyB9yEIe9WxmS8UfWwcJ53MMh+IzssFvZ+bhSYM9nJbFVnUD7uPO/2+oBYpGG baf9qM1E+/HCgxC8fw63a177sDXvH+MWQ56vvNqXF5bzNg+n+Qq+0AiDI7cw==
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

Currently, we require the size argument to be prefixed with "len__" in
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
 kernel/bpf/btf.c             |  41 +++++++++++-
 kernel/bpf/verifier.c        | 124 ++++++++++++++++++++++-------------
 3 files changed, 119 insertions(+), 48 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 182b16a91084..b80fe5bf2a02 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -507,6 +507,8 @@ bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 
 int check_ctx_reg(struct bpf_verifier_env *env,
 		  const struct bpf_reg_state *reg, int regno);
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size);
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e5ba26367ed9..04e80dd6de2e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5617,6 +5617,25 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
 	return true;
 }
 
+static bool is_kfunc_arg_mem_size(const struct btf *btf,
+				  const struct btf_param *arg,
+				  const struct bpf_reg_state *reg)
+{
+	const struct btf_type *t;
+	const char *param_name;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	/* In the future, this can be ported to use BTF tagging */
+	param_name = btf_name_by_offset(btf, arg->name_off);
+	if (strncmp(param_name, "len__", sizeof("len__") - 1))
+		return false;
+
+	return true;
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
@@ -5728,16 +5747,32 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
-				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {
+				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0) &&
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
index f0604796132f..0fc2e581a10e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4797,6 +4797,62 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
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
@@ -4820,6 +4876,28 @@ int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 	return check_helper_mem_access(env, regno, mem_size, true, NULL);
 }
 
+int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
+			     u32 regno)
+{
+	struct bpf_reg_state *mem_reg = &cur_regs(env)[regno - 1];
+	bool may_be_null = reg_type_may_be_null(mem_reg->type);
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
@@ -5333,51 +5411,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

