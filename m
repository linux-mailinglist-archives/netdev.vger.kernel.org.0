Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A80120A4E8
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406214AbgFYS0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:26:47 -0400
Received: from correo.us.es ([193.147.175.20]:33462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404317AbgFYS0q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1096FC5EC
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFF50DA861
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B366CDA85D; Thu, 25 Jun 2020 20:26:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17A20DA73F;
        Thu, 25 Jun 2020 20:26:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DF62B42EE38F;
        Thu, 25 Jun 2020 20:26:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Thu, 25 Jun 2020 20:26:28 +0200
Message-Id: <20200625182635.1958-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net, they are:

1) Unaligned atomic access in ipset, from Russell King.

2) Missing module description, from Rob Gill.

3) Patches to fix a module unload causing NULL pointer dereference in
   xtables, from David Wilder. For the record, I posting here his cover
   letter explaining the problem:

    A crash happened on ppc64le when running ltp network tests triggered by
    "rmmod iptable_mangle".

    See previous discussion in this thread:
    https://lists.openwall.net/netdev/2020/06/03/161 .

    In the crash I found in iptable_mangle_hook() that
    state->net->ipv4.iptable_mangle=NULL causing a NULL pointer dereference.
    net->ipv4.iptable_mangle is set to NULL in +iptable_mangle_net_exit() and
    called when ip_mangle modules is unloaded. A rmmod task was found running
    in the crash dump.  A 2nd crash showed the same problem when running
    "rmmod iptable_filter" (net->ipv4.iptable_filter=NULL).

    To fix this I added .pre_exit hook in all iptable_foo.c. The pre_exit will
    un-register the underlying hook and exit would do the table freeing. The
    netns core does an unconditional +synchronize_rcu after the pre_exit hooks
    insuring no packets are in flight that have picked up the pointer before
    completing the un-register.

    These patches include changes for both iptables and ip6tables.

    We tested this fix with ltp running iptables01.sh and iptables01.sh -6 a
    loop for 72 hours.

4) Add a selftest for conntrack helper assignment, from Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 67c20de35a3cc2e2cd940f95ebd85ed0a765315a:

  net: Add MODULE_DESCRIPTION entries to network modules (2020-06-20 21:33:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 619ae8e0697a6fb85b99b19137590c7c337c579e:

  selftests: netfilter: add test case for conntrack helper assignment (2020-06-25 00:50:31 +0200)

----------------------------------------------------------------
David Wilder (4):
      netfilter: iptables: Split ipt_unregister_table() into pre_exit and exit helpers.
      netfilter: iptables: Add a .pre_exit hook in all iptable_foo.c.
      netfilter: ip6tables: Split ip6t_unregister_table() into pre_exit and exit helpers.
      netfilter: ip6tables: Add a .pre_exit hook in all ip6table_foo.c.

Florian Westphal (1):
      selftests: netfilter: add test case for conntrack helper assignment

Rob Gill (1):
      netfilter: Add MODULE_DESCRIPTION entries to kernel modules

Russell King (1):
      netfilter: ipset: fix unaligned atomic access

 include/linux/netfilter_ipv4/ip_tables.h           |   6 +
 include/linux/netfilter_ipv6/ip6_tables.h          |   3 +
 net/bridge/netfilter/nft_meta_bridge.c             |   1 +
 net/bridge/netfilter/nft_reject_bridge.c           |   1 +
 net/ipv4/netfilter/ip_tables.c                     |  15 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c                  |   1 +
 net/ipv4/netfilter/iptable_filter.c                |  10 +-
 net/ipv4/netfilter/iptable_mangle.c                |  10 +-
 net/ipv4/netfilter/iptable_nat.c                   |  10 +-
 net/ipv4/netfilter/iptable_raw.c                   |  10 +-
 net/ipv4/netfilter/iptable_security.c              |  11 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            |   1 +
 net/ipv4/netfilter/nft_dup_ipv4.c                  |   1 +
 net/ipv4/netfilter/nft_fib_ipv4.c                  |   1 +
 net/ipv4/netfilter/nft_reject_ipv4.c               |   1 +
 net/ipv6/netfilter/ip6_tables.c                    |  15 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c                 |   1 +
 net/ipv6/netfilter/ip6table_filter.c               |  10 +-
 net/ipv6/netfilter/ip6table_mangle.c               |  10 +-
 net/ipv6/netfilter/ip6table_nat.c                  |  10 +-
 net/ipv6/netfilter/ip6table_raw.c                  |  10 +-
 net/ipv6/netfilter/ip6table_security.c             |  10 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c            |   1 +
 net/ipv6/netfilter/nft_dup_ipv6.c                  |   1 +
 net/ipv6/netfilter/nft_fib_ipv6.c                  |   1 +
 net/ipv6/netfilter/nft_reject_ipv6.c               |   1 +
 net/netfilter/ipset/ip_set_core.c                  |   2 +
 net/netfilter/nf_dup_netdev.c                      |   1 +
 net/netfilter/nf_flow_table_core.c                 |   1 +
 net/netfilter/nf_flow_table_inet.c                 |   1 +
 net/netfilter/nf_synproxy_core.c                   |   1 +
 net/netfilter/nfnetlink.c                          |   1 +
 net/netfilter/nft_compat.c                         |   1 +
 net/netfilter/nft_connlimit.c                      |   1 +
 net/netfilter/nft_counter.c                        |   1 +
 net/netfilter/nft_ct.c                             |   1 +
 net/netfilter/nft_dup_netdev.c                     |   1 +
 net/netfilter/nft_fib_inet.c                       |   1 +
 net/netfilter/nft_fib_netdev.c                     |   1 +
 net/netfilter/nft_flow_offload.c                   |   1 +
 net/netfilter/nft_hash.c                           |   1 +
 net/netfilter/nft_limit.c                          |   1 +
 net/netfilter/nft_log.c                            |   1 +
 net/netfilter/nft_masq.c                           |   1 +
 net/netfilter/nft_nat.c                            |   1 +
 net/netfilter/nft_numgen.c                         |   1 +
 net/netfilter/nft_objref.c                         |   1 +
 net/netfilter/nft_osf.c                            |   1 +
 net/netfilter/nft_queue.c                          |   1 +
 net/netfilter/nft_quota.c                          |   1 +
 net/netfilter/nft_redir.c                          |   1 +
 net/netfilter/nft_reject.c                         |   1 +
 net/netfilter/nft_reject_inet.c                    |   1 +
 net/netfilter/nft_synproxy.c                       |   1 +
 net/netfilter/nft_tunnel.c                         |   1 +
 net/netfilter/xt_nat.c                             |   1 +
 tools/testing/selftests/netfilter/Makefile         |   2 +-
 .../selftests/netfilter/nft_conntrack_helper.sh    | 175 +++++++++++++++++++++
 58 files changed, 344 insertions(+), 16 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_conntrack_helper.sh
