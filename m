Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D773637A1
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhDRVEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:04:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34968 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhDRVEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:51 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B710263E34;
        Sun, 18 Apr 2021 23:03:51 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/14] Netfilter updates for net-next
Date:   Sun, 18 Apr 2021 23:04:01 +0200
Message-Id: <20210418210415.4719-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add vlan match and pop actions to the flowtable offload,
   patches from wenxu.

2) Reduce size of the netns_ct structure, which itself is
   embedded in struct net Make netns_ct a read-mostly structure.
   Patches from Florian Westphal.

3) Add FLOW_OFFLOAD_XMIT_UNSPEC to skip dst check from garbage
   collector path, as required by the tc CT action. From Roi Dayan.

4) VLAN offload fixes for nftables: Allow for matching on both s-vlan
   and c-vlan selectors. Fix match of VLAN id due to incorrect
   byteorder. Add a new routine to properly populate flow dissector
   ethertypes.

5) Missing keys in ip{6}_route_me_harder() results in incorrect
   routes. This includes an update for selftest infra. Patches
   from Ido Schimmel.

6) Add counter hardware offload support through FLOW_CLS_STATS.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks!

----------------------------------------------------------------

The following changes since commit 8ef7adc6beb2ef0bce83513dc9e4505e7b21e8c2:

  net: ethernet: ravb: Enable optional refclk (2021-04-12 14:09:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to b72920f6e4a9d6607b723d69b7f412c829769c75:

  netfilter: nftables: counter hardware offload support (2021-04-18 22:04:49 +0200)

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: conntrack: move autoassign warning member to net_generic data
      netfilter: conntrack: move autoassign_helper sysctl to net_generic data
      netfilter: conntrack: move expect counter to net_generic data
      netfilter: conntrack: move ct counter to net_generic data
      netfilter: conntrack: convert sysctls to u8

Ido Schimmel (2):
      netfilter: Dissect flow after packet mangling
      selftests: fib_tests: Add test cases for interaction with mangling

Pablo Neira Ayuso (4):
      netfilter: nft_payload: fix C-VLAN offload support
      netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector
      netfilter: nftables_offload: special ethertype handling for VLAN
      netfilter: nftables: counter hardware offload support

Roi Dayan (1):
      netfilter: flowtable: Add FLOW_OFFLOAD_XMIT_UNSPEC xmit type

wenxu (2):
      netfilter: flowtable: add vlan match offload support
      netfilter: flowtable: add vlan pop action offload support

 include/net/netfilter/nf_conntrack.h      |   8 ++
 include/net/netfilter/nf_flow_table.h     |   5 +-
 include/net/netfilter/nf_tables.h         |   2 +
 include/net/netfilter/nf_tables_offload.h |  13 ++-
 include/net/netns/conntrack.h             |  23 ++---
 net/ipv4/netfilter.c                      |   2 +
 net/ipv6/netfilter.c                      |   2 +
 net/netfilter/nf_conntrack_core.c         |  46 ++++++---
 net/netfilter/nf_conntrack_expect.c       |  22 +++--
 net/netfilter/nf_conntrack_helper.c       |  15 ++-
 net/netfilter/nf_conntrack_netlink.c      |   5 +-
 net/netfilter/nf_conntrack_proto_tcp.c    |  34 +++----
 net/netfilter/nf_conntrack_standalone.c   |  66 +++++++------
 net/netfilter/nf_flow_table_core.c        |   3 +
 net/netfilter/nf_flow_table_offload.c     |  52 ++++++++++
 net/netfilter/nf_tables_api.c             |   3 +
 net/netfilter/nf_tables_offload.c         |  88 +++++++++++++++--
 net/netfilter/nft_cmp.c                   |  41 +++++++-
 net/netfilter/nft_counter.c               |  29 ++++++
 net/netfilter/nft_payload.c               |  13 ++-
 tools/testing/selftests/net/fib_tests.sh  | 152 +++++++++++++++++++++++++++++-
 21 files changed, 520 insertions(+), 104 deletions(-)
