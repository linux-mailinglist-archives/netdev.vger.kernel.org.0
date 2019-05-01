Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4ADA10945
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfEAOoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:44:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50183 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfEAOoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:44:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id p21so7360574wmc.0
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 07:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UEKun5otufNAwx8YBAyUxGDzAVU+lk0pgfDUI4nGLCk=;
        b=pTsfoApBrnh5T+DZMNXS8Lscwd3G6/vqwDVbqMd1bKCdIsASSoVGMDdqlwbxmL8ppz
         PQcVpPmoD1OzDtvNWFzFIPASKbBAd6qMdSuGDGxKE+wJ7ZfsrBhG0bQ/vKKNuOg9d+Z5
         D3l/jdTZUV+aAQ143bMDcUFS4bwIiWIqIYQITKJ744UZLD7dsShAo4/p9PsIvgO68PVU
         SXEJqEA5ACRNOg5HCphnh6GHG09PODXaQwHt0aJI0Rbb9pcsv8i66rQW6oI+gjKUSHlW
         N5fnmzDqEjHIsbCTy2L2EPUSN+UYgzO/FGGugpvr8JQRXsdo8EJg79NAzWcPo2IaMIct
         Oh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UEKun5otufNAwx8YBAyUxGDzAVU+lk0pgfDUI4nGLCk=;
        b=Oy8Yd1xUQ4ZeCR2er7hUXNwcIU6IENc148xV6nSXMMC4L2ERmpabd41PhVThBbGutl
         UQxwrsR/mjbXg6XA4EXb+1dBqvNGKLd4FScgP2WJxXVFSYy8DIsewdbjgcYCEYrG/oiX
         6uuAFR+i8Ppk2Lhk4U4mTrdctu8e7RX9fSEpUy1VQGftIQas9hp0X5mvusEWzss4ieTp
         Wc+dE2/F14tqpizid2JhbnBRD9LpZetKmBZ5YArW5bYrWF+QvNnHNKN/ASxyXyaU1kDk
         WUCoD38bb5QfAR6Zn7zN3n/BuP3/IQCqzn2f0uSYNxw8m+iWpYmZ8VVlRwUUzpDlZ/Zg
         z99A==
X-Gm-Message-State: APjAAAXolcIF0VliIh0FP8DLcWucCXPx1d5LtfLSrUpgZuvU+FV8jX7K
        dG/HS/VLFWU8LTK4O60z+TCLaA==
X-Google-Smtp-Source: APXvYqxt8pqd9vSnAbZpKUKrJrgpSxi1B6+XoZBhRQCBnHC9JVevecKAfpPL+ikm1hjgx43pMW4s2g==
X-Received: by 2002:a1c:22c6:: with SMTP id i189mr7161054wmi.128.1556721850008;
        Wed, 01 May 2019 07:44:10 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g10sm36164976wrq.2.2019.05.01.07.44.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 01 May 2019 07:44:09 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paul Burton <paul.burton@mips.com>,
        Wang YanQing <udknight@gmail.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Shubham Bansal <illusionist.neo@gmail.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH v5 bpf-next 00/17] bpf: eliminate zero extensions for sub-register writes
Date:   Wed,  1 May 2019 15:43:45 +0100
Message-Id: <1556721842-29836-1-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v5:
  - Adjusted several test_verifier helpers to make them works on hosts
    w and w/o hardware zext. (Naveen)
  - Make sure zext flag not set when verifier by-passed, for example,
    libtest_bpf.ko. (Naveen)
  - Conservatively mark bpf main return value as 64-bit. (Alexei)
  - Make sure read flag is either READ64 or READ32, not the mix of both.
    (Alexei)
  - Merged patch 1 and 2 in v4. (Alexei)
  - Fixed kbuild bot warning on NFP. (kbuild bot)
  - Proposed new BPF_ZEXT insn to have optimal code-gen for various JIT
    back-ends.
  - Conservately set zext flags for patched-insn.
  - Fixed return value zext for helper function calls.
  - Also adjusted test_verifier scalability unit test to avoid triggerring
    too many insn patch which will hang computer.
  - re-tested on x86 host with llvm 9.0, no regression on test_verifier,
    test_progs, test_progs_32.
  - re-tested offload target (nfp), no regression on local testsuite.

v4:
  - added the two missing fixes which addresses two Jakub's reviewes in v3.
  - rebase on top of bpf-next.

v3:
  - remove redundant check in "propagate_liveness_reg". (Jakub)
  - add extra check in "mark_reg_read" to prune more search. (Jakub)
  - re-implemented "prog_flags" passing mechanism, removed use of
    global switch inside libbpf.
  - enabled high 32-bit randomization beyond "test_verifier" and
    "test_progs". Now it should have been enabled for all possible
    tests. Re-run all tests, haven't noticed regression.
  - remove RFC tag.

