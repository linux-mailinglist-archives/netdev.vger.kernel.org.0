Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957576A2EE5
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBZIwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBZIwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:52:11 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B902C14997;
        Sun, 26 Feb 2023 00:52:09 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p6so2943889plf.0;
        Sun, 26 Feb 2023 00:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVie7F8WUf2v5YB8WwziocQ8yrS/Fp63KxmpEgw43Ic=;
        b=PVx8w+ac95q4kaWVR81jJcItLXjq7mAEKwOAGkkMO2yGleT31bxCniuTRI12I6Z9dC
         EMBHCNuC33kmWEFY8gI9BTcUK1ki80Bt7Ov/T1xxKdFNtMSuID7c2KY8Ev9Q81oR6wct
         RfI/rbHtMg17QxlUOGA8JQe4Er7ddHOJH5H7pqf6piPYDyEF/egHNKtdIhwXAVJh0znI
         0bS75GtDekNCcEOq8Kii9l5lBOFwPYxRMXvyPoldc5t/dWZxGT13av7LjRFeXEdLYu25
         v7Xy44GnGuweGtic5XQLgKRv2ZgufEvPwnITHfelPT3zGrG0545z8O7rQsPCos2BmADt
         j5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVie7F8WUf2v5YB8WwziocQ8yrS/Fp63KxmpEgw43Ic=;
        b=lqRzYHzs9x5LoXU/9nPUITXeFnHo8aqSHrSa7oGNCfRjv+vhdCZMxquz+vMjXd+ZQk
         FR7fwPg1cFFhRbogNQSsOl0npVkT8DzTJxt6qsxSeRKNAoU6HOrJDbQg9teaI+2WiZo2
         kdYCdvCrNrrY7ttW2Pf0/vLlCkQSDyb3gT63KetN5IiJgGHc/oDNG1xRcSS84K9qyTv2
         yDVKS6VW+3PfaPXkRaxQu4ZvmL9ISo0wd6ZHqXVZ3utmyTI35rsVvGz6Y2UAMBQ6cXkn
         Tl3YAfSic8r4O3tU+jCK2maO3Yn9iyWS70tgnP3KIpz2GqkSIqQd0ktf3a2gQfrA96KN
         qhOQ==
X-Gm-Message-State: AO0yUKVNe7vAoqPUlCc/GbDkVF+sKnaSFBaia5S3BQ8YbTdmfQTL+RHN
        An6UR5U4bg8rFhTEiuIi14TZ1dColBY=
X-Google-Smtp-Source: AK7set//YNnC7ZpmhmFZSkMErdwunM/aIu2dEb5/Pyphv545Gh5/NnCiq0tZhxFoQMt9looJV2XEgQ==
X-Received: by 2002:a05:6a21:6d9e:b0:cc:b73a:1079 with SMTP id wl30-20020a056a216d9e00b000ccb73a1079mr5518455pzb.62.1677401528696;
        Sun, 26 Feb 2023 00:52:08 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:52:08 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 06/10] bpf: Add __uninit kfunc annotation
Date:   Sun, 26 Feb 2023 00:51:16 -0800
Message-Id: <20230226085120.3907863-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230226085120.3907863-1-joannelkoong@gmail.com>
References: <20230226085120.3907863-1-joannelkoong@gmail.com>
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
index cedd38292a62..3a7f69b29053 100644
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

