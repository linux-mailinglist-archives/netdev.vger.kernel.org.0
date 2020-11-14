Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321EE2B2AC4
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgKNCIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:08:25 -0500
Received: from www62.your-server.de ([213.133.104.62]:38826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKNCIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 21:08:24 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdkzE-0005ah-3b; Sat, 14 Nov 2020 03:08:20 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-11-14
Date:   Sat, 14 Nov 2020 03:08:19 +0100
Message-Id: <20201114020819.29584-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25987/Fri Nov 13 14:19:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 66 non-merge commits during the last 22 day(s) which contain
a total of 83 files changed, 3908 insertions(+), 1271 deletions(-).

The main changes are:

1) Add BTF generation for kernel modules and extend BTF infra in kernel
   e.g. support for split BTF loading and validation, from Andrii Nakryiko.

2) Support for pointers beyond pkt_end to recognize LLVM generated patterns
   on inlined branch conditions, from Alexei Starovoitov.

3) Implements bpf_local_storage for task_struct for BPF LSM, from KP Singh.

4) Enable FENTRY/FEXIT/RAW_TP tracing program to use the bpf_sk_storage
   infra, from Martin KaFai Lau.

5) Add XDP bulk APIs that introduce a defer/flush mechanism to optimize the
   XDP_REDIRECT path, from Lorenzo Bianconi.

6) Fix a potential (although rather theoretical) deadlock of hashtab in NMI
   context, from Song Liu.

7) Fixes for cross and out-of-tree build of bpftool and runqslower allowing build
   for different target archs on same source tree, from Jean-Philippe Brucker.

8) Fix error path in htab_map_alloc() triggered from syzbot, from Eric Dumazet.

9) Move functionality from test_tcpbpf_user into the test_progs framework so it
   can run in BPF CI, from Alexander Duyck.

10) Lift hashtab key_size limit to be larger than MAX_BPF_STACK, from Florian Lehner.

Note that for the fix from Song we have seen a sparse report on context
imbalance which requires changes in sparse itself for proper annotation
detection where this is currently being discussed on linux-sparse among
developers [0]. Once we have more clarification/guidance after their fix,
Song will follow-up.

  [0] https://lore.kernel.org/linux-sparse/CAHk-=wh4bx8A8dHnX612MsDO13st6uzAz1mJ1PaHHVevJx_ZCw@mail.gmail.com/T/
      https://lore.kernel.org/linux-sparse/20201109221345.uklbp3lzgq6g42zb@ltop.local/T/

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Greg Kroah-Hartman, Ilias Apalodimas, 
Jesper Dangaard Brouer, Jiri Olsa, John Fastabend, KP Singh, Martin 
KaFai Lau, Matteo Croce, Rafael J. Wysocki, Roman Gushchin, Sergei 
Iudin, Song Liu, Stephen Rothwell, syzbot, Yonghong Song

----------------------------------------------------------------

The following changes since commit 3cb12d27ff655e57e8efe3486dca2a22f4e30578:

  Merge tag 'net-5.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-10-23 12:05:49 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to c14d61fca0d10498bf267c0ab1f381dd0b35d96b:

  Merge branch 'xdp-redirect-bulk' (2020-11-14 02:30:03 +0100)

----------------------------------------------------------------
Alexander Duyck (5):
      selftests/bpf: Move test_tcppbf_user into test_progs
      selftests/bpf: Drop python client/server in favor of threads
      selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
      selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
      selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern

Alexei Starovoitov (10):
      Merge branch 'bpf: safeguard hashtab locking in NMI context'
      Merge branch 'selftests/bpf: Migrate test_tcpbpf_user to be a part of test_progs'
      Merge branch 'libbpf: split BTF support'
      selftests/bpf: Fix selftest build with old libc
      Merge branch 'Integrate kernel module BTF support'
      Merge branch 'Remove unused test_ipip.sh test and add missed'
      bpf: Support for pointers beyond pkt_end.
      selftests/bpf: Add skb_pkt_end test
      selftests/bpf: Add asm tests for pkt vs pkt_end comparison.
      Merge branch 'bpf: Enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP'

