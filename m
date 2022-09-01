Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81605A9D57
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235104AbiIAQoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbiIAQoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:44:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F2A97B31;
        Thu,  1 Sep 2022 09:43:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A816A61FAF;
        Thu,  1 Sep 2022 16:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D17C433C1;
        Thu,  1 Sep 2022 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662050637;
        bh=F0UE1zbi5RFx3ubQb7yZX3C9AdizxwoKe/hy0ZvG3s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwhZlNEiMK8VwEQS2Yxx49WngT3q70uy5arMIgGZIKcHsqP/pYFB+VJ8qA0YPtsog
         d4XgDJYSyZApPGQcEkd2FFKGGSe6kZPt8ilnvdUQSWxYDRFvnBnqcK9vHbOIZjyq3e
         9pNB8wpMWaK2XilPNFPMvUrxEmJ3VKxPqcQ4yOpZ9W09WLLzPIw4GX3UQbuQSASrtw
         kytHTYZLvV65FBTDdXSAOk2dUAQJjARuYjWhHl4HXDXKsXA6g2jVMePW74UQQ1bpK1
         CxIjlt5pr0KgZytJsQfl9DBAx1t4JyxLlanwK9UfsGKsPb45VhWlx1wfIA8+RfrB3z
         vKtgbtsCaHfag==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH bpf-next 1/4] bpf: Add support for per-parameter trusted args
Date:   Thu,  1 Sep 2022 18:43:24 +0200
Message-Id: <e2a8c940243cba50280818dd6310e08a296e84f0.1662050126.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662050126.git.lorenzo@kernel.org>
References: <cover.1662050126.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Similar to how we detect mem, size pairs in kfunc, teach verifier to
treat __ref suffix on argument name to imply that it must be a trusted
arg when passed to kfunc, similar to the effect of KF_TRUSTED_ARGS flag
but limited to the specific parameter. This is required to ensure that
kfunc that operate on some object only work on acquired pointers and not
normal PTR_TO_BTF_ID with same type which can be obtained by pointer
walking. Release functions need not specify such suffix on release
arguments as they are already expected to receive one referenced
argument.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 Documentation/bpf/kfuncs.rst | 18 +++++++++++++++++
 kernel/bpf/btf.c             | 39 ++++++++++++++++++++++++------------
 net/bpf/test_run.c           |  9 +++++++--
 3 files changed, 51 insertions(+), 15 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 781731749e55..a9d77d12fd0c 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -72,6 +72,24 @@ argument as its size. By default, without __sz annotation, the size of the type
 of the pointer is used. Without __sz annotation, a kfunc cannot accept a void
 pointer.
 
+2.2.2 __ref Annotation
+----------------------
+
+This annotation is used to indicate that the argument is trusted, i.e. it will
+be a pointer from an acquire function (defined later), and its offset will be
+zero. This annotation has the same effect as the KF_TRUSTED_ARGS kfunc flag but
+only on the parameter it is applied to. An example is shown below::
+
+        void bpf_task_send_signal(struct task_struct *task__ref, int signal)
+        {
+        ...
+        }
+
+Here, bpf_task_send_signal will only act on trusted task_struct pointers, and
+cannot be used on pointers obtained using pointer walking. This ensures that
+caller always calls this kfunc on a task whose lifetime is guaranteed for the
+duration of the call.
+
 .. _BPF_kfunc_nodef:
 
 2.3 Using an existing kernel function
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 903719b89238..7e273f949ee8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6140,18 +6140,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
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
@@ -6160,10 +6155,26 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
 	if (len < sfx_len)
 		return false;
 	param_name += len - sfx_len;
-	if (strncmp(param_name, "__sz", sfx_len))
+	return !strncmp(param_name, suffix, sfx_len);
+}
+
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
 		return false;
 
-	return true;
+	return btf_param_match_suffix(btf, arg, "__sz");
 }
 
 static int btf_check_func_arg_match(struct bpf_verifier_env *env,
@@ -6173,7 +6184,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 				    u32 kfunc_flags)
 {
 	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
-	bool rel = false, kptr_get = false, trusted_arg = false;
+	bool rel = false, kptr_get = false, kf_trusted_args = false;
 	bool sleepable = false;
 	struct bpf_verifier_log *log = &env->log;
 	u32 i, nargs, ref_id, ref_obj_id = 0;
@@ -6211,7 +6222,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		/* Only kfunc can be release func */
 		rel = kfunc_flags & KF_RELEASE;
 		kptr_get = kfunc_flags & KF_KPTR_GET;
-		trusted_arg = kfunc_flags & KF_TRUSTED_ARGS;
+		kf_trusted_args = kfunc_flags & KF_TRUSTED_ARGS;
 		sleepable = kfunc_flags & KF_SLEEPABLE;
 	}
 
@@ -6222,6 +6233,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		enum bpf_arg_type arg_type = ARG_DONTCARE;
 		u32 regno = i + 1;
 		struct bpf_reg_state *reg = &regs[regno];
+		bool trusted_arg = false;
 
 		t = btf_type_skip_modifiers(btf, args[i].type, NULL);
 		if (btf_type_is_scalar(t)) {
@@ -6240,6 +6252,7 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 		/* Check if argument must be a referenced pointer, args + i has
 		 * been verified to be a pointer (after skipping modifiers).
 		 */
+		trusted_arg = kf_trusted_args || is_kfunc_arg_ref(btf, args + i);
 		if (is_kfunc && trusted_arg && !reg->ref_obj_id) {
 			bpf_log(log, "R%d must be referenced\n", regno);
 			return -EINVAL;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 25d8ecf105aa..b735accf8750 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -691,7 +691,11 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
 {
 }
 
-noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p)
+noinline void bpf_kfunc_call_test_trusted(struct prog_test_ref_kfunc *p)
+{
+}
+
+noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
 {
 }
 
@@ -722,7 +726,8 @@ BTF_ID_FLAGS(func, bpf_kfunc_call_test_fail3)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_pass1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail1)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_mem_len_fail2)
-BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_trusted, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_kfunc_call_test_ref)
 BTF_ID_FLAGS(func, bpf_kfunc_call_test_destructive, KF_DESTRUCTIVE)
 BTF_SET8_END(test_sk_check_kfunc_ids)
 
-- 
2.37.2