v2:
  - rebased on top of bpf-next master.
  - added comments for what is sub-register def index. (Edward, Alexei)
  - removed patch 1 which turns bit mask from enum to macro. (Alexei)
  - removed sysctl/bpf_jit_32bit_opt. (Alexei)
  - merged sub-register def insn index into reg state. (Alexei)
  - change test methodology (Alexei):
      + instead of simple unit tests on x86_64 for which this optimization
        doesn't enabled due to there is hardware support, poison high
        32-bit for whose def identified as safe to do so. this could let
        the correctness of this patch set checked when daily bpf selftest
        ran which delivers very stressful test on host machine like x86_64.
      + hi32 poisoning is gated by a new BPF_F_TEST_RND_HI32 prog flags.
      + BPF_F_TEST_RND_HI32 is enabled for all tests of "test_progs" and
        "test_verifier", the latter needs minor tweak on two unit tests,
        please see the patch for the change.
      + introduced a new global variable "libbpf_test_mode" into libbpf.
        once it is set to true, it will set BPF_F_TEST_RND_HI32 for all the
        later PROG_LOAD syscall, the goal is to easy the enable of hi32
        poison on exsiting testsuite.
        we could also introduce new APIs, for example "bpf_prog_test_load",
        then use -Dbpf_prog_load=bpf_prog_test_load to migrate tests under
        test_progs, but there are several load APIs, and such new API need
        some change on struture like "struct bpf_prog_load_attr".
      + removed old unit tests. it is based on insn scan and requires quite
        a few test_verifier generic code change. given hi32 randomization
        could offer good test coverage, the unit tests doesn't add much
        extra test value.
  - enhanced register width check ("is_reg64") when record sub-register
    write, now, it returns more accurate width.
  - Re-run all tests under "test_progs" and "test_verifier" on x86_64, no
    regression. Fixed a couple of bugs exposed:
      1. ctx field size transformation was not taken into account.
      2. insn patch could cause lost of original aux data which is
         important for ctx field conversion.
      3. return value for propagate_liveness was wrong and caused
         regression on processed insn number.
      4. helper call arg wasn't handled properly that path prune may cause
         64-bit read info in pruned path lost.
  - Re-run Cilium bpf prog for processed-insn-number benchmarking, no
    regression.

v1:
  - Fixed the missing handling on callee-saved for bpf-to-bpf call,
    sub-register defs therefore moved to frame state. (Jakub Kicinski)
  - Removed redundant "cross_reg". (Jakub Kicinski)
  - Various coding styles & grammar fixes. (Jakub Kicinski, Quentin Monnet)

eBPF ISA specification requires high 32-bit cleared when low 32-bit
sub-register is written. This applies to destination register of
ALU32/LD_H/B/W etc. JIT back-ends must guarantee this semantic when doing
code-gen.

x86-64 and arm64 ISA has the same semantics, so the corresponding JIT
back-end doesn't need to do extra work. However, 32-bit arches (arm, nfp
etc.) and some other 64-bit arches (powerpc, sparc etc), need explicitly
zero extension sequence to meet such semantic.

This is important, because for C code like the following:

  u64_value = (u64) u32_value
  ... other uses of u64_value

compiler could exploit the semantic described above and save those zero
extensions for extending u32_value to u64_value. Hardware, runtime, or BPF
JIT back-ends, are responsible for guaranteeing this. Some benchmarks shows
~40% sub-register writes out of total insns, meaning ~40% extra code-gen
and could go up for arches requiring two shifts for zero extension. All
these are because JIT back-end needs to do extra code-gen for all such
instructions, always.

However this is not always necessary in case u32 value is never cast into a
u64, which is quite normal in real life program. So, it would be really
good if we could identify those places where such type cast happened, and
only do zero extensions for them, not for the others. This could save a lot
of BPF code-gen.

Algo
====
We could use insn scan based static analysis to tell whether one
sub-register def doesn't need zero extension. However, using such static
analysis, we must do conservative assumption at branching point where
multiple uses could be introduced. So, for any sub-register def that is
active at branching point, we need to mark it as needing zero extension.
This could introducing quite a few false alarms, for example ~25% on
Cilium bpf_lxc.

It will be far better to use dynamic data-flow tracing which verifier
fortunately already has and could be easily extend to serve the purpose of
this patch set.

 - Record indices of instructions that do sub-register def (write). And
   these indices need to stay with function state so path pruning and bpf
   to bpf function call could be handled properly.

   These indices are kept up to date while doing insn walk.

 - A full register read on an active sub-register def marks the def insn as
   needing zero extension on dst register.

 - A new sub-register write overrides the old one.

   A new full register write makes the register free of zero extension on
   dst register.

 - When propagating register read64 during path pruning, it also marks def
   insns whose defs are hanging active sub-register, if there is any read64
   from shown from the equal state.

 The core patch in this set is patch 4.

