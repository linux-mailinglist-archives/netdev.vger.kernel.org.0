Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF30A54FFBB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 00:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350246AbiFQWIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 18:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbiFQWIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 18:08:41 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE53054E;
        Fri, 17 Jun 2022 15:08:39 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1o2K8q-0001dq-QD; Sat, 18 Jun 2022 00:08:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-06-17
Date:   Sat, 18 Jun 2022 00:08:36 +0200
Message-Id: <20220617220836.7373-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26575/Fri Jun 17 10:08:05 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 72 non-merge commits during the last 15 day(s) which contain
a total of 92 files changed, 4582 insertions(+), 834 deletions(-).

The main changes are:

1) Add 64 bit enum value support to BTF, from Yonghong Song.

2) Implement support for sleepable BPF uprobe programs, from Delyan Kratunov.

3) Add new BPF helpers to issue and check TCP SYN cookies without binding to a
   socket especially useful in synproxy scenarios, from Maxim Mikityanskiy.

4) Fix libbpf's internal USDT address translation logic for shared libraries as
   well as uprobe's symbol file offset calculation, from Andrii Nakryiko.

5) Extend libbpf to provide an API for textual representation of the various
   map/prog/attach/link types and use it in bpftool, from Daniel Müller.

6) Provide BTF line info for RV64 and RV32 JITs, and fix a put_user bug in the
   core seen in 32 bit when storing BPF function addresses, from Pu Lehui.

7) Fix libbpf's BTF pointer size guessing by adding a list of various aliases
   for 'long' types, from Douglas Raillard.

8) Fix bpftool to readd setting rlimit since probing for memcg-based accounting
   has been unreliable and caused a regression on COS, from Quentin Monnet.

9) Fix UAF in BPF cgroup's effective program computation triggered upon BPF link
   detachment, from Tadeusz Struk.

10) Fix bpftool build bootstrapping during cross compilation which was pointing
    to the wrong AR process, from Shahab Vahedi.

11) Fix logic bug in libbpf's is_pow_of_2 implementation, from Yuze Chi.

12) BPF hash map optimization to avoid grabbing spinlocks of all CPUs when there
    is no free element. Also add a benchmark as reproducer, from Feng Zhou.

13) Fix bpftool's codegen to bail out when there's no BTF, from Michael Mullin.

14) Various minor cleanup and improvements all over the place.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Dave Marchevsky, Jakub Sitnicki, 
Jesper Dangaard Brouer, John Fastabend, kernel test robot, Maciej 
Fijalkowski, Quentin Monnet, Song Liu, Tariq Toukan, Toke 
Høiland-Jørgensen, Yonghong Song, Yuze Chi

----------------------------------------------------------------

The following changes since commit 58f9d52ff689a262bec7f5713c07f5a79e115168:

  Merge tag 'net-5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-06-02 12:50:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to f5be22c64bd6ee6c1cb0b34f4ff748d43879cd4c:

  bpf: Fix bpf_skc_lookup comment wrt. return type (2022-06-17 18:36:45 +0200)

----------------------------------------------------------------
Alexei Starovoitov (4):
      Merge branch 'bpf: Add 64bit enum value support'
      Merge branch 'Optimize performance of update hash-map when free is zero'
      Merge branch 'sleepable uprobe support'
      Merge branch 'New BPF helpers to accelerate synproxy'

Andrii Nakryiko (4):
      Merge branch 'libbpf: Textual representation of enums'
      libbpf: Fix uprobe symbol file offset calculation logic
      libbpf: Fix internal USDT address translation logic for shared libraries
      selftests/bpf: Don't force lld on non-x86 architectures

Daniel Müller (13):
      libbpf: Introduce libbpf_bpf_prog_type_str
      selftests/bpf: Add test for libbpf_bpf_prog_type_str
      bpftool: Use libbpf_bpf_prog_type_str
      libbpf: Introduce libbpf_bpf_map_type_str
      selftests/bpf: Add test for libbpf_bpf_map_type_str
      bpftool: Use libbpf_bpf_map_type_str
      libbpf: Introduce libbpf_bpf_attach_type_str
      selftests/bpf: Add test for libbpf_bpf_attach_type_str
      bpftool: Use libbpf_bpf_attach_type_str
      libbpf: Introduce libbpf_bpf_link_type_str
      selftests/bpf: Add test for libbpf_bpf_link_type_str
      bpftool: Use libbpf_bpf_link_type_str
      libbpf: Fix a couple of typos

Daniel Xu (1):
      bpf, test_run: Remove unnecessary prog type checks

