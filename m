Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13434F998
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhCaHNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:13:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15410 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbhCaHNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:13:14 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F9HYG0R9FzlWlB;
        Wed, 31 Mar 2021 15:11:30 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 15:13:02 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <kpsingh@kernel.org>, <john.fastabend@gmail.com>, <yhs@fb.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <andrii@kernel.org>,
        <daniel@iogearbox.net>, <ast@kernel.org>
Subject: [Patch bpf-next] bpf: remove unused parameter from ___bpf_prog_run
Date:   Wed, 31 Mar 2021 07:51:35 +0000
Message-ID: <20210331075135.3850782-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'stack' parameter is not used in ___bpf_prog_run,
the base address have been set to FP reg. So consequently remove it.

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 kernel/bpf/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index f5423251c118..5e31ee9f7512 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1363,11 +1363,10 @@ u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
  *	__bpf_prog_run - run eBPF program on a given context
  *	@regs: is the array of MAX_BPF_EXT_REG eBPF pseudo-registers
  *	@insn: is the array of eBPF instructions
- *	@stack: is the eBPF storage stack
  *
  * Decode and execute eBPF instructions.
  */
-static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
+static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
@@ -1701,7 +1700,7 @@ static unsigned int PROG_NAME(stack_size)(const void *ctx, const struct bpf_insn
 \
 	FP = (u64) (unsigned long) &stack[ARRAY_SIZE(stack)]; \
 	ARG1 = (u64) (unsigned long) ctx; \
-	return ___bpf_prog_run(regs, insn, stack); \
+	return ___bpf_prog_run(regs, insn); \
 }
 
 #define PROG_NAME_ARGS(stack_size) __bpf_prog_run_args##stack_size
@@ -1718,7 +1717,7 @@ static u64 PROG_NAME_ARGS(stack_size)(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5, \
 	BPF_R3 = r3; \
 	BPF_R4 = r4; \
 	BPF_R5 = r5; \
-	return ___bpf_prog_run(regs, insn, stack); \
+	return ___bpf_prog_run(regs, insn); \
 }
 
 #define EVAL1(FN, X) FN(X)
-- 
2.25.1

