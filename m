Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E6C4839CA
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiADB1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:27:24 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:31065 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiADB1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:27:23 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JSZdS28Xsz1DKM0;
        Tue,  4 Jan 2022 09:23:56 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 4 Jan
 2022 09:27:20 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf] bpf, arm64: calculate offset as byte-offset for bpf line info
Date:   Tue, 4 Jan 2022 09:42:36 +0800
Message-ID: <20220104014236.1512639-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf line info for arm64 is broken due to two reasons:
(1) insn_to_jit_off passed to bpf_prog_fill_jited_linfo() is
    calculated in instruction granularity instead of bytes
    granularity.
(2) insn_to_jit_off only considers the body itself and ignores
    prologue before the body.

So fix it by calculating offset as byte-offset and do build_prologue()
first in the first JIT pass.

Fixes: 37ab566c178d ("bpf: arm64: Enable arm64 jit to provide bpf_line_info")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 arch/arm64/net/bpf_jit_comp.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 148ca51325bb..d7a6d4b523c9 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -24,6 +24,8 @@
 
 #include "bpf_jit.h"
 
+#define INSN_SZ (sizeof(u32))
+
 #define TMP_REG_1 (MAX_BPF_JIT_REG + 0)
 #define TMP_REG_2 (MAX_BPF_JIT_REG + 1)
 #define TCALL_CNT (MAX_BPF_JIT_REG + 2)
@@ -154,10 +156,11 @@ static inline int bpf2a64_offset(int bpf_insn, int off,
 	bpf_insn++;
 	/*
 	 * Whereas arm64 branch instructions encode the offset
-	 * from the branch itself, so we must subtract 1 from the
+	 * from the branch itself, so we must subtract 4 from the
 	 * instruction offset.
 	 */
-	return ctx->offset[bpf_insn + off] - (ctx->offset[bpf_insn] - 1);
+	return (ctx->offset[bpf_insn + off] -
+		(ctx->offset[bpf_insn] - INSN_SZ)) / INSN_SZ;
 }
 
 static void jit_fill_hole(void *area, unsigned int size)
@@ -955,13 +958,14 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 		const struct bpf_insn *insn = &prog->insnsi[i];
 		int ret;
 
+		/* BPF line info needs byte-offset instead of insn-offset */
 		if (ctx->image == NULL)
-			ctx->offset[i] = ctx->idx;
+			ctx->offset[i] = ctx->idx * INSN_SZ;
 		ret = build_insn(insn, ctx, extra_pass);
 		if (ret > 0) {
 			i++;
 			if (ctx->image == NULL)
-				ctx->offset[i] = ctx->idx;
+				ctx->offset[i] = ctx->idx * INSN_SZ;
 			continue;
 		}
 		if (ret)
@@ -973,7 +977,7 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 	 * instruction (end of program)
 	 */
 	if (ctx->image == NULL)
-		ctx->offset[i] = ctx->idx;
+		ctx->offset[i] = ctx->idx * INSN_SZ;
 
 	return 0;
 }
@@ -1058,15 +1062,18 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 		goto out_off;
 	}
 
-	/* 1. Initial fake pass to compute ctx->idx. */
-
-	/* Fake pass to fill in ctx->offset. */
-	if (build_body(&ctx, extra_pass)) {
+	/*
+	 * 1. Initial fake pass to compute ctx->idx and ctx->offset.
+	 *
+	 * BPF line info needs ctx->offset[i] to be the byte offset
+	 * of instruction[i] in jited image, so build prologue first.
+	 */
+	if (build_prologue(&ctx, was_classic)) {
 		prog = orig_prog;
 		goto out_off;
 	}
 
-	if (build_prologue(&ctx, was_classic)) {
+	if (build_body(&ctx, extra_pass)) {
 		prog = orig_prog;
 		goto out_off;
 	}
-- 
2.27.0

