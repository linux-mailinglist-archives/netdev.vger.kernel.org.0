Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B892D1609
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgLGQdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:33:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgLGQdf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 11:33:35 -0500
From:   Lorenzo Bianconi <lorenzo@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        jasowang@redhat.com
Subject: [PATCH v5 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
Date:   Mon,  7 Dec 2020 17:32:29 +0100
Message-Id: <cover.1607349924.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
layout used for non-linear SKB. We introduced a "xdp_shared_info" data
structure at the end of the first buffer to link together subsequent buffers.
xdp_shared_info will alias skb_shared_info allowing to keep most of the frags
in the same cache-line (while with skb_shared_info only the first fragment will
be placed in the first "shared_info" cache-line). Moreover we introduced some
xdp_shared_info helpers aligned to skb_frag* ones.
Converting xdp_frame to SKB and deliver it to the network stack is shown in
cpumap code (patch 11/14). Building the SKB, the xdp_shared_info structure
will be converted in a skb_shared_info one.

A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
to notify the bpf/network layer if this is a xdp multi-buffer frame (mb = 1)
or not (mb = 0).
The mb bit will be set by a xdp multi-buffer capable driver only for
non-linear frames maintaining the capability to receive linear frames
without any extra cost since the xdp_shared_info structure at the end
of the first buffer will be initialized only if mb is set.

Typical use cases for this series are:
- Jumbo-frames
- Packet header split (please see Google’s use-case @ NetDevConf 0x14, [0])
- TSO

A new frame_length field has been introduce in XDP ctx in order to notify the
eBPF layer about the total frame size (linear + paged parts).

bpf_xdp_adjust_tail helper has been modified to take info account xdp
multi-buff frames.

More info about the main idea behind this approach can be found here [1][2].

Changes since v4:
- rebase ontop of bpf-next
- introduce xdp_shared_info to build xdp multi-buff instead of using the
  skb_shared_info struct
- introduce frame_length in xdp ctx
- drop previous bpf helpers
- fix bpf_xdp_adjust_tail for xdp multi-buff
- introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
- fix xdp_return_frame_bulk for xdp multi-buff

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

Eelco Chaudron (3):
  bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
  bpf: add new frame_length field to the XDP ctx
  bpf: update xdp_adjust_tail selftest to include multi-buffer

Lorenzo Bianconi (11):
  xdp: introduce mb in xdp_buff/xdp_frame
  xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
  xdp: add xdp_shared_info data structure
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  bpf: move user_size out of bpf_test_init
  bpf: introduce multibuff support to bpf_prog_test_run_xdp()
  bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
    signature
  net: mvneta: enable jumbo frames for XDP
  bpf: cpumap: introduce xdp multi-buff support

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         | 181 ++++++++++--------
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
 include/net/xdp.h                             | 111 ++++++++++-
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/cpumap.c                           |  45 +----
 kernel/bpf/verifier.c                         |   2 +-
 net/bpf/test_run.c                            | 107 +++++++++--
 net/core/dev.c                                |   1 +
 net/core/filter.c                             | 146 ++++++++++++++
 net/core/xdp.c                                | 150 ++++++++++++++-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  16 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 +++-
 35 files changed, 761 insertions(+), 161 deletions(-)

-- 
2.28.0

