Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF57218EBC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgGHRqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:23 -0400
Received: from correo.us.es ([193.147.175.20]:34714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgGHRqV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B96C93066A6
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA8BEDA722
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A066FDA796; Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63836DA722;
        Wed,  8 Jul 2020 19:46:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3693C4265A2F;
        Wed,  8 Jul 2020 19:46:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 00/12] Netfilter/IPVS updates for net-next
Date:   Wed,  8 Jul 2020 19:45:57 +0200
Message-Id: <20200708174609.1343-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Support for rejecting packets from the prerouting chain, from
   Laura Garcia Liebana.

2) Remove useless assignment in pipapo, from Stefano Brivio.

3) On demand hook registration in IPVS, from Julian Anastasov.

4) Expire IPVS connection from process context to not overload
   timers, also from Julian.

5) Fallback to conntrack TCP tracker to handle connection reuse
   in IPVS, from Julian Anastasov.

6) Several patches to support for chain bindings.

7) Expose enum nft_chain_flags through UAPI.

8) Reject unsupported chain flags from the netlink control plane.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thank you.

----------------------------------------------------------------

The following changes since commit 5fb62372a0207f1514fa6052c51991198c46ffe2:

  Merge branch 'dpaa2-eth-send-a-scatter-gather-FD-instead-of-realloc-ing' (2020-06-29 17:42:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git HEAD

for you to fetch changes up to c1f79a2eefdcc0aef5d7a911c27a3f75f1936ecd:

  netfilter: nf_tables: reject unsupported chain flags (2020-07-04 02:51:28 +0200)

----------------------------------------------------------------
Julian Anastasov (3):
      ipvs: register hooks only with services
      ipvs: avoid expiring many connections from timer
      ipvs: allow connection reuse for unconfirmed conntrack

Laura Garcia Liebana (1):
      netfilter: introduce support for reject at prerouting stage

Pablo Neira Ayuso (7):
      netfilter: nf_tables: add NFTA_CHAIN_ID attribute
      netfilter: nf_tables: add NFTA_RULE_CHAIN_ID attribute
      netfilter: nf_tables: add NFTA_VERDICT_CHAIN_ID attribute
      netfilter: nf_tables: expose enum nft_chain_flags through UAPI
      netfilter: nf_tables: add nft_chain_add()
      netfilter: nf_tables: add NFT_CHAIN_BINDING
      netfilter: nf_tables: reject unsupported chain flags

Stefano Brivio (1):
      netfilter: nft_set_pipapo: Drop useless assignment of scratch  map index on insert

 include/net/ip_vs.h                      |  15 ++-
 include/net/netfilter/nf_tables.h        |  23 ++--
 include/uapi/linux/netfilter/nf_tables.h |  14 +++
 net/ipv4/netfilter/nf_reject_ipv4.c      |  21 ++++
 net/ipv6/netfilter/nf_reject_ipv6.c      |  26 +++++
 net/netfilter/ipvs/ip_vs_conn.c          |  53 ++++++---
 net/netfilter/ipvs/ip_vs_core.c          |  92 +++++++++++----
 net/netfilter/ipvs/ip_vs_ctl.c           |  29 ++++-
 net/netfilter/nf_tables_api.c            | 188 +++++++++++++++++++++++++------
 net/netfilter/nft_immediate.c            |  51 +++++++++
 net/netfilter/nft_reject.c               |   3 +-
 net/netfilter/nft_set_pipapo.c           |   2 -
 12 files changed, 428 insertions(+), 89 deletions(-)
