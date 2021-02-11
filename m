Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879A0318D98
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 15:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBKOqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 09:46:35 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:56722 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhBKOji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 09:39:38 -0500
Date:   Thu, 11 Feb 2021 14:38:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613054323; bh=gLXlYt9sVB2KVePA5uDpF6vfKRoqKT612iOxzbWMbgg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=dF/y1md9+NCpW0+ccZKfo1AofayKcPVie2oNpyokfHgroLAoQDmcbzHbsfnUUE7Wu
         UpGvAkf5LArGJ+86RlDB6Ssm7wCwGS81IDs9kyb39AREipU6gAWb74wPjONKj/b/eC
         ni2IvJ4jbLgvOKpaGIXSc5wGipgDI0DZoa647znaLoM9BgfuTZBqCN1d/6oFdKba1Z
         0QSzTRyFfk4kDa4CZEX+G7/kx6ZNndQh1yAtYJPrEj00GQGzWTIKWLcklM2CZsrwJq
         AZubIy4yMoYo3azt+1WdemanM92L5f3USct+HKHMMHi974Alz9+2GjWSue+iUU45QB
         DzE9/C4lz/aEQ==
To:     Jesper Dangaard Brouer <brouer@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
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
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 net-next 08/11] skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads
Message-ID: <20210211143818.2078-1-alobakin@pm.me>
In-Reply-To: <20210211135459.075d954b@carbon>
References: <20210210162732.80467-1-alobakin@pm.me> <20210210162732.80467-9-alobakin@pm.me> <20210211135459.075d954b@carbon>
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

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 11 Feb 2021 13:54:59 +0100

> On Wed, 10 Feb 2021 16:30:23 +0000
> Alexander Lobakin <alobakin@pm.me> wrote:
>=20
> > Instead of just bulk-flushing skbuff_heads queued up through
> > napi_consume_skb() or __kfree_skb_defer(), try to reuse them
> > on allocation path.
>=20
> Maybe you are already aware of this dynamics, but high speed NICs will
> usually run the TX "cleanup" (opportunistic DMA-completion) in the napi
> poll function call, and often before processing RX packets. Like
> ixgbe_poll[1] calls ixgbe_clean_tx_irq() before ixgbe_clean_rx_irq().

Sure. 1G MIPS is my home project (I'll likely migrate to ARM64 cluster
in 2-3 months). I mostly work with 10-100G NICs at work.

> If traffic is symmetric (or is routed-back same interface) then this
> SKB recycle scheme will be highly efficient. (I had this part of my
> initial patchset and tested it on ixgbe).
>=20
> [1] https://elixir.bootlin.com/linux/v5.11-rc7/source/drivers/net/etherne=
t/intel/ixgbe/ixgbe_main.c#L3149

That's exactly why I introduced this feature. Firstly driver enriches
the cache with the consumed skbs from Tx completion queue, and then
it just decaches them back on Rx completion cycle. That's how things
worked most of the time on my test setup.

The reason why Paolo proposed this as an option, and why I agreed
it's safer to do instead of unconditional switching, is that
different platforms and setup may react differently on this.
We don't have an ability to test the entire zoo, so we propose
an option for driver and network core developers to test and use
"on demand".
As I wrote in reply to Paolo, there might be cases when even the
core networking code may benefit from this.

> > If the cache is empty on allocation, bulk-allocate the first
> > 16 elements, which is more efficient than per-skb allocation.
> > If the cache is full on freeing, bulk-wipe the second half of
> > the cache (32 elements).
> > This also includes custom KASAN poisoning/unpoisoning to be
> > double sure there are no use-after-free cases.
> >=20
> > To not change current behaviour, introduce a new function,
> > napi_build_skb(), to optionally use a new approach later
> > in drivers.
> >=20
> > Note on selected bulk size, 16:
> >  - this equals to XDP_BULK_QUEUE_SIZE, DEV_MAP_BULK_SIZE
> >    and especially VETH_XDP_BATCH, which is also used to
> >    bulk-allocate skbuff_heads and was tested on powerful
> >    setups;
> >  - this also showed the best performance in the actual
> >    test series (from the array of {8, 16, 32}).
> >=20
> > Suggested-by: Edward Cree <ecree.xilinx@gmail.com> # Divide on two halv=
es
> > Suggested-by: Eric Dumazet <edumazet@google.com>   # KASAN poisoning
> > Cc: Dmitry Vyukov <dvyukov@google.com>             # Help with KASAN
> > Cc: Paolo Abeni <pabeni@redhat.com>                # Reduced batch size
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> > ---
> >  include/linux/skbuff.h |  2 +
> >  net/core/skbuff.c      | 94 ++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 83 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 0e0707296098..906122eac82a 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1087,6 +1087,8 @@ struct sk_buff *build_skb(void *data, unsigned in=
t frag_size);
> >  struct sk_buff *build_skb_around(struct sk_buff *skb,
> >  =09=09=09=09 void *data, unsigned int frag_size);
> > =20
> > +struct sk_buff *napi_build_skb(void *data, unsigned int frag_size);
> > +
> >  /**
> >   * alloc_skb - allocate a network buffer
> >   * @size: size to allocate
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 860a9d4f752f..9e1a8ded4acc 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -120,6 +120,8 @@ static void skb_under_panic(struct sk_buff *skb, un=
signed int sz, void *addr)
> >  }
> > =20
> >  #define NAPI_SKB_CACHE_SIZE=0964
> > +#define NAPI_SKB_CACHE_BULK=0916
> > +#define NAPI_SKB_CACHE_HALF=09(NAPI_SKB_CACHE_SIZE / 2)
> > =20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Thanks,
Al

