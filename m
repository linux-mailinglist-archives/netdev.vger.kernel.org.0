Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B866442353
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhKAWYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhKAWYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:24:30 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB55C061714;
        Mon,  1 Nov 2021 15:21:56 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id j9so10268633pgh.1;
        Mon, 01 Nov 2021 15:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QVI+TFy2NeGxn0uvheZucafx89jvMp2zvxva7Rv6FQM=;
        b=ZlAyke869bxh9AvZNkL9BC1G87GHb3FGmdX5cQTnz7mfBaQIVIvRxnFowM43Wj2KaJ
         bjVb7onEo2+NhNTzRCx/cv6xItGTzZj3OwYeE/k5RANUvMv2Dp1PYX6cmQRP4DH8cisZ
         9/NXfnTKRopw2Cp/BuGJs51UJObmbQV+90/N4e13WPEZZuWIJXX+O0ZC445RgLrLIGnq
         uQy+6KwD16ByIWQ3FAo55QgOLWvZoaDlaY7v1icojG1yyIxn5KRvrIALO/f03NL2GegY
         HLUjhJzH6hiYWSs5Wf1AiN50CztQ0y7Reb1vJmJmO3s8+MPsbikeHGuVXavzhJzkaEBr
         +duA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QVI+TFy2NeGxn0uvheZucafx89jvMp2zvxva7Rv6FQM=;
        b=iVHsJASU6MzBKaWgfWet03VDDkeN9dzcnzoOG++oGyBwyPd8tDVotLrK/vpw4AaS15
         9pu/bh8izGa2TtFIj6ikeWD1SolsC8E9zEY7q7VzemXNqzBfWk9NPyIsMsWGJuWwj7KP
         2bP0W8xgqWLx3UavTHnjD1Ud/wJGNfqtQhoLAy1HlrdE3ZaVfbXj5K6F+gQDqMgYS1Sc
         +dmnCATdlP1JT5FSDj5dOFSA6N2G9Q4zBPY+Z0FaRupm3r6v5fCb0wxfMzci2aA0vgnw
         xAkyjDEk3dvJLm0KG5fgv/DFkxAWvkDdOCqKn1JuNoA0tKVABhOo3QE3DFrXOYhung1g
         hxCQ==
X-Gm-Message-State: AOAM530Zt6WgcQpIm9DFROO2rPK5BhCh5bzUbnbmL9/jxnsDfxCh6LQG
        bZHufwxB6cjfSME7lcW9/Y5ICyeNJDw=
X-Google-Smtp-Source: ABdhPJxVTGnU8z6qx00kMsQX5AdlxQl5wXA0UxCPXZCifTYkU2NqyoOHR0++whNl9T1f3g4068isWQ==
X-Received: by 2002:a63:e243:: with SMTP id y3mr24171972pgj.101.1635805316246;
        Mon, 01 Nov 2021 15:21:56 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:880e])
        by smtp.gmail.com with ESMTPSA id k2sm1761695pfu.112.2021.11.01.15.21.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Nov 2021 15:21:55 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 1/3] bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
Date:   Mon,  1 Nov 2021 15:21:51 -0700
Message-Id: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Before this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))

After this fix:
166: (b5) if r2 <= 0x1 goto pc+22
from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))

While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
and call __reg_combine_64_into_32(true_reg).

Without the fix it would not pass the condition:
if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))

since umin_value == 0 at this point.
Before commit 10bf4e83167c the umin was incorrectly ingored.
The commit 10bf4e83167c fixed the correctness issue, but pessimized
propagation of 64-bit min max into 32-bit min max and corresponding var_off.

Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c                               | 2 +-
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c8aa7df1773..29671ed49ee8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1425,7 +1425,7 @@ static bool __reg64_bound_s32(s64 a)
 
 static bool __reg64_bound_u32(u64 a)
 {
-	return a > U32_MIN && a < U32_MAX;
+	return a >= U32_MIN && a <= U32_MAX;
 }
 
 static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index 1b1c798e9248..1b138cd2b187 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -186,7 +186,7 @@
 	},
 	.fixup_map_hash_48b = { 3 },
 	.errstr_unpriv = "R0 leaks addr",
-	.errstr = "R0 unbounded memory access",
+	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
 	.result_unpriv = REJECT,
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
-- 
2.30.2

