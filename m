Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB9A60E207
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiJZNXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiJZNWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:22:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BDA2543E4A;
        Wed, 26 Oct 2022 06:22:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 00/10] Netfilter updates for net-next
Date:   Wed, 26 Oct 2022 15:22:17 +0200
Message-Id: <20221026132227.3287-1-pablo@netfilter.org>
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

The following patchset contains Netfilter updates for net-next:

1) Move struct nft_payload_set definition to .c file where it is
   only used.

2) Shrink transport and inner header offset fields in the nft_pktinfo
   structure to 16-bits, from Florian Westphal.

3) Get rid of nft_objref Kbuild toggle, make it built-in into
   nf_tables. This expression is used to instantiate conntrack helpers
   in nftables. After removing the conntrack helper auto-assignment
   toggle it this feature became more important so move it to the nf_tables
   core module. Also from Florian.

4) Extend the existing function to calculate payload inner header offset
   to deal with the GRE and IPIP transport protocols.

6) Add inner expression support for nf_tables. This new expression
   provides a packet parser for tunneled packets which uses a userspace
   description of the expected inner headers. The inner expression
   invokes the payload expression (via direct call) to match on the
   inner header protocol fields using the inner link, network and
   transport header offsets.

   An example of the bytecode generated from userspace to match on
   IP source encapsulated in a VxLAN packet:

   # nft --debug=netlink add rule netdev x y udp dport 4789 vxlan ip saddr 1.2.3.4
     netdev x y
       [ meta load l4proto => reg 1 ]
       [ cmp eq reg 1 0x00000011 ]
       [ payload load 2b @ transport header + 2 => reg 1 ]
       [ cmp eq reg 1 0x0000b512 ]
       [ inner type vxlan hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
       [ cmp eq reg 1 0x00000008 ]
       [ inner type vxlan hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
       [ cmp eq reg 1 0x04030201 ]

7) Store inner link, network and transport header offsets in percpu
   area to parse inner packet header once only. Matching on a different
   tunnel type invalidates existing offsets in the percpu area and it
   invokes the inner tunnel parser again.

8) Add support for inner meta matching. This support for
   NFTA_META_PROTOCOL, which specifies the inner ethertype, and
   NFT_META_L4PROTO, which specifies the inner transport protocol.

9) Extend nft_inner to parse GENEVE optional fields to calculate the
   link layer offset.

10) Update inner expression so tunnel offset points to GRE header
    to normalize tunnel header handling. This also allows to perform
    different interpretations of the GRE header from userspace.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git

Thanks.

----------------------------------------------------------------

The following changes since commit d6dd508080a3cdc0ab34ebf66c3734f2dff907ad:

  bnx2: Use kmalloc_size_roundup() to match ksize() usage (2022-10-25 12:59:04 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git HEAD

for you to fetch changes up to 91619eb60aeccd3181d9b88975add706a9b763c1:

  netfilter: nft_inner: set tunnel offset to GRE header offset (2022-10-25 13:48:42 +0200)

----------------------------------------------------------------
Florian Westphal (2):
      netfilter: nf_tables: reduce nft_pktinfo by 8 bytes
      netfilter: nft_objref: make it builtin

Pablo Neira Ayuso (8):
      netfilter: nft_payload: move struct nft_payload_set definition where it belongs
      netfilter: nft_payload: access GRE payload via inner offset
      netfilter: nft_payload: access ipip payload for inner offset
      netfilter: nft_inner: support for inner tunnel header matching
      netfilter: nft_inner: add percpu inner context
      netfilter: nft_meta: add inner match support
      netfilter: nft_inner: add geneve support
      netfilter: nft_inner: set tunnel offset to GRE header offset

 include/net/netfilter/nf_tables.h        |  10 +-
 include/net/netfilter/nf_tables_core.h   |  36 ++-
 include/net/netfilter/nf_tables_ipv4.h   |   4 +
 include/net/netfilter/nf_tables_ipv6.h   |   6 +-
 include/net/netfilter/nft_meta.h         |   6 +
 include/uapi/linux/netfilter/nf_tables.h |  27 +++
 net/netfilter/Kconfig                    |   6 -
 net/netfilter/Makefile                   |   4 +-
 net/netfilter/nf_tables_api.c            |  37 +++
 net/netfilter/nf_tables_core.c           |   2 +
 net/netfilter/nft_inner.c                | 384 +++++++++++++++++++++++++++++++
 net/netfilter/nft_meta.c                 |  62 +++++
 net/netfilter/nft_objref.c               |  22 +-
 net/netfilter/nft_payload.c              | 134 ++++++++++-
 14 files changed, 695 insertions(+), 45 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c
