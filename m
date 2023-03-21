Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA396C3BF1
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 21:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjCUUjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 16:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbjCUUjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 16:39:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52B3B677;
        Tue, 21 Mar 2023 13:39:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so6630800pjb.4;
        Tue, 21 Mar 2023 13:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679431145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzLvqebVw3MYiQ1vdYwWMDg0dSlQISX+oRSaHN6DRqE=;
        b=V8Pd9wU+xbOh9nCcjkBgG+Wnk6OQDD3Tb6RuclIECaV+fQUaBoDsxOD400KvLyzJyF
         YOIoWvHLHuhWJ+KrRGAKlkJZVD6+/n/STHdp63ZwRhIV4KSpID6hzbwLcou+2dVF16+w
         1o3V50i1vXvcKoGLu2EhqIphEGznIr83CCWa2/IG17ALuPMOSV6dQcAsrpIrLCZPbXGE
         fTlTmpySMtOn+C3cvHPdYqKdn0G1pCgF/CjMDr/wFwft0CKuTSt5c/C0bsbo2B5Gg8eB
         2s9umq4Ubpca8+ID7qddo4IA+PYyocpxaFesUwwvCHJKddO8BluOh2DMQJk43IwE8M96
         IpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679431145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RzLvqebVw3MYiQ1vdYwWMDg0dSlQISX+oRSaHN6DRqE=;
        b=TbcrQ5B5E+5/hyqH4AZddJAQLUjR1Yh/pJHoXmYAvWIIfSQy2wgLQ4e5ONSaFqwfMJ
         AbtOnEiH0HJ9mvcYckf5+GnneBJqwVbid8hvzQxuYmipVhx3Ce5GfvoydfMalosqGDew
         cnH8wN0q1mxHNY/9Co+trr17OIjhqQojetQa9djk7wsGxa1dk5MUPHq0koWnzMXPGOU6
         NFMX8qpbkFfOsE6M71suvF/WqvVfOW5FNxx1Dln+0H1/6RWCFbLjLkXn14VOhOUtYCMh
         j5OkI4mEYm2e4WryIufhemAYmv/YEi8rUpb26Em6fbndwKMcaNNwzIRud+g5EqoB6gAg
         rOdg==
X-Gm-Message-State: AO0yUKWC8WOPPSeZ6U74u24UY3YmBVR59O7Xb9IL6JJozepJjRl1odvr
        2D13cj5QB1qfIKeAnO82/Ow=
X-Google-Smtp-Source: AK7set84En57KtBxR2o+i0BBpM9V7IwlDM+cYWtv93Knn3+29tJ/78ru6Xoc7l7Q7tJqoE1fhZAPzA==
X-Received: by 2002:a17:90b:4a07:b0:23b:4439:4179 with SMTP id kk7-20020a17090b4a0700b0023b44394179mr1015219pjb.28.1679431144809;
        Tue, 21 Mar 2023 13:39:04 -0700 (PDT)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:500::5:34cf])
        by smtp.gmail.com with ESMTPSA id t8-20020a17090abc4800b0023f8e3702c3sm5743037pjv.30.2023.03.21.13.39.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Mar 2023 13:39:04 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/4] bpf: Teach the verifier to recognize rdonly_mem as not null.
Date:   Tue, 21 Mar 2023 13:38:52 -0700
Message-Id: <20230321203854.3035-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
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

Teach the verifier to recognize PTR_TO_MEM | MEM_RDONLY as not NULL
otherwise if (!bpf_ksym_exists(known_kfunc)) doesn't go through
dead code elimination.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8bc44f5dc5b6..5693e4a92752 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -486,8 +486,17 @@ static bool type_is_sk_pointer(enum bpf_reg_type type)
 		type == PTR_TO_XDP_SOCK;
 }
 
+static bool type_may_be_null(u32 type)
+{
+	return type & PTR_MAYBE_NULL;
+}
+
 static bool reg_type_not_null(enum bpf_reg_type type)
 {
+	if (type_may_be_null(type))
+		return false;
+
+	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
 		type == PTR_TO_MAP_VALUE ||
@@ -531,11 +540,6 @@ static bool type_is_rdonly_mem(u32 type)
 	return type & MEM_RDONLY;
 }
 
-static bool type_may_be_null(u32 type)
-{
-	return type & PTR_MAYBE_NULL;
-}
-
 static bool is_acquire_function(enum bpf_func_id func_id,
 				const struct bpf_map *map)
 {
-- 
2.34.1

