Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58D11A60D
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 03:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbfEKBDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 21:03:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:44108 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfEKBDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 21:03:20 -0400
Received: from [178.199.41.31] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hPGQ1-0004Ot-6u; Sat, 11 May 2019 03:03:17 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     jakub.kicinski@netronome.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/2] bpf: add various test cases for backward jumps
Date:   Sat, 11 May 2019 03:03:10 +0200
Message-Id: <20190511010310.17323-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190511010310.17323-1-daniel@iogearbox.net>
References: <20190511010310.17323-1-daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25445/Fri May 10 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of tests to make sure branch offset adjustments are
correctly performed.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/verifier/jump.c | 151 ++++++++++++++++++++
 1 file changed, 151 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/jump.c b/tools/testing/selftests/bpf/verifier/jump.c
index 8e6fcc8940f0..f4ec8e12127c 100644
--- a/tools/testing/selftests/bpf/verifier/jump.c
+++ b/tools/testing/selftests/bpf/verifier/jump.c
@@ -178,3 +178,154 @@
 	.result_unpriv = REJECT,
 	.result = ACCEPT,
 },
+{
+	"jump test 6",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_MOV64_IMM(BPF_REG_1, 2),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 2),
+	BPF_EXIT_INSN(),
+	BPF_JMP_REG(BPF_JNE, BPF_REG_0, BPF_REG_1, 16),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, -20),
+	},
+	.result = ACCEPT,
+	.retval = 2,
+},
+{
+	"jump test 7",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 3),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 2, 16),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_JMP_IMM(BPF_JA, 0, 0, -20),
+	},
+	.result = ACCEPT,
+	.retval = 3,
+},
+{
+	"jump test 8",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_MOV64_IMM(BPF_REG_1, 2),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 3),
+	BPF_EXIT_INSN(),
+	BPF_JMP_REG(BPF_JNE, BPF_REG_0, BPF_REG_1, 16),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_JMP_IMM(BPF_JA, 0, 0, -20),
+	},
+	.result = ACCEPT,
+	.retval = 3,
+},
+{
+	"jump/call test 9",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 3),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 2, 16),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, -20),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "jump out of range from insn 1 to 4",
+},
+{
+	"jump/call test 10",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, 2),
+	BPF_MOV64_IMM(BPF_REG_0, 3),
+	BPF_EXIT_INSN(),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 2, 16),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_MOV64_IMM(BPF_REG_0, 42),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 1, 0, -20),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = REJECT,
+	.errstr = "last insn is not an exit or jmp",
+},
-- 
2.17.1

