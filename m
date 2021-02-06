Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91E631208B
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBFX7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFX7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:59:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F17064E54;
        Sat,  6 Feb 2021 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612655938;
        bh=1rj+jy4S56LJr5Fp6OQGaPqhjd7IcwpsdGIi32P2Qnc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bazbhkEJN6SOpf+iHoKPyR6EiPt7L9U7THgDfNmoHAogKLcH8Efl9drciFwBZnCk1
         cXV0FDrh2nhNoNEoA7cY/jZQCNoNpqY8uNznrEAoq0z4KzdgcWFJSrWp4/Pnw+AB4F
         W2vt6ezEQ3r9rQppqEXH43fewfW+4FXROSe4tWFs5MSDJTUF5knLuVo7bhen4UH2c8
         Hj1MtEO45k8fHjseAe3oH376qyIUlCg7IpKMVHMmPZxeytpePwfJLKoRpriv9zoUma
         ImW0++bJToxb/6Nt3lnYwq+K19KamIzfA16my1kbD4i0iQlqoR4vYWGV+lZH6x+JBK
         4WKL0ZB8ak8aQ==
Date:   Sat, 6 Feb 2021 15:58:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: allow port mirroring towards foreign
 interfaces
Message-ID: <20210206155857.1d983d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205230521.s2eb2alw5pkqqafv@skbuf>
References: <20210205223355.298049-1-olteanv@gmail.com>
        <fead6d2a-3455-785a-a367-974c2e6efdf3@gmail.com>
        <20210205230521.s2eb2alw5pkqqafv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 01:05:21 +0200 Vladimir Oltean wrote:
> On Fri, Feb 05, 2021 at 02:42:55PM -0800, Florian Fainelli wrote:
> > How does the mirred action deal with that case? How does it know that
> > packets delivered to the DSA master should be sent towards a foreign
> > address, do I need to set-up two mirred rules? One that set-ups the
> > filter on say sw0p0 to redirect egress to eth0 (DSA master) and another
> > one to ingress filter on eth0 and egress mirror to eth1 (USB ethernet
> > dongle)?  
> 
> [ I should have posted this as RFC, somebody asked me if it's possible,
>   I only tested ingress mirroring, saw something come out, and posted this.
>   I didn't even study act_mirred.c to see why I got anything at all ]

Let me mark it as RFC, then :)

> For ingress mirroring there should be nothing special about the mirror
> packets, it's just more traffic in the ingress data path where the qdisc
> hook already exists.

For ingress the only possible corner case seems to be if the filter has
SKIP_SW set, then HW will send to CPU but SW will ignore.

That's assuming the frame still comes on the CPU appropriately tagged.

> For egress mirroring I don't think there's really any way for the mirred
> action to take over the packets from what is basically the ingress qdisc
> and into the egress qdisc of the DSA interface such that they will be
> redirected to the selected mirror. I hadn't even thought about egress
> mirroring. I suppose with more API, we could have DSA do introspection
> into the frame header, see it's an egress-mirrored packet, and inject it
> into the egress qdisc of the net device instead of doing netif_rx.

IMHO it's not very pretty but FWIW some "SmartNIC" drivers already do
a similar thing. But to be clear that's just an optimization, right?
The SW should still be able to re-process and come to the same
decisions as the switch, provided SKIP_SW was not set?

> The idea with 2 mirrors might work however it's not amazing and I was
> thinking that if we bother to do something at all, we could as well try
> to think it through and come up with something that's seamless for the
> user.
