Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694811028E1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfKSQIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:08:14 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35798 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727509AbfKSQIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:08:13 -0500
Received: by mail-pf1-f195.google.com with SMTP id q13so12399065pff.2;
        Tue, 19 Nov 2019 08:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onDCXnuc72nzrLzMxythbvEUqz2tvX0Mw0spNkTCjA8=;
        b=UsP5zMiMSZ1RSEubdcZC6U2xAGZY1YJcmpEAIziwu03OtsdjlDzA5woIPgfh0paUCS
         tBN2WvjiLiG+KNVtngX6P4Qq9onj0efkQu179VbFuby84Te7Sugoeh6t5cNiY0bcFjXY
         8K0WkMUZrHf7hMHsZ6BIFb+Rg42Z7dt4fNtco5eWFy2l/h2iPeKgMktLXqsH4ic/rN1R
         YXs0rU/Uo7PxJdmbk/QF17jiWc7UjC7/h5y6mEIrhFYMDHr8e8sTOCsrxwFMzK2fHUFn
         GnyijBeLS+rmQm25uHAe4ndKInuMJ4gjlUuUphlzbm9gPBq7sdoNrI+k//cKeKbFM2Tp
         m3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onDCXnuc72nzrLzMxythbvEUqz2tvX0Mw0spNkTCjA8=;
        b=kFk2Y4Kww5HScwxF1ft74WL63nDY+9yBYR7pw+KBr9qGGnCvoa1/QI4c84tsB49WPu
         +twHBOZO9uJuBMqv0HNFm5O1rt9QJWKJe8tcvC77OhJZ11+TEyq5ZxHAmuSFjYkAyASh
         5hp10kKZWR3iOSJLBed50iXS0XWOgUfvskZXInfHZG7aIIXP6FnI1Sjh7aoGnq0uxD7h
         3g5RjXQ3fOQbxooTRYjfk8eqENDnYdnvguXTY7npe+68pmTRkgjwSeMrEcuE7CNZqq6u
         El3iCtIK1vmwHsoDqCs+CZ4mtIMVVkhyjkXTRFLCoeksy5a2cA22T0PD1uVp+bbrO/7C
         SagQ==
X-Gm-Message-State: APjAAAUQEQpAVT1c8M+TfEiYs0430wxGiW1siF4fIEEps2eSvTNl4TAp
        8eyUmnhBgucmfxpm1zak8+rW60uvAWjlvQ==
X-Google-Smtp-Source: APXvYqyJp7JUAQ6N5vibk0UunRb8+Cuw+V3uF0w3Jm7c+bQ1ailnPi0iGKzBmtV7vNJxYTshhYZkdA==
X-Received: by 2002:a63:3cd:: with SMTP id 196mr6529961pgd.150.1574179692221;
        Tue, 19 Nov 2019 08:08:12 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id v10sm25196949pfg.11.2019.11.19.08.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 08:08:11 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next 0/3] Introduce xdp_call.h and the BPF dispatcher
Date:   Tue, 19 Nov 2019 17:07:54 +0100
Message-Id: <20191119160757.27714-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

This series introduces the BPF dispatcher and a wrapper, xdp_call.h,
which are a mechanism to avoid indirect calls when retpolines are
enabled.

The BPF dispatcher is a multi-way branch code generator, mainly
targeted for XDP programs. When an XDP program is executed via the
bpf_prog_run_xdp(), it is invoked via an indirect call. With
retpolines enabled, the indirect call has a substantial performance
impact. The dispatcher is a mechanism that transform multiple indirect
calls to direct calls, and therefore avoids the retpoline. The
dispatcher is generated using the BPF JIT, and relies on text poking
provided by bpf_arch_text_poke().

The dispatcher hijacks a trampoline function it via the __fentry__ nop
of the trampoline. One dispatcher instance currently supports up to 16
dispatch points. This can be extended in the future.

An example: A module/driver allocates a dispatcher. The dispatcher is
shared for all netdevs. Each unique XDP program has a slot in the
dispatcher, registered by a netdev. The netdev then uses the
dispatcher to call the correct program with a direct call.

The xdp_call.h header wraps a more user-friendly API around the BPF
dispatcher. A user adds a trampoline/XDP caller using the
DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
xdp_call_update(). The actual dispatch is done via xdp_call().

This series relies on Daniel's text poking parts of the "Optimize BPF
tail calls for direct jumps" work [0].

[0] https://patchwork.ozlabs.org/cover/1197087/

Generated code, x86-64
======================

The dispatcher currently has a maximum of 16 entries, where one entry
is a unique BPF program. Multiple users of a dispatcher instance using
the same BPF program will share that entry.

The program/slot lookup is performed by a binary search, O(log
n). Let's have a look at the generated code.

The trampoline function has the following signature:

  unsigned int tramp(const void *xdp_ctx,
                     const struct bpf_insn *insnsi,
                     unsigned int (*bpf_func)(const void *,
                                              const struct bpf_insn *))

