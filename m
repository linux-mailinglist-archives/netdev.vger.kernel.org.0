Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F284B54F609
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381986AbiFQK5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381972AbiFQK5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:57:43 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E370C140DB
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:57:40 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gl15so8063758ejb.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qG3ha7d/c1/glBiA0lW9gWurpAn6x6mc34n7Bzs5t10=;
        b=FvNZja5hsprnUW58Ytnv5T2LWfeyXrh/nTEwfDjdpXpriAGe/uQ23xf9ctojNpuuJt
         E9kmNHT9fAKpUIt6uR/mSIHh2ZgHAZXIKiNsnZRFOAcwQg180Xwf/W5ml00Pkbizlv4w
         lgPOLEtQeKdYBCwPezmN7YdzxNgX0pb81ehsU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qG3ha7d/c1/glBiA0lW9gWurpAn6x6mc34n7Bzs5t10=;
        b=YhfqEDYhVhO74E+GzecX5+cPeaTOY5kzLuHg6YXRRbOJN6iLzsOcJziSvW2XtkavNT
         OS88OczQFDAckS3VDKaSivpkkwVTS/yL8KPXJisUMohD5M9QOLSir5UOHiJXPkM0Fu5W
         IoW4JgNN62KYTUG3jjOxS8+NUgDQw3QbVgNhjFWMN4iCuCq6GLaogFNlTYcWcDJtrMnm
         GtARV9Ll242TewyAt6CoK8n1QZc/lFbW3JCYkvKVSa8PqrPYyWRzTIw0hmtevptFMU6X
         XNmoJG+2mkMWzORdMTwgtQ3wfEzAeQg0We3uqInLBXtMiNqVsEa1Or6byKlkw0wb5br1
         EAGg==
X-Gm-Message-State: AJIora9hrzGSvy5BxGMl0B+64jgzxzGJecuq7hS1DFiD1Nom2lMq6lPp
        5ftwTJ9QxO890WvTkXP4/CF2UA==
X-Google-Smtp-Source: AGRyM1vbOhqI7d4EHnkkGQSAMK2WGPk7YDI6TTOTOOtB/i9v8gNJNKamyrbczlIrzWdRAbc7mcIl1g==
X-Received: by 2002:a17:907:8b06:b0:711:e7f6:1728 with SMTP id sz6-20020a1709078b0600b00711e7f61728mr8560902ejc.32.1655463459377;
        Fri, 17 Jun 2022 03:57:39 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id u9-20020aa7d0c9000000b00433b5f22864sm3467677edo.20.2022.06.17.03.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:57:39 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, Tony Ambardar <tony.ambardar@gmail.com>
Subject: [PATCH bpf-next 2/2] bpf: arm64: Keep tail call count across bpf2bpf calls
Date:   Fri, 17 Jun 2022 12:57:35 +0200
Message-Id: <20220617105735.733938-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220617105735.733938-1-jakub@cloudflare.com>
References: <20220617105735.733938-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today doing a BPF tail call after a BPF to BPF call, that is from a
subprogram, is allowed only by the x86-64 BPF JIT. Mixing these features
requires support from JIT. Tail call count has to be tracked through BPF to
BPF calls, as well as through BPF tail calls to prevent unbounded chains of
tail calls.

arm64 BPF JIT stores the tail call count (TCC) in a dedicated
register (X26). This makes it easier to support bpf2bpf calls mixed with
tail calls than on x86 platform.

In order to keep the tail call count in tact throughout bpf2bpf calls, all
we need to do is tweak the program prologue generator. When emitting
prologue for a subprogram, we skip the block that initializes the tail call
count and emits a jump pad for the tail call.

With this change, a sample execution flow where a bpf2bpf call is followed
by a tail call would look like so:

