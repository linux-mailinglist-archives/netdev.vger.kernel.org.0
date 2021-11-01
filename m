Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB5442355
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhKAWYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhKAWYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:24:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D55C061714;
        Mon,  1 Nov 2021 15:21:59 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so17698161pff.3;
        Mon, 01 Nov 2021 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L/L+iEcylYaJRN1JEwZW2WFGkpHOtnIBjD4CtEr0pII=;
        b=Fg3kdZPRC/62WOiA8rqusBX0B+GCymI6Hzw8O+xXXHOMoIjzTYbUjodnf2za0gJAYQ
         +EBhxcTc2zIvo2EXZs9YPqzzHpkL8Z4qT7jGI2vKEz/57omLMIiUjx6K1rz/hwiAGXLt
         X5b3yyqTOAVW4BfSYzRxFVZ1H+MXaXq75ES6KcPQ400DpNxQ3DJ3O3NuqaGkHx0AIxAR
         SgHd+EYMkX9WsUOu2RUAIxnezQnKsS2NznZfQWisVa/3NMvPnFGwH+6JxAIWZa5MXyLQ
         gFEURp+DJXMpRZclVtL0LUdJtlHrMtr7C3x3NeRie27xN+Ji4L7f5dA+U07AkuvEs8D/
         FnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L/L+iEcylYaJRN1JEwZW2WFGkpHOtnIBjD4CtEr0pII=;
        b=L5FwnVM+G6Hykiz+bKw8ZfGFNeei0y2ZOMR4IP2gomglO2RyqGE0rGrqjM5gtX6xeH
         4GM08WwKyNv8/2rwPOBlntWKVRA/32WoYbiA+YL4vLn9AapIBYNLXe0/lgBm49m6Hsz6
         YvB0Zik6OSfEMT3vp6NQsmYXESWzX54k5CUqT4JzHIbwcEb9aKTMTE77TGqvPHfqUiEq
         ho7lFoBJ4VhEYrUyOszEJm8PiQB7Yrl0K8YfVCaBBGyqZhOjV4kOsKE/j8cPu2Hygz/O
         jzRMvcNK1ntb043ZwrfX8IS9/ITFVL6Ihk7BRRouERq9V5+VTUC/E3hSypilGE6UhqnJ
         ACuQ==
X-Gm-Message-State: AOAM530OQTWwiWQ2upCWXBXZwjbBze6NEAewryh1Ilq+G5uhjlF7ej4c
        mlqa7qU43NblGVrrYz+xKjA=
X-Google-Smtp-Source: ABdhPJzO1mdx7Q84O+aPBuS+XdV8E/liSzzpotEWOgLNhdG63O+bsLeVPL+eOTZ4ikzBGdwGn3PxLw==
X-Received: by 2002:a62:7cc8:0:b0:481:db:39dc with SMTP id x191-20020a627cc8000000b0048100db39dcmr11769367pfc.60.1635805318879;
        Mon, 01 Nov 2021 15:21:58 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:880e])
        by smtp.gmail.com with ESMTPSA id a7sm16021025pfo.32.2021.11.01.15.21.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 15:21:58 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 2/3] bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
Date:   Mon,  1 Nov 2021 15:21:52 -0700
Message-Id: <20211101222153.78759-2-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Similar to unsigned bounds propagation fix signed bounds.
The 'Fixes' tag is a hint. There is no security bug here.
The verifier was too conservative.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 29671ed49ee8..a4b48bd4e3ca 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1420,7 +1420,7 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
 
 static bool __reg64_bound_s32(s64 a)
 {
-	return a > S32_MIN && a < S32_MAX;
+	return a >= S32_MIN && a <= S32_MAX;
 }
 
 static bool __reg64_bound_u32(u64 a)
-- 
2.30.2

