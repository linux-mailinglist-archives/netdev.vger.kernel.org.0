Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62908182D66
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgCLKXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:36 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56600 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726028AbgCLKXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:35 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTY017875;
        Thu, 12 Mar 2020 12:23:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 00/15] Introduce connection tracking offload
Date:   Thu, 12 Mar 2020 12:23:02 +0200
Message-Id: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background
----------

The connection tracking action provides the ability to associate connection state to a packet.
The connection state may be used for stateful packet processing such as stateful firewalls
and NAT operations.

Connection tracking in TC SW
----------------------------

The CT state may be matched only after the CT action is performed.
As such, CT use cases are commonly implemented using multiple chains.
Consider the following TC filters, as an example:
1. tc filter add dev ens1f0_0 ingress prio 1 chain 0 proto ip flower \
    src_mac 24:8a:07:a5:28:01 ct_state -trk \
    action ct \
    pipe action goto chain 2
       
2. tc filter add dev ens1f0_0 ingress prio 1 chain 2 proto ip flower \
    ct_state +trk+new \
    action ct commit \
    pipe action tunnel_key set \
        src_ip 0.0.0.0 \
        dst_ip 7.7.7.8 \
        id 98 \
        dst_port 4789 \
    action mirred egress redirect dev vxlan0
       
3. tc filter add dev ens1f0_0 ingress prio 1 chain 2 proto ip flower \
    ct_state +trk+est \
    action tunnel_key set \
        src_ip 0.0.0.0 \
        dst_ip 7.7.7.8 \
        id 98 \
        dst_port 4789 \
    action mirred egress redirect dev vxlan0
       
Filter #1 (chain 0) decides, after initial packet classification, to send the packet to the
connection tracking module (ct action).
Once the ct_state is initialized by the CT action the packet processing continues on chain 2.

Chain 2 classifies the packet based on the ct_state.
Filter #2 matches on the +trk+new CT state while filter #3 matches on the +trk+est ct_state.

MLX5 Connection tracking HW offload - MLX5 driver patches
------------------------------

The MLX5 hardware model aligns with the software model by realizing a multi-table
architecture. In SW the TC CT action sets the CT state on the skb. Similarly,
HW sets the CT state on a HW register. Driver gets this CT state while offloading
a tuple with a new ct_metadata action that provides it.

Matches on ct_state are translated to HW register matches.
    
TC filter with CT action broken to two rules, a pre_ct rule, and a post_ct rule.
pre_ct rule:
   Inserted on the corrosponding tc chain table, matches on original tc match, with
   actions: any pre ct actions, set fte_id, set zone, and goto the ct table.
   The fte_id is a register mapping uniquely identifying this filter.
post_ct_rule:
   Inserted in a post_ct table, matches on the fte_id register mapping, with
   actions: counter + any post ct actions (this is usally 'goto chain X')

post_ct table is a table that all the tuples inserted to the ct table goto, so
if there is a tuple hit, packet will continue from ct table to post_ct table,
after being marked with the CT state (mark/label..)

This design ensures that the rule's actions and counters will be executed only after a CT hit.
HW misses will continue processing in SW from the last chain ID that was processed in hardware.

The following illustrates the HW model:

+-------------------+      +--------------------+    +--------------+
+ pre_ct (tc chain) +----->+ CT (nat or no nat) +--->+ post_ct      +----->
+ original match    +   |  + tuple + zone match + |  + fte_id match +  |
+-------------------+   |  +--------------------+ |  +--------------+  |
                        v                         v                    v
                     set chain miss mapping    set mark             original
                     set fte_id                set label            filter
                     set zone                  set established      actions
                     set tunnel_id             do nat (if needed)
                     do decap

To fill CT table, driver registers a CB for flow offload events, for each new
flow table that is passed to it from offloading ct actions. Once a flow offload
event is triggered on this CB, offload this flow to the hardware CT table.

Established events offload
--------------------------

Currently, act_ct maintains an FT instance per ct zone. Flow table entries
are created, per ct connection, when connections enter an established
state and deleted otherwise. Once an entry is created, the FT assumes
ownership of the entries, and manages their aging. FT is used for software
offload of conntrack. FT entries associate 5-tuples with an action list.

The act_ct changes in this patchset:
Populate the action list with a (new) ct_metadata action, providing the
connection's ct state (zone,mark and label), and mangle actions if NAT
is configured.

Pass the action's flow table instance as ct action entry parameter,
so  when the action is offloaded, the driver may register a callback on
it's block to receive FT flow offload add/del/stats events.

Netilter changes
--------------------------
The netfilter changes export the relevant bits, and add the relevant CBs
to support the above.

Applying this patchset
--------------------------

On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
and fix the following non trivial conflict in fs_core.c as follows:
#define OFFLOADS_MAX_FT 2
#define OFFLOADS_NUM_PRIOS 2
#define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)

Then apply this patchset.

Changelog:
  v2->v3:
    Added the first two patches needed after rebasing on net-next:
     "net/mlx5: E-Switch, Enable reg c1 loopback when possible"
     "net/mlx5e: en_rep: Create uplink rep root table after eswitch offloads table"


Paul Blakey (15):
  net/mlx5: E-Switch, Enable reg c1 loopback when possible
  net/mlx5e: en_rep: Create uplink rep root table after eswitch offloads
    table
  netfilter: flowtable: Add API for registering to flow table events
  net/sched: act_ct: Instantiate flow table entry actions
  net/sched: act_ct: Support restoring conntrack info on skbs
  net/sched: act_ct: Support refreshing the flow table entries
  net/sched: act_ct: Enable hardware offload of flow table entires
  net/mlx5: E-Switch, Introduce global tables
  net/mlx5: E-Switch, Add support for offloading rules with no in_port
  net/mlx5: E-Switch, Support getting chain mapping
  flow_offload: Add flow_match_ct to get rule ct match
  net/mlx5e: CT: Introduce connection tracking
  net/mlx5e: CT: Offload established flows
  net/mlx5e: CT: Handle misses after executing CT action
  net/mlx5e: CT: Support clear action

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1356 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  171 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  120 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |    9 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    6 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   66 +-
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   43 +
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |   13 +
 include/linux/mlx5/eswitch.h                       |    7 +
 include/net/flow_offload.h                         |   13 +
 include/net/netfilter/nf_flow_table.h              |   32 +
 include/net/tc_act/tc_ct.h                         |   17 +
 net/core/flow_offload.c                            |    7 +
 net/netfilter/nf_flow_table_core.c                 |   60 +
 net/netfilter/nf_flow_table_ip.c                   |   15 +-
 net/netfilter/nf_flow_table_offload.c              |   27 +-
 net/sched/act_ct.c                                 |  226 ++++
 net/sched/cls_api.c                                |    1 +
 22 files changed, 2134 insertions(+), 70 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h

-- 
1.8.3.1

