Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0E132B3C8
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835457AbhCCEGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376701AbhCBUxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 15:53:37 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8295EC06178A
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 12:52:54 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d15so6093946wrv.5
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 12:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wREP2F1ta4aY9hShQDZuaOuJoZqB/7Qc1JkJE18SelQ=;
        b=AfGpuyqr6FcO4wIn10druzCKNA6V6UY0SeRq57wuugd2XsJsw7dq5rB++ef4r4AGib
         X1M7ID5wGs8L1JxCmo2f5wNFi+/BhxgkOpnMN15PKutSZI+Bjn+MPxBew2b8fNfKG9Fd
         ZPDpHfY47aiCp9djMkS+6qRot9NcRHLKmU09zy7fY9CdxIZDclijvIEMXnKmnjg6lRUV
         TXZQxtIdQ8ogjHn4jsfVAYMtpIFvFaVds693sdKdrgidw1nqXPJuCvKNTkCUZgIQavca
         u8VUgHSAgkfUv/q7f/6SxV40Rkevuwd168dQhr6tN6euCxaa8ONnm10xpxT0i+iZbsZO
         p09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wREP2F1ta4aY9hShQDZuaOuJoZqB/7Qc1JkJE18SelQ=;
        b=mDAVToMS9ku6+0y0KwobnbMtJ3eZP12ZdjnB7n4dNN6zVHUT9f81lC2IFlTc7zNMRX
         eEpv/wGWO/esYIarU59XF9BQyDgosLojPJexI8xW1iL5EhywS6MBxTr+OLjguivEgOCE
         FXbqT6gtgLvK5y8ZJxDe+Q+kxebIKPFxdrApWEDFI8Fl9Q5l73cg8JF7QO/FFN7ONyTI
         SLRoYQYz+5/Fe5lC2FJxVVqaSHBoXHwvO5E2QXDxmkXL6THeC3g8xe9H2z6jhSvAa/4t
         OY1GmzRMTAX93Yp1AuWj/iyf5XYwm6FXNlqM3GPJtmI4uXsN6YcxZ48l1nP0nBWaPjMN
         Hong==
X-Gm-Message-State: AOAM530TH02RHLQDYW3m0TTUthudjYYxeQ9LoUjP9dhwvrPHa2nqgnT8
        gcYOb/NhkqMdKveETjf32XctjwPcdWVbvr+wI/elxQ==
X-Google-Smtp-Source: ABdhPJzld/0xVPnE6SkFzvncucCBEsKp3W1vYfEhS8sX+9JAXD3i0u83HzkWEHjwVB7OVuVskRzP9Gx43croa30X0rg=
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr14788204wrp.118.1614718373080;
 Tue, 02 Mar 2021 12:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
In-Reply-To: <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 2 Mar 2021 12:52:14 -0800
Message-ID: <CAK6E8=fL7HP3ObOrUtR=UbR5ZrCDjc0qQ-t7cD9oUMorWFsKwg@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 11:58 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > When receiver does not accept TCP Fast Open it will only ack
> > the SYN, and not the data. We detect this and immediately queue
> > the data for (re)transmission in tcp_rcv_fastopen_synack().
> >
> > In DC networks with very low RTT and without RFS the SYN-ACK
> > may arrive before NIC driver reported Tx completion on
> > the original SYN. In which case skb_still_in_host_queue()
> > returns true and sender will need to wait for the retransmission
> > timer to fire milliseconds later.
> >
> > Revert back to non-fast clone skbs, this way
> > skb_still_in_host_queue() won't prevent the recovery flow
> > from completing.
> >
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
>
> Hmmm, not sure if this Fixes: tag makes sense.
>
> Really, if we delay TX completions by say 10 ms, other parts of the
> stack will misbehave anyway.
>
> Also, backporting this patch up to linux-3.19 is going to be tricky.
>
> The real issue here is that skb_still_in_host_queue() can give a false positive.
>
> I have mixed feelings here, as you can read my answer :/
>
> Maybe skb_still_in_host_queue() signal should not be used when a part
> of the SKB has been received/acknowledged by the remote peer
> (in this case the SYN part).
Thank you Eric and Jakub for working on the TFO issue.

I like this option the most because it's more generic and easy to understand. Is
it easy to implement by checking snd_una etc?




>
> Alternative is that drivers unable to TX complete their skbs in a
> reasonable time should call skb_orphan()
>  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
>
> If you really want to play and delay TX completions, maybe provide a
> way to disable skb_still_in_host_queue() globally,
> using a static key ?
>
> My personal WIP/hack was something like :
>
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 69a545db80d2ead47ffcf2f3819a6d066e95f35d..666f6f0a6a06fece204199e07a79e21d1faf8f92
> 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5995,7 +5995,8 @@ static bool tcp_rcv_fastopen_synack(struct sock
> *sk, struct sk_buff *synack,
>                 else
>                         tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
>                 skb_rbtree_walk_from(data) {
> -                       if (__tcp_retransmit_skb(sk, data, 1))
> +                       /* segs = -1 to bypass
> skb_still_in_host_queue() check */
> +                       if (__tcp_retransmit_skb(sk, data, -1))
>                                 break;
>                 }
>                 tcp_rearm_rto(sk);
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index fbf140a770d8e21b936369b79abbe9857537acd8..1d1489e596976e352fe7d5ccee7a6eae55fdbcce
> 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3155,8 +3155,12 @@ int __tcp_retransmit_skb(struct sock *sk,
> struct sk_buff *skb, int segs)
>                   sk->sk_sndbuf))
>                 return -EAGAIN;
>
> -       if (skb_still_in_host_queue(sk, skb))
> -               return -EBUSY;
> +       if (segs > 0) {
> +               if (skb_still_in_host_queue(sk, skb))
> +                       return -EBUSY;
> +       } else {
> +               segs = -segs;
> +       }
>
>         if (before(TCP_SKB_CB(skb)->seq, tp->snd_una)) {
>                 if (unlikely(before(TCP_SKB_CB(skb)->end_seq, tp->snd_una))) {
>
>
> > Signed-off-by: Neil Spring <ntspring@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/ipv4/tcp_output.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index fbf140a770d8..cd9461588539 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -3759,9 +3759,16 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
> >         /* limit to order-0 allocations */
> >         space = min_t(size_t, space, SKB_MAX_HEAD(MAX_TCP_HEADER));
> >
> > -       syn_data = sk_stream_alloc_skb(sk, space, sk->sk_allocation, false);
> > +       syn_data = alloc_skb(MAX_TCP_HEADER + space, sk->sk_allocation);
> >         if (!syn_data)
> >                 goto fallback;
> > +       if (!sk_wmem_schedule(sk, syn_data->truesize)) {
> > +               __kfree_skb(syn_data);
> > +               goto fallback;
> > +       }
> > +       skb_reserve(syn_data, MAX_TCP_HEADER);
> > +       INIT_LIST_HEAD(&syn_data->tcp_tsorted_anchor);
> > +
> >         syn_data->ip_summed = CHECKSUM_PARTIAL;
> >         memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
> >         if (space) {
> > --
> > 2.26.2
> >
