Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F4C31C488
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 01:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhBPAQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 19:16:03 -0500
Received: from www62.your-server.de ([213.133.104.62]:57268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPAQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 19:16:01 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lBo1M-0003IX-Na; Tue, 16 Feb 2021 01:15:16 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, sdf@google.com, arjunroy@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-02-16
Date:   Tue, 16 Feb 2021 01:15:16 +0100
Message-Id: <20210216001516.3248-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26081/Mon Feb 15 13:19:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

There's a small merge conflict between 7eeba1706eba ("tcp: Add receive timestamp
support for receive zerocopy.") from net-next tree and 9cacf81f8161 ("bpf: Remove
extra lock_sock for TCP_ZEROCOPY_RECEIVE") from bpf-next tree. Resolve as follows:

  [...]
                lock_sock(sk);
                err = tcp_zerocopy_receive(sk, &zc, &tss);
                err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
                                                          &zc, &len, err);
                release_sock(sk);
  [...]

We've added 116 non-merge commits during the last 27 day(s) which contain
a total of 156 files changed, 5662 insertions(+), 1489 deletions(-).

The main changes are:

1) Adds support of pointers to types with known size among global function
   args to overcome the limit on max # of allowed args, from Dmitrii Banshchikov.

2) Add bpf_iter for task_vma which can be used to generate information similar
   to /proc/pid/maps, from Song Liu.

3) Enable bpf_{g,s}etsockopt() from all sock_addr related program hooks. Allow
   rewriting bind user ports from BPF side below the ip_unprivileged_port_start
   range, both from Stanislav Fomichev.

4) Prevent recursion on fentry/fexit & sleepable programs and allow map-in-map
   as well as per-cpu maps for the latter, from Alexei Starovoitov.

5) Add selftest script to run BPF CI locally. Also enable BPF ringbuffer
   for sleepable programs, both from KP Singh.

6) Extend verifier to enable variable offset read/write access to the BPF
   program stack, from Andrei Matei.

7) Improve tc & XDP MTU handling and add a new bpf_check_mtu() helper to
   query device MTU from programs, from Jesper Dangaard Brouer.

8) Allow bpf_get_socket_cookie() helper also be called from [sleepable] BPF
   tracing programs, from Florent Revest.

9) Extend x86 JIT to pad JMPs with NOPs for helping image to converge when
   otherwise too many passes are required, from Gary Lin.

10) Verifier fixes on atomics with BPF_FETCH as well as function-by-function
    verification both related to zero-extension handling, from Ilya Leoshkevich.

11) Better kernel build integration of resolve_btfids tool, from Jiri Olsa.

12) Batch of AF_XDP selftest cleanups and small performance improvement
    for libbpf's xsk map redirect for newer kernels, from Björn Töpel.

13) Follow-up BPF doc and verifier improvements around atomics with
    BPF_FETCH, from Brendan Jackman.

14) Permit zero-sized data sections e.g. if ELF .rodata section contains
    read-only data from local variables, from Yonghong Song.

15) veth driver skb bulk-allocation for ndo_xdp_xmit, from Lorenzo Bianconi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Andrey Ignatov, Andrii Nakryiko, Björn Töpel, Brendan 
Jackman, Carlo Carraro, Dan Carpenter, Daniel Borkmann, Ilya 
Leoshkevich, Jesper Dangaard Brouer, Jiri Olsa, John Fastabend, kernel 
test robot, KP Singh, Lukas Bulwahn, Maciej Fijalkowski, Martin KaFai 
Lau, Nathan Chancellor, Randy Dunlap, Song Liu, Toshiaki Makita, Yauheni 
Kaliuta, Yonghong Song

----------------------------------------------------------------

The following changes since commit 0fe2f273ab892bbba3f8d85e3f237bc0802e5709:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-01-20 12:16:11 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 45159b27637b0fef6d5ddb86fc7c46b13c77960f:

  bpf: Clear subreg_def for global function return values (2021-02-15 23:39:35 +0100)

----------------------------------------------------------------
Alexei Starovoitov (17):
      Merge branch 'bpf,x64: implement jump padding in jit'
      Merge branch 'Allow attaching to bare tracepoints'
      Merge branch 'bpf: misc performance improvements for cgroup'
      bpf: Emit explicit NULL pointer checks for PROBE_LDX instructions.
      Merge branch 'allow variable-offset stack acces'
      bpf: Optimize program stats
      bpf: Run sleepable programs with migration disabled
      bpf: Compute program stats for sleepable programs
      bpf: Add per-program recursion prevention mechanism
      selftest/bpf: Add a recursion test
      bpf: Count the number of times recursion was prevented
      selftests/bpf: Improve recursion selftest
      bpf: Allows per-cpu maps and map-in-map in sleepable programs
      selftests/bpf: Add a test for map-in-map and per-cpu maps in sleepable progs
      bpf: Clear per_cpu pointers during bpf_prog_realloc
      Merge branch 'introduce bpf_iter for task_vma'
      Merge branch 'Add support of pointer to struct in global'

