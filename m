Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2450147D082
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240157AbhLVLGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:06:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240151AbhLVLGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:06:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640171198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ceCWycWRHrWKCZY6dAAESWQ7r47FSVaC7YZyAMeDDKk=;
        b=fETKXgF/5YzTZq0oV55N52sjc86nFHA2rk5EGzfaLVxzBBk1O6GJyYx88mo3cfdNRovr76
        /NobX+dHUSNtsAyJrQNTH5AT40dWh333F0w9FXl7QoyX7XC2p5JZ4V8aK8HkBDq/mRUIGk
        JCd3aTY8f7WGCDA1805+owmDjA8pEWo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-bLDulFogM3atBzaAz_0clw-1; Wed, 22 Dec 2021 06:06:37 -0500
X-MC-Unique: bLDulFogM3atBzaAz_0clw-1
Received: by mail-qk1-f197.google.com with SMTP id p18-20020a05620a057200b00467bc32b45aso1472718qkp.12
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ceCWycWRHrWKCZY6dAAESWQ7r47FSVaC7YZyAMeDDKk=;
        b=VX+NAYl8JZOE9CDV3F/F3XHu44MWf9mq2Fi1wYs5rDKV6aWLrCQRMG/6K2DJwUcItc
         gEgSkDKPztsayS6crt/ZFyr1oIc5M16QRkWUtxq6j1XnAGMWfiyh9OWXd8lgoOLhS1P7
         8VKBn6FgD8Hi7Ef+IjuCJvjLaPwYYd+ED1XcreNQq7X64tJqh3k3i+lvGsKhaVJ52iAG
         B3M5wQjL8h35uPtcqKsBKza0BYq/rivMlKa7pcaDxC1MP0dM0b1Cqp+Apzk1skCcIWGP
         q8xHdOD6fJXeOtlIBQF4wvnabfnX8f7OlcBtAcB7M7fVTqcKdVGIshCbI8rHcHKdHSyF
         LtXw==
X-Gm-Message-State: AOAM530BAqjdzl8abDEQTxsCrzBnfjLMFi0aboQ0wB9OSu8W0tYhuAl0
        0ICd88twZ3BkLq1PJbglsHzVEFYugHt4Z1JavXf368uzzy7dumct3Khv4HYucqlH76YKeR/V8qc
        stnoy+VA97QWkagTg
X-Received: by 2002:a37:8684:: with SMTP id i126mr636448qkd.436.1640171196437;
        Wed, 22 Dec 2021 03:06:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMicG0r6dSeRYSbToqb6O6HBC61TxfWFrjgk0pImfFkS+SB/o4SyZvBse0tKyn9xBeK2S0EQ==
X-Received: by 2002:a37:8684:: with SMTP id i126mr636434qkd.436.1640171196108;
        Wed, 22 Dec 2021 03:06:36 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-225-60.dyn.eolo.it. [146.241.225.60])
        by smtp.gmail.com with ESMTPSA id x62sm1439965qkb.70.2021.12.22.03.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 03:06:35 -0800 (PST)
Message-ID: <dad55584ad20723f1579475a09ef7b3a3607e087.camel@redhat.com>
Subject: Re: [PATCH net] veth: ensure skb entering GRO are not cloned.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 22 Dec 2021 12:06:31 +0100
In-Reply-To: <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
References: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
         <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2021-12-21 at 20:31 -0800, Eric Dumazet wrote:
> On Tue, Dec 21, 2021 at 1:34 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
> > if GRO is enabled on a veth device and TSO is disabled on the peer
> > device, TCP skbs will go through the NAPI callback. If there is no XDP
> > program attached, the veth code does not perform any share check, and
> > shared/cloned skbs could enter the GRO engine.
> > 
> > 
> 
> ...
> 
> > Address the issue checking for cloned skbs even in the GRO-without-XDP
> > input path.
> > 
> > Reported-and-tested-by: Ignat Korchagin <ignat@cloudflare.com>
> > Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  drivers/net/veth.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > index b78894c38933..abd1f949b2f5 100644
> > --- a/drivers/net/veth.c
> > +++ b/drivers/net/veth.c
> > @@ -718,6 +718,14 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
> >         rcu_read_lock();
> >         xdp_prog = rcu_dereference(rq->xdp_prog);
> >         if (unlikely(!xdp_prog)) {
> > +               if (unlikely(skb_shared(skb) || skb_head_is_locked(skb))) {
> 
> Why skb_head_is_locked() needed here ?
> I would think skb_cloned() is enough for the problem we want to address.

Thank you for the feedback.

I double checked the above: in my test even skb_cloned() suffice.

> > +                       struct sk_buff *nskb = skb_copy(skb, GFP_ATOMIC | __GFP_NOWARN);
> > +
> > +                       if (!nskb)
> > +                               goto drop;
> > +                       consume_skb(skb);
> > +                       skb = nskb;
> > +               }
> >                 rcu_read_unlock();
> >                 goto out;
> >         }
> > --
> > 2.33.1
> > 
> 
> - It seems adding yet memory alloc/free and copies is defeating GRO purpose.
> - After skb_copy(), GRO is forced to use the expensive frag_list way
> for aggregation anyway.
> - veth mtu could be set to 64KB, so we could have order-4 allocation
> attempts here.
> 
> Would the following fix [1] be better maybe, in terms of efficiency,
> and keeping around skb EDT/tstamp
> information (see recent thread with Martin and Daniel )
> 
> I think it also focuses more on the problem (GRO is not capable of
> dealing with cloned skb yet).
> Who knows, maybe in the future we will _have_ to add more checks in
> GRO fast path for some other reason,
> since it is becoming the Swiss army knife of networking :)

Only vaguely related: I have a bunch of micro optimizations for the GRO
engine. I did not submit the patches because I can observe the gain
only in micro-benchmarks, but I'm wondering if that could be visible
with very high speed TCP stream? I can share the code if that could be
of general interest (after some rebasing, the patches predates gro.c)

> Although I guess this whole case (disabling TSO) is moot, I have no
> idea why anyone would do that :)
> 
> [1]
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 50eb43e5bf459bb998e264d399bc85d4e9d73594..fe7a4d2f7bfc834ea56d1da185c0f53bfbd22ad0
> 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
> 
>                         stats->xdp_bytes += skb->len;
>                         skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
> -                       if (skb)
> -                               napi_gro_receive(&rq->xdp_napi, skb);
> +                       if (skb) {
> +                               if (skb_shared(skb) || skb_cloned(skb))
> +                                       netif_receive_skb(skb);
> +                               else
> +                                       napi_gro_receive(&rq->xdp_napi, skb);
> +                       }
>                 }
>                 done++;
>         }

I tested the above, and it works, too.

I thought about something similar, but I overlooked possible OoO or
behaviour changes when a packet socket is attached to the paired device
(as it would disable GRO).

It looks like tcpdump should have not ill-effects (the mmap rx-path
releases the skb clone before the orig packet reaches the other end),
so I guess the above is fine (and sure is better to avoid more
timestamp related problem).

Do you prefer to submit it formally, or do you prefer I'll send a v2
with the latter code?

Thanks!

Paolo


