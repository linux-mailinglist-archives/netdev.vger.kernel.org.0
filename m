Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A866A564760
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 15:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiGCNJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 09:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiGCNJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 09:09:48 -0400
Received: from smtp.gentoo.org (smtp.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CDC6350;
        Sun,  3 Jul 2022 06:09:44 -0700 (PDT)
From:   Yixun Lan <dlan@gentoo.org>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        linux-riscv@lists.infradead.org
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yixun Lan <dlan@gentoo.org>
Subject: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Date:   Sun,  3 Jul 2022 21:09:24 +0800
Message-Id: <20220703130924.57240-1-dlan@gentoo.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable this option to fix a bcc error in RISC-V platform

And, the error shows as follows:

~ # runqlen
WARNING: This target JIT is not designed for the host you are running. \
If bad things happen, please choose a different -march switch.
bpf: Failed to load program: Invalid argument
0: R1=ctx(off=0,imm=0) R10=fp0
0: (85) call bpf_get_current_task#35          ; R0_w=scalar()
1: (b7) r6 = 0                        ; R6_w=0
2: (7b) *(u64 *)(r10 -8) = r6         ; R6_w=P0 R10=fp0 fp-8_w=00000000
3: (07) r0 += 312                     ; R0_w=scalar()
4: (bf) r1 = r10                      ; R1_w=fp0 R10=fp0
5: (07) r1 += -8                      ; R1_w=fp-8
6: (b7) r2 = 8                        ; R2_w=8
7: (bf) r3 = r0                       ; R0_w=scalar(id=1) R3_w=scalar(id=1)
8: (85) call bpf_probe_read#4
unknown func bpf_probe_read#4
processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

Traceback (most recent call last):
  File "/usr/lib/python-exec/python3.9/runqlen", line 187, in <module>
    b.attach_perf_event(ev_type=PerfType.SOFTWARE,
  File "/usr/lib/python3.9/site-packages/bcc/__init__.py", line 1228, in attach_perf_event
    fn = self.load_func(fn_name, BPF.PERF_EVENT)
  File "/usr/lib/python3.9/site-packages/bcc/__init__.py", line 522, in load_func
    raise Exception("Failed to load BPF program %s: %s" %
Exception: Failed to load BPF program b'do_perf_event': Invalid argument

Signed-off-by: Yixun Lan <dlan@gentoo.org>
---
 arch/riscv/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 32ffef9f6e5b4..da0016f1be6ce 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -25,6 +25,7 @@ config RISCV
 	select ARCH_HAS_GIGANTIC_PAGE
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_MMIOWB
+	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
 	select ARCH_HAS_SET_MEMORY if MMU
-- 
2.35.1