Benchmark
=========
 - I estimate the JITed image could be 25% smaller on average on all these
   affected arches (nfp, arm, x32, risv, ppc, sparc, s390).

 - The implementation is based on existing register read liveness tracking
   infrastructure, so it is dynamic tracking and would trace all possible
   code paths, therefore, it shouldn't be any false alarm.

   For Cilium bpf_lxc, there is ~11500 insns in the compiled binary (use
   latest LLVM snapshot, and with -mcpu=v3 -mattr=+alu32 enabled), 4460 of
   them has sub-register writes (~40%). Calculated by:

    cat dump | grep -P "\tw" | wc -l       (ALU32)
    cat dump | grep -P "r.*=.*u32" | wc -l (READ_W)
    cat dump | grep -P "r.*=.*u16" | wc -l (READ_H)
    cat dump | grep -P "r.*=.*u8" | wc -l  (READ_B)

   After this patch set enabled, up-to 647 out of those 4460 could be
   identified as really needing zero extension on the destination, then it
   is safe for JIT back-ends to eliminate zero extension for all the other
   instructions which is ~85% of all those sub-register write insns or 33%
   of total insns. It is a significant save.

   For those insns marked as needing zero extension, part of them are
   setting up u64 parameters for help calls, remaining ones are those whose
   sub-register defs really have 64-bit reads.

Cc: David S. Miller <davem@davemloft.net>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Wang YanQing <udknight@gmail.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: Shubham Bansal <illusionist.neo@gmail.com>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>

Jiong Wang (17):
  bpf: verifier: offer more accurate helper function arg and return type
  bpf: verifier: mark verified-insn with sub-register zext flag
  bpf: verifier: mark patched-insn with sub-register zext flag
  bpf: introduce new alu insn BPF_ZEXT for explicit zero extension
  bpf: verifier: insert BPF_ZEXT according to zext analysis result
  bpf: introduce new bpf prog load flags "BPF_F_TEST_RND_HI32"
  bpf: verifier: randomize high 32-bit when BPF_F_TEST_RND_HI32 is set
  libbpf: add "prog_flags" to
    bpf_program/bpf_prog_load_attr/bpf_load_program_attr
  selftests: bpf: adjust several test_verifier helpers for insn
    insertion
  selftests: bpf: enable hi32 randomization for all tests
  arm: bpf: eliminate zero extension code-gen
  powerpc: bpf: eliminate zero extension code-gen
  s390: bpf: eliminate zero extension code-gen
  sparc: bpf: eliminate zero extension code-gen
  x32: bpf: eliminate zero extension code-gen
  riscv: bpf: eliminate zero extension code-gen
  nfp: bpf: eliminate zero extension code-gen

 Documentation/networking/filter.txt                |  10 +
 arch/arm/net/bpf_jit_32.c                          |  35 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  13 +-
 arch/riscv/net/bpf_jit_comp.c                      |  36 ++-
 arch/s390/net/bpf_jit_comp.c                       |  20 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |  12 +-
 arch/x86/net/bpf_jit_comp32.c                      |  39 ++-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c       | 115 ++++---
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |   2 +
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c  |  12 +
 include/linux/bpf.h                                |   7 +-
 include/linux/bpf_verifier.h                       |  14 +-
 include/linux/filter.h                             |   1 +
 include/uapi/linux/bpf.h                           |  21 ++
 kernel/bpf/core.c                                  |  14 +-
 kernel/bpf/helpers.c                               |  10 +-
 kernel/bpf/syscall.c                               |   4 +-
 kernel/bpf/verifier.c                              | 352 +++++++++++++++++++--
 kernel/trace/bpf_trace.c                           |   4 +-
 net/core/filter.c                                  |  38 +--
 tools/include/uapi/linux/bpf.h                     |  21 ++
 tools/lib/bpf/bpf.c                                |   1 +
 tools/lib/bpf/bpf.h                                |   1 +
 tools/lib/bpf/libbpf.c                             |   3 +
 tools/lib/bpf/libbpf.h                             |   1 +
 tools/testing/selftests/bpf/Makefile               |  10 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   1 +
 tools/testing/selftests/bpf/test_sock_addr.c       |   1 +
 tools/testing/selftests/bpf/test_sock_fields.c     |   1 +
 tools/testing/selftests/bpf/test_socket_cookie.c   |   1 +
 tools/testing/selftests/bpf/test_stub.c            |  40 +++
 tools/testing/selftests/bpf/test_verifier.c        |  31 +-
 32 files changed, 716 insertions(+), 155 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_stub.c

-- 
2.7.4