Andrei Matei (5):
      selftest/bpf: Testing for multiple logs on REJECT
      bpf: Allow variable-offset stack access
      selftest/bpf: Adjust expected verifier errors
      selftest/bpf: Verifier tests for var-off access
      selftest/bpf: Add test for var-offset stack access

Andrii Nakryiko (5):
      selftests/bpf: Don't exit on failed bpf_testmod unload
      libbpf: Stop using feature-detection Makefiles
      Merge branch 'BPF selftest helper script'
      Merge branch 'BPF ring buffer + sleepable programs'
      Merge branch 'kbuild/resolve_btfids: Invoke resolve_btfids'

Björn Töpel (16):
      samples/bpf: Add BPF_ATOMIC_OP macro for BPF samples
      xsk: Remove explicit_free parameter from __xsk_rcv()
      xsk: Fold xp_assign_dev and __xp_assign_dev
      libbpf, xsk: Select AF_XDP BPF program based on kernel version
      selftests/bpf: Remove a lot of ifobject casting
      selftests/bpf: Remove unused enums
      selftests/bpf: Fix style warnings
      selftests/bpf: Remove memory leak
      selftests/bpf: Improve readability of xdpxceiver/worker_pkt_validate()
      selftests/bpf: Remove casting by introduce local variable
      selftests/bpf: Change type from void * to struct ifaceconfigobj *
      selftests/bpf: Change type from void * to struct generic_data *
      selftests/bpf: Define local variables at the beginning of a block
      selftests/bpf: Avoid heap allocation
      selftests/bpf: Consistent malloc/calloc usage
      selftests/bpf: Avoid useless void *-casts

Brendan Jackman (4):
      docs: bpf: Fixup atomics markup
      docs: bpf: Clarify -mcpu=v3 requirement for atomic ops
      bpf: Propagate stack bounds to registers in atomics w/ BPF_FETCH
      selftests/bpf: Add missing cleanup in atomic_bounds test

Carlos Neira (1):
      bpf, selftests: Fold test_current_pid_tgid_new_ns into test_progs.

Cong Wang (1):
      skmsg: Make sk_psock_destroy() static

Dmitrii Banshchikov (4):
      bpf: Rename bpf_reg_state variables
      bpf: Extract nullable reg type conversion into a helper function
      bpf: Support pointers in global func args
      selftests/bpf: Add unit tests for pointers in global functions

Florent Revest (5):
      bpf: Be less specific about socket cookies guarantees
      bpf: Expose bpf_get_socket_cookie to tracing programs
      selftests/bpf: Integrate the socket_cookie test to test_progs
      selftests/bpf: Use vmlinux.h in socket_cookie_prog.c
      selftests/bpf: Add a selftest for the tracing bpf_get_socket_cookie

Florian Lehner (1):
      tools, headers: Sync struct bpf_perf_event_data

Gary Lin (3):
      bpf,x64: Pad NOPs to make images converge more easily
      test_bpf: Remove EXPECTED_FAIL flag from bpf_fill_maxinsns11
      selftests/bpf: Add verifier tests for x64 jit jump padding

Hangbin Liu (1):
      samples/bpf: Add xdp program on egress for xdp_redirect_map

Ilya Leoshkevich (4):
      selftests/bpf: Fix endianness issues in atomic tests
      docs: bpf: Clarify BPF_CMPXCHG wording
      bpf: Fix subreg optimization for BPF_FETCH
      bpf: Clear subreg_def for global function return values

Jesper Dangaard Brouer (7):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: Fix bpf_fib_lookup helper MTU check for SKB ctx
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: Add BPF-helper for MTU checking
      bpf: Drop MTU check when doing TC-BPF redirect to ingress
      selftests/bpf: Use bpf_check_mtu in selftest test_cls_redirect
      selftests/bpf: Tests using bpf_check_mtu BPF-helper

Jiapeng Chong (2):
      bpf: Simplify bool comparison
      selftests/bpf: Simplify the calculation of variables

