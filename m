Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE2312098
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGAoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:44:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBGAoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:44:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5135764E89;
        Sun,  7 Feb 2021 00:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612658600;
        bh=yY7qfnSRAFCCi6LMat1keB9FyvYc27s2mI8Z0xVmisU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B+bJm4lT83R+7tK7NWGDgvVK0hCua5RJHwo1tifBcBjRKXoru4XK+sIrgHXA54Z03
         qT8SsWvml3I2U9nd91UI6TDsfl5kKLmL74C0fR4MUCbEtldpiM/S7I6ut9FKj1u8f3
         KFWiMNlKyP72ZkPaMmaaahDObfiVUgqDgqV75VQegnuMto6diLWWnme3AOd9d+/fDK
         p20fTvMSsCEpmKZFl0tlRBBkZmu63hdmGVWQBKdMOM1FAtdCCjPGnA277iQjBYK6MS
         OV+ILahpkSfon+qyWTYAtuU2JdnEb3Y29anN/HWPf0vmGGhYtixU3iTDtyRkWWJDD2
         qZTCg1PRtIjhg==
Date:   Sat, 6 Feb 2021 16:43:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: allow port mirroring towards foreign
 interfaces
Message-ID: <20210206164319.4120ce73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210207001617.p3ohj754mi5vrydb@skbuf>
References: <20210205223355.298049-1-olteanv@gmail.com>
        <fead6d2a-3455-785a-a367-974c2e6efdf3@gmail.com>
        <20210205230521.s2eb2alw5pkqqafv@skbuf>
        <20210206155857.1d983d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207001617.p3ohj754mi5vrydb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Feb 2021 02:16:17 +0200 Vladimir Oltean wrote:
> On Sat, Feb 06, 2021 at 03:58:57PM -0800, Jakub Kicinski wrote:
> > > For ingress mirroring there should be nothing special about the mirror
> > > packets, it's just more traffic in the ingress data path where the qdisc
> > > hook already exists.  
> > 
> > For ingress the only possible corner case seems to be if the filter has
> > SKIP_SW set, then HW will send to CPU but SW will ignore.  
> 
> Correct, but I'm not sure if this requirement can be enforced at driver
> level though.

True, we'd need to add more info to struct flow_cls_common_offload.

> > That's assuming the frame still comes on the CPU appropriately tagged.  
> 
> For ingress mirroring I think the assumption that it does is reasonable,
> since the packet should be mirrored before the forwarding took place, it
> can only have one DSA tag and that would be the tag where the source
> port is the ingress port.
> For egress mirroring, software would need to see the mirrored packet as
> coming from the egress port, and this would mean that the source port in
> the DSA frame header would have to be equal to the egress port.
> 
> > > For egress mirroring I don't think there's really any way for the mirred
> > > action to take over the packets from what is basically the ingress qdisc
> > > and into the egress qdisc of the DSA interface such that they will be
> > > redirected to the selected mirror. I hadn't even thought about egress
> > > mirroring. I suppose with more API, we could have DSA do introspection
> > > into the frame header, see it's an egress-mirrored packet, and inject it
> > > into the egress qdisc of the net device instead of doing netif_rx.  
> > 
> > IMHO it's not very pretty but FWIW some "SmartNIC" drivers already do
> > a similar thing. But to be clear that's just an optimization, right?
> > The SW should still be able to re-process and come to the same
> > decisions as the switch, provided SKIP_SW was not set?  
> 
> I guess what would need to happen is that we'd need to do something like
> this, from the DSA tagging protocol files:
> 
> 	if (is_egress_mirror(skb)) {
> 		skb_get(skb);
> 		skb_push(skb, ETH_ALEN);
> 		skb = sch_handle_egress(skb, &err, skb->dev);
> 		if (skb)
> 			consume_skb(skb);
> 		return NULL;
> 	}
> 
> basically just run whatever tc filters there might be on that packet (in
> our case mirred), then discard it.
> 
> It's not an optimization thing. Egress mirrored traffic on a DSA switch
> is still ingress traffic from software's perspective, so it won't match
> on any mirred action on any egress qdisc. Only packets sent from the
> network stack would match the mirred egress mirror rule, however there
> might be lots of offloaded flows which don't.
> 
> Or I might just be misunderstanding.

Okay, that makes sense, sounds like we just can't expect the DSA tag 
with ingress port info preserved when frames are trapped at egress.
All depends on HW capabilities then.
