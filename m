Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02342E7B43
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgL3Q6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:58:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgL3Q6m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 11:58:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08FAA207B0;
        Wed, 30 Dec 2020 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609347481;
        bh=WwsvJ6+e/U3mYbaKukuVwmTy/RvjFznh/gcnh5DFkAA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c/YF14HfGmC3vY5t5+qvfpHFUi4qDNyp4zeci0iTKy7oMh6lFC80YZ9GRWvLFxLdp
         Vqbev9I08rJgj+WNXKR5vaPUVuuEar7fWYW0jBqZMb+Q2914ZWt0WJ9ei1Fxa+kYGY
         qkhFqvGeRVDV/c8WaxOzOPsV1OFqJFGEeHhLcFR5mYQSdKJr9lehiF6L3oqCURGx4y
         wxEAJWf1YgPgUm0hcQjc8l/BSWfYliYlHlJlrknS9meJwAEm0I4+Kz35X2E1V8+nGa
         qInO3lBp17Oga6zBwRWOJ/kOUe8SF8mC4U2dOLplh5PrwFoMawhwXrQ6VjeXl6aTWF
         4A45k951w/umw==
Received: by pali.im (Postfix)
        id CE8C99F8; Wed, 30 Dec 2020 17:57:58 +0100 (CET)
Date:   Wed, 30 Dec 2020 17:57:58 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: sfp: assume that LOS is not implemented if both
 LOS normal and inverted is set
Message-ID: <20201230165758.jqezvxnl44cvvodw@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-4-pali@kernel.org>
 <20201230161310.GT1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230161310.GT1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 30 December 2020 16:13:10 Russell King - ARM Linux admin wrote:
> On Wed, Dec 30, 2020 at 04:47:54PM +0100, Pali Rohár wrote:
> > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > 
> > Such combination of bits is meaningless so assume that LOS signal is not
> > implemented.
> > 
> > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > 
> > Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> No, this is not co-developed. The patch content is exactly what _I_
> sent you, only the commit description is your own.

Sorry, in this case I misunderstood usage of this Co-developed-by tag.
I will remove it in next iteration of patches.

> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
> >  1 file changed, 22 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> > index 73f3ecf15260..d47485ed239c 100644
> > --- a/drivers/net/phy/sfp.c
> > +++ b/drivers/net/phy/sfp.c
> > @@ -1475,15 +1475,19 @@ static void sfp_sm_link_down(struct sfp *sfp)
> >  
> >  static void sfp_sm_link_check_los(struct sfp *sfp)
> >  {
> > -	unsigned int los = sfp->state & SFP_F_LOS;
> > +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> > +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> > +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> > +	bool los = false;
> >  
> >  	/* If neither SFP_OPTIONS_LOS_INVERTED nor SFP_OPTIONS_LOS_NORMAL
> > -	 * are set, we assume that no LOS signal is available.
> > +	 * are set, we assume that no LOS signal is available. If both are
> > +	 * set, we assume LOS is not implemented (and is meaningless.)
> >  	 */
> > -	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED))
> > -		los ^= SFP_F_LOS;
> > -	else if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL)))
> > -		los = 0;
> > +	if (los_options == los_inverted)
> > +		los = !(sfp->state & SFP_F_LOS);
> > +	else if (los_options == los_normal)
> > +		los = !!(sfp->state & SFP_F_LOS);
> >  
> >  	if (los)
> >  		sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
> > @@ -1493,18 +1497,22 @@ static void sfp_sm_link_check_los(struct sfp *sfp)
> >  
> >  static bool sfp_los_event_active(struct sfp *sfp, unsigned int event)
> >  {
> > -	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
> > -		event == SFP_E_LOS_LOW) ||
> > -	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
> > -		event == SFP_E_LOS_HIGH);
> > +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> > +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> > +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> > +
> > +	return (los_options == los_inverted && event == SFP_E_LOS_LOW) ||
> > +	       (los_options == los_normal && event == SFP_E_LOS_HIGH);
> >  }
> >  
> >  static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
> >  {
> > -	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
> > -		event == SFP_E_LOS_HIGH) ||
> > -	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
> > -		event == SFP_E_LOS_LOW);
> > +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> > +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> > +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> > +
> > +	return (los_options == los_inverted && event == SFP_E_LOS_HIGH) ||
> > +	       (los_options == los_normal && event == SFP_E_LOS_LOW);
> >  }
> >  
> >  static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
> > -- 
> > 2.20.1
> > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
