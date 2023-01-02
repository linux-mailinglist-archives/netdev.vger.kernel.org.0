Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3521A65B531
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 17:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbjABQkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 11:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbjABQki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 11:40:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97AFA114E;
        Mon,  2 Jan 2023 08:40:33 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 0/7] Netfilter fixes for net
Date:   Mon,  2 Jan 2023 17:40:18 +0100
Message-Id: <20230102164025.125995-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Use signed integer in ipv6_skip_exthdr() called from nf_confirm().
   Reported by static analysis tooling, patch from Florian Westphal.

2) Missing set type checks in nf_tables: Validate that set declaration
   matches the an existing set type, otherwise bail out with EEXIST.
   Currently, nf_tables silently accepts the re-declaration with a
   different type but it bails out later with EINVAL when the user adds
   entries to the set. This fix is relatively large because it requires
   two preparation patches that are included in this batch.

3) Do not ignore updates of timeout and gc_interval parameters in
   existing sets.

4) Fix a hang when 0/0 subnets is added to a hash:net,port,net type of
   ipset. Except hash:net,port,net and hash:net,iface, the set types don't
   support 0/0 and the auxiliary functions rely on this fact. So 0/0 needs
   a special handling in hash:net,port,net which was missing (hash:net,iface
   was not affected by this bug), from Jozsef Kadlecsik.

5) When adding/deleting large number of elements in one step in ipset,
   it can take a reasonable amount of time and can result in soft lockup
   errors. This patch is a complete rework of the previous version in order
   to use a smaller internal batch limit and at the same time removing
   the external hard limit to add arbitrary number of elements in one step.
   Also from Jozsef Kadlecsik.

Except for patch #1, which fixes a bug introduced in the previous net-next
development cycle, anything else has been broken for several releases.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 19e72b064fc32cd58f6fc0b1eb64ac2e4f770e76:

  net: fec: check the return value of build_skb() (2022-12-20 11:33:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 5e29dc36bd5e2166b834ceb19990d9e68a734d7d:

  netfilter: ipset: Rework long task execution when adding/deleting entries (2023-01-02 15:10:05 +0100)

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: conntrack: fix ipv6 exthdr error check

Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting entries

Pablo Neira Ayuso (4):
      netfilter: nf_tables: consolidate set description
      netfilter: nf_tables: add function to create set stateful expressions
      netfilter: nf_tables: perform type checking for existing sets
      netfilter: nf_tables: honor set timeout and garbage collection updates

 include/linux/netfilter/ipset/ip_set.h       |   2 +-
 include/net/netfilter/nf_tables.h            |  25 ++-
 net/netfilter/ipset/ip_set_core.c            |   7 +-
 net/netfilter/ipset/ip_set_hash_ip.c         |  14 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  13 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  13 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  13 +-
 net/netfilter/ipset/ip_set_hash_net.c        |  17 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  15 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  23 +--
 net/netfilter/ipset/ip_set_hash_netport.c    |  19 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  40 ++--
 net/netfilter/nf_conntrack_proto.c           |   7 +-
 net/netfilter/nf_tables_api.c                | 261 ++++++++++++++++++---------
 15 files changed, 293 insertions(+), 189 deletions(-)
