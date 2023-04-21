Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11B86EB551
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbjDUXCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjDUXCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3846DE57;
        Fri, 21 Apr 2023 16:02:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 00/20] Netfilter/IPVS updates for net-next
Date:   Sat, 22 Apr 2023 01:01:51 +0200
Message-Id: <20230421230211.214635-1-pablo@netfilter.org>
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

The following patchset contains Netfilter updates for net-next:

1) DCCP option matching support, from Jeremy Sowden.

2) Reduce jumpstack footprint: Stash chain in last rule marker in blob for
   tracing. Remove last rule and chain from jumpstack. From Florian Westphal.

3) nf_tables validates all tables before committing the new rules.
   Unfortunately, this has two drawbacks:

   - Since addition of the transaction mutex pernet state gets written to
     outside of the locked section from the cleanup callback, this is
     wrong so do this cleanup directly after table has passed all checks.

   - Revalidate tables that saw no changes. This can be avoided by
     keeping the validation state per table, not per netns.

   From Florian Westphal.

4) Get rid of a few redundant pointers in the traceinfo structure.
   The three removed pointers are used in the expression evaluation loop,
   so gcc keeps them in registers. Passing them to the (inlined) helpers
   thus doesn't increase nft_do_chain text size, while stack is reduced
   by another 24 bytes on 64bit arches. From Florian Westphal.

5) IPVS cleanups in several ways without implementing any functional
   changes, aside from removing some debugging output:

   - Update width of source for ip_vs_sync_conn_options
     The operation is safe, use an annotation to describe it properly.

   - Consistently use array_size() in ip_vs_conn_init()
     It seems better to use helpers consistently.

   - Remove {Enter,Leave}Function. These seem to be well past their
     use-by date.

   - Correct spelling in comments.

   From Simon Horman.

6) Extended netlink error report for netdevice in flowtables and
   netdev/chains. Allow for incrementally add/delete devices to netdev
   basechain. Allow to create netdev chain without device.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit ca288965801572fe41386560d4e6c5cc0e5cc56d:

  Merge tag 'wireless-next-2023-04-21' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2023-04-21 07:35:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-23-04-22

for you to fetch changes up to c7ce03c47ae836cad7d95fc08dc564452fe9b6e3:

  netfilter: nf_tables: allow to create netdev chain without device (2023-04-22 00:23:35 +0200)

----------------------------------------------------------------
netfilter pull request 23-04-22

----------------------------------------------------------------
Florian Westphal (9):
      netfilter: nf_tables: merge nft_rules_old structure and end of ruleblob marker
      netfilter: nf_tables: don't store address of last rule on jump
      netfilter: nf_tables: don't store chain address on jump
      netfilter: nf_tables: don't write table validation state without mutex
      netfilter: nf_tables: make validation state per table
      netfilter: nf_tables: remove unneeded conditional
      netfilter: nf_tables: do not store pktinfo in traceinfo structure
      netfilter: nf_tables: do not store verdict in traceinfo structure
      netfilter: nf_tables: do not store rule in traceinfo structure

Jeremy Sowden (1):
      netfilter: nft_exthdr: add boolean DCCP option matching

Pablo Neira Ayuso (6):
      netfilter: nf_tables: extended netlink error reporting for netdevice
      netfilter: nf_tables: do not send complete notification of deletions
      netfilter: nf_tables: rename function to destroy hook list
      netfilter: nf_tables: support for adding new devices to an existing netdev chain
      netfilter: nf_tables: support for deleting devices in an existing netdev chain
      netfilter: nf_tables: allow to create netdev chain without device

Simon Horman (4):
      ipvs: Update width of source for ip_vs_sync_conn_options
      ipvs: Consistently use array_size() in ip_vs_conn_init()
      ipvs: Remove {Enter,Leave}Function
      ipvs: Correct spelling in comments

 include/linux/netfilter/nfnetlink.h      |   1 -
 include/net/ip_vs.h                      |  32 +-
 include/net/netfilter/nf_tables.h        |  35 +-
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/ipvs/ip_vs_conn.c          |  12 +-
 net/netfilter/ipvs/ip_vs_core.c          |   8 -
 net/netfilter/ipvs/ip_vs_ctl.c           |  26 +-
 net/netfilter/ipvs/ip_vs_sync.c          |   7 +-
 net/netfilter/ipvs/ip_vs_xmit.c          |  62 +---
 net/netfilter/nf_tables_api.c            | 539 ++++++++++++++++++++-----------
 net/netfilter/nf_tables_core.c           |  59 ++--
 net/netfilter/nf_tables_trace.c          |  62 ++--
 net/netfilter/nfnetlink.c                |   2 -
 net/netfilter/nft_exthdr.c               | 105 ++++++
 14 files changed, 570 insertions(+), 382 deletions(-)
