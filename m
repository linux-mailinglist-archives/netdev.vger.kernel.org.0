Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F333B3512EC
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 12:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234035AbhDAJ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 05:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhDAJ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 05:59:19 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D954FC061788
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 02:59:11 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id m132so1205543ybf.2
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 02:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yFvsjh5AstzSh/3RmSp+v0uX0o4tln2rcj2STO2FZVw=;
        b=MWqwTRkeg0wU5jC3C1JSa5iBcsmJwKtvX/NzPO3m0H2yvUJm+mBcQh58Ob/cf6Yx7Y
         JwiSLgOJXfmDrNT5bdMS7H+zaQOEdyjZ8j6HjQfIzz2oV/XdnQwOulu5K2vrclt1wjet
         /LArfMkhUH2mN7EV8xHOcQrpFgQJUcOGC6fXUaiXEtFdRCJofxw++FE9WhqzVV07EDLr
         werYCRCMjpPVAMczoQLqr+OTomg5xyGmEFZvvBbRL7TT9EAccSjjTe4fmGFKwDQdhV69
         3SbVVnIJeG7B0Bij5JdFG85w/VhV8DWUm/b5VAhyqgQ9HtPoWMFDMUvVpdQdPErTs4Cm
         MzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yFvsjh5AstzSh/3RmSp+v0uX0o4tln2rcj2STO2FZVw=;
        b=WbBfm7M85n2Xvd9SJLk8xvhB8RsBzvaHDA0K6ALKwefewvzDZ4k2hIcX8NT3wsP9q/
         AcJO9so+MoLqjdX2cvRu0+dt6OueDMyKEIXOkCYiwL5dbyZZgiWflcTThWap/hMMG8IL
         ERIdVZvoukSYN3bJbgf65PgH4mC2+gV9JQisY9KUM/+T0Y67zdU2KeigHyysjCbJ8rPf
         E6khJuV+IvTWNOvlCdRds5tNIQ6UJmMO3/jb1ADT/0sJisXlpQRGxIvCGjniuCu0LS5Y
         sIeeQTMZFbTHUqC+5jGv1sJzu4BCe/H51m44+65f5P8p2Ou1+U4UlhcYHRXxQSrZCHAD
         HwMg==
X-Gm-Message-State: AOAM531g14YzbOMbj/VGjOntOWSt1s8cYcMYCL016QrBHLr2IdYxT/dF
        1c+qn3MefMXihH/ayILLVGfSoOdpHwX8RB2FedALXA==
X-Google-Smtp-Source: ABdhPJxD/li3Jvnd6nclsnuTWXgGLtaZSsCA9Le9pvA2SyOjQ4QR0UiQbE31LY6Rrs0caSi2X7b2ZGoo1Kf2Ehs37DY=
X-Received: by 2002:a25:ab81:: with SMTP id v1mr11021120ybi.303.1617271150613;
 Thu, 01 Apr 2021 02:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <cd931f86-e213-78f1-8a88-79a28c506ec5@redhat.com> <1617267183.5697193-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1617267183.5697193-1-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Apr 2021 11:58:58 +0200
Message-ID: <CANn89iJA=RMKFNk5LFUxuQPUsXBoL2UbcskkX94UeFZo-B9LEw@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, su-lifan@linux.alibaba.com,
        "dust.li" <dust.li@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 1, 2021 at 11:04 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Thu, 1 Apr 2021 15:14:18 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> >
> > =E5=9C=A8 2021/3/31 =E4=B8=8B=E5=8D=884:11, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> > > On Mon, Mar 29, 2021 at 11:06:09AM +0200, Eric Dumazet wrote:
> > >> On Mon, Mar 29, 2021 at 10:52 AM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
> > >>> On Wed, 13 Jan 2021 08:18:19 -0800, Eric Dumazet <eric.dumazet@gmai=
l.com> wrote:
> > >>>> From: Eric Dumazet <edumazet@google.com>
> > >>>>
> > >>>> Both virtio net and napi_get_frags() allocate skbs
> > >>>> with a very small skb->head
> > >>>>
> > >>>> While using page fragments instead of a kmalloc backed skb->head m=
ight give
> > >>>> a small performance improvement in some cases, there is a huge ris=
k of
> > >>>> under estimating memory usage.
> > >>>>
> > >>>> For both GOOD_COPY_LEN and GRO_MAX_HEAD, we can fit at least 32 al=
locations
> > >>>> per page (order-3 page in x86), or even 64 on PowerPC
> > >>>>
> > >>>> We have been tracking OOM issues on GKE hosts hitting tcp_mem limi=
ts
> > >>>> but consuming far more memory for TCP buffers than instructed in t=
cp_mem[2]
> > >>>>
> > >>>> Even if we force napi_alloc_skb() to only use order-0 pages, the i=
ssue
> > >>>> would still be there on arches with PAGE_SIZE >=3D 32768
> > >>>>
> > >>>> This patch makes sure that small skb head are kmalloc backed, so t=
hat
> > >>>> other objects in the slab page can be reused instead of being held=
 as long
