Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871835A039F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbiHXWDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiHXWDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:03:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42B027675C;
        Wed, 24 Aug 2022 15:03:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 00/14] Netfilter fixes for net
Date:   Thu, 25 Aug 2022 00:03:16 +0200
Message-Id: <20220824220330.64283-1-pablo@netfilter.org>
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

The following patchset contains Netfilter fixes for net. All fixes
included in this batch address problems appearing in several releases:

1) Fix crash with malformed ebtables blob which do not provide all
   entry points, from Florian Westphal.

2) Fix possible TCP connection clogging up with default 5-days
   timeout in conntrack, from Florian.

3) Fix crash in nf_tables tproxy with unsupported chains, also from Florian.

4) Do not allow to update implicit chains.

5) Make table handle allocation per-netns to fix data race.

6) Do not truncated payload length and offset, and checksum offset.
   Instead report EINVAl.

7) Enable chain stats update via static key iff no error occurs.

8) Restrict osf expression to ip, ip6 and inet families.

9) Restrict tunnel expression to netdev family.

10) Fix crash when trying to bind again an already bound chain.

11) Flowtable garbage collector might leave behind pending work to
    delete entries. This patch comes with a previous preparation patch
    as dependency.

12) Allow net.netfilter.nf_conntrack_frag6_high_thresh to be lowered,
    from Eric Dumazet.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 855a28f9c96c80e6cbd2d986a857235e34868064:

  net: dsa: don't dereference NULL extack in dsa_slave_changeupper() (2022-08-23 07:54:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

for you to fetch changes up to 00cd7bf9f9e06769ef84d5102774c8becd6a498a:

  netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases (2022-08-24 08:06:44 +0200)

----------------------------------------------------------------
Eric Dumazet (1):
      netfilter: nf_defrag_ipv6: allow nf_conntrack_frag6_high_thresh increases

Florian Westphal (3):
      netfilter: ebtables: reject blobs that don't provide all entry points
      netfilter: conntrack: work around exceeded receive window
      netfilter: nft_tproxy: restrict to prerouting hook

Pablo Neira Ayuso (10):
      netfilter: nf_tables: disallow updates of implicit chain
      netfilter: nf_tables: make table handle allocation per-netns friendly
      netfilter: nft_payload: report ERANGE for too long offset and length
      netfilter: nft_payload: do not truncate csum_offset and csum_type
      netfilter: nf_tables: do not leave chain stats enabled on error
      netfilter: nft_osf: restrict osf to ipv4, ipv6 and inet families
      netfilter: nft_tunnel: restrict it to netdev family
      netfilter: nf_tables: disallow binding to already bound chain
      netfilter: flowtable: add function to invoke garbage collection immediately
      netfilter: flowtable: fix stuck flows on cleanup due to pending work

 include/linux/netfilter_bridge/ebtables.h |  4 ----
 include/net/netfilter/nf_flow_table.h     |  3 +++
 include/net/netfilter/nf_tables.h         |  1 +
 net/bridge/netfilter/ebtable_broute.c     |  8 --------
 net/bridge/netfilter/ebtable_filter.c     |  8 --------
 net/bridge/netfilter/ebtable_nat.c        |  8 --------
 net/bridge/netfilter/ebtables.c           |  8 +-------
 net/ipv6/netfilter/nf_conntrack_reasm.c   |  1 -
 net/netfilter/nf_conntrack_proto_tcp.c    | 31 +++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_core.c        | 15 ++++++++++-----
 net/netfilter/nf_flow_table_offload.c     |  8 ++++++++
 net/netfilter/nf_tables_api.c             | 14 ++++++++++----
 net/netfilter/nft_osf.c                   | 18 +++++++++++++++---
 net/netfilter/nft_payload.c               | 29 +++++++++++++++++++++--------
 net/netfilter/nft_tproxy.c                |  8 ++++++++
 net/netfilter/nft_tunnel.c                |  1 +
 16 files changed, 109 insertions(+), 56 deletions(-)