Jiri Olsa (6):
      libbpf: Use string table index from index table if needed
      tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
      tools/resolve_btfids: Check objects before removing
      tools/resolve_btfids: Set srctree variable unconditionally
      kbuild: Add resolve_btfids clean to root clean target
      kbuild: Do not clean resolve_btfids if the output does not exist

Jun'ichi Nomura (1):
      bpf, devmap: Use GFP_KERNEL for xdp bulk queue allocation

Junlin Yang (1):
      selftest/bpf: Fix typo

KP Singh (5):
      selftests/bpf: Fix a compiler warning in local_storage test
      bpf: Helper script for running BPF presubmit tests
      bpf/selftests: Add a short note about vmtest.sh in README.rst
      bpf: Allow usage of BPF ringbuffer in sleepable programs
      bpf/selftests: Update the IMA test to use BPF ring buffer

Lorenzo Bianconi (3):
      net, xdp: Introduce __xdp_build_skb_from_frame utility routine
      net, xdp: Introduce xdp_build_skb_from_frame utility routine
      net, veth: Alloc skb in bulk for ndo_xdp_xmit

Lukas Bulwahn (1):
      docs, bpf: Add minimal markup to address doc warning

Marco Elver (1):
      bpf_lru_list: Read double-checked variable once without lock

Martin KaFai Lau (2):
      libbpf: Ignore non function pointer member in struct_ops
      bpf: selftests: Add non function pointer test to struct_ops

Menglong Dong (1):
      bpf: Change 'BPF_ADD' to 'BPF_AND' in print_bpf_insn()

Qais Yousef (2):
      trace: bpf: Allow bpf to attach to bare tracepoints
      selftests: bpf: Add a new test for bare tracepoints

Sedat Dilek (1):
      tools: Factor Clang, LLC and LLVM utils definitions

Song Liu (3):
      bpf: Introduce task_vma bpf_iter
      bpf: Allow bpf_d_path in bpf_iter program
      selftests/bpf: Add test for bpf_iter_task_vma

Stanislav Fomichev (11):
      bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
      bpf: Try to avoid kzalloc in cgroup/{s,g}etsockopt
      bpf: Split cgroup_bpf_enabled per attach type
      bpf: Allow rewriting to ports under ip_unprivileged_port_start
      selftests/bpf: Verify that rebinding to port < 1024 from BPF works
      bpf: Enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
      bpf: Enable bpf_{g,s}etsockopt in BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME
      selftests/bpf: Rewrite recvmsg{4,6} asm progs to c in test_sock_addr
      bpf: Enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_RECVMSG
      libbpf: Use AF_LOCAL instead of AF_INET in xsk.c
      tools/resolve_btfids: Add /libbpf to .gitignore

Tiezhu Yang (3):
      bpf, docs: Update build procedure for manually compiling LLVM and Clang
      samples/bpf: Set flag __SANE_USERSPACE_TYPES__ for MIPS to fix build warnings
      samples/bpf: Add include dir for MIPS Loongson64 to fix build errors

Tobias Klauser (2):
      bpf: Fix typo in scalar{,32}_min_max_rsh comments
      bpf: Simplify cases in bpf_base_func_proto

Yang Li (3):
      samples: bpf: Remove unneeded semicolon
      bpf/benchs/bench_ringbufs: Remove unneeded semicolon
      selftests/bpf: Remove unneeded semicolon

