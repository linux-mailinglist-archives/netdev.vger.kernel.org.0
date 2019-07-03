Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0235EF41
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 00:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfGCWru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 18:47:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:52032 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfGCWrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 18:47:49 -0400
Received: from [178.193.45.231] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hio2O-0005fm-Ua; Thu, 04 Jul 2019 00:47:41 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, saeedm@mellanox.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-07-03
Date:   Thu,  4 Jul 2019 00:47:40 +0200
Message-Id: <20190703224740.15354-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

There is a minor merge conflict in mlx5 due to 8960b38932be ("linux/dim:
Rename externally used net_dim members") which has been pulled into your
tree in the meantime, but resolution seems not that bad ... getting current
bpf-next out now before there's coming more on mlx5. ;) I'm Cc'ing Saeed
just so he's aware of the resolution below:

** First conflict in drivers/net/ethernet/mellanox/mlx5/core/en_main.c:

  <<<<<<< HEAD
  static int mlx5e_open_cq(struct mlx5e_channel *c,
                           struct dim_cq_moder moder,
                           struct mlx5e_cq_param *param,
                           struct mlx5e_cq *cq)
  =======
  int mlx5e_open_cq(struct mlx5e_channel *c, struct net_dim_cq_moder moder,
                    struct mlx5e_cq_param *param, struct mlx5e_cq *cq)
  >>>>>>> e5a3e259ef239f443951d401db10db7d426c9497

Resolution is to take the second chunk and rename net_dim_cq_moder into
dim_cq_moder. Also the signature for mlx5e_open_cq() in ...

  drivers/net/ethernet/mellanox/mlx5/core/en.h +977

... and in mlx5e_open_xsk() ...

  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c +64

... needs the same rename from net_dim_cq_moder into dim_cq_moder.

** Second conflict in drivers/net/ethernet/mellanox/mlx5/core/en_main.c:

  <<<<<<< HEAD
          int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
          struct dim_cq_moder icocq_moder = {0, 0};
          struct net_device *netdev = priv->netdev;
          struct mlx5e_channel *c;
          unsigned int irq;
  =======
          struct net_dim_cq_moder icocq_moder = {0, 0};
  >>>>>>> e5a3e259ef239f443951d401db10db7d426c9497

Take the second chunk and rename net_dim_cq_moder into dim_cq_moder
as well.

Let me know if you run into any issues. Anyway, the main changes are:

1) Long-awaited AF_XDP support for mlx5e driver, from Maxim.

2) Addition of two new per-cgroup BPF hooks for getsockopt and
   setsockopt along with a new sockopt program type which allows more
   fine-grained pass/reject settings for containers. Also add a sock_ops
   callback that can be selectively enabled on a per-socket basis and is
   executed for every RTT to help tracking TCP statistics, both features
   from Stanislav.

3) Follow-up fix from loops in precision tracking which was not propagating
   precision marks and as a result verifier assumed that some branches were
   not taken and therefore wrongly removed as dead code, from Alexei.

4) Fix BPF cgroup release synchronization race which could lead to a
   double-free if a leaf's cgroup_bpf object is released and a new BPF
   program is attached to the one of ancestor cgroups in parallel, from Roman.

5) Support for bulking XDP_TX on veth devices which improves performance
   in some cases by around 9%, from Toshiaki.

6) Allow for lookups into BPF devmap and improve feedback when calling into
   bpf_redirect_map() as lookup is now performed right away in the helper
   itself, from Toke.

7) Add support for fq's Earliest Departure Time to the Host Bandwidth
   Manager (HBM) sample BPF program, from Lawrence.

