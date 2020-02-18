Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657531635ED
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 23:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgBRWVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 17:21:08 -0500
Received: from correo.us.es ([193.147.175.20]:57476 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgBRWVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4AB2303D05
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3378DA3C2
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 23:21:06 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B87F8DA801; Tue, 18 Feb 2020 23:21:06 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2A8EDA72F;
        Tue, 18 Feb 2020 23:21:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Feb 2020 23:21:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C16CB42EE38E;
        Tue, 18 Feb 2020 23:21:04 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/9] Netfilter fixes for net
Date:   Tue, 18 Feb 2020 23:20:52 +0100
Message-Id: <20200218222101.635808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This batch contains Netfilter fixes for net:

1) Restrict hashlimit size to 1048576, from Cong Wang.

2) Check for offload flags from nf_flow_table_offload_setup(),
   this fixes a crash in case the hardware offload is disabled.
   From Florian Westphal.

3) Three preparation patches to extend the conntrack clash resolution,
   from Florian.

4) Extend clash resolution to deal with DNS packets from the same flow
   racing to set up the NAT configuration.

5) Small documentation fix in pipapo, from Stefano Brivio.

6) Remove misleading unlikely() from pipapo_refill(), also from Stefano.

7) Reduce hashlimit mutex scope, from Cong Wang. This patch is actually
   triggering another problem, still under discussion, another patch to
   fix this will follow up.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you.

----------------------------------------------------------------

The following changes since commit 259039fa30457986929a324d769f543c1509987f:

  Merge branch 'stmmac-fixes' (2020-02-07 11:36:22 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 9a7712048f9d43da5022e75eca3d6b81080e76d3:

  netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill() (2020-02-18 22:07:09 +0100)

----------------------------------------------------------------
Cong Wang (2):
      netfilter: xt_hashlimit: reduce hashlimit_mutex scope for htable_put()
      netfilter: xt_hashlimit: limit the max size of hashtable

Florian Westphal (5):
      netfilter: flowtable: skip offload setup if disabled
      netfilter: conntrack: remove two args from resolve_clash
      netfilter: conntrack: place confirm-bit setting in a helper
      netfilter: conntrack: split resolve_clash function
      netfilter: conntrack: allow insertion of clashing entries

Stefano Brivio (2):
      netfilter: nft_set_pipapo: Fix mapping table example in comments
      netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill()

 include/linux/rculist_nulls.h                      |   7 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |  12 +-
 net/netfilter/nf_conntrack_core.c                  | 192 ++++++++++++++++++---
 net/netfilter/nf_conntrack_proto_udp.c             |  20 ++-
 net/netfilter/nf_flow_table_offload.c              |   6 +-
 net/netfilter/nft_set_pipapo.c                     |   6 +-
 net/netfilter/xt_hashlimit.c                       |  22 ++-
 7 files changed, 220 insertions(+), 45 deletions(-)
