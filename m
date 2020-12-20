Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEA82DF345
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 04:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgLTDhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 22:37:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbgLTDgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 22:36:40 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/10] selftests/bpf: Fix array access with signed variable test
Date:   Sat, 19 Dec 2020 22:34:55 -0500
Message-Id: <20201220033457.2728519-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201220033457.2728519-1-sashal@kernel.org>
References: <20201220033457.2728519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 77ce220c0549dcc3db8226c61c60e83fc59dfafc ]

The test fails because of a recent fix to the verifier, even though this
program is valid. In details what happens is:

    7: (61) r1 = *(u32 *)(r0 +0)

Load a 32-bit value, with signed bounds [S32_MIN, S32_MAX]. The bounds
of the 64-bit value are [0, U32_MAX]...

    8: (65) if r1 s> 0xffffffff goto pc+1

... therefore this is always true (the operand is sign-extended).

    10: (b4) w2 = 11
    11: (6d) if r2 s> r1 goto pc+1

When true, the 64-bit bounds become [0, 10]. The 32-bit bounds are still
[S32_MIN, 10].

    13: (64) w1 <<= 2

Because this is a 32-bit operation, the verifier propagates the new
32-bit bounds to the 64-bit ones, and the knowledge gained from insn 11
is lost.

    14: (0f) r0 += r1
    15: (7a) *(u64 *)(r0 +0) = 4

Then the verifier considers r0 unbounded here, rejecting the test. To
make the test work, change insn 8 to check the sign of the 32-bit value.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index f3c33e128709b..a80d806ead15f 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -68,7 +68,7 @@
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 9),
 	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
-	BPF_JMP_IMM(BPF_JSGT, BPF_REG_1, 0xffffffff, 1),
+	BPF_JMP32_IMM(BPF_JSGT, BPF_REG_1, 0xffffffff, 1),
 	BPF_MOV32_IMM(BPF_REG_1, 0),
 	BPF_MOV32_IMM(BPF_REG_2, MAX_ENTRIES),
 	BPF_JMP_REG(BPF_JSGT, BPF_REG_2, BPF_REG_1, 1),
-- 
2.27.0

