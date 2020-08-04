Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686123C063
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgHDUCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:02:40 -0400
Received: from correo.us.es ([193.147.175.20]:49372 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgHDUCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 16:02:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7C2B5DA7ED
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7275ADA73F
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 22:02:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 66B7CDA72F; Tue,  4 Aug 2020 22:02:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CD07DA73F;
        Tue,  4 Aug 2020 22:02:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 22:02:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 724F54265A32;
        Tue,  4 Aug 2020 22:02:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 0/5] Netfilter fixes for net
Date:   Tue,  4 Aug 2020 22:02:03 +0200
Message-Id: <20200804200208.18620-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Flush the cleanup xtables worker to make sure destructors
   have completed, from Florian Westphal.

2) iifgroup is matching erroneously, also from Florian.

3) Add selftest for meta interface matching, from Florian Westphal.

4) Move nf_ct_offload_timeout() to header, from Roi Dayan.

5) Call nf_ct_offload_timeout() from flow_offload_add() to
   make sure garbage collection does not evict offloaded flow,
   from Roi Dayan.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thank you!

----------------------------------------------------------------

The following changes since commit 85496a29224188051b6135eb38da8afd4c584765:

  net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe() (2020-07-30 17:45:13 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to 4203b19c27967d9eff6928f6a733f81892ffc592:

  netfilter: flowtable: Set offload timeout when adding flow (2020-08-03 12:37:24 +0200)

----------------------------------------------------------------
Florian Westphal (3):
      netfilter: nft_compat: make sure xtables destructors have run
      netfilter: nft_meta: fix iifgroup matching
      selftests: netfilter: add meta iif/oif match test

Roi Dayan (2):
      netfilter: conntrack: Move nf_ct_offload_timeout to header file
      netfilter: flowtable: Set offload timeout when adding flow

 include/net/netfilter/nf_conntrack.h          |  12 +++
 include/net/netfilter/nf_tables.h             |   2 +
 net/netfilter/nf_conntrack_core.c             |  12 ---
 net/netfilter/nf_flow_table_core.c            |   2 +
 net/netfilter/nf_tables_api.c                 |  10 ++-
 net/netfilter/nft_compat.c                    |  36 +++++++-
 net/netfilter/nft_meta.c                      |   2 +-
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 tools/testing/selftests/netfilter/nft_meta.sh | 124 ++++++++++++++++++++++++++
 9 files changed, 182 insertions(+), 20 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_meta.sh