int entry(struct __sk_buff *skb):
   0xffffffc0090151d4:  paciasp
   0xffffffc0090151d8:  stp     x29, x30, [sp, #-16]!
   0xffffffc0090151dc:  mov     x29, sp
   0xffffffc0090151e0:  stp     x19, x20, [sp, #-16]!
   0xffffffc0090151e4:  stp     x21, x22, [sp, #-16]!
   0xffffffc0090151e8:  stp     x25, x26, [sp, #-16]!
   0xffffffc0090151ec:  stp     x27, x28, [sp, #-16]!
   0xffffffc0090151f0:  mov     x25, sp
   0xffffffc0090151f4:  mov     x26, #0x0                       // <- init TCC only
   0xffffffc0090151f8:  bti     j                               //    in main prog
   0xffffffc0090151fc:  sub     x27, x25, #0x0
   0xffffffc009015200:  sub     sp, sp, #0x10
   0xffffffc009015204:  mov     w1, #0x0
   0xffffffc009015208:  mov     x10, #0xffffffffffffffff
   0xffffffc00901520c:  strb    w1, [x25, x10]
   0xffffffc009015210:  mov     x10, #0xffffffffffffd25c
   0xffffffc009015214:  movk    x10, #0x902, lsl #16
   0xffffffc009015218:  movk    x10, #0xffc0, lsl #32
   0xffffffc00901521c:  blr     x10 -------------------.        // bpf2bpf call
   0xffffffc009015220:  add     x7, x0, #0x0 <-------------.
   0xffffffc009015224:  add     sp, sp, #0x10          |   |
   0xffffffc009015228:  ldp     x27, x28, [sp], #16    |   |
   0xffffffc00901522c:  ldp     x25, x26, [sp], #16    |   |
   0xffffffc009015230:  ldp     x21, x22, [sp], #16    |   |
   0xffffffc009015234:  ldp     x19, x20, [sp], #16    |   |
   0xffffffc009015238:  ldp     x29, x30, [sp], #16    |   |
   0xffffffc00901523c:  add     x0, x7, #0x0           |   |
   0xffffffc009015240:  autiasp                        |   |
   0xffffffc009015244:  ret                            |   |
                                                       |   |
int subprog_tail(struct __sk_buff *skb):               |   |
   0xffffffc00902d25c:  paciasp <----------------------'   |
   0xffffffc00902d260:  stp     x29, x30, [sp, #-16]!      |
   0xffffffc00902d264:  mov     x29, sp                    |
   0xffffffc00902d268:  stp     x19, x20, [sp, #-16]!      |
   0xffffffc00902d26c:  stp     x21, x22, [sp, #-16]!      |
   0xffffffc00902d270:  stp     x25, x26, [sp, #-16]!      |
   0xffffffc00902d274:  stp     x27, x28, [sp, #-16]!      |
   0xffffffc00902d278:  mov     x25, sp                    |
   0xffffffc00902d27c:  sub     x27, x25, #0x0             |
   0xffffffc00902d280:  sub     sp, sp, #0x10              |    // <- end of prologue, notice:
   0xffffffc00902d284:  add     x19, x0, #0x0              |    //    1) TCC not touched, and
   0xffffffc00902d288:  mov     w0, #0x1                   |    //    2) no tail call jump pad
   0xffffffc00902d28c:  mov     x10, #0xfffffffffffffffc   |
   0xffffffc00902d290:  str     w0, [x25, x10]             |
   0xffffffc00902d294:  mov     x20, #0xffffff80ffffffff   |
   0xffffffc00902d298:  movk    x20, #0xc033, lsl #16      |
   0xffffffc00902d29c:  movk    x20, #0x4e00               |
   0xffffffc00902d2a0:  add     x0, x19, #0x0              |
   0xffffffc00902d2a4:  add     x1, x20, #0x0              |
   0xffffffc00902d2a8:  mov     x2, #0x0                   |
   0xffffffc00902d2ac:  mov     w10, #0x24                 |
   0xffffffc00902d2b0:  ldr     w10, [x1, x10]             |
   0xffffffc00902d2b4:  add     w2, w2, #0x0               |
   0xffffffc00902d2b8:  cmp     w2, w10                    |
   0xffffffc00902d2bc:  b.cs    0xffffffc00902d2f8         |
   0xffffffc00902d2c0:  mov     w10, #0x21                 |
   0xffffffc00902d2c4:  cmp     x26, x10                   |    // TCC >= MAX_TAIL_CALL_CNT?
   0xffffffc00902d2c8:  b.cs    0xffffffc00902d2f8         |
   0xffffffc00902d2cc:  add     x26, x26, #0x1             |    // TCC++
   0xffffffc00902d2d0:  mov     w10, #0x110                |
   0xffffffc00902d2d4:  add     x10, x1, x10               |
   0xffffffc00902d2d8:  lsl     x11, x2, #3                |
   0xffffffc00902d2dc:  ldr     x11, [x10, x11]            |
   0xffffffc00902d2e0:  cbz     x11, 0xffffffc00902d2f8    |
   0xffffffc00902d2e4:  mov     w10, #0x30                 |
   0xffffffc00902d2e8:  ldr     x10, [x11, x10]            |
   0xffffffc00902d2ec:  add     x10, x10, #0x24            |
   0xffffffc00902d2f0:  add     sp, sp, #0x10              |    // <- destroy just current
   0xffffffc00902d2f4:  br      x10 ---------------------. |    //    BPF stack frame
   0xffffffc00902d2f8:  mov     x10, #0xfffffffffffffffc | |    //    before the tail call
   0xffffffc00902d2fc:  ldr     w7, [x25, x10]           | |
   0xffffffc00902d300:  add     sp, sp, #0x10            | |
   0xffffffc00902d304:  ldp     x27, x28, [sp], #16      | |
   0xffffffc00902d308:  ldp     x25, x26, [sp], #16      | |
   0xffffffc00902d30c:  ldp     x21, x22, [sp], #16      | |
   0xffffffc00902d310:  ldp     x19, x20, [sp], #16      | |
   0xffffffc00902d314:  ldp     x29, x30, [sp], #16      | |
   0xffffffc00902d318:  add     x0, x7, #0x0             | |
   0xffffffc00902d31c:  autiasp                          | |
   0xffffffc00902d320:  ret                              | |
                                                         | |
int classifier_0(struct __sk_buff *skb):                 | |
   0xffffffc008ff5874:  paciasp                          | |
   0xffffffc008ff5878:  stp     x29, x30, [sp, #-16]!    | |
   0xffffffc008ff587c:  mov     x29, sp                  | |
   0xffffffc008ff5880:  stp     x19, x20, [sp, #-16]!    | |
   0xffffffc008ff5884:  stp     x21, x22, [sp, #-16]!    | |
   0xffffffc008ff5888:  stp     x25, x26, [sp, #-16]!    | |
   0xffffffc008ff588c:  stp     x27, x28, [sp, #-16]!    | |
   0xffffffc008ff5890:  mov     x25, sp                  | |
   0xffffffc008ff5894:  mov     x26, #0x0                | |
   0xffffffc008ff5898:  bti     j <----------------------' |
   0xffffffc008ff589c:  sub     x27, x25, #0x0             |
   0xffffffc008ff58a0:  sub     sp, sp, #0x0               |
   0xffffffc008ff58a4:  mov     x0, #0xffffffc0ffffffff    |
   0xffffffc008ff58a8:  movk    x0, #0x8fc, lsl #16        |
   0xffffffc008ff58ac:  movk    x0, #0x6000                |
   0xffffffc008ff58b0:  mov     w1, #0x1                   |
   0xffffffc008ff58b4:  str     w1, [x0]                   |
   0xffffffc008ff58b8:  mov     w7, #0x0                   |
   0xffffffc008ff58bc:  mov     sp, sp                     |
   0xffffffc008ff58c0:  ldp     x27, x28, [sp], #16        |
   0xffffffc008ff58c4:  ldp     x25, x26, [sp], #16        |
   0xffffffc008ff58c8:  ldp     x21, x22, [sp], #16        |
   0xffffffc008ff58cc:  ldp     x19, x20, [sp], #16        |
   0xffffffc008ff58d0:  ldp     x29, x30, [sp], #16        |
   0xffffffc008ff58d4:  add     x0, x7, #0x0               |
   0xffffffc008ff58d8:  autiasp                            |
   0xffffffc008ff58dc:  ret -------------------------------'

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 arch/arm64/net/bpf_jit_comp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 8ab4035dea27..71c3f4f7224e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -246,6 +246,7 @@ static bool is_lsi_offset(int offset, int scale)
 static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 {
 	const struct bpf_prog *prog = ctx->prog;
+	const bool is_main_prog = prog->aux->func_idx == 0;
 	const u8 r6 = bpf2a64[BPF_REG_6];
 	const u8 r7 = bpf2a64[BPF_REG_7];
 	const u8 r8 = bpf2a64[BPF_REG_8];
@@ -299,7 +300,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 	/* Set up BPF prog stack base register */
 	emit(A64_MOV(1, fp, A64_SP), ctx);
 
-	if (!ebpf_from_cbpf) {
+	if (!ebpf_from_cbpf && is_main_prog) {
 		/* Initialize tail_call_cnt */
 		emit(A64_MOVZ(1, tcc, 0, 0), ctx);
 
@@ -1529,3 +1530,9 @@ void bpf_jit_free_exec(void *addr)
 {
 	return vfree(addr);
 }
+
+/* Indicate the JIT backend supports mixing bpf2bpf and tailcalls. */
+bool bpf_jit_supports_subprog_tailcalls(void)
+{
+	return true;
+}
-- 
2.35.3

