Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E848581A34
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 21:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiGZTVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 15:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGZTV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 15:21:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D3C237F5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:21:28 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGQ7R-00080k-J8; Tue, 26 Jul 2022 21:21:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/3] netfilter updates for net
Date:   Tue, 26 Jul 2022 21:20:53 +0200
Message-Id: <20220726192056.13497-1-fw@strlen.de>
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

Three late fixes for netfilter:

1) If nf_queue user requests packet truncation below size of l3 header,
   we corrupt the skb, then crash.  Reject such requests.

2) add cond_resched() calls when doing cycle detection in the
   nf_tables graph.  This avoids softlockup warning with certain
   rulesets.

3) Reject rulesets that use nftables 'queue' expression in family/chain
   combinations other than those that are supported.  Currently the ruleset
   will load, but when userspace attempts to reinject you get WARN splat +
   packet drops.

The following changes since commit 9b134b1694ec8926926ba6b7b80884ea829245a0:

  bridge: Do not send empty IFLA_AF_SPEC attribute (2022-07-26 15:35:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

for you to fetch changes up to 47f4f510ad586032b85c89a0773fbb011d412425:

  netfilter: nft_queue: only allow supported familes and hooks (2022-07-26 21:12:42 +0200)

----------------------------------------------------------------
Florian Westphal (3):
  netfilter: nf_queue: do not allow packet truncation below transport header offset
  netfilter: nf_tables: add rescheduling points during loop detection walks
  netfilter: nft_queue: only allow supported familes and hooks

 net/netfilter/nf_tables_api.c   |  6 ++++++
 net/netfilter/nfnetlink_queue.c |  7 ++++++-
 net/netfilter/nft_queue.c       | 27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)
-- 
2.35.1
