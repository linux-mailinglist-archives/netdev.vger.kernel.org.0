Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247672F4C4A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbhAMNgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:36:50 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:16280 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhAMNgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:36:46 -0500
Date:   Wed, 13 Jan 2021 13:35:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610544962; bh=guUtzNDokVjGcSR8AA0SShEy7FHBvKI0bc1oYHZ+ko0=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=NFFsPb8iE0f1jrEgSznqos49PDFv/v59FYBVsI70462JZWFAIjnfl4yIfWVjkK8u8
         K9CqOBqfmYel+7/e0MOcZ4zUU0BnJLhWLfhR3RVZgb8yYmvHn7ZZmRanv3EE79ABoY
         lUKAFEwYT5wNl0kmE0aPYo00XfKIaLezJZrzZ1D1WEnWMRkPG7tbfjA2uuRxLNmKMP
         Q3tm/BkvAjocBLnE559AwyIpzixprfsDmjYjTpXeZa9INBNxoqWF1I7GwwzCYKPClG
         J+VpS5oPeDOLiu2mzNEVneShD0raUxfl3NraNLnCn1TgtTSTeepOkFOkKGKFcpz4En
         RzkYoE/jZ81KA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 0/3] skbuff: introduce skbuff_heads reusing and bulking
Message-ID: <20210113133523.39205-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, all sorts of skb allocation always do allocate
skbuff_heads one by one via kmem_cache_alloc().
On the other hand, we have percpu napi_alloc_cache to store
skbuff_heads queued up for freeing and flush them by bulks.

We can use this cache not only for bulk-wiping, but also to obtain
heads for new skbs and avoid unconditional allocations, as well as
for bulk-allocating.
As accessing napi_alloc_cache implies NAPI softirq context, do this
only for __napi_alloc_skb() and its derivatives (napi_alloc_skb()
and napi_get_frags()). The rough amount of their call sites are 69,
which is quite a number.

iperf3 showed 35-50 Mbps bumps for both TCP and UDP while performing
VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be way bigger
on more powerful hosts and NICs with tens of Mpps.

Since v1 [0]:
 - use one unified cache instead of two separate to greatly simplify
   the logics and reduce hotpath overhead (Edward Cree);
 - new: recycle also GRO_MERGED_FREE skbs instead of immediate
   freeing;
 - correct performance numbers after optimizations and performing
   lots of tests for different use cases.

[0] https://lore.kernel.org/netdev/20210111182655.12159-1-alobakin@pm.me

Alexander Lobakin (3):
  skbuff: open-code __build_skb() inside __napi_alloc_skb()
  skbuff: (re)use NAPI skb cache on allocation path
  skbuff: recycle GRO_MERGED_FREE skbs into NAPI skb cache

 include/linux/skbuff.h |  1 +
 net/core/dev.c         |  9 +----
 net/core/skbuff.c      | 74 +++++++++++++++++++++++++++++-------------
 3 files changed, 54 insertions(+), 30 deletions(-)

--=20
2.30.0


