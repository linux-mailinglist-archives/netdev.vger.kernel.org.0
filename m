Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5F57CC40
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiGUNnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGUNnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:43:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401FA7E83B;
        Thu, 21 Jul 2022 06:42:55 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v67-20020a1cac46000000b003a1888b9d36so3377011wme.0;
        Thu, 21 Jul 2022 06:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKDQvr4Ha1ihCYQYI2WnPngxgXWoBDxQkBDVJ/HQ+2c=;
        b=JOfA0CrB+z9kMyu+BrMsNlDlutUR/4rdDtTKE+rYTGKuZUJtY57sPOwXNjB4RP28Hl
         fxV58yLWDmPwlpZ0ltfXQ64bm196MgLEhhKhyQfm1rr+1zYsfVYN55wOGaaGFqM1e3dH
         Be/pLQfFeL4ttP1zRYLAfwy5Aogm7bQPh6zJF0gl/KmGxqP2PsD1LbZFfy0Mz6XBYnIU
         O+qi44PR9MmL+yRMrI6vC0wb6vqkdBSLSeNxynZ6VNfIqtZuyCL6YKDfXa1EA7NNfsCj
         qpKXxvH7y0hmcEIvVb7ED5yCIbQZtWwjIeLkRT4vHSYGggttjRjO3oAN4soGBwFdJkVY
         o93w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKDQvr4Ha1ihCYQYI2WnPngxgXWoBDxQkBDVJ/HQ+2c=;
        b=hIsesyql/dQSo9kwnoTy4oOuFRIeANcq6vCLcYcvJRd0ff552yKeVlEt8YiIOFE0cM
         Iue0IJ4eV7e9X0jASpNre10/PIfylM17u/yg1qei/HKMcusc4d/1AjKxv932myvvo4kF
         B5HlWsDpgowrCGvoDfMAIG/x0yNbJ0hZ7ISi1PlwyRFaRTIyHUbF3cVE8g7tj+nsw1Hr
         7qJafxiATOnVFS/VuaEUNlMFxkbPECi/RksJKCnULfZFgs0+Ijyz974NwERqUOjAhMKW
         AtyqJ2MIa7GCHGo1IEQfyw1GJNlkFyfWQq8H4XkYv/43vrz/PJyUnWLwMGNDiajfNsfc
         wR+w==
X-Gm-Message-State: AJIora+wfcLIagI1xEYOdoMmoy3MiQQobXNIuvamAwiG0od+Fz6Het0/
        MezDntCandsWy7xgkpJBm+XMIA3Elr1tKw==
X-Google-Smtp-Source: AGRyM1vHcrDGI21ugSZ0fwHqE4uLxkGQ+WihPsJ2i3HZC9kx12C9Xe5ageUInDtitf+Ha92mjj6o2A==
X-Received: by 2002:a05:600c:19cc:b0:3a3:10bd:9211 with SMTP id u12-20020a05600c19cc00b003a310bd9211mr8301568wmq.106.1658410973348;
        Thu, 21 Jul 2022 06:42:53 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id s23-20020a1cf217000000b003a2e2a2e294sm1915169wmc.18.2022.07.21.06.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:52 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args to be trusted
Date:   Thu, 21 Jul 2022 15:42:36 +0200
Message-Id: <20220721134245.2450-5-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5959; i=memxor@gmail.com; h=from:subject; bh=BHiQPw04vFEmpC2vFjwdUDUZ6v33xbb9HRikP4q55rA=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfOJiUhpF22fBHYMRbOvxT02mRY1qIxK1d+MmNU FAricliJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzgAKCRBM4MiGSL8Ryt24D/ 0edK8mcFRBr4+RM92mRzOskZlL9uIYEZ9m9oAnbrDIefGm6maDTT8WsfyJJoaJGvXwkGpy6Rbx8z+s ixySjfngirKHXZcv+rIWf8+9P6TQJ4u25tvcCsj9viPMJcS7c587Hr6mCVGlqpfYeoSNb/ZFMRbKar nBspWCWE5OKUYYr5YrELqXjXeXz4OZMhDrbt1/fvGZQIpShlCWkvLME60U2A+XZ3dUj7N3g/0uxS6g EDfEAGChHpQUv+0ojAz7lgzRNe+IGW+JFNgmmhrg55rDibjla5Smp9YNnyqSOR2ehKp+oBgLVimVSQ TBrDMHFshr8n43+S6rNinSf/Wy09usPDiwT5VM+IaWvlJXh5LjbrlZoH8VKqxk4aaXQTMO61U5aDVn n1BVJ/iBEJ0i8Iu/csbGOgT7ecLdRbgDdClB7s7MZqxfECyV+vW8YsSOsamDxK8S/cUd/KIUHcfBGC IXujY02B47s6R/fO7rowQYskmmGe6S4DZamA/JpwFKkklb8T9RYFvDejwGKTPkgJX8T39SDOgtB9zc DIFJSt0kmCvNkvZo28fpSroTcLKVxB5vErxKdDQVxKHEJK8I37KNzXwB16SCrqNY6p+C7P/hULMxVN iqDAbg9PjSSBasE+dPRuEgCdKteFBhM7YUHfuWz2rCvJAy89ts/iKOOoBzJA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach the verifier to detect a new KF_TRUSTED_ARGS kfunc flag, which
means each pointer argument must be trusted, which we define as a
pointer that is referenced (has non-zero ref_obj_id) and also needs to
have its offset unchanged, similar to how release functions expect their
argument. This allows a kfunc to receive pointer arguments unchanged
from the result of the acquire kfunc.

