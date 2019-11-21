Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9364110473F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKUAFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:05:24 -0500
Received: from www62.your-server.de ([213.133.104.62]:44912 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUAFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:05:23 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXZyB-0006eh-DA; Thu, 21 Nov 2019 01:05:11 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-11-20
Date:   Thu, 21 Nov 2019 01:05:10 +0100
Message-Id: <20191121000510.18946-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25639/Wed Nov 20 11:02:53 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 81 non-merge commits during the last 17 day(s) which contain
a total of 120 files changed, 4958 insertions(+), 1081 deletions(-).

There are 3 trivial conflicts, resolve it by always taking the chunk from
196e8ca74886c433:

<<<<<<< HEAD
=======
void *bpf_map_area_mmapable_alloc(u64 size, int numa_node);
>>>>>>> 196e8ca74886c433dcfc64a809707074b936aaf5

<<<<<<< HEAD
void *bpf_map_area_alloc(u64 size, int numa_node)
=======
static void *__bpf_map_area_alloc(u64 size, int numa_node, bool mmapable)
>>>>>>> 196e8ca74886c433dcfc64a809707074b936aaf5

<<<<<<< HEAD
        if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
=======
        /* kmalloc()'ed memory can't be mmap()'ed */
        if (!mmapable && size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
>>>>>>> 196e8ca74886c433dcfc64a809707074b936aaf5

The main changes are:

1) Addition of BPF trampoline which works as a bridge between kernel functions,
   BPF programs and other BPF programs along with two new use cases: i) fentry/fexit
   BPF programs for tracing with practically zero overhead to call into BPF (as
   opposed to k[ret]probes) and ii) attachment of the former to networking related
   programs to see input/output of networking programs (covering xdpdump use case),
   from Alexei Starovoitov.

2) BPF array map mmap support and use in libbpf for global data maps; also a big
   batch of libbpf improvements, among others, support for reading bitfields in a
   relocatable manner (via libbpf's CO-RE helper API), from Andrii Nakryiko.

3) Extend s390x JIT with usage of relative long jumps and loads in order to lift
   the current 64/512k size limits on JITed BPF programs there, from Ilya Leoshkevich.

4) Add BPF audit support and emit messages upon successful prog load and unload in
   order to have a timeline of events, from Daniel Borkmann and Jiri Olsa.

5) Extension to libbpf and xdpsock sample programs to demo the shared umem mode
   (XDP_SHARED_UMEM) as well as RX-only and TX-only sockets, from Magnus Karlsson.

6) Several follow-up bug fixes for libbpf's auto-pinning code and a new API
   call named bpf_get_link_xdp_info() for retrieving the full set of prog
   IDs attached to XDP, from Toke Høiland-Jørgensen.

7) Add BTF support for array of int, array of struct and multidimensional arrays
   and enable it for skb->cb[] access in kfree_skb test, from Martin KaFai Lau.

8) Fix AF_XDP by using the correct number of channels from ethtool, from Luigi Rizzo.

9) Two fixes for BPF selftest to get rid of a hang in test_tc_tunnel and to avoid
   xdping to be run as standalone, from Jiri Benc.

10) Various BPF selftest fixes when run with latest LLVM trunk, from Yonghong Song.

11) Fix a memory leak in BPF fentry test run data, from Colin Ian King.

12) Various smaller misc cleanups and improvements mostly all over BPF selftests and
    samples, from Daniel T. Lee, Andre Guedes, Anders Roxell, Mao Wenan, Yue Haibing.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Alexei Starovoitov, Andrii Nakryiko, Daniel Bristot de 
Oliveira, David S. Miller, Hulk Robot, Jakub Kicinski, Johannes Weiner, 
John Fastabend, Jonathan Lemon, Magnus Karlsson, Masami Hiramatsu, Song 
Liu, Stephen Rothwell, Steven Rostedt (VMware), Toke Høiland-Jørgensen, 
Willem de Bruijn, William Tu, Yonghong Song

----------------------------------------------------------------

The following changes since commit 1574cf83c7a069f5f29295170ed8a568ccebcb7b:

  Merge tag 'mlx5-updates-2019-11-01' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2019-11-03 19:23:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 196e8ca74886c433dcfc64a809707074b936aaf5:

  bpf: Switch bpf_map_{area_alloc,area_mmapable_alloc}() to u64 size (2019-11-20 23:18:58 +0100)

