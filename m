Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26876558926
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiFWTiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiFWTiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:38:10 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6A5532C9;
        Thu, 23 Jun 2022 12:26:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a17so102561pls.6;
        Thu, 23 Jun 2022 12:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n+kCLqcYggGgj/4wHfET987AyfI9xqVXOAXCs4nRvcc=;
        b=UZie5KbSakxig9EpDsTOCLZ57cu8hlDbW615a4Hd1AO4GZ2Od4WNO1/XdF6KD2v9WW
         Vvivk066eRr0EUOgrPIQVYXm8D5YpicnBeCeDfNreaAlghimS13+DV3ivF9YpwfFlpVF
         0yPNFva3lah7SOSHO2bOPP2XiA2+SkLssUIfyHbFDpaqI2xMaxO1kYvbKE11mz7Jbcen
         VpPCmbP183wkNH+YxO+VKxEVnvfv+6WnilpT3Zm+2ujwYeMjRHcjvd9tO/B5hFkIxC5w
         opDATK8uwH+cPOR72/hox8mYK7dAZ7KUA9GPHwzRLkaMICldOyI6VV0DkOx2vSGaxc6w
         TnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n+kCLqcYggGgj/4wHfET987AyfI9xqVXOAXCs4nRvcc=;
        b=uI3J60/wNPE/U7w2Pd/UQjXk67zJz2zH7TemLaFyrMM8uyR2kHghvryTXvYDsYHauG
         JEIwjLJ0JA6p/4R7pnJ1v2OYaq/MxeBFh+hshVYuSDDt78gvCj+lNKDNwMt4AnnfKZc4
         Sl+0whQWpFWfsyWChaXaNsyezHS5IHNfuMvlWH30E7YprTFZJ6mYY2NQRaoTecGOx9L4
         r9D4B3q1TD75yxxMF+jZVJSGWEorbgevweCIJ0IEf1hYm3jusSsnKIEvFfPXU6g7eYIP
         QK6xnbZB17dlaWxrDcZYhUTIJ/az8NqSTqX17tWNrz3xpfW9Mm7Y+d2PkX6F5pzAHmk3
         tf0w==
X-Gm-Message-State: AJIora9/+Pm1vcpTXjTDQE7gk2Pci157L8rKsrW1OIL6aTwMNo6aUnne
        L2G128VBcFmk/tzXRzpO3bgrASVwUZxgcA==
X-Google-Smtp-Source: AGRyM1uxJApBf7VeNcQ8ELbu57V6+CduA/vPXw5DDUQ+4aExxxJTpyTnsbi6sYXT0tuid2kf/6Cc+w==
X-Received: by 2002:a17:903:2145:b0:16a:65c:353c with SMTP id s5-20020a170903214500b0016a065c353cmr33155128ple.44.1656012405675;
        Thu, 23 Jun 2022 12:26:45 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0c0:79de:f3f4:353c:8616])
        by smtp.gmail.com with ESMTPSA id x2-20020aa79a82000000b00524fdb94c53sm6533pfi.132.2022.06.23.12.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 12:26:45 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args to be referenced
Date:   Fri, 24 Jun 2022 00:56:30 +0530
Message-Id: <20220623192637.3866852-2-memxor@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623192637.3866852-1-memxor@gmail.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5053; h=from:subject; bh=ClD0UChbRIlxE4Ob+WFmRgx14HljAcE8S7Mg5vxKeTI=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBitL5LfWnXHZtzrFYTRPsjoIPZjD2EcuRlFlaOC3uJ H1sRAVKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYrS+SwAKCRBM4MiGSL8RykmoEA CrDmA6MQ3VaAw1tHx5LHDZVhWJwsBRwU5CPWGuZx/zBBCe/b1tW7fuySvThPnVIvZCgbr19UEyGhm+ gobq6xYFfAewRmN5aJw9SIIit05SikdrpbqcOo8j2PG9M/R1MKo5U7+D4/3DwBpHQXnHlqapdMGsLJ nSWydwYR5Grolb1e9t9OdJzUxB1CIUkiSgM/N321ZtQnzECjiq82c/SmDkkLkFvxMnrP8puCjHGIl3 gwkeKXEPRCNOBNOFUrZ8WlkfWcimSW2Z3fp/NJsanys2C3D/MJ2KsuQ1ht6zL1ws7BF1O5MOMSEQLh gkd6s/mdhUns7L/3MMvpQskrh5njhUzcBRZsi6kg2gtditvKESgNA0zvynP1hM6XcbM003epV+BdeO 63wjY8cljInjbNUoHb0+Ir7ee7tY98QPrl293x+FRZ5z63OUobuGwu4PxZw/EbylzwhqeTknQomoop jSZoSSf3Odg90Bi9GxqR3olaWjvoG8lK+5B5d+up4rTcrBWTpWfdB8OjlfiYe3c8kPpa0nxgxYJGzq xzricI9yybkE4Vs6nuTVxZOoXhlm8Y/yJ2gCBm+nyYAwaD4YwpBM2YOfX4xp5mr8WvdRiqyqkfzRuN 8AElmahXxaU80VAz+/ZdayqpG2Py79KOURBcPQCImfKiV8T7G5vJwFW8kkdg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to how we detect mem, size pairs in kfunc, teach verifier to
treat __ref suffix on argument name to imply that it must be a
referenced pointer when passed to kfunc. This is required to ensure that
kfunc that operate on some object only work on acquired pointers and not
normal PTR_TO_BTF_ID with same type which can be obtained by pointer
walking. Release functions need not specify such suffix on release
arguments as they are already expected to receive one referenced
argument.

