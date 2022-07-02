Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0638B563E82
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 06:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiGBEjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 00:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGBEjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 00:39:15 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8331F2C9
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 21:39:13 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id i7so7294927ybe.11
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 21:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fcXrjy6USp+1HO3NzJ6oUGjfai/efuk6xIDLeKxBtPY=;
        b=DgKf0ALqJ5mXoBMWwMaod4Uq31oa3BBX+hyu7XnAX7uILVe207HQWmjTejcHLhzyrC
         U5sIXh9IkCOPWfsa/52Z5yU9zfBKsclpTIxzL1jviS38zHEyHKNm1urcqFb0OVPbBjKO
         ag53BlXvXACH0E0B+PF7Xe0fZkhHytyOgCHXJegNx4O7Bvi92TKxT+3G8hwtSkUVH7Cb
         jG5w7+2remvdGorg0d/2YhjORir4GJpcI4+8ntzuqZbrOVGCKW1ib4/Iu6yFBPGXPY9y
         b/pW8MUr+0RD3GmsNldExMrlr0fsnxxeyWrAzLDI6UeKokF5VFBgzqF7NtNILroQtmgg
         Uy6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcXrjy6USp+1HO3NzJ6oUGjfai/efuk6xIDLeKxBtPY=;
        b=LvObLms+NxQqbj6ZCp4HjwQpDZIQrNIoLBJzJkohYHj/6u1+cQAc1SzVnCe30eIPtP
         F83QS/x0q1RNF/dOr1f8pxDPjK46BKVXeUv8nwGwe/t98snKF2avk1NWWDYM7GdRGu/L
         ZH/FTDD5ieIYCPzWypRNa398VpCJay/psYZXTBT+FJ51wPoORZURZoTk2uPqPMY44+RG
         4TMPVtbBRhUF3CjbYsa5ZO7fhnVGwDajx6W0fKeZ6PBK1vpuI1+fgCrRuipbfpJEAtSK
         BjDyQtbg5R7883CuJEsGkdhSxFQg68teT9rNvSGeTkTCoJdh8278TCAtUKxhq9kNvxrO
         nzdg==
X-Gm-Message-State: AJIora+sVz7MAYxdBp1FBad+vTCixmGQHB7FF9k40rlL2j3D6Nu6XVHA
        /qKaOo7kECxJZzpRFsgPkcIaaikcJYi+MEeM/ztfJg==
X-Google-Smtp-Source: AGRyM1uQrnSvirfBdxClGd1N0T3VdTWivoUq/R2MZ/gPT2WVqAbJUXoputqV1WaS76zlMDOnkwu7eoHaj+f2bie7nrM=
X-Received: by 2002:a25:3a81:0:b0:66a:645f:fe99 with SMTP id
 h123-20020a253a81000000b0066a645ffe99mr17617688yba.489.1656736752690; Fri, 01
 Jul 2022 21:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220701094256.1970076-1-johan.almbladh@anyfinetworks.com>
 <20220701151200.2033129-1-johan.almbladh@anyfinetworks.com> <1558ba51-c9dd-e265-4222-a69e27238813@iogearbox.net>
In-Reply-To: <1558ba51-c9dd-e265-4222-a69e27238813@iogearbox.net>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Sat, 2 Jul 2022 06:39:01 +0200
Message-ID: <CAM1=_QTrTPaQn9fuYoOGV6vs-gjgztFyTieQKCCcY0pFuqvpKA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xdp: Fix spurious packet loss in generic XDP TX path
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, song@kernel.org,
        martin.lau@linux.dev, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Freysteinn.Alfredsson@kau.se, toke@redhat.com,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 2, 2022 at 12:47 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/1/22 5:12 PM, Johan Almbladh wrote:
> > The byte queue limits (BQL) mechanism is intended to move queuing from
> > the driver to the network stack in order to reduce latency caused by
> > excessive queuing in hardware. However, when transmitting or redirecting
> > a packet using generic XDP, the qdisc layer is bypassed and there are no
> > additional queues. Since netif_xmit_stopped() also takes BQL limits into
> > account, but without having any alternative queuing, packets are
> > silently dropped.
> >
> > This patch modifies the drop condition to only consider cases when the
> > driver itself cannot accept any more packets. This is analogous to the
> > condition in __dev_direct_xmit(). Dropped packets are also counted on
> > the device.
> >
> > Bypassing the qdisc layer in the generic XDP TX path means that XDP
> > packets are able to starve other packets going through a qdisc, and
> > DDOS attacks will be more effective. In-driver-XDP use dedicated TX
> > queues, so they do not have this starvation issue.
> >
> > Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> > ---
> >   net/core/dev.c | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 8e6f22961206..00fb9249357f 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4863,7 +4863,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
> >   }
> >
> >   /* When doing generic XDP we have to bypass the qdisc layer and the
> > - * network taps in order to match in-driver-XDP behavior.
> > + * network taps in order to match in-driver-XDP behavior. This also means
> > + * that XDP packets are able to starve other packets going through a qdisc,
> > + * and DDOS attacks will be more effective. In-driver-XDP use dedicated TX
> > + * queues, so they do not have this starvation issue.
> >    */
> >   void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
> >   {
> > @@ -4875,10 +4878,12 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
> >       txq = netdev_core_pick_tx(dev, skb, NULL);
> >       cpu = smp_processor_id();
> >       HARD_TX_LOCK(dev, txq, cpu);
> > -     if (!netif_xmit_stopped(txq)) {
> > +     if (!netif_xmit_frozen_or_drv_stopped(txq)) {
> >               rc = netdev_start_xmit(skb, dev, txq, 0);
> >               if (dev_xmit_complete(rc))
> >                       free_skb = false;
> > +     } else {
> > +             dev_core_stats_tx_dropped_inc(dev);
> >       }
> >       HARD_TX_UNLOCK(dev, txq);
> >       if (free_skb) {
>
> Small q: Shouldn't the drop counter go into the free_skb branch?

This was on purpose to not increment the counter twice, but I think
you are right. The driver update the tx_dropped counter if the packet
is dropped, but I see that it also consumes the skb in those cases.
Looking again at the driver tree I cannot found any examples where the
driver updates the counter *without* consuming the skb. This logic
makes sense - whoever consumes the skb it is also responsible for
updating the counters on the netdev.

>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 00fb9249357f..17e2c39477c5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4882,11 +4882,10 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
>                  rc = netdev_start_xmit(skb, dev, txq, 0);
>                  if (dev_xmit_complete(rc))
>                          free_skb = false;
> -       } else {
> -               dev_core_stats_tx_dropped_inc(dev);
>          }
>          HARD_TX_UNLOCK(dev, txq);
>          if (free_skb) {
> +               dev_core_stats_tx_dropped_inc(dev);
>                  trace_xdp_exception(dev, xdp_prog, XDP_TX);
>                  kfree_skb(skb);
>          }
