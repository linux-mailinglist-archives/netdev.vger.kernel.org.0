Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4455562CF8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 02:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfGIANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 20:13:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:50236 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfGIANy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 20:13:54 -0400
Received: from [178.193.45.231] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hkdlX-0007Zu-LQ; Tue, 09 Jul 2019 02:13:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-07-09
Date:   Tue,  9 Jul 2019 02:13:51 +0200
Message-Id: <20190709001351.8848-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25504/Mon Jul  8 10:05:57 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

The main changes are:

1) Lots of libbpf improvements: i) addition of new APIs to attach BPF
   programs to tracing entities such as {k,u}probes or tracepoints,
   ii) improve specification of BTF-defined maps by eliminating the
   need for data initialization for some of the members, iii) addition
   of a high-level API for setting up and polling perf buffers for
   BPF event output helpers, all from Andrii.

2) Add "prog run" subcommand to bpftool in order to test-run programs
   through the kernel testing infrastructure of BPF, from Quentin.

3) Improve verifier for BPF sockaddr programs to support 8-byte stores
   for user_ip6 and msg_src_ip6 members given clang tends to generate
   such stores, from Stanislav.

4) Enable the new BPF JIT zero-extension optimization for further
   riscv64 ALU ops, from Luke.

5) Fix a bpftool json JIT dump crash on powerpc, from Jiri.

6) Fix an AF_XDP race in generic XDP's receive path, from Ilya.

7) Various smaller fixes from Ilya, Yue and Arnd.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit c4cde5804d512a2f8934017dbf7df642dfbdf2ad:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2019-07-04 12:48:21 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to bf0bdd1343efbbf65b4d53aef1fce14acbd79d50:

  xdp: fix race on generic receive path (2019-07-09 01:43:26 +0200)

----------------------------------------------------------------
Andrii Nakryiko (19):
      libbpf: make libbpf_strerror_r agnostic to sign of error
      libbpf: introduce concept of bpf_link
      libbpf: add ability to attach/detach BPF program to perf event
      libbpf: add kprobe/uprobe attach API
      libbpf: add tracepoint attach API
      libbpf: add raw tracepoint attach API
      selftests/bpf: switch test to new attach_perf_event API
      selftests/bpf: add kprobe/uprobe selftests
      selftests/bpf: convert existing tracepoint tests to new APIs
      libbpf: capture value in BTF type info for BTF-defined map defs
      selftests/bpf: add __uint and __type macro for BTF-defined maps
      selftests/bpf: convert selftests using BTF-defined maps to new syntax
      selftests/bpf: convert legacy BPF maps to BTF-defined ones
      libbpf: add perf buffer API
      libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
      selftests/bpf: test perf buffer API
      tools/bpftool: switch map event_pipe to libbpf's perf_buffer
      libbpf: add perf_buffer_ prefix to README
      selftests/bpf: fix test_attach_probe map definition

Arnd Bergmann (1):
      bpf: avoid unused variable warning in tcp_bpf_rtt()

Daniel Borkmann (4):
      Merge branch 'bpf-libbpf-link-trace'
      Merge branch 'bpf-libbpf-int-btf-map'
      Merge branch 'bpf-libbpf-perf-rb-api'
      Merge branch 'bpf-sockaddr-wide-store'

Ilya Leoshkevich (1):
      selftests/bpf: fix test_reuseport_array on s390

Ilya Maximets (1):
      xdp: fix race on generic receive path

Jiri Olsa (1):
      tools: bpftool: Fix json dump crash on powerpc

Luke Nelson (1):
      bpf, riscv: Enable zext optimization for more RV64G ALU ops

Quentin Monnet (2):
      tools: bpftool: add "prog run" subcommand to test-run programs
      tools: bpftool: add completion for bpftool prog "loadall"

Stanislav Fomichev (5):
      selftests/bpf: fix test_align liveliness expectations
      selftests/bpf: add test_tcp_rtt to .gitignore
      bpf: allow wide (u64) aligned stores for some fields of bpf_sock_addr
      bpf: sync bpf.h to tools/
      selftests/bpf: add verifier tests for wide stores

