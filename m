Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7531928D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBKSxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:53:53 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:11500 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhBKSxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 13:53:40 -0500
Date:   Thu, 11 Feb 2021 18:52:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613069569; bh=NUBZMBqGVXKB5B+mjmbD+QS/7XtCT4xEM8IcD7m5LMY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=AT1cLTGpSPNlSUo7wlM3MHr3/mUtfDcNTm5+tUuCAxlXfOo+spYEAMl8Rem05T4tx
         L+UWAfK6vf9eqq1VOeuC+J/566VbdLhSdMZGgjDZ9SuyetlFHN2+WKcwMZQyaTuZdg
         JekHEfMssGoVCeVCD0+rY8lqQ5p5nqvXsmWPIw2EFOWrbtYdNFHO9V2bYm3wBBs5Cv
         ZJAADKSaEFr25IEi9+czqr5o86FKhl4MuzjloVLPUAqApBFfNgliWSJNNG5NW/NNii
         NrXv2ZOat9ekfHLTLiRtBc7YR1TJ7fT5oKh/6jp+a39j+mL7hlE3Wm7RddRRyxMNkd
         jB8IptKQHEzBg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 net-next 00/11] skbuff: introduce skbuff_heads bulking and reusing
Message-ID: <20210211185220.9753-1-alobakin@pm.me>
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
for bulk-allocating (like XDP's cpumap code and veth driver already
do).

As this might affect latencies, cache pressure and lots of hardware
and driver-dependent stuff, this new feature is mostly optional and
can be issued via:
 - a new napi_build_skb() function (as a replacement for build_skb());
 - existing {,__}napi_alloc_skb() and napi_get_frags() functions;
 - __alloc_skb() with passing SKB_ALLOC_NAPI in flags.

iperf3 showed 35-70 Mbps bumps for both TCP and UDP while performing
VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be bigger
on more powerful hosts and NICs with tens of Mpps.

Note on skbuff_heads from distant slabs or pfmemalloc'ed slabs:
 - kmalloc()/kmem_cache_alloc() itself allows by default allocating
   memory from the remote nodes to defragment their slabs. This is
   controlled by sysctl, but according to this, skbuff_head from a
   remote node is an OK case;
 - The easiest way to check if the slab of skbuff_head is remote or
   pfmemalloc'ed is:

=09if (!dev_page_is_reusable(virt_to_head_page(skb)))
=09=09/* drop it */;

   ...*but*, regarding that most slabs are built of compound pages,
   virt_to_head_page() will hit unlikely-branch every single call.
   This check costed at least 20 Mbps in test scenarios and seems
   like it'd be better to _not_ do this.

Since v4 [3]:
 - rebase on top of net-next and address kernel build robot issue;
 - reorder checks a bit in __alloc_skb() to make new condition even
   more harmless.

Since v3 [2]:
 - make the feature mostly optional, so driver developers could
   decide whether to use it or not (Paolo Abeni).
   This reuses the old flag for __alloc_skb() and introduces
   a new napi_build_skb();
 - reduce bulk-allocation size from 32 to 16 elements (also Paolo).
   This equals to the value of XDP's devmap and veth batch processing
   (which were tested a lot) and should be sane enough;
 - don't waste cycles on explicit in_serving_softirq() check.

Since v2 [1]:
 - also cover {,__}alloc_skb() and {,__}build_skb() cases (became handy
   after the changes that pass tiny skbs requests to kmalloc layer);
 - cover the cache with KASAN instrumentation (suggested by Eric
   Dumazet, help of Dmitry Vyukov);
 - completely drop redundant __kfree_skb_flush() (also Eric);
 - lots of code cleanups;
 - expand the commit message with NUMA and pfmemalloc points (Jakub).

Since v1 [0]:
 - use one unified cache instead of two separate to greatly simplify
   the logics and reduce hotpath overhead (Edward Cree);
 - new: recycle also GRO_MERGED_FREE skbs instead of immediate
   freeing;
 - correct performance numbers after optimizations and performing
   lots of tests for different use cases.

[0] https://lore.kernel.org/netdev/20210111182655.12159-1-alobakin@pm.me
[1] https://lore.kernel.org/netdev/20210113133523.39205-1-alobakin@pm.me
[2] https://lore.kernel.org/netdev/20210209204533.327360-1-alobakin@pm.me
[3] https://lore.kernel.org/netdev/20210210162732.80467-1-alobakin@pm.me

Alexander Lobakin (11):
  skbuff: move __alloc_skb() next to the other skb allocation functions
  skbuff: simplify kmalloc_reserve()
  skbuff: make __build_skb_around() return void
  skbuff: simplify __alloc_skb() a bit
  skbuff: use __build_skb_around() in __alloc_skb()
  skbuff: remove __kfree_skb_flush()
  skbuff: move NAPI cache declarations upper in the file
  skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads
  skbuff: allow to optionally use NAPI cache from __alloc_skb()
  skbuff: allow to use NAPI cache from __napi_alloc_skb()
  skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing

 include/linux/skbuff.h |   4 +-
 net/core/dev.c         |  16 +-
 net/core/skbuff.c      | 429 +++++++++++++++++++++++------------------
 3 files changed, 243 insertions(+), 206 deletions(-)

--=20
2.30.1


