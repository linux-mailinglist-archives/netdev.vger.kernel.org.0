Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D094F7DD
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 14:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbfD3MDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 08:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbfD3Lng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E18921670;
        Tue, 30 Apr 2019 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624614;
        bh=gXLdoaAcPWLTUVmzvOUrQ4bL46PcIJ0n9kh5CiHo3PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aH5UEdkNGRn/RJtVoJQ5nwiL/+dhdloi1FnhlwDP2GaaHLjPIwlkC7oCVKz8zmNhf
         SZyx4aLI58M2Yfqt5H9D3bH1j3E4rEUAmdDLb2GyVopDYFo472K/iJ979Y4YGNRht4
         Bk8IckUKamW4N4eCU9DEdEiWNMILQu6Cshud9+cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 4.14 40/53] x86, retpolines: Raise limit for generating indirect calls from switch-case
Date:   Tue, 30 Apr 2019 13:38:47 +0200
Message-Id: <20190430113558.059074259@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit ce02ef06fcf7a399a6276adb83f37373d10cbbe1 upstream.

>From networking side, there are numerous attempts to get rid of indirect
calls in fast-path wherever feasible in order to avoid the cost of
retpolines, for example, just to name a few:

  * 283c16a2dfd3 ("indirect call wrappers: helpers to speed-up indirect calls of builtin")
  * aaa5d90b395a ("net: use indirect call wrappers at GRO network layer")
  * 028e0a476684 ("net: use indirect call wrappers at GRO transport layer")
  * 356da6d0cde3 ("dma-mapping: bypass indirect calls for dma-direct")
  * 09772d92cd5a ("bpf: avoid retpoline for lookup/update/delete calls on maps")
  * 10870dd89e95 ("netfilter: nf_tables: add direct calls for all builtin expressions")
  [...]

Recent work on XDP from Björn and Magnus additionally found that manually
transforming the XDP return code switch statement with more than 5 cases
into if-else combination would result in a considerable speedup in XDP
layer due to avoidance of indirect calls in CONFIG_RETPOLINE enabled
builds. On i40e driver with XDP prog attached, a 20-26% speedup has been
observed [0]. Aside from XDP, there are many other places later in the
networking stack's critical path with similar switch-case
processing. Rather than fixing every XDP-enabled driver and locations in
stack by hand, it would be good to instead raise the limit where gcc would
emit expensive indirect calls from the switch under retpolines and stick
with the default as-is in case of !retpoline configured kernels. This would
also have the advantage that for archs where this is not necessary, we let
compiler select the underlying target optimization for these constructs and
avoid potential slow-downs by if-else hand-rewrite.