> > >>>> as skbs are sitting in socket queues.
> > >>>>
> > >>>> Note that we might in the future use the sk_buff napi cache,
> > >>>> instead of going through a more expensive __alloc_skb()
> > >>>>
> > >>>> Another idea would be to use separate page sizes depending
> > >>>> on the allocated length (to never have more than 4 frags per page)
> > >>>>
> > >>>> I would like to thank Greg Thelen for his precious help on this ma=
tter,
> > >>>> analysing crash dumps is always a time consuming task.
> > >>>
> > >>> This patch causes a performance degradation of about 10% in the sce=
nario of
> > >>> virtio-net + GRO.
> > >>>
> > >>> For GRO, there is no way to merge skbs based on frags with this pat=
ch, only
> > >>> frag_list can be used to link skbs. The problem that this cause are=
 that compared
> > >>> to the GRO package merged into the frags way, the current skb needs=
 to call
> > >>> kfree_skb_list to release each skb, resulting in performance degrad=
ation.
> > >>>
> > >>> virtio-net will store some data onto the linear space after receivi=
ng it. In
> > >>> addition to the header, there are also some payloads, so "headlen <=
=3D offset"
> > >>> fails. And skb->head_frag is failing when use kmalloc() for skb->he=
ad allocation.
> > >>>
> > >> Thanks for the report.
> > >>
> > >> There is no way we can make things both fast for existing strategies
> > >> used by _insert_your_driver
> > >> and malicious usages of data that can sit for seconds/minutes in soc=
ket queues.
> > >>
> > >> I think that if you want to gain this 10% back, you have to change
> > >> virtio_net to meet optimal behavior.
> > >>
> > >> Normal drivers make sure to not pull payload in skb->head, only head=
ers.
> > > Hmm we do have hdr_len field, but seem to ignore it on RX.
> > > Jason do you see any issues with using it for the head len?
> >
> >
> > This might work only if the device sets a correct hdr_len. I'm not sure
> > all of the devices can do this properly. E.g for tap, we use
> > skb_headlen() in virtio_net_hdr_from_skb() which depends highly on the
> > behaviour of the underlayer layers (device driver or GRO). And we only
> > set this hint for GSO packet but virtio-net may tries to do GRO for non
> > GSO packets.
> >
> > Thanks
>
> hi, Jason
>
> I personally prefer to use build_skb to create skb, so the problem here i=
s
> actually gone.
>
> The premise of this is that the buffer added by add_recvbuf_mergeable mus=
t
> retain a skb_shared_info. Of course, then rx frags coalescing won't
> work. But I consider that suppose the size of the mrg_avg_pkt_len 1500, s=
o we
> can still store 17 * 1500 =3D 24k packets in a skb. If the packet is real=
ly big,
> the mrg_avg_pkt_len will also increase, and the buffer allocated later wi=
ll
> increase. When the mrg_avg_pkt_len is greater than PAGE_SIZE/2, rx frags
> coalesce is no longer needed. Because we can't allocate two bufs with a v=
alue of
> mrg_avg_pkt_len on the same page.
>

For the record I implemented build_skb() 10 years ago, so you can
trust me when I
am saying this will not help.

Using build_skb() will waste additional skb_shared_info per MSS.
That's an increase of 20% of memory, for nothing at all.

Also there are cases when this won't be possible, say if you use an MTU of =
4000





