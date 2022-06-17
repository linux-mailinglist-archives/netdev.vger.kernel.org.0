Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E772054F608
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382018AbiFQK5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiFQK5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:57:42 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6840A29348
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:57:39 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id g25so8032922ejh.9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mWYyeMwi13pXDXYKNIGoy1I9a/3/4b0VlegrhxpACmM=;
        b=RXMz2l9Vog/STEZaAhE8CQCzZTS8R7Wub4UBYMqp3c/iaJh0Q6EVsOtbbLct8PngB9
         M0qKhLrPI6cxYN0pqTNJ5I8ZoEfE9nzg2WeX+pbJr+dGSjsg+cPrdPHA41/IV74PoT1+
         R/O5ZKpHQz2tjgIKKHFpwwdy0FQI6mghEzIyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mWYyeMwi13pXDXYKNIGoy1I9a/3/4b0VlegrhxpACmM=;
        b=SRZNwHOeiKxOQxwKuJkNOAb+2jK0XMdaHC+C5kkH2U99Fmzc7lJzOjpRCWdsbY0jix
         9VHV2zHNYx0esb9lFtZ2FLnHy1t1Il45MMnepU3APmn4yoIg3/QqbiidH6J5kgAarsdC
         70/NFwhaInJaeLhuq1QLkJXMktgk7LD0OwdGvyMwm3sacyNEhB3C2BRtaIFgAARqosDy
         Nj+3HdbhqoIXbr74u2dlCCM6ZHoK2hlGhnyY1+F6MMuD7btRBsEZe6a4on9G8hZr8G/6
         BZBIga5lME1s1iyGA3nHr3P+4/4RPPapZ4ck2ggqw71xYjQUTRtj5axY8MbRn1B3P1cq
         kQXg==
X-Gm-Message-State: AJIora9QoKPDT3K+d3cSAWHxJXwIIOMderxIHN72ku8dqSN7GYHP+ari
        3tSax6xRm+KD4yzrV6wJV92srQ==
X-Google-Smtp-Source: AGRyM1sV0qqhkERnD1bTlYaRu4Pd+wAcbE8FanYJC5y8agcrGMDgrvECljMAwPlIvWtdIrqbWFbd5w==
X-Received: by 2002:a17:906:a245:b0:708:ce69:e38b with SMTP id bi5-20020a170906a24500b00708ce69e38bmr8590575ejb.100.1655463458090;
        Fri, 17 Jun 2022 03:57:38 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id us12-20020a170906bfcc00b00709e786c7b2sm2017376ejb.213.2022.06.17.03.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:57:37 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Tony Ambardar <Tony.Ambardar@gmail.com>
Subject: [PATCH bpf-next 1/2] bpf: x64: Add predicate for bpf2bpf with tailcalls support in JIT
Date:   Fri, 17 Jun 2022 12:57:34 +0200
Message-Id: <20220617105735.733938-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220617105735.733938-1-jakub@cloudflare.com>
References: <20220617105735.733938-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Ambardar <tony.ambardar@gmail.com>

The BPF core/verifier is hard-coded to permit mixing bpf2bpf and tail
calls for only x86-64. Change the logic to instead rely on a new weak
function 'bool bpf_jit_supports_subprog_tailcalls(void)', which a capable
JIT backend can override.

Update the x86-64 eBPF JIT to reflect this.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
[jakub: drop MIPS bits and tweak patch subject]
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 arch/x86/net/bpf_jit_comp.c | 6 ++++++
 include/linux/filter.h      | 1 +
 kernel/bpf/core.c           | 6 ++++++
 kernel/bpf/verifier.c       | 3 ++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index f298b18a9a3d..2c51ca9f7cec 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2491,3 +2491,9 @@ void *bpf_arch_text_copy(void *dst, void *src, size_t len)
 		return ERR_PTR(-EINVAL);
 	return dst;
 }
+
+/* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool bpf_jit_supports_subprog_tailcalls(void)
+{
+	return true;
+}
diff --git a/include/linux/filter.h b/include/linux/filter.h
index d0cbb31b1b4d..4c1a8b247545 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -914,6 +914,7 @@ u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
 bool bpf_jit_needs_zext(void);
+bool bpf_jit_supports_subprog_tailcalls(void);
 bool bpf_jit_supports_kfunc_call(void);
 bool bpf_helper_changes_pkt_data(void *func);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b5ffebcce6cc..f023cb399e3f 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2729,6 +2729,12 @@ bool __weak bpf_jit_needs_zext(void)
 	return false;
 }
 
+/* Return TRUE if the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool __weak bpf_jit_supports_subprog_tailcalls(void)
+{
+	return false;
+}
+
 bool __weak bpf_jit_supports_kfunc_call(void)
 {
 	return false;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2859901ffbe3..f64d2598d7d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6154,7 +6154,8 @@ static bool may_update_sockmap(struct bpf_verifier_env *env, int func_id)
 
 static bool allow_tail_call_in_subprogs(struct bpf_verifier_env *env)
 {
-	return env->prog->jit_requested && IS_ENABLED(CONFIG_X86_64);
+	return env->prog->jit_requested &&
+	       bpf_jit_supports_subprog_tailcalls();
 }
 
 static int check_map_func_compatibility(struct bpf_verifier_env *env,
-- 
2.35.3