In case of gcc, this setting is controlled by case-values-threshold which
has an architecture global default that selects 4 or 5 (latter if target
does not have a case insn that compares the bounds) where some arch back
ends like arm64 or s390 override it with their own target hooks, for
example, in gcc commit db7a90aa0de5 ("S/390: Disable prediction of indirect
branches") the threshold pretty much disables jump tables by limit of 20
under retpoline builds.  Comparing gcc's and clang's default code
generation on x86-64 under O2 level with retpoline build results in the
following outcome for 5 switch cases:

* gcc with -mindirect-branch=thunk-inline -mindirect-branch-register:

  # gdb -batch -ex 'disassemble dispatch' ./c-switch
  Dump of assembler code for function dispatch:
   0x0000000000400be0 <+0>:     cmp    $0x4,%edi
   0x0000000000400be3 <+3>:     ja     0x400c35 <dispatch+85>
   0x0000000000400be5 <+5>:     lea    0x915f8(%rip),%rdx        # 0x4921e4
   0x0000000000400bec <+12>:    mov    %edi,%edi
   0x0000000000400bee <+14>:    movslq (%rdx,%rdi,4),%rax
   0x0000000000400bf2 <+18>:    add    %rdx,%rax
   0x0000000000400bf5 <+21>:    callq  0x400c01 <dispatch+33>
   0x0000000000400bfa <+26>:    pause
   0x0000000000400bfc <+28>:    lfence
   0x0000000000400bff <+31>:    jmp    0x400bfa <dispatch+26>
   0x0000000000400c01 <+33>:    mov    %rax,(%rsp)
   0x0000000000400c05 <+37>:    retq
   0x0000000000400c06 <+38>:    nopw   %cs:0x0(%rax,%rax,1)
   0x0000000000400c10 <+48>:    jmpq   0x400c90 <fn_3>
   0x0000000000400c15 <+53>:    nopl   (%rax)
   0x0000000000400c18 <+56>:    jmpq   0x400c70 <fn_2>
   0x0000000000400c1d <+61>:    nopl   (%rax)
   0x0000000000400c20 <+64>:    jmpq   0x400c50 <fn_1>
   0x0000000000400c25 <+69>:    nopl   (%rax)
   0x0000000000400c28 <+72>:    jmpq   0x400c40 <fn_0>
   0x0000000000400c2d <+77>:    nopl   (%rax)
   0x0000000000400c30 <+80>:    jmpq   0x400cb0 <fn_4>
   0x0000000000400c35 <+85>:    push   %rax
   0x0000000000400c36 <+86>:    callq  0x40dd80 <abort>
  End of assembler dump.

* clang with -mretpoline emitting search tree:

  # gdb -batch -ex 'disassemble dispatch' ./c-switch
  Dump of assembler code for function dispatch:
   0x0000000000400b30 <+0>:     cmp    $0x1,%edi
   0x0000000000400b33 <+3>:     jle    0x400b44 <dispatch+20>
   0x0000000000400b35 <+5>:     cmp    $0x2,%edi
   0x0000000000400b38 <+8>:     je     0x400b4d <dispatch+29>
   0x0000000000400b3a <+10>:    cmp    $0x3,%edi
   0x0000000000400b3d <+13>:    jne    0x400b52 <dispatch+34>
   0x0000000000400b3f <+15>:    jmpq   0x400c50 <fn_3>
   0x0000000000400b44 <+20>:    test   %edi,%edi
   0x0000000000400b46 <+22>:    jne    0x400b5c <dispatch+44>
   0x0000000000400b48 <+24>:    jmpq   0x400c20 <fn_0>
   0x0000000000400b4d <+29>:    jmpq   0x400c40 <fn_2>
   0x0000000000400b52 <+34>:    cmp    $0x4,%edi
   0x0000000000400b55 <+37>:    jne    0x400b66 <dispatch+54>
   0x0000000000400b57 <+39>:    jmpq   0x400c60 <fn_4>
   0x0000000000400b5c <+44>:    cmp    $0x1,%edi
   0x0000000000400b5f <+47>:    jne    0x400b66 <dispatch+54>
   0x0000000000400b61 <+49>:    jmpq   0x400c30 <fn_1>
   0x0000000000400b66 <+54>:    push   %rax
   0x0000000000400b67 <+55>:    callq  0x40dd20 <abort>
  End of assembler dump.

  For sake of comparison, clang without -mretpoline:

  # gdb -batch -ex 'disassemble dispatch' ./c-switch
  Dump of assembler code for function dispatch:
   0x0000000000400b30 <+0>:	cmp    $0x4,%edi
   0x0000000000400b33 <+3>:	ja     0x400b57 <dispatch+39>
   0x0000000000400b35 <+5>:	mov    %edi,%eax
   0x0000000000400b37 <+7>:	jmpq   *0x492148(,%rax,8)
   0x0000000000400b3e <+14>:	jmpq   0x400bf0 <fn_0>
   0x0000000000400b43 <+19>:	jmpq   0x400c30 <fn_4>
   0x0000000000400b48 <+24>:	jmpq   0x400c10 <fn_2>
   0x0000000000400b4d <+29>:	jmpq   0x400c20 <fn_3>
   0x0000000000400b52 <+34>:	jmpq   0x400c00 <fn_1>
   0x0000000000400b57 <+39>:	push   %rax
   0x0000000000400b58 <+40>:	callq  0x40dcf0 <abort>
  End of assembler dump.

Raising the cases to a high number (e.g. 100) will still result in similar
code generation pattern with clang and gcc as above, in other words clang
generally turns off jump table emission by having an extra expansion pass
under retpoline build to turn indirectbr instructions from their IR into
switch instructions as a built-in -mno-jump-table lowering of a switch (in
this case, even if IR input already contained an indirect branch).

For gcc, adding --param=case-values-threshold=20 as in similar fashion as
s390 in order to raise the limit for x86 retpoline enabled builds results
in a small vmlinux size increase of only 0.13% (before=18,027,528
after=18,051,192). For clang this option is ignored due to i) not being
needed as mentioned and ii) not having above cmdline
parameter. Non-retpoline-enabled builds with gcc continue to use the
default case-values-threshold setting, so nothing changes here.

[0] https://lore.kernel.org/netdev/20190129095754.9390-1-bjorn.topel@gmail.com/
    and "The Path to DPDK Speeds for AF_XDP", LPC 2018, networking track:
  - http://vger.kernel.org/lpc_net2018_talks/lpc18_pres_af_xdp_perf-v3.pdf
  - http://vger.kernel.org/lpc_net2018_talks/lpc18_paper_af_xdp_perf-v2.pdf

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: https://lkml.kernel.org/r/20190221221941.29358-1-daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -242,6 +242,11 @@ KBUILD_CFLAGS += -fno-asynchronous-unwin
 # Avoid indirect branches in kernel to deal with Spectre
 ifdef CONFIG_RETPOLINE
   KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
+  # Additionally, avoid generating expensive indirect jumps which
+  # are subject to retpolines for small number of switch cases.
+  # clang turns off jump table generation by default when under
+  # retpoline builds, however, gcc does not for x86.
+  KBUILD_CFLAGS += $(call cc-option,--param=case-values-threshold=20)
 endif
 
 archscripts: scripts_basic


