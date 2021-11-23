Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E86745A899
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKWQo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 11:44:26 -0500
Received: from mga14.intel.com ([192.55.52.115]:62210 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhKWQoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 11:44:25 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235294599"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235294599"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 08:41:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="591251752"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Nov 2021 08:41:07 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANGf4Wc016784;
        Tue, 23 Nov 2021 16:41:04 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 net-next 00/26] net: introduce and use generic XDP stats
Date:   Tue, 23 Nov 2021 17:39:29 +0100
Message-Id: <20211123163955.154512-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an almost complete rework of [0].

This series introduces generic XDP statistics infra based on rtnl
xstats (Ethtool standard stats previously), and wires up the drivers
which collect appropriate statistics to this new interface. Finally,
it introduces XDP/XSK statistics to all XDP-capable Intel drivers.

Those counters are:
* packets: number of frames passed to bpf_prog_run_xdp().
* bytes: number of bytes went through bpf_prog_run_xdp().
* errors: number of general XDP errors, if driver has one unified
  counter.
* aborted: number of XDP_ABORTED returns.
* drop: number of XDP_DROP returns.
* invalid: number of returns of unallowed values (i.e. not XDP_*).
* pass: number of XDP_PASS returns.
* redirect: number of successfully performed XDP_REDIRECT requests.
* redirect_errors: number of failed XDP_REDIRECT requests.
* tx: number of successfully performed XDP_TX requests.
* tx_errors: number of failed XDP_TX requests.
* xmit_packets: number of successfully transmitted XDP/XSK frames.
* xmit_bytes: number of successfully transmitted XDP/XSK frames.
* xmit_errors: of XDP/XSK frames failed to transmit.
* xmit_full: number of XDP/XSK queue being full at the moment of
  transmission.

To provide them, developers need to implement .ndo_get_xdp_stats()
and, if they want to expose stats on a per-channel basis,
.ndo_get_xdp_stats_nch(). include/net/xdp.h contains some helper
structs and functions which might be useful for doing this.
It is up to developers to decide whether to implement XDP stats in
their drivers or not, depending on the needs and so on, but if so,
it is implied that they will be implemented using this new infra
rather than custom Ethtool entries. XDP stats {,type} list can be
expanded if needed as counters are being provided as nested NL attrs.
There's an option to provide XDP and XSK counters separately, and I
used it in mlx5 (has separate RQs and SQs) and Intel (have separate
NAPI poll routines) drivers.

Example output of iproute2's new command:

$ ip link xdpstats dev enp178s0
16: enp178s0:
xdp-channel0-rx_xdp_packets: 0
xdp-channel0-rx_xdp_bytes: 1
xdp-channel0-rx_xdp_errors: 2
xdp-channel0-rx_xdp_aborted: 3
xdp-channel0-rx_xdp_drop: 4
xdp-channel0-rx_xdp_invalid: 5
xdp-channel0-rx_xdp_pass: 6
xdp-channel0-rx_xdp_redirect: 7
xdp-channel0-rx_xdp_redirect_errors: 8
xdp-channel0-rx_xdp_tx: 9
xdp-channel0-rx_xdp_tx_errors: 10
xdp-channel0-tx_xdp_xmit_packets: 11
xdp-channel0-tx_xdp_xmit_bytes: 12
xdp-channel0-tx_xdp_xmit_errors: 13
xdp-channel0-tx_xdp_xmit_full: 14
[ ... ]

