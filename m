Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546A5417D8D
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 00:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345269AbhIXWNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 18:13:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49746 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhIXWMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 18:12:53 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id C58DD63EA4;
        Sat, 25 Sep 2021 00:09:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 00/15] Netfilter/IPVS fixes for net
Date:   Sat, 25 Sep 2021 00:10:58 +0200
Message-Id: <20210924221113.348767-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS fixes for net:

1) ipset limits the max allocatable memory via kvmalloc() to MAX_INT,
   from Jozsef Kadlecsik.

2) Check ip_vs_conn_tab_bits value to be in the range specified
   in Kconfig, from Andrea Claudi.

3) Initialize fragment offset in ip6tables, from Jeremy Sowden.

4) Make conntrack hash chain length random, from Florian Westphal.

5) Add zone ID to conntrack and NAT hashtuple again, also from Florian.

6) Add selftests for bidirectional zone support and colliding tuples,
   from Florian Westphal.

7) Unlink table before synchronize_rcu when cleaning tables with
   owner, from Florian.

8) ipset limits the max allocatable memory via kvmalloc() to MAX_INT.

9) Release conntrack entries via workqueue in masquerade, from Florian.

10) Fix bogus net_init in iptables raw table definition, also from Florian.

11) Work around missing softdep in log extensions, from Florian Westphal.

12) Serialize hash resizes and cleanups with mutex, from Eric Dumazet.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 276aae377206d60b9b7b7df4586cd9f2a813f5d0:

  net: stmmac: fix system hang caused by eee_ctrl_timer during suspend/resume (2021-09-08 12:28:26 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to e9edc188fc76499b0b9bd60364084037f6d03773:

  netfilter: conntrack: serialize hash resizes and cleanups (2021-09-21 03:46:56 +0200)

----------------------------------------------------------------
Andrea Claudi (1):
      ipvs: check that ip_vs_conn_tab_bits is between 8 and 20

Eric Dumazet (1):
      netfilter: conntrack: serialize hash resizes and cleanups

Florian Westphal (10):
      netfilter: conntrack: make max chain length random
      netfilter: conntrack: include zone id in tuple hash again
      netfilter: nat: include zone id in nat table hash again
      selftests: netfilter: add selftest for directional zone support
      selftests: netfilter: add zone stress test with colliding tuples
      netfilter: nf_tables: unlink table before deleting it
      netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
      netfilter: nf_nat_masquerade: defer conntrack walk to work queue
      netfilter: iptable_raw: drop bogus net_init annotation
      netfilter: log: work around missing softdep backend module

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix oversized kvmalloc() calls

Pablo Neira Ayuso (1):
      netfilter: nf_tables: Fix oversized kvmalloc() calls

 net/ipv4/netfilter/iptable_raw.c                   |   2 +-
 net/ipv6/netfilter/ip6_tables.c                    |   1 +
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |   4 +
 net/netfilter/nf_conntrack_core.c                  | 154 ++++++----
 net/netfilter/nf_nat_core.c                        |  17 +-
 net/netfilter/nf_nat_masquerade.c                  | 168 ++++++-----
 net/netfilter/nf_tables_api.c                      |  30 +-
 net/netfilter/nft_compat.c                         |  17 +-
 net/netfilter/xt_LOG.c                             |  10 +-
 net/netfilter/xt_NFLOG.c                           |  10 +-
 tools/testing/selftests/netfilter/nft_nat_zones.sh | 309 +++++++++++++++++++++
 .../testing/selftests/netfilter/nft_zones_many.sh  | 156 +++++++++++
 13 files changed, 735 insertions(+), 147 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_nat_zones.sh
 create mode 100755 tools/testing/selftests/netfilter/nft_zones_many.sh
