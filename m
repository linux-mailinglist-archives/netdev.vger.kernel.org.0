Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2AD21424D
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgGDAPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:15:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:49654 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGDAPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 20:15:19 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrVpi-00075R-6T; Sat, 04 Jul 2020 02:15:06 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-07-04
Date:   Sat,  4 Jul 2020 02:15:05 +0200
Message-Id: <20200704001505.10610-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25862/Fri Jul  3 15:56:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 73 non-merge commits during the last 17 day(s) which contain
a total of 106 files changed, 5233 insertions(+), 1283 deletions(-).

The main changes are:

1) bpftool ability to show PIDs of processes having open file descriptors
   for BPF map/program/link/BTF objects, relying on BPF iterator progs
   to extract this info efficiently, from Andrii Nakryiko.

2) Addition of BPF iterator progs for dumping TCP and UDP sockets to
   seq_files, from Yonghong Song.

3) Support access to BPF map fields in struct bpf_map from programs
   through BTF struct access, from Andrey Ignatov.

4) Add a bpf_get_task_stack() helper to be able to dump /proc/*/stack
   via seq_file from BPF iterator progs, from Song Liu.

5) Make SO_KEEPALIVE and related options available to bpf_setsockopt()
   helper, from Dmitry Yakunin.

6) Optimize BPF sk_storage selection of its caching index, from Martin
   KaFai Lau.

7) Removal of redundant synchronize_rcu()s from BPF map destruction which
   has been a historic leftover, from Alexei Starovoitov.

8) Several improvements to test_progs to make it easier to create a shell
   loop that invokes each test individually which is useful for some CIs,
   from Jesper Dangaard Brouer.

9) Fix bpftool prog dump segfault when compiled without skeleton code on
   older clang versions, from John Fastabend.

10) Bunch of cleanups and minor improvements, from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Christoph Hellwig, Hao Luo, Jesper Dangaard Brouer, Joe 
Stringer, John Fastabend, kernel test robot, Martin KaFai Lau, Paul E. 
McKenney, Quentin Monnet, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit 7bd3a33ae6d2b820bc44a206f9b81b96840219fd:

  libbpf: Bump version to 0.1.0 (2020-06-17 13:20:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 9ff79af3331277c69ac61cc75b2392eb3284e305:

  selftests/bpf: Fix compilation error of bpf_iter_task_stack.c (2020-07-03 23:25:40 +0200)

----------------------------------------------------------------
Alexei Starovoitov (8):
      Merge branch 'bpftool-show-pid'
      Merge up to bpf_probe_read_kernel_str() fix into bpf-next
      selftests/bpf: Workaround for get_stack_rawtp test.
      Merge branch 'bpf_iter_tcp_udp'
      Merge branch 'libbpf_autoload_knob'
      bpf: Remove redundant synchronize_rcu.
      Merge branch 'bpf_get_task_stack'
      Merge branch 'test_progs-improvements'

Andrey Ignatov (5):
      bpf: Switch btf_parse_vmlinux to btf_find_by_name_kind
      bpf: Rename bpf_htab to bpf_shtab in sock_map
      bpf: Support access to bpf map fields
      bpf: Set map_btf_{name, id} for all map types
      selftests/bpf: Test access to bpf map pointer

Andrii Nakryiko (24):
      bpf: Fix definition of bpf_ringbuf_output() helper in UAPI comments
      tools/bpftool: Add ringbuf map to a list of known map types
      bpf: bpf_probe_read_kernel_str() has to return amount of data read on success
      tools/bpftool: Relicense bpftool's BPF profiler prog as dual-license GPL/BSD
      libbpf: Add a bunch of attribute getters/setters for map definitions
      libbpf: Generalize libbpf externs support
      libbpf: Add support for extracting kernel symbol addresses
      selftests/bpf: Add __ksym extern selftest
      tools/bpftool: Move map/prog parsing logic into common
      tools/bpftool: Minimize bootstrap bpftool
      tools/bpftool: Generalize BPF skeleton support and generate vmlinux.h
      libbpf: Wrap source argument of BPF_CORE_READ macro in parentheses
      tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs
      tools/bpftool: Add documentation and sample output for process info
      bpf: Switch most helper return values from 32-bit int to 64-bit long
      selftests/bpf: Add variable-length data concatenation pattern test
      libbpf: Prevent loading vmlinux BTF twice
      libbpf: Support disabling auto-loading BPF programs
      selftests/bpf: Test auto-load disabling logic for BPF programs
      tools/bpftool: Allow substituting custom vmlinux.h for the build
      selftests/bpf: Allow substituting custom vmlinux.h for selftests build
      libbpf: Make bpf_endian co-exist with vmlinux.h
      selftests/bpf: Add byte swapping selftest
      tools/bpftool: Turn off -Wnested-externs warning

Colin Ian King (1):
      libbpf: Fix spelling mistake "kallasyms" -> "kallsyms"

Dmitry Yakunin (3):
      sock: Move sock_valbool_flag to header
      tcp: Expose tcp_sock_set_keepidle_locked
      bpf: Add SO_KEEPALIVE and related options to bpf_setsockopt

Gaurav Singh (1):
      bpf, xdp, samples: Fix null pointer dereference in *_user code

Hao Luo (1):
      selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.

Jesper Dangaard Brouer (3):
      selftests/bpf: Test_progs indicate to shell on non-actions
      selftests/bpf: Test_progs option for getting number of tests
      selftests/bpf: Test_progs option for listing test names

John Fastabend (2):
      selftests/bpf: Add variable-length data concat pattern less than test
      bpf: Fix bpftool without skeleton code enabled

Martin KaFai Lau (3):
      bpf: sk_storage: Prefer to get a free cache_idx
      bpf: selftests: A few improvements to network_helpers.c
      bpf: selftests: Restore netns after each test

Quentin Monnet (1):
      tools, bpftool: Fix variable shadowing in emit_obj_refs_json()

Randy Dunlap (1):
      bpf: Fix net/core/filter build errors when INET is not enabled

Song Liu (6):
      perf: Expose get/put_callchain_entry()
      bpf: Introduce helper bpf_get_task_stack()
      bpf: Allow %pB in bpf_seq_printf() and bpf_trace_printk()
      selftests/bpf: Add bpf_iter test with bpf_get_task_stack()
      bpf: Fix build without CONFIG_STACKTRACE
      selftests/bpf: Fix compilation error of bpf_iter_task_stack.c

Tobias Klauser (3):
      tools, bpftool: Correctly evaluate $(BUILD_BPF_SKELS) in Makefile
      tools, bpftool: Define prog_type_name array only once
      tools, bpftool: Define attach_type_name array only once

Yonghong Song (17):
      bpf: Avoid verifier failure for 32bit pointer arithmetic
      tools/bpf: Add verifier tests for 32bit pointer/scalar arithmetic
      net: bpf: Add bpf_seq_afinfo in tcp_iter_state
      net: bpf: Implement bpf iterator for tcp
      bpf: Support 'X' in bpf_seq_printf() helper
      bpf: Allow tracing programs to use bpf_jiffies64() helper
      bpf: Add bpf_skc_to_tcp6_sock() helper
      bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request}_sock() helpers
      net: bpf: Add bpf_seq_afinfo in udp_iter_state
      net: bpf: Implement bpf iterator for udp
      bpf: Add bpf_skc_to_udp6_sock() helper
      selftests/bpf: Move newer bpf_iter_* type redefining to a new header file
      selftests/bpf: Refactor some net macros to bpf_tracing_net.h
      selftests/bpf: Add more common macros to bpf_tracing_net.h
      selftests/bpf: Implement sample tcp/tcp6 bpf_iter programs
      selftests/bpf: Implement sample udp/udp6 bpf_iter programs
      selftests/bpf: Add tcp/udp iterator programs to selftests

 include/linux/bpf.h                                |  26 +
 include/linux/bpf_verifier.h                       |   1 +
 include/linux/perf_event.h                         |   2 +
 include/linux/tcp.h                                |   1 +
 include/net/sock.h                                 |   9 +
 include/net/tcp.h                                  |   1 +
 include/net/udp.h                                  |   1 +
 include/uapi/linux/bpf.h                           | 273 +++++---
 kernel/bpf/arraymap.c                              |  27 +-
 kernel/bpf/bpf_struct_ops.c                        |   3 +
 kernel/bpf/btf.c                                   |  64 +-
 kernel/bpf/cpumap.c                                |   3 +
 kernel/bpf/devmap.c                                |   6 +
 kernel/bpf/hashtab.c                               |  23 +-
 kernel/bpf/local_storage.c                         |   3 +
 kernel/bpf/lpm_trie.c                              |   8 +-
 kernel/bpf/queue_stack_maps.c                      |  13 +-
 kernel/bpf/reuseport_array.c                       |   5 +-
 kernel/bpf/ringbuf.c                               |  10 +-
 kernel/bpf/stackmap.c                              |  87 ++-
 kernel/bpf/verifier.c                              | 134 +++-
 kernel/events/callchain.c                          |  13 +-
 kernel/trace/bpf_trace.c                           |  29 +-
 net/core/bpf_sk_storage.c                          |  44 +-
 net/core/filter.c                                  | 206 ++++++-
 net/core/sock.c                                    |   9 -
 net/core/sock_map.c                                |  88 +--
 net/ipv4/tcp.c                                     |   6 +-
 net/ipv4/tcp_ipv4.c                                | 153 ++++-
 net/ipv4/udp.c                                     | 144 ++++-
 net/xdp/xskmap.c                                   |   3 +
 samples/bpf/xdp_monitor_user.c                     |   8 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   7 +-
 samples/bpf/xdp_rxq_info_user.c                    |  13 +-
 scripts/bpf_helpers_doc.py                         |  12 +
 tools/bpf/bpftool/.gitignore                       |   5 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   5 +
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |  13 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   8 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  11 +
 tools/bpf/bpftool/Makefile                         |  66 +-
 tools/bpf/bpftool/btf.c                            |   6 +
 tools/bpf/bpftool/common.c                         | 344 +++++++++++
 tools/bpf/bpftool/feature.c                        |   4 +-
 tools/bpf/bpftool/link.c                           |  11 +-
 tools/bpf/bpftool/main.c                           |  12 +-
 tools/bpf/bpftool/main.h                           | 125 ++--
 tools/bpf/bpftool/map.c                            | 168 +----
 tools/bpf/bpftool/pids.c                           | 231 +++++++
 tools/bpf/bpftool/prog.c                           | 193 ++----
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |  80 +++
 tools/bpf/bpftool/skeleton/pid_iter.h              |  12 +
 tools/bpf/bpftool/skeleton/profiler.bpf.c          |   7 +-
 tools/bpf/bpftool/skeleton/profiler.h              |  46 --
 tools/build/feature/Makefile                       |   4 +-
 tools/build/feature/test-clang-bpf-co-re.c         |   9 +
 tools/build/feature/test-clang-bpf-global-var.c    |   4 -
 tools/include/uapi/linux/bpf.h                     | 273 +++++---
 tools/lib/bpf/bpf_core_read.h                      |   8 +-
 tools/lib/bpf/bpf_endian.h                         |  43 +-
 tools/lib/bpf/bpf_helpers.h                        |   1 +
 tools/lib/bpf/btf.h                                |   5 +
 tools/lib/bpf/libbpf.c                             | 663 +++++++++++++++-----
 tools/lib/bpf/libbpf.h                             |  32 +-
 tools/lib/bpf/libbpf.map                           |  16 +
 tools/testing/selftests/bpf/Makefile               |   9 +-
 tools/testing/selftests/bpf/network_helpers.c      | 157 +++--
 tools/testing/selftests/bpf/network_helpers.h      |   9 +-
 tools/testing/selftests/bpf/prog_tests/autoload.c  |  41 ++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  85 +++
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c          |  12 +-
 .../selftests/bpf/prog_tests/connect_force_port.c  |  10 +-
 tools/testing/selftests/bpf/prog_tests/endian.c    |  53 ++
 tools/testing/selftests/bpf/prog_tests/ksyms.c     |  71 +++
 .../selftests/bpf/prog_tests/load_bytes_relative.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |  32 +
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |   4 +-
 tools/testing/selftests/bpf/prog_tests/varlen.c    |  68 ++
 tools/testing/selftests/bpf/progs/bpf_iter.h       |  80 +++
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |  18 +-
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c      |  25 +-
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |  22 +-
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |  18 +-
 .../selftests/bpf/progs/bpf_iter_task_file.c       |  20 +-
 .../selftests/bpf/progs/bpf_iter_task_stack.c      |  37 ++
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  | 234 +++++++
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  | 250 ++++++++
 .../selftests/bpf/progs/bpf_iter_test_kern3.c      |  17 +-
 .../selftests/bpf/progs/bpf_iter_test_kern4.c      |  17 +-
 .../bpf/progs/bpf_iter_test_kern_common.h          |  18 +-
 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c  |  71 +++
 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c  |  79 +++
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |  51 ++
 tools/testing/selftests/bpf/progs/connect4_prog.c  |  27 +
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   | 686 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_autoload.c  |  40 ++
 tools/testing/selftests/bpf/progs/test_endian.c    |  37 ++
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |   3 +-
 tools/testing/selftests/bpf/progs/test_ksyms.c     |  32 +
 tools/testing/selftests/bpf/progs/test_varlen.c    | 158 +++++
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |  16 +-
 tools/testing/selftests/bpf/test_progs.c           |  59 +-
 tools/testing/selftests/bpf/test_progs.h           |   4 +
 tools/testing/selftests/bpf/verifier/map_ptr.c     |  62 ++
 .../selftests/bpf/verifier/map_ptr_mixing.c        |   2 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |  38 ++
 106 files changed, 5233 insertions(+), 1283 deletions(-)
 create mode 100644 tools/bpf/bpftool/pids.c
 create mode 100644 tools/bpf/bpftool/skeleton/pid_iter.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/pid_iter.h
 delete mode 100644 tools/bpf/bpftool/skeleton/profiler.h
 create mode 100644 tools/build/feature/test-clang-bpf-co-re.c
 delete mode 100644 tools/build/feature/test-clang-bpf-global-var.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/autoload.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/endian.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_ptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/varlen.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_tracing_net.h
 create mode 100644 tools/testing/selftests/bpf/progs/map_ptr_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoload.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_endian.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_varlen.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_ptr.c