On Intel x86-64 this means that rdx will contain the bpf_func. To,
make it easier to read, I've let the BPF programs have the following
range: 0xffffffffffffffff (-1) to 0xfffffffffffffff0
(-16). 0xffffffff81c00f10 is the retpoline thunk, in this case
__x86_indirect_thunk_rdx.

The minimal dispatcher will then look like this:

ffffffffc0002000: cmp    rdx,0xffffffffffffffff
ffffffffc0002007: je     0xffffffffffffffff ; -1
ffffffffc000200d: jmp    0xffffffff81c00f10

The largest dispatcher looks like this:

ffffffffc0020000: cmp    rdx,0xfffffffffffffff7 ; -9
ffffffffc0020007: jg     0xffffffffc0020130
ffffffffc002000d: cmp    rdx,0xfffffffffffffff3 ; -13
ffffffffc0020014: jg     0xffffffffc00200a0
ffffffffc002001a: cmp    rdx,0xfffffffffffffff1 ; -15
ffffffffc0020021: jg     0xffffffffc0020060
ffffffffc0020023: cmp    rdx,0xfffffffffffffff0 ; -16
ffffffffc002002a: jg     0xffffffffc0020040
ffffffffc002002c: cmp    rdx,0xfffffffffffffff0 ; -16
ffffffffc0020033: je     0xfffffffffffffff0 ; -16
ffffffffc0020039: jmp    0xffffffff81c00f10
ffffffffc002003e: xchg   ax,ax
ffffffffc0020040: cmp    rdx,0xfffffffffffffff1 ; -15
ffffffffc0020047: je     0xfffffffffffffff1 ; -15
ffffffffc002004d: jmp    0xffffffff81c00f10
ffffffffc0020052: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002005a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020060: cmp    rdx,0xfffffffffffffff2 ; -14
ffffffffc0020067: jg     0xffffffffc0020080
ffffffffc0020069: cmp    rdx,0xfffffffffffffff2 ; -14
ffffffffc0020070: je     0xfffffffffffffff2 ; -14
ffffffffc0020076: jmp    0xffffffff81c00f10
ffffffffc002007b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020080: cmp    rdx,0xfffffffffffffff3 ; -13
ffffffffc0020087: je     0xfffffffffffffff3 ; -13
ffffffffc002008d: jmp    0xffffffff81c00f10
ffffffffc0020092: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002009a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00200a0: cmp    rdx,0xfffffffffffffff5 ; -11
ffffffffc00200a7: jg     0xffffffffc00200f0
ffffffffc00200a9: cmp    rdx,0xfffffffffffffff4 ; -12
ffffffffc00200b0: jg     0xffffffffc00200d0
ffffffffc00200b2: cmp    rdx,0xfffffffffffffff4 ; -12
ffffffffc00200b9: je     0xfffffffffffffff4 ; -12
ffffffffc00200bf: jmp    0xffffffff81c00f10
ffffffffc00200c4: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00200cc: nop    DWORD PTR [rax+0x0]
ffffffffc00200d0: cmp    rdx,0xfffffffffffffff5 ; -11
ffffffffc00200d7: je     0xfffffffffffffff5 ; -11
ffffffffc00200dd: jmp    0xffffffff81c00f10
ffffffffc00200e2: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00200ea: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00200f0: cmp    rdx,0xfffffffffffffff6 ; -10
ffffffffc00200f7: jg     0xffffffffc0020110
ffffffffc00200f9: cmp    rdx,0xfffffffffffffff6 ; -10
ffffffffc0020100: je     0xfffffffffffffff6 ; -10
ffffffffc0020106: jmp    0xffffffff81c00f10
ffffffffc002010b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020110: cmp    rdx,0xfffffffffffffff7 ; -9
ffffffffc0020117: je     0xfffffffffffffff7 ; -9
ffffffffc002011d: jmp    0xffffffff81c00f10
ffffffffc0020122: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002012a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020130: cmp    rdx,0xfffffffffffffffb ; -5
ffffffffc0020137: jg     0xffffffffc00201d0
ffffffffc002013d: cmp    rdx,0xfffffffffffffff9 ; -7
ffffffffc0020144: jg     0xffffffffc0020190
ffffffffc0020146: cmp    rdx,0xfffffffffffffff8 ; -8
ffffffffc002014d: jg     0xffffffffc0020170
ffffffffc002014f: cmp    rdx,0xfffffffffffffff8 ; -8
ffffffffc0020156: je     0xfffffffffffffff8 ; -8
ffffffffc002015c: jmp    0xffffffff81c00f10
ffffffffc0020161: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020169: nop    DWORD PTR [rax+0x0]
ffffffffc0020170: cmp    rdx,0xfffffffffffffff9 ; -7
ffffffffc0020177: je     0xfffffffffffffff9 ; -7
ffffffffc002017d: jmp    0xffffffff81c00f10
ffffffffc0020182: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002018a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020190: cmp    rdx,0xfffffffffffffffa ; -6
ffffffffc0020197: jg     0xffffffffc00201b0
ffffffffc0020199: cmp    rdx,0xfffffffffffffffa ; -6
ffffffffc00201a0: je     0xfffffffffffffffa ; -6
ffffffffc00201a6: jmp    0xffffffff81c00f10
ffffffffc00201ab: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201b0: cmp    rdx,0xfffffffffffffffb ; -5
ffffffffc00201b7: je     0xfffffffffffffffb ; -5
ffffffffc00201bd: jmp    0xffffffff81c00f10
ffffffffc00201c2: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201ca: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc00201d0: cmp    rdx,0xfffffffffffffffd ; -3
ffffffffc00201d7: jg     0xffffffffc0020220
ffffffffc00201d9: cmp    rdx,0xfffffffffffffffc ; -4
ffffffffc00201e0: jg     0xffffffffc0020200
ffffffffc00201e2: cmp    rdx,0xfffffffffffffffc ; -4
ffffffffc00201e9: je     0xfffffffffffffffc ; -4
ffffffffc00201ef: jmp    0xffffffff81c00f10
ffffffffc00201f4: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc00201fc: nop    DWORD PTR [rax+0x0]
ffffffffc0020200: cmp    rdx,0xfffffffffffffffd ; -3
ffffffffc0020207: je     0xfffffffffffffffd ; -3
ffffffffc002020d: jmp    0xffffffff81c00f10
ffffffffc0020212: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc002021a: nop    WORD PTR [rax+rax*1+0x0]
ffffffffc0020220: cmp    rdx,0xfffffffffffffffe ; -2
ffffffffc0020227: jg     0xffffffffc0020240
ffffffffc0020229: cmp    rdx,0xfffffffffffffffe ; -2
ffffffffc0020230: je     0xfffffffffffffffe ; -2
ffffffffc0020236: jmp    0xffffffff81c00f10
ffffffffc002023b: nop    DWORD PTR [rax+rax*1+0x0]
ffffffffc0020240: cmp    rdx,0xffffffffffffffff ; -1
ffffffffc0020247: je     0xffffffffffffffff ; -1
ffffffffc002024d: jmp    0xffffffff81c00f10

