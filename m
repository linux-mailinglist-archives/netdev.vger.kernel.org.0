Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99531050E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhBEGox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhBEGoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:44:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C89364F9B;
        Fri,  5 Feb 2021 06:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507444;
        bh=Y1hva9YwHKGFbIuPh0Rziua4GJtWHNVbIDXD9Focecc=;
        h=From:To:Cc:Subject:Date:From;
        b=eOnP4BsDpSWEXX8q0WGyv3hFPpCZ+8v73JtJIC+pFyt2plON8aLZnBge/nykcXkkk
         5RSTlOVtrQ8N3DcaYIF0vnMutbolVs/yDRbhTYzMy0MNLFLpcURBEO3XV5OP8H/yGi
         FWicFdqGZvkm4N8a9et1qdbI7i88PBuqTQwF6on6hhXwk+Y9ig3xo0IEBN8RdItO3h
         h/SNsHm40XXAmL4izu4bEDciGEGDg/7SHVu43oTG2p2KYTaMibM4HFT1iBWRsfmgUG
         dFsbweEFt+aWJLUpN/qrQ+jqx9ee0b+IkU6b7JLQq//gAFw1rq1cHMFuigqheFlDqn
         Sh3WdFroOoVGw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/17] mlx5 updates 2021-02-04
Date:   Thu,  4 Feb 2021 22:40:34 -0800
Message-Id: <20210205064051.89592-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub,

This series adds support for VF tunneling from Vlad,
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 4d469ec8ec05e1fa4792415de1a95b28871ff2fa:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-02-04 21:26:28 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-02-04

for you to fetch changes up to 823d1f49cd93b04e7ac3957a35153e404201b041:

  net/mlx5e: Handle FIB events to update tunnel endpoint device (2021-02-04 22:37:46 -0800)

----------------------------------------------------------------
mlx5-updates-2021-02-04

Vlad Buslov says:
=================

Implement support for VF tunneling

Abstract

Currently, mlx5 only supports configuration with tunnel endpoint IP address on
uplink representor. Remove implicit and explicit assumptions of tunnel always
being terminated on uplink and implement necessary infrastructure for
configuring tunnels on VF representors and updating rules on such tunnels
according to routing changes.

SW TC model

From TC perspective VF tunnel configuration requires two rules in both
directions:

TX rules

1. Rule that redirects packets from UL to VF rep that has the tunnel
endpoint IP address:

$ tc -s filter show dev enp8s0f0 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac 16:c9:a0:2d:69:2c
  src_mac 0c:42:a1:58:ab:e4
  eth_type ipv4
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: mirred (Egress Redirect to device enp8s0f0_0) stolen
        index 3 ref 1 bind 1 installed 377 sec used 0 sec
        Action statistics:
        Sent 114096 bytes 952 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 114096 bytes 952 pkt
        backlog 0b 0p requeues 0
        cookie 878fa48d8c423fc08c3b6ca599b50a97
        no_percpu
        used_hw_stats delayed

2. Rule that decapsulates the tunneled flow and redirects to destination VF
representor:

$ tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac ca:2e:a7:3f:f5:0f
  src_mac 0a:40:bd:30:89:99
  eth_type ipv4
  enc_dst_ip 7.7.7.5
  enc_src_ip 7.7.7.1
  enc_key_id 98
  enc_dst_port 4789
  enc_tos 0
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  unset pipe
         index 2 ref 1 bind 1 installed 434 sec used 434 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device enp8s0f0_1) stolen
        index 4 ref 1 bind 1 installed 434 sec used 0 sec
        Action statistics:
        Sent 129936 bytes 1082 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 129936 bytes 1082 pkt
        backlog 0b 0p requeues 0
        cookie ac17cf398c4c69e4a5b2f7aabd1b88ff
        no_percpu
        used_hw_stats delayed

RX rules

1. Rule that encapsulates the tunneled flow and redirects packets from
source VF rep to tunnel device:

$ tc -s filter show dev enp8s0f0_1 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac 0a:40:bd:30:89:99
  src_mac ca:2e:a7:3f:f5:0f
  eth_type ipv4
  ip_tos 0/0x3
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  set
        src_ip 7.7.7.5
        dst_ip 7.7.7.1
        key_id 98
        dst_port 4789
        nocsum
        ttl 64 pipe
         index 1 ref 1 bind 1 installed 411 sec used 411 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        no_percpu
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device vxlan_sys_4789) stolen
        index 1 ref 1 bind 1 installed 411 sec used 0 sec
        Action statistics:
        Sent 5615833 bytes 4028 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 5615833 bytes 4028 pkt
        backlog 0b 0p requeues 0
        cookie bb406d45d343bf7ade9690ae80c7cba4
        no_percpu
        used_hw_stats delayed

