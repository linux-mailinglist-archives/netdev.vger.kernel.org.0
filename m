Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDABCB0FE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbfJCVVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:21:45 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37843 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbfJCVVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:21:44 -0400
Received: by mail-ed1-f66.google.com with SMTP id r4so3982326edy.4
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/y5wVzJjjbl/Vn1Lr3gSHaAXMHhISRU05cnKzoEvpag=;
        b=E+5pxO9W3oNTUh1auqzsx+4w5rPmLvPQ0cwnhYE5qcOOMLwns5+Lizk5HO0la8qPPC
         rtqOuBFePv9Oe6AJw5yFVZJSJtmCYl6qT/FMO9vJJUpR+cEpQJ/4lJER3P+nyDTujIjL
         Ccg63UPI/7e8HgQHs+O2tSiqG0xZBmTMDJtu9whO9OSVbPCjLPjCJdUlKhHpKFq/Y3HV
         rZ09GpHo2wh2flmoWUWw6GQ9M0RCkiLl5KC5yyGx6PYFNpGMXz+dg9OIdDH8aS4dvTsC
         cLq00oHxrw2aHgqHXBCtyi/i4k+Tj88wToA47oU8QUaH3PQ8oiD4MXztKnUbwmlG980+
         o+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/y5wVzJjjbl/Vn1Lr3gSHaAXMHhISRU05cnKzoEvpag=;
        b=cf/R7Bxq+MrZc5BEg0VahuLp9Z2de8aQGG+QVDgsnI6ES+RXbP+3YiI27ZeM6Cu12g
         Oy2M6fPEVvKNgzFRQrH51D4BbsCTFiE0mVgOU9iW2RmnBNSBrgJyjGeL8gTeIAko3J81
         Tb42VPgRxuUG5SLn0jJPuT4vOhhmwdTShh+Zv1LPXFsaWE+kz7/L0KZxg09c7O5PVI6c
         T/sE+g53JodHTLUgBSuOdoWblmQCi/BU+PXrVzoTeZwZCRSJZWU/Ad2tmC39uZ+PG8AI
         d4+Lea+KFDf6Ys/vhxnhUjeaDjbvvMPE+5QDBPJvaHLfpCv8w9q6gGeWUvhXMbpmmkaI
         fzwQ==
X-Gm-Message-State: APjAAAWAlv64ZrGU5WDF1ouL/nXGm9voZ5Jc7FGmo6Lo52iDzqO51oTA
        7ahmAOuATnbiIwzv2ioGm3SV2LiSLF+JgbYquNHeVA==
X-Google-Smtp-Source: APXvYqx54H8FJpbEJJWaU/lmpDMeXqW1Bww/XDUwK3EKEdHP5JTdAzVdla9S5dYWOwhAakg0MeOeLYJ3J8gVsWuDYjY=
X-Received: by 2002:a50:eac4:: with SMTP id u4mr12068242edp.36.1570137701146;
 Thu, 03 Oct 2019 14:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20191002233750.13566-1-olteanv@gmail.com> <20191003192445.GD21875@lunn.ch>
In-Reply-To: <20191003192445.GD21875@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 4 Oct 2019 00:21:30 +0300
Message-ID: <CA+h21hrYvCaNLDbDFzU9LEjodJUnR01BNV=CFwF8DNJqU33hYw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: Allow port mirroring to the CPU port
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 at 22:24, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Oct 03, 2019 at 02:37:50AM +0300, Vladimir Oltean wrote:
> > On a regular netdev, putting it in promiscuous mode means receiving all
> > traffic passing through it, whether or not it was destined to its MAC
> > address. Then monitoring applications such as tcpdump can see all
> > traffic transiting it.
> >
> > On Ethernet switches, clearly all ports are in promiscuous mode by
> > definition, since they accept frames destined to any MAC address.
> > However tcpdump does not capture all frames transiting switch ports,
> > only the ones destined to, or originating from the CPU port.
> >
> > To be able to monitor frames with tcpdump on the CPU port, extend the tc
> > matchall classifier and mirred action to support the DSA master port as
> > a possible mirror target.
> >
> > Tested with:
> > tc qdisc add dev swp2 clsact
> > tc filter add dev swp2 ingress matchall skip_sw \
> >       action mirred egress mirror dev eth2
> > tcpdump -i swp2
>
> Humm.
>
> O.K, i don't like this for a few reasons.
>
> egress mirror dev eth2
>
> Frames are supported to egress eth2. But in fact they will ingress on
> eth2. That is not intuitive.
>

