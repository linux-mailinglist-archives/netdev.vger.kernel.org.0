Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 198115658FE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiGDOyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiGDOyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:54:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32E0D316;
        Mon,  4 Jul 2022 07:54:38 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2633123A;
        Mon,  4 Jul 2022 07:54:38 -0700 (PDT)
Received: from e124483.cambridge.arm.com (e124483.cambridge.arm.com [10.1.29.145])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E3A633F792;
        Mon,  4 Jul 2022 07:54:33 -0700 (PDT)
From:   Andrew Kilroy <andrew.kilroy@arm.com>
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Andrew Kilroy <andrew.kilroy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH 0/8] Perf stack unwinding with pointer authentication
Date:   Mon,  4 Jul 2022 15:53:24 +0100
Message-Id: <20220704145333.22557-1-andrew.kilroy@arm.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series addresses issues that perf has when attempting to show
userspace stacks in the presence of pointer authentication on arm64.

Depending on whether libunwind or libdw is used, perf incorrectly
displays the userspace stack in 'perf report --stdio'.  With libunwind,
only the leaf function is shown.

            |
            ---0x200000004005bf
               0x200000004005bf
               my_leaf_function

With libdw, only the leaf function is shown even though there are
callers in the application.

            |
            ---my_leaf_function


The reason perf cannot show the stack upon a perf report --stdio is
because the unwinders are given instruction pointers which contain a
pointer authentication code (PAC).  For the libraries to correctly
unwind, they need to know which bits of the instruction pointer to turn
off.

The kernel exposes the set of PAC bits via the NT_ARM_PAC_MASK regset.
It is expected that this may vary per-task in future. The kernel also
exposes which pointer authentication keys are enabled via the
NT_ARM_PAC_ENABLED_KEYS regset, and this can change dynamically. These
are per-task state which perf would need to sample.

It's not always feasible for perf to acquire these regsets via ptrace.
When sampling system-wide or with inherited events this may require a
large volume of ptrace requests, and by the time the perf tool processes
a sample for a task, that task might already have terminated.

Instead, these patches allow this state to be sampled into the perf
ringbuffer, where it can be consumed more easily by the perf tool.

The first patch changes the kernel to send the authentication PAC masks
to userspace perf via the perf ring buffer.  This is published in the
sample, using a new sample field PERF_SAMPLE_ARCH_1.

The subsequent patches are changes to userspace perf to

1) request the PERF_SAMPLE_ARCH_1
2) supply the instruction mask to libunwind
3) ensure perf can cope with an older kernel that does not know about
   the PERF_SAMPLE_ARCH_1 sample field.
4) checks if the version of libunwind has the capability to accept
   an instruction mask from perf and if so enable the feature.

These changes depend on a change to libunwind, that is yet to be
released, although the patch has been merged.

  https://github.com/libunwind/libunwind/pull/360


Andrew Kilroy (6):
  perf arm64: Send pointer auth masks to ring buffer
  perf evsel: Do not request ptrauth sample field if not supported
  perf tools: arm64: Read ptrauth data from kernel
  perf libunwind: Feature check for libunwind ptrauth callback
  perf libunwind: arm64 pointer authentication
  perf tools: Print ptrauth struct in perf report

German Gomez (2):
  perf test: Update arm64 tests to expect ptrauth masks
  perf test arm64: Test unwinding with PACs on gcc & clang compilers

 arch/arm64/include/asm/arch_sample_data.h     |  38 ++++++
 arch/arm64/kernel/Makefile                    |   2 +-
 arch/arm64/kernel/arch_sample_data.c          |  37 ++++++
 include/linux/perf_event.h                    |  24 ++++
 include/uapi/linux/perf_event.h               |   5 +-
 kernel/events/core.c                          |  35 ++++++
 tools/build/Makefile.feature                  |   2 +
 tools/build/feature/Makefile                  |   4 +
 tools/build/feature/test-all.c                |   5 +
 .../feature/test-libunwind-arm64-ptrauth.c    |  26 ++++
 tools/include/uapi/linux/perf_event.h         |   5 +-
 tools/perf/Makefile.config                    |  10 ++
 tools/perf/Makefile.perf                      |   1 +
 tools/perf/tests/Build                        |   1 +
 tools/perf/tests/arm_unwind_pac.c             | 113 ++++++++++++++++++
 tools/perf/tests/arm_unwind_pac.sh            |  57 +++++++++
 tools/perf/tests/attr/README                  |   1 +
 .../attr/test-record-graph-default-aarch64    |   3 +-
 tools/perf/tests/attr/test-record-graph-dwarf |   1 +
 .../attr/test-record-graph-dwarf-aarch64      |  13 ++
 .../tests/attr/test-record-graph-fp-aarch64   |   3 +-
 tools/perf/tests/builtin-test.c               |   1 +
 tools/perf/tests/sample-parsing.c             |   2 +-
 tools/perf/tests/tests.h                      |   1 +
 tools/perf/util/event.h                       |   8 ++
 tools/perf/util/evsel.c                       |  64 ++++++++++
 tools/perf/util/evsel.h                       |   1 +
 tools/perf/util/perf_event_attr_fprintf.c     |   2 +-
 tools/perf/util/session.c                     |  15 +++
 tools/perf/util/unwind-libunwind-local.c      |  12 ++
 30 files changed, 485 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/include/asm/arch_sample_data.h
 create mode 100644 arch/arm64/kernel/arch_sample_data.c
 create mode 100644 tools/build/feature/test-libunwind-arm64-ptrauth.c
 create mode 100644 tools/perf/tests/arm_unwind_pac.c
 create mode 100755 tools/perf/tests/arm_unwind_pac.sh
 create mode 100644 tools/perf/tests/attr/test-record-graph-dwarf-aarch64

-- 
2.17.1

