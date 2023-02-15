Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF4F697DD5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 14:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjBONuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 08:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBONty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 08:49:54 -0500
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D71A2A993;
        Wed, 15 Feb 2023 05:49:53 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4PGzwC1YH5z4f3jHm;
        Wed, 15 Feb 2023 21:49:47 +0800 (CST)
Received: from localhost.localdomain (unknown [10.67.175.61])
        by APP1 (Coremail) with SMTP id cCh0CgDnUSz64uxjC3LEDQ--.36740S4;
        Wed, 15 Feb 2023 21:49:49 +0800 (CST)
From:   Pu Lehui <pulehui@huaweicloud.com>
To:     bpf@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Pu Lehui <pulehui@huawei.com>,
        Pu Lehui <pulehui@huaweicloud.com>
Subject: [PATCH bpf-next v1 2/4] riscv, bpf: Factor out emit_call for kernel and bpf context
Date:   Wed, 15 Feb 2023 21:52:03 +0800
Message-Id: <20230215135205.1411105-3-pulehui@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230215135205.1411105-1-pulehui@huaweicloud.com>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDnUSz64uxjC3LEDQ--.36740S4
X-Coremail-Antispam: 1UD129KBjvJXoWxurWfuw13GrWUJFykWFyrXrb_yoW5Zr4xpF
        W5CFn3C3yvqF1SgFyDGFs5Zr1akr4v9r13tF93W395KFsFqrsrKF15Ka1Yqa4YyryrGr4r
        JFsFkFnxu3WUZrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
        6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2
        Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
        Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
        CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOJPEUUUU
        U
X-CM-SenderInfo: psxovxtxl6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

The current emit_call function is not suitable for kernel
function call as it store return value to bpf R0 register.
We can separate it out for common use. Meanwhile, simplify
judgment logic, that is, fixed function address can use jal
or auipc+jalr, while the unfixed can use only auipc+jalr.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 arch/riscv/net/bpf_jit_comp64.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index f2417ac54edd..69ebab81d935 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -428,12 +428,12 @@ static void emit_sext_32_rd(u8 *rd, struct rv_jit_context *ctx)
 	*rd = RV_REG_T2;
 }
 
-static int emit_jump_and_link(u8 rd, s64 rvoff, bool force_jalr,
+static int emit_jump_and_link(u8 rd, s64 rvoff, bool fixed_addr,
 			      struct rv_jit_context *ctx)
 {
 	s64 upper, lower;
 
-	if (rvoff && is_21b_int(rvoff) && !force_jalr) {
+	if (rvoff && fixed_addr && is_21b_int(rvoff)) {
 		emit(rv_jal(rd, rvoff >> 1), ctx);
 		return 0;
 	} else if (in_auipc_jalr_range(rvoff)) {
@@ -454,24 +454,17 @@ static bool is_signed_bpf_cond(u8 cond)
 		cond == BPF_JSGE || cond == BPF_JSLE;
 }
 
-static int emit_call(bool fixed, u64 addr, struct rv_jit_context *ctx)
+static int emit_call(u64 addr, bool fixed_addr, struct rv_jit_context *ctx)
 {
 	s64 off = 0;
 	u64 ip;
-	u8 rd;
-	int ret;
 
 	if (addr && ctx->insns) {
 		ip = (u64)(long)(ctx->insns + ctx->ninsns);
 		off = addr - ip;
 	}
 
-	ret = emit_jump_and_link(RV_REG_RA, off, !fixed, ctx);
-	if (ret)
-		return ret;
-	rd = bpf_to_rv_reg(BPF_REG_0, ctx);
-	emit_mv(rd, RV_REG_A0, ctx);
-	return 0;
+	return emit_jump_and_link(RV_REG_RA, off, fixed_addr, ctx);
 }
 
 static void emit_atomic(u8 rd, u8 rs, s16 off, s32 imm, bool is64,
@@ -913,7 +906,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
 		rvoff = rv_offset(i, off, ctx);
-		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
 		if (ret)
 			return ret;
 		break;
@@ -1032,17 +1025,20 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 	/* function call */
 	case BPF_JMP | BPF_CALL:
 	{
-		bool fixed;
+		bool fixed_addr;
 		u64 addr;
 
 		mark_call(ctx);
-		ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass, &addr,
-					    &fixed);
+		ret = bpf_jit_get_func_addr(ctx->prog, insn, extra_pass,
+					    &addr, &fixed_addr);
 		if (ret < 0)
 			return ret;
-		ret = emit_call(fixed, addr, ctx);
+
+		ret = emit_call(addr, fixed_addr, ctx);
 		if (ret)
 			return ret;
+
+		emit_mv(bpf_to_rv_reg(BPF_REG_0, ctx), RV_REG_A0, ctx);
 		break;
 	}
 	/* tail call */
@@ -1057,7 +1053,7 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 			break;
 
 		rvoff = epilogue_offset(ctx);
-		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, false, ctx);
+		ret = emit_jump_and_link(RV_REG_ZERO, rvoff, true, ctx);
 		if (ret)
 			return ret;
 		break;
-- 
2.25.1

