Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB601DF37F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgEWA0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:26:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:33160 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387456AbgEWA0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 20:26:13 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHzN-0004mX-CR; Sat, 23 May 2020 02:26:09 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2020-05-23
Date:   Sat, 23 May 2020 02:26:08 +0200
Message-Id: <20200523002608.31415-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 50 non-merge commits during the last 8 day(s) which contain
a total of 109 files changed, 2776 insertions(+), 2887 deletions(-).

The main changes are:

1) Add a new AF_XDP buffer allocation API to the core in order to help
   lowering the bar for drivers adopting AF_XDP support. i40e, ice, ixgbe
   as well as mlx5 have been moved over to the new API and also gained a
   small improvement in performance, from Björn Töpel and Magnus Karlsson.

2) Add getpeername()/getsockname() attach types for BPF sock_addr programs
   in order to allow for e.g. reverse translation of load-balancer backend
   to service address/port tuple from a connected peer, from Daniel Borkmann.

3) Improve the BPF verifier is_branch_taken() logic to evaluate pointers
   being non-NULL, e.g. if after an initial test another non-NULL test on
   that pointer follows in a given path, then it can be pruned right away,
   from John Fastabend.

4) Larger rework of BPF sockmap selftests to make output easier to understand
   and to reduce overall runtime as well as adding new BPF kTLS selftests
   that run in combination with sockmap, also from John Fastabend.

5) Batch of misc updates to BPF selftests including fixing up test_align
   to match verifier output again and moving it under test_progs, allowing
   bpf_iter selftest to compile on machines with older vmlinux.h, and
   updating config options for lirc and v6 segment routing helpers, from
   Stanislav Fomichev, Andrii Nakryiko and Alan Maguire.

6) Conversion of BPF tracing samples outdated internal BPF loader to use
   libbpf API instead, from Daniel T. Lee.

7) Follow-up to BPF kernel test infrastructure in order to fix a flake in
   the XDP selftests, from Jesper Dangaard Brouer.

8) Minor improvements to libbpf's internal hashmap implementation, from
   Ian Rogers.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrey Ignatov, Andrii Nakryiko, Jakub Sitnicki, 
Jesper Dangaard Brouer, Yonghong Song

----------------------------------------------------------------

The following changes since commit da07f52d3caf6c24c6dbffb5500f379d819e04bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-05-15 13:48:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to a5dfaa2ab94057dd75c7911143482a0a85593c14:

  selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh (2020-05-23 01:12:31 +0200)

----------------------------------------------------------------
Alan Maguire (3):
      selftests/bpf: Add general instructions for test execution
      selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
      selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh

Alexei Starovoitov (4):
      Merge branch 'getpeername'
      tools/bpf: sync bpf.h
      Merge branch 'af_xdp-common-alloc'
      Merge branch 'improve-branch_taken'

Andrii Nakryiko (2):
      selftest/bpf: Make bpf_iter selftest compilable against old vmlinux.h
      selftests/bpf: Convert bpf_iter_test_kern{3, 4}.c to define own bpf_iter_meta

Björn Töpel (14):
      xsk: Fix xsk_umem_xdp_frame_sz()
      xsk: Move xskmap.c to net/xdp/
      xsk: Move defines only used by AF_XDP internals to xsk.h
      xsk: Introduce AF_XDP buffer allocation API
      i40e: Refactor rx_bi accesses
      i40e: Separate kernel allocated rx_bi rings from AF_XDP rings
      i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL
      ice, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL
      ixgbe, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL
      mlx5, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL
      xsk: Remove MEM_TYPE_ZERO_COPY and corresponding code
      xdp: Simplify xdp_return_{frame, frame_rx_napi, buff}
      xsk: Explicitly inline functions and move definitions
      MAINTAINERS, xsk: Update AF_XDP section after moves/adds

Daniel Borkmann (5):
      bpf: Fix check_return_code to only allow [0,1] in trace_iter progs
      bpf: Add get{peer, sock}name attach types for sock_addr
      bpf, libbpf: Enable get{peer, sock}name attach types
      bpf, bpftool: Enable get{peer, sock}name attach types
      bpf, testing: Add get{peer, sock}name selftests to test_progs

Daniel T. Lee (5):
      samples, bpf: Refactor pointer error check with libbpf
      samples, bpf: Refactor kprobe tracing user progs with libbpf
      samples, bpf: Refactor tail call user progs with libbpf
      samples, bpf: Add tracex7 test file to .gitignore
      samples, bpf: Refactor kprobe, tail call kern progs map definition

Ian Rogers (2):
      libbpf, hashmap: Remove unused #include
      libbpf, hashmap: Fix signedness warnings

Jesper Dangaard Brouer (1):
      bpf: Fix too large copy from user in bpf_test_init

John Fastabend (14):
      bpf: Selftests, move sockmap bpf prog header into progs
      bpf: Selftests, remove prints from sockmap tests
      bpf: Selftests, sockmap test prog run without setting cgroup
      bpf: Selftests, print error in test_sockmap error cases
      bpf: Selftests, improve test_sockmap total bytes counter
      bpf: Selftests, break down test_sockmap into subtests
      bpf: Selftests, provide verbose option for selftests execution
      bpf: Selftests, add whitelist option to test_sockmap
      bpf: Selftests, add blacklist to test_sockmap
      bpf: Selftests, add ktls tests to test_sockmap
      bpf: Verifier track null pointer branch_taken with JNE and JEQ
      bpf: Selftests, verifier case for non null pointer check branch taken
      bpf: Selftests, verifier case for non null pointer map value branch
      bpf: Selftests, add printk to test_sk_lookup_kern to encode null ptr check