Andrii Nakryiko (18):
      libbpf: Factor out common operations in BTF writing APIs
      selftest/bpf: Relax btf_dedup test checks
      libbpf: Unify and speed up BTF string deduplication
      libbpf: Implement basic split BTF support
      selftests/bpf: Add split BTF basic test
      selftests/bpf: Add checking of raw type dump in BTF writer APIs selftests
      libbpf: Fix BTF data layout checks and allow empty BTF
      libbpf: Support BTF dedup of split BTFs
      libbpf: Accomodate DWARF/compiler bug with duplicated identical arrays
      selftests/bpf: Add split BTF dedup selftests
      tools/bpftool: Add bpftool support for split BTF
      bpf: Add in-kernel split BTF support
      bpf: Assign ID to vmlinux BTF and return extra info for BTF in GET_OBJ_INFO
      kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it
      bpf: Load and verify kernel module BTFs
      tools/bpftool: Add support for in-kernel and named BTF in `btf show`
      bpf: Compile out btf_parse_module() if module BTF is not enabled
      Merge branch 'tools/bpftool: Some build fixes'

Daniel Borkmann (2):
      Merge branch 'bpf-ptrs-beyond-pkt-end'
      Merge branch 'xdp-redirect-bulk'

Eric Dumazet (1):
      bpf: Fix error path in htab_map_alloc()

Florian Lehner (1):
      bpf: Lift hashtab key_size limit

Hangbin Liu (2):
      selftest/bpf: Add missed ip6ip6 test back
      samples/bpf: Remove unused test_ipip.sh

Jean-Philippe Brucker (9):
      tools: Factor HOSTCC, HOSTLD, HOSTAR definitions
      tools/bpftool: Force clean of out-of-tree build
      tools/bpftool: Fix cross-build
      tools/runqslower: Use Makefile.include
      tools/runqslower: Enable out-of-tree build
      tools/runqslower: Build bpftool using HOSTCC
      tools/bpftool: Fix build slowdown
      tools/bpf: Add bootstrap/ to .gitignore
      tools/bpf: Always run the *-clean recipes

KP Singh (11):
      bpf: Allow LSM programs to use bpf spin locks
      bpf: Implement task local storage
      libbpf: Add support for task local storage
      bpftool: Add support for task local storage
      bpf: Implement get_current_task_btf and RET_PTR_TO_BTF_ID
      bpf: Fix tests for local_storage
      bpf: Update selftests for local_storage to use vmlinux.h
      bpf: Add tests for task_local_storage
      bpf: Exercise syscall operations for inode and sk storage
      bpf: Augment the set of sleepable LSM hooks
      bpf: Expose bpf_d_path helper to sleepable LSM hooks

Lorenzo Bianconi (5):
      net: xdp: Introduce bulking for xdp tx return path
      net: page_pool: Add bulk support for ptr_ring
      net: mvneta: Add xdp tx return bulking support
      net: mvpp2: Add xdp tx return bulking support
      net: mlx5: Add xdp tx return bulking support

Martin KaFai Lau (6):
      bpf: selftest: Use static globals in tcp_hdr_options and btf_skc_cls_ingress
      bpf: Fix NULL dereference in bpf_task_storage
      bpf: Folding omem_charge() into sk_storage_charge()
      bpf: Rename some functions in bpf_sk_storage
      bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
      bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP

Menglong Dong (1):
      samples/bpf: Remove duplicate include in hbm

Song Liu (2):
      bpf: Use separate lockdep class for each hashtab
      bpf: Avoid hashtab deadlock with map_locked

Wang Qing (1):
      bpf, btf: Remove the duplicate btf_ids.h include