Yonghong Song (3):
      bpf: Permit size-0 datasec
      bpf: Refactor BPF_PSEUDO_CALL checking as a helper function
      bpf: Fix an unitialized value in bpf_iter

 Documentation/bpf/bpf_design_QA.rst                |   6 +
 Documentation/bpf/bpf_devel_QA.rst                 |  11 +-
 Documentation/networking/filter.rst                |  28 +-
 Makefile                                           |  13 +-
 arch/x86/net/bpf_jit_comp.c                        | 205 +++--
 drivers/net/veth.c                                 |  94 ++-
 include/linux/bpf-cgroup.h                         | 101 ++-
 include/linux/bpf.h                                |  74 +-
 include/linux/bpf_verifier.h                       |   5 +-
 include/linux/filter.h                             |  21 +-
 include/linux/indirect_call_wrapper.h              |   6 +
 include/linux/netdevice.h                          |  32 +-
 include/linux/skmsg.h                              |   1 -
 include/net/inet_common.h                          |   2 +
 include/net/sock.h                                 |   2 +
 include/net/tcp.h                                  |   1 +
 include/net/xdp.h                                  |   6 +
 include/trace/bpf_probe.h                          |  12 +-
 include/uapi/linux/bpf.h                           | 103 ++-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/bpf_lru_list.c                          |   7 +-
 kernel/bpf/btf.c                                   |  76 +-
 kernel/bpf/cgroup.c                                | 120 ++-
 kernel/bpf/core.c                                  |  18 +-
 kernel/bpf/cpumap.c                                |  46 +-
 kernel/bpf/devmap.c                                |   4 +-
 kernel/bpf/disasm.c                                |   2 +-
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/helpers.c                               |  12 +-
 kernel/bpf/syscall.c                               |  16 +-
 kernel/bpf/task_iter.c                             | 267 ++++++-
 kernel/bpf/trampoline.c                            |  77 +-
 kernel/bpf/verifier.c                              | 877 ++++++++++++++++-----
 kernel/trace/bpf_trace.c                           |   6 +
 lib/test_bpf.c                                     |   7 +-
 net/core/dev.c                                     |  32 +-
 net/core/filter.c                                  | 195 ++++-
 net/core/skmsg.c                                   |   3 +-
 net/core/xdp.c                                     |  70 ++
 net/ipv4/af_inet.c                                 |  18 +-
 net/ipv4/tcp.c                                     |  14 +
 net/ipv4/tcp_ipv4.c                                |   1 +
 net/ipv4/udp.c                                     |   7 +-
 net/ipv6/af_inet6.c                                |  18 +-
 net/ipv6/tcp_ipv6.c                                |   1 +
 net/ipv6/udp.c                                     |   7 +-
 net/socket.c                                       |   3 +
 net/xdp/xsk.c                                      |  47 +-
 net/xdp/xsk_buff_pool.c                            |  12 +-
 samples/bpf/Makefile                               |  10 +-
 samples/bpf/README.rst                             |  22 +-
 samples/bpf/bpf_insn.h                             |  24 +-
 samples/bpf/cookie_uid_helper_example.c            |   2 +-
 samples/bpf/xdp_redirect_map_kern.c                |  60 +-
 samples/bpf/xdp_redirect_map_user.c                | 112 ++-
 tools/bpf/bpf_dbg.c                                |   2 +-
 tools/bpf/bpftool/Makefile                         |   2 -
 tools/bpf/bpftool/prog.c                           |   4 +
 tools/bpf/resolve_btfids/.gitignore                |   3 +-
 tools/bpf/resolve_btfids/Makefile                  |  44 +-
 tools/bpf/runqslower/Makefile                      |   3 -
 tools/build/feature/Makefile                       |   4 +-
 tools/include/linux/types.h                        |   3 +
 tools/include/uapi/linux/bpf.h                     | 103 ++-
 tools/include/uapi/linux/bpf_perf_event.h          |   1 +
 tools/include/uapi/linux/tcp.h                     | 357 +++++++++
 tools/lib/bpf/.gitignore                           |   1 -
 tools/lib/bpf/Makefile                             |  47 +-
 tools/lib/bpf/btf.c                                |  12 +-
 tools/lib/bpf/libbpf.c                             |  22 +-
 tools/lib/bpf/xsk.c                                |  83 +-
 tools/perf/Makefile.perf                           |   1 -
 tools/scripts/Makefile.include                     |   7 +
 tools/testing/selftests/bpf/.gitignore             |   2 -
 tools/testing/selftests/bpf/Makefile               |   8 +-
 tools/testing/selftests/bpf/README.rst             |  24 +
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |   2 +-
 tools/testing/selftests/bpf/bpf_sockopt_helpers.h  |  21 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   1 +
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |   6 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |  21 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |   6 +
 .../selftests/bpf/prog_tests/atomic_bounds.c       |  17 +
 tools/testing/selftests/bpf/prog_tests/bind_perm.c | 109 +++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 118 ++-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   1 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |  25 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c | 216 +++++
 .../selftests/bpf/prog_tests/cls_redirect.c        |   1 +
 .../selftests/bpf/prog_tests/fexit_stress.c        |   4 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |  60 ++
 .../selftests/bpf/prog_tests/module_attach.c       |  27 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c | 118 +--
 tools/testing/selftests/bpf/prog_tests/recursion.c |  41 +
 .../selftests/bpf/prog_tests/socket_cookie.c       |  76 ++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   1 +
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |  28 +
 .../selftests/bpf/prog_tests/stack_var_off.c       |  35 +
 .../selftests/bpf/prog_tests/test_global_funcs.c   |   8 +
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |  23 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |   2 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   4 +-
 tools/testing/selftests/bpf/progs/atomic_bounds.c  |  24 +
 tools/testing/selftests/bpf/progs/bind_perm.c      |  45 ++
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   8 +
 .../selftests/bpf/progs/bpf_iter_task_vma.c        |  58 ++
 .../selftests/bpf/progs/connect_force_port4.c      |   8 +
 .../selftests/bpf/progs/connect_force_port6.c      |   8 +
 tools/testing/selftests/bpf/progs/ima.c            |  33 +-
 tools/testing/selftests/bpf/progs/lsm.c            |  69 ++
 tools/testing/selftests/bpf/progs/recursion.c      |  46 ++
 tools/testing/selftests/bpf/progs/recvmsg4_prog.c  |  42 +
 tools/testing/selftests/bpf/progs/recvmsg6_prog.c  |  48 ++
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c  |   7 +
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c  |   5 +
 .../selftests/bpf/progs/socket_cookie_prog.c       |  47 +-
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |  23 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c | 198 +++++
 .../selftests/bpf/progs/test_cls_redirect.c        |   7 +
 .../selftests/bpf/progs/test_global_func10.c       |  29 +
 .../selftests/bpf/progs/test_global_func11.c       |  19 +
 .../selftests/bpf/progs/test_global_func12.c       |  21 +
 .../selftests/bpf/progs/test_global_func13.c       |  24 +
 .../selftests/bpf/progs/test_global_func14.c       |  21 +
 .../selftests/bpf/progs/test_global_func15.c       |  22 +
 .../selftests/bpf/progs/test_global_func16.c       |  22 +
 .../selftests/bpf/progs/test_global_func9.c        | 132 ++++
 .../selftests/bpf/progs/test_global_func_args.c    |  91 +++
 .../selftests/bpf/progs/test_module_attach.c       |  10 +
 .../selftests/bpf/progs/test_ns_current_pid_tgid.c |  28 +-
 .../selftests/bpf/progs/test_stack_var_off.c       |  51 ++
 .../selftests/bpf/test_current_pid_tgid_new_ns.c   | 160 ----
 tools/testing/selftests/bpf/test_flow_dissector.c  |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |   2 +-
 tools/testing/selftests/bpf/test_progs.h           |   1 -
 tools/testing/selftests/bpf/test_sock_addr.c       |  86 +-
 tools/testing/selftests/bpf/test_socket_cookie.c   | 208 -----
 tools/testing/selftests/bpf/test_verifier.c        |  88 ++-
 tools/testing/selftests/bpf/verifier/atomic_and.c  |   2 +-
 .../testing/selftests/bpf/verifier/atomic_bounds.c |  27 +
 tools/testing/selftests/bpf/verifier/atomic_or.c   |   2 +-
 tools/testing/selftests/bpf/verifier/atomic_xor.c  |   2 +-
 tools/testing/selftests/bpf/verifier/basic_stack.c |   2 +-
 tools/testing/selftests/bpf/verifier/calls.c       |   4 +-
 tools/testing/selftests/bpf/verifier/const_or.c    |   4 +-
 .../selftests/bpf/verifier/helper_access_var_len.c |  12 +-
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   6 +-
 tools/testing/selftests/bpf/verifier/jit.c         |  24 +
 tools/testing/selftests/bpf/verifier/raw_stack.c   |  10 +-
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |  22 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |   2 +-
 tools/testing/selftests/bpf/verifier/var_off.c     | 115 ++-
 tools/testing/selftests/bpf/vmtest.sh              | 368 +++++++++
 tools/testing/selftests/bpf/xdpxceiver.c           | 225 +++---
 tools/testing/selftests/bpf/xdpxceiver.h           |   2 -
 tools/testing/selftests/tc-testing/Makefile        |   3 +-
 156 files changed, 5662 insertions(+), 1489 deletions(-)
 create mode 100644 tools/include/uapi/linux/tcp.h
 create mode 100644 tools/testing/selftests/bpf/bpf_sockopt_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/atomic_bounds.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/global_func_args.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/recursion.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/socket_cookie.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stack_var_off.c
 create mode 100644 tools/testing/selftests/bpf/progs/atomic_bounds.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/recursion.c
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/recvmsg6_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func10.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func11.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func12.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func13.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func14.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func15.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func16.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func9.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_stack_var_off.c
 delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
 delete mode 100644 tools/testing/selftests/bpf/test_socket_cookie.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_bounds.c
 create mode 100755 tools/testing/selftests/bpf/vmtest.sh
