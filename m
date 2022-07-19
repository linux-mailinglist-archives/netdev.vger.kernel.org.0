Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58BC57A097
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiGSOI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiGSOIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:08:00 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD4D53D16;
        Tue, 19 Jul 2022 06:24:40 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id v12so19565366edc.10;
        Tue, 19 Jul 2022 06:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4HdQRgZNWt4KwZg2LOa2AZAYHjC0j10GdFoMZAkH+Uo=;
        b=Bi9JesZFTOr6aXGaZzpHbPGyJT2Tnqhgan7FgZXcs/FN/zLaEUIQUaRl2/gvvMTDlJ
         gQhDHGG58mqsq02AOdrU/4pnm0zmq1VF2MTuTEdnlDR7xlCt1/PXVozzU0xwohioJ0fM
         bKD17E9y4YTA5UE3RULJyLFKLjBcE7xSCuCYktnjZevqoPWWjgjTas7imDr2sMqqse4A
         r/1/gy0BhC2tLVi3GDvD4fUVdMMXmXwPMEuGeDYH93N2Ug2dh4ukcBkK77yPPTc4qI9A
         aXzsA02GI1jXWLeIXduv/Zye/9Dy9sVcuZmIz68WiBDAylFSWCt5nhttNtidLwc5XneQ
         iHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4HdQRgZNWt4KwZg2LOa2AZAYHjC0j10GdFoMZAkH+Uo=;
        b=LkVfZflV4zrhq9CkRH26IvVWdM1az6j0Vma3NNdJkx7OQVM+FHHFiDkNtbnDoyOMf6
         3breML6+ivMKm3RQidB4I74otNKG4efFmNRYjpW7jMFWA2EqBrA81TrzW7+2QCRypnvc
         VVZDpiKGJhI0Z7AOb1ZFiqm6QHNS837z5yOp1IfCtWub3SQHt/KeXTeEfuHhGGRlwvMN
         ChP8QXjdOKsE8MrqckFC/YT9O+NiWpghbs44HVn6O8G+fTSQqw4BHUPvN1mmUu+TGbbX
         rvfYd/44cftZI/qs4O7atIssw5CBqs3NEGaRWSW5amQ+VOva59RnnWp7/xT/y9ZhPWtB
         TQnQ==
X-Gm-Message-State: AJIora+W3WIFzQs12X+q009NuOz/GWQv3vqyjs4CzD7L5fMB6na+w/u+
        Z2O/Vbzkffe6x6mfICdQA6wkTCNaK1Nr8w==
X-Google-Smtp-Source: AGRyM1sD/DpM7vqJHuF690LiWtLnWUBsdgGaaZNksCyte8HyZzqKpqLBKnCtTGKiaZ0OIMi04ejGlg==
X-Received: by 2002:a05:6402:450d:b0:43b:d99:6d4f with SMTP id ez13-20020a056402450d00b0043b0d996d4fmr43755310edb.39.1658237079026;
        Tue, 19 Jul 2022 06:24:39 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id kv10-20020a17090778ca00b0072eddc468absm6731080ejc.134.2022.07.19.06.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:38 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 04/13] bpf: Add support for forcing kfunc args to be trusted
Date:   Tue, 19 Jul 2022 15:24:21 +0200
Message-Id: <20220719132430.19993-5-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5967; i=memxor@gmail.com; h=from:subject; bh=b3Q8sBj4dMADbeuH5+HLSJXs+GVGPgtk6z4hlRqbdz4=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBl9qNs9hYdhxUOSz7n/uRNVkhtvnkdFNZEolIh JD5zGmyJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RyvpXEA CSaXNjtgPXrXHmXxM3MCP6Fpq89dc6ps3F49pdcYY2O0iekwWNyIW/a1OWaO9omhpvv1GOutABApNk NMtfyT8Tmt0ssWbcIZVtlY+pCuuztfTK5q7aoMjDG10iZOl0kBtHfyymU5e+9n092XITruYyyve4yo W93BAhq10R4hvCJLdwUku+nW2BiHEHp/xhCmTXZoAJLVx9S+Xc34JxbyU/0E94liSHovKyCKflcJy4 nqGBD5W8TbejMZJhd6HB/ZBsIluWcOa3E4Y7Up+zMEHyEtSvnMeeiNuiJNBC/F2BdR5VKFb44vwiLq lhZExvvhDJB+5rYptk81xbIdfUiOfUJM19GYaCaCVtyNWbQX2AJG0LIN7Vf9oBDncAjZiapl7TRYHr sO5nLzOf61SaRSxN+H9B9IvcEREa0UqgwrgKVXQTG2eL3g0He61YPRrD4EyA71OxyoJ+4PYBZskoCo owPwd3rmUwcr5AnfrkLsrkyDnN0jbsgVqs7l55o0TQ08mk0WGlpvLs9yAf8UgwOGlo+861gMLjprvF Ml12bDpUVIRqnCu0gCMSA/a0C4EchgEImU+CF0j8lB7Qr0i7PtTrxWuF812bGCvx4jozFYEQRB7Fil LdRvipEcDdT6lWnvK8i4Ft+qi4AL+Efj+lKAjcVxcj4Nr+AzfcPt6cikbRPQ==
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
index b370e20e8af9..bfa3e7a4e0a2 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -20,6 +20,38 @@
 #define KF_RELEASE	0x00000002 /* kfunc is a release function */
 #define KF_RET_NULL	0x00000004 /* kfunc returns a pointer that may be NULL */
 #define KF_KPTR_GET	0x00000008 /* kfunc returns reference to a kptr */
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
+#define KF_TRUSTED_ARGS 0x00000010 /* kfunc only takes trusted pointer arguments */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 75ad3543aa72..e574c5019a7c 100644
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
index 1fbcd99327f5..ead88eeba977 100644
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