----------------------------------------------------------------
Alexei Starovoitov (22):
      Merge branch 'map-pinning'
      Merge branch 'share-umem'
      bpf: Refactor x86 JIT into helpers
      bpf: Add bpf_arch_text_poke() helper
      bpf: Introduce BPF trampoline
      libbpf: Introduce btf__find_by_name_kind()
      libbpf: Add support to attach to fentry/fexit tracing progs
      selftest/bpf: Simple test for fentry/fexit
      bpf: Add kernel test functions for fentry testing
      selftests/bpf: Add test for BPF trampoline
      selftests/bpf: Add fexit tests for BPF trampoline
      selftests/bpf: Add combined fentry/fexit test
      selftests/bpf: Add stress test for maximum number of progs
      bpf: Reserve space for BPF trampoline in BPF programs
      bpf: Fix race in btf_resolve_helper_id()
      bpf: Annotate context types
      bpf: Compare BTF types of functions arguments with actual types
      bpf: Support attaching tracing BPF program to other BPF programs
      libbpf: Add support for attaching BPF programs to other BPF programs
      selftests/bpf: Extend test_pkt_access test
      selftests/bpf: Add a test for attaching BPF prog to another BPF prog and subprog
      Merge branch 'remove-jited-size-limits'

Anders Roxell (1):
      bpf, testing: Add missing object file to TEST_FILES

Andre Guedes (2):
      samples/bpf: Remove duplicate option from xdpsock
      samples/bpf: Add missing option to xdpsock usage

Andrii Nakryiko (20):
      selftests/bpf: Remove too strict field offset relo test cases
      libbpf: Add support for relocatable bitfields
      libbpf: Add support for field size relocations
      selftest/bpf: Add relocatable bitfield reading tests
      selftests/bpf: Add field size relocation tests
      selftests/bps: Clean up removed ints relocations negative tests
      libbpf: Simplify BPF_CORE_READ_BITFIELD_PROBED usage
      libbpf: Fix negative FD close() in xsk_setup_xdp_prog()
      libbpf: Fix memory leak/double free issue
      libbpf: Fix potential overflow issue
      libbpf: Fix another potential overflow issue in bpf_prog_linfo
      libbpf: Make btf__resolve_size logic always check size error condition
      libbpf: Improve handling of corrupted ELF during map initialization
      bpf: Switch bpf_map ref counter to atomic64_t so bpf_map_inc() never fails
      bpf: Convert bpf_prog refcnt to atomic64_t
      bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY
      libbpf: Make global data internal arrays mmap()-able, if possible
      selftests/bpf: Add BPF_TYPE_MAP_ARRAY mmap() tests
      libbpf: Fix call relocation offset calculation bug
      selftests/bpf: Enforce no-ALU32 for test_progs-no_alu32

Colin Ian King (1):
      bpf: Fix memory leak on object 'data'

Daniel Borkmann (6):
      Merge branch 'bpf-libbpf-bitfield-size-relo'
      Merge branch 'bpf-libbpf-fixes'
      Merge branch 'bpf-trampoline'
      Merge branch 'bpf-array-mmap'
      bpf: Emit audit messages upon successful prog load and unload
      bpf: Switch bpf_map_{area_alloc,area_mmapable_alloc}() to u64 size

Daniel T. Lee (2):
      samples: bpf: Update outdated error message
      samples: bpf: update map definition to new syntax BTF-defined map

Ilya Leoshkevich (12):
      tools, bpf_asm: Warn when jumps are out of range
      s390/bpf: Use kvcalloc for addrs array
      s390/bpf: Wrap JIT macro parameter usages in parentheses
      s390/bpf: Remove unused SEEN_RET0, SEEN_REG_AX and ret0_ip
      bpf: Support doubleword alignment in bpf_jit_binary_alloc
      s390/bpf: Make sure JIT passes do not increase code size
      s390/bpf: Use relative long branches
      s390/bpf: Align literal pool entries
      s390/bpf: Load literal pool register using larl
      s390/bpf: Use lgrl instead of lg where possible
      s390/bpf: Use lg(f)rl when long displacement cannot be used
      s390/bpf: Remove JITed image size limitations

Jiri Benc (2):
      selftests, bpf: xdping is not meant to be run standalone
      selftests, bpf: Fix test_tc_tunnel hanging

Luigi Rizzo (1):
      net-af_xdp: Use correct number of channels from ethtool

