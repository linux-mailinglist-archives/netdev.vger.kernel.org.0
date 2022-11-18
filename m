Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9C162F74D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241760AbiKRO3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235313AbiKRO3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:29:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D2EB5DBB0;
        Fri, 18 Nov 2022 06:29:23 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/2] Netfilter fixes for net
Date:   Fri, 18 Nov 2022 15:29:16 +0100
Message-Id: <20221118142918.196782-1-pablo@netfilter.org>
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

The following patchset contains late Netfilter fixes for net:

1) Use READ_ONCE()/WRITE_ONCE() to update ct->mark, from Daniel Xu.
   Not reported by syzbot, but I presume KASAN would trigger post
   a splat on this. This is a rather old issue, predating git history.

2) Do not set up extensions for set element with end interval flag
   set on. This leads to bogusly skipping this elements as expired
   when listing the set/map to userspace as well as increasing
   memory consumpton when stateful expressions are used. This issue
   has been present since 4.18, when timeout support for rbtree set
   was added.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 40b9d1ab63f5c4f3cb69450044d07b45e5af72e1:

  ipvlan: hold lower dev to avoid possible use-after-free (2022-11-18 10:39:22 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 33c7aba0b4ffd6d7cdab862a034eb582a5120a38:

  netfilter: nf_tables: do not set up extensions for end interval (2022-11-18 15:21:32 +0100)

----------------------------------------------------------------
Daniel Xu (1):
      netfilter: conntrack: Fix data-races around ct mark

Pablo Neira Ayuso (1):
      netfilter: nf_tables: do not set up extensions for end interval

 net/core/flow_dissector.c               |  2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c      |  4 ++--
 net/netfilter/nf_conntrack_core.c       |  2 +-
 net/netfilter/nf_conntrack_netlink.c    | 24 ++++++++++++++----------
 net/netfilter/nf_conntrack_standalone.c |  2 +-
 net/netfilter/nf_tables_api.c           |  6 ++++--
 net/netfilter/nft_ct.c                  |  6 +++---
 net/netfilter/xt_connmark.c             | 18 ++++++++++--------
 net/openvswitch/conntrack.c             |  8 ++++----
 net/sched/act_connmark.c                |  4 ++--
 net/sched/act_ct.c                      |  8 ++++----
 net/sched/act_ctinfo.c                  |  6 +++---
 12 files changed, 49 insertions(+), 41 deletions(-)
