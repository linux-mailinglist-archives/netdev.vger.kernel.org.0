Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B105BF7D4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiIUHim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIUHim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:38:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C4483F07;
        Wed, 21 Sep 2022 00:38:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oauJX-0005QG-R2; Wed, 21 Sep 2022 09:38:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/5] netfilter: bugfixes for net
Date:   Wed, 21 Sep 2022 09:38:20 +0200
Message-Id: <20220921073825.4658-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The following set contains netfilter fixes for the *net* tree.

Regressions (rc only):
recent ebtables crash fix was incomplete, it added a memory leak.

The patch to fix possible buffer overrun for BIG TCP in ftp conntrack
tried to be too clever, we cannot re-use ct->lock: NAT engine might
grab it again -> deadlock.  Revert back to a global spinlock.
Both from myself.

Remove the documentation for the recently removed
'nf_conntrack_helper' sysctl as well, from Pablo Neira.

The static_branch_inc() that guards the 'chain stats enabled' path
needs to be deferred further, until the entire transaction was created.
From Tetsuo Handa.

Older bugs:
Since 5.3:
nf_tables_addchain may leak pcpu memory in error path when
offloading fails. Also from Tetsuo Handa.

Please consider pulling these changes from
  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

----------------------------------------------------------------
The following changes since commit 603ccb3aca717d04a4b1a04e3a7bc3b91eba33e8:

  MAINTAINERS: Add myself as a reviewer for Qualcomm ETHQOS Ethernet driver (2022-09-20 13:42:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git master

for you to fetch changes up to d25088932227680988a6b794221e031a7232f137:

  netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed (2022-09-20 23:50:03 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: ebtables: fix memory leak when blob is malformed
      netfilter: nf_ct_ftp: fix deadlock when nat rewrite is needed

Pablo Neira Ayuso (1):
      netfilter: conntrack: remove nf_conntrack_helper documentation

Tetsuo Handa (2):
      netfilter: nf_tables: fix nft_counters_enabled underflow at nf_tables_addchain()
      netfilter: nf_tables: fix percpu memory leak at nf_tables_addchain()

 Documentation/networking/nf_conntrack-sysctl.rst | 9 ---------
 net/bridge/netfilter/ebtables.c                  | 4 +++-
 net/netfilter/nf_conntrack_ftp.c                 | 6 ++++--
 net/netfilter/nf_tables_api.c                    | 8 ++++----
 4 files changed, 11 insertions(+), 16 deletions(-)
