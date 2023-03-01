Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2868A6A7041
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCAPvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjCAPvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:51:21 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF6E47403;
        Wed,  1 Mar 2023 07:51:08 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 132so7954835pgh.13;
        Wed, 01 Mar 2023 07:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YU4pMAod8HyLKZA/SKat+W0kbmawXHD8Dt9X7wyI7vk=;
        b=N31D4N8YtO1B92IaTlMw99EvATN43n9vUNYVnBnFQmDxJ2DEH9kT8mn5mTss3n+ZtL
         YdAaGnIs+kWtnbBANQCEieHxL7ut8+vTysV/gc7KtP680Azu7uTwTj+IWCBvYDetlSMX
         ct1s9c8ddvkK50pt2zL+Kk6QfeNrVq9OVSDvQV+PVJepXABqa64abkBxoRNiw3zgMGHK
         2K8W9JMDtt3712cm1UY9Z4M4KuJvNmCkjCEIY5LhyWiIR/QW9bvcEWlwMEvYm63dqXIR
         LLtN3hehq9U4fnwjk5pUuydopErrecfyl92UudJa56jNHTX+etFY3FRyeQ/ymfJM76OM
         vA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YU4pMAod8HyLKZA/SKat+W0kbmawXHD8Dt9X7wyI7vk=;
        b=6dzkE+c1RNIWtfAl3F8OLJlTdvLznolwz+UsxCwbxEwyXfpL7yjyqMMBxrde3USdXv
         fBlu6nTXF9CipZKIYjZkJoNGMtkk87ALSY8oRz+6/Ll5Kbkwq104XUJFV7J6Qn7bJxJP
         uKHQ46UHvz+UoXHha82IS+eH80hDd0S8+sqxnERPlr7UQFYrWbPNLnEZ2GH7BZXTObts
         jmsYTusgAR7IXAK8zEvz7gSkGHmIZlY8oBHn3Obygez493s9zUx2ePHzX4j7fYh2ibFl
         9J2XtsB0ZOcb0JKBGxv0VtMu8b24PQujmFvd3Z2frMDRNr9djK0NaRMskFWYyu2L8rjP
         IquQ==
X-Gm-Message-State: AO0yUKX0y6+jXCW6aorx5KlyRd+AftSE0FSUdk05kKZe5dm7/1yUSOao
        oesf3v/jt8O4kY7Q7LnRBeXf7LP5TEs=
X-Google-Smtp-Source: AK7set+ldy0v+DqD0D4k0DcAF5f7FCjkhgS2tmBJel9VQhaM5tlf6ps5eYF4Fn9EiTpSZYwicmL8aw==
X-Received: by 2002:a62:64cb:0:b0:593:d276:1931 with SMTP id y194-20020a6264cb000000b00593d2761931mr6209767pfb.14.1677685867070;
        Wed, 01 Mar 2023 07:51:07 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:51:06 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 06/10] bpf: Add __uninit kfunc annotation
Date:   Wed,  1 Mar 2023 07:49:49 -0800
Message-Id: <20230301154953.641654-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
MIME-Version: 1.0
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

This patch adds __uninit as a kfunc annotation.

This will be useful for scenarios such as for example in dynptrs,
indicating whether the dynptr should be checked by the verifier as an
initialized or an uninitialized dynptr.

Without this annotation, the alternative would be needing to hard-code
in the verifier the specific kfunc to indicate that arg should be
treated as an uninitialized arg.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 Documentation/bpf/kfuncs.rst | 17 +++++++++++++++++
 kernel/bpf/verifier.c        | 18 ++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 226313747be5..9a78533d25ac 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -100,6 +100,23 @@ Hence, whenever a constant scalar argument is accepted by a kfunc which is not a
 size parameter, and the value of the constant matters for program safety, __k
 suffix should be used.
 
+2.2.2 __uninit Annotation
+--------------------
+
+This annotation is used to indicate that the argument will be treated as
+uninitialized.
+
+An example is given below::
+
+        __bpf_kfunc int bpf_dynptr_from_skb(..., struct bpf_dynptr_kern *ptr__uninit)
+        {
+        ...
+        }
+
+Here, the dynptr will be treated as an uninitialized dynptr. Without this
+annotation, the verifier will reject the program if the dynptr passed in is
+not initialized.
+
 .. _BPF_kfunc_nodef:
 
 2.3 Using an existing kernel function
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8fd2f26a8977..d052aa5800de 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8727,6 +8727,11 @@ static bool is_kfunc_arg_alloc_obj(const struct btf *btf, const struct btf_param
 	return __kfunc_param_match_suffix(btf, arg, "__alloc");
 }
 
+static bool is_kfunc_arg_uninit(const struct btf *btf, const struct btf_param *arg)
+{
+	return __kfunc_param_match_suffix(btf, arg, "__uninit");
+}
+
 static bool is_kfunc_arg_scalar_with_name(const struct btf *btf,
 					  const struct btf_param *arg,
 					  const char *name)
@@ -9662,17 +9667,26 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				return ret;
 			break;
 		case KF_ARG_PTR_TO_DYNPTR:
+		{
+			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
+
 			if (reg->type != PTR_TO_STACK &&
 			    reg->type != CONST_PTR_TO_DYNPTR) {
 				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
 				return -EINVAL;
 			}
 
-			ret = process_dynptr_func(env, regno, insn_idx,
-						  ARG_PTR_TO_DYNPTR | MEM_RDONLY);
+			if (reg->type == CONST_PTR_TO_DYNPTR)
+				dynptr_arg_type |= MEM_RDONLY;
+
+			if (is_kfunc_arg_uninit(btf, &args[i]))
+				dynptr_arg_type |= MEM_UNINIT;
+
+			ret = process_dynptr_func(env, regno, insn_idx, dynptr_arg_type);
 			if (ret < 0)
 				return ret;
 			break;
+		}
 		case KF_ARG_PTR_TO_LIST_HEAD:
 			if (reg->type != PTR_TO_MAP_VALUE &&
 			    reg->type != (PTR_TO_BTF_ID | MEM_ALLOC)) {
-- 
2.34.1

