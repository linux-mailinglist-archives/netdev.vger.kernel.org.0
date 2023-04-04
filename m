Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06016D57BB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbjDDEvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbjDDEu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:50:58 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946111FEE;
        Mon,  3 Apr 2023 21:50:54 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso32752998pjb.2;
        Mon, 03 Apr 2023 21:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583854; x=1683175854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9EIIrkyDfeXGi2D7arXqdGRO5YUqjTAwchDB5thL54=;
        b=Q+SuKfHJD06lA1i2DyA6LOFYBH3LO9Ur4zxvd/KEeNvFozkM+ooH1liPmclIownv9L
         X4ty2EXczPKNPwKXqgGJmTMj4E7qsC15QG8Ph+mBWXHuT2DddOrVmElohSeTi9WYNjzL
         Ets3rOIjT0slvX+kmWVpcLmFSHuyHpsbyEBq25FQ/nZH7ydObgitX6j1VzRK3j5oSVlK
         Y/ksTKNtN8Pl6QgbAjvH4QznrqHJZUMb5RjYrOfthFGyy5WHGhqb8ZiMDZiJLH5TWPgQ
         ZQ/+DwGYjBaoyMMw9LAI/iP588+mHLsTZEeTsZrmq63MvKokACdR002mEQ4VAEqQhfAN
         Z4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583854; x=1683175854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9EIIrkyDfeXGi2D7arXqdGRO5YUqjTAwchDB5thL54=;
        b=vrhpsab3J65c+8Pwx2Qhl21u6a0xYarirPaWd3xJcnnEZ3AlaJHGCWc3pKQOw4jXkc
         zbULeNcI0VZvZ10B1Fa8kCbasROT/LaAhOHpgXwzz8p9nm/saAv2bLkFZvKmF9KChNV9
         GlEdnb5R16cG+0By8pHZDJcwazGDbrB8K5XCSJXKOQwzmNyNvKs2zS/PmBKdbo3kKBUl
         YlkD7jMym5qBP0N4Anmrm0pzbIkx1KEDnZxeTDRsC8hCkLGEprgoBkzwFaFGhbnyR/a2
         sPlWOcHLtp01KCoN0r57qKahhPaKZIJ7SC8dp6j4FMpFLSQZdn1FShL8GaP8h61uYfRD
         SnNw==
X-Gm-Message-State: AAQBX9e6vz93htemq7/zjjqsxCMd3fAjKrYDIpquoGZJ3hRQIrEKJFcQ
        /BQiY7Jd03LJSbdT2mGPdqs=
X-Google-Smtp-Source: AKy350YqcMfCuCiUSZQ9hn0YxhVy+vZGG+StVfntyIbpropFQXU366RiQTvNDlq2AzBjcmOOWLA1dA==
X-Received: by 2002:a17:90b:38cd:b0:240:ce2f:5fc1 with SMTP id nn13-20020a17090b38cd00b00240ce2f5fc1mr1301909pjb.46.1680583853825;
        Mon, 03 Apr 2023 21:50:53 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090abb0300b0023371cb020csm10493731pjr.34.2023.04.03.21.50.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:53 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 5/8] bpf: Refactor NULL-ness check in check_reg_type().
Date:   Mon,  3 Apr 2023 21:50:26 -0700
Message-Id: <20230404045029.82870-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

check_reg_type() unconditionally disallows PTR_TO_BTF_ID | PTR_MAYBE_NULL.
It's problematic for helpers that allow ARG_PTR_TO_BTF_ID_OR_NULL like
bpf_sk_storage_get(). Allow passing PTR_TO_BTF_ID | PTR_MAYBE_NULL into such
helpers. That technically includes bpf_kptr_xchg() helper, but in practice:
  bpf_kptr_xchg(..., bpf_cpumask_create());
is still disallowed because bpf_cpumask_create() returns ref counted pointer
with ref_obj_id > 0.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2cd2e0b725cd..4e7d671497f4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7168,6 +7168,8 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 	case PTR_TO_BTF_ID:
 	case PTR_TO_BTF_ID | PTR_TRUSTED:
 	case PTR_TO_BTF_ID | MEM_RCU:
+	case PTR_TO_BTF_ID | PTR_MAYBE_NULL:
+	case PTR_TO_BTF_ID | PTR_MAYBE_NULL | MEM_RCU:
 	{
 		/* For bpf_sk_release, it needs to match against first member
 		 * 'struct sock_common', hence make an exception for it. This
@@ -7176,6 +7178,12 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 		bool strict_type_match = arg_type_is_release(arg_type) &&
 					 meta->func_id != BPF_FUNC_sk_release;
 
+		if (type_may_be_null(reg->type) &&
+		    (!type_may_be_null(arg_type) || arg_type_is_release(arg_type))) {
+			verbose(env, "Possibly NULL pointer passed to helper arg%d\n", regno);
+			return -EACCES;
+		}
+
 		if (!arg_btf_id) {
 			if (!compatible->btf_id) {
 				verbose(env, "verifier internal error: missing arg compatible BTF ID\n");
@@ -7206,10 +7214,6 @@ static int check_reg_type(struct bpf_verifier_env *env, u32 regno,
 		}
 		break;
 	}
-	case PTR_TO_BTF_ID | PTR_MAYBE_NULL:
-	case PTR_TO_BTF_ID | PTR_MAYBE_NULL | MEM_RCU:
-		verbose(env, "Possibly NULL pointer passed to helper arg%d\n", regno);
-		return -EACCES;
 	case PTR_TO_BTF_ID | MEM_ALLOC:
 		if (meta->func_id != BPF_FUNC_spin_lock && meta->func_id != BPF_FUNC_spin_unlock &&
 		    meta->func_id != BPF_FUNC_kptr_xchg) {
-- 
2.34.1

