Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126141D3561
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgENPlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 11:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbgENPlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 11:41:20 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FE9C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:41:18 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id o7so24926868oif.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 08:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=awnbTGIXklZW5yvjH8VDoOTQPbPwhwX3A7OQXsPfVhg=;
        b=v1RSwKpggRq/fTuogA9mjrs3n10qTzDDgLPZFV/1/YoT/VPlWividnhNPI+b7RwQvY
         rOZ9fgs51tj9CdSbPIFtc3oTrDmFvLYzvcZTEzjjEh4DhO/WHjmh6xCDi5a34AwGyX2A
         IqdDRZmjqk+lSR2cp41Sn8k0JM923C2PwN3vk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=awnbTGIXklZW5yvjH8VDoOTQPbPwhwX3A7OQXsPfVhg=;
        b=hRcsxhXjHMtjM/l7W4WBk7i8N3fC41/N72M5LcwWqcayTiIq8QlTML8Hon89yeBVTF
         dshvsihEc6kk0uf+ZrD7UoNllY+eT9YOCIIsso0KnjBbbme7BjHzaLjBgkkmNZ6z3eoQ
         IjSFOKnNf9jlsXuXW+BvpwO5VmAuP/rSaOOXkBSyBhRrBBaGD1S398/m0I0rDMkKk+qF
         A7/TDb8joejjgWXRNIrF03gTnr0yhyOrV/Y4TcQlZVHvzKk+vaWh8OvfZ31R9B/y12fG
         K4IhcVwYO9L5O3+3PFav3rQble1w0/UoEmJJzwrtLKtSqgRLSQ0T485MqqEwkTgT+JT+
         pixQ==
X-Gm-Message-State: AGi0PubAF10zpYBPodgGIZwTVnbmT7hK3F+r70QOUUeL8UejSS9JWZfe
        0dK+Kc95bM0wP8CpOzKoGgCNim4mf9X/4N5H7Zgtwg==
X-Google-Smtp-Source: APiQypJ9C/9yTZ7jmSDKZFJKGmkA7cJwCOpUNjz2n2qFFWqYcaXk6ZO9YLZSPDlM4S1Dam4aFoIbch5Z+41LO3FSoFY=
X-Received: by 2002:aca:c441:: with SMTP id u62mr32257615oif.110.1589470877832;
 Thu, 14 May 2020 08:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <CACAyw9_4Uzh0GqAR16BfEHQ0ZWHKGUKacOQwwhwsfhdCTMtsNQ@mail.gmail.com>
 <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
In-Reply-To: <b93b4ad2-0cf0-81e0-b2b0-664248b3630f@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 14 May 2020 16:41:06 +0100
Message-ID: <CACAyw9-95He2yq0qoxuWFy3wqQt1kAtAQcRw2UTrqse2hUq1tA@mail.gmail.com>
Subject: Re: "Forwarding" from TC classifier
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 at 18:48, David Ahern <dsahern@gmail.com> wrote:
>
> On 5/13/20 10:40 AM, Lorenz Bauer wrote:
> > We've recently open sourced a key component of our L4 load balancer:
> > cls_redirect [1].
> > In the commit description, I call out the following caveat:
> >
> >     cls_redirect relies on receiving encapsulated packets directly
> > from a router. This is
> >     because we don't have access to the neighbour tables from BPF, yet.
>
> Can you explain more about this limitation? Why does access to neighbor
> tables solve the problem?

We want to forward the packet to another machine, based on an IP address
stored in our custom encapsulation header.
If we always receive packets from a router we can plug in the new IP, swap
the MAC and send the packet back to the router. Inefficient, but it means we
don't have to deal with MAC addresses ourselves.

I think I use the wrong terminology, sorry. By "access to the neighbour table"
I mean being able to go from IP to MAC address.

