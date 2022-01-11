Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E924748B52E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350280AbiAKSGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350298AbiAKSFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:05:11 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6D2C061212;
        Tue, 11 Jan 2022 10:05:09 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so6771971pjj.2;
        Tue, 11 Jan 2022 10:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WZy/SxBwLsYdG6mkY0Zc2dYIxmewH5Xd/7ypkgvEhtY=;
        b=MRHkIXEv9BOjzxHMrZbSNtnzVYo8zSMtKnL7+QadESZCGpeT/pZIgYnQuNz1zoGZm0
         s1/kRhGaUbFLo3m6irx6Ml10+H3H8zoaPXOu0Sw/Dp8sDHslG0kykdhXHHz9Gz9WW5fR
         wX9wjbr4cYxYbhelQ8ehbX/bl6Cnf/cYxaMKudBm6RHBai1VPvRJcvI4ia7Wu68Pfp+C
         dQh1nLUk5/Z65VfWyugmdq23XhxHdSPhxIARgw8uVO2EYTzttPjI9cqvdQlPjXw6RdvS
         7lCmG6J9WPF3QbZeVUjBTRLy479dHaOIx8ID7xhSgIUQ2d7yd8rmEsnlOIx5Hn/wWBsm
         lufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WZy/SxBwLsYdG6mkY0Zc2dYIxmewH5Xd/7ypkgvEhtY=;
        b=yIGWzHCpP9e7gHUzUdZDVdjGepRnaAkDD4wUZdLS62OvDWJmI+CD+RbaoTc+0kMug2
         f3VdQy4J0831UCPrlmY1LElviF0rRe61Ru/uh+X7eX98PkCrGHwR5wmicVbc8jtlYpHC
         sPg30sq4bYSieCCYLwRtZfSf0W8mfkVXPLVj6dT9dmWLq/KTSiAjCuOW8HomDZ1o5A+Y
         9r95CcNL3CkyfCqCPDbqQFtEeOrCpYK8fKElemgqU8w8OozzJuMGyzVE4qn1YansKa+6
         oeEldYbNFwuToEF6Zyet+zJ9LiRmLbatLs07aXGVmxwjrq8sPeuU6Fpggq9QiI/Jqj9+
         Db3A==
X-Gm-Message-State: AOAM5305yc32Rn+PamPTDkcamO8rah5FZ/D5KxATwaO3CY5p/CEo9WB7
        DZK3vE1Jlxq9654hM/36ebRkqI1WYmFB0g==
X-Google-Smtp-Source: ABdhPJzkJsQoSwBsfyheFfutrKoNkuDhgaIfU1KQblSSLwsAoP6zghXvhcZzswbdZNQat34OXw63Bw==
X-Received: by 2002:a63:f5a:: with SMTP id 26mr5137012pgp.613.1641924308280;
        Tue, 11 Jan 2022 10:05:08 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:502e:73f4:8af1:9522])
        by smtp.gmail.com with ESMTPSA id b4sm3119877pjh.44.2022.01.11.10.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:05:08 -0800 (PST)
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
Subject: [PATCH bpf-next v7 04/10] bpf: Introduce mem, size argument pair support for kfunc
Date:   Tue, 11 Jan 2022 23:34:22 +0530
Message-Id: <20220111180428.931466-5-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111180428.931466-1-memxor@gmail.com>
References: <20220111180428.931466-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10036; h=from:subject; bh=g31VGcMoJJ0vdw6gOUMJPC/1fEdzf0G3ukVh1oecyMk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh3cajPXDEFQSiDXBE+oPK1YA6OBt5kGgoP46LwGNE Jk8QF8CJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYd3GowAKCRBM4MiGSL8Ryu+qD/ 40MiWX9qS2Hfey334H94YTBGJDTfaAPYK2MKb6qSMgHOussV4T2lDdHIhToj7bEkfd6EXD+UbA0HpP pUTDUq9lFUML+igpRRxtNA90HSfJGvSb2//06hai6ZBG48Z1c+bw5WH41gZwzy0X3aa5bApCbgnKEn /8hygJDpjFN6IXYSIGkK3irgsGfvCn/PdA8qsWR1mi2qztjWXKOkS7ahiIr5Uvo+as3NUap3eR3EXo O7qDfel/a10hidYHR2Q/P4MZp74mrbTicwyGdak6BERRaRCVVlpF5epdWJTcN5AUNnYs3ScqYi44YM tjERGK/jGJ4VY3wIl6GER741dW/0E1tysUQkctZnyUq085R+CTfQZz41PHrlEWGkY52UHxze4wPv89 NJRCOq03uFRWyUJSgxH+7zHJmxhjxDHsmOGgg3fW8l8Am7vhC/VfCSvQwEqwsSHrl6MBHPEjh882eO BLrTR/vaSdY6JY5su7XFrPTOZ1tNIzAT7VBTQtuzF9ONdV/nkpJEBGMSQkLZ9najw+EkgkkCnrFerS MCx6Z1rQ3r1S0uuPoeLWPCMgWheCZLJCnloevannspjGQcF2YSlXFhZsRweVD4ZTWbD5q9ajYR7GCM Jkunv2sSrRGJIT/dTYGXCM55XR3sdwyLLBtJhdny42qFH5s/vxC1oOvig1Aw==
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
index efc1415ae202..ed1b4792f505 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5647,6 +5647,32 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
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
@@ -5758,17 +5784,33 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
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
index ec07f4992253..f147b6963dd5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4865,6 +4865,62 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
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
@@ -4888,6 +4944,28 @@ int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
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
@@ -5409,51 +5487,7 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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

