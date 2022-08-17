Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BAA597087
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiHQOBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbiHQOA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:00:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9CC95E61;
        Wed, 17 Aug 2022 07:00:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJbG-0008Np-9U; Wed, 17 Aug 2022 16:00:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 00/17] netfilter: conntrack and nf_tables bug fixes
Date:   Wed, 17 Aug 2022 15:59:58 +0200
Message-Id: <20220817140015.25843-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patchset contains netfilter fixes for net.

Broken since 5.19:
A few ancient connection tracking helpers assume TCP packets cannot
exceed 64kb in size, but this isn't the case anymore with 5.19 when
BIG TCP got merged, from myself.

Regressions since 5.19:
1. 'conntrack -E expect' won't display anything because nfnetlink failed
to enable events for expectations, only for normal conntrack events.

2. partially revert change that added resched calls to a function that can
   be in atomic context.  Both broken and fixed up by myself.

Broken for several releases (up to original merge of nf_tables):
Several fixes for nf_tables control plane, from Pablo.
This fixes up resource leaks in error paths and adds more sanity
checks for mutually exclusive attributes/flags.

Kconfig:
NF_CONNTRACK_PROCFS is very old and doesn't provide all info provided
via ctnetlink, so it should not default to y. From Geert Uytterhoeven.

Selftests:
rework nft_flowtable.sh: it frequently indicated failure; the way it
tried to detect an offload failure did not work reliably.

Please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

The following changes since commit f329a0ebeaba4ffe91d431e0ac1ca7f9165872a4:

  genetlink: correct uAPI defines (2022-08-10 13:49:50 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git 

for you to fetch changes up to c8550b9077d271b9b4fbe5a9a260eb021f371c4f:

  testing: selftests: nft_flowtable.sh: rework test to detect offload failure (2022-08-17 15:12:01 +0200)

----------------------------------------------------------------
Florian Westphal (8):
      netfilter: nf_ct_sane: remove pseudo skb linearization
      netfilter: nf_ct_h323: cap packet size at 64k
      netfilter: nf_ct_ftp: prefer skb_linearize
      netfilter: nf_ct_irc: cap packet search space to 4k
      netfilter: nf_tables: fix scheduling-while-atomic splat
      netfilter: nfnetlink: re-enable conntrack expectation events
      testing: selftests: nft_flowtable.sh: use random netns names
      testing: selftests: nft_flowtable.sh: rework test to detect offload failure

Geert Uytterhoeven (1):
      netfilter: conntrack: NF_CONNTRACK_PROCFS should no longer default to y

Pablo Neira Ayuso (8):
      netfilter: nf_tables: use READ_ONCE and WRITE_ONCE for shared generation id access
      netfilter: nf_tables: disallow NFTA_SET_ELEM_KEY_END with NFT_SET_ELEM_INTERVAL_END flag
      netfilter: nf_tables: possible module reference underflow in error path
      netfilter: nf_tables: really skip inactive sets when allocating name
      netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on NFT_SET_OBJECT flag
      netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
      netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
      netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified

 include/net/netns/conntrack.h                      |   2 +-
 net/netfilter/Kconfig                              |   1 -
 net/netfilter/nf_conntrack_ftp.c                   |  24 +-
 net/netfilter/nf_conntrack_h323_main.c             |  10 +-
 net/netfilter/nf_conntrack_irc.c                   |  12 +-
 net/netfilter/nf_conntrack_sane.c                  |  68 ++--
 net/netfilter/nf_tables_api.c                      |  74 +++-
 net/netfilter/nfnetlink.c                          |  83 ++++-
 tools/testing/selftests/netfilter/nft_flowtable.sh | 377 +++++++++++----------
 9 files changed, 390 insertions(+), 261 deletions(-)
