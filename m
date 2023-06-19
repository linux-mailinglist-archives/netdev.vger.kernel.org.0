Return-Path: <netdev+bounces-12076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7F7735E91
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA07280FDF
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4620F3D7C;
	Mon, 19 Jun 2023 20:34:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDADD537
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCFFC433C0;
	Mon, 19 Jun 2023 20:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687206873;
	bh=It+wktZKuA6vjVox70vxEs1gipZh9JTFgLsapasfn0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/ls0awfy7I//ClSjHn8RKOeVahX8hd1nheY8GXsoRCFNh6aC2GO/sX8KI1RaR3Ou
	 FamiqOeBEtOnpGMtyicv1Tah5lg10y5oXDYE8MCtp6hh1BcXRQttAhRqycUNagalQA
	 1mOH5EjYLlP6Wy8PT9LkobbQ780JCT0IuDQq9/d8qdey7gEeUiEkBtiJKkSCTVzf0z
	 JHsqteqB0pWP38AZzQ04H4mgh2yZQW+fL62GyuAaljR2lX5GVMTl0R8wjvg7r4Lx9L
	 coVb2Hh57UPs3JY4YRYN0uYgHIfA/Rq7MAgZUiwUB68ECpp/36G6QkVF7qu0UYeuZK
	 tUZFfY+4RrG9g==
Date: Mon, 19 Jun 2023 22:34:30 +0200
From: Simon Horman <horms@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Simon Horman <simon.horman@corigine.com>, Andrew Lunn <andrew@lunn.ch>,
	netdev <netdev@vger.kernel.org>, ansuelsmth@gmail.com,
	Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v0 2/3] net: phy: phy_device: Call into the PHY
 driver to set LED offload
Message-ID: <ZJC71i4YFMCYOrti@kernel.org>
References: <20230618173937.4016322-1-andrew@lunn.ch>
 <20230618173937.4016322-2-andrew@lunn.ch>
 <ZJBjtWTtDqsyWPXE@corigine.com>
 <ZJCaODPt5cJVZqTf@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJCaODPt5cJVZqTf@shell.armlinux.org.uk>

On Mon, Jun 19, 2023 at 07:11:04PM +0100, Russell King (Oracle) wrote:
> On Mon, Jun 19, 2023 at 04:18:29PM +0200, Simon Horman wrote:
> > On Sun, Jun 18, 2023 at 07:39:36PM +0200, Andrew Lunn wrote:
> > > Linux LEDs can be requested to perform hardware accelerated blinking
> > > to indicate link, RX, TX etc. Pass the rules for blinking to the PHY
> > > driver, if it implements the ops needed to determine if a given
> > > pattern can be offloaded, to offload it, and what the current offload
> > > is. Additionally implement the op needed to get what device the LED is
> > > for.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > ...
> > 
> > > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > > index 11c1e91563d4..1db63fb905c5 100644
> > > --- a/include/linux/phy.h
> > > +++ b/include/linux/phy.h
> > > @@ -1104,6 +1104,20 @@ struct phy_driver {
> > >  	int (*led_blink_set)(struct phy_device *dev, u8 index,
> > >  			     unsigned long *delay_on,
> > >  			     unsigned long *delay_off);
> > > +	/* Can the HW support the given rules. Return 0 if yes,
> > > +	 * -EOPNOTSUPP if not, or an error code.
> > > +	 */
> > > +	int (*led_hw_is_supported)(struct phy_device *dev, u8 index,
> > > +				   unsigned long rules);
> > > +	/* Set the HW to control the LED as described by rules. */
> > > +	int (*led_hw_control_set)(struct phy_device *dev, u8 index,
> > > +				  unsigned long rules);
> > > +	/* Get the rules used to describe how the HW is currently
> > > +	 * configure.
> > > +	 */
> > > +	int (*led_hw_control_get)(struct phy_device *dev, u8 index,
> > > +				  unsigned long *rules);
> > > +
> > 
> > Hi Andrew,
> > 
> > for consistency it would be nice if the comments for
> > the new members above was in kernel doc format.
> 
> Unfortunately, kerneldoc doesn't understand structures-of-function-
> pointers, so one can't document each operation and its parameters
> without playing games such as I've done in linux/phylink.h. It involves
> listing the prototypes not as function pointers but as normal function
> prototypes in a #if 0..#endif section and preceeding each with a
> kerneldoc comment describing the function and its parameters in the
> normal way.

Ok. I'll confess that I wasn't aware of that problem.
But could we use one of the approaches approach already taken
for existing members of this structure?

e.g.:

        /**
         * @led_blink_set: Set a PHY LED brightness.  Index indicates
         * which of the PHYs led should be configured to blink. Delays
         * are in milliseconds and if both are zero then a sensible
         * default should be chosen.  The call should adjust the
         * timings in that case and if it can't match the values
         * specified exactly.
         */
        int (*led_blink_set)(struct phy_device *dev, u8 index,
                             unsigned long *delay_on,
                             unsigned long *delay_off);

Or the more minimalist approach:

        /** @get_plca_status: Return the current PLCA status info */
        int (*get_plca_status)(struct phy_device *dev,
                               struct phy_plca_status *plca_st);

I was going to say to be consistent. But the above aren't consistent with
each other.  I guess that I feel something is better than nothing.  But if
you think otherwise then let's let it rest.

