Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB605A8F81
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiIAHNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiIAHM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:12:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096541243D2;
        Thu,  1 Sep 2022 00:12:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oTeNf-0000Wx-Ot; Thu, 01 Sep 2022 09:12:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/4] netfilter: bug fixes for net
Date:   Thu,  1 Sep 2022 09:12:34 +0200
Message-Id: <20220901071238.3044-1-fw@strlen.de>
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

Hello,

This patchset contains netfilter related fixes for the net tree.

1. Fix IP address check in irc DCC conntrack helper, this should check
   the opposite direction rather than the destination address of the
   packets' direction, from David Leadbeater.

2. bridge netfilter needs to drop dst references, from Harsh Modi.
   This was fine back in the day the code was originally written,
   but nowadays various tunnels can pre-set metadata dsts on packets.

3. Remove nf_conntrack_helper sysctl and the modparam toggle, users
   need to explicitily assign the helpers to use via nftables or
   iptables.  Conntrack helpers, by design, may be used to add dynamic
   port redirections to internal machines, so its necessary to restrict
   which hosts/peers are allowed to use them.
   The auto-assign-for-everything mechanism has been in "please don't do this"
   territory since 2012.  From Pablo.

4. Fix a memory leak in the netdev hook error unwind path, also from Pablo.

----------------------------------------------------------------
The following changes since commit 13a9d08c296228d18289de60b83792c586e1d073:

  net: lan966x: improve error handle in lan966x_fdma_rx_get_frame() (2022-08-30 23:18:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git 

for you to fetch changes up to 0efe125cfb99e6773a7434f3463f7c2fa28f3a43:

  netfilter: nf_conntrack_irc: Fix forged IP logic (2022-09-01 02:01:56 +0200)

----------------------------------------------------------------
David Leadbeater (1):
      netfilter: nf_conntrack_irc: Fix forged IP logic

Harsh Modi (1):
      netfilter: br_netfilter: Drop dst references before setting.

Pablo Neira Ayuso (2):
      netfilter: remove nf_conntrack_helper sysctl and modparam toggles
      netfilter: nf_tables: clean up hook list when offload flags check fails

 include/net/netfilter/nf_conntrack.h               |  2 -
 include/net/netns/conntrack.h                      |  1 -
 net/bridge/br_netfilter_hooks.c                    |  2 +
 net/bridge/br_netfilter_ipv6.c                     |  1 +
 net/netfilter/nf_conntrack_core.c                  |  7 +-
 net/netfilter/nf_conntrack_helper.c                | 80 +++-------------------
 net/netfilter/nf_conntrack_irc.c                   |  5 +-
 net/netfilter/nf_conntrack_netlink.c               |  5 --
 net/netfilter/nf_conntrack_standalone.c            | 10 ---
 net/netfilter/nf_tables_api.c                      |  4 +-
 net/netfilter/nft_ct.c                             |  3 -
 .../selftests/netfilter/nft_conntrack_helper.sh    | 36 +++++++---
 12 files changed, 46 insertions(+), 110 deletions(-)
-- 
2.35.1