> Thanks.
>
> >
> >
> > >
> > >
> > >> Optimal GRO packets are when payload is in page fragments.
> > >>
> > >> (I am speaking not only for raw performance, but ability for systems
> > >> to cope with network outages and sudden increase of memory usage in
> > >> out of order queues)
> > >>
> > >> This has been quite clearly stated in my changelog.
> > >>
> > >> Thanks.
> > >>
> > >>
> > >>> int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >>> {
> > >>>          struct skb_shared_info *pinfo, *skbinfo =3D skb_shinfo(skb=
);
> > >>>          unsigned int offset =3D skb_gro_offset(skb);
> > >>>          unsigned int headlen =3D skb_headlen(skb);
> > >>>
> > >>>      .......
> > >>>
> > >>>          if (headlen <=3D offset) {         // virtio-net will fail
> > >>>          ........ // merge by frags
> > >>>                  goto done;
> > >>>          } else if (skb->head_frag) {     // skb->head_frag is fail=
 when use kmalloc() for skb->head allocation
> > >>>          ........ // merge by frags
> > >>>                  goto done;
> > >>>          }
> > >>>
> > >>> merge:
> > >>>      ......
> > >>>
> > >>>          if (NAPI_GRO_CB(p)->last =3D=3D p)
> > >>>                  skb_shinfo(p)->frag_list =3D skb;
> > >>>          else
> > >>>                  NAPI_GRO_CB(p)->last->next =3D skb;
> > >>>
> > >>>      ......
> > >>>          return 0;
> > >>> }
> > >>>
> > >>>
> > >>> test cmd:
> > >>>   for i in $(seq 1 4)
> > >>>   do
> > >>>      redis-benchmark -r 10000000 -n 10000000 -t set -d 1024 -c 8 -P=
 32 -h  <ip> -p 6379 2>&1 | grep 'per second'  &
> > >>>   done
> > >>>
> > >>> Reported-by: su-lifan@linux.alibaba.com
> > >>>
> > >>>> Fixes: fd11a83dd363 ("net: Pull out core bits of __netdev_alloc_sk=
b and add __napi_alloc_skb")
> > >>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >>>> Cc: Alexander Duyck <alexanderduyck@fb.com>
> > >>>> Cc: Paolo Abeni <pabeni@redhat.com>
> > >>>> Cc: Michael S. Tsirkin <mst@redhat.com>
> > >>>> Cc: Greg Thelen <gthelen@google.com>
> > >>>> ---
> > >>>>   net/core/skbuff.c | 9 +++++++--
> > >>>>   1 file changed, 7 insertions(+), 2 deletions(-)
> > >>>>
> > >>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > >>>> index 7626a33cce590e530f36167bd096026916131897..3a8f55a43e6964344d=
f464a27b9b1faa0eb804f3 100644
> > >>>> --- a/net/core/skbuff.c
> > >>>> +++ b/net/core/skbuff.c
> > >>>> @@ -501,13 +501,17 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
> > >>>>   struct sk_buff *__napi_alloc_skb(struct napi_struct *napi, unsig=
ned int len,
> > >>>>                                 gfp_t gfp_mask)
> > >>>>   {
> > >>>> -     struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cac=
he);
> > >>>> +     struct napi_alloc_cache *nc;
> > >>>>        struct sk_buff *skb;
> > >>>>        void *data;
> > >>>>
> > >>>>        len +=3D NET_SKB_PAD + NET_IP_ALIGN;
> > >>>>
> > >>>> -     if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
> > >>>> +     /* If requested length is either too small or too big,
> > >>>> +      * we use kmalloc() for skb->head allocation.
> > >>>> +      */
> > >>>> +     if (len <=3D SKB_WITH_OVERHEAD(1024) ||
> > >>>> +         len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
> > >>>>            (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
> > >>>>                skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NU=
MA_NO_NODE);
> > >>>>                if (!skb)
> > >>>> @@ -515,6 +519,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_s=
truct *napi, unsigned int len,
> > >>>>                goto skb_success;
> > >>>>        }
> > >>>>
> > >>>> +     nc =3D this_cpu_ptr(&napi_alloc_cache);
> > >>>>        len +=3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > >>>>        len =3D SKB_DATA_ALIGN(len);
> > >>>>
> > >>>> --
> > >>>> 2.30.0.284.gd98b1dd5eaa7-goog
> > >>>>
> >
