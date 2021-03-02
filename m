Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0970A32B39B
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449841AbhCCED5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379047AbhCBRBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 12:01:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C896664F32;
        Tue,  2 Mar 2021 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614704404;
        bh=3H77ZwdQEknCdRjOurVXlNwCZCw2PYsL741DgUaTbBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GiZun7bB6n29O9ovPC11ZXfRbhdwyDjEVCmhDk2R+/JggqjG0LipzeK1pNBLttrvq
         +6mTKAkLhki0kIHNECxo6qY2dfgnEd3ci3Hl+o3g7ybhYfsGtJEq/Iohqd45ti8ZLP
         kwlsKHICKx4IvEZXgd1i03aplENQvIdL/Cn2v+wjHJQi0GPsAtKG7fjj/1DCw3hO+X
         QQ1RemqhexCud6/yw/Nj0YIOili/pV/6dx2TMw27LAaXU6kCtiNjM2Wo97jIaSmV1N
         ps9uFY74o9IziG+9bxYYysgQ1iU4Xkj3ai5/DmhhroeBJXMH2yRVCvo1ipzOBVa+uv
         O55q3T07vHxEQ==
Date:   Tue, 2 Mar 2021 09:00:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen
 SYN
Message-ID: <20210302090003.78664c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
References: <20210302060753.953931-1-kuba@kernel.org>
        <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 10:38:46 +0100 Eric Dumazet wrote:
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

Indeed, the problem is minor in practical terms. Maybe it's enough if I
spell that out more in the description? Are you thinking net-next or
net without a Fixes tag?

> The real issue here is that skb_still_in_host_queue() can give a false positive.
> 
> I have mixed feelings here, as you can read my answer :/
> 
> Maybe skb_still_in_host_queue() signal should not be used when a part
> of the SKB has been received/acknowledged by the remote peer
> (in this case the SYN part).

FWIW I was pondering this, when the rtx is requested by the receiver
we are relatively sure we can ignore skb_still_in_host_queue() because
we know our system should Tx in order so if receiver saw N + 1, N can't
be in our queues.

But AFAICT generalizing the test doesn't matter much. In cases other
than TFO worst case a loss probe will chase the rtx out. And I don't
grasp enough of TCP to implement the general optimization :)

> Alternative is that drivers unable to TX complete their skbs in a
> reasonable time should call skb_orphan()
>  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
> 
> If you really want to play and delay TX completions, maybe provide a
> way to disable skb_still_in_host_queue() globally,
> using a static key ?

I see the TFO issue with rx and tx completions set to 33us both, 
with two different NIC vendors, so the timing just influences the
likelihood.

> My personal WIP/hack was something like :

LGTM, are you happy with that being the fix?

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

