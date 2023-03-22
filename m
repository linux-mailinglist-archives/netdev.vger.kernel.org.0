Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB8C6C587A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCVVIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCVVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:08:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0F640E2;
        Wed, 22 Mar 2023 14:08:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pf5gk-00041X-2y; Wed, 22 Mar 2023 22:08:06 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/5] netfilter updates for net-next
Date:   Wed, 22 Mar 2023 22:07:57 +0100
Message-Id: <20230322210802.6743-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

This pull request contains changes for the *net-next* tree.

1. Change IPv6 stack to keep conntrack references until ipsec policy
   checks are done, like ipv4, from Madhu Koriginja.
   This update was missed when IPv6 NAT support was added 10 years ago.

2. get rid of old 'compat' structure layout in nf_nat_redirect
   core and move the conversion to the only user that needs the
   old layout for abi reasons. From Jeremy Sowden.

3. Compact some common code paths in nft_redir, also from Jeremy.

4. Time to remove the 'default y' knob so iptables 32bit compat interface
   isn't compiled in by default anymore, from myself.

5. Move ip(6)tables builtin icmp matches to the udptcp one.
   This has the advantage that icmp/icmpv6 match doesn't load the
   iptables/ip6tables modules anymore when iptables-nft is used.
   Also from myself.

The following changes since commit 5c5945dc695c54f2b55a934a10b6c4e220f9c140:

  selftests/net: Add SHA256 computation over data sent in tcp_mmap (2023-03-22 15:34:31 +0100)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next main

for you to fetch changes up to b0e214d212030fe497d4d150bb3474e50ad5d093:

  netfilter: keep conntrack reference until IPsecv6 policy checks are done (2023-03-22 21:50:23 +0100)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: xtables: disable 32bit compat interface by default
      xtables: move icmp/icmpv6 logic to xt_tcpudp

Jeremy Sowden (2):
      netfilter: nft_redir: use `struct nf_nat_range2` throughout and deduplicate eval call-backs
      netfilter: nft_masq: deduplicate eval call-backs

Madhu Koriginja (1):
      netfilter: keep conntrack reference until IPsecv6 policy checks are done

 include/net/netfilter/nf_nat_redirect.h |   3 +-
 net/dccp/ipv6.c                         |   1 +
 net/ipv4/netfilter/ip_tables.c          |  68 +-------------------
 net/ipv6/ip6_input.c                    |  14 ++--
 net/ipv6/netfilter/ip6_tables.c         |  68 +-------------------
 net/ipv6/raw.c                          |   5 +-
 net/ipv6/tcp_ipv6.c                     |   2 +
 net/ipv6/udp.c                          |   2 +
 net/netfilter/Kconfig                   |   1 -
 net/netfilter/nf_nat_redirect.c         |  71 ++++++++++-----------
 net/netfilter/nft_masq.c                |  75 +++++++++-------------
 net/netfilter/nft_redir.c               |  84 +++++++++---------------
 net/netfilter/xt_REDIRECT.c             |  10 ++-
 net/netfilter/xt_tcpudp.c               | 110 ++++++++++++++++++++++++++++++++
 14 files changed, 226 insertions(+), 288 deletions(-)
