Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2553FBF5E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 01:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238942AbhH3XVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 19:21:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:35556 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237832AbhH3XVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 19:21:21 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mKqCS-0006zr-Fh; Tue, 31 Aug 2021 00:56:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-08-31
Date:   Tue, 31 Aug 2021 00:56:18 +0200
Message-Id: <20210830225618.11634-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26279/Mon Aug 30 10:22:08 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 116 non-merge commits during the last 17 day(s) which contain
a total of 126 files changed, 6813 insertions(+), 4027 deletions(-).

The main changes are:

1) Add opaque bpf_cookie to perf link which the program can read out again,
   to be used in libbpf-based USDT library, from Andrii Nakryiko.

2) Add bpf_task_pt_regs() helper to access userspace pt_regs, from Daniel Xu.

3) Add support for UNIX stream type sockets for BPF sockmap, from Jiang Wang.

4) Allow BPF TCP congestion control progs to call bpf_setsockopt() e.g. to switch
   to another congestion control algorithm during init, from Martin KaFai Lau.

5) Extend BPF iterator support for UNIX domain sockets, from Kuniyuki Iwashima.

6) Allow bpf_{set,get}sockopt() calls from setsockopt progs, from Prankur Gupta.

7) Add bpf_get_netns_cookie() helper for BPF_PROG_TYPE_{SOCK_OPS,CGROUP_SOCKOPT}
   progs, from Xu Liu and Stanislav Fomichev.

8) Support for __weak typed ksyms in libbpf, from Hao Luo.

9) Shrink struct cgroup_bpf by 504 bytes through refactoring, from Dave Marchevsky.

10) Fix a smatch complaint in verifier's narrow load handling, from Andrey Ignatov.

11) Fix BPF interpreter's tail call count limit, from Daniel Borkmann.

12) Big batch of improvements to BPF selftests, from Magnus Karlsson, Li Zhijian,
    Yucong Sun, Yonghong Song, Ilya Leoshkevich, Jussi Maki, Ilya Leoshkevich, others.

13) Another big batch to revamp XDP samples in order to give them consistent look
    and feel, from Kumar Kartikeya Dwivedi.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Cong Wang, Dan Carpenter, Dmitry Osipenko, Jakub 
Sitnicki, Johan Almbladh, John Fastabend, kernel test robot, Kuniyuki 
Iwashima, Martin KaFai Lau, Paul Chaignon, Peter Zijlstra (Intel), Song 
Liu, Yonghong Song

----------------------------------------------------------------

