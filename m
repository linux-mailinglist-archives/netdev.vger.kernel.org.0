Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956A269AB8C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjBQMa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjBQMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:30:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 714256782C;
        Fri, 17 Feb 2023 04:30:05 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 0/6] Netfilter/IPVS updates for net-next
Date:   Fri, 17 Feb 2023 13:29:51 +0100
Message-Id: <20230217122957.799277-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter updates for net-next:

1) Add safeguard to check for NULL tupe in objects updates via
   NFT_MSG_NEWOBJ, this should not ever happen. From Alok Tiwari.

2) Incorrect pointer check in the new destroy rule command,
   from Yang Yingliang.

3) Incorrect status bitcheck in nf_conntrack_udp_packet(),
   from Florian Westphal.

4) Simplify seq_print_acct(), from Ilia Gavrilov.

5) Use 2-arg optimal variant of kfree_rcu() in IPVS,
   from Julian Anastasov.

6) TCP connection enters CLOSE state in conntrack for locally
   originated TCP reset packet from the reject target,
   from Florian Westphal.

The fixes #2 and #3 in this series address issues from the previous pull
nf-next request in this net-next cycle.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit dd25cfab16e6bff1bbd75b42b8334c4419c90a4f:

  Merge branch 'net-ipa-remaining-ipa-v5-0-support' (2023-01-31 21:45:54 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 2954fe60e33da0f4de4d81a4c95c7dddb517d00c:

  netfilter: let reset rules clean out conntrack entries (2023-02-17 13:04:56 +0100)

----------------------------------------------------------------
Alok Tiwari (1):
      netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Florian Westphal (2):
      netfilter: conntrack: udp: fix seen-reply test
      netfilter: let reset rules clean out conntrack entries

Gavrilov Ilia (1):
      netfilter: conntrack: remote a return value of the 'seq_print_acct' function.

Julian Anastasov (1):
      ipvs: avoid kfree_rcu without 2nd arg

Yang Yingliang (1):
      netfilter: nf_tables: fix wrong pointer passed to PTR_ERR()

 include/linux/netfilter.h               |  3 +++
 include/net/ip_vs.h                     |  1 +
 include/net/netfilter/nf_conntrack.h    |  8 ++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c     |  1 +
 net/ipv6/netfilter/nf_reject_ipv6.c     |  1 +
 net/netfilter/core.c                    | 16 +++++++++++++++
 net/netfilter/ipvs/ip_vs_est.c          |  2 +-
 net/netfilter/nf_conntrack_core.c       | 12 +++++++++++
 net/netfilter/nf_conntrack_proto_tcp.c  | 35 +++++++++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_proto_udp.c  |  2 +-
 net/netfilter/nf_conntrack_standalone.c | 12 ++++-------
 net/netfilter/nf_tables_api.c           |  5 ++++-
 12 files changed, 87 insertions(+), 11 deletions(-)
