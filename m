Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E46416034C
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgBPKCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:02:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44748 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbgBPKBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:38 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1cdu007834;
        Sun, 16 Feb 2020 12:01:38 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 00/16] Handle multi chain hardware misses
Date:   Sun, 16 Feb 2020 12:01:20 +0200
Message-Id: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David/Jakub/Saeed,

TC multi chain configuration can cause offloaded tc chains to miss in
hardware after jumping to some chain. In such cases the software should
continue from the chain that was missed in hardware, as the hardware may have
manipulated the packet and updated some counters.

The first four patches enables tc classification to start from a specified chain by
re-using the existing TC_SKB_EXT skb extension.

The next six patches are the Mellanox driver implementation of the miss path.
The driver loads the last processed chain from HW register (reg_c0, then flow_tag)
and stores it on the TC_SKB_EXT skb extension for continued processing
in software.

The final six patches introduce the Mellanox driver implementation for handling
tunnel restore when the packet was decapsulated on first chain hop.
Early decapsulation creates two issues:
1. The outer headers will not be available in later chains
2. If the HW will miss on later chains, the packet will come up to software
   without the tunnel header. Therefore, sw matches on the tunnel info will miss.

Address these issues by mapping a unique id per tunnel info. The mapping is
stored on hardware register (c1) when the packet is decapsulated. On miss,
use the id to restore the tunnel info metadata on the skb.

Note that miss path handling of multi-chain rules is a required infrastructure
for connection tracking hardware offload. The connection tracking offload
series will follow this one.

Changelog:
   v2-v3:
     Split first patch to four

Paul Blakey (16):
  net: sched: Introduce ingress classification function
  net: sched: Pass ingress block to tcf_classify_ingress
  net: sched: Change the block's chain list to an rcu list
  net: sched: Support specifying a starting chain via tc skb ext
  net/mlx5: Introduce mapping infra for mapping unique ids to data
  net/mlx5: E-Switch, Move source port on reg_c0 to the upper 16 bits
  net/mlx5: E-Switch, Get reg_c0 value on CQE
  net/mlx5: E-Switch, Mark miss packets with new chain id mapping
  net/mlx5e: Rx, Split rep rx mpwqe handler from nic
  net/mlx5: E-Switch, Restore chain id on miss
  net/mlx5e: Allow re-allocating mod header actions
  net/mlx5e: Move tc tunnel parsing logic with the rest at tc_tun module
  net/mlx5e: Disallow inserting vxlan/vlan egress rules without
    decap/pop
  net/mlx5e: Support inner header rewrite with goto action
  net/mlx5: E-Switch, Get reg_c1 value on miss
  net/mlx5e: Restore tunnel metadata on miss

 drivers/infiniband/hw/mlx5/main.c                  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/mapping.c   | 218 ++++++
 .../net/ethernet/mellanox/mlx5/core/en/mapping.h   |  27 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 112 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  66 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 818 ++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  45 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  15 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 240 +++++-
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   | 130 +++-
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 include/linux/mlx5/eswitch.h                       |  31 +-
 include/net/pkt_cls.h                              |  13 +
 include/net/sch_generic.h                          |   3 +
 net/core/dev.c                                     |   3 +-
 net/sched/cls_api.c                                |  98 ++-
 net/sched/sch_generic.c                            |   8 +
 net/sched/sch_ingress.c                            |  11 +-
 23 files changed, 1619 insertions(+), 246 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mapping.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/mapping.h

-- 
1.8.3.1

