Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC44241CFAD
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbhI2XGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:06:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34766 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346417AbhI2XGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:06:47 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3808E63586;
        Thu, 30 Sep 2021 01:03:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/5] Netfilter fixes for net
Date:   Thu, 30 Sep 2021 01:04:55 +0200
Message-Id: <20210929230500.811946-1-pablo@netfilter.org>
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

4) Remove superfluous check in the dynamic set extension which
   disallow update commands on a set without timeout.

5) Propagate to userspace the NLM_F_CREATE and NLM_F_EXCL flags
   from the rule notification path.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 3b1b6e82fb5e08e2cb355d7b2ee8644ec289de66:

  net: phy: enhance GPY115 loopback disable function (2021-09-27 13:49:38 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 3d3b30175a51cf027201670af3e2e5b05447b985:

  netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification (2021-09-28 13:04:56 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1

Pablo Neira Ayuso (4):
      netfilter: nf_tables: add position handle in event notification
      netfilter: nf_tables: reverse order in rule replacement expansion
      netfilter: nft_dynset: relax superfluous check on set updates
      netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification

 include/net/netfilter/ipv6/nf_defrag_ipv6.h |  1 -
 include/net/netfilter/nf_tables.h           |  2 +-
 include/net/netns/netfilter.h               |  6 ++
 net/ipv4/netfilter/nf_defrag_ipv4.c         | 30 +++-------
 net/ipv6/netfilter/nf_conntrack_reasm.c     |  2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c   | 25 +++-----
 net/netfilter/nf_tables_api.c               | 91 ++++++++++++++++++++---------
 net/netfilter/nft_dynset.c                  | 11 +---
 net/netfilter/nft_quota.c                   |  2 +-
 9 files changed, 92 insertions(+), 78 deletions(-)
