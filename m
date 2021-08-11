Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2687D3E8C59
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhHKIth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44012 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbhHKIth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:37 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 57ED060052;
        Wed, 11 Aug 2021 10:48:30 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/10] Netfilter updates for net-next
Date:   Wed, 11 Aug 2021 10:48:58 +0200
Message-Id: <20210811084908.14744-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Use nfnetlink_unicast() instead of netlink_unicast() in nft_compat.

2) Remove call to nf_ct_l4proto_find() in flowtable offload timeout
   fixup.

3) CLUSTERIP registers ARP hook on demand, from Florian.

4) Use clusterip_net to store pernet warning, also from Florian.

5) Remove struct netns_xt, from Florian Westphal.

6) Enable ebtables hooks in initns on demand, from Florian.

7) Allow to filter conntrack netlink dump per status bits,
   from Florian Westphal.

8) Register x_tables hooks in initns on demand, from Florian.

9) Remove queue_handler from per-netns structure, again from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit aae950b189413ed3201354600d44223da0bcf63c:

  Merge branch 'clean-devlink-net-namespace-operations' (2021-07-30 13:16:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 8702997074363c294a1f83928cd0c33ca57bf813:

  netfilter: nf_queue: move hookfn registration out of struct net (2021-08-10 17:32:00 +0200)

----------------------------------------------------------------
Florian Westphal (8):
      netfilter: ipt_CLUSTERIP: only add arp mangle hook when required
      netfilter: ipt_CLUSTERIP: use clusterip_net to store pernet warning
      netfilter: remove xt pernet data
      netfilter: ebtables: do not hook tables by default
      netfilter: ctnetlink: add and use a helper for mark parsing
      netfilter: ctnetlink: allow to filter dump by status bits
      netfilter: x_tables: never register tables by default
      netfilter: nf_queue: move hookfn registration out of struct net

Pablo Neira Ayuso (2):
      netfilter: nft_compat: use nfnetlink_unicast()
      netfilter: flowtable: remove nf_ct_l4proto_find() call

 include/linux/netfilter/x_tables.h                 |   6 +-
 include/linux/netfilter_bridge/ebtables.h          |   2 +
 include/net/net_namespace.h                        |   2 -
 include/net/netfilter/nf_queue.h                   |   4 +-
 include/net/netns/netfilter.h                      |   1 -
 include/net/netns/x_tables.h                       |  12 ---
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   1 +
 net/bridge/netfilter/ebtable_broute.c              |  17 +++-
 net/bridge/netfilter/ebtable_filter.c              |  17 +++-
 net/bridge/netfilter/ebtable_nat.c                 |  17 +++-
 net/bridge/netfilter/ebtables.c                    | 109 ++++++++++++++++++---
 net/ipv4/netfilter/arptable_filter.c               |  23 +++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |  56 +++++++----
 net/ipv4/netfilter/iptable_filter.c                |  24 +++--
 net/ipv4/netfilter/iptable_mangle.c                |  17 ++--
 net/ipv4/netfilter/iptable_nat.c                   |  20 ++--
 net/ipv4/netfilter/iptable_raw.c                   |  21 ++--
 net/ipv4/netfilter/iptable_security.c              |  23 +++--
 net/ipv6/netfilter/ip6table_filter.c               |  23 +++--
 net/ipv6/netfilter/ip6table_mangle.c               |  22 ++---
 net/ipv6/netfilter/ip6table_nat.c                  |  16 +--
 net/ipv6/netfilter/ip6table_raw.c                  |  24 +++--
 net/ipv6/netfilter/ip6table_security.c             |  22 ++---
 net/netfilter/nf_conntrack_netlink.c               |  76 +++++++++++---
 net/netfilter/nf_flow_table_core.c                 |  10 --
 net/netfilter/nf_queue.c                           |  19 ++--
 net/netfilter/nfnetlink_queue.c                    |  15 ++-
 net/netfilter/nft_compat.c                         |   8 +-
 net/netfilter/x_tables.c                           |  98 ++++++++++++++----
 net/netfilter/xt_CT.c                              |  11 ---
 30 files changed, 468 insertions(+), 248 deletions(-)
 delete mode 100644 include/net/netns/x_tables.h
