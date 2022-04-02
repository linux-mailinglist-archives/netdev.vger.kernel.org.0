Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7214EFF4E
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 09:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiDBHbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 03:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDBHbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 03:31:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0BB173B2B;
        Sat,  2 Apr 2022 00:29:09 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KVpXG040nzgYKZ;
        Sat,  2 Apr 2022 15:27:25 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Sat, 2 Apr
 2022 15:29:06 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next v2] bpf, arm64: Sign return address for jited code
Date:   Sat, 2 Apr 2022 03:39:42 -0400
Message-ID: <20220402073942.3782529-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sign return address for jited code when the kernel is built with pointer
authentication enabled.

1. Sign LR with paciasp instruction before LR is pushed to stack. Since
   paciasp acts like landing pads for function entry, no need to insert
   bti instruction before paciasp.

2. Authenticate LR with autiasp instruction after LR is poped from stack.

For bpf tail call, the stack frame constructed by the caller is reused by
the callee. That is, the stack frame is constructed by the caller and
destructed by the callee. Thus LR is signed and pushed to the stack in the
caller's prologue, and poped from the stack and authenticated in the
callee's epilogue.

For bpf2bpf call, the caller and callee construct their own stack frames,
and sign and authenticate their own LRs.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---

v1->v2:
- Add bpf tail call and bpf2bpf call description to commit message
- Rebased to bpf-next

 arch/arm64/net/bpf_jit.h      |  3 +++
 arch/arm64/net/bpf_jit_comp.c | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index 3920213244f0..194c95ccc1cf 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -263,6 +263,9 @@
 /* HINTs */
 #define A64_HINT(x) aarch64_insn_gen_hint(x)
 
+#define A64_PACIASP A64_HINT(AARCH64_INSN_HINT_PACIASP)
+#define A64_AUTIASP A64_HINT(AARCH64_INSN_HINT_AUTIASP)
+
 /* BTI */
 #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 093fa9ea1083..8ab4035dea27 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -236,7 +236,8 @@ static bool is_lsi_offset(int offset, int scale)
 }
 
 /* Tail call offset to jump into */
-#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
+#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || \
+	IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
 #define PROLOGUE_OFFSET 9
 #else
 #define PROLOGUE_OFFSET 8
@@ -278,8 +279,11 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	 *
 	 */
 
+	/* Sign lr */
+	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
+		emit(A64_PACIASP, ctx);
 	/* BTI landing pad */
-	if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
+	else if (IS_ENABLED(CONFIG_ARM64_BTI_KERNEL))
 		emit(A64_BTI_C, ctx);
 
 	/* Save FP and LR registers to stay align with ARM64 AAPCS */
@@ -580,6 +584,10 @@ static void build_epilogue(struct jit_ctx *ctx)
 	/* Set return value */
 	emit(A64_MOV(1, A64_R(0), r0), ctx);
 
+	/* Authenticate lr */
+	if (IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL))
+		emit(A64_AUTIASP, ctx);
+
 	emit(A64_RET(A64_LR), ctx);
 }
 
-- 
2.30.2

