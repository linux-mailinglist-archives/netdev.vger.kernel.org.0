Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5122F8A7D
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbhAPBaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:30:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:59282 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728604AbhAPBaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 20:30:07 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l0aP5-000FY0-0O; Sat, 16 Jan 2021 02:29:23 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-01-16
Date:   Sat, 16 Jan 2021 02:29:22 +0100
Message-Id: <20210116012922.17823-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26050/Fri Jan 15 13:34:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 41 non-merge commits during the last 7 day(s) which contain
a total of 100 files changed, 2565 insertions(+), 741 deletions(-).

The main changes are:

1) Extend atomic operations to the BPF instruction set along with x86-64 JIT support,
   that is, atomic{,64}_{xchg,cmpxchg,fetch_{add,and,or,xor}}, from Brendan Jackman.

2) Add support for using kernel module global variables (__ksym externs in BPF
   programs) retrieved via module's BTF, from Andrii Nakryiko.

3) Generalize BPF stackmap's buildid retrieval and add support to have buildid
   stored in mmap2 event for perf, from Jiri Olsa.

4) Various fixes for cross-building BPF sefltests out-of-tree which then will
   unblock wider automated testing on ARM hardware, from Jean-Philippe Brucker.

5) Allow to retrieve SOL_SOCKET opts from sock_addr progs, from Daniel Borkmann.

6) Clean up driver's XDP buffer init and split into two helpers to init per-
   descriptor and non-changing fields during processing, from Lorenzo Bianconi.

7) Minor misc improvements to libbpf & bpftool, from Ian Rogers.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Duyck, Andrii Nakryiko, Björn Töpel, Camelia Groza, Hao Luo, 
Jesper Dangaard Brouer, John Fastabend, kernel test robot, KP Singh, 
Marcin Wojtas, Martin Habets, Martin KaFai Lau, Peter Zijlstra (Intel), 
Shay Agroskin, Song Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 833d22f2f922bbee6430e558417af060db6bbe9c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-08 13:28:00 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to eed6a9a9571b94acdad98fab2fbf6a92199edf69:

  Merge branch 'perf: Add mmap2 build id support' (2021-01-14 19:29:59 -0800)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'Support kernel module ksym variables'
      Merge branch 'Atomics for eBPF'
      Merge branch 'perf: Add mmap2 build id support'

Andrii Nakryiko (12):
      libbpf: Add user-space variants of BPF_CORE_READ() family of macros
      libbpf: Add non-CO-RE variants of BPF_CORE_READ() macro family
      selftests/bpf: Add tests for user- and non-CO-RE BPF_CORE_READ() variants
      libbpf: Clarify kernel type use with USER variants of CORE reading macros
      bpf: Add bpf_patch_call_args prototype to include/linux/bpf.h
      bpf: Avoid warning when re-casting __bpf_call_base into __bpf_call_base_args
      bpf: Declare __bpf_free_used_maps() unconditionally
      selftests/bpf: Sync RCU before unloading bpf_testmod
      bpf: Support BPF ksym variables in kernel modules
      libbpf: Support kernel module ksym externs
      selftests/bpf: Test kernel module ksym externs
      Merge branch 'selftests/bpf: Some build fixes'

Brendan Jackman (13):
      bpf: Clarify return value of probe str helpers
      bpf: Fix a verifier message for alloc size helper arg
      bpf: x86: Factor out emission of ModR/M for *(reg + off)
      bpf: x86: Factor out emission of REX byte
      bpf: x86: Factor out a lookup table for some ALU opcodes
      bpf: Rename BPF_XADD and prepare to encode other atomics in .imm
      bpf: Move BPF_STX reserved field check into BPF_STX verifier code
      bpf: Add BPF_FETCH field / create atomic_fetch_add instruction
      bpf: Add instructions for atomic_[cmp]xchg
      bpf: Pull out a macro for interpreting atomic ALU operations
      bpf: Add bitwise atomic instructions
      bpf: Add tests for new BPF atomic operations
      bpf: Document new atomic instructions

Daniel Borkmann (2):
      bpf: Allow to retrieve sol_socket opts from sock_addr progs
      bpf: Extend bind v4/v6 selftests for mark/prio/bindtoifindex

Ian Rogers (2):
      bpf, libbpf: Avoid unused function warning on bpf_tail_call_static
      tools/bpftool: Add -Wall when building BPF programs

Jean-Philippe Brucker (5):
      selftests/bpf: Enable cross-building
      selftests/bpf: Fix out-of-tree build
      selftests/bpf: Move generated test files to $(TEST_GEN_FILES)
      selftests/bpf: Fix installation of urandom_read
      selftests/bpf: Install btf_dump test cases

Jiri Olsa (3):
      bpf: Move stack_map_get_build_id into lib
      bpf: Add size arg to build_id_parse function
      perf: Add build id data in mmap2 event

Leah Neukirchen (1):
      bpf: Remove unnecessary <argp.h> include from preload/iterators

Lorenzo Bianconi (2):
      net, xdp: Introduce xdp_init_buff utility routine
      net, xdp: Introduce xdp_prepare_buff utility routine

Menglong Dong (1):
      selftests/bpf: Remove duplicate include in test_lsm