8) Various cleanups and minor fixes all over the place from many others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 7d30a7f6424e88c958c19a02f6f54ab8d25919cd:

  Merge branch 'ipv6-avoid-taking-refcnt-on-dst-during-route-lookup' (2019-06-23 13:24:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to e5a3e259ef239f443951d401db10db7d426c9497:

  Merge branch 'bpf-tcp-rtt-hook' (2019-07-03 16:52:03 +0200)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'bpf-sockopt-hooks'
      bpf: fix precision tracking

Andrii Nakryiko (2):
      selftests/bpf: build tests with debug info
      libbpf: fix GCC8 warning for strncpy

Colin Ian King (1):
      libbpf: fix spelling mistake "conflictling" -> "conflicting"

Daniel Borkmann (3):
      Merge branch 'bpf-af-xdp-mlx5e'
      Merge branch 'bpf-lookup-devmap'
      Merge branch 'bpf-tcp-rtt-hook'

Daniel T. Lee (1):
      samples: bpf: make the use of xdp samples consistent

Eric Leblond (1):
      xsk: sample kernel code is now in libbpf

Ivan Khoronzhuk (1):
      libbpf: fix max() type mismatch for 32bit

Jiri Benc (1):
      selftests: bpf: standardize to static __always_inline

Leo Yan (1):
      bpf, libbpf, smatch: Fix potential NULL pointer dereference

Maxim Mikityanskiy (16):
      net/mlx5e: Attach/detach XDP program safely
      xsk: Add API to check for available entries in FQ
      xsk: Add getsockopt XDP_OPTIONS
      libbpf: Support getsockopt XDP_OPTIONS
      xsk: Change the default frame size to 4096 and allow controlling it
      xsk: Return the whole xdp_desc from xsk_umem_consume_tx
      net/mlx5e: Replace deprecated PCI_DMA_TODEVICE
      net/mlx5e: Calculate linear RX frag size considering XSK
      net/mlx5e: Allow ICO SQ to be used by multiple RQs
      net/mlx5e: Refactor struct mlx5e_xdp_info
      net/mlx5e: Share the XDP SQ for XDP_TX between RQs
      net/mlx5e: XDP_TX from UMEM support
      net/mlx5e: Consider XSK in XDP MTU limit calculation
      net/mlx5e: Encapsulate open/close queues into a function
      net/mlx5e: Move queue param structs to en/params.h
      net/mlx5e: Add XSK zero-copy support

Michal Rostecki (1):
      samples: bpf: Remove bpf_debug macro in favor of bpf_printk

Roman Gushchin (1):
      bpf: fix cgroup bpf release synchronization

Stanislav Fomichev (18):
      bpf: implement getsockopt and setsockopt hooks
      bpf: sync bpf.h to tools/
      libbpf: support sockopt hooks
      selftests/bpf: test sockopt section name
      selftests/bpf: add sockopt test
      selftests/bpf: add sockopt test that exercises sk helpers
      selftests/bpf: add sockopt test that exercises BPF_F_ALLOW_MULTI
      bpf: add sockopt documentation
      bpftool: support cgroup sockopt
      selftests/bpf: fix -Wstrict-aliasing in test_sockopt_sk.c
      bpf: add BPF_CGROUP_SOCK_OPS callback that is executed on every RTT
      bpf: split shared bpf_tcp_sock and bpf_sock_ops implementation
      bpf: add dsack_dups/delivered{, _ce} to bpf_tcp_sock
      bpf: add icsk_retransmits to bpf_tcp_sock
      bpf/tools: sync bpf.h
      selftests/bpf: test BPF_SOCK_OPS_RTT_CB
      samples/bpf: add sample program that periodically dumps TCP stats
      samples/bpf: fix tcp_bpf.readme detach command

Toke Høiland-Jørgensen (5):
      xskmap: Move non-standard list manipulation to helper
      devmap/cpumap: Use flush list instead of bitmap
      devmap: Rename ifindex member in bpf_redirect_info
      bpf_xdp_redirect_map: Perform map lookup in eBPF helper
      devmap: Allow map lookups from eBPF

Toshiaki Makita (3):
      selftests, bpf: Add test for veth native XDP
      xdp: Add tracepoint for bulk XDP_TX
      veth: Support bulk XDP_TX

Yonghong Song (1):
      bpf: fix compiler warning with CONFIG_MODULES=n

YueHaibing (1):
      xdp: Make __mem_id_disconnect static

brakmo (1):
      bpf: Add support for fq's EDT to HBM

 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/prog_cgroup_sockopt.rst          |   93 ++
 Documentation/networking/af_xdp.rst                |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  155 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  108 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  118 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  231 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   36 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/Makefile    |    1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  192 ++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   27 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  223 +++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |   25 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  111 +++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |   15 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  267 +++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   31 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   25 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  730 +++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  104 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  115 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   30 +
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   42 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |    5 -
 drivers/net/veth.c                                 |   60 +-
 include/linux/bpf-cgroup.h                         |   45 +
 include/linux/bpf.h                                |    2 +
 include/linux/bpf_types.h                          |    1 +
 include/linux/filter.h                             |   13 +-
 include/linux/list.h                               |   14 +
 include/net/tcp.h                                  |    8 +
 include/net/xdp_sock.h                             |   27 +-
 include/trace/events/xdp.h                         |   34 +-
 include/uapi/linux/bpf.h                           |   33 +-
 include/uapi/linux/if_xdp.h                        |    8 +
 kernel/bpf/cgroup.c                                |  352 ++++++-
 kernel/bpf/core.c                                  |   10 +
 kernel/bpf/cpumap.c                                |  105 +-
 kernel/bpf/devmap.c                                |  112 +--
 kernel/bpf/syscall.c                               |   19 +
 kernel/bpf/verifier.c                              |  136 ++-
 kernel/bpf/xskmap.c                                |    3 +-
 kernel/trace/bpf_trace.c                           |   27 +-
 net/core/filter.c                                  |  269 ++++--
 net/core/xdp.c                                     |    2 +-
 net/ipv4/tcp_input.c                               |    4 +
 net/socket.c                                       |   30 +
 net/xdp/xsk.c                                      |   36 +-
 net/xdp/xsk_queue.h                                |   14 +
 samples/bpf/Makefile                               |    3 +
 samples/bpf/do_hbm_test.sh                         |   22 +-
 samples/bpf/hbm.c                                  |   18 +-
 samples/bpf/hbm_edt_kern.c                         |  168 ++++
 samples/bpf/hbm_kern.h                             |   40 +-
 samples/bpf/ibumad_kern.c                          |   18 +-
 samples/bpf/tcp_bpf.readme                         |    2 +-
 samples/bpf/tcp_dumpstats_kern.c                   |   68 ++
 samples/bpf/xdp_adjust_tail_user.c                 |   12 +-
 samples/bpf/xdp_redirect_map_user.c                |   15 +-
 samples/bpf/xdp_redirect_user.c                    |   15 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |   12 +-
 samples/bpf/xdpsock_user.c                         |   44 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    7 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    3 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    9 +-
 tools/bpf/bpftool/cgroup.c                         |    5 +-
 tools/bpf/bpftool/main.h                           |    1 +
 tools/bpf/bpftool/prog.c                           |    3 +-
 tools/include/uapi/linux/bpf.h                     |   26 +-
 tools/include/uapi/linux/if_xdp.h                  |    8 +
 tools/lib/bpf/libbpf.c                             |   23 +-
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/lib/bpf/xsk.c                                |   15 +-
 tools/lib/bpf/xsk.h                                |    2 +-
 tools/testing/selftests/bpf/.gitignore             |    3 +
 tools/testing/selftests/bpf/Makefile               |   10 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |    9 +-
 tools/testing/selftests/bpf/progs/sockopt_multi.c  |   71 ++
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |  111 +++
 tools/testing/selftests/bpf/progs/strobemeta.h     |   36 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c        |   61 ++
 tools/testing/selftests/bpf/progs/test_jhash.h     |    3 +-
 tools/testing/selftests/bpf/progs/test_seg6_loop.c |   23 +-
 .../selftests/bpf/progs/test_verif_scale2.c        |    2 +-
 .../testing/selftests/bpf/progs/xdp_redirect_map.c |   31 +
 tools/testing/selftests/bpf/progs/xdp_tx.c         |   12 +
 tools/testing/selftests/bpf/test_section_names.c   |   10 +
 tools/testing/selftests/bpf/test_sockopt.c         | 1021 ++++++++++++++++++++
 tools/testing/selftests/bpf/test_sockopt_multi.c   |  374 +++++++
 tools/testing/selftests/bpf/test_sockopt_sk.c      |  211 ++++
 tools/testing/selftests/bpf/test_tcp_rtt.c         |  254 +++++
 tools/testing/selftests/bpf/test_xdp_veth.sh       |  118 +++
 98 files changed, 6197 insertions(+), 841 deletions(-)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
 create mode 100644 samples/bpf/hbm_edt_kern.c
 create mode 100644 samples/bpf/tcp_dumpstats_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_rtt.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_tx.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_multi.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c
 create mode 100644 tools/testing/selftests/bpf/test_tcp_rtt.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_veth.sh
