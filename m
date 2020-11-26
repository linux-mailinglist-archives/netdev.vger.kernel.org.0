Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4038A2C568E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389990AbgKZOBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:01:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389434AbgKZOBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 09:01:33 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiHpu-008ywQ-NC; Thu, 26 Nov 2020 15:01:26 +0100
Date:   Thu, 26 Nov 2020 15:01:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <20201126140126.GL2075216@lunn.ch>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-2-george.mccollister@gmail.com>
 <20201125203429.GF2073444@lunn.ch>
 <20201126135004.aq2lruz5kxptmsvl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126135004.aq2lruz5kxptmsvl@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 03:50:04PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 25, 2020 at 09:34:29PM +0100, Andrew Lunn wrote:
> > > +static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> > > +				   struct packet_type *pt)
> > > +{
> > > +	int source_port;
> > > +	u8 *trailer;
> > > +
> > > +	if (skb_linearize(skb))
> > > +		return NULL;
> >
> > Something for Vladimir:
> >
> > Could this linearise be moved into the core, depending on the
> > tail_tag?
> 
> Honestly I believe that the skb_linearize is not needed at all.

Humm

I'm assuming this is here in case the frame is in fragments, and the
trailer could be spread over two fragments? If so, you cannot access
the trailer using straight pointers. Linearize should copy it into one
buffer.

For the normal case of a 1500 byte frame, i doubt we have hardware
which uses multiple scatter/gather buffers. But for jumbo frames?

> > > +	if (pskb_trim_rcsum(skb, skb->len - 1))
> > > +		return NULL;
> >
> > And the overhead is also in dsa_devlink_ops, so maybe this can be
> > moved as well?
> 
> Sorry, I don't understand this comment.

I'm meaning, could that also be moved into the core? We seem to have
the needed information to do it in the core.

    Andrew