Yonghong Song (1):
      bpf: Permit cond_resched for some iterators

 Documentation/ABI/testing/sysfs-kernel-btf         |   8 +
 drivers/net/ethernet/marvell/mvneta.c              |  10 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  22 +-
 include/linux/bpf.h                                |   8 +
 include/linux/bpf_lsm.h                            |  30 +
 include/linux/bpf_types.h                          |   1 +
 include/linux/bpf_verifier.h                       |   2 +-
 include/linux/module.h                             |   4 +
 include/net/bpf_sk_storage.h                       |   2 +
 include/net/page_pool.h                            |  26 +
 include/net/xdp.h                                  |  17 +-
 include/uapi/linux/bpf.h                           |  51 ++
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/bpf_iter.c                              |  14 +
 kernel/bpf/bpf_lsm.c                               |  89 +++
 kernel/bpf/bpf_task_storage.c                      | 315 ++++++++
 kernel/bpf/btf.c                                   | 411 +++++++++--
 kernel/bpf/hashtab.c                               | 144 ++--
 kernel/bpf/syscall.c                               |   3 +-
 kernel/bpf/sysfs_btf.c                             |   2 +-
 kernel/bpf/task_iter.c                             |   2 +
 kernel/bpf/verifier.c                              | 182 +++--
 kernel/module.c                                    |  32 +
 kernel/trace/bpf_trace.c                           |  29 +-
 lib/Kconfig.debug                                  |   9 +
 net/core/bpf_sk_storage.c                          | 135 +++-
 net/core/page_pool.c                               |  70 +-
 net/core/xdp.c                                     |  54 ++
 samples/bpf/hbm.c                                  |   1 -
 samples/bpf/test_ipip.sh                           | 179 -----
 scripts/Makefile.modfinal                          |  20 +-
 security/bpf/hooks.c                               |   2 +
 tools/bpf/bpftool/.gitignore                       |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   3 +-
 tools/bpf/bpftool/Makefile                         |  44 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   2 +-
 tools/bpf/bpftool/btf.c                            |  37 +-
 tools/bpf/bpftool/main.c                           |  15 +-
 tools/bpf/bpftool/main.h                           |   1 +
 tools/bpf/bpftool/map.c                            |   4 +-
 tools/bpf/resolve_btfids/Makefile                  |   9 -
 tools/bpf/runqslower/Makefile                      |  55 +-
 tools/build/Makefile                               |   4 -
 tools/include/uapi/linux/bpf.h                     |  51 ++
 tools/lib/bpf/btf.c                                | 807 ++++++++++++---------
 tools/lib/bpf/btf.h                                |   8 +
 tools/lib/bpf/libbpf.map                           |   9 +
 tools/lib/bpf/libbpf_probes.c                      |   1 +
 tools/objtool/Makefile                             |   9 -
 tools/perf/Makefile.perf                           |   4 -
 tools/power/acpi/Makefile.config                   |   1 -
 tools/scripts/Makefile.include                     |  10 +
 tools/testing/selftests/bpf/.gitignore             |   1 -
 tools/testing/selftests/bpf/Makefile               |   5 +-
 tools/testing/selftests/bpf/btf_helpers.c          | 259 +++++++
 tools/testing/selftests/bpf/btf_helpers.h          |  19 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |  40 +-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     | 325 +++++++++
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |  99 +++
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  43 ++
 .../selftests/bpf/prog_tests/hash_large_key.c      |  43 ++
 .../selftests/bpf/prog_tests/sk_storage_tracing.c  | 135 ++++
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  12 +-
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c | 141 ++++
 .../selftests/bpf/prog_tests/test_local_storage.c  | 204 +++++-
 .../selftests/bpf/prog_tests/test_skb_pkt_end.c    |  41 ++
 tools/testing/selftests/bpf/progs/local_storage.c  | 103 ++-
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |  54 ++
 .../selftests/bpf/progs/test_hash_large_key.c      |  44 ++
 .../bpf/progs/test_sk_storage_trace_itself.c       |  29 +
 .../selftests/bpf/progs/test_sk_storage_tracing.c  |  95 +++
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  86 +--
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  42 +-
 tools/testing/selftests/bpf/tcp_client.py          |  50 --
 tools/testing/selftests/bpf/tcp_server.py          |  80 --
 tools/testing/selftests/bpf/test_maps.c            |   3 +-
 tools/testing/selftests/bpf/test_progs.h           |  11 +
 tools/testing/selftests/bpf/test_tcpbpf.h          |   2 +
 tools/testing/selftests/bpf/test_tcpbpf_user.c     | 165 -----
 tools/testing/selftests/bpf/test_tunnel.sh         |  43 +-
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |  42 ++
 83 files changed, 3908 insertions(+), 1271 deletions(-)
 create mode 100644 kernel/bpf/bpf_task_storage.c
 delete mode 100755 samples/bpf/test_ipip.sh
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.c
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_split.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_trace_itself.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
 delete mode 100644 tools/testing/selftests/bpf/test_tcpbpf_user.c
