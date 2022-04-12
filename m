Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE74FCA26
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiDLAuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243665AbiDLAuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:50:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEA02FFDB;
        Mon, 11 Apr 2022 17:46:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E1F2B819BF;
        Tue, 12 Apr 2022 00:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271FCC385AC;
        Tue, 12 Apr 2022 00:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724403;
        bh=oknzdsPyyYxHHeLKbM5fyYkIpdaUMdm8VabbP461qHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf6wU5Ksxc5pK7fq5DgOX2u6Q8iiIc9AxQCT2oBS6+rPZrw7RfEDpDUvFDjW2aCxs
         U1WNBIFtdTaTqi3B/hFb5WO/yJprltXCcIYn8S4QnVKNY84OfYWoc984Fph+dB/NmP
         4u5hS5siElnoKB3BqapMtWAGXFmaULganifVsk5LLl8tFXtRn5508/xYoyW8pW7qqQ
         wzaUJiXM+6dMq0t/saQEnBuQU26IsYcwPdNNzHFRPI1+FeQEIHbkf4KCDA7Tzwlr5/
         Nv3s3r5trx9CGnfd3Ynk8+F996FxkYDB4cJopiolKHKZOeEqR3gevhdEyLeaRVTf6A
         xo51tTS299/sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, daniel@iogearbox.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, andrii@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.17 45/49] x86,bpf: Avoid IBT objtool warning
Date:   Mon, 11 Apr 2022 20:44:03 -0400
Message-Id: <20220412004411.349427-45-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit be8a096521ca1a252bf078b347f96ce94582612e ]

Clang can inline emit_indirect_jump() and then folds constants, which
results in:

  | vmlinux.o: warning: objtool: emit_bpf_dispatcher()+0x6a4: relocation to !ENDBR: .text.__x86.indirect_thunk+0x40
  | vmlinux.o: warning: objtool: emit_bpf_dispatcher()+0x67d: relocation to !ENDBR: .text.__x86.indirect_thunk+0x40
  | vmlinux.o: warning: objtool: emit_bpf_tail_call_indirect()+0x386: relocation to !ENDBR: .text.__x86.indirect_thunk+0x20
  | vmlinux.o: warning: objtool: emit_bpf_tail_call_indirect()+0x35d: relocation to !ENDBR: .text.__x86.indirect_thunk+0x20

Suppress the optimization such that it must emit a code reference to
the __x86_indirect_thunk_array[] base.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lkml.kernel.org/r/20220405075531.GB30877@worktop.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 0ecb140864b2..b272e963388c 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -398,6 +398,7 @@ static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
+		OPTIMIZER_HIDE_VAR(reg);
 		emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
 	} else
 #endif
-- 
2.35.1

