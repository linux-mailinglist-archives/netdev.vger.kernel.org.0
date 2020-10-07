Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA6A286ADD
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 00:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgJGW1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 18:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbgJGW1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 18:27:37 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BF4C061755;
        Wed,  7 Oct 2020 15:27:37 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p11so1761790pld.5;
        Wed, 07 Oct 2020 15:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NnZ1n8E65Otvm1/bxPZ6xNlcltAne+x5NWUhCP57djM=;
        b=lO3bFrY7g6GqVV8Vj0lq7yLgsIYpiYLLcApW3qUo0BXyrp/drxWYTWtUwqCopsZbff
         JSp5M7Lmd8sNgTvq1pQc/zu2Pe03pLri7i3NL1eu4nP3L9/QACklaFMPU6EOkHhKhguZ
         QhkXIjanKGg2EgE48w4Lxxz35XoepwXW+0Kracbd6oxYEORch7+zK1wppC5xHHZOLkKO
         rNRJRpc743bbUM9TwBGGgDOjT4V5Czklknx62l3rH6wBbgXGNBNA21272bZQXIA49gz3
         uDK8k8OsquY1nElJkqRxlNK57WwWyKPhaFz4FfSwoSDyp50DVs4KQ6QQEgHWtUlCbnvE
         mnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NnZ1n8E65Otvm1/bxPZ6xNlcltAne+x5NWUhCP57djM=;
        b=oBz5o8d24QCSCpnNne0PurCFjPuT143Qo2haSKVnW1flhoqPmpWSjBJjrPvkU7CKgp
         t4XiArc6Egj+2+GflEuur7X31OEVD0RB37EvMIVxaAioI1kixbxJM2fundw7prfvTuKR
         zylqmHgS3Bp1nMEPcixsryHz4K6ZJ6hmxpVkKmVsKCnyGHgVKyKHExETmXZM1Oh+nSjf
         kRPvpYFhcw1FMmsxHIEpSJmLC+5Od4mX3GOOetPoloEeHD1iH8LKQNC+PT/WZ3WRf3vK
         f+RPm2hAJLikevmA9o+J/gReNgG84W+mv5DxaKlnJAkVys48XYRiiWK4QEHtJgSCTW+i
         MLxA==
X-Gm-Message-State: AOAM533jaMyUvbbDHohnCgef9EiPJneYbr7Knvh931p57FHEFfi9S55W
        Oyuz3Yg7AcgfvwCJDuSOeRsD4OAb47aXaQ==
X-Google-Smtp-Source: ABdhPJy7zpwvS9KzSa6rYQr5xI/dHZdWmtCIj3nLSqlVhlFZfIgEI1Q/ryTrnEwAlU0Mf9JcFPC8yg==
X-Received: by 2002:a17:902:9884:b029:d2:4276:1b64 with SMTP id s4-20020a1709029884b02900d242761b64mr4927538plp.76.1602109656875;
        Wed, 07 Oct 2020 15:27:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id d6sm296090pjr.51.2020.10.07.15.27.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 15:27:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] selftests/bpf: Additional asm tests for the verifier regalloc tracking.
Date:   Wed,  7 Oct 2020 15:27:34 -0700
Message-Id: <20201007222734.93364-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add asm tests for register allocator tracking logic implemented in the patches:
https://lore.kernel.org/bpf/20201006200955.12350-1-alexei.starovoitov@gmail.com/T/#t

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../testing/selftests/bpf/verifier/regalloc.c | 159 ++++++++++++++++++
 1 file changed, 159 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c

diff --git a/tools/testing/selftests/bpf/verifier/regalloc.c b/tools/testing/selftests/bpf/verifier/regalloc.c
new file mode 100644
index 000000000000..e9b6c6fdecd2
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/regalloc.c
@@ -0,0 +1,159 @@
+{
+	"regalloc 1",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 8),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 4),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc 2",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 8),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 24, 4),
+	BPF_JMP_IMM(BPF_JSLT, BPF_REG_2, 0, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=48 size=1",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc 3",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 5),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_3, BPF_REG_2, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc 4",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 22, 5),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_3, BPF_REG_2, 3),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_0),
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_2),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc 5",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 20, 7),
+	/* r0 has upper bound that should propagate into r2 */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8), /* spill r2 */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 0), /* clear r0 and r2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_10, -8), /* fill r3 */
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_0, BPF_REG_3, 2),
+	/* r3 has lower and upper bounds */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_3),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
+{
+	"regalloc 6",
+	.insns = {
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_1),
+	BPF_ST_MEM(BPF_DW, BPF_REG_10, -8, 0),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 11),
+	BPF_MOV64_REG(BPF_REG_7, BPF_REG_0),
+	BPF_EMIT_CALL(BPF_FUNC_get_prandom_u32),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 48, 7),
+	/* r0 has upper bound that should propagate into r2 */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8), /* spill r2 */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_MOV64_IMM(BPF_REG_2, 0), /* clear r0 and r2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_10, -8), /* fill r3 */
+	BPF_JMP_REG(BPF_JSGE, BPF_REG_0, BPF_REG_3, 2),
+	/* r3 has lower and upper bounds */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_7, BPF_REG_3),
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_48b = { 4 },
+	.result = REJECT,
+	.errstr = "invalid access to map value, value_size=48 off=48 size=8",
+	.prog_type = BPF_PROG_TYPE_TRACEPOINT,
+},
-- 
2.23.0

