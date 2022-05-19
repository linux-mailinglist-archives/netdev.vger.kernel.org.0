Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9862B52DFB6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiESWCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiESWCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BCDAC8BFA;
        Thu, 19 May 2022 15:02:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 00/11] Netfilter updates for net-next
Date:   Fri, 20 May 2022 00:01:55 +0200
Message-Id: <20220519220206.722153-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next, misc
updates and fallout fixes from recent Florian's code rewritting (from
last pull request):

1) Use new flowi4_l3mdev field in ip_route_me_harder(), from Martin Willi.

2) Avoid unnecessary GC with a timestamp in conncount, from William Tu
   and Yifeng Sun.

3) Remove TCP conntrack debugging, from Florian Westphal.

4) Fix compilation warning in ctnetlink, from Florian.

5) Add flowtable entry count and limit hw entries toggles, from
   Vlad Buslov and Oz Shlomo.

6) Add flowtable in-flight workqueue objects count, also from Vlad and Oz.

7) syzbot warning in nfnetlink bind, from Florian.

8) Refetch conntrack after __nf_conntrack_confirm(), from Florian Westphal.

9) Move struct nf_ct_timeout back at the bottom of the ctnl_time, to
   where it before recent update, also from Florian.

10) A few NL_SET_BAD_ATTR() for nf_tables netlink set element commands.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5cf15ce3c8f1ef431dc9fa845c6d1674f630ecd1:

  Merge branch 'Renesas-RSZ-V2M-support' (2022-05-16 10:14:27 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to eb6fb4d6ecbcfd69dfc36fbedbafc9860aeef1e4:

  netfilter: nf_tables: set element extended ACK reporting support (2022-05-19 22:39:50 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: conntrack: remove pr_debug callsites from tcp tracker
      netfilter: nfnetlink: fix warn in nfnetlink_unbind
      netfilter: conntrack: re-fetch conntrack after insertion
      netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit

Martin Willi (1):
      netfilter: Use l3mdev flow key when re-routing mangled packets

Pablo Neira Ayuso (1):
      netfilter: nf_tables: set element extended ACK reporting support

Stephen Rothwell (1):
      netfilter: ctnetlink: fix up for "netfilter: conntrack: remove unconfirmed list"

Vlad Buslov (3):
      net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
      netfilter: nf_flow_table: count and limit hw offloaded entries
      netfilter: nf_flow_table: count pending offload workqueue tasks

William Tu (1):
      netfilter: nf_conncount: reduce unnecessary GC

 Documentation/networking/nf_conntrack-sysctl.rst |   9 ++
 include/net/net_namespace.h                      |   6 +
 include/net/netfilter/nf_conntrack_core.h        |   7 +-
 include/net/netfilter/nf_conntrack_count.h       |   1 +
 include/net/netfilter/nf_flow_table.h            |  57 +++++++++
 include/net/netns/flow_table.h                   |  14 +++
 net/ipv4/netfilter.c                             |   3 +-
 net/ipv6/netfilter.c                             |   3 +-
 net/netfilter/Kconfig                            |   9 ++
 net/netfilter/Makefile                           |   1 +
 net/netfilter/nf_conncount.c                     |  11 ++
 net/netfilter/nf_conntrack_netlink.c             |   2 +
 net/netfilter/nf_conntrack_proto_tcp.c           |  52 +-------
 net/netfilter/nf_flow_table_core.c               |  89 +++++++++++++-
 net/netfilter/nf_flow_table_offload.c            |  55 +++++++--
 net/netfilter/nf_flow_table_sysctl.c             | 148 +++++++++++++++++++++++
 net/netfilter/nf_tables_api.c                    |  12 +-
 net/netfilter/nfnetlink.c                        |  24 +---
 net/netfilter/nfnetlink_cttimeout.c              |   5 +-
 net/sched/act_ct.c                               |   5 +-
 20 files changed, 423 insertions(+), 90 deletions(-)
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/netfilter/nf_flow_table_sysctl.c
