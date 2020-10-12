Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FBE28AB6F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgJLBia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:38:30 -0400
Received: from correo.us.es ([193.147.175.20]:41692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726562AbgJLBia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4ECA9E780F
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3EED0DA73F
        for <netdev@vger.kernel.org>; Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34A82DA704; Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52A20DA730;
        Mon, 12 Oct 2020 03:38:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1FFEA41FF201;
        Mon, 12 Oct 2020 03:38:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 0/6] Netfilter/IPVS updates for net-next
Date:   Mon, 12 Oct 2020 03:38:13 +0200
Message-Id: <20201012013819.23128-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter/IPVS updates for net-next:

1) Inspect the reply packets coming from DR/TUN and refresh connection
   state and timeout, from longguang yue and Julian Anastasov.

2) Series to add support for the inet ingress chain type in nf_tables.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit bc081a693a56061f68f736c5d596134ee3c87689:

  Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch' (2020-10-11 11:19:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to 793d5d61242695142460ce74f124281e0681fbc7:

  netfilter: flowtable: reduce calls to pskb_may_pull() (2020-10-12 01:58:10 +0200)

----------------------------------------------------------------
Pablo Neira Ayuso (5):
      netfilter: add nf_static_key_{inc,dec}
      netfilter: add nf_ingress_hook() helper function
      netfilter: add inet ingress support
      netfilter: nf_tables: add inet ingress support
      netfilter: flowtable: reduce calls to pskb_may_pull()

longguang.yue (1):
      ipvs: inspect reply packets from DR/TUN real servers

 include/net/netfilter/nf_tables.h      |   6 ++
 include/net/netfilter/nf_tables_ipv4.h |  33 +++++++++
 include/net/netfilter/nf_tables_ipv6.h |  46 ++++++++++++
 include/uapi/linux/netfilter.h         |   1 +
 net/netfilter/core.c                   | 129 ++++++++++++++++++++++++++-------
 net/netfilter/ipvs/ip_vs_conn.c        |  18 ++++-
 net/netfilter/ipvs/ip_vs_core.c        |  19 ++---
 net/netfilter/nf_flow_table_core.c     |  12 +--
 net/netfilter/nf_flow_table_ip.c       |  45 +++++++-----
 net/netfilter/nf_tables_api.c          |  14 ++--
 net/netfilter/nft_chain_filter.c       |  35 ++++++++-
 11 files changed, 282 insertions(+), 76 deletions(-)
