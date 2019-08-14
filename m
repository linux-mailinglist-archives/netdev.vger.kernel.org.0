Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763CE8CF4F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfHNJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:24:51 -0400
Received: from correo.us.es ([193.147.175.20]:42570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfHNJYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 05:24:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64716C40E4
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 530E250F3F
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 48A8FDA730; Wed, 14 Aug 2019 11:24:48 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4252D50F3F;
        Wed, 14 Aug 2019 11:24:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:24:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EE7494265A2F;
        Wed, 14 Aug 2019 11:24:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/7] Netfilter fixes for net
Date:   Wed, 14 Aug 2019 11:24:33 +0200
Message-Id: <20190814092440.20087-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset contains Netfilter fixes for net:

1) Extend selftest to cover flowtable with ipsec, from Florian Westphal.

2) Fix interaction of ipsec with flowtable, also from Florian.

3) User-after-free with bound set to rule that fails to load.

4) Adjust state and timeout for flows that expire.

5) Timeout update race with flows in teardown state.

6) Ensure conntrack id hash calculation use invariants as input,
   from Dirk Morris.

7) Do not push flows into flowtable for TCP fin/rst packets.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 5e5412c365a32e452daa762eac36121cb8a370bb:

  net/socket: fix GCC8+ Wpacked-not-aligned warnings (2019-08-03 11:02:46 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to dfe42be15fde16232340b8b2a57c359f51cc10d9:

  netfilter: nft_flow_offload: skip tcp rst and fin packets (2019-08-14 11:09:07 +0200)

----------------------------------------------------------------
Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Florian Westphal (2):
      selftests: netfilter: extend flowtable test script for ipsec
      netfilter: nf_flow_table: fix offload for flows that are subject to xfrm

Pablo Neira Ayuso (4):
      netfilter: nf_tables: use-after-free in failing rule with bound set
      netfilter: nf_flow_table: conntrack picks up expired flows
      netfilter: nf_flow_table: teardown flow timeout race
      netfilter: nft_flow_offload: skip tcp rst and fin packets

 include/net/netfilter/nf_tables.h                  |  9 +++-
 net/netfilter/nf_conntrack_core.c                  | 16 ++++----
 net/netfilter/nf_flow_table_core.c                 | 43 +++++++++++++------
 net/netfilter/nf_flow_table_ip.c                   | 43 +++++++++++++++++++
 net/netfilter/nf_tables_api.c                      | 15 ++++---
 net/netfilter/nft_flow_offload.c                   |  9 ++--
 tools/testing/selftests/netfilter/nft_flowtable.sh | 48 ++++++++++++++++++++++
 7 files changed, 153 insertions(+), 30 deletions(-)

