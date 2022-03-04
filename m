Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEDA4CD958
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbiCDQoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240713AbiCDQoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:44:04 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58356F11B4;
        Fri,  4 Mar 2022 08:43:16 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nQB1N-000Ewe-FU; Fri, 04 Mar 2022 17:43:13 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-03-04
Date:   Fri,  4 Mar 2022 17:43:13 +0100
Message-Id: <20220304164313.31675-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26471/Fri Mar  4 10:24:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 32 non-merge commits during the last 14 day(s) which contain
a total of 59 files changed, 1038 insertions(+), 473 deletions(-).

The main changes are:

1) Optimize BPF stackmap's build_id retrieval by caching last valid build_id,
   as consecutive stack frames are likely to be in the same VMA and therefore
   have the same build id, from Hao Luo.

2) Several improvements to arm64 BPF JIT, that is, support for JITing
   the atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and lastly
   atomic[64]_{xchg|cmpxchg}. Also fix the BTF line info dump for JITed
   programs, from Hou Tao.

3) Optimize generic BPF map batch deletion by only enforcing synchronize_rcu()
   barrier once upon return to user space, from Eric Dumazet.

4) For kernel build parse DWARF and generate BTF through pahole with enabled
   multithreading, from Kui-Feng Lee.

5) BPF verifier usability improvements by making log info more concise and
   replacing inv with scalar type name, from Mykola Lysenko.

6) Two follow-up fixes for BPF prog JIT pack allocator, from Song Liu.

7) Add a new Kconfig to allow for loading kernel modules with non-matching
   BTF type info; their BTF info is then removed on load, from Connor O'Brien.

8) Remove reallocarray() usage from bpftool and switch to libbpf_reallocarray()
   in order to fix compilation errors for older glibc, from Mauricio Vásquez.

9) Fix libbpf to error on conflicting name in BTF when type declaration
   appears before the definition, from Xu Kuohai.

10) Fix issue in BPF preload for in-kernel light skeleton where loaded BPF
    program fds prevent init process from setting up fd 0-2, from Yucong Sun.

11) Fix libbpf reuse of pinned perf RB map when max_entries is auto-determined
    by libbpf, from Stijn Tintel.

12) Several cleanups for libbpf and a fix to enforce perf RB map #pages to be
    non-zero, from Yuntao Wang.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Hengqi Chen, kernel test robot, Kui-Feng Lee, Kumar 
Kartikeya Dwivedi, Marc Zyngier, Namhyung Kim, Pasha Tatashin, Quentin 
Monnet, Shung-Hsi Yu, Song Liu, Stanislav Fomichev, Yonghong Song, 
Yucong Sun

----------------------------------------------------------------

