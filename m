Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974D44D713C
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 23:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiCLWEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 17:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiCLWEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 17:04:30 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F991D004C;
        Sat, 12 Mar 2022 14:03:22 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 563E262FEA;
        Sat, 12 Mar 2022 23:01:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date:   Sat, 12 Mar 2022 23:03:12 +0100
Message-Id: <20220312220315.64531-1-pablo@netfilter.org>
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

The following patchset contains Netfilter fixes for net coming late
in the 5.17-rc process:

1) Revert port remap to mitigate shadowing service ports, this is causing
   problems in existing setups and this mitigation can be achieved with
   explicit ruleset, eg.

	... tcp sport < 16386 tcp dport >= 32768 masquerade random

  This patches provided a built-in policy similar to the one described above.

2) Disable register tracking infrastructure in nf_tables. Florian reported
   two issues:

   - Existing expressions with no implemented .reduce interface
     that causes data-store on register should cancel the tracking.
   - Register clobbering might be possible storing data on registers that
     are larger than 32-bits.

   This might lead to generating incorrect ruleset bytecode. These two
   issues are scheduled to be addressed in the next release cycle.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit f8e9bd34cedd89b93b1167aa32ab8ecd6c2ccf4a:

  Merge branch 'smc-fix' (2022-03-03 10:34:18 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to ed5f85d4229010235eab1e3d9acf6970d9304963:

  netfilter: nf_tables: disable register tracking (2022-03-12 16:07:38 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      Revert "netfilter: nat: force port remap to prevent shadowing well-known ports"
      Revert "netfilter: conntrack: tag conntracks picked up in local out hook"

Pablo Neira Ayuso (1):
      netfilter: nf_tables: disable register tracking

 include/net/netfilter/nf_conntrack.h         |  1 -
 net/netfilter/nf_conntrack_core.c            |  3 --
 net/netfilter/nf_nat_core.c                  | 43 ++--------------------------
 net/netfilter/nf_tables_api.c                |  9 ++++--
 tools/testing/selftests/netfilter/nft_nat.sh |  5 ++--
 5 files changed, 12 insertions(+), 49 deletions(-)
