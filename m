Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60EAC4C97F9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 22:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbiCAVyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiCAVyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:54:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAB635F4DD;
        Tue,  1 Mar 2022 13:53:42 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4DA2F60201;
        Tue,  1 Mar 2022 22:52:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] Netfilter fixes for net
Date:   Tue,  1 Mar 2022 22:53:29 +0100
Message-Id: <20220301215337.378405-1-pablo@netfilter.org>
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

1) Use kfree_rcu(ptr, rcu) variant, using kfree_rcu(ptr) was not
   intentional. From Eric Dumazet.

2) Use-after-free in netfilter hook core, from Eric Dumazet.

3) Missing rcu read lock side for netfilter egress hook,
   from Florian Westphal.

4) nf_queue assume state->sk is full socket while it might not be.
   Invoke sock_gen_put(), from Florian Westphal.

5) Add selftest to exercise the reported KASAN splat in 4)

6) Fix possible use-after-free in nf_queue in case sk_refcnt is 0.
   Also from Florian.

7) Use input interface index only for hardware offload, not for
   the software plane. This breaks tc ct action. Patch from Paul Blakey.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 277f2bb14361790a70e4b3c649e794b75a91a597:

  ibmvnic: schedule failover only if vioctl fails (2022-02-22 17:06:27 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to db6140e5e35a48405e669353bd54042c1d4c3841:

  net/sched: act_ct: Fix flow table lookup failure with no originating ifindex (2022-03-01 22:08:31 +0100)

----------------------------------------------------------------
Eric Dumazet (2):
      netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
      netfilter: fix use-after-free in __nf_register_net_hook()

Florian Westphal (5):
      netfilter: egress: silence egress hook lockdep splats
      netfilter: nf_queue: don't assume sk is full socket
      selftests: netfilter: add nfqueue TCP_NEW_SYN_RECV socket race test
      netfilter: nf_queue: fix possible use-after-free
      netfilter: nf_queue: handle socket prefetch

Paul Blakey (1):
      net/sched: act_ct: Fix flow table lookup failure with no originating ifindex

 include/linux/netfilter_netdev.h                  |   4 +
 include/net/netfilter/nf_flow_table.h             |   6 +-
 include/net/netfilter/nf_queue.h                  |   2 +-
 net/netfilter/core.c                              |   5 +-
 net/netfilter/nf_flow_table_offload.c             |   6 +-
 net/netfilter/nf_queue.c                          |  36 +++++-
 net/netfilter/nf_tables_api.c                     |   4 +-
 net/netfilter/nfnetlink_queue.c                   |  12 +-
 net/sched/act_ct.c                                |  13 ++-
 tools/testing/selftests/netfilter/.gitignore      |   1 +
 tools/testing/selftests/netfilter/Makefile        |   2 +-
 tools/testing/selftests/netfilter/connect_close.c | 136 ++++++++++++++++++++++
 tools/testing/selftests/netfilter/nft_queue.sh    |  19 +++
 13 files changed, 226 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/netfilter/connect_close.c