The following changes since commit 086d49058cd8471046ae9927524708820f5fd1c7:

  ipv6: annotate some data-races around sk->sk_prot (2022-02-18 11:53:28 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 7df5072cc05fd1aab5823bbc465d033cd292fca8:

  bpf: Small BPF verifier log improvements (2022-03-03 16:54:10 +0100)

----------------------------------------------------------------
Alexei Starovoitov (1):
      Merge branch 'fixes for bpf_prog_pack'

Andrii Nakryiko (1):
      selftests/bpf: Fix btfgen tests

Connor O'Brien (1):
      bpf: Add config to allow loading modules with BTF mismatches

Daniel Borkmann (1):
      Merge branch 'for-next/insn' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/arm64/linux

Delyan Kratunov (1):
      bpftool: Bpf skeletons assert type sizes

Eric Dumazet (1):
      bpf: Call maybe_wait_bpf_programs() only once from generic_map_delete_batch()

Hao Luo (1):
      bpf: Cache the last valid build_id

Hou Tao (6):
      arm64: move AARCH64_BREAK_FAULT into insn-def.h
      arm64: insn: add encoders for atomic operations
      bpf, arm64: Call build_prologue() first in first JIT pass
      bpf, arm64: Feed byte-offset into bpf line info
      bpf, arm64: Support more atomic operations
      bpf, selftests: Use raw_tp program for atomic test

James Morse (1):
      arm64: insn: Generate 64 bit mask immediates correctly

Kui-Feng Lee (1):
      scripts/pahole-flags.sh: Parse DWARF and generate BTF with multithreading.

Kumar Kartikeya Dwivedi (1):
      selftests/bpf: Add test for reg2btf_ids out of bounds access

Mauricio Vásquez (1):
      bpftool: Remove usage of reallocarray()

Mykola Lysenko (1):
      bpf: Small BPF verifier log improvements

Song Liu (2):
      x86: Disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86
      bpf, x86: Set header->size properly before freeing it

Souptick Joarder (HPE) (1):
      bpf: Initialize ret to 0 inside btf_populate_kfunc_set()

Stanislav Fomichev (1):
      bpf, test_run: Fix overflow in XDP frags bpf_test_finish

Stijn Tintel (1):
      libbpf: Fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning

Tiezhu Yang (1):
      bpf: Add some description about BPF_JIT_ALWAYS_ON in Kconfig

Tom Rix (1):
      bpf: Cleanup comments

Wan Jiabing (1):
      bpf, docs: Add a missing colon in verifier.rst

Xu Kuohai (2):
      libbpf: Skip forward declaration when counting duplicated type names
      selftests/bpf: Update btf_dump case for conflicting names

Yonghong Song (1):
      selftests/bpf: Fix a clang deprecated-declarations compilation error

Yucong Sun (1):
      bpf: Fix issue with bpf preload module taking over stdout/stdin of kernel.

Yuntao Wang (4):
      libbpf: Remove redundant check in btf_fixup_datasec()
      libbpf: Simplify the find_elf_sec_sz() function
      bpftool: Remove redundant slashes
      libbpf: Add a check to ensure that page_cnt is non-zero

 Documentation/bpf/verifier.rst                     |   2 +-
 arch/arm64/include/asm/debug-monitors.h            |  12 -
 arch/arm64/include/asm/insn-def.h                  |  14 ++
 arch/arm64/include/asm/insn.h                      |  80 ++++++-
 arch/arm64/lib/insn.c                              | 187 ++++++++++++++--
 arch/arm64/net/bpf_jit.h                           |  44 +++-
 arch/arm64/net/bpf_jit_comp.c                      | 241 +++++++++++++++++----
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/net/bpf_jit_comp.c                        |   5 +-
 kernel/bpf/Kconfig                                 |   4 +
 kernel/bpf/bpf_local_storage.c                     |   2 +-
 kernel/bpf/btf.c                                   |  11 +-
 kernel/bpf/cgroup.c                                |   8 +-
 kernel/bpf/core.c                                  |   9 +-
 kernel/bpf/hashtab.c                               |   2 +-
 kernel/bpf/helpers.c                               |   2 +-
 kernel/bpf/local_storage.c                         |   2 +-
 kernel/bpf/preload/bpf_preload_kern.c              |   7 +
 kernel/bpf/reuseport_array.c                       |   2 +-
 kernel/bpf/stackmap.c                              |  12 +-
 kernel/bpf/syscall.c                               |   5 +-
 kernel/bpf/trampoline.c                            |   2 +-
 kernel/bpf/verifier.c                              |  64 +++---
 lib/Kconfig.debug                                  |  10 +
 net/bpf/test_run.c                                 |   5 +
 scripts/pahole-flags.sh                            |   3 +
 tools/bpf/bpftool/Makefile                         |  20 +-
 tools/bpf/bpftool/gen.c                            | 127 +++++++++--
 tools/bpf/bpftool/main.h                           |   2 +-
 tools/bpf/bpftool/prog.c                           |   7 +-
 tools/bpf/bpftool/xlated_dumper.c                  |   5 +-
 tools/lib/bpf/btf_dump.c                           |   5 +
 tools/lib/bpf/libbpf.c                             |  56 ++---
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |   3 +-
 tools/testing/selftests/bpf/prog_tests/align.c     | 218 +++++++++----------
 tools/testing/selftests/bpf/prog_tests/atomics.c   |  91 ++------
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  54 +++--
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  17 +-
 tools/testing/selftests/bpf/prog_tests/log_buf.c   |   4 +-
 tools/testing/selftests/bpf/progs/atomics.c        |  28 +--
 tools/testing/selftests/bpf/test_cpp.cpp           |   3 +
 .../selftests/bpf/verifier/atomic_invalid.c        |   6 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |   4 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  25 ++-
 tools/testing/selftests/bpf/verifier/ctx.c         |   4 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |   2 +-
 .../selftests/bpf/verifier/helper_access_var_len.c |   6 +-
 tools/testing/selftests/bpf/verifier/jmp32.c       |  16 +-
 tools/testing/selftests/bpf/verifier/precise.c     |   4 +-
 tools/testing/selftests/bpf/verifier/raw_stack.c   |   4 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   6 +-
 .../selftests/bpf/verifier/search_pruning.c        |   2 +-
 tools/testing/selftests/bpf/verifier/sock.c        |   2 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |  38 ++--
 tools/testing/selftests/bpf/verifier/unpriv.c      |   4 +-
 .../selftests/bpf/verifier/value_illegal_alu.c     |   4 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |   4 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |   2 +-
 59 files changed, 1038 insertions(+), 473 deletions(-)
