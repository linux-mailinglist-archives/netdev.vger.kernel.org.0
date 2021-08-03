Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6B3DF2A2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhHCQhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:37:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:56666 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233449AbhHCQhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 12:37:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="200900149"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="200900149"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 09:36:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="636665141"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 03 Aug 2021 09:36:48 -0700
Received: from alobakin-mobl.ger.corp.intel.com (eflejszm-mobl2.ger.corp.intel.com [10.213.26.164])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 173GahEo029968;
        Tue, 3 Aug 2021 17:36:44 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lukasz Czapnik <lukasz.czapnik@intel.com>,
        Marcin Kubiak <marcin.kubiak@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Shay Agroskin <shayagr@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jian Shen <shenjian15@huawei.com>,
        Petr Vorel <petr.vorel@gmail.com>, Dan Murphy <dmurphy@ti.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 00/21] ethtool, stats: introduce and use standard XDP stats
Date:   Tue,  3 Aug 2021 18:36:20 +0200
Message-Id: <20210803163641.3743-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series follows the Jakub's work on standard statistics and
unifies XDP statistics across [most of] the drivers.
The only driver left unconverted is mlx5 -- it has rather complex
statistics, so I believe it would be better to leave this up to
its developers.

The stats itself consists of 12 counters:
 - packets: number of frames passed to bpf_prog_run_xdp();
 - errors: number of general XDP errors, if driver has one unified counter;
 - aborted: number of XDP_ABORTED returns;
 - drop: number of XDP_DROP returns;
 - invalid: number of returns of unallowed values (i.e. not XDP_*);
 - pass: number of XDP_PASS returns;
 - redirect: number of successfully performed XDP_REDIRECT requests;
 - redirect_errors: number of failed XDP_REDIRECT requests;
 - tx: number of successfully performed XDP_TX requests;
 - tx_errors: number of failed XDP_TX requests;
 - xmit: number of xdp_frames successfully transmitted via .ndo_xdp_xmit();
 - xmit_drops: number of frames dropped from .ndo_xdp_xmit().

As most drivers stores them on a per-channel basis, Ethtool standard
stats infra has been expanded to support this. A new nested
attribute has been added which indicated that the fields enclosed
in this block are related to one particular channel. If Ethtool
utility is older than the kernel, those blocks will just be skipped
with no errors.
When the stats are not per-channel, Ethtool core treats them as
regular and so does Ethtool utility display them. Otherwise,
the example output looks like:

$ ./ethtool -S enp175s0f0 --all-groups
Standard stats for enp175s0f0:
[ snip ]
channel0-xdp-aborted: 1
channel0-xdp-drop: 2
channel0-xdp-illegal: 3
channel0-xdp-pass: 4
channel0-xdp-redirect: 5
[ snip ]

...and the JSON output looks like:

[ snip ]
        "xdp": {
            "per-channel": [
                "channel0": {
                    "aborted": 1,
                    "drop": 2,
                    "illegal": 3,
                    "pass": 4,
                    "redirect": 5,
[ snip ]
                } ]
        }
[ snip ]

Rouhly half of the commits are present to unify XDP stats logics
across the drivers, and the first two are preparatory/housekeeping.

This set is also available here: [0]

[0] https://github.com/alobakin/linux/tree/xdp_stats

Alexander Lobakin (21):
  ethtool, stats: use a shorthand pointer in stats_prepare_data()
  ethtool, stats: add compile-time checks for standard stats
  ethtool, stats: introduce standard XDP statistics
  ethernet, dpaa2: simplify per-channel Ethtool stats counting
  ethernet, dpaa2: convert to standard XDP stats
  ethernet, ena: constify src and syncp args of ena_safe_update_stat()
  ethernet, ena: convert to standard XDP stats
  ethernet, enetc: convert to standard XDP stats
  ethernet, mvneta: rename xdp_xmit_err to xdp_xmit_drops
  ethernet, mvneta: convert to standard XDP stats
  ethernet, mvpp2: rename xdp_xmit_err to xdp_xmit_drops
  ethernet, mvpp2: convert to standard XDP stats
  ethernet, sfc: convert to standard XDP stats
  veth: rename rx_drops to xdp_errors
  veth: rename xdp_xmit_errors to xdp_xmit_drops
  veth: rename drop xdp_ suffix from packets and bytes stats
  veth: convert to standard XDP stats
  virtio-net: rename xdp_tx{,__drops} SQ stats to xdp_xmit{,__drops}
  virtio-net: don't mix error-caused drops with XDP_DROP cases
  virtio-net: convert to standard XDP stats
  Documentation, ethtool-netlink: update standard statistics
    documentation

 Documentation/networking/ethtool-netlink.rst  |  45 +++--
 drivers/net/ethernet/amazon/ena/ena_ethtool.c |  50 +++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   7 +-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  38 +++-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  58 ++++--
 drivers/net/ethernet/marvell/mvneta.c         | 112 ++++++------
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  96 +++-------
 drivers/net/ethernet/sfc/ef100_ethtool.c      |   2 +
 drivers/net/ethernet/sfc/ethtool.c            |   2 +
 drivers/net/ethernet/sfc/ethtool_common.c     |  35 +++-
 drivers/net/ethernet/sfc/ethtool_common.h     |   3 +
 drivers/net/veth.c                            | 167 ++++++++++--------
 drivers/net/virtio_net.c                      |  76 ++++++--
 include/linux/ethtool.h                       |  36 ++++
 include/uapi/linux/ethtool.h                  |   2 +
 include/uapi/linux/ethtool_netlink.h          |  34 ++++
 net/ethtool/netlink.h                         |   1 +
 net/ethtool/stats.c                           | 163 +++++++++++++++--
 net/ethtool/strset.c                          |   5 +
 20 files changed, 659 insertions(+), 275 deletions(-)

-- 
2.31.1

