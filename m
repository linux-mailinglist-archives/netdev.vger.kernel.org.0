Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27EC535588
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348820AbiEZVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbiEZVfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657DD9E84;
        Thu, 26 May 2022 14:35:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF0FF61BA6;
        Thu, 26 May 2022 21:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800BCC34113;
        Thu, 26 May 2022 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600930;
        bh=GD3wVha5id9NTQn6ILFEqSIUDXKz8nCPvRiMOCT25Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dn9FF2pMqS0a4hjilbWfvt4tEo/cvAnlVOKbB6QUwycjJIF3K3REOk1wKzOe6YcWb
         tAP3jsqgRym8AdAMxdAHNrLpCpEPIe8b3/BQyQs7txDExfMoc3YL0k7xTWUvUX/x5M
         M15HUpwh9TDtEEggkvbX2i35pqimggdTqQ0K+qi7tZkmiDTMEo6DZUZYPNItTe/6CC
         bB9GR+Dl4sc74c5vbkO36+x9n3yqQ/lEZ2e+9dRtRvMIlgtOUwodI8VgpXVd8AKB9Q
         C9oRD3s/o7h3BBmVz/9GFfGGciPQZL4+xOC6G7VsyFXhI5GwCiATYVoV4sPXcr2eJE
         8H/G1ipXl1Ryw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 01/14] bpf: Add support for forcing kfunc args to be referenced
Date:   Thu, 26 May 2022 23:34:49 +0200
Message-Id: <2c1777dfbc5d3ff06f45bc77dac218db9bdae119.1653600577.git.lorenzo@kernel.org>
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

Similar to how we detect mem, size pairs in kfunc, teach verifier to
treat __ref suffix on argument name to imply that it must be a
referenced pointer when passed to kfunc. This is required to ensure that
kfunc that operate on some object only work on acquired pointers and not
normal PTR_TO_BTF_ID with same type which can be obtained by pointer
walking. Release functions need not specify such suffix on release
arguments as they are already expected to receive one referenced
argument.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/btf.c   | 42 ++++++++++++++++++++++++++++++++----------
 net/bpf/test_run.c |  5 +++++
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7bccaa4646e5..9f8dec0ab924 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6023,18 +6023,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
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
@@ -6043,12 +6038,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
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
@@ -6117,6 +6131,14 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* Check if argument must be a referenced pointer, args + i has
+		 * been verified to be a pointer (after skipping modifiers).
+		 */
+		if (is_kfunc && is_kfunc_arg_ref(btf, args + i) && !reg->ref_obj_id) {
+			bpf_log(log, "R%d must be referenced\n", regno);
+			return -EINVAL;
+		}
+
 		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
 		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 56f059b3c242..4b796e0a9667 100644
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
2.35.3