Note that we use strict type matching when a __ref suffix is present on
the argument.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/btf.c   | 48 ++++++++++++++++++++++++++++++++++------------
 net/bpf/test_run.c |  5 +++++
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f08037c31dd7..7b4128e3359a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6136,18 +6136,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
 	return true;
 }
 
-static bool is_kfunc_arg_mem_size(const struct btf *btf,
-				  const struct btf_param *arg,
-				  const struct bpf_reg_state *reg)
+static bool btf_param_match_suffix(const struct btf *btf,
+				   const struct btf_param *arg,
+				   const char *suffix)
 {
-	int len, sfx_len = sizeof("__sz") - 1;
-	const struct btf_type *t;
+	int len, sfx_len = strlen(suffix);
 	const char *param_name;
 
-	t = btf_type_skip_modifiers(btf, arg->type, NULL);
-	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
-		return false;
-
 	/* In the future, this can be ported to use BTF tagging */
 	param_name = btf_name_by_offset(btf, arg->name_off);
 	if (str_is_empty(param_name))
@@ -6156,22 +6151,41 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	if (len < sfx_len)
 		return false;
 	param_name += len - sfx_len;
-	if (strncmp(param_name, "__sz", sfx_len))
+	if (strncmp(param_name, suffix, sfx_len))
 		return false;
 
 	return true;
 }
 
+static bool is_kfunc_arg_ref(const struct btf *btf,
+			     const struct btf_param *arg)
+{
+	return btf_param_match_suffix(btf, arg, "__ref");
+}
+
+static bool is_kfunc_arg_mem_size(const struct btf *btf,
+				  const struct btf_param *arg,
+				  const struct bpf_reg_state *reg)
+{
+	const struct btf_type *t;
+
+	t = btf_type_skip_modifiers(btf, arg->type, NULL);
+	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
+		return false;
+
+	return btf_param_match_suffix(btf, arg, "__sz");
+}
+
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    const struct btf *btf, u32 func_id,
 				    struct bpf_reg_state *regs,
 				    bool ptr_to_mem_ok)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
+	bool rel = false, kptr_get = false, arg_ref = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
 	bool is_kfunc = btf_is_kernel(btf);
-	bool rel = false, kptr_get = false;
 	const char *func_name, *ref_tname;
 	const struct btf_type *t, *ref_t;
 	const struct btf_param *args;
@@ -6231,6 +6245,15 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* Check if argument must be a referenced pointer, args + i has
+		 * been verified to be a pointer (after skipping modifiers).
+		 */
+		arg_ref = is_kfunc_arg_ref(btf, args + i);
+		if (is_kfunc && arg_ref && !reg->ref_obj_id) {
+			bpf_log(log, "R%d must be referenced\n", regno);
+			return -EINVAL;
+		}
+
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
@@ -6332,7 +6355,8 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			reg_ref_tname = btf_name_by_offset(reg_btf,
 							   reg_ref_t->name_off);
 			if (!btf_struct_ids_match(log, reg_btf, reg_ref_id,
-						  reg->off, btf, ref_id, rel && reg->ref_obj_id)) {
+						  reg->off, btf, ref_id,
+						  arg_ref || (rel && reg->ref_obj_id))) {
 				bpf_log(log, "kernel function %s args#%d expected pointer to %s %s but R%d has a pointer to %s %s\n",
 					func_name, i,
 					btf_type_str(ref_t), ref_tname,
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a..4314b8172b52 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -691,6 +691,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
 {
 }
 
+noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
+{
+}
+
 __diag_pop();
 
 ALLOW_ERROR_INJECTION(bpf_modify_return_test, ERRNO);
@@ -714,6 +718,7 @@ BTF_ID(func, bpf_kfunc_call_test_fail3)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID(func, bpf_kfunc_call_test_mem_len_fail2)
+BTF_ID(func, bpf_kfunc_call_test_ref)
 BTF_SET_END(test_sk_check_kfunc_ids)
 
 BTF_SET_START(test_sk_acquire_kfunc_ids)
-- 
2.36.1