Magnus Karlsson (5):
      libbpf: Support XDP_SHARED_UMEM with external XDP program
      samples/bpf: Add XDP_SHARED_UMEM support to xdpsock
      libbpf: Allow for creating Rx or Tx only AF_XDP sockets
      samples/bpf: Use Rx-only and Tx-only sockets in xdpsock
      xsk: Extend documentation for Rx|Tx-only sockets and shared umems

Mao Wenan (1):
      bpf, doc: Change right arguments for JIT example code

Martin KaFai Lau (3):
      bpf: Account for insn->off when doing bpf_probe_read_kernel
      bpf: Add array support to btf_struct_access
      bpf: Add cb access in kfree_skb test

Peter Zijlstra (1):
      x86/alternatives: Teach text_poke_bp() to emulate instructions

Toke Høiland-Jørgensen (6):
      libbpf: Unpin auto-pinned maps if loading fails
      selftests/bpf: Add tests for automatic map unpinning on load failure
      libbpf: Propagate EPERM to caller on program load
      libbpf: Use pr_warn() when printing netlink errors
      libbpf: Add bpf_get_link_xdp_info() function to get more XDP information
      libbpf: Add getter for program size

Yonghong Song (2):
      bpf, testing: Workaround a verifier failure for test_progs
      selftests, bpf: Workaround an alu32 sub-register spilling issue

