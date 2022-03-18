Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980C74DD7D4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiCRKTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234924AbiCRKTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:19:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796001FB518;
        Fri, 18 Mar 2022 03:18:22 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KKg0f6BlmzfYnH;
        Fri, 18 Mar 2022 18:16:50 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 18 Mar
 2022 18:18:19 +0800
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
Subject: [PATCH bpf-next] bpf, arm64: sign return address for jited code
Date:   Fri, 18 Mar 2022 06:29:36 -0400
Message-ID: <20220318102936.838459-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

1. Sign lr with paciasp instruction before lr is pushed to stack. Since
   paciasp acts like landing pads for function entry, no need to insert
   bti instruction before paciasp.

2. Authenticate lr with autiasp instruction after lr is poped from stack.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 arch/arm64/net/bpf_jit.h      |  3 +++
 arch/arm64/net/bpf_jit_comp.c | 11 +++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/net/bpf_jit.h b/arch/arm64/net/bpf_jit.h
index dd59b5ad8fe4..679c80aa1f2e 100644
--- a/arch/arm64/net/bpf_jit.h
+++ b/arch/arm64/net/bpf_jit.h
@@ -249,6 +249,9 @@
 /* HINTs */
 #define A64_HINT(x) aarch64_insn_gen_hint(x)
 
+#define A64_PACIASP A64_HINT(AARCH64_INSN_HINT_PACIASP)
+#define A64_AUTIASP A64_HINT(AARCH64_INSN_HINT_AUTIASP)
+
 /* BTI */
 #define A64_BTI_C  A64_HINT(AARCH64_INSN_HINT_BTIC)
 #define A64_BTI_J  A64_HINT(AARCH64_INSN_HINT_BTIJ)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index e850c69e128c..5dcf45e5944e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -192,7 +192,7 @@ static bool is_addsub_imm(u32 imm)
 }
 
 /* Tail call offset to jump into */
-#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
+#if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL) || IS_ENABLED(CONFIG_ARM64_PTR_AUTH_KERNEL)
 #define PROLOGUE_OFFSET 8
 #else
 #define PROLOGUE_OFFSET 7
@@ -233,8 +233,11 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
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
@@ -529,6 +532,10 @@ static void build_epilogue(struct jit_ctx *ctx)
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