Delyan Kratunov (5):
      bpf: move bpf_prog to bpf.h
      bpf: implement sleepable uprobes by chaining gps
      bpf: allow sleepable uprobe programs to attach
      libbpf: add support for sleepable uprobe programs
      selftests/bpf: add tests for sleepable (uk)probes

Douglas Raillard (1):
      libbpf: Fix determine_ptr_size() guessing

Feng Zhou (2):
      bpf: avoid grabbing spin_locks of all cpus when no free elems
      selftest/bpf/benchs: Add bpf_map benchmark

Hangbin Liu (1):
      selftests/bpf: Add drv mode testing for xdping

Hongyi Lu (1):
      bpf: Fix spelling in bpf_verifier.h

Joanne Koong (1):
      bpf: Fix non-static bpf_func_proto struct definitions

Ke Liu (1):
      xdp: Directly use ida_alloc()/free() APIs

Kosuke Fujimoto (1):
      bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"

Lorenzo Bianconi (1):
      sample: bpf: xdp_router_ipv4: Allow the kernel to send arp requests

Martin KaFai Lau (1):
      selftests/bpf: Fix tc_redirect_dtime

Maxim Mikityanskiy (6):
      bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
      bpf: Allow helpers to accept pointers with a fixed size
      bpf: Add helpers to issue and check SYN cookies in XDP
      selftests/bpf: Add selftests for raw syncookie helpers
      bpf: Allow the new syncookie helpers to work with SKBs
      selftests/bpf: Add selftests for raw syncookie helpers in TC mode

Michael Mullin (1):
      bpftool: Check for NULL ptr of btf in codegen_asserts

Pu Lehui (3):
      bpf: Unify data extension operation of jited_ksyms and jited_linfo
      bpf, riscv: Support riscv jit to provide bpf_line_info
      bpf: Correct the comment about insn_to_jit_off

Quentin Monnet (2):
      Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"
      bpftool: Do not check return value from libbpf_set_strict_mode()

Shahab Vahedi (1):
      bpftool: Fix bootstrapping during a cross compilation

Tadeusz Struk (1):
      bpf: Fix KASAN use-after-free Read in compute_effective_progs

Tobias Klauser (1):
      bpf: Fix bpf_skc_lookup comment wrt. return type

Wang Yufen (1):
      bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

Yonghong Song (20):
      bpf: Add btf enum64 support
      libbpf: Permit 64bit relocation value
      libbpf: Fix an error in 64bit relocation value computation
      libbpf: Refactor btf__add_enum() for future code sharing
      libbpf: Add enum64 parsing and new enum64 public API
      libbpf: Add enum64 deduplication support
      libbpf: Add enum64 support for btf_dump
      libbpf: Add enum64 sanitization
      libbpf: Add enum64 support for bpf linking
      libbpf: Add enum64 relocation support
      bpftool: Add btf enum64 support
      selftests/bpf: Fix selftests failure
      selftests/bpf: Test new enum kflag and enum64 API functions
      selftests/bpf: Add BTF_KIND_ENUM64 unit tests
      selftests/bpf: Test BTF_KIND_ENUM64 for deduplication
      selftests/bpf: Add a test for enum64 value relocations
      docs/bpf: Update documentation for BTF_KIND_ENUM64 support
      libbpf: Fix an unsigned < 0 bug
      selftests/bpf: Fix test_varlen verification failure with latest llvm
      selftests/bpf: Avoid skipping certain subtests

YueHaibing (1):
      bpf, arm: Remove unused function emit_a32_alu_r()

Yuntao Wang (1):
      selftests/bpf: Fix test_run logic in fexit_stress.c

Yuze Chi (1):
      libbpf: Fix is_pow_of_2

