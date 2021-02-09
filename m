Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE60315883
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhBIVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:20:47 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:49748 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbhBIUrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:47:52 -0500
Date:   Tue, 09 Feb 2021 20:46:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903595; bh=OqhINS5au7CkgIZc/zoD88FzPH9SHYkuEvXcCCJstX4=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=lS7a7+3WQVXxFjZAC+WtL8ZIRbM4CTWuPwlPeAKnpqAMP209LS6XjSsHSbda/uCJY
         VwrW6VpXc9CvSiBCDi2bn9RFn1fEJBPSJyRni2NnG2FwUsIuzIyj/s/e3PTplWnRMT
         W+g1N4HtaPd6/naENaWkMkA4odbgnZ2f840yVZ6XZIi46kDgauAyhr/94nlVFAufIC
         O5WAFvTsBuqqMnS2mxBQWOQ7B7mP1lgzxuurIlgyTYQcstF75yiJvbjiL/3ZW15sqx
         kEpEpuKp0mjnPCDErWGA/KT5tppyVpYviR11VeBIOEbf5UREDo+IcOa2xCkf2XMdOW
         LPDACzBtVnFvw==
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [v3 net-next 00/10] skbuff: introduce skbuff_heads bulking and reusing
Message-ID: <20210209204533.327360-1-alobakin@pm.me>
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
As accessing napi_alloc_cache implies NAPI softirq context, decaching
is protected with in_serving_softirq() check, with the option to
bypass the check when the context is 100% known.

iperf3 showed 35-70 Mbps bumps for both TCP and UDP while performing
VLAN NAT on 1.2 GHz MIPS board. The boost is likely to be way bigger
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

Alexander Lobakin (10):
  skbuff: move __alloc_skb() next to the other skb allocation functions
  skbuff: simplify kmalloc_reserve()
  skbuff: make __build_skb_around() return void
  skbuff: simplify __alloc_skb() a bit
  skbuff: use __build_skb_around() in __alloc_skb()
  skbuff: remove __kfree_skb_flush()
  skbuff: move NAPI cache declarations upper in the file
  skbuff: reuse NAPI skb cache on allocation path (__build_skb())
  skbuff: reuse NAPI skb cache on allocation path (__alloc_skb())
  skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing

 include/linux/skbuff.h   |   4 +-
 net/core/dev.c           |  15 +-
 net/core/skbuff.c        | 392 ++++++++++++++++++++-------------------
 net/netlink/af_netlink.c |   2 +-
 4 files changed, 202 insertions(+), 211 deletions(-)

--=20
2.30.0