But you are just arguing that the tc mirred syntax is confusing.
'ingress'/'egress' has nothing to do with 'eth2'. You just specify the
direction of the frames transiting swp2 that you want to capture. And
the destination port, as a net device. Because there is no net device
for the CPU port, 'eth2' acts as substitute. Florian's br0 could have
acted as substitute as well, but then there may not be a br0...
But that is only to fit the existing tc mirred command pattern. I'm
not using 'tcpdump -i eth2' to capture the mirrored traffic, but still
'tcpdump -i swp2'.

> I'm also no sure how safe this it is to ingress mirror packets on the
> master interface. Will they have DSA tags? I think that will vary from

Generally speaking, I would say that a device which does not push DSA
tags towards the CPU port is broken. Yes, I know, I don't need to be
reminded about cc1939e4b3aa ("net: dsa: Allow drivers to filter
packets they can decode source port from").
But there might be other exceptions too: maybe some switches support
cascaded setups, but don't stack DSA tags, and they need an awareness
of the switches beneath them, case in which it's reasonable for them
not to push a second tag. But then it isn't possible to enable port
mirroring on a DSA port anyway, due to lack of both net devices in
this case.

> device to device. Are we going to see some packets twice? Once for the
> mirror, and a second time because they are destined to the CPU? Do we
> end up processing the packets twice?
>

Does it matter?
FWIW, my device does not duplicate frames which already had the CPU in
the destination ports mask. But you will, nonetheless, see as
duplicated the frames transmitted from the CPU towards a port with
egress mirroring enabled towards the CPU. But then you could just keep
only ingress mirroring enabled, if that bothered you.

> For your use case of wanting to see packets in tcpdump, i think we are
> back to the discussion of what promisc mode means. I would prefer that
> when a DSA slave interface is put into promisc mode for tcpdump, the
> switch then forwards a copy of frames to the CPU, without
> duplication. That is a much more intuitive model.
>

So I'm not disagreeing that the patch I'm proposing isn't very
intuitive. But I think the reasons you pointed out are not the real
ones why.
I would like to see DSA switch net devices (and not only) as
'offloaded net devices', some of the traffic not reaching the CPU for
whatever reason. And have a switch to copy the offloaded traffic
towards the CPU as well. Then it would not matter that it's DSA or
switchdev or capable of offloaded IP routing or promiscuous or
whatever.
Would I want that switch to get flipped by default by the driver when
I run tcpdump? Not so sure. I mean there are already switches like
'--monitor-mode' in tcpdump specifically for Wi-Fi, so it's not as
though users who want to 'see everything' aren't able to understand a
new concept (in this case an 'offloaded net device').
And piggybacking on top of the promiscuity concept maybe isn't the
most intuitive way to get this solved either: you can already be
promiscuous and still not 'see everything'. And there's a second
reason too: mirroring (or copy-to-cpu) in many devices is a lot more
configurable than promiscuity is. Even 'dumb' devices like sja1105
support port-based mirroring and flow-based mirroring (classification
done at least by {DMAC, VLAN} keys), configured separately for the RX
and TX direction of each port. I suppose you want the driver to just
enable something really simple, like egress and ingress port-based
mirroring? Maybe that is less useful in a real debugging scenario than
just copying what you're interested in.
And this slowly glides towards the idea that if there's already this
much degree of configurability in what you want to mirror, then maybe
it doesn't make much sense at all in even having that switch put in
tcpdump (where it would only be something trivial, if not implicit),
and not in a more dedicated place for this kind of stuff, like tc.
Maybe the discussion should be about how to represent traffic destined
towards the CPU in a more abstract way in the tc mirred command?

>           Andrew

Thanks,
-Vladimir