The nops are there to align jump targets to 16B.

Performance
===========

The tests were performed using the xdp_rxq_info sample program with
the following command-line:

  # xdp_rxq_info --dev eth0 --action XDP_DROP

64B UDP packets at linerate (~59 Mpps) from a packet generator to a
40GbE i40e NIC attached to a 3GHz Intel Skylake machine.

1.  Baseline w/o dispatcher: 22.7 Mpps
2.  Dispatcher,  1 entry:    31.7 Mpps (+40%)
3.  Dispatcher,  2 entries:  32.2 Mpps (+42%)
4.  Dispatcher,  3 entries:  31.3 Mpps (+38%)
5.  Dispatcher,  4 entries:  32.0 Mpps (+41%)
6.  Dispatcher,  5 entries:  31.2 Mpps (+37%)
7.  Dispatcher,  6 entries:  31.2 Mpps (+37%)
8.  Dispatcher,  7 entries:  30.2 Mpps (+33%)
9.  Dispatcher,  8 entries:  31.3 Mpps (+39%)
10. Dispatcher,  9 entries:  30.1 Mpps (+32%)
11. Dispatcher, 10 entries:  31.6 Mpps (+39%)
12. Dispatcher, 11 entries:  31.1 Mpps (+37%)
13. Dispatcher, 12 entries:  30.9 Mpps (+36%)
14. Dispatcher, 13 entries:  30.4 Mpps (+34%)
15. Dispatcher, 14 entries:  31.2 Mpps (+37%)
16. Dispatcher, 15 entries:  30.9 Mpps (+36%)
17. Dispatcher, 16 entries:  32.1 Mpps (+41%)
18. Dispatcher, full:        22.4 Mpps (- 1%)

Test 18 is to show-case the cost of walking the a full dispatcher, and
then fallback to an indirect call.

As the results show, it is hard to see any difference between 1 to 16
entries, other than small variations between runs.

Revisions
=========

RFC->v1: [1]
  * Improved error handling (Edward and Andrii)
  * Explicit cleanup (Andrii)
  * Use 32B with sext cmp (Alexei)
  * Align jump targets to 16B (Alexei)
  * 4 to 16 entries (Toke)
  * Added stats to xdp_call_run()

[1] https://lore.kernel.org/bpf/20191113204737.31623-1-bjorn.topel@gmail.com/


Thanks!
Björn


Björn Töpel (3):
  bpf: introduce BPF dispatcher
  xdp: introduce xdp_call
  i40e: start using xdp_call.h

 arch/x86/net/bpf_jit_comp.c                 | 135 +++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c |   5 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  |   5 +-
 include/linux/xdp_call.h                    |  66 +++++++
 kernel/bpf/Makefile                         |   1 +
 kernel/bpf/dispatcher.c                     | 208 ++++++++++++++++++++
 7 files changed, 423 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/xdp_call.h
 create mode 100644 kernel/bpf/dispatcher.c

-- 
2.20.1

