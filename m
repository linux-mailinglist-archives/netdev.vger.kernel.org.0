Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394EC185261
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 00:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCMXfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 19:35:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:50354 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgCMXfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 19:35:11 -0400
Received: from 192.42.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.42.192] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCtpW-00007O-6D; Sat, 14 Mar 2020 00:35:02 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-03-13
Date:   Sat, 14 Mar 2020 00:35:01 +0100
Message-Id: <20200313233501.1180-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25750/Fri Mar 13 14:03:09 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 86 non-merge commits during the last 12 day(s) which contain
a total of 107 files changed, 5771 insertions(+), 1700 deletions(-).

The main changes are:

1) Add modify_return attach type which allows to attach to a function via
   BPF trampoline and is run after the fentry and before the fexit programs
   and can pass a return code to the original caller, from KP Singh.

2) Generalize BPF's kallsyms handling and add BPF trampoline and dispatcher
   objects to be visible in /proc/kallsyms so they can be annotated in
   stack traces, from Jiri Olsa.

3) Extend BPF sockmap to allow for UDP next to existing TCP support in order
   in order to enable this for BPF based socket dispatch, from Lorenz Bauer.

4) Introduce a new bpftool 'prog profile' command which attaches to existing
   BPF programs via fentry and fexit hooks and reads out hardware counters
   during that period, from Song Liu. Example usage:

   bpftool prog profile id 337 duration 3 cycles instructions llc_misses

        4228 run_cnt
     3403698 cycles                                              (84.08%)
     3525294 instructions   #  1.04 insn per cycle               (84.05%)
          13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)

5) Batch of improvements to libbpf, bpftool and BPF selftests. Also addition
   of a new bpf_link abstraction to keep in particular BPF tracing programs
   attached even when the applicaion owning them exits, from Andrii Nakryiko.

6) New bpf_get_current_pid_tgid() helper for tracing to perform PID filtering
   and which returns the PID as seen by the init namespace, from Carlos Neira.

7) Refactor of RISC-V JIT code to move out common pieces and addition of a
   new RV32G BPF JIT compiler, from Luke Nelson.

8) Add gso_size context member to __sk_buff in order to be able to know whether
   a given skb is GSO or not, from Willem de Bruijn.

9) Add a new bpf_xdp_output() helper which reuses XDP's existing perf RB output
   implementation but can be called from tracepoint programs, from Eelco Chaudron.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrey Ignatov, Andrii Nakryiko, Björn Töpel, Daniel Borkmann, Jakub 
Sitnicki, John Fastabend, kbuild test robot, KP Singh, Martin KaFai Lau, 
Michal Rostecki, Quentin Monnet, Randy Dunlap, Song Liu, Stanislav 
Fomichev, Toke Høiland-Jørgensen, Wenbo Zhang, Yonghong Song

----------------------------------------------------------------