YueHaibing (1):
      bpf: cgroup: Fix build error without CONFIG_NET

 arch/riscv/net/bpf_jit_comp.c                      |  16 +-
 include/linux/filter.h                             |   6 +
 include/net/tcp.h                                  |   4 +-
 include/net/xdp_sock.h                             |   2 +
 include/uapi/linux/bpf.h                           |   6 +-
 kernel/bpf/cgroup.c                                |   4 +
 net/core/filter.c                                  |  22 +-
 net/xdp/xsk.c                                      |  31 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  34 +
 tools/bpf/bpftool/bash-completion/bpftool          |  35 +-
 tools/bpf/bpftool/jit_disasm.c                     |  11 +-
 tools/bpf/bpftool/main.c                           |  29 +
 tools/bpf/bpftool/main.h                           |   1 +
 tools/bpf/bpftool/map_perf_ring.c                  | 201 ++---
 tools/bpf/bpftool/prog.c                           | 348 ++++++++-
 tools/include/linux/sizes.h                        |  48 ++
 tools/include/uapi/linux/bpf.h                     |   6 +-
 tools/lib/bpf/README.rst                           |   3 +-
 tools/lib/bpf/libbpf.c                             | 822 ++++++++++++++++++++-
 tools/lib/bpf/libbpf.h                             |  70 ++
 tools/lib/bpf/libbpf.map                           |  12 +-
 tools/lib/bpf/str_error.c                          |   2 +-
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/bpf_helpers.h          |   3 +
 .../selftests/bpf/prog_tests/attach_probe.c        | 166 +++++
 .../testing/selftests/bpf/prog_tests/perf_buffer.c | 100 +++
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |  55 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |  31 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |  43 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |  15 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |  28 +-
 .../selftests/bpf/progs/get_cgroup_id_kern.c       |  26 +-
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |  20 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |  90 +--
 .../selftests/bpf/progs/socket_cookie_prog.c       |  13 +-
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |  48 +-
 tools/testing/selftests/bpf/progs/strobemeta.h     |  68 +-
 .../selftests/bpf/progs/test_attach_probe.c        |  52 ++
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |  13 +-
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |  39 +-
 .../testing/selftests/bpf/progs/test_global_data.c |  37 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c      |  65 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |  65 +-
 .../testing/selftests/bpf/progs/test_map_in_map.c  |  30 +-
 tools/testing/selftests/bpf/progs/test_map_lock.c  |  26 +-
 tools/testing/selftests/bpf/progs/test_obj_id.c    |  12 +-
 .../testing/selftests/bpf/progs/test_perf_buffer.c |  25 +
 .../bpf/progs/test_select_reuseport_kern.c         |  67 +-
 .../selftests/bpf/progs/test_send_signal_kern.c    |  26 +-
 .../selftests/bpf/progs/test_sock_fields_kern.c    |  78 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |  36 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |  55 +-
 .../selftests/bpf/progs/test_stacktrace_map.c      |  52 +-
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |  13 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  26 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |  28 +-
 tools/testing/selftests/bpf/progs/test_xdp.c       |  26 +-
 tools/testing/selftests/bpf/progs/test_xdp_loop.c  |  26 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |  81 +-
 .../testing/selftests/bpf/progs/xdp_redirect_map.c |  12 +-
 tools/testing/selftests/bpf/progs/xdping_kern.c    |  12 +-
 tools/testing/selftests/bpf/test_align.c           |  16 +-
 tools/testing/selftests/bpf/test_maps.c            |  21 +-
 tools/testing/selftests/bpf/test_queue_stack_map.h |  30 +-
 tools/testing/selftests/bpf/test_sockmap_kern.h    | 110 +--
 tools/testing/selftests/bpf/test_verifier.c        |  17 +-
 tools/testing/selftests/bpf/verifier/wide_store.c  |  36 +
 67 files changed, 2490 insertions(+), 1062 deletions(-)
 create mode 100644 tools/include/linux/sizes.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/verifier/wide_store.c
