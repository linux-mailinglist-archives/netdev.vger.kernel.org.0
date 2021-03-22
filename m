Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21100344BB4
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhCVQiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:38:03 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:11802 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhCVQhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:37:48 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F40Xh2qlVz9txkM;
        Mon, 22 Mar 2021 17:37:40 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 0xxz-9rq0dT4; Mon, 22 Mar 2021 17:37:40 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F40Xh1qmSz9txkL;
        Mon, 22 Mar 2021 17:37:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E57D08B7A3;
        Mon, 22 Mar 2021 17:37:45 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id hGhPYlNpQroi; Mon, 22 Mar 2021 17:37:45 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9F83C8B79C;
        Mon, 22 Mar 2021 17:37:45 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 730F3675F4; Mon, 22 Mar 2021 16:37:45 +0000 (UTC)
Message-Id: <cover.1616430991.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH v2 0/8] Implement EBPF on powerpc32
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 22 Mar 2021 16:37:45 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements extended BPF on powerpc32. For the implementation
details, see the patch before the last.

The following operations are not implemented:

		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */

The following operations are only implemented for power of two constants:

		case BPF_ALU64 | BPF_MOD | BPF_K: /* dst %= imm */
		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst /= imm */

Below are the results on a powerpc 885:
- with the patch, with and without bpf_jit_enable
- without the patch, with bpf_jit_enable (ie with CBPF)

With the patch, with bpf_jit_enable = 1 :

[   60.826529] test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]
[   60.832505] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

With the patch, with bpf_jit_enable = 0 :

[   75.186337] test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]
[   75.192325] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

Without the patch, with bpf_jit_enable = 1 :

[  186.112429] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'ed]

Couldn't run test_progs because it doesn't build (clang 11 crashes during the build).

Changes in v2:
- Simplify 16 bits swap
- Rework tailcall, use stack for tailcall counter
- Fix handling of BPF_REG_FP:
  - must be handler like any other register allthough only the lower 32 bits part is used as a pointer.
  - r18 was TMP_REG, r17/r18 become de BPF_REG_FP
  - r31 was BPF_REG_FP, it is now TMP_REG
- removed bpf_jit32.h
- Reorder register allocation dynamically to use the volatile registers as much as possible when not doing function calls (last patch - new)

Christophe Leroy (8):
  powerpc/bpf: Remove classical BPF support for PPC32
  powerpc/bpf: Change register numbering for bpf_set/is_seen_register()
  powerpc/bpf: Move common helpers into bpf_jit.h
  powerpc/bpf: Move common functions into bpf_jit_comp.c
  powerpc/bpf: Change values of SEEN_ flags
  powerpc/asm: Add some opcodes in asm/ppc-opcode.h for PPC32 eBPF
  powerpc/bpf: Implement extended BPF on PPC32
  powerpc/bpf: Reallocate BPF registers to volatile registers when
    possible on PPC32

 Documentation/admin-guide/sysctl/net.rst |    2 +-
 arch/powerpc/Kconfig                     |    3 +-
 arch/powerpc/include/asm/ppc-opcode.h    |   12 +
 arch/powerpc/net/Makefile                |    6 +-
 arch/powerpc/net/bpf_jit.h               |   61 ++
 arch/powerpc/net/bpf_jit32.h             |  139 ---
 arch/powerpc/net/bpf_jit64.h             |   21 +-
 arch/powerpc/net/bpf_jit_asm.S           |  226 -----
 arch/powerpc/net/bpf_jit_comp.c          |  782 ++++-----------
 arch/powerpc/net/bpf_jit_comp32.c        | 1095 ++++++++++++++++++++++
 arch/powerpc/net/bpf_jit_comp64.c        |  295 +-----
 11 files changed, 1372 insertions(+), 1270 deletions(-)
 delete mode 100644 arch/powerpc/net/bpf_jit32.h
 delete mode 100644 arch/powerpc/net/bpf_jit_asm.S
 create mode 100644 arch/powerpc/net/bpf_jit_comp32.c

-- 
2.25.0

