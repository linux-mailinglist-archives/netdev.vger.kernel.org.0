Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D752D133141
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgAGU7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:59456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbgAGU7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C5E21744;
        Tue,  7 Jan 2020 20:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430741;
        bh=vCIHg4nrV33PHnHUdiahTM63gn1eC2OQrBoSflm+lEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XE0fMj9GPucGYOqbV42hvUywagg9WEeVCGw3q9SvVGjmHcS6eKIEsaYkguR5CHIdP
         739AgbqOGWQerSgddUKux/PtCo+0IriRZahGhZG4epgCYZtjYY/YcF+ve3x8BRM7Iw
         JXihfkezJ8cS/MpFCK3aYcMh4VED+kZAEHoLV7oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        Tony Ambardar <itugrok@yahoo.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org
Subject: [PATCH 5.4 076/191] MIPS: BPF: Disable MIPS32 eBPF JIT
Date:   Tue,  7 Jan 2020 21:53:16 +0100
Message-Id: <20200107205337.048444554@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Burton <paulburton@kernel.org>

commit f8fffebdea752a25757b906f3dffecf1a59a6194 upstream.

Commit 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32
architecture.") enabled our eBPF JIT for MIPS32 kernels, whereas it has
previously only been availailable for MIPS64. It was my understanding at
the time that the BPF test suite was passing & JITing a comparable
number of tests to our cBPF JIT [1], but it turns out that was not the
case.

The eBPF JIT has a number of problems on MIPS32:

- Most notably various code paths still result in emission of MIPS64
  instructions which will cause reserved instruction exceptions & kernel
  panics when run on MIPS32 CPUs.

- The eBPF JIT doesn't account for differences between the O32 ABI used
  by MIPS32 kernels versus the N64 ABI used by MIPS64 kernels. Notably
  arguments beyond the first 4 are passed on the stack in O32, and this
  is entirely unhandled when JITing a BPF_CALL instruction. Stack space
  must be reserved for arguments even if they all fit in registers, and
  the callee is free to assume that stack space has been reserved for
  its use - with the eBPF JIT this is not the case, so calling any
  function can result in clobbering values on the stack & unpredictable
  behaviour. Function arguments in eBPF are always 64-bit values which
  is also entirely unhandled - the JIT still uses a single (32-bit)
  register per argument. As a result all function arguments are always
  passed incorrectly when JITing a BPF_CALL instruction, leading to
  kernel crashes or strange behavior.

- The JIT attempts to bail our on use of ALU64 instructions or 64-bit
  memory access instructions. The code doing this at the start of
  build_one_insn() incorrectly checks whether BPF_OP() equals BPF_DW,
  when it should really be checking BPF_SIZE() & only doing so when
  BPF_CLASS() is one of BPF_{LD,LDX,ST,STX}. This results in false
  positives that cause more bailouts than intended, and that in turns
  hides some of the problems described above.

- The kernel's cBPF->eBPF translation makes heavy use of 64-bit eBPF
  instructions that the MIPS32 eBPF JIT bails out on, leading to most
  cBPF programs not being JITed at all.

Until these problems are resolved, revert the enabling of the eBPF JIT
on MIPS32 done by commit 716850ab104d ("MIPS: eBPF: Initial eBPF support
for MIPS32 architecture.").

Note that this does not undo the changes made to the eBPF JIT by that
commit, since they are a useful starting point to providing MIPS32
support - they're just not nearly complete.

[1] https://lore.kernel.org/linux-mips/MWHPR2201MB13583388481F01A422CE7D66D4410@MWHPR2201MB1358.namprd22.prod.outlook.com/

Signed-off-by: Paul Burton <paulburton@kernel.org>
Fixes: 716850ab104d ("MIPS: eBPF: Initial eBPF support for MIPS32 architecture.")
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Hassan Naveed <hnaveed@wavecomp.com>
Cc: Tony Ambardar <itugrok@yahoo.com>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: <stable@vger.kernel.org> # v5.2+
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -46,7 +46,7 @@ config MIPS
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES
 	select HAVE_ASM_MODVERSIONS
-	select HAVE_EBPF_JIT if (!CPU_MICROMIPS)
+	select HAVE_EBPF_JIT if (64BIT && !CPU_MICROMIPS)
 	select HAVE_CONTEXT_TRACKING
 	select HAVE_COPY_THREAD_TLS
 	select HAVE_C_RECORDMCOUNT


