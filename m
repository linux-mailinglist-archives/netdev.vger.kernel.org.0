Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409652A7FD6
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbgKENpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 08:45:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgKENpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 08:45:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kafZg-005Pek-EM; Thu, 05 Nov 2020 14:45:12 +0100
Date:   Thu, 5 Nov 2020 14:45:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201105134512.GJ933237@lunn.ch>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
 <20201105010439.GH933237@lunn.ch>
 <20201105082557.c43odnzis35y7khj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105082557.c43odnzis35y7khj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Where is the TX confirm which uses this stored pointer. I don't see it
> > in this file.
> > 
> 
> The Tx confirm - dpaa2_switch_tx_conf() - is added in patch 5/9.

Not so obvious. Could it be moved here?

> > It can be expensive to store pointer like this in buffers used for
> > DMA.
> 
> Yes, it is. But the hardware does not give us any other indication that
> a packet was actually sent so that we can move ahead with consuming the
> initial skb.
> 
> > It has to be flushed out of the cache here as part of the
> > send. Then the TX complete needs to invalidate and then read it back
> > into the cache. Or you use coherent memory which is just slow.
> > 
> > It can be cheaper to keep a parallel ring in cacheable memory which
> > never gets flushed.
> 
> I'm afraid I don't really understand your suggestion. In this parallel
> ring I would keep the skb pointers of all frames which are in-flight?
> Then, when a packet is received on the Tx confirmation queue I would
> have to loop over the parallel ring and determine somehow which skb was
> this packet initially associated to. Isn't this even more expensive?

I don't know this particular hardware, so i will talk in general
terms. Generally, you have a transmit ring. You add new frames to be
sent to the beginning of the ring, and you take off completed frames
from the end of the ring. This is kept in 'expensive' memory, in that
either it is coherent, or you need to do flushed/invalidates.

It is expected that the hardware keeps to ring order. It does not pick
and choose which frames it sends, it does them in order. That means
completion also happens in ring order. So the driver can keep a simple
linear array the size of the ring, in cachable memory, with pointers
to the skbuf. And it just needs a counting index to know which one
just completed.

Now, your hardware is more complex. You have one queue feeding
multiple switch ports. Maybe it does not keep to ring order? If you
have one port running at 10M/Half, and another at 10G/Full, does it
leave frames for the 10/Half port in the ring when its egress queue it
full? That is probably a bad idea, since the 10G/Full port could then
starve for lack of free slots in the ring? So my guess would be, the
frames get dropped. And so ring order is maintained.

If you are paranoid it could get out of sync, keep an array of tuples,
address of the frame descriptor and the skbuf. If the fd address does
not match what you expect, then do the linear search of the fd
address, and increment a counter that something odd has happened.

	 Andrew
