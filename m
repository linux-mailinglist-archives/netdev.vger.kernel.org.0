Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1BA4BF023
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiBVDx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:53:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiBVDxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:53:25 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C102A256;
        Mon, 21 Feb 2022 19:52:58 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id i11so31990794eda.9;
        Mon, 21 Feb 2022 19:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ZgQXvZsELc67V/yMhgs9KgblP3IFQsF3DCluKIvHKw=;
        b=lVaEZqzYR7smwdFaIjgLjx6+jCb/kseFnkpfOD4fET89Pq2Hfph9uE1j8sN5t2WR+w
         IcNAE0xRi4+JqAxLJ5+3/2z4FSM3vtrK+0PlfyKadYhKEolLN7Sl/7JUPDzyrl1gvKCT
         1xp+AAowN8t+YAghA8piED042G6OUA25Fp3MMSAy0WKwJsCNlzU0GDbvwen2Cxi6aVWO
         y70cz8yYwv1PYvdeB5bP+eup9AEPwZg7/+Rx0a9cQJv34BVBJlRZeYDjNkI+VNKNQqri
         pfx2xZt0EScxDb41WscyD6I7vaN3qOnvuEq/5dmXPRO7bbQuYWv4D2VTmJw6KkO8lpLN
         4n5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ZgQXvZsELc67V/yMhgs9KgblP3IFQsF3DCluKIvHKw=;
        b=28LRfiF3iqNusluFzuwUIBYI37Z5+7BlNtXiHkqub2xmlTSUQn3e4i17Rfn+W+3bHn
         vGzGDfrtf1gMxKl8WGJbaQnetwQflXgl3CHtu3DcID9TCnXByfOQitSYuHbvXoyATE4Y
         iHP8IqfI9OD98z1r893kQXOPVPvwBZdU2C6RiPFjtVbcXTMiTiayMuaouV26uAANqBzF
         hZWGKfsy6/SzDL+BVO2y1zobvi+2EvNKsF/czf+/I0wVocypmfSfN9lh5tU4X0X3ZylE
         /5YOMdSMaXdP9TuVSlsMvBoZ+FFCn6DkEiZOgd8fydJyVK4FII3UywXAnb3Yw4EDOZHE
         d4aA==
X-Gm-Message-State: AOAM5309Nb5hTwH+ES/alpIemxJ7TMcUqVy3fI75UGUJbIXNQx2eDHjO
        SpWJXMICiTkgLF30zz1FNvaW+jsBc7xdtMzMJ6w=
X-Google-Smtp-Source: ABdhPJwECknUN4HgmiXQAEsGZDIbkmhr5k3+UG3WEcenrX0WRxxLVNKK6JAmsYh+R6JyZ/XWHWkqzMMbi8RwgtYbdWA=
X-Received: by 2002:aa7:d7c8:0:b0:3f9:3b65:f2b3 with SMTP id
 e8-20020aa7d7c8000000b003f93b65f2b3mr24053092eds.389.1645501977019; Mon, 21
 Feb 2022 19:52:57 -0800 (PST)
MIME-Version: 1.0
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-3-imagedong@tencent.com> <2969b15c-b825-3b0e-2ad7-00633ee6815b@kernel.org>
In-Reply-To: <2969b15c-b825-3b0e-2ad7-00633ee6815b@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 22 Feb 2022 11:47:38 +0800
Message-ID: <CADxym3YX2+3EQPxynQj6FyXquNWJaefDrQJLAH4YroC8CvkHwQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: neigh: use kfree_skb_reason() for __neigh_event_send()
To:     David Ahern <dsahern@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, paulb@nvidia.com,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        flyingpeng@tencent.com, Mengen Sun <mengensun@tencent.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 11:17 AM David Ahern <dsahern@kernel.org> wrote:
>
> On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index c310a4a8fc86..206b66f5ce6b 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -393,6 +393,15 @@ enum skb_drop_reason {
> >                                        * see the doc for disable_ipv6
> >                                        * in ip-sysctl.rst for detail
> >                                        */
> > +     SKB_DROP_REASON_NEIGH_FAILED,   /* dropped as the state of
> > +                                      * neighbour is NUD_FAILED
> > +                                      */
>
> /* neigh entry in failed state */
>
> > +     SKB_DROP_REASON_NEIGH_QUEUEFULL,        /* the skbs that waiting
> > +                                              * for sending on the queue
> > +                                              * of neigh->arp_queue is
> > +                                              * full, and the skbs on the
> > +                                              * tail will be dropped
> > +                                              */
>
> /* arp_queue for neigh entry is full */
>
>
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index ec0bf737b076..c353834e8fa9 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -1171,7 +1171,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
> >                       neigh->updated = jiffies;
> >                       write_unlock_bh(&neigh->lock);
> >
> > -                     kfree_skb(skb);
> > +                     kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_FAILED);
> >                       return 1;
> >               }
> >       } else if (neigh->nud_state & NUD_STALE) {
> > @@ -1193,7 +1193,7 @@ int __neigh_event_send(struct neighbour *neigh, struct sk_buff *skb,
> >                               if (!buff)
> >                                       break;
> >                               neigh->arp_queue_len_bytes -= buff->truesize;
> > -                             kfree_skb(buff);
> > +                             kfree_skb_reason(buff, SKB_DROP_REASON_NEIGH_QUEUEFULL);
> >                               NEIGH_CACHE_STAT_INC(neigh->tbl, unres_discards);
> >                       }
> >                       skb_dst_force(skb);
>
> what about out_dead: path? the tracepoint there shows that path is of
> interest.

You are right, that path should be considered too.
