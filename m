Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C837430C8F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbhJQWRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53380 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235725AbhJQWRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:49 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E67E7605E1;
        Mon, 18 Oct 2021 00:13:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 00/15] Netfilter/IPVS updates for net-next
Date:   Mon, 18 Oct 2021 00:15:07 +0200
Message-Id: <20211017221522.853838-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS for net-next:

1) Add new run_estimation toggle to IPVS to stop the estimation_timer
   logic, from Dust Li.

2) Relax superfluous dynset check on NFT_SET_TIMEOUT.

3) Add egress hook, from Lukas Wunner.

4) Nowadays, almost all hook functions in x_table land just call the hook
   evaluation loop. Remove remaining hook wrappers from iptables and IPVS.
   From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit c514fbb6231483b05c97eb22587188d4c453b28e:

  ethernet: ti: cpts: Use devm_kcalloc() instead of devm_kzalloc() (2021-10-07 09:08:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to ffdd33dd9c12a8c263f78d778066709ef94671f9:

  netfilter: core: Fix clang warnings about unused static inlines (2021-10-17 15:49:08 +0200)

----------------------------------------------------------------
Dust Li (1):
      ipvs: add sysctl_run_estimation to support disable estimation

Florian Westphal (8):
      netfilter: iptables: allow use of ipt_do_table as hookfn
      netfilter: arp_tables: allow use of arpt_do_table as hookfn
      netfilter: ip6tables: allow use of ip6t_do_table as hookfn
      netfilter: ebtables: allow use of ebt_do_table as hookfn
      netfilter: ipvs: prepare for hook function reduction
      netfilter: ipvs: remove unneeded output wrappers
      netfilter: ipvs: remove unneeded input wrappers
      netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers

Lukas Wunner (4):
      netfilter: Rename ingress hook include file
      netfilter: Generalize ingress hook include file
      netfilter: Introduce egress hook
      netfilter: core: Fix clang warnings about unused static inlines

Pablo Neira Ayuso (2):
      netfilter: nft_dynset: relax superfluous check on set updates
      af_packet: Introduce egress hook

 Documentation/networking/ipvs-sysctl.rst  |  11 ++
 drivers/net/ifb.c                         |   3 +
 include/linux/netdevice.h                 |   4 +
 include/linux/netfilter_arp/arp_tables.h  |   5 +-
 include/linux/netfilter_bridge/ebtables.h |   5 +-
 include/linux/netfilter_ingress.h         |  58 -----------
 include/linux/netfilter_ipv4/ip_tables.h  |   6 +-
 include/linux/netfilter_ipv6/ip6_tables.h |   5 +-
 include/linux/netfilter_netdev.h          | 146 ++++++++++++++++++++++++++
 include/linux/skbuff.h                    |   4 +
 include/net/ip_vs.h                       |  11 ++
 include/uapi/linux/netfilter.h            |   1 +
 net/bridge/netfilter/ebtable_broute.c     |   2 +-
 net/bridge/netfilter/ebtable_filter.c     |  13 +--
 net/bridge/netfilter/ebtable_nat.c        |  12 +--
 net/bridge/netfilter/ebtables.c           |   6 +-
 net/core/dev.c                            |  19 +++-
 net/ipv4/netfilter/arp_tables.c           |   7 +-
 net/ipv4/netfilter/arptable_filter.c      |  10 +-
 net/ipv4/netfilter/ip_tables.c            |   7 +-
 net/ipv4/netfilter/iptable_filter.c       |   9 +-
 net/ipv4/netfilter/iptable_mangle.c       |   8 +-
 net/ipv4/netfilter/iptable_nat.c          |  15 +--
 net/ipv4/netfilter/iptable_raw.c          |  10 +-
 net/ipv4/netfilter/iptable_security.c     |   9 +-
 net/ipv6/netfilter/ip6_tables.c           |   6 +-
 net/ipv6/netfilter/ip6table_filter.c      |  10 +-
 net/ipv6/netfilter/ip6table_mangle.c      |   8 +-
 net/ipv6/netfilter/ip6table_nat.c         |  15 +--
 net/ipv6/netfilter/ip6table_raw.c         |  10 +-
 net/ipv6/netfilter/ip6table_security.c    |   9 +-
 net/netfilter/Kconfig                     |  11 ++
 net/netfilter/core.c                      |  38 ++++++-
 net/netfilter/ipvs/ip_vs_core.c           | 166 ++++++------------------------
 net/netfilter/ipvs/ip_vs_ctl.c            |   8 ++
 net/netfilter/ipvs/ip_vs_est.c            |   5 +
 net/netfilter/nfnetlink_hook.c            |  16 ++-
 net/netfilter/nft_chain_filter.c          |   4 +-
 net/netfilter/nft_dynset.c                |  11 +-
 net/packet/af_packet.c                    |  35 +++++++
 40 files changed, 389 insertions(+), 349 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h