Zhengchao Shao (1):
      samples/bpf: Check detach prog exist or not in xdp_fwd

 Documentation/bpf/btf.rst                          |  43 +-
 Documentation/bpf/instruction-set.rst              |   2 +-
 arch/arm/net/bpf_jit_32.c                          |  16 -
 arch/riscv/net/bpf_jit.h                           |   1 +
 arch/riscv/net/bpf_jit_core.c                      |   8 +-
 include/linux/bpf.h                                | 105 ++-
 include/linux/bpf_verifier.h                       |   2 +-
 include/linux/btf.h                                |  28 +
 include/linux/filter.h                             |  34 -
 include/linux/skmsg.h                              |   1 +
 include/net/tcp.h                                  |   1 +
 include/uapi/linux/bpf.h                           |  88 ++-
 include/uapi/linux/btf.h                           |  17 +-
 kernel/bpf/btf.c                                   | 142 +++-
 kernel/bpf/cgroup.c                                |  70 +-
 kernel/bpf/core.c                                  |  17 +-
 kernel/bpf/helpers.c                               |  12 +-
 kernel/bpf/percpu_freelist.c                       |  20 +-
 kernel/bpf/syscall.c                               |   7 +-
 kernel/bpf/verifier.c                              |  49 +-
 kernel/events/core.c                               |  16 +-
 kernel/trace/bpf_trace.c                           |   4 +-
 kernel/trace/trace_uprobe.c                        |   5 +-
 net/bpf/test_run.c                                 |   6 -
 net/core/filter.c                                  | 130 +++-
 net/core/skmsg.c                                   |   1 +
 net/core/sock_map.c                                |  23 +
 net/ipv4/tcp_bpf.c                                 |   1 +
 net/ipv4/tcp_input.c                               |   3 +-
 net/xdp/xdp_umem.c                                 |   6 +-
 samples/bpf/xdp_fwd_user.c                         |  55 +-
 samples/bpf/xdp_router_ipv4.bpf.c                  |   9 +
 scripts/bpf_doc.py                                 |   4 +
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  16 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   5 +-
 tools/bpf/bpftool/Makefile                         |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  18 +-
 tools/bpf/bpftool/btf.c                            |  57 +-
 tools/bpf/bpftool/btf_dumper.c                     |  29 +
 tools/bpf/bpftool/cgroup.c                         |  53 +-
 tools/bpf/bpftool/common.c                         |  90 ++-
 tools/bpf/bpftool/feature.c                        |  89 ++-
 tools/bpf/bpftool/gen.c                            |   4 +
 tools/bpf/bpftool/link.c                           |  61 +-
 tools/bpf/bpftool/main.c                           |   2 -
 tools/bpf/bpftool/main.h                           |  22 +-
 tools/bpf/bpftool/map.c                            |  84 +--
 tools/bpf/bpftool/pids.c                           |   1 +
 tools/bpf/bpftool/prog.c                           |  79 +-
 tools/bpf/bpftool/struct_ops.c                     |   2 +
 tools/include/uapi/linux/bpf.h                     |  88 ++-
 tools/include/uapi/linux/btf.h                     |  17 +-
 tools/lib/bpf/btf.c                                | 229 +++++-
 tools/lib/bpf/btf.h                                |  32 +-
 tools/lib/bpf/btf_dump.c                           | 137 +++-
 tools/lib/bpf/libbpf.c                             | 296 ++++++--
 tools/lib/bpf/libbpf.h                             |  38 +-
 tools/lib/bpf/libbpf.map                           |   8 +
 tools/lib/bpf/libbpf_internal.h                    |   7 +
 tools/lib/bpf/linker.c                             |   7 +-
 tools/lib/bpf/relo_core.c                          | 113 +--
 tools/lib/bpf/relo_core.h                          |   4 +-
 tools/lib/bpf/usdt.c                               | 123 +--
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |  28 +-
 tools/testing/selftests/bpf/bench.c                |   2 +
 .../bpf/benchs/bench_bpf_hashmap_full_update.c     |  96 +++
 .../benchs/run_bench_bpf_hashmap_full_update.sh    |  11 +
 tools/testing/selftests/bpf/btf_helpers.c          |  25 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  49 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 153 +++-
 tools/testing/selftests/bpf/prog_tests/btf_write.c | 126 +++-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  65 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |  32 +-
 .../testing/selftests/bpf/prog_tests/libbpf_str.c  | 207 +++++
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   8 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        | 183 +++++
 .../bpf/progs/bpf_hashmap_full_update_bench.c      |  40 +
 .../bpf/progs/btf__core_reloc_enum64val.c          |   3 +
 .../bpf/progs/btf__core_reloc_enum64val___diff.c   |   3 +
 .../btf__core_reloc_enum64val___err_missing.c      |   3 +
 .../btf__core_reloc_enum64val___val3_missing.c     |   3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  78 ++
 .../selftests/bpf/progs/test_attach_probe.c        |  60 ++
 .../bpf/progs/test_core_reloc_enum64val.c          |  70 ++
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |  53 +-
 tools/testing/selftests/bpf/progs/test_varlen.c    |   8 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c        | 833 +++++++++++++++++++++
 .../selftests/bpf/test_bpftool_synctypes.py        | 166 ++--
 tools/testing/selftests/bpf/test_btf.h             |   1 +
 tools/testing/selftests/bpf/test_xdping.sh         |   4 +
 tools/testing/selftests/bpf/xdp_synproxy.c         | 466 ++++++++++++
 92 files changed, 4582 insertions(+), 834 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_str.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enum64val.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
