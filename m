Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3E43D140E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhGUPoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbhGUPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:44:07 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036C3C061757
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:24:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d12so2788153wre.13
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qok1pkfdEeYSDb7/cI2MZAneeiWe2xwJyJcYchiQlYg=;
        b=WXtbpvq0LVm/vV6RiQcj36ZUAGBdqa8J9GitxasbubvQpgClPRjjcUahqlldYYCg0e
         2g4NH0zrmM5v5q/PVlmODXkdsLnFEf+52ctQANCQUWtWBIccFCiIfu/5APmcvHJwP0Ia
         lSJXj6Wms+HJdOqOeCx17OXgqB+aN2nm2opvEDNqJP1owj6rWT9As8IxXR1Ij80qbhen
         HY/wLEXizAcPRVJvWSFShFz1CRSoFccr7TymIZpVO24Gu7Ynsz3vpsyVG71tCnM6o9n0
         UVN6KRV4elraFwYeXFCJ5B1VpCBe8xUOGd7o794KAf3VKKn98FtlGx5ooq7mTx4FjVbV
         TkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qok1pkfdEeYSDb7/cI2MZAneeiWe2xwJyJcYchiQlYg=;
        b=pmEODOvOX+CXxYfnePzW+kTqP0BcunW0fhKNYnroDThmAk7Ub26CJgRPm1NN6yZEOr
         HPeTqiVN0p2Vg8qHNofQIkcMYSVu9GHjKZXMcQri6OVMOpCaTFas6XqvqKRWqgcPuZil
         x44wpcFzRIYBw/JWRKsueM/Ts/74Bqq5T+Y8sf9ftCiYzlVmELMUdLG03i9WMgTykyUB
         DiGlPl8ekYybClZR+sxup8oDWtvR0KzlH/pJQcL+DOSj0C3hzuvIhIW91Jh/Fih9MwKu
         EK4rPphLIntY/3rxGucp4OEfMDl1eaZbMy/ydlzf6zrGbj9RZi+2cgzzjFv/3I2JABml
         p2Hw==
X-Gm-Message-State: AOAM5331tKji/6BkTdV2jlmniA9lPe+Aml8uqwcscQbNGVFg0YtrzsxK
        lgIRnyq4gMztaMY0IpQgdeJDVlCBvRCrdREyfqH0XQ==
X-Google-Smtp-Source: ABdhPJzkafvo+aUKoCi3LtgNCEdvHBGEVZ7rIGzNBD8fmmDhG9AAWePUynsRD6qKX+TSkPXXfRSVkWzyNsCJhO4vNqI=
X-Received: by 2002:adf:e902:: with SMTP id f2mr43451966wrm.424.1626884681408;
 Wed, 21 Jul 2021 09:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210721101528.329723-1-eric.dumazet@gmail.com> <CACSApvamiE2Q_OdzU+Sv4Tw1jDKKmRR-7pS42nG0rQ=HV_-=uQ@mail.gmail.com>
In-Reply-To: <CACSApvamiE2Q_OdzU+Sv4Tw1jDKKmRR-7pS42nG0rQ=HV_-=uQ@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Wed, 21 Jul 2021 12:24:04 -0400
Message-ID: <CAK6E8=eALPfyEPmyuVqnCA2St0bH=NG=vyOwWTKcvcp+TVgmww@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: tweak len/truesize ratio for coalesce candidates
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 9:27 AM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Wed, Jul 21, 2021 at 6:15 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > tcp_grow_window() is using skb->len/skb->truesize to increase tp->rcv_ssthresh
> > which has a direct impact on advertized window sizes.
> >
> > We added TCP coalescing in linux-3.4 & linux-3.5:
> >
> > Instead of storing skbs with one or two MSS in receive queue (or OFO queue),
> > we try to append segments together to reduce memory overhead.
> >
> > High performance network drivers tend to cook skb with 3 parts :
> >
> > 1) sk_buff structure (256 bytes)
> > 2) skb->head contains room to copy headers as needed, and skb_shared_info
> > 3) page fragment(s) containing the ~1514 bytes frame (or more depending on MTU)
> >
> > Once coalesced into a previous skb, 1) and 2) are freed.
> >
> > We can therefore tweak the way we compute len/truesize ratio knowing
> > that skb->truesize is inflated by 1) and 2) soon to be freed.
> >
> > This is done only for in-order skb, or skb coalesced into OFO queue.
> >
> > The result is that low rate flows no longer pay the memory price of having
> > low GRO aggregation factor. Same result for drivers not using GRO.
> >
> > This is critical to allow a big enough receiver window,
> > typically tcp_rmem[2] / 2.
> >
> > We have been using this at Google for about 5 years, it is due time
> > to make it upstream.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Yuchung Cheng <ycheng@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>