YueHaibing (1):
      bpf: Make array_map_mmap static

 Documentation/networking/af_xdp.rst                |  28 +-
 Documentation/networking/filter.txt                |   8 +-
 arch/s390/net/bpf_jit_comp.c                       | 502 +++++++++++++-----
 arch/x86/include/asm/text-patching.h               |  24 +-
 arch/x86/kernel/alternative.c                      | 132 +++--
 arch/x86/kernel/jump_label.c                       |   9 +-
 arch/x86/kernel/kprobes/opt.c                      |  11 +-
 arch/x86/net/bpf_jit_comp.c                        | 424 +++++++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   9 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   9 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 +-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   8 +-
 drivers/net/virtio_net.c                           |   7 +-
 include/linux/audit.h                              |   3 +
 include/linux/bpf.h                                | 176 ++++++-
 include/linux/bpf_types.h                          |  78 ++-
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/btf.h                                |   1 +
 include/linux/filter.h                             |   6 +-
 include/linux/vmalloc.h                            |   1 +
 include/uapi/linux/audit.h                         |   1 +
 include/uapi/linux/bpf.h                           |   6 +
 kernel/auditsc.c                                   |   2 +-
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/arraymap.c                              |  58 ++-
 kernel/bpf/btf.c                                   | 558 +++++++++++++++++++--
 kernel/bpf/core.c                                  |  15 +-
 kernel/bpf/inode.c                                 |   7 +-
 kernel/bpf/map_in_map.c                            |   2 +-
 kernel/bpf/syscall.c                               | 287 ++++++++---
 kernel/bpf/trampoline.c                            | 253 ++++++++++
 kernel/bpf/verifier.c                              | 137 ++++-
 kernel/bpf/xskmap.c                                |   6 +-
 kernel/events/core.c                               |   7 +-
 mm/vmalloc.c                                       |  20 +
 net/bpf/test_run.c                                 |  43 ++
 net/core/bpf_sk_storage.c                          |   2 +-
 net/core/filter.c                                  |  12 +-
 samples/bpf/Makefile                               |   1 +
 samples/bpf/hbm.c                                  |   2 +-
 samples/bpf/sockex1_kern.c                         |  12 +-
 samples/bpf/sockex2_kern.c                         |  12 +-
 samples/bpf/xdp1_kern.c                            |  12 +-
 samples/bpf/xdp1_user.c                            |   2 +-
 samples/bpf/xdp2_kern.c                            |  12 +-
 samples/bpf/xdp_adjust_tail_kern.c                 |  12 +-
 samples/bpf/xdp_fwd_kern.c                         |  13 +-
 samples/bpf/xdp_redirect_cpu_kern.c                | 108 ++--
 samples/bpf/xdp_redirect_kern.c                    |  24 +-
 samples/bpf/xdp_redirect_map_kern.c                |  24 +-
 samples/bpf/xdp_router_ipv4_kern.c                 |  64 +--
 samples/bpf/xdp_rxq_info_kern.c                    |  37 +-
 samples/bpf/xdp_rxq_info_user.c                    |   6 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   2 +-
 samples/bpf/xdp_tx_iptunnel_kern.c                 |  26 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |   2 +-
 samples/bpf/xdpsock.h                              |  11 +
 samples/bpf/xdpsock_kern.c                         |  24 +
 samples/bpf/xdpsock_user.c                         | 161 ++++--
 tools/bpf/bpf_exp.y                                |  14 +-
 tools/include/uapi/linux/bpf.h                     |   6 +
 tools/lib/bpf/bpf.c                                |  10 +-
 tools/lib/bpf/bpf.h                                |   5 +-
 tools/lib/bpf/bpf_core_read.h                      |  74 +++
 tools/lib/bpf/bpf_helpers.h                        |  13 +
 tools/lib/bpf/bpf_prog_linfo.c                     |  14 +-
 tools/lib/bpf/btf.c                                |  25 +-
 tools/lib/bpf/btf.h                                |   2 +
 tools/lib/bpf/libbpf.c                             | 484 +++++++++++++-----
 tools/lib/bpf/libbpf.h                             |  20 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/libbpf_internal.h                    |   4 +
 tools/lib/bpf/netlink.c                            |  87 ++--
 tools/lib/bpf/nlattr.c                             |  10 +-
 tools/lib/bpf/xsk.c                                |  45 +-
 tools/testing/selftests/bpf/Makefile               |  14 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  | 174 +++++--
 .../selftests/bpf/prog_tests/fentry_fexit.c        |  90 ++++
 .../testing/selftests/bpf/prog_tests/fentry_test.c |  64 +++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  76 +++
 .../selftests/bpf/prog_tests/fexit_stress.c        |  76 +++
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |  64 +++
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |  93 +++-
 tools/testing/selftests/bpf/prog_tests/mmap.c      | 220 ++++++++
 tools/testing/selftests/bpf/prog_tests/pinning.c   |  20 +-
 .../btf__core_reloc_arrays___err_wrong_val_type.c  |   3 +
 .../btf__core_reloc_arrays___err_wrong_val_type1.c |   3 -
 .../btf__core_reloc_arrays___err_wrong_val_type2.c |   3 -
 .../bpf/progs/btf__core_reloc_bitfields.c          |   3 +
 .../btf__core_reloc_bitfields___bit_sz_change.c    |   3 +
 .../btf__core_reloc_bitfields___bitfield_vs_int.c  |   3 +
 ...__core_reloc_bitfields___err_too_big_bitfield.c |   3 +
 .../btf__core_reloc_bitfields___just_big_enough.c  |   3 +
 .../progs/btf__core_reloc_ints___err_bitfield.c    |   3 -
 .../progs/btf__core_reloc_ints___err_wrong_sz_16.c |   3 -
 .../progs/btf__core_reloc_ints___err_wrong_sz_32.c |   3 -
 .../progs/btf__core_reloc_ints___err_wrong_sz_64.c |   3 -
 .../progs/btf__core_reloc_ints___err_wrong_sz_8.c  |   3 -
 .../selftests/bpf/progs/btf__core_reloc_size.c     |   3 +
 .../bpf/progs/btf__core_reloc_size___diff_sz.c     |   3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h | 173 ++++---
 tools/testing/selftests/bpf/progs/fentry_test.c    |  90 ++++
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |  91 ++++
 tools/testing/selftests/bpf/progs/fexit_test.c     |  98 ++++
 tools/testing/selftests/bpf/progs/kfree_skb.c      |  77 ++-
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   4 +-
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   4 +-
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |   4 +-
 .../bpf/progs/test_core_reloc_bitfields_direct.c   |  63 +++
 .../bpf/progs/test_core_reloc_bitfields_probed.c   |  57 +++
 .../selftests/bpf/progs/test_core_reloc_size.c     |  51 ++
 tools/testing/selftests/bpf/progs/test_mmap.c      |  45 ++
 tools/testing/selftests/bpf/progs/test_pinning.c   |   2 +-
 .../testing/selftests/bpf/progs/test_pkt_access.c  |  38 +-
 tools/testing/selftests/bpf/progs/test_seg6_loop.c |   4 +-
 .../selftests/bpf/progs/test_sysctl_loop1.c        |   5 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   5 +
 120 files changed, 4958 insertions(+), 1081 deletions(-)
 create mode 100644 kernel/bpf/trampoline.c
 create mode 100644 samples/bpf/xdpsock.h
 create mode 100644 samples/bpf/xdpsock_kern.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_stress.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_size.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_mmap.c