Zheng Yongjun (1):
      bpf: Replace fput with sockfd_put in sock map

 Documentation/networking/filter.rst                |  61 ++++-
 arch/arm/net/bpf_jit_32.c                          |   7 +-
 arch/arm64/net/bpf_jit_comp.c                      |  16 +-
 arch/mips/net/ebpf_jit.c                           |  11 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |  25 ++-
 arch/riscv/net/bpf_jit_comp32.c                    |  20 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  16 +-
 arch/s390/net/bpf_jit_comp.c                       |  27 ++-
 arch/sparc/net/bpf_jit_comp_64.c                   |  17 +-
 arch/x86/net/bpf_jit_comp.c                        | 217 ++++++++++++------
 arch/x86/net/bpf_jit_comp32.c                      |   6 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   9 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |  12 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  10 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  14 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  18 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  15 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  18 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  19 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  19 +-
 drivers/net/ethernet/marvell/mvneta.c              |  10 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  14 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   8 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c       |  14 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |   4 +-
 drivers/net/ethernet/netronome/nfp/bpf/verifier.c  |  15 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  12 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   9 +-
 drivers/net/ethernet/sfc/rx.c                      |  10 +-
 drivers/net/ethernet/socionext/netsec.c            |   9 +-
 drivers/net/ethernet/ti/cpsw.c                     |  18 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |  18 +-
 drivers/net/hyperv/netvsc_bpf.c                    |   8 +-
 drivers/net/tun.c                                  |  12 +-
 drivers/net/veth.c                                 |  14 +-
 drivers/net/virtio_net.c                           |  18 +-
 drivers/net/xen-netfront.c                         |  10 +-
 include/linux/bpf.h                                |  18 +-
 include/linux/bpf_verifier.h                       |   3 +
 include/linux/btf.h                                |   3 +
 include/linux/buildid.h                            |  12 +
 include/linux/filter.h                             |  27 ++-
 include/net/xdp.h                                  |  19 ++
 include/uapi/linux/bpf.h                           |  20 +-
 include/uapi/linux/perf_event.h                    |  42 +++-
 kernel/bpf/btf.c                                   |  31 ++-
 kernel/bpf/core.c                                  |  90 +++++++-
 kernel/bpf/disasm.c                                |  43 +++-
 kernel/bpf/preload/iterators/iterators.c           |   2 +-
 kernel/bpf/stackmap.c                              | 143 +-----------
 kernel/bpf/verifier.c                              | 231 +++++++++++++++----
 kernel/events/core.c                               |  32 ++-
 lib/Makefile                                       |   3 +-
 lib/buildid.c                                      | 149 +++++++++++++
 lib/test_bpf.c                                     |  14 +-
 net/bpf/test_run.c                                 |  11 +-
 net/core/dev.c                                     |  24 +-
 net/core/filter.c                                  |  25 ++-
 net/core/sock_map.c                                |   2 +-
 samples/bpf/bpf_insn.h                             |   4 +-
 samples/bpf/cookie_uid_helper_example.c            |   8 +-
 samples/bpf/sock_example.c                         |   2 +-
 samples/bpf/test_cgrp2_attach.c                    |   5 +-
 tools/bpf/bpftool/Makefile                         |   2 +-
 tools/include/linux/filter.h                       |  24 +-
 tools/include/uapi/linux/bpf.h                     |  20 +-
 tools/lib/bpf/bpf_core_read.h                      | 169 ++++++++++----
 tools/lib/bpf/bpf_helpers.h                        |   2 +-
 tools/lib/bpf/libbpf.c                             |  50 +++--
 tools/testing/selftests/bpf/Makefile               |  60 +++--
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   3 +
 tools/testing/selftests/bpf/prog_tests/atomics.c   | 246 +++++++++++++++++++++
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |  33 ---
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   4 +-
 .../selftests/bpf/prog_tests/core_read_macros.c    |  64 ++++++
 .../selftests/bpf/prog_tests/ksyms_module.c        |  31 +++
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |   1 -
 tools/testing/selftests/bpf/progs/atomics.c        | 154 +++++++++++++
 tools/testing/selftests/bpf/progs/bind4_prog.c     |  42 +++-
 tools/testing/selftests/bpf/progs/bind6_prog.c     |  42 +++-
 .../selftests/bpf/progs/test_core_read_macros.c    |  50 +++++
 .../selftests/bpf/progs/test_ksyms_module.c        |  26 +++
 tools/testing/selftests/bpf/test_cgroup_storage.c  |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |  11 +
 tools/testing/selftests/bpf/test_progs.h           |   1 +
 tools/testing/selftests/bpf/verifier/atomic_and.c  |  77 +++++++
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |  96 ++++++++
 .../selftests/bpf/verifier/atomic_fetch_add.c      | 106 +++++++++
 tools/testing/selftests/bpf/verifier/atomic_or.c   |  77 +++++++
 tools/testing/selftests/bpf/verifier/atomic_xchg.c |  46 ++++
 tools/testing/selftests/bpf/verifier/atomic_xor.c  |  77 +++++++
 tools/testing/selftests/bpf/verifier/ctx.c         |   7 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |   4 +-
 tools/testing/selftests/bpf/verifier/leak_ptr.c    |  10 +-
 tools/testing/selftests/bpf/verifier/meta_access.c |   4 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   3 +-
 .../selftests/bpf/verifier/value_illegal_alu.c     |   2 +-
 tools/testing/selftests/bpf/verifier/xadd.c        |  18 +-
 100 files changed, 2565 insertions(+), 741 deletions(-)
 create mode 100644 include/linux/buildid.h
 create mode 100644 lib/buildid.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/atomics.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_read_macros.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/atomics.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_read_macros.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_module.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_and.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_cmpxchg.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_fetch_add.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_or.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_xchg.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_xor.c
