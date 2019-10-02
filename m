Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16708C9523
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfJBXpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:45:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:50930 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJBXpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:45:21 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFoJ5-0001sC-5I; Thu, 03 Oct 2019 01:45:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 1/2] bpf, x86: Small optimization in comparing against imm0
Date:   Thu,  3 Oct 2019 01:45:11 +0200
Message-Id: <20191002234512.25902-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25590/Wed Oct  2 10:31:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'cmp reg, 0' with 'test reg, reg' for comparisons against
zero. Saves 1 byte of instruction encoding per occurrence. The flag
results of test 'reg, reg' are identical to 'cmp reg, 0' in all
cases except for AF which we don't use/care about. In terms of
macro-fusibility in combination with a subsequent conditional jump
instruction, both have the same properties for the jumps used in
the JIT translation. For example, same JITed Cilium program can
shrink a bit from e.g. 12,455 to 12,317 bytes as tests with 0 are
used quite frequently.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 arch/x86/net/bpf_jit_comp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 991549a1c5f3..3ad2ba1ad855 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -909,6 +909,16 @@ xadd:			if (is_imm8(insn->off))
 		case BPF_JMP32 | BPF_JSLT | BPF_K:
 		case BPF_JMP32 | BPF_JSGE | BPF_K:
 		case BPF_JMP32 | BPF_JSLE | BPF_K:
+			/* test dst_reg, dst_reg to save one extra byte */
+			if (imm32 == 0) {
+				if (BPF_CLASS(insn->code) == BPF_JMP)
+					EMIT1(add_2mod(0x48, dst_reg, dst_reg));
+				else if (is_ereg(dst_reg))
+					EMIT1(add_2mod(0x40, dst_reg, dst_reg));
+				EMIT2(0x85, add_2reg(0xC0, dst_reg, dst_reg));
+				goto emit_cond_jmp;
+			}
+
 			/* cmp dst_reg, imm8/32 */
 			if (BPF_CLASS(insn->code) == BPF_JMP)
 				EMIT1(add_1mod(0x48, dst_reg));
-- 
2.17.1

