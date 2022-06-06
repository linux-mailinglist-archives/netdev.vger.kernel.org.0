Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B287F53F18A
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiFFVVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiFFVVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:21:06 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27A2BC4EBC;
        Mon,  6 Jun 2022 14:21:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/7] Netfilter fixes for net
Date:   Mon,  6 Jun 2022 23:20:48 +0200
Message-Id: <20220606212055.98300-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix NAT support for NFPROTO_INET without layer 3 address,
   from Florian Westphal.

2) Use kfree_rcu(ptr, rcu) variant in nf_tables clean_net path.

3) Use list to collect flowtable hooks to be deleted.

4) Initialize list of hook field in flowtable transaction.

5) Release hooks on error for flowtable updates.

6) Memleak in hardware offload rule commit and abort paths.

7) Early bail out in case device does not support for hardware offload.
   This adds a new interface to net/core/flow_offload.c to check if the
   flow indirect block list is empty.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 0a375c822497ed6ad6b5da0792a12a6f1af10c0b:

  tcp: tcp_rtx_synack() can be called from process context (2022-05-31 21:40:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 3a41c64d9c1185a2f3a184015e2a9b78bfc99c71:

  netfilter: nf_tables: bail out early if hardware offload is not supported (2022-06-06 19:19:15 +0200)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nat: really support inet nat without l3 address

Pablo Neira Ayuso (6):
      netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
      netfilter: nf_tables: delete flowtable hooks via transaction list
      netfilter: nf_tables: always initialize flowtable hook list in transaction
      netfilter: nf_tables: release new hooks on unsupported flowtable flags
      netfilter: nf_tables: memleak flow rule from commit path
      netfilter: nf_tables: bail out early if hardware offload is not supported

 include/net/flow_offload.h                   |  1 +
 include/net/netfilter/nf_tables.h            |  1 -
 include/net/netfilter/nf_tables_offload.h    |  2 +-
 net/core/flow_offload.c                      |  6 ++++
 net/netfilter/nf_tables_api.c                | 54 ++++++++++++----------------
 net/netfilter/nf_tables_offload.c            | 23 +++++++++++-
 net/netfilter/nft_nat.c                      |  3 +-
 tools/testing/selftests/netfilter/nft_nat.sh | 43 ++++++++++++++++++++++
 8 files changed, 98 insertions(+), 35 deletions(-)