This series doesn't touch existing Ethtool-exposed XDP stats due
to the potential breakage of custom{,er} scripts and other stuff
that might be hardwired on their presence. Developers are free to
drop them on their own if possible. In ideal case we would see
Ethtool stats free from anything related to XDP, but it's unlikely
to happen (:

XDP_PASS kpps on an ice NIC with ~50 Gbps line rate:

Frame size     64    | 128   | 256   | 512   | 1024 | 1532
----------------------------------------------------------
net-next       23557 | 23750 | 20731 | 11723 | 6270 | 4377
This series    23484 | 23812 | 20679 | 11720 | 6270 | 4377

The same situation with XDP_DROP and several more common cases:
nothing past stddev (which is a bit surprising, but not complaining
at all).

A brief series breakdown:
 * 1-2: introduce new infra and APIs, for rtnetlink and drivers
   respectively;
 * 3-19: add needed callback to the existing drivers to export
   their stats using new infra. Some of the patches are cosmetic
   prereqs;
 * 20-25: add XDP/XSK stats to all Intel drivers;
 * 26: mention generic XDP stats in Documentation.

This set is also available here: [1]
A separate iproute2-next patch will be published in parallel,
for now you can find it here: [2]

From v1 [0]:
 - use rtnl xstats instead of Ethtool standard -- XDP stats are
   purely software while Ethtool infra was designed for HW stats
   (Jakub);
 - split xmit into xmit_packets and xmit_bytes, add xmit_full;
 - don't touch existing drivers custom XDP stats exposed via
   Ethtool (Jakub);
 - add a bunch of helper structs and functions to reduce boilerplates
   and code duplication in new drivers;
 - merge with the series which adds XDP stats to Intel drivers;
 - add some perf numbers per Jakub's request.

[0] https://lore.kernel.org/all/20210803163641.3743-1-alexandr.lobakin@intel.com
[1] https://github.com/alobakin/linux/pull/11
[2] https://github.com/alobakin/iproute2/pull/1

Alexander Lobakin (26):
  rtnetlink: introduce generic XDP statistics
  xdp: provide common driver helpers for implementing XDP stats
  ena: implement generic XDP statistics callbacks
  dpaa2: implement generic XDP stats callbacks
  enetc: implement generic XDP stats callbacks
  mvneta: reformat mvneta_netdev_ops
  mvneta: add .ndo_get_xdp_stats() callback
  mvpp2: provide .ndo_get_xdp_stats() callback
  mlx5: don't mix XDP_DROP and Rx XDP error cases
  mlx5: provide generic XDP stats callbacks
  sf100, sfx: implement generic XDP stats callbacks
  veth: don't mix XDP_DROP counter with Rx XDP errors
  veth: drop 'xdp_' suffix from packets and bytes stats
  veth: reformat veth_netdev_ops
  veth: add generic XDP stats callbacks
  virtio_net: don't mix XDP_DROP counter with Rx XDP errors
  virtio_net: rename xdp_tx{,_drops} SQ stats to xdp_xmit{,_errors}
  virtio_net: reformat virtnet_netdev
  virtio_net: add callbacks for generic XDP stats
  i40e: add XDP and XSK generic per-channel statistics
  ice: add XDP and XSK generic per-channel statistics
  igb: add XDP generic per-channel statistics
  igc: bail out early on XSK xmit if no descs are available
  igc: add XDP and XSK generic per-channel statistics
  ixgbe: add XDP and XSK generic per-channel statistics
  Documentation: reflect generic XDP statistics

 Documentation/networking/statistics.rst       |  33 +++
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  53 ++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  45 +++
 drivers/net/ethernet/freescale/enetc/enetc.c  |  48 ++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |   3 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   2 +
 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  38 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  40 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  33 ++-
 drivers/net/ethernet/intel/ice/ice.h          |   2 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |  21 ++
 drivers/net/ethernet/intel/ice/ice_main.c     |  17 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  33 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  12 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |   3 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  51 +++-
 drivers/net/ethernet/intel/igb/igb.h          |  14 +-
 drivers/net/ethernet/intel/igb/igb_main.c     | 102 ++++++-
 drivers/net/ethernet/intel/igc/igc.h          |   3 +
 drivers/net/ethernet/intel/igc/igc_main.c     |  89 +++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  69 ++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  56 +++-
 drivers/net/ethernet/marvell/mvneta.c         |  78 +++++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  51 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   2 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  76 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   3 +
 drivers/net/ethernet/sfc/ef100_netdev.c       |   2 +
 drivers/net/ethernet/sfc/efx.c                |   2 +
 drivers/net/ethernet/sfc/efx_common.c         |  42 +++
 drivers/net/ethernet/sfc/efx_common.h         |   3 +
 drivers/net/veth.c                            | 128 +++++++--
 drivers/net/virtio_net.c                      | 104 +++++--
 include/linux/if_link.h                       |  39 ++-
 include/linux/netdevice.h                     |  13 +
 include/net/xdp.h                             | 162 +++++++++++
 include/uapi/linux/if_link.h                  |  67 +++++
 net/core/rtnetlink.c                          | 264 ++++++++++++++++++
 net/core/xdp.c                                | 124 ++++++++
 45 files changed, 1798 insertions(+), 143 deletions(-)

--
2.33.1

