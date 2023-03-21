Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DBA6C29BF
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCUFUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCUFUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:20:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300B3399EB;
        Mon, 20 Mar 2023 22:20:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso14798824pjb.2;
        Mon, 20 Mar 2023 22:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679376004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzLvqebVw3MYiQ1vdYwWMDg0dSlQISX+oRSaHN6DRqE=;
        b=KKBkEsq+w4tNNqlyF+hcJvwyppiKS5HEq0hfYHjAosql9DJYNIFhJZNzYMMsxUH1kk
         ei2bWfb8kOOa9kPC1qkcE3QURTuBykXx6QAN6hs3qqxQxZpSgzFQjOQ7hYwOtU6wv1DI
         1xkYD4LRkocInDlAVip4/o1138TuDBFBfxHe2nEIIBkdpkKRM7KTu4DMFoZo/Z6V4zSp
         GjkjWrx6W7BqDoJc6IAlTPVMf3HM6FKRLC8ffSPgTBqEAMr/aQ3+T7EbBtxvUBxb8A15
         465AI7Yvk3oL5FRST2NwHrAPvN47voiOQY7iRLD9TQoE3UcOKcB09wy1jPDDWzOmW50v
         9uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679376004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RzLvqebVw3MYiQ1vdYwWMDg0dSlQISX+oRSaHN6DRqE=;
        b=w8rej4HrL27O7JHCLfabgtZ7FJlkSghEgMJ02nwAjh6360pgUN3qXYB/r9xF5ajLCP
         A1lyXi/wE2DdKTbFuYeF4Hynf/YCVToO6Mg1iayXLG7zdVM9bsf3ev8/hX3k3uvv6k4C
         A+4cdi08lJr60rrN9rJItUp8kB2EvdgqvqNGi9cLhj9eta9/4yWIyixbYE9DTYw2BNkY
         HpxElOW4Xs7IsZNfRPIptyv5J25+ZgCjPhMApYTfW/XymChVbyx1jGmVDROYMtVdgl5w
         Vg3xm+O008cuofHEPEQjudksLKtPWEIiaU+yZqF7ko5lJCXGd7q98MNBNtVtWPrLaBpY
         a33A==
X-Gm-Message-State: AO0yUKW/i6pKWQVsvK3FO5NiM7/a8aTtiKXlvNgUBbJslC700Tpg9hnS
        FnQL+Lp7ZEtHoEjhe/Xwtwc=
X-Google-Smtp-Source: AK7set9eSvOCPdtSO7zcRDQLIbF+kBL9LKOwBmYcOQiwRiHYCfaGQY9pbxUQZRnmM1EHOyi+alQPHQ==
X-Received: by 2002:a17:90b:3ece:b0:231:248c:6ac4 with SMTP id rm14-20020a17090b3ece00b00231248c6ac4mr1342900pjb.7.1679376004066;
        Mon, 20 Mar 2023 22:20:04 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:1606])
        by smtp.gmail.com with ESMTPSA id i5-20020a170902eb4500b001a045f45d49sm7574079pli.281.2023.03.20.22.20.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Mar 2023 22:20:03 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/4] bpf: Teach the verifier to recognize rdonly_mem as not null.
Date:   Mon, 20 Mar 2023 22:19:49 -0700
Message-Id: <20230321051951.58223-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
References: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
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

