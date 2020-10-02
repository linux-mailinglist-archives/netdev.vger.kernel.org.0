Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211D8281571
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbgJBOmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:24 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E01206FA;
        Fri,  2 Oct 2020 14:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649743;
        bh=6aooMorPufXd+5j7fELEzmOtThmUf51bnUTcnnVnnBM=;
        h=From:To:Cc:Subject:Date:From;
        b=pLMteHAbEu4zFoyT8YQ2k4giDh8kQfsBaAwS7Y6mlTAEH5wiid/BE5+zLD0P/UkPt
         cj4aXxYEEHngdemJUV+9qY3rDJFOlJMIGmmMoyUvu2EEnRXtX2xtZvzKt0sQHrrLTH
         3mRLf4y1AiIju8hevheKxxVeEE1ScfYfvg7igqn0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer support
Date:   Fri,  2 Oct 2020 16:41:58 +0200
Message-Id: <cover.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce XDP multi-buffer support. The mvneta driver is
the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
please focus on how these new types of xdp_{buff,frame} packets
traverse the different layers and the layout design. It is on purpose
that BPF-helpers are kept simple, as we don't want to expose the
internal layout to allow later changes.

For now, to keep the design simple and to maintain performance, the XDP
BPF-prog (still) only have access to the first-buffer. It is left for
later (another patchset) to add payload access across multiple buffers.
This patchset should still allow for these future extensions. The goal
is to lift the XDP MTU restriction that comes with XDP, but maintain
same performance as before.

The main idea for the new multi-buffer layout is to reuse the same
layout used for non-linear SKB. This rely on the "skb_shared_info"
struct at the end of the first buffer to link together subsequent
buffers. Keeping the layout compatible with SKBs is also done to ease
and speedup creating an SKB from an xdp_{buff,frame}. Converting
xdp_frame to SKB and deliver it to the network stack is shown in cpumap
code (patch 13/13).

A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
to notify the bpf/network layer if this is a xdp multi-buffer frame (mb = 1)
or not (mb = 0).
The mb bit will be set by a xdp multi-buffer capable driver only for
non-linear frames maintaining the capability to receive linear frames
without any extra cost since the skb_shared_info structure at the end
of the first buffer will be initialized only if mb is set.

In order to provide to userspace some metdata about the non-linear
xdp_{buff,frame}, we introduced 2 bpf helpers:
- bpf_xdp_get_frags_count:
  get the number of fragments for a given xdp multi-buffer.
- bpf_xdp_get_frags_total_size:
  get the total size of fragments for a given xdp multi-buffer.

Typical use cases for this series are:
- Jumbo-frames
- Packet header split (please see Google’s use-case @ NetDevConf 0x14, [0])
- TSO

More info about the main idea behind this approach can be found here [1][2].

We carried out some throughput tests in a standard linear frame scenario in order
to verify we did not introduced any performance regression adding xdp multi-buff
support to mvneta:

offered load is ~ 1000Kpps, packet size is 64B, mvneta descriptor size is one PAGE

commit: 879456bedbe5 ("net: mvneta: avoid possible cache misses in mvneta_rx_swbm")
- xdp-pass:      ~162Kpps
- xdp-drop:      ~701Kpps
- xdp-tx:        ~185Kpps
- xdp-redirect:  ~202Kpps

mvneta xdp multi-buff:
- xdp-pass:      ~163Kpps
- xdp-drop:      ~739Kpps
- xdp-tx:        ~182Kpps
- xdp-redirect:  ~202Kpps

Changes since v3:
- rebase ontop of bpf-next
- add patch 10/13 to copy back paged data from a xdp multi-buff frame to
  userspace buffer for xdp multi-buff selftests

Changes since v2:
- add throughput measurements
- drop bpf_xdp_adjust_mb_header bpf helper
- introduce selftest for xdp multibuffer
- addressed comments on bpf_xdp_get_frags_count
- introduce xdp multi-buff support to cpumaps

Changes since v1:
- Fix use-after-free in xdp_return_{buff/frame}
- Introduce bpf helpers
- Introduce xdp_mb sample program
- access skb_shared_info->nr_frags only on the last fragment

Changes since RFC:
- squash multi-buffer bit initialization in a single patch
- add mvneta non-linear XDP buff support for tx side

[0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
[2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)

Lorenzo Bianconi (11):
  xdp: introduce mb in xdp_buff/xdp_frame
  xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  bpf: move user_size out of bpf_test_init
  bpf: introduce multibuff support to bpf_prog_test_run_xdp()
  bpf: test_run: add skb_shared_info pointer in bpf_test_finish
    signature
  bpf: add xdp multi-buffer selftest
  net: mvneta: enable jumbo frames for XDP
  bpf: cpumap: introduce xdp multi-buff support

Sameeh Jubran (2):
  bpf: introduce bpf_xdp_get_frags_{count, total_size} helpers
  samples/bpf: add bpf program that uses xdp mb helpers

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         | 131 +++++++------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
 drivers/net/ethernet/sfc/rx.c                 |   1 +
 drivers/net/ethernet/socionext/netsec.c       |   1 +
 drivers/net/ethernet/ti/cpsw.c                |   1 +
 drivers/net/ethernet/ti/cpsw_new.c            |   1 +
 drivers/net/hyperv/netvsc_bpf.c               |   1 +
 drivers/net/tun.c                             |   2 +
 drivers/net/veth.c                            |   1 +
 drivers/net/virtio_net.c                      |   2 +
 drivers/net/xen-netfront.c                    |   1 +
 include/net/xdp.h                             |  31 ++-
 include/uapi/linux/bpf.h                      |  14 ++
 kernel/bpf/cpumap.c                           |  45 +----
 net/bpf/test_run.c                            | 118 ++++++++++--
 net/core/dev.c                                |   1 +
 net/core/filter.c                             |  42 ++++
 net/core/xdp.c                                | 104 ++++++++++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_mb_kern.c                     |  68 +++++++
 samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  14 ++
 .../testing/selftests/bpf/prog_tests/xdp_mb.c |  79 ++++++++
 .../selftests/bpf/progs/test_xdp_multi_buff.c |  24 +++
 36 files changed, 757 insertions(+), 123 deletions(-)
 create mode 100644 samples/bpf/xdp_mb_kern.c
 create mode 100644 samples/bpf/xdp_mb_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c

-- 
2.26.2

