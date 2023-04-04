Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD406D57BF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjDDEvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbjDDEvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:51:09 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05152697;
        Mon,  3 Apr 2023 21:51:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z11so20629375pfh.4;
        Mon, 03 Apr 2023 21:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583862; x=1683175862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYCczLlj+qI2Rf3310jhdvz1Q1q9UTepuX5/jYcvRP0=;
        b=OxQmHX3NxS4UedNoIietUQB5stCXClbPVKSPw3uCxvDmIr3uoe4/T3OvI0ybR8y36I
         50gW5JWWCmxTIeyZvecvahqpdFVid+b/1D5f8vAHFHLMJU3sv4NQ9brjhQWsIOVPYd6J
         9tdsRNsuzTMBBeSul/vgrxTLA50SKi2hx1sUgGp96Ehcdu9tYhZtr1Rk+h6miRCqaqRM
         IeYunshZt9VHjWFBFoRwFIVyMRyXPociKDkvwy1Ab8C7FqKKr7Ek9ai3fVn89slLR1sd
         jvfI8Oja2mNa/D8xClYqOMCVjkPc//muQqE4cf91z6EyDz9foxsJ5oQoqOhGC++kDHZ5
         FZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583862; x=1683175862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYCczLlj+qI2Rf3310jhdvz1Q1q9UTepuX5/jYcvRP0=;
        b=ppObmOG76NucHVr2m1taL1W9v4pBy/ZWriadAiPHJU88rAIJckoUzsDlAk+rEw9GPr
         gbJ0K6KLbyM/OvEFf0nV3d0EBPE0KCrHME01vqgMLxsAmtd60RDKRhDG8q3QaJuGpFn/
         LMLAESOln0fQLl7opuinZkMMGvICeKP3XtX70KOjnjtU+2pWEglL/TwKxhTcPkZNAwdU
         EtoruhzZLVQNkREbgbXrjc89EJz/gpU2QuAZcOCH1ib0k1IWFQ8JhiQRzv0iPN+7oNyq
         P7mwSuRDul5dseWM3C4BVxPUoDSNiCvr8wX8uvZt9rFzsxNBsmuaRZrEDdgqx3AnVKgI
         kdJw==
X-Gm-Message-State: AAQBX9eHLcasOiB1foApGntb8nqbCgDUB/9l9/JdxQM2+msQ5+yrByVK
        IkWL/ItzI5cbjCodxJaEkcY=
X-Google-Smtp-Source: AKy350YW0ZSfjmnOUuyeFMixtydXRrsvXkUTRBxYNrcanrZkF4FJhTMCV3b1uhgRkvEqaxPRAjlsvA==
X-Received: by 2002:a05:6a00:11:b0:625:fe60:9b5c with SMTP id h17-20020a056a00001100b00625fe609b5cmr1059525pfk.23.1680583862088;
        Mon, 03 Apr 2023 21:51:02 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id u4-20020a62ed04000000b005a84ef49c63sm7652120pfh.214.2023.04.03.21.51.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:51:01 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 7/8] bpf: Undo strict enforcement for walking untagged fields.
Date:   Mon,  3 Apr 2023 21:50:28 -0700
Message-Id: <20230404045029.82870-8-alexei.starovoitov@gmail.com>
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

The commit 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
broke several tracing bpf programs. Even in clang compiled kernels there are
many fields that are not marked with __rcu that are safe to read and pass into
helpers, but the verifier doesn't know that they're safe. Aggressively marking
them as PTR_UNTRUSTED was premature.

Fixes: 6fcd486b3a0a ("bpf: Refactor RCU enforcement in the verifier.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fd90ba498ccc..56f569811f70 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4974,6 +4974,11 @@ static bool is_rcu_reg(const struct bpf_reg_state *reg)
 	return reg->type & MEM_RCU;
 }
 
+static void clear_trusted_flags(enum bpf_type_flag *flag)
+{
+	*flag &= ~(BPF_REG_TRUSTED_MODIFIERS | MEM_RCU);
+}
+
 static int check_pkt_ptr_alignment(struct bpf_verifier_env *env,
 				   const struct bpf_reg_state *reg,
 				   int off, int size, bool strict)
@@ -5602,8 +5607,8 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 			} else if (flag & (MEM_PERCPU | MEM_USER)) {
 				/* keep as-is */
 			} else {
-				/* walking unknown pointers yields untrusted pointer */
-				flag = PTR_UNTRUSTED;
+				/* walking unknown pointers yields old deprecated PTR_TO_BTF_ID */
+				clear_trusted_flags(&flag);
 			}
 		} else {
 			/*
@@ -5617,7 +5622,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		}
 	} else {
 		/* Old compat. Deprecated */
-		flag &= ~PTR_TRUSTED;
+		clear_trusted_flags(&flag);
 	}
 
 	if (atype == BPF_READ && value_regno >= 0)
-- 
2.34.1

