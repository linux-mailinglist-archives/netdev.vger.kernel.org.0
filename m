Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ABA2AE6E4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgKKDMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgKKDMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:12:22 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13694C0613D1;
        Tue, 10 Nov 2020 19:12:21 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so495723pgg.13;
        Tue, 10 Nov 2020 19:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WMbEEZw5ZrznXDzs8M994I77wJLdQcvBKo3AYZnqjhY=;
        b=JbNN4pefd9zfwHmTfJB9cEjMOO6H7dz7YH6JxMTcqYyU+eR47CDcsK96nftP+8K7L4
         0np6pByaSotj4eRgulAXhPsmwksA/6RVD+iVNIOd4lv5+F96jZTHgrI2kguqqU8ghILz
         fMj9qfxsc/UcKGPBTK6Au7kYu7ypBQsgM0dYNhdAIcoe1GZTfV/0uamH7elk4SAKVie6
         vXpduKdQ/8C6x4AardcGvfreftcjdruuk5fxXKaF4BPmgzzxEynhvDniBYsJ+fFG08NZ
         saZGoZQTFYdn9K4YWL0fOrQWmy+uIQDJdjWq+q81PLUkQO5xKVpuOD0zMSfC/7ozu7Nz
         sydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WMbEEZw5ZrznXDzs8M994I77wJLdQcvBKo3AYZnqjhY=;
        b=KezILWmlu1N4x8Kr5QLgy5KFT6CDN7Txld4/oqsEVQyq0JucWO0zO3WCZIIPrjY3Zu
         oHAzMjZJ57PWMBvyTcVYp5lCUm8CNya7L+hiHnw9Qwf+V1ovoemaXi1sjOyy3G2kBWyw
         VDNLhwTqrAIizZUSVeDBKe6Pg7UNRt3PnMu1S3vJBaTjRRoJIpw9vTZtAqiB11VQ3A/M
         KOkUdKWze7obLt1+aLntjhJLW8QqbD2Vhig2uF86O1DZlnv4z406CYYN/33hFt1Yj/ZE
         4Ls67obx8VtkocRCnS2E5tcJKVy9vZqwWkE04+7yRXLsbLQsnYt8Lc0IoDmcGFh5K2ej
         KRvQ==
X-Gm-Message-State: AOAM533tOP9LjV+lyQE5rIpR4WhnsnYplhTSgHxaIrQs+mgA3rpnzQnb
        UpVHlirlrZpJ7n63nK36zZs=
X-Google-Smtp-Source: ABdhPJwQhLi1+uUcTCWGtHwQzUO5MT9yNCts3Gl2DQ/rqcOOOnhZAmQwIzmHPC+SSqq+PLzdkwHoSg==
X-Received: by 2002:a05:6a00:14cd:b029:18b:fac7:d88 with SMTP id w13-20020a056a0014cdb029018bfac70d88mr3663521pfu.6.1605064340654;
        Tue, 10 Nov 2020 19:12:20 -0800 (PST)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o132sm506815pfg.100.2020.11.10.19.12.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 19:12:19 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: Add asm tests for pkt vs pkt_end comparison.
Date:   Tue, 10 Nov 2020 19:12:13 -0800
Message-Id: <20201111031213.25109-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
References: <20201111031213.25109-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add few assembly tests for packet comparison.

Tested-by: Jiri Olsa <jolsa@redhat.com>
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
2.24.1

