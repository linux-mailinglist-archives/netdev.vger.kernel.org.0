Return-Path: <netdev+bounces-3550-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E479707D89
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF08528188E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61A811CB5;
	Thu, 18 May 2023 10:08:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3AD11CA0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:11 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BC91BD6;
	Thu, 18 May 2023 03:08:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYE-0005ml-AO; Thu, 18 May 2023 12:08:02 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 0/9] Netfilter updates for net-next
Date: Thu, 18 May 2023 12:07:50 +0200
Message-Id: <20230518100759.84858-1-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

[ sorry if you get this twice, wrong mail aliases in v1 ]

this PR contains updates for your *net-next* tree.

nftables updates:

1. Allow key existence checks with maps.
   At the moment the kernel requires userspace to pass a destination
   register for the associated value, make this optional so userspace
   can query if the key exists, just like with normal sets.

2. nftables maintains a counter per set that holds the number of
   elements.  This counter gets decremented on element removal,
   but its only incremented if the set has a upper maximum value.
   Increment unconditionally, this will allow us to update the
   maximum value later on.

3. At DCCP option maching, from Jeremy Sowden.

4. use struct_size macro, from Christophe JAILLET.

Conntrack:

5. Squash holes in struct nf_conntrack_expect, also Christophe JAILLET.

6. Allow clash resolution for GRE Protocol to avoid a packet drop,
   from Faicker Mo.

Flowtable:

Simplify route logic and split large functions into smaller
chunks, from Pablo Neira Ayuso.

The following changes since commit b50a8b0d57ab1ef11492171e98a030f48682eac3:

  net: openvswitch: Use struct_size() (2023-05-17 21:25:46 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-2023-05-18

for you to fetch changes up to e05b5362166b18a224c30502e81416e4d622d3e4:

  netfilter: flowtable: split IPv6 datapath in helper functions (2023-05-18 08:48:55 +0200)

----------------------------------------------------------------
Christophe JAILLET (2):
      netfilter: Reorder fields in 'struct nf_conntrack_expect'
      netfilter: nft_set_pipapo: Use struct_size()

Faicker Mo (1):
      netfilter: conntrack: allow insertion clash of gre protocol

Florian Westphal (2):
      netfilter: nf_tables: relax set/map validation checks
      netfilter: nf_tables: always increment set element count

Jeremy Sowden (1):
      netfilter: nft_exthdr: add boolean DCCP option matching

Pablo Neira Ayuso (3):
      netfilter: flowtable: simplify route logic
      netfilter: flowtable: split IPv4 datapath in helper functions
      netfilter: flowtable: split IPv6 datapath in helper functions

 include/net/netfilter/nf_conntrack_expect.h |  18 +--
 include/net/netfilter/nf_flow_table.h       |   4 +-
 include/uapi/linux/netfilter/nf_tables.h    |   2 +
 net/netfilter/nf_conntrack_proto_gre.c      |   1 +
 net/netfilter/nf_flow_table_core.c          |  24 +--
 net/netfilter/nf_flow_table_ip.c            | 231 ++++++++++++++++++----------
 net/netfilter/nf_tables_api.c               |  11 +-
 net/netfilter/nft_exthdr.c                  | 106 +++++++++++++
 net/netfilter/nft_flow_offload.c            |  12 +-
 net/netfilter/nft_lookup.c                  |  23 ++-
 net/netfilter/nft_set_pipapo.c              |   6 +-
 11 files changed, 303 insertions(+), 135 deletions(-)

