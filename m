Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AEB6B11FC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCHTau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:30:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B908BCB9C;
        Wed,  8 Mar 2023 11:30:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzUj-0003ov-Aj; Wed, 08 Mar 2023 20:30:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date:   Wed,  8 Mar 2023 20:30:24 +0100
Message-Id: <20230308193033.13965-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
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

Hi,

The following set contains updates for the *net-next* tree:

1. nf_tables 'brouting' support, from Sriram Yagnaraman.

2. Update bridge netfilter and ovs conntrack helpers to handle
   IPv6 Jumbo packets properly, i.e. fetch the packet length
   from hop-by-hop extension header, from Xin Long.

   This comes with a test BIG TCP test case, added to
   tools/testing/selftests/net/.

3. Fix spelling and indentation in conntrack, from Jeremy Sowden.

Please consider pulling from

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

----------------------------------------------------------------

The following changes since commit 7d8c48917a9576b5fc8871aa4946149b0e4a4927:

  dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal (2023-03-08 13:05:37 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git main

for you to fetch changes up to b0ca200077b3872056e6a8291c9a50f803658c2a:

  netfilter: nat: fix indentation of function arguments (2023-03-08 14:25:44 +0100)

----------------------------------------------------------------

Jeremy Sowden (2):
  netfilter: conntrack: fix typo
  netfilter: nat: fix indentation of function arguments

Sriram Yagnaraman (1):
  netfilter: bridge: introduce broute meta statement

Xin Long (6):
  netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
  netfilter: bridge: check len before accessing more nh data
  netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
  netfilter: move br_nf_check_hbh_len to utils
  netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
  selftests: add a selftest for big tcp

 include/linux/netfilter_ipv6.h           |   2 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/bridge/br_netfilter_ipv6.c           |  79 ++--------
 net/bridge/netfilter/nft_meta_bridge.c   |  71 ++++++++-
 net/netfilter/nf_conntrack_core.c        |   2 +-
 net/netfilter/nf_conntrack_ovs.c         |  11 +-
 net/netfilter/nf_nat_core.c              |   4 +-
 net/netfilter/utils.c                    |  52 +++++++
 tools/testing/selftests/net/Makefile     |   1 +
 tools/testing/selftests/net/big_tcp.sh   | 180 +++++++++++++++++++++++
 10 files changed, 327 insertions(+), 77 deletions(-)
 create mode 100755 tools/testing/selftests/net/big_tcp.sh
