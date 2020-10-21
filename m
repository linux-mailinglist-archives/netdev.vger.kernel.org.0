Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B454229521F
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504023AbgJUSUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 14:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504015AbgJUSUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 14:20:24 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AC4C0613CE;
        Wed, 21 Oct 2020 11:20:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l18so1988321pgg.0;
        Wed, 21 Oct 2020 11:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bQDv4ngMFmZAdWeS/hQnXH5tSvDx9O8/9xskgAUaTrI=;
        b=X46oR3eBSh2053rRWIWetOLLHKNJC5MrkUFbuZYYQ/Emwu53GxqgsjpFHsP182RTOg
         tg0Hvs0XgywmeepsO/wM69unwC7S32euFaI92MMaJPUGSOiREUOrVaLG6WIQlg4wZ4Eg
         Juxh+3c5jU702Tlz3AnQ0niO9BYF93kc5JTFrOvPaOwFgnfa+7y2NR6/VjF/GMLm6mAf
         ftEgb9SGgARMUdwV9ErhD3Ny4YBz7viLqpCwdlHvElG6EHNMkbl4Na7DMGFsteP5/7xh
         5U/Yg73+0qKO61cupIfA7Ic3Q0bx1u1UtQMrJJRd4k93jYE/Ph2xzZjvfo1pcdxSjCqq
         GuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bQDv4ngMFmZAdWeS/hQnXH5tSvDx9O8/9xskgAUaTrI=;
        b=a7TO4cEiQ1ZM1IZckB7fZVtRCyFDGBzgqLjeHBKJ8dM43sKUU5FF5dDvejGVsDdUQ8
         sXueiYJcavQSWTDukHtAo9WwEhDUklwPU6STqJI9AwaaUFoNKtXM/3xmOrXACcmyLUAR
         KJE8pzlpXyX3LniLwpy5aPcpb6iWtsjClDc1LoDVS5GbaoFjAv5U5Vxqm9Rdvz9dGnbt
         PKODa1QarQ3HVWqf2XIGdrKLSX13KMfIzWmD+x7YGzUYC52Tw5mIhxbDhzoWywUSgQ93
         uDmP330Lj7xwVG2xA6U+YF5AICNh53zAAqU1ia/Gxh0QDMWIt2LC56dv5yNmDbagz2EM
         cdUw==
X-Gm-Message-State: AOAM531fbV59ezJ3zBD4hFju6kNiD2/xjdC+awUcbKyVyPosniKLE/tj
        4pRYWLAwbedMobKt/2s9zrkS/zLJYKQWBQ==
X-Google-Smtp-Source: ABdhPJxZyxDtbzpG5mUyRqAWvs7NoPaBMFcVzJ7dRJ6jytmimjb6flMakIqqNwVqaAUnCBbIbHg2kQ==
X-Received: by 2002:a63:e:: with SMTP id 14mr4635728pga.426.1603304423461;
        Wed, 21 Oct 2020 11:20:23 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id v3sm2618672pfu.165.2020.10.21.11.20.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2020 11:20:22 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, jolsa@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: Add asm tests for pkt vs pkt_end comparison.
Date:   Wed, 21 Oct 2020 11:20:15 -0700
Message-Id: <20201021182015.39000-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
References: <20201021182015.39000-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add few assembly tests for packet comparison.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/verifier/ctx_skb.c  | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ctx_skb.c b/tools/testing/selftests/bpf/verifier/ctx_skb.c
index 2e16b8e268f2..2022c0f2cd75 100644
--- a/tools/testing/selftests/bpf/verifier/ctx_skb.c
+++ b/tools/testing/selftests/bpf/verifier/ctx_skb.c
@@ -1089,3 +1089,45 @@
 	.errstr_unpriv = "R1 leaks addr",
 	.result = REJECT,
 },
+{
+       "pkt > pkt_end taken check",
+       .insns = {
+       BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,                //  0. r2 = *(u32 *)(r1 + data_end)
+                   offsetof(struct __sk_buff, data_end)),
+       BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,                //  1. r4 = *(u32 *)(r1 + data)
+                   offsetof(struct __sk_buff, data)),
+       BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),                    //  2. r3 = r4
+       BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),                  //  3. r3 += 42
+       BPF_MOV64_IMM(BPF_REG_1, 0),                            //  4. r1 = 0
+       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),          //  5. if r3 > r2 goto 8
+       BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),                  //  6. r4 += 14
+       BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),                    //  7. r1 = r4
+       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 1),          //  8. if r3 > r2 goto 10
+       BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),            //  9. r2 = *(u8 *)(r1 + 9)
+       BPF_MOV64_IMM(BPF_REG_0, 0),                            // 10. r0 = 0
+       BPF_EXIT_INSN(),                                        // 11. exit
+       },
+       .result = ACCEPT,
+       .prog_type = BPF_PROG_TYPE_SK_SKB,
+},
+{
+       "pkt_end < pkt taken check",
+       .insns = {
+       BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1,                //  0. r2 = *(u32 *)(r1 + data_end)
+                   offsetof(struct __sk_buff, data_end)),
+       BPF_LDX_MEM(BPF_W, BPF_REG_4, BPF_REG_1,                //  1. r4 = *(u32 *)(r1 + data)
+                   offsetof(struct __sk_buff, data)),
+       BPF_MOV64_REG(BPF_REG_3, BPF_REG_4),                    //  2. r3 = r4
+       BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, 42),                  //  3. r3 += 42
+       BPF_MOV64_IMM(BPF_REG_1, 0),                            //  4. r1 = 0
+       BPF_JMP_REG(BPF_JGT, BPF_REG_3, BPF_REG_2, 2),          //  5. if r3 > r2 goto 8
+       BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, 14),                  //  6. r4 += 14
+       BPF_MOV64_REG(BPF_REG_1, BPF_REG_4),                    //  7. r1 = r4
+       BPF_JMP_REG(BPF_JLT, BPF_REG_2, BPF_REG_3, 1),          //  8. if r2 < r3 goto 10
+       BPF_LDX_MEM(BPF_H, BPF_REG_2, BPF_REG_1, 9),            //  9. r2 = *(u8 *)(r1 + 9)
+       BPF_MOV64_IMM(BPF_REG_0, 0),                            // 10. r0 = 0
+       BPF_EXIT_INSN(),                                        // 11. exit
+       },
+       .result = ACCEPT,
+       .prog_type = BPF_PROG_TYPE_SK_SKB,
+},
-- 
2.23.0

