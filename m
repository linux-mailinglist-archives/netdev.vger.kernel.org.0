Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82347AA731
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388258AbfIEPYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:24:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:45528 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731609AbfIEPYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:24:04 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i5tc1-00048N-Q3; Thu, 05 Sep 2019 17:23:53 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-09-05
Date:   Thu,  5 Sep 2019 17:23:53 +0200
Message-Id: <20190905152353.16832-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25563/Thu Sep  5 10:24:28 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) Add the ability to use unaligned chunks in the AF_XDP umem. By
   relaxing where the chunks can be placed, it allows to use an
   arbitrary buffer size and place whenever there is a free
   address in the umem. Helps more seamless DPDK AF_XDP driver
   integration. Support for i40e, ixgbe and mlx5e, from Kevin and
   Maxim.

2) Addition of a wakeup flag for AF_XDP tx and fill rings so the
   application can wake up the kernel for rx/tx processing which
   avoids busy-spinning of the latter, useful when app and driver
   is located on the same core. Support for i40e, ixgbe and mlx5e,
   from Magnus and Maxim.

3) bpftool fixes for printf()-like functions so compiler can actually
   enforce checks, bpftool build system improvements for custom output
   directories, and addition of 'bpftool map freeze' command, from Quentin.

4) Support attaching/detaching XDP programs from 'bpftool net' command,
   from Daniel.

5) Automatic xskmap cleanup when AF_XDP socket is released, and several
   barrier/{read,write}_once fixes in AF_XDP code, from Björn.

6) Relicense of bpf_helpers.h/bpf_endian.h for future libbpf
   inclusion as well as libbpf versioning improvements, from Andrii.

7) Several new BPF kselftests for verifier precision tracking, from Alexei.

8) Several BPF kselftest fixes wrt endianess to run on s390x, from Ilya.

9) And more BPF kselftest improvements all over the place, from Stanislav.

10) Add simple BPF map op cache for nfp driver to batch dumps, from Jakub.

11) AF_XDP socket umem mapping improvements for 32bit archs, from Ivan.

12) Add BPF-to-BPF call and BTF line info support for s390x JIT, from Yauheni.

13) Small optimization in arm64 JIT to spare 1 insns for BPF_MOD, from Jerin.

14) Fix an error check in bpf_tcp_gen_syncookie() helper, from Petar.

