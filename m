Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21323A1F2F
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhFIVrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60454 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFIVrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8994063087;
        Wed,  9 Jun 2021 23:44:13 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/13] Netfilter updates for net-next
Date:   Wed,  9 Jun 2021 23:45:10 +0200
Message-Id: <20210609214523.1678-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add nfgenmsg field to nfnetlink's struct nfnl_info and use it.

2) Remove nft_ctx_init_from_elemattr() and nft_ctx_init_from_setattr()
   helper functions.

3) Add the nf_ct_pernet() helper function to fetch the conntrack
   pernetns data area.

4) Expose TCP and UDP flowtable offload timeouts through sysctl,
   from Oz Shlomo.

5) Add nfnetlink_hook subsystem to fetch the netfilter hook
   pipeline configuration, from Florian Westphal. This also includes
   a new field to annotate the hook type as metadata.

6) Fix unsafe memory access to non-linear skbuff in the new SCTP
   chunk support for nft_exthdr, from Phil Sutter.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you!

----------------------------------------------------------------

The following changes since commit 1a42624aecba438f1d114430a14b640cdfa51c87:

  net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table (2021-06-04 14:49:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to c5c6accd7b7e10434d6afda4f6a5107c480bb4fb:

  netfilter: nf_tables: move base hook annotation to init helper (2021-06-09 21:29:23 +0200)

----------------------------------------------------------------
Colin Ian King (1):
      netfilter: nfnetlink_hook: fix array index out-of-bounds error

Florian Westphal (4):
      netfilter: annotate nf_tables base hook ops
      netfilter: add new hook nfnl subsystem
      netfilter: nfnetlink_hook: add depends-on nftables
      netfilter: nf_tables: move base hook annotation to init helper

Oz Shlomo (3):
      netfilter: conntrack: Introduce tcp offload timeout configuration
      netfilter: conntrack: Introduce udp offload timeout configuration
      netfilter: flowtable: Set offload timeouts according to proto values

Pablo Neira Ayuso (4):
      netfilter: nfnetlink: add struct nfgenmsg to struct nfnl_info and use it
      netfilter: nf_tables: remove nft_ctx_init_from_elemattr()
      netfilter: nf_tables: remove nft_ctx_init_from_setattr()
      netfilter: nftables: add nf_ct_pernet() helper function

Phil Sutter (1):
      netfilter: nft_exthdr: Fix for unsafe packet data read

 include/linux/netfilter.h                     |   8 +-
 include/linux/netfilter/nfnetlink.h           |   1 +
 include/net/netfilter/nf_conntrack.h          |   7 +
 include/net/netfilter/nf_flow_table.h         |   2 +
 include/net/netns/conntrack.h                 |   8 +
 include/uapi/linux/netfilter/nfnetlink.h      |   3 +-
 include/uapi/linux/netfilter/nfnetlink_hook.h |  55 ++++
 net/netfilter/Kconfig                         |  10 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nf_conntrack_core.c             |  22 +-
 net/netfilter/nf_conntrack_ecache.c           |   8 +-
 net/netfilter/nf_conntrack_expect.c           |  12 +-
 net/netfilter/nf_conntrack_helper.c           |   6 +-
 net/netfilter/nf_conntrack_netlink.c          |  23 +-
 net/netfilter/nf_conntrack_proto.c            |   6 +-
 net/netfilter/nf_conntrack_proto_tcp.c        |   5 +
 net/netfilter/nf_conntrack_proto_udp.c        |   5 +
 net/netfilter/nf_conntrack_standalone.c       |  54 +++-
 net/netfilter/nf_flow_table_core.c            |  47 +++-
 net/netfilter/nf_flow_table_offload.c         |   4 +-
 net/netfilter/nf_tables_api.c                 | 202 ++++++--------
 net/netfilter/nfnetlink.c                     |   3 +
 net/netfilter/nfnetlink_hook.c                | 375 ++++++++++++++++++++++++++
 net/netfilter/nfnetlink_log.c                 |   5 +-
 net/netfilter/nfnetlink_queue.c               |   9 +-
 net/netfilter/nft_compat.c                    |  17 +-
 net/netfilter/nft_exthdr.c                    |   4 +-
 27 files changed, 697 insertions(+), 205 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nfnetlink_hook.h
 create mode 100644 net/netfilter/nfnetlink_hook.c