Magnus Karlsson (1):
      xsk: Move driver interface to xdp_sock_drv.h

Stanislav Fomichev (2):
      selftests/bpf: Fix test_align verifier log patterns
      selftests/bpf: Move test_align under test_progs

 Documentation/bpf/bpf_devel_QA.rst                 |  15 +
 MAINTAINERS                                        |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  28 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 134 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |  17 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx_common.h |  40 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 379 ++-------
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   3 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           | 378 +--------
 drivers/net/ethernet/intel/ice/ice_xsk.h           |  13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  15 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       | 309 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    | 113 +--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  25 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  51 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  25 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  34 +-
 drivers/net/hyperv/netvsc_bpf.c                    |   1 -
 include/linux/bpf-cgroup.h                         |   1 +
 include/net/xdp.h                                  |   9 +-
 include/net/xdp_sock.h                             | 287 +------
 include/net/xdp_sock_drv.h                         | 232 ++++++
 include/net/xsk_buff_pool.h                        | 140 ++++
 include/trace/events/xdp.h                         |   2 +-
 include/uapi/linux/bpf.h                           |   4 +
 kernel/bpf/Makefile                                |   3 -
 kernel/bpf/syscall.c                               |  12 +
 kernel/bpf/verifier.c                              |  45 +-
 net/bpf/test_run.c                                 |   8 +-
 net/core/filter.c                                  |   4 +
 net/core/xdp.c                                     |  51 +-
 net/ethtool/channels.c                             |   2 +-
 net/ethtool/ioctl.c                                |   2 +-
 net/ipv4/af_inet.c                                 |   8 +-
 net/ipv6/af_inet6.c                                |   9 +-
 net/xdp/Makefile                                   |   3 +-
 net/xdp/xdp_umem.c                                 |  55 +-
 net/xdp/xdp_umem.h                                 |   2 +-
 net/xdp/xsk.c                                      | 204 ++---
 net/xdp/xsk.h                                      |  30 +
 net/xdp/xsk_buff_pool.c                            | 336 ++++++++
 net/xdp/xsk_diag.c                                 |   2 +-
 net/xdp/xsk_queue.c                                |  63 +-
 net/xdp/xsk_queue.h                                | 117 +--
 {kernel/bpf => net/xdp}/xskmap.c                   |   2 +
 samples/bpf/.gitignore                             |   1 +
 samples/bpf/Makefile                               |  16 +-
 samples/bpf/sampleip_kern.c                        |  12 +-
 samples/bpf/sampleip_user.c                        |   7 +-
 samples/bpf/sockex3_kern.c                         |  36 +-
 samples/bpf/sockex3_user.c                         |  64 +-
 samples/bpf/trace_common.h                         |  13 +
 samples/bpf/trace_event_kern.c                     |  24 +-
 samples/bpf/trace_event_user.c                     |   9 +-
 samples/bpf/tracex1_user.c                         |  37 +-
 samples/bpf/tracex2_kern.c                         |  27 +-
 samples/bpf/tracex2_user.c                         |  51 +-
 samples/bpf/tracex3_kern.c                         |  24 +-
 samples/bpf/tracex3_user.c                         |  61 +-
 samples/bpf/tracex4_kern.c                         |  12 +-
 samples/bpf/tracex4_user.c                         |  51 +-
 samples/bpf/tracex5_kern.c                         |  14 +-
 samples/bpf/tracex5_user.c                         |  66 +-
 samples/bpf/tracex6_kern.c                         |  38 +-
 samples/bpf/tracex6_user.c                         |  49 +-
 samples/bpf/tracex7_user.c                         |  39 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   5 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  10 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   3 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  15 +-
 tools/bpf/bpftool/cgroup.c                         |   7 +-
 tools/bpf/bpftool/main.h                           |   4 +
 tools/bpf/bpftool/prog.c                           |   6 +-
 tools/include/uapi/linux/bpf.h                     |  10 +-
 tools/lib/bpf/hashmap.c                            |   5 +-
 tools/lib/bpf/hashmap.h                            |   1 -
 tools/lib/bpf/libbpf.c                             |   8 +
 tools/testing/selftests/bpf/README.rst             |   2 +
 tools/testing/selftests/bpf/config                 |   2 +
 tools/testing/selftests/bpf/network_helpers.c      |  11 +-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../bpf/{test_align.c => prog_tests/align.c}       | 109 +--
 .../selftests/bpf/prog_tests/connect_force_port.c  | 107 ++-
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |  16 +
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c      |  16 +
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |  16 +
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |  16 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |  18 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c      |  15 +
 .../selftests/bpf/progs/bpf_iter_test_kern4.c      |  15 +
 .../bpf/progs/bpf_iter_test_kern_common.h          |  16 +
 .../selftests/bpf/progs/connect_force_port4.c      |  59 +-
 .../selftests/bpf/progs/connect_force_port6.c      |  70 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |   1 +
 .../selftests/bpf/{ => progs}/test_sockmap_kern.h  | 158 +---
 tools/testing/selftests/bpf/test_sockmap.c         | 913 +++++++++++----------
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  33 +
 .../testing/selftests/bpf/verifier/value_or_null.c |  19 +
 109 files changed, 2776 insertions(+), 2887 deletions(-)
 create mode 100644 include/net/xdp_sock_drv.h
 create mode 100644 include/net/xsk_buff_pool.h
 create mode 100644 net/xdp/xsk_buff_pool.c
 rename {kernel/bpf => net/xdp}/xskmap.c (99%)
 create mode 100644 samples/bpf/trace_common.h
 rename tools/testing/selftests/bpf/{test_align.c => prog_tests/align.c} (91%)
 rename tools/testing/selftests/bpf/{ => progs}/test_sockmap_kern.h (61%)