>
> >
> > The code in question lives in forward_to_next_hop() [2], and does the following:
> > 1. Swap source and destination MAC of the packet
> > 2. Update source and destination IP address
> > 3. Transmit the packet via bpf_redirect(skb->ifindex, 0)
> >
> > Really, I'd like to get rid of step 1, and instead rely on the network
> > stack to switch or route
> > the packet for me. The bpf_fib_lookup helper is very close to what I need. I've
> > hacked around a bit, and come up with the following replacement for step 1:
> >
> >     switch (bpf_fib_lookup(skb, &fib, sizeof(fib), 0)) {
> >     case BPF_FIB_LKUP_RET_SUCCESS:
> >         /* There is a cached neighbour, bpf_redirect without going
> > through the stack. */
> >         return bpf_redirect(...);
> >
> >     case BPF_FIB_LKUP_RET_NO_NEIGH:
> >         /* We have no information about this target. Let the stack handle it. */
> >         return TC_ACT_OK;
> >
> >     case BPF_FIB_LKUP_RET_FWD_DISABLED:
> >         return TC_ACT_SHOT;
> >
> >     default:
> >         return TC_ACT_SHOT;
> >     }
> >
> > I have a couple of questions:
> >
> > First, I think I can get BPF_FIB_LKUP_RET_NO_NEIGH if the packet needs
> > to be routed,
> > but there is no neighbour entry for the default gateway. Is that correct?
>
> Correct.
>
> >
> > Second, is it possible to originate the packet from the local machine,
> > instead of keeping
> > the original source address when passing the packet to the stack on NO_NEIGH?
>
> Network address or MAC address? Swapping the network address is not a
> usual part of routing a packet so I presume you mean mac but just making
> sure. Swapping mac addresses should be done for all routed packets.

No, I'd like to do network address swapping. The code already swaps MAC.
Basically, I'd like to pretend that I'm outputting a new packet.

Just setting the source network address and then doing TC_ACT_OK doesn't
work due to sysctl accept_local=0.

>
> > This is what I get with my current approach:
> >
> >   IP (tos 0x0, ttl 64, id 25769, offset 0, flags [DF], proto UDP (17),
> > length 124)
> >       10.42.0.2.37074 > 10.42.0.4.2483: [bad udp cksum 0x14d3 ->
> > 0x3c0d!] UDP, length 96
> >   IP (tos 0x0, ttl 63, id 25769, offset 0, flags [DF], proto UDP (17),
> > length 124)
> >       10.42.0.2.37074 > 10.42.0.3.2483: [no cksum] UDP, length 96
> >   IP (tos 0x0, ttl 64, id 51342, offset 0, flags [none], proto ICMP
> > (1), length 84)
> >       10.42.0.3 > 10.42.0.2: ICMP echo reply, id 33779, seq 0, length 64
> >
> > The first and second packet are using our custom GUE header, they
> > contain an ICMP echo request. Packet three contains the answer to the
> > request. As you can see, the second packet keeps the 10.42.0.2 source
> > address instead of using 10.42.0.4.
> >
> > Third, what effect does BPF_FIB_LOOKUP_OUTPUT have? Seems like I should set it,
> > but I get somewhat sensible results without it as well. Same for LOOKUP_DIRECT.
>
> BPF_FIB_LOOKUP_OUTPUT affects the flow parameters passed to the FIB lookup:
>         if (flags & BPF_FIB_LOOKUP_OUTPUT) {
>                 fl4.flowi4_iif = 1;
>                 fl4.flowi4_oif = params->ifindex;
>         } else {
>                 fl4.flowi4_iif = params->ifindex;
>                 fl4.flowi4_oif = 0;
>         }
>
> iif / oif set can have an influence on the FIB lookup result - e.g., FIB
> rules directing the lookup to a table or requiring the lookup result to
> use the specified device.
>
> Usually, 'output' is for locally generated traffic headed out. XDP
> programs run on ingress are from an Rx perspective and do the lookup
> from the perspective of 'is this forwarded or locally delivered'.

What if the XDP encapsulates the packet? At this point I know that I
want to forward it elsewhere. Would that use LOOKUP_OUTPUT?

Thanks!


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