15) Various minor fixes and cleanups, from Nathan, Masahiro, Masanari,
    Peter, Wei, Yue.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit c162610c7db2e9611a7b3ec806f9c97fcfec0b0b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next (2019-08-13 18:22:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 593f191a8005110e20302039834c116676d69be1:

  Merge branch 'bpf-af-xdp-barrier-fixes' (2019-09-05 14:11:53 +0200)

----------------------------------------------------------------
Alexei Starovoitov (8):
      Merge branch 'bpftool-net-attach'
      Merge branch 'fix-printf'
      Merge branch 'btf_get_next_id'
      bpf: introduce verifier internal test flag
      tools/bpf: sync bpf.h
      selftests/bpf: verifier precise tests
      selftests/bpf: add precision tracking test
      selftests/bpf: precision tracking tests

Andrii Nakryiko (2):
      libbpf: make libbpf.map source of truth for libbpf version
      libbpf: relicense bpf_helpers.h and bpf_endian.h

Björn Töpel (6):
      xsk: remove AF_XDP socket from map when the socket is released
      xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
      xsk: avoid store-tearing when assigning queues
      xsk: avoid store-tearing when assigning umem
      xsk: use state member for socket synchronization
      xsk: lock the control mutex in sock_diag interface

Daniel Borkmann (10):
      Merge branch 'bpf-af-xdp-wakeup'
      Merge branch 'bpf-sk-storage-clone'
      Merge branch 'bpf-af-xdp-xskmap-improvements'
      Merge branch 'bpf-precision-tracking-tests'
      Merge branch 'bpf-misc-test-fixes'
      Merge branch 'bpf-bpftool-build-improvements'
      Merge branch 'bpf-nfp-map-op-cache'
      Merge branch 'bpf-xdp-unaligned-chunk'
      Merge branch 'bpf-selftest-endianess-fixes'
      Merge branch 'bpf-af-xdp-barrier-fixes'

Daniel T. Lee (4):
      tools: bpftool: add net attach command to attach XDP on interface
      tools: bpftool: add net detach command to detach XDP on interface
      tools: bpftool: add bash-completion for net attach/detach
      tools: bpftool: add documentation for net attach/detach

Ilya Leoshkevich (5):
      btf: do not use CONFIG_OUTPUT_FORMAT
      selftests/bpf: introduce bpf_cpu_to_be64 and bpf_be64_to_cpu
      selftests/bpf: fix "ctx:write sysctl:write read ok" on s390
      selftests/bpf: improve unexpected success reporting in test_syctl
      selftests/bpf: fix endianness issues in test_sysctl

Ivan Khoronzhuk (3):
      libbpf: use LFS (_FILE_OFFSET_BITS) instead of direct mmap2 syscall
      xdp: xdp_umem: replace kmap on vmap for umem map
      samples: bpf: syscall_nrs: use mmap2 if defined

Jakub Kicinski (2):
      nfp: bpf: rework MTU checking
      nfp: bpf: add simple map op cache

Jerin Jacob (1):
      arm64: bpf: optimize modulo operation

Kevin Laatz (13):
      i40e: simplify Rx buffer recycle
      ixgbe: simplify Rx buffer recycle
      xsk: add support to allow unaligned chunk placement
      i40e: modify driver for handling offsets
      ixgbe: modify driver for handling offsets
      mlx5e: modify driver for handling offsets
      libbpf: add flags to umem config
      samples/bpf: add unaligned chunks mode support to xdpsock
      samples/bpf: add buffer recycling for unaligned chunks to xdpsock
      samples/bpf: use hugepages in xdpsock app
      doc/af_xdp: include unaligned chunk case
      i40e: fix xdp handle calculations
      ixgbe: fix xdp handle calculations

Magnus Karlsson (6):
      xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
      xsk: add support for need_wakeup flag in AF_XDP rings
      i40e: add support for AF_XDP need_wakeup feature
      ixgbe: add support for AF_XDP need_wakeup feature
      libbpf: add support for need_wakeup flag in AF_XDP part
      samples/bpf: add use of need_wakeup flag in xdpsock

Masahiro Yamada (1):
      bpf: add include guard to tnum.h

Masanari Iida (1):
      selftests/bpf: Fix a typo in test_offload.py

Maxim Mikityanskiy (4):
      net/mlx5e: Move the SW XSK code from NAPI poll to a separate function
      net/mlx5e: Add AF_XDP need_wakeup support
      net: Don't call XDP_SETUP_PROG when nothing is changed
      net/mlx5e: Allow XSK frames smaller than a page

Nathan Chancellor (1):
      test_bpf: Fix a new clang warning about xor-ing two numbers

Petar Penkov (2):
      selftests/bpf: fix race in test_tcp_rtt test
      bpf: fix error check in bpf_tcp_gen_syncookie

Peter Wu (4):
      bpf: clarify description for CONFIG_BPF_EVENTS
      bpf: fix 'struct pt_reg' typo in documentation
      bpf: clarify when bpf_trace_printk discards lines
      bpf: sync bpf.h to tools/

Quentin Monnet (19):
      tools: bpftool: compile with $(EXTRA_WARNINGS)
      tools: bpftool: fix arguments for p_err() in do_event_pipe()
      tools: bpftool: fix format strings and arguments for jsonw_printf()
      tools: bpftool: fix argument for p_err() in BTF do_dump()
      tools: bpftool: fix format string for p_err() in query_flow_dissector()
      tools: bpftool: fix format string for p_err() in detect_common_prefix()
      tools: bpftool: move "__printf()" attributes to header file
      bpf: add BTF ids in procfs for file descriptors to BTF objects
      bpf: add new BPF_BTF_GET_NEXT_ID syscall command
      tools: bpf: synchronise BPF UAPI header with tools
      libbpf: refactor bpf_*_get_next_id() functions
      libbpf: add bpf_btf_get_next_id() to cycle through BTF objects
      tools: bpftool: implement "bpftool btf show|list"
      tools: bpftool: show frozen status for maps
      tools: bpftool: add "bpftool map freeze" subcommand
      tools: bpftool: ignore make built-in rules for getting kernel version
      tools: bpftool: improve and check builds for different make invocations
      tools: bpf: account for generated feature/ and libbpf/ directories
      tools: bpftool: do not link twice against libbpf.a in Makefile

Stanislav Fomichev (11):
      bpf: export bpf_map_inc_not_zero
      bpf: support cloning sk storage on accept()
      bpf: sync bpf.h to tools/
      selftests/bpf: add sockopt clone/inheritance test
      selftests/bpf: test_progs: test__skip
      selftests/bpf: test_progs: remove global fail/success counts
      selftests/bpf: test_progs: remove asserts from subtests
      selftests/bpf: test_progs: remove unused ret
      selftests/bpf: remove wrong nhoff in flow dissector test
      selftests/bpf: test_progs: fix verbose mode garbage
      selftests/bpf: test_progs: add missing to CHECK_FAIL

Wei Yongjun (1):
      btf: fix return value check in btf_vmlinux_init()

Yauheni Kaliuta (2):
      bpf: s390: add JIT support for multi-function programs
      bpf: s390: add JIT support for bpf line info

YueHaibing (1):
      bpf: Use PTR_ERR_OR_ZERO in xsk_map_inc()

 Documentation/networking/af_xdp.rst                |  10 +-
 arch/arm64/net/bpf_jit.h                           |   3 +
 arch/arm64/net/bpf_jit_comp.c                      |   6 +-
 arch/s390/net/bpf_jit_comp.c                       |  67 +++-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  52 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  49 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  23 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  14 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  27 +-
 drivers/net/ethernet/netronome/nfp/bpf/cmsg.c      | 187 ++++++++++-
 drivers/net/ethernet/netronome/nfp/bpf/fw.h        |   1 +
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |  33 ++
 drivers/net/ethernet/netronome/nfp/bpf/main.h      |  24 ++
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   3 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |   9 +-
 include/linux/bpf.h                                |   5 +
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/netdevice.h                          |  14 +-
 include/linux/tnum.h                               |   6 +
 include/net/bpf_sk_storage.h                       |  10 +
 include/net/xdp_sock.h                             | 122 ++++++-
 include/uapi/linux/bpf.h                           |  15 +-
 include/uapi/linux/if_xdp.h                        |  22 ++
 kernel/bpf/btf.c                                   |  16 +-
 kernel/bpf/syscall.c                               |  21 +-
 kernel/bpf/sysfs_btf.c                             |   9 +-
 kernel/bpf/verifier.c                              |   5 +-
 kernel/bpf/xskmap.c                                | 133 ++++++--
 kernel/trace/Kconfig                               |   3 +-
 lib/test_bpf.c                                     |   2 +-
 net/core/bpf_sk_storage.c                          | 104 +++++-
 net/core/dev.c                                     |  15 +-
 net/core/filter.c                                  |   2 +-
 net/core/sock.c                                    |   9 +-
 net/xdp/xdp_umem.c                                 |  67 +++-
 net/xdp/xsk.c                                      | 349 +++++++++++++++++----
 net/xdp/xsk.h                                      |  13 +
 net/xdp/xsk_diag.c                                 |   5 +-
 net/xdp/xsk_queue.h                                |  71 ++++-
 samples/bpf/syscall_nrs.c                          |   6 +
 samples/bpf/tracex5_kern.c                         |  13 +
 samples/bpf/xdpsock_user.c                         | 243 +++++++++-----
 scripts/link-vmlinux.sh                            |   6 +-
 tools/bpf/.gitignore                               |   1 +
 tools/bpf/Makefile                                 |   5 +-
 tools/bpf/bpftool/.gitignore                       |   2 +
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   7 +
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   9 +
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |  57 +++-
 tools/bpf/bpftool/Makefile                         |  31 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  89 +++++-
 tools/bpf/bpftool/btf.c                            | 344 +++++++++++++++++++-
 tools/bpf/bpftool/btf_dumper.c                     |   8 +-
 tools/bpf/bpftool/cgroup.c                         |   2 +-
 tools/bpf/bpftool/common.c                         |   4 +-
 tools/bpf/bpftool/json_writer.c                    |   6 +-
 tools/bpf/bpftool/json_writer.h                    |   6 +-
 tools/bpf/bpftool/main.c                           |   2 +-
 tools/bpf/bpftool/main.h                           |   4 +-
 tools/bpf/bpftool/map.c                            |  64 +++-
 tools/bpf/bpftool/map_perf_ring.c                  |   4 +-
 tools/bpf/bpftool/net.c                            | 178 ++++++++++-
 tools/bpf/bpftool/perf.c                           |   4 +
 tools/include/linux/compiler-gcc.h                 |   2 +
 tools/include/uapi/linux/bpf.h                     |  15 +-
 tools/include/uapi/linux/if_xdp.h                  |  22 ++
 tools/lib/bpf/Makefile                             |  26 +-
 tools/lib/bpf/bpf.c                                |  24 +-
 tools/lib/bpf/bpf.h                                |   1 +
 tools/lib/bpf/libbpf.map                           |   6 +
 tools/lib/bpf/xsk.c                                |  86 ++---
 tools/lib/bpf/xsk.h                                |  33 ++
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/Makefile               |   6 +-
 tools/testing/selftests/bpf/bpf_endian.h           |  16 +-
 tools/testing/selftests/bpf/bpf_helpers.h          |   2 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |  20 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   9 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   5 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   3 -
 .../testing/selftests/bpf/prog_tests/global_data.c |  20 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   9 +-
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |  38 +--
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |   4 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |   4 +-
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   8 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |   4 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |  43 ++-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |  16 +-
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   7 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   7 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |  17 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |   9 +-
 .../selftests/bpf/prog_tests/task_fd_query_rawtp.c |   3 -
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |   5 -
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |   4 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   4 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   8 +-
 .../testing/selftests/bpf/progs/sockopt_inherit.c  |  97 ++++++
 .../selftests/bpf/progs/test_lwt_seg6local.c       |  16 +-
 tools/testing/selftests/bpf/progs/test_seg6_loop.c |   8 +-
 tools/testing/selftests/bpf/test_bpftool_build.sh  | 143 +++++++++
 tools/testing/selftests/bpf/test_offload.py        |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |  42 ++-
 tools/testing/selftests/bpf/test_progs.h           |  19 +-
 tools/testing/selftests/bpf/test_sockopt_inherit.c | 253 +++++++++++++++
 tools/testing/selftests/bpf/test_sysctl.c          | 130 +++++---
 tools/testing/selftests/bpf/test_tcp_rtt.c         |  31 ++
 tools/testing/selftests/bpf/test_verifier.c        |  68 +++-
 tools/testing/selftests/bpf/verifier/precise.c     | 194 ++++++++++++
 124 files changed, 3489 insertions(+), 698 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_build.sh
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c
 create mode 100644 tools/testing/selftests/bpf/verifier/precise.c