2. Rule that redirects from tunnel device to UL rep:

$ tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac ca:2e:a7:3f:f5:0f
  src_mac 0a:40:bd:30:89:99
  eth_type ipv4
  enc_dst_ip 7.7.7.5
  enc_src_ip 7.7.7.1
  enc_key_id 98
  enc_dst_port 4789
  enc_tos 0
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  unset pipe
         index 2 ref 1 bind 1 installed 434 sec used 434 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device enp8s0f0_1) stolen
        index 4 ref 1 bind 1 installed 434 sec used 0 sec
        Action statistics:
        Sent 129936 bytes 1082 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 129936 bytes 1082 pkt
        backlog 0b 0p requeues 0
        cookie ac17cf398c4c69e4a5b2f7aabd1b88ff
        no_percpu
        used_hw_stats delayed

HW offloads model

For hardware offload the goal is to mach packet on both rules without exposing
it to software on tunnel endpoint VF. In order to achieve this for tx, TC
implementation marks encap rules with tunnel endpoint on mlx5 VF of same eswitch
with MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE flag and adds header modification
rule to overwrite packet source port to the value of tunnel VF. Eswitch code is
modified to recirculate such packets after source port value is changed, which
allows second tx rules to match.

For rx path indirect table infrastructure is used to allow fully processing VF
tunnel traffic in hardware. To implement such pipeline driver needs to program
the hardware after matching on UL rule to overwrite source vport from UL to
tunnel VF and recirculate the packet to the root table to allow matching on the
rule installed on tunnel VF. For this, indirect table matches all encapsulated
traffic by tunnel parameters and all other IP traffic is sent to tunnel VF by
the miss rule. Such configuration will cause packet to appear on VF representor
instead of VF itself if packet has been matches by indirect table rule based on
tunnel parameters but missed on second rule (after recirculation). Handle such
case by marking packets processed by indirect table with special 0xFFF value in
reg_c1 and extending slow table with additional flow group that matches on
reg_c0 (source port value set by indirect tables) and reg_c1 (special 0xFFF
mark). When creating offloads fdb tables, install one rule per VF vport to match
on recirculated miss packets and redirect them to appropriate VF vport.

Routing events

In order to support routing changes and migration of tunnel device between
different endpoint VFs, implement routing infrastructure and update it with FIB
events. Routing entry table is introduced to mlx5 TC. Every rx and tx VF tunnel
rule is attached to a routing entry, which is shared for rules of same tunnel.
On FIB event the work is scheduled to delete/recreate all rules of affected
tunnel.

Note: only vxlan tunnel type is supported by this series.

=================

----------------------------------------------------------------
Mark Bloch (1):
      net/mlx5: E-Switch, Refactor setting source port

Vlad Buslov (16):
      net/mlx5e: E-Switch, Maintain vhca_id to vport_num mapping
      net/mlx5e: Always set attr mdev pointer
      net/mlx5: E-Switch, Refactor rule offload forward action processing
      net/mlx5e: VF tunnel TX traffic offloading
      net/mlx5e: Refactor tun routing helpers
      net/mlx5: E-Switch, Indirect table infrastructure
      net/mlx5e: Remove redundant match on tunnel destination mac
      net/mlx5e: VF tunnel RX traffic offloading
      net/mlx5e: Refactor reg_c1 usage
      net/mlx5e: Match recirculated packet miss in slow table using reg_c1
      net/mlx5e: Extract tc tunnel encap/decap code to dedicated file
      net/mlx5e: Create route entry infrastructure
      net/mlx5e: Refactor neigh update infrastructure
      net/mlx5e: TC preparation refactoring for routing update event
      net/mlx5e: Rename some encap-specific API to generic names
      net/mlx5e: Handle FIB events to update tunnel endpoint device

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    1 +
 .../mellanox/mlx5/core/diag/en_rep_tracepoint.h    |    4 +-
 .../mellanox/mlx5/core/diag/en_tc_tracepoint.h     |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |   16 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.h |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   14 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  175 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  499 ++++--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   13 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 1653 ++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   38 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 1083 +++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   40 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |  517 ++++++
 .../ethernet/mellanox/mlx5/core/esw/indir_table.h  |   76 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   20 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   16 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  631 +++++++-
 include/linux/mlx5/eswitch.h                       |   29 +
 23 files changed, 3798 insertions(+), 1057 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.h