This is required to ensure that kfunc that operate on some object only
work on acquired pointers and not normal PTR_TO_BTF_ID with same type
which can be obtained by pointer walking. The restrictions applied to
release arguments also apply to trusted arguments. This implies that
strict type matching (not deducing type by recursively following members
at offset) and OBJ_RELEASE offset checks (ensuring they are zero) are
used for trusted pointer arguments.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h | 32 ++++++++++++++++++++++++++++++++
 kernel/bpf/btf.c    | 17 ++++++++++++++---
 net/bpf/test_run.c  |  5 +++++
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 6dfc6eaf7f8c..cb63aa71e82f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -17,6 +17,38 @@
 #define KF_RELEASE	(1 << 1) /* kfunc is a release function */
 #define KF_RET_NULL	(1 << 2) /* kfunc returns a pointer that may be NULL */
 #define KF_KPTR_GET	(1 << 3) /* kfunc returns reference to a kptr */
+/* Trusted arguments are those which are meant to be referenced arguments with
+ * unchanged offset. It is used to enforce that pointers obtained from acquire
+ * kfuncs remain unmodified when being passed to helpers taking trusted args.
+ *
+ * Consider
+ *	struct foo {
+ *		int data;
+ *		struct foo *next;
+ *	};
+ *
+ *	struct bar {
+ *		int data;
+ *		struct foo f;
+ *	};
+ *
+ *	struct foo *f = alloc_foo(); // Acquire kfunc
+ *	struct bar *b = alloc_bar(); // Acquire kfunc
+ *
+ * If a kfunc set_foo_data() wants to operate only on the allocated object, it
+ * will set the KF_TRUSTED_ARGS flag, which will prevent unsafe usage like:
+ *
+ *	set_foo_data(f, 42);	   // Allowed
+ *	set_foo_data(f->next, 42); // Rejected, non-referenced pointer
+ *	set_foo_data(&f->next, 42);// Rejected, referenced, but bad offset
+ *	set_foo_data(&b->f, 42);   // Rejected, referenced, but wrong type
+ *
+ * In the final case, usually for the purposes of type matching, it is deduced
+ * by looking at the type of the member at the offset, but due to the
+ * requirement of trusted argument, this deduction will be strict and not done
+ * for this case.
+ */
+#define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 4d9c2d88720f..7ac971ea98d1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6174,10 +6174,10 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    u32 kfunc_flags)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
+	bool rel = false, kptr_get = false, trusted_arg = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
-	bool rel = false, kptr_get = false;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
@@ -6211,6 +6211,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		/* Only kfunc can be release func */
 		rel = kfunc_flags & KF_RELEASE;
 		kptr_get = kfunc_flags & KF_KPTR_GET;
+		trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
 	}
 
 	/* check that BTF function arguments match actual types that the
@@ -6235,10 +6236,19 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* Check if argument must be a referenced pointer, args + i has
+		 * been verified to be a pointer (after skipping modifiers).
+		 */
+		if (is_kfunc && trusted_arg && !reg->ref_obj_id) {
+			bpf_log(log, "R%d must be referenced\n", regno);
+			return -EINVAL;
+		}
+
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
-		if (rel && reg->ref_obj_id)
+		/* Trusted args have the same offset checks as release arguments */
+		if (trusted_arg || (rel && reg->ref_obj_id))
 			arg_type |= OBJ_RELEASE;
 		ret = check_func_arg_reg_off(env, reg, regno, arg_type);
 		if (ret < 0)
@@ -6336,7 +6346,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			reg_ref_tname = btf_name_by_offset(reg_btf,
 							   reg_ref_t->name_off);
 			if (!btf_struct_ids_match(log, reg_btf, reg_ref_id,
-						  reg->off, btf, ref_id, rel && reg->ref_obj_id)) {
+						  reg->off, btf, ref_id,
+						  trusted_arg || (rel && reg->ref_obj_id))) {
 				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d has a pointer to %s %s\n",
 					func_name, i,
 					btf_type_str(ref_t), ref_tname,
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index ca5b7234a350..cbc9cd5058cb 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -691,6 +691,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
 {
 }
 
+noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -714,6 +718,7 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
 BTF_SET8_END(test_sk_check_kfunc_ids)
 
 static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
-- 
2.34.1