>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> Thank you, Eric!
>
> > ---
> >  net/ipv4/tcp_input.c | 38 ++++++++++++++++++++++++++++++--------
> >  1 file changed, 30 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index bef2c8b64d83a0f3d4cca90f9b12912bf3d00807..501d8d4d4ba46f9a5de322ab690c320757e0990c 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -454,11 +454,12 @@ static void tcp_sndbuf_expand(struct sock *sk)
> >   */
> >
> >  /* Slow part of check#2. */
> > -static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)
> > +static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
> > +                            unsigned int skbtruesize)
> >  {
> >         struct tcp_sock *tp = tcp_sk(sk);
> >         /* Optimize this! */
> > -       int truesize = tcp_win_from_space(sk, skb->truesize) >> 1;
> > +       int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
> >         int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
> >
> >         while (tp->rcv_ssthresh <= window) {
> > @@ -471,7 +472,27 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)
> >         return 0;
> >  }
> >
> > -static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
> > +/* Even if skb appears to have a bad len/truesize ratio, TCP coalescing
> > + * can play nice with us, as sk_buff and skb->head might be either
> > + * freed or shared with up to MAX_SKB_FRAGS segments.
> > + * Only give a boost to drivers using page frag(s) to hold the frame(s),
> > + * and if no payload was pulled in skb->head before reaching us.
> > + */
> > +static u32 truesize_adjust(bool adjust, const struct sk_buff *skb)
> > +{
> > +       u32 truesize = skb->truesize;
> > +
> > +       if (adjust && !skb_headlen(skb)) {
> > +               truesize -= SKB_TRUESIZE(skb_end_offset(skb));
> > +               /* paranoid check, some drivers might be buggy */
> > +               if (unlikely((int)truesize < (int)skb->len))
> > +                       truesize = skb->truesize;
> > +       }
> > +       return truesize;
> > +}
> > +
> > +static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb,
> > +                           bool adjust)
> >  {
> >         struct tcp_sock *tp = tcp_sk(sk);
> >         int room;
> > @@ -480,15 +501,16 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
> >
> >         /* Check #1 */
> >         if (room > 0 && !tcp_under_memory_pressure(sk)) {
> > +               unsigned int truesize = truesize_adjust(adjust, skb);
> >                 int incr;
> >
> >                 /* Check #2. Increase window, if skb with such overhead
> >                  * will fit to rcvbuf in future.
> >                  */
> > -               if (tcp_win_from_space(sk, skb->truesize) <= skb->len)
> > +               if (tcp_win_from_space(sk, truesize) <= skb->len)
> >                         incr = 2 * tp->advmss;
> >                 else
> > -                       incr = __tcp_grow_window(sk, skb);
> > +                       incr = __tcp_grow_window(sk, skb, truesize);
> >
> >                 if (incr) {
> >                         incr = max_t(int, incr, 2 * skb->len);
> > @@ -782,7 +804,7 @@ static void tcp_event_data_recv(struct sock *sk, struct sk_buff *skb)
> >         tcp_ecn_check_ce(sk, skb);
> >
> >         if (skb->len >= 128)
> > -               tcp_grow_window(sk, skb);
> > +               tcp_grow_window(sk, skb, true);
> >  }
> >
> >  /* Called to compute a smoothed rtt estimate. The data fed to this
> > @@ -4769,7 +4791,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
> >                  * and trigger fast retransmit.
> >                  */
> >                 if (tcp_is_sack(tp))
> > -                       tcp_grow_window(sk, skb);
> > +                       tcp_grow_window(sk, skb, true);
> >                 kfree_skb_partial(skb, fragstolen);
> >                 skb = NULL;
> >                 goto add_sack;
> > @@ -4857,7 +4879,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
> >                  * and trigger fast retransmit.
> >                  */
> >                 if (tcp_is_sack(tp))
> > -                       tcp_grow_window(sk, skb);
> > +                       tcp_grow_window(sk, skb, false);
> >                 skb_condense(skb);
> >                 skb_set_owner_r(skb, sk);
> >         }
> > --
> > 2.32.0.402.g57bb445576-goog
> >