The following changes since commit afa79d08c6c8e1901cb1547591e3ccd3ec6965d9:

  net: in_irq() cleanup (2021-08-13 14:09:19 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to fca35b11e18a9d854cda6b18ed39a78011f4b082:

  MAINTAINERS: Remove self from powerpc BPF JIT (2021-08-30 22:19:05 +0200)

----------------------------------------------------------------
Alexei Starovoitov (7):
      Merge branch 'Refactor cgroup_bpf internals to use more specific attach_type'
      Merge branch 'selftests/bpf: minor fixups'
      Merge branch 'bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG'
      Merge branch 'Improve XDP samples usability and output'
      Merge branch 'bpf: Add bpf_task_pt_regs() helper'
      Merge branch 'selftests: xsk: various simplifications'
      Merge branch 'bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt'

Andrey Ignatov (1):
      bpf: Fix possible out of bound write in narrow load handling

Andrii Nakryiko (21):
      Merge branch 'bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT'
      Merge branch 'BPF iterator for UNIX domain socket.'
      bpf: Refactor BPF_PROG_RUN into a function
      bpf: Refactor BPF_PROG_RUN_ARRAY family of macros into functions
      bpf: Refactor perf_event_set_bpf_prog() to use struct bpf_prog input
      bpf: Implement minimal BPF perf link
      bpf: Allow to specify user-provided bpf_cookie for BPF perf links
      bpf: Add bpf_get_attach_cookie() BPF helper to access bpf_cookie value
      libbpf: Re-build libbpf.so when libbpf.map changes
      libbpf: Remove unused bpf_link's destroy operation, but add dealloc
      libbpf: Use BPF perf link when supported by kernel
      libbpf: Add bpf_cookie support to bpf_link_create() API
      libbpf: Add bpf_cookie to perf_event, kprobe, uprobe, and tp attach APIs
      selftests/bpf: Test low-level perf BPF link API
      selftests/bpf: Extract uprobe-related helpers into trace_helpers.{c,h}
      selftests/bpf: Add bpf_cookie selftests for high-level APIs
      libbpf: Add uprobe ref counter offset support for USDT semaphores
      selftests/bpf: Add ref_ctr_offset selftests
      Merge branch 'sockmap: add sockmap support for unix stream socket'
      Merge branch 'selftests/bpf: Improve the usability of test_progs'
      Merge branch 'selftests/bpf: fix flaky send_signal test'

Chengfeng Ye (1):
      selftests/bpf: Fix potential unreleased lock

Colin Ian King (2):
      bpf, tests: Fix spelling mistake "shoft" -> "shift"
      bpf: Remove redundant initialization of variable allow

Daniel Borkmann (2):
      Merge branch 'bpf-perf-link'
      bpf: Undo off-by-one in interpreter tail call count limit

Daniel Xu (6):
      bpf: Add BTF_ID_LIST_GLOBAL_SINGLE macro
      bpf: Consolidate task_struct BTF_ID declarations
      bpf: Extend bpf_base_func_proto helpers with bpf_get_current_task_btf()
      bpf: Add bpf_task_pt_regs() helper
      bpf: selftests: Add bpf_task_pt_regs() selftest
      bpf: Fix bpf-next builds without CONFIG_BPF_EVENTS

Dave Marchevsky (1):
      bpf: Migrate cgroup_bpf to internal cgroup_bpf_attach_type enum

Grant Seltzer (1):
      libbpf: Rename libbpf documentation index file

Hao Luo (1):
      libbpf: Support weak typed ksyms.

Hengqi Chen (1):
      selftests/bpf: Test btf__load_vmlinux_btf/btf__load_module_btf APIs

Ilya Leoshkevich (1):
      selftests/bpf: Fix test_core_autosize on big-endian machines

Jiang Wang (6):
      af_unix: Add read_sock for stream socket types
      af_unix: Add unix_stream_proto for sockmap
      selftest/bpf: Add tests for sockmap with unix stream type.
      selftest/bpf: Change udp to inet in some function names
      selftest/bpf: Add new tests in sockmap for unix stream to tcp.
      af_unix: Fix NULL pointer bug in unix_shutdown

Jussi Maki (1):
      selftests/bpf: Fix running of XDP bonding tests

Kumar Kartikeya Dwivedi (23):
      samples: bpf: Fix a couple of warnings
      tools: include: Add ethtool_drvinfo definition to UAPI header
      samples: bpf: Add basic infrastructure for XDP samples
      samples: bpf: Add BPF support for redirect tracepoint
      samples: bpf: Add redirect tracepoint statistics support
      samples: bpf: Add BPF support for xdp_exception tracepoint
      samples: bpf: Add xdp_exception tracepoint statistics support
      samples: bpf: Add BPF support for cpumap tracepoints
      samples: bpf: Add cpumap tracepoint statistics support
      samples: bpf: Add BPF support for devmap_xmit tracepoint
      samples: bpf: Add devmap_xmit tracepoint statistics support
      samples: bpf: Add vmlinux.h generation support
      samples: bpf: Convert xdp_monitor_kern.o to XDP samples helper
      samples: bpf: Convert xdp_monitor to XDP samples helper
      samples: bpf: Convert xdp_redirect_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect to XDP samples helper
      samples: bpf: Convert xdp_redirect_cpu_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_cpu to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_map to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_multi_kern.o to XDP samples helper
      samples: bpf: Convert xdp_redirect_map_multi to XDP samples helper
      samples: bpf: Fix uninitialized variable in xdp_redirect_cpu

Kuniyuki Iwashima (4):
      bpf: af_unix: Implement BPF iterator for UNIX domain socket.
      bpf: Support "%c" in bpf_bprintf_prepare().
      selftest/bpf: Implement sample UNIX domain socket iterator program.
      selftest/bpf: Extend the bpf_snprintf() test for "%c".

Li Zhijian (5):
      selftests/bpf: Enlarge select() timeout for test_maps
      selftests/bpf: Make test_doc_build.sh work from script directory
      selftests/bpf: Add default bpftool built by selftests to PATH
      selftests/bpf: Add missing files required by test_bpftool.sh for installing
      selftests/bpf: Exit with KSFT_SKIP if no Makefile found

Magnus Karlsson (16):
      selftests: xsk: Remove color mode
      selftests: xsk: Remove the num_tx_packets option
      selftests: xsk: Remove unused variables
      selftests: xsk: Return correct error codes
      selftests: xsk: Simplify the retry code
      selftests: xsk: Remove end-of-test packet
      selftests: xsk: Disassociate umem size with packets sent
      selftests: xsk: Rename worker_* functions that are not thread entry points
      selftests: xsk: Simplify packet validation in xsk tests
      selftests: xsk: Validate tx stats on tx thread
      selftests: xsk: Decrease sending speed
      selftests: xsk: Simplify cleanup of ifobjects
      selftests: xsk: Generate packet directly in umem
      selftests: xsk: Generate packets from specification
      selftests: xsk: Make enums lower case
      selftests: xsk: Preface options with opt

Martin KaFai Lau (4):
      bpf: tcp: Allow bpf-tcp-cc to call bpf_(get|set)sockopt
      bpf: selftests: Add sk_state to bpf_tcp_helpers.h
      bpf: selftests: Add connect_to_fd_opts to network_helpers
      bpf: selftests: Add dctcp fallback test

Muhammad Falak R Wani (1):
      samples/bpf: Define MAX_ENTRIES instead of a magic number in offwaketime

Prankur Gupta (2):
      bpf: Add support for {set|get} socket options from setsockopt BPF
      selftests/bpf: Add tests for {set|get} socket option from setsockopt BPF

Sandipan Das (1):
      MAINTAINERS: Remove self from powerpc BPF JIT

Stanislav Fomichev (4):
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
      selftests/bpf: Verify bpf_get_netns_cookie in BPF_PROG_TYPE_CGROUP_SOCKOPT
      bpf: Use kvmalloc for map values in syscall
      bpf: Use kvmalloc for map keys in syscalls

Xu Liu (4):
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SOCK_OPS
      selftests/bpf: Test for get_netns_cookie
      bpf: Allow bpf_get_netns_cookie in BPF_PROG_TYPE_SK_MSG
      selftests/bpf: Test for get_netns_cookie

Yonghong Song (3):
      selftests/bpf: Replace CHECK with ASSERT_* macros in send_signal.c
      selftests/bpf: Fix flaky send_signal test
      bpf: Fix NULL event->prog pointer access in bpf_overflow_handler

Yucong Sun (9):
      selftests/bpf: Add exponential backoff to map_update_retriable in test_maps
      selftests/bpf: Add exponential backoff to map_delete_retriable in test_maps
      selftests/bpf: Skip loading bpf_testmod when using -l to list tests.
      selftests/bpf: Correctly display subtest skip status
      selftests/bpf: Also print test name in subtest status message
      selftests/bpf: Support glob matching for test selector.
      selftests/bpf: Adding delay in socketmap_listen to reduce flakyness
      selftests/bpf: Reduce flakyness in timer_mim
      selftests/bpf: Reduce more flakyness in sockmap_listen

grantseltzer (1):
      bpf: Reconfigure libbpf docs to remove unversioned API

 Documentation/bpf/index.rst                        |   10 +-
 Documentation/bpf/libbpf/{libbpf.rst => index.rst} |    8 +
 Documentation/bpf/libbpf/libbpf_api.rst            |   27 -
 .../bpf/libbpf/libbpf_naming_convention.rst        |    2 +-
 Documentation/networking/filter.rst                |    4 +-
 MAINTAINERS                                        |    1 -
 drivers/media/rc/bpf-lirc.c                        |    6 +-
 drivers/net/ppp/ppp_generic.c                      |    8 +-
 drivers/net/team/team_mode_loadbalance.c           |    2 +-
 include/linux/bpf-cgroup.h                         |  182 ++-
 include/linux/bpf.h                                |  200 ++-
 include/linux/bpf_types.h                          |    3 +
 include/linux/bpfptr.h                             |   12 +-
 include/linux/btf_ids.h                            |    9 +-
 include/linux/filter.h                             |   66 +-
 include/linux/perf_event.h                         |    1 +
 include/linux/trace_events.h                       |    7 +-
 include/net/af_unix.h                              |    8 +-
 include/uapi/linux/bpf.h                           |   34 +-
 kernel/bpf/bpf_iter.c                              |    2 +-
 kernel/bpf/bpf_struct_ops.c                        |   22 +-
 kernel/bpf/bpf_task_storage.c                      |    6 +-
 kernel/bpf/btf.c                                   |    2 +
 kernel/bpf/cgroup.c                                |  198 ++-
 kernel/bpf/core.c                                  |   33 +-
 kernel/bpf/helpers.c                               |   20 +
 kernel/bpf/stackmap.c                              |    4 +-
 kernel/bpf/syscall.c                               |  167 +-
 kernel/bpf/task_iter.c                             |   11 +-
 kernel/bpf/trampoline.c                            |    2 +-
 kernel/bpf/verifier.c                              |    6 +-
 kernel/events/core.c                               |   77 +-
 kernel/trace/bpf_trace.c                           |   72 +-
 lib/test_bpf.c                                     |    4 +-
 net/bpf/test_run.c                                 |    6 +-
 net/core/filter.c                                  |   38 +-
 net/core/ptp_classifier.c                          |    2 +-
 net/core/sock_map.c                                |    1 +
 net/ipv4/af_inet.c                                 |    6 +-
 net/ipv4/bpf_tcp_ca.c                              |   41 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv6/af_inet6.c                                |    6 +-
 net/ipv6/udp.c                                     |    2 +-
 net/netfilter/xt_bpf.c                             |    2 +-
 net/sched/act_bpf.c                                |    4 +-
 net/sched/cls_bpf.c                                |    4 +-
 net/unix/af_unix.c                                 |  189 ++-
 net/unix/unix_bpf.c                                |   93 +-
 samples/bpf/Makefile                               |  109 +-
 samples/bpf/Makefile.target                        |   11 +
 samples/bpf/cookie_uid_helper_example.c            |   11 +-
 samples/bpf/offwaketime_kern.c                     |    9 +-
 samples/bpf/tracex4_user.c                         |    2 +-
 samples/bpf/xdp_monitor.bpf.c                      |    8 +
 samples/bpf/xdp_monitor_kern.c                     |  257 ---
 samples/bpf/xdp_monitor_user.c                     |  798 +---------
 samples/bpf/xdp_redirect.bpf.c                     |   49 +
 ..._redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} |  393 ++---
 samples/bpf/xdp_redirect_cpu_user.c                | 1106 ++++---------
 samples/bpf/xdp_redirect_kern.c                    |   90 --
 ..._redirect_map_kern.c => xdp_redirect_map.bpf.c} |   89 +-
 ...p_multi_kern.c => xdp_redirect_map_multi.bpf.c} |   50 +-
 samples/bpf/xdp_redirect_map_multi_user.c          |  345 ++--
 samples/bpf/xdp_redirect_map_user.c                |  385 ++---
 samples/bpf/xdp_redirect_user.c                    |  270 ++--
 samples/bpf/xdp_sample.bpf.c                       |  266 ++++
 samples/bpf/xdp_sample.bpf.h                       |  141 ++
 samples/bpf/xdp_sample_shared.h                    |   17 +
 samples/bpf/xdp_sample_user.c                      | 1673 ++++++++++++++++++++
 samples/bpf/xdp_sample_user.h                      |  108 ++
 tools/include/uapi/linux/bpf.h                     |   34 +-
 tools/include/uapi/linux/ethtool.h                 |   53 +
 tools/lib/bpf/Makefile                             |   10 +-
 tools/lib/bpf/bpf.c                                |   32 +-
 tools/lib/bpf/bpf.h                                |    8 +-
 tools/lib/bpf/libbpf.c                             |  229 ++-
 tools/lib/bpf/libbpf.h                             |   75 +-
 tools/lib/bpf/libbpf.map                           |    3 +
 tools/lib/bpf/libbpf_internal.h                    |   32 +-
 tools/testing/selftests/bpf/Makefile               |    4 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   19 +
 tools/testing/selftests/bpf/network_helpers.c      |   23 +-
 tools/testing/selftests/bpf/network_helpers.h      |    6 +
 .../selftests/bpf/prog_tests/attach_probe.c        |   98 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  254 +++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   16 +
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |  106 +-
 .../testing/selftests/bpf/prog_tests/btf_module.c  |   34 +
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    2 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   31 +
 .../selftests/bpf/prog_tests/netns_cookie.c        |   80 +
 tools/testing/selftests/bpf/prog_tests/perf_link.c |   89 ++
 .../testing/selftests/bpf/prog_tests/send_signal.c |   61 +-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |    4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   79 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |    4 +-
 .../selftests/bpf/prog_tests/sockopt_qos_to_cc.c   |   70 +
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   47 +
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |   16 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |    6 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   25 +
 .../selftests/bpf/progs/bpf_dctcp_release.c        |   26 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |    8 +
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c  |   80 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    4 +
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |    4 +-
 .../selftests/bpf/progs/netns_cookie_prog.c        |   84 +
 .../selftests/bpf/progs/sockopt_qos_to_cc.c        |   39 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   16 +
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |   85 +
 .../selftests/bpf/progs/test_core_autosize.c       |   20 +-
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |   56 +
 tools/testing/selftests/bpf/progs/test_perf_link.c |   16 +
 tools/testing/selftests/bpf/progs/test_snprintf.c  |    6 +-
 .../selftests/bpf/progs/test_task_pt_regs.c        |   29 +
 tools/testing/selftests/bpf/test_bpftool.sh        |    6 +
 tools/testing/selftests/bpf/test_bpftool_build.sh  |    2 +-
 tools/testing/selftests/bpf/test_doc_build.sh      |   10 +-
 tools/testing/selftests/bpf/test_maps.c            |   18 +-
 tools/testing/selftests/bpf/test_progs.c           |  107 +-
 tools/testing/selftests/bpf/test_xsk.sh            |   10 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   87 +
 tools/testing/selftests/bpf/trace_helpers.h        |    4 +
 tools/testing/selftests/bpf/xdpxceiver.c           |  681 ++++----
 tools/testing/selftests/bpf/xdpxceiver.h           |   63 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |   30 +-
 126 files changed, 6813 insertions(+), 4027 deletions(-)
 rename Documentation/bpf/libbpf/{libbpf.rst => index.rst} (75%)
 delete mode 100644 Documentation/bpf/libbpf/libbpf_api.rst
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)
 delete mode 100644 samples/bpf/xdp_redirect_kern.c
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (57%)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_module.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_link.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockopt_qos_to_cc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_pt_regs.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp_release.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_qos_to_cc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_cookie.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_weak.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_task_pt_regs.c
