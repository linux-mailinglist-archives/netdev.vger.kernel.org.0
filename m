Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11949C164
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 03:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236472AbiAZClM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 21:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236462AbiAZClL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 21:41:11 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15971C06161C;
        Tue, 25 Jan 2022 18:41:11 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id l5so49587745edv.3;
        Tue, 25 Jan 2022 18:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nvYT9cREnL587cnwNxl70V0b4mTuKuGJBsvkUpeGJTI=;
        b=PiOBtBd8TvUYspYmYkT9OrQrUqhO7Wpl4lLWAFBD1Ne1JeO949dsU5uZRzhM1i4Py/
         aQb9zYxkowpya+taRfPhXSBN+9w1WubYbDFmrQYWEGvf50myO/1PQqxnq3z+Gup5Fpqa
         95lUYhueOhTq/EoO6KXCLLvMr0VbNoRzbI+ZPpBoR95GQv07Vv1HW/fiMQwMPmr5OhCx
         epw08QvSMqJN2056dgq+z9FyxMVy7rx4vkAFwNX59ehm75ipcU/cMSh20gg9KJB8BojF
         VGbjaKXYgF+fdcuskh9KHq+jSzGADm9BN2SV+RzYguHvuHikaeDRZSCVzhGPK5i6dlXY
         QeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nvYT9cREnL587cnwNxl70V0b4mTuKuGJBsvkUpeGJTI=;
        b=GqjZA2xYIzf+R9M/uptBC5j/pwA9ITckBwsRU6VnZGAFiVqiawVIALZGdrbvCjYe8E
         0FPzBTZREkqxy8daGqa1TZPDnSBCu1xzA4R7tnfZraQC2hA+N8xUQgbT7wmMTIoJPcKI
         HeQv/AoWB7VxOjRRlKnHjiMDtGo9/PWHpJdKPYp+9ND0WGDjC5Qk9ZWNz1k1uJrCRaQA
         VDAktRAKX3Oot3h8CLyu8l5BYnpKpkrygJgyzY9K3vFAmNfs9uEhZuQwG22dchn8pay8
         9IwPvOu9Ohv09ibaNgkS15czgcbwbVN9T6w8BrQt+lliVDFOZJeRTaLoSQVY8K3vpkMX
         mLeQ==
X-Gm-Message-State: AOAM5312PTTLQWeskDUp7jAuaU+ORCXB8jxXnYKz0w1JsSABLMWd4CH+
        PQ5G5kVNJhDy4iY96urEikmHYUvvRfDjfZjF6VY=
X-Google-Smtp-Source: ABdhPJzWDZQzWBiTo7Na9QBnnqqGO9SpMQ0BQ/8UcafVyIR5mzO325TRSPEiX5CSUlcWiyjagCOyN+c4DwsR1qzb7AI=
X-Received: by 2002:a05:6402:34c1:: with SMTP id w1mr18517792edc.403.1643164869573;
 Tue, 25 Jan 2022 18:41:09 -0800 (PST)
MIME-Version: 1.0
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-4-imagedong@tencent.com> <5201dd8b-e84c-89a0-568f-47a2211b88cb@gmail.com>
In-Reply-To: <5201dd8b-e84c-89a0-568f-47a2211b88cb@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 26 Jan 2022 10:36:41 +0800
Message-ID: <CADxym3YpyWh59cjtUqxGXxpb2+2Ywb-n4Jpz1KJG3AYRf5cenA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 10:18 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/24/22 6:15 AM, menglong8.dong@gmail.com wrote:
> > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > index ab9bee4bbf0a..77bb9ddc441b 100644
> > --- a/net/ipv4/ip_input.c
> > +++ b/net/ipv4/ip_input.c
> > @@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> >  {
> >       const struct iphdr *iph = ip_hdr(skb);
> >       int (*edemux)(struct sk_buff *skb);
> > +     int err, drop_reason;
> >       struct rtable *rt;
> > -     int err;
> > +
> > +     drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
> >
> >       if (ip_can_use_hint(skb, iph, hint)) {
> >               err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
> > @@ -339,8 +341,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> >               if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
> >                       err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
> >                                             udp_v4_early_demux, skb);
> > -                     if (unlikely(err))
> > +                     if (unlikely(err)) {
> > +                             drop_reason = SKB_DROP_REASON_EARLY_DEMUX;
>
> is there really value in this one? You ignore the error case from
> ip_route_use_hint which is a similar, highly unlikely error path so why
> care about this one? The only failure case is ip_mc_validate_source from
> udp_v4_early_demux and 'early demux' drops really mean nothing to the user.
>

Ok, let's just ignore it ( In fact, it's because that I don't know
what 'early demux'
do :/ )

>
> >                               goto drop_error;
> > +                     }
> >                       /* must reload iph, skb->head might have changed */
> >                       iph = ip_hdr(skb);
> >               }
> > @@ -353,8 +357,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
> >       if (!skb_valid_dst(skb)) {
> >               err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
> >                                          iph->tos, dev);
> > -             if (unlikely(err))
> > +             if (unlikely(err)) {
> > +                     drop_reason = SKB_DROP_REASON_IP_ROUTE_INPUT;
>
> The reason codes should be meaningful to users and not derived from a
> code path. What does SKB_DROP_REASON_IP_ROUTE_INPUT mean as a failure?
>

Is't it meaningful? I name it from the meaning of 'ip route lookup or validate
failed in input path', can't it express this information?

>
> >                       goto drop_error;
> > +             }
> >       }
> >
> >  #ifdef CONFIG_IP_ROUTE_CLASSID
