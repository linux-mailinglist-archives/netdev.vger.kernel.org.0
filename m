Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1344962F5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378773AbiAUQha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378589AbiAUQhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:37:25 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEFBC061744
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:37:24 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id c6so29171645ybk.3
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRw3c2nTcxpf7XFAr5fDNjcxYint58apP77JYrgfibE=;
        b=YbuwxpWXzChtGfQL0yLMa5wL24jazyFMecXUoio8ZzQy070dgCO7p+49DtmJKLUUfv
         e/YBLegpdIrg7nPOzDtJll65faRExM3O+pc9bts2D7Nx7ND7nlyMzPGFnbVUKDdJiNos
         LgPPxmcb5wjT/em/dmqE0sdEyJ04LYBZcXIJmSTZmNGxjfob7T3eF7Z+VIpzrJN3S+/h
         SZjaQKvd585b37QxFEHqS1mA3nZsEjTb9ntv03WF7Qs96HIteDwF8ltpuBdnnlNohnCU
         RCRHyH8lciMqpZpGnKiITPczKkFAPX+t8cycYGcuvgz9PDUKt9zGmsmcl6I87IC9tBb9
         gKtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRw3c2nTcxpf7XFAr5fDNjcxYint58apP77JYrgfibE=;
        b=zzDVTOp+IfjVqR7bN3qNV8JHsrmkuUiV7JdaS1SjxaU+W2BqdjlmfArmZMO7nUSKX3
         kMkasNZsyXMVWOS3EZNy+nRFGqMOTSCeigJVK8Hr6AHTJT/zNjwSooAwSsEeKPGKDgp6
         3wZz6wRqfCavd3xv5SXP7t6ZAbN8Rhfeyi0aqg8g/CcrH1veUFmUwp7RmfCos/+lA3n+
         hchWfydvB/IBP5R1vhdCg9HDsAUBN4kFGkMUsJpHdpqUCAm0tS+m3ZcVZBVxFvHHl+hN
         KZaBKCp3soKji474bQkoKC0ZCu73+PRJ1deTxEDj3TNEr+nTB3ot9AebCLtiW24aAYHy
         6o+g==
X-Gm-Message-State: AOAM531iaJPle4F+m2b26HVEX081YGlJtBgyp+Ak6T4uQW3bWf0sVKS5
        /zHKAeCZFNYTcvG4cszNO6AJ5L7DzurBP8MSneyIJA==
X-Google-Smtp-Source: ABdhPJwu2WGePbqeYOkPmC42scDR/CiQFgc8GAwU9djrfe5Wz0YKcZXAtKLMMdaaJ3LTMWJeTcScBQ24B2QDKc3VPxo=
X-Received: by 2002:a5b:506:: with SMTP id o6mr7474719ybp.156.1642783043712;
 Fri, 21 Jan 2022 08:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20220121011941.1123392-1-kuba@kernel.org> <CANn89iKBchKPeumrdWVOf9onjM2qBm1D5_2CUToi57C+CEwoJw@mail.gmail.com>
 <20220121071514.4e80f880@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220121071514.4e80f880@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Jan 2022 08:37:12 -0800
Message-ID: <CANn89iJY=oDHY+Fe=u+GHeb07LCUC305rwLehsE2Wq1TcidP8Q@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: gro: flush instead of assuming different flows
 on hop_limit mismatch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 21, 2022 at 7:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 21 Jan 2022 00:55:08 -0800 Eric Dumazet wrote:
> > On Thu, Jan 20, 2022 at 5:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > IPv6 GRO considers packets to belong to different flows when their
> > > hop_limit is different. This seems counter-intuitive, the flow is
> > > the same. hop_limit may vary because of various bugs or hacks but
> > > that doesn't mean it's okay for GRO to reorder packets.
> > >
> > > Practical impact of this problem on overall TCP performance
> > > is unclear, but TCP itself detects this reordering and bumps
> > > TCPSACKReorder resulting in user complaints.
> > >
> > > Note that the code plays an easy to miss trick by upcasting next_hdr
> > > to a u16 pointer and compares next_hdr and hop_limit in one go.
> > > Coalesce the flush setting to reduce the instruction count a touch.
> >
> > There are downsides to this change.
> >
> > We had an internal discussion at Google years ago about this
> > difference in behavior of IPv6/IPv4
> >
> > We came to the conclusion the IPv6 behavior was better for our needs
> > (and we do not care
> > much about IPv4 GRO, since Google DC traffic is 99.99% IPv6)
> >
> > In our case, we wanted to keep this 'ipv6 feature' because we were
> > experimenting with the idea of sending
> > TSO packets with different flowlabels, to use different paths in the
> > network, to increase nominal
> > throughput for WAN flows (one flow would use multiple fiber links)
> >
> > The issue with 'ipv4 gro style about ttl mismatch' was that because of
> > small differences in RTT for each path,
> >  a receiver could very well receive mixed packets.
> >
> > Even without playing with ECMP hashes, this scenario can happen if the sender
> > uses a bonding device in balance-rr mode.
> >
> > After your change, GRO would be defeated and deliver one MSS at a time
> > to TCP stack.
>
> Indeed. Sounds like we're trading correctness for an optimization of a
> questionable practical application, but our motivation isn't 100% pure
> either [1] so whatever way we can fix this is fine by me :)
>
> [1] We have some shenanigans that bump TTL to indicate re-transmitted
> packets so we can identify them in the network.
>
> > We implemented SACK compress in TCP stack to avoid extra SACK being
> > sent by the receiver
> >
> > We have an extension of this SACK compression for TCP flows terminated
> > by Google servers,
> > since modern TCP stacks do not need the old rule of TCP_FASTRETRANS_THRESH
> > DUPACK to start retransmits.
> >
> > Something like this pseudo code:
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index dc49a3d551eb919baf5ad812ef21698c5c7b9679..d72554ab70fd2e16ed60dc78a905f4aa1414f8c9
> > 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5494,7 +5494,8 @@ static void __tcp_ack_snd_check(struct sock *sk,
> > int ofo_possible)
> >         }
> >         if (tp->dup_ack_counter < TCP_FASTRETRANS_THRESH) {
> >                 tp->dup_ack_counter++;
> > -               goto send_now;
> > +               if (peer_is_using_old_rule_about_fastretrans(tp))
> > +                       goto send_now;
> >         }
> >         tp->compressed_ack++;
> >         if (hrtimer_is_queued(&tp->compressed_ack_timer))
> >
>
> Is this something we could upstream / test? peer_is_using.. does not
> exist upstream.

Sure, because we do not have a standardized way (at SYN SYNACK time)
to advertise
that the stack is not 10 years old.

This could be a per net-ns sysctl, or a per socket flag, or a per cgroup flag.

In our case, we do negotiate special TCP options, and allow these options
only from internal communications.

(So we store this private bit in the socket itself)

>
>
> Coincidentally, speaking of sending SACKs, my initial testing was on
> 5.12 kernels and there I saw what appeared to a lay person (me) like
> missing ACKs. Receiver would receive segments:
>
> _AB_C_D_E
>
> where _ indicates loss. It'd SACK A, then generate the next SACK after E
> (SACKing C D E), sender would rexmit A which makes receiver ACK all
> the way to the end of B. Now sender thinks B arrived after CDE because
> it was never sacked.
>
> Perhaps it was fixed by commit a29cb6914681 ("net: tcp better handling
> of reordering then loss cases").. or it's a result of some out-of-tree
> hack. I thought I'd mention it tho in case it immediately rings a bell
> for anyone.

Could all the missing SACK have been lost ?

Writing a packetdrill test for this scenario should not be too hard.
