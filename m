Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCF41FACD
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 12:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbhJBKKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 06:10:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45068 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhJBKKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 06:10:24 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6915F63EDC;
        Sat,  2 Oct 2021 12:07:09 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/4] Netfilter fixes for net (v2)
Date:   Sat,  2 Oct 2021 12:08:29 +0200
Message-Id: <20211002100833.21411-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Move back the defrag users fields to the global netns_nf area.
   Kernel fails to boot if conntrack is builtin and kernel is booted
   with: nf_conntrack.enable_hooks=1. From Florian Westphal.

2) Rule event notification is missing relevant context such as
   the position handle and the NLM_F_APPEND flag.

3) Rule replacement is expanded to add + delete using the existing
   rule handle, reverse order of this operation so it makes sense
   from rule notification standpoint.

4) Propagate to userspace the NLM_F_CREATE and NLM_F_EXCL flags
   from the rule notification path.

Patches #2, #3 and #4 are used by 'nft monitor' and 'iptables-monitor'
userspace utilities which are not correctly representing the following
operations through netlink notifications:

- rule insertions
- rule addition/insertion from position handle
- create table/chain/set/map/flowtable/...

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

In this round, I have keep back the patch 4/5 ("netfilter: nft_dynset:
relax superfluous check on set updates") coming in the previous series,
which is relaxing a bogus check in the dynset extension for the timeout
flag. Such patch has no existing users in the strict sense and it is
possible to route it through net-next.

Thanks.

----------------------------------------------------------------

The following changes since commit 3b1b6e82fb5e08e2cb355d7b2ee8644ec289de66:

  net: phy: enhance GPY115 loopback disable function (2021-09-27 13:49:38 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 6fb721cf781808ee2ca5e737fb0592cc68de3381:

  netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification (2021-10-02 12:00:17 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

Pablo Neira Ayuso (3):
      netfilter: nf_tables: add position handle in event notification
      netfilter: nf_tables: reverse order in rule replacement expansion
      netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  1 -
 include/net/netfilter/nf_tables.h           |  2 +-
 include/net/netns/netfilter.h               |  6 ++
 net/ipv4/netfilter/nf_defrag_ipv4.c         | 30 +++-------
 net/ipv6/netfilter/nf_conntrack_reasm.c     |  2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   | 25 +++-----
 net/netfilter/nf_tables_api.c               | 91 ++++++++++++++++++++---------
 net/netfilter/nft_quota.c                   |  2 +-
 8 files changed, 91 insertions(+), 68 deletions(-)
