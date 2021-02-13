Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCE131ABFD
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBMN5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 08:57:40 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:49790 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhBMN5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 08:57:37 -0500
Date:   Sat, 13 Feb 2021 13:56:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613224611; bh=T6KIeabV5sI7XCFa/PJx1BokACoH/f2hbL4xDuJnHrw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=paJxQJHQ6QsKrY/FqcS3AXMj5XvUuQ90BRqLHfuUsi9sWtk2cLIaYm+tHM3cNPOXE
         hWNhJER6x7rJCLYwz7ifoh6QseyWydbnO7bNjI88HMlCcJuxtVZ+MRy4O9mAcI75i9
         1xvBPF74nQtOT4vaJUsbWYhFmQTIDt7XTILs8FPjL1Yf3gWTDr7d84paGVEQHkZGbj
         nB8qpQdsijf1m6XNi4NEDHZTsO4eURX0Aqu3IZ+86+YhUdb0550UMZLqiETXmiV9+P
         ABbATPXQXpOmD6yhsv6GAC40z5OW4KErtHtpdp2RKfVdek7WuoNsVsV8FccVS7p6gM
         9ha3bAL1AC/rA==
To:     Alexander Duyck <alexander.duyck@gmail.com>
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
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v5 net-next 06/11] skbuff: remove __kfree_skb_flush()
Message-ID: <20210213135604.86581-1-alobakin@pm.me>
In-Reply-To: <CAKgT0Uc=_VereGioEPrvfT8-eL6odvs9PwNxywu4=UC1DPvRNQ@mail.gmail.com>
References: <20210211185220.9753-1-alobakin@pm.me> <20210211185220.9753-7-alobakin@pm.me> <CAKgT0Uc=_VereGioEPrvfT8-eL6odvs9PwNxywu4=UC1DPvRNQ@mail.gmail.com>
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

From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Thu, 11 Feb 2021 19:28:52 -0800

> On Thu, Feb 11, 2021 at 10:57 AM Alexander Lobakin <alobakin@pm.me> wrote=
:
> >
> > This function isn't much needed as NAPI skb queue gets bulk-freed
> > anyway when there's no more room, and even may reduce the efficiency
> > of bulk operations.
> > It will be even less needed after reusing skb cache on allocation path,
> > so remove it and this way lighten network softirqs a bit.
> >
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>=20
> I'm wondering if you have any actual gains to show from this patch?
>=20
> The reason why I ask is because the flushing was happening at the end
> of the softirq before the system basically gave control back over to
> something else. As such there is a good chance for the memory to be
> dropped from the cache by the time we come back to it. So it may be
> just as expensive if not more so than accessing memory that was just
> freed elsewhere and placed in the slab cache.

Just retested after readding this function (and changing the logics so
it would drop the second half of the cache, like napi_skb_cache_put()
does) and got 10 Mbps drawback with napi_build_skb() +
napi_gro_receive().

So seems like getting a pointer from an array instead of calling
kmem_cache_alloc() is cheaper even if the given object was pulled
out of CPU caches.

> > ---
> >  include/linux/skbuff.h |  1 -
> >  net/core/dev.c         |  7 +------
> >  net/core/skbuff.c      | 12 ------------
> >  3 files changed, 1 insertion(+), 19 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 0a4e91a2f873..0e0707296098 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -2919,7 +2919,6 @@ static inline struct sk_buff *napi_alloc_skb(stru=
ct napi_struct *napi,
> >  }
> >  void napi_consume_skb(struct sk_buff *skb, int budget);
> >
> > -void __kfree_skb_flush(void);
> >  void __kfree_skb_defer(struct sk_buff *skb);
> >
> >  /**
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 321d41a110e7..4154d4683bb9 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4944,8 +4944,6 @@ static __latent_entropy void net_tx_action(struct=
 softirq_action *h)
> >                         else
> >                                 __kfree_skb_defer(skb);
> >                 }
> > -
> > -               __kfree_skb_flush();
> >         }
> >
> >         if (sd->output_queue) {
> > @@ -7012,7 +7010,6 @@ static int napi_threaded_poll(void *data)
> >                         __napi_poll(napi, &repoll);
> >                         netpoll_poll_unlock(have);
> >
> > -                       __kfree_skb_flush();
> >                         local_bh_enable();
> >
> >                         if (!repoll)
>=20
> So it looks like this is the one exception to my comment above. Here
> we should probably be adding a "if (!repoll)" before calling
> __kfree_skb_flush().
>=20
> > @@ -7042,7 +7039,7 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >
> >                 if (list_empty(&list)) {
> >                         if (!sd_has_rps_ipi_waiting(sd) && list_empty(&=
repoll))
> > -                               goto out;
> > +                               return;
> >                         break;
> >                 }
> >
> > @@ -7069,8 +7066,6 @@ static __latent_entropy void net_rx_action(struct=
 softirq_action *h)
> >                 __raise_softirq_irqoff(NET_RX_SOFTIRQ);
> >
> >         net_rps_action_and_irq_enable(sd);
> > -out:
> > -       __kfree_skb_flush();
> >  }
> >
> >  struct netdev_adjacent {
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 1c6f6ef70339..4be2bb969535 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -838,18 +838,6 @@ void __consume_stateless_skb(struct sk_buff *skb)
> >         kfree_skbmem(skb);
> >  }
> >
> > -void __kfree_skb_flush(void)
> > -{
> > -       struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache)=
;
> > -
> > -       /* flush skb_cache if containing objects */
> > -       if (nc->skb_count) {
> > -               kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
> > -                                    nc->skb_cache);
> > -               nc->skb_count =3D 0;
> > -       }
> > -}
> > -
> >  static inline void _kfree_skb_defer(struct sk_buff *skb)
> >  {
> >         struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache)=
;
> > --
> > 2.30.1

Al