The following changes since commit 15070919f801348e9a9a2ea96f427d8b621f3cd5:

  mvneta: add XDP ethtool errors stats for TX to driver (2020-03-02 11:29:37 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 832165d225f71040a2c1fc2407752e462d00de1f:

  Merge branch 'bpf-core-fixes' (2020-03-13 23:31:14 +0100)

----------------------------------------------------------------
Alexei Starovoitov (7):
      Merge branch 'move_BPF_PROG_to_libbpf'
      Merge branch 'bpf_link'
      Merge branch 'bpf_gso_size'
      Merge branch 'bpf_modify_ret'
      bpf: Fix trampoline generation for fmod_ret programs
      Merge branch 'bpf_get_ns_current_pid_tgid'
      Merge branch 'generalize-bpf-ksym'

Andrii Nakryiko (24):
      bpftool: Add header guards to generated vmlinux.h
      libbpf: Fix use of PT_REGS_PARM macros with vmlinux.h
      selftests/bpf: Fix BPF_KRETPROBE macro and use it in attach_probe test
      libbpf: Merge selftests' bpf_trace_helpers.h into libbpf's bpf_tracing.h
      bpf: Reliably preserve btf_trace_xxx types
      bpf: Introduce pinnable bpf_link abstraction
      libbpf: Add bpf_link pinning/unpinning
      selftests/bpf: Add link pinning selftests
      libbpf: Fix handling of optional field_name in btf_dump__emit_type_decl
      bpf: Switch BPF UAPI #define constants used from BPF program side to enums
      libbpf: Assume unsigned values for BTF_KIND_ENUM
      tools/runqslower: Drop copy/pasted BPF_F_CURRENT_CPU definiton
      selftests/bpf: Support out-of-tree vmlinux builds for VMLINUX_BTF
      bpf: Add bpf_link_new_file that doesn't install FD
      tools/runqslower: Add BPF_F_CURRENT_CPU for running selftest on older kernels
      libbpf: Split BTF presence checks into libbpf- and kernel-specific parts
      selftests/bpf: Guarantee that useep() calls nanosleep() syscall
      selftests/bpf: Make tcp_rtt test more robust to failures
      bpf: Abstract away entire bpf_link clean up procedure
      selftests/bpf: Fix usleep() implementation
      selftests/bpf: Ensure consistent test failure output
      libbpf: Ignore incompatible types with matching name during CO-RE relocation
      libbpf: Provide CO-RE variants of PT_REGS macros
      selftests/bpf: Add vmlinux.h selftest exercising tracing of syscalls

Björn Töpel (1):
      bpf: Add bpf_trampoline_ name prefix for DECLARE_BPF_DISPATCHER

Carlos Neira (4):
      fs/nsfs.c: Added ns_match
      bpf: Added new helper bpf_get_ns_current_pid_tgid
      tools/testing/selftests/bpf: Add self-tests for new helper bpf_get_ns_current_pid_tgid.
      bpf_helpers_doc.py: Fix warning when compiling bpftool

Daniel Borkmann (2):
      Merge branch 'bpf-uapi-enums'
      Merge branch 'bpf-core-fixes'

Eelco Chaudron (1):
      bpf: Add bpf_xdp_output() helper

Jakub Sitnicki (1):
      selftests/bpf: Fix spurious failures in accept due to EAGAIN

Jiri Olsa (11):
      x86/mm: Rename is_kernel_text to __is_kernel_text
      bpf: Add struct bpf_ksym
      bpf: Add name to struct bpf_ksym
      bpf: Move lnode list node to struct bpf_ksym
      bpf: Move ksym_tnode to bpf_ksym
      bpf: Add bpf_ksym_find function
      bpf: Add prog flag to struct bpf_ksym object
      bpf: Add bpf_ksym_add/del functions
      bpf: Add trampolines to kallsyms
      bpf: Add dispatchers to kallsyms
      bpf: Remove bpf_image tree

Jules Irenge (1):
      bpf: Add missing annotations for __bpf_prog_enter() and __bpf_prog_exit()

KP Singh (9):
      bpf: Refactor trampoline update code
      bpf: JIT helpers for fmod_ret progs
      bpf: Introduce BPF_MODIFY_RETURN
      bpf: Attachment verification for BPF_MODIFY_RETURN
      tools/libbpf: Add support for BPF_MODIFY_RETURN
      bpf: Add test ops for BPF_PROG_TYPE_TRACING
      bpf: Add selftests for BPF_MODIFY_RETURN
      bpf: Remove unnecessary CAP_MAC_ADMIN check
      bpf: Fix bpf_prog_test_run_tracing for !CONFIG_NET

Kees Cook (1):
      kbuild: Remove debug info from kallsyms linking

Lorenz Bauer (12):
      bpf: sockmap: Only check ULP for TCP sockets
      skmsg: Update saved hooks only once
      bpf: tcp: Move assertions into tcp_bpf_get_proto
      bpf: tcp: Guard declarations with CONFIG_NET_SOCK_MSG
      bpf: sockmap: Move generic sockmap hooks from BPF TCP
      bpf: sockmap: Simplify sock_map_init_proto
      bpf: Add sockmap hooks for UDP sockets
      bpf: sockmap: Add UDP support
      selftests: bpf: Don't listen() on UDP sockets
      selftests: bpf: Add tests for UDP sockets in sockmap
      selftests: bpf: Enable UDP sockmap reuseport tests
      bpf, doc: Update maintainers for L7 BPF

Luke Nelson (4):
      riscv, bpf: Factor common RISC-V JIT code
      riscv, bpf: Add RV32G eBPF JIT
      bpf, doc: Add BPF JIT for RV32G to BPF documentation
      MAINTAINERS: Add entry for RV32G BPF JIT

Quentin Monnet (3):
      tools: bpftool: Allow all prog/map handles for pinning objects
      tools: bpftool: Fix minor bash completion mistakes
      tools: bpftool: Restore message on failure to guess program type

Song Liu (7):
      bpftool: Introduce "prog profile" command
      bpftool: Documentation for bpftool prog profile
      bpftool: Bash completion for "bpftool prog profile"
      bpftool: Fix typo in bash-completion
      bpftool: Only build bpftool-prog-profile if supported by clang
      bpftool: Skeleton should depend on libbpf
      bpftool: Add _bpftool and profiler.skel.h to .gitignore

Tobias Klauser (2):
      bpftool: Use linux/types.h from source tree for profiler build
      tools/bpf: Move linux/types.h for selftests and bpftool

Toke Høiland-Jørgensen (1):
      selftests/bpf: Declare bpf_log_buf variables as static

Willem de Bruijn (3):
      bpf: Add gso_size to __sk_buff
      bpf: Sync uapi bpf.h to tools/
      selftests/bpf: Test new __sk_buff field gso_size

 Documentation/admin-guide/sysctl/net.rst           |    3 +-
 Documentation/networking/filter.txt                |    2 +-
 MAINTAINERS                                        |   16 +-
 arch/riscv/Kconfig                                 |    2 +-
 arch/riscv/net/Makefile                            |    9 +-
 arch/riscv/net/bpf_jit.h                           |  514 ++++++++
 arch/riscv/net/bpf_jit_comp32.c                    | 1310 ++++++++++++++++++++
 .../riscv/net/{bpf_jit_comp.c => bpf_jit_comp64.c} |  605 +--------
 arch/riscv/net/bpf_jit_core.c                      |  166 +++
 arch/x86/mm/init_32.c                              |   14 +-
 arch/x86/net/bpf_jit_comp.c                        |  260 ++--
 fs/nsfs.c                                          |   14 +
 include/linux/bpf.h                                |  109 +-
 include/linux/filter.h                             |   15 +-
 include/linux/proc_ns.h                            |    2 +
 include/linux/skmsg.h                              |   56 +-
 include/net/inet_connection_sock.h                 |    6 +
 include/net/tcp.h                                  |   20 +-
 include/net/udp.h                                  |    5 +
 include/trace/bpf_probe.h                          |   18 +-
 include/uapi/linux/bpf.h                           |  221 +++-
 kernel/bpf/bpf_struct_ops.c                        |   10 +-
 kernel/bpf/btf.c                                   |   27 +-
 kernel/bpf/core.c                                  |  121 +-
 kernel/bpf/dispatcher.c                            |    5 +-
 kernel/bpf/helpers.c                               |   45 +
 kernel/bpf/inode.c                                 |   42 +-
 kernel/bpf/syscall.c                               |  306 ++++-
 kernel/bpf/trampoline.c                            |  152 +--
 kernel/bpf/verifier.c                              |   29 +-
 kernel/events/core.c                               |    9 +-
 kernel/extable.c                                   |    2 -
 kernel/trace/bpf_trace.c                           |   13 +
 net/bpf/test_run.c                                 |   64 +-
 net/core/filter.c                                  |   65 +-
 net/core/sock_map.c                                |  157 ++-
 net/ipv4/Makefile                                  |    1 +
 net/ipv4/tcp_bpf.c                                 |  114 +-
 net/ipv4/tcp_ulp.c                                 |    7 -
 net/ipv4/udp_bpf.c                                 |   53 +
 scripts/bpf_helpers_doc.py                         |    2 +
 scripts/link-vmlinux.sh                            |   28 +-
 tools/bpf/bpftool/.gitignore                       |    2 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   19 +
 tools/bpf/bpftool/Makefile                         |   36 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   76 +-
 tools/bpf/bpftool/btf.c                            |    5 +
 tools/bpf/bpftool/common.c                         |   40 +-
 tools/bpf/bpftool/main.c                           |    7 -
 tools/bpf/bpftool/main.h                           |    7 +-
 tools/bpf/bpftool/map.c                            |    2 +-
 tools/bpf/bpftool/prog.c                           |  454 ++++++-
 tools/bpf/bpftool/skeleton/profiler.bpf.c          |  119 ++
 tools/bpf/bpftool/skeleton/profiler.h              |   46 +
 tools/bpf/runqslower/runqslower.bpf.c              |    4 +-
 tools/build/feature/Makefile                       |    9 +-
 tools/build/feature/test-clang-bpf-global-var.c    |    4 +
 tools/include/uapi/linux/bpf.h                     |  223 +++-
 .../selftests/bpf => }/include/uapi/linux/types.h  |    0
 tools/lib/bpf/bpf_tracing.h                        |  223 +++-
 tools/lib/bpf/btf_dump.c                           |   10 +-
 tools/lib/bpf/libbpf.c                             |  156 ++-
 tools/lib/bpf/libbpf.h                             |    5 +
 tools/lib/bpf/libbpf.map                           |    5 +
 tools/scripts/Makefile.include                     |    1 +
 tools/testing/selftests/bpf/.gitignore             |    1 +
 tools/testing/selftests/bpf/Makefile               |   26 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |    2 +-
 tools/testing/selftests/bpf/bpf_trace_helpers.h    |  120 --
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |    2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |    2 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |    2 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |   12 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   14 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   69 +-
 .../selftests/bpf/prog_tests/link_pinning.c        |  105 ++
 .../selftests/bpf/prog_tests/modify_return.c       |   65 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |   88 ++
 .../selftests/bpf/prog_tests/select_reuseport.c    |    6 -
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |    1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  259 +++-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |   32 +-
 tools/testing/selftests/bpf/prog_tests/vmlinux.c   |   43 +
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   53 +
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |    2 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |    2 +-
 tools/testing/selftests/bpf/progs/fentry_test.c    |    2 +-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |    2 +-
 .../selftests/bpf/progs/fexit_bpf2bpf_simple.c     |    2 +-
 tools/testing/selftests/bpf/progs/fexit_test.c     |    2 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c      |    2 +-
 tools/testing/selftests/bpf/progs/modify_return.c  |   49 +
 .../selftests/bpf/progs/test_attach_probe.c        |    3 +-
 .../selftests/bpf/progs/test_link_pinning.c        |   25 +
 .../selftests/bpf/progs/test_ns_current_pid_tgid.c |   37 +
 tools/testing/selftests/bpf/progs/test_overhead.c  |    7 +-
 .../selftests/bpf/progs/test_perf_branches.c       |    2 +-
 .../testing/selftests/bpf/progs/test_perf_buffer.c |    2 +-
 .../testing/selftests/bpf/progs/test_probe_user.c  |    1 -
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |    2 +
 .../selftests/bpf/progs/test_trampoline_count.c    |    3 +-
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |   84 ++
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   26 +-
 .../selftests/bpf/test_current_pid_tgid_new_ns.c   |  159 +++
 tools/testing/selftests/bpf/test_progs.c           |   28 +-
 tools/testing/selftests/bpf/test_progs.h           |    8 +-
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |   47 +
 107 files changed, 5771 insertions(+), 1700 deletions(-)
 create mode 100644 arch/riscv/net/bpf_jit.h
 create mode 100644 arch/riscv/net/bpf_jit_comp32.c
 rename arch/riscv/net/{bpf_jit_comp.c => bpf_jit_comp64.c} (69%)
 create mode 100644 arch/riscv/net/bpf_jit_core.c
 create mode 100644 net/ipv4/udp_bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
 create mode 100644 tools/build/feature/test-clang-bpf-global-var.c
 rename tools/{testing/selftests/bpf => }/include/uapi/linux/types.h (100%)
 delete mode 100644 tools/testing/selftests/bpf/bpf_trace_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/link_pinning.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/modify_return.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vmlinux.c
 create mode 100644 tools/testing/selftests/bpf/progs/modify_return.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_link_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_vmlinux.c
 create mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
