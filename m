Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B925378CA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiE3I6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiE3I6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:58:34 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E45762B0;
        Mon, 30 May 2022 01:58:33 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LBTpQ5jKTzDqZF;
        Mon, 30 May 2022 16:58:22 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 16:58:31 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next v3 2/6] riscv, bpf: Support riscv jit to provide bpf_line_info
Date:   Mon, 30 May 2022 17:28:11 +0800
Message-ID: <20220530092815.1112406-3-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220530092815.1112406-1-pulehui@huawei.com>
References: <20220530092815.1112406-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for riscv jit to provide bpf_line_info. We need to
consider the prologue offset in ctx->offset, but unlike x86 and
arm64, ctx->offset of riscv does not provide an extra slot for
the prologue, so here we just calculate the len of prologue and
add it to ctx->offset at the end. Both RV64 and RV32 have been
tested.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 arch/riscv/net/bpf_jit.h      | 1 +
 arch/riscv/net/bpf_jit_core.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit.h b/arch/riscv/net/bpf_jit.h
index 2a3715bf29fe..d926e0f7ef57 100644
--- a/arch/riscv/net/bpf_jit.h
+++ b/arch/riscv/net/bpf_jit.h
@@ -69,6 +69,7 @@ struct rv_jit_context {
 	struct bpf_prog *prog;
 	u16 *insns;		/* RV insns */
 	int ninsns;
+	int body_len;
 	int epilogue_offset;
 	int *offset;		/* BPF to RV */
 	int nexentries;
diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index be743d700aa7..737baf8715da 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -44,7 +44,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	unsigned int prog_size = 0, extable_size = 0;
 	bool tmp_blinded = false, extra_pass = false;
 	struct bpf_prog *tmp, *orig_prog = prog;
-	int pass = 0, prev_ninsns = 0, i;
+	int pass = 0, prev_ninsns = 0, prologue_len, i;
 	struct rv_jit_data *jit_data;
 	struct rv_jit_context *ctx;
 
@@ -95,6 +95,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			prog = orig_prog;
 			goto out_offset;
 		}
+		ctx->body_len = ctx->ninsns;
 		bpf_jit_build_prologue(ctx);
 		ctx->epilogue_offset = ctx->ninsns;
 		bpf_jit_build_epilogue(ctx);
@@ -161,6 +162,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 
 	if (!prog->is_func || extra_pass) {
 		bpf_jit_binary_lock_ro(jit_data->header);
+		prologue_len = ctx->epilogue_offset - ctx->body_len;
+		for (i = 0; i < prog->len; i++)
+			ctx->offset[i] = ninsns_rvoff(prologue_len +
+						      ctx->offset[i]);
+		bpf_prog_fill_jited_linfo(prog, ctx->offset);
 out_offset:
 		kfree(ctx->offset);
 		kfree(jit_data);
-- 
2.25.1

