Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81594FB98E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiDKKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiDKKaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8E3F2B258;
        Mon, 11 Apr 2022 03:27:48 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 87D9E625B9;
        Mon, 11 Apr 2022 12:23:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 00/11] Netfilter updates for net-next
Date:   Mon, 11 Apr 2022 12:27:33 +0200
Message-Id: <20220411102744.282101-1-pablo@netfilter.org>
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

1) Replace unnecessary list_for_each_entry_continue() in nf_tables,
   from Jakob Koschel.

2) Add struct nf_conntrack_net_ecache to conntrack event cache and
   use it, from Florian Westphal.

3) Refactor ctnetlink_dump_list(), also from Florian.

4) Bump module reference counter on cttimeout object addition/removal,
   from Florian.

5) Consolidate nf_log MAC printer, from Phil Sutter.

6) Add basic logging support for unknown ethertype, from Phil Sutter.

7) Consolidate check for sysctl nf_log_all_netns toggle, also from Phil.

8) Replace hardcode value in nft_bitwise, from Jeremy Sowden.

9) Rename BASIC-like goto tags in nft_bitwise to more meaningful names,
   also from Jeremy.

10) nft_fib support for reverse path filtering with policy-based routing
    on iif. Extend selftests to cover for this new usecase, from Florian.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit 2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14:

  Merge tag 'net-5.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-31 11:23:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 0c7b27616fbd64b3b86c59ad5441f82a1a0c4176:

  selftests: netfilter: add fib expression forward test case (2022-04-11 12:10:09 +0200)

----------------------------------------------------------------
Florian Westphal (4):
      netfilter: ecache: move to separate structure
      netfilter: conntrack: split inner loop of list dumping to own function
      netfilter: cttimeout: inc/dec module refcount per object, not per use refcount
      selftests: netfilter: add fib expression forward test case

Jakob Koschel (1):
      netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()

Jeremy Sowden (2):
      netfilter: bitwise: replace hard-coded size with `sizeof` expression
      netfilter: bitwise: improve error goto labels

Pablo Neira Ayuso (1):
      netfilter: nft_fib: reverse path filter for policy-based routing on iif

Phil Sutter (3):
      netfilter: nf_log_syslog: Merge MAC header dumpers
      netfilter: nf_log_syslog: Don't ignore unknown protocols
      netfilter: nf_log_syslog: Consolidate entry checks

 include/net/netfilter/nf_conntrack.h         |   8 +-
 net/ipv4/netfilter/nft_fib_ipv4.c            |   4 +
 net/ipv6/netfilter/nft_fib_ipv6.c            |   4 +
 net/netfilter/nf_conntrack_ecache.c          |  19 ++--
 net/netfilter/nf_conntrack_netlink.c         |  68 +++++++++-----
 net/netfilter/nf_log_syslog.c                | 136 +++++++++++++--------------
 net/netfilter/nf_tables_api.c                |   6 +-
 net/netfilter/nfnetlink_cttimeout.c          |  14 +--
 net/netfilter/nft_bitwise.c                  |  13 +--
 net/netfilter/nft_fib.c                      |   4 +
 tools/testing/selftests/netfilter/nft_fib.sh |  50 ++++++++++
 11 files changed, 199 insertions(+), 127 deletions(-)
