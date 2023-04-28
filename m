Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8406F14A7
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345907AbjD1JzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbjD1JzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:55:07 -0400
Received: from out187-22.us.a.mail.aliyun.com (out187-22.us.a.mail.aliyun.com [47.90.187.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4D15FFA;
        Fri, 28 Apr 2023 02:54:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---.STDfs9K_1682675604;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.STDfs9K_1682675604)
          by smtp.aliyun-inc.com;
          Fri, 28 Apr 2023 17:53:25 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Thomas Garnier" <thgarnie@chromium.org>,
        "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        "Martin KaFai Lau" <martin.lau@linux.dev>,
        "Song Liu" <song@kernel.org>, "Yonghong Song" <yhs@fb.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "KP Singh" <kpsingh@kernel.org>,
        "Stanislav Fomichev" <sdf@google.com>,
        "Hao Luo" <haoluo@google.com>, "Jiri Olsa" <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "David Ahern" <dsahern@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH RFC 30/43] x86/bpf: Adapt BPF_CALL JIT codegen for PIE support
Date:   Fri, 28 Apr 2023 17:51:10 +0800
Message-Id: <b44b9ca8187f2ebeea8e03f0c215d4383112fdf5.1682673543.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
References: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If image is NULL, ip calculated is in bottom address and func is in
kernel image address, then the offset is valid when the kernel stays in
the top 2G address space. However, PIE kernel image could be below top
2G, which makes the offset out of range.  Since the length of
PC-relative call instruction is fixed, it's pointless to calculate the
offset without the proper image base (it has been zero until the last
pass). Use 1 as the dummy offset to generate the instruction in the
first pass.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Thomas Garnier <thgarnie@chromium.org>
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/x86/net/bpf_jit_comp.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 1056bbf55b17..0da41833e426 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1549,8 +1549,21 @@ st:			if (is_imm8(insn->off))
 					return -EINVAL;
 				offs = x86_call_depth_emit_accounting(&prog, func);
 			}
-			if (emit_call(&prog, func, image + addrs[i - 1] + offs))
-				return -EINVAL;
+			/*
+			 * If image is NULL, ip is in bottom address and func
+			 * is in kernel image address (top 2G), so the offset
+			 * is valid. However, PIE kernel image could be below
+			 * top 2G, then the offset would be out of range. Since
+			 * the length of PC-relative call(0xe8) is fixed, so it's
+			 * pointless to calculate the offset until the last pass.
+			 * Use 1 as the dummy offset if image is NULL.
+			 */
+			if (image)
+				err = emit_call(&prog, func, image + addrs[i - 1] + offs);
+			else
+				err = emit_call(&prog, (void *)(X86_PATCH_SIZE + 1UL), 0);
+			if (err)
+				return err;
 			break;
 		}
 
-- 
2.31.1

