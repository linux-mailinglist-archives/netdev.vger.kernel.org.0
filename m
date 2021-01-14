Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE712F6F27
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbhANX4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731040AbhANX4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:56:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 405C823356;
        Thu, 14 Jan 2021 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610668523;
        bh=+UDf1VuTxcx0O3kFj8ek2bxtWAkjVs/EfjwDj85SFzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C/zcKlQukXgOu8Cn71onNcTdNR119n1DJzBDYNB+IkB9E8vblwfjK/R5ypwnDeB39
         eUwW8pcd6f/gHRHN1QkD+wrRUiABybGcQE0NeDqURV+xoN9n9IvjuAee+qD0cM2/w8
         POxVit6svynREDVc3xj2SxRTHlg6a97XBUjjVIEquQeQ7+lMRgZvv6UTB6XFptglX9
         i3Pf7agq5E3wbNsB4TO9qsFgjq+Qia9wqyK4mNhvUZb1QaPZox0JtFakxPc3CguzEd
         x4Y/HYSdfCSWhDa9SY3tN0YSaS4tmZESFXpr44OHinZM4fVEKk4zF/4YQp7duxqxs2
         /u5fCTMVPZfaw==
Date:   Fri, 15 Jan 2021 00:55:16 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        lkp@intel.com, davem@davemloft.net, ashkan.boldaji@digi.com,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: do not allow inband AN for
 2500base-x mode
Message-ID: <20210115005516.03f0f772@kernel.org>
In-Reply-To: <YADNEWkiPQX34Tyo@lunn.ch>
References: <20210114024055.17602-1-kabel@kernel.org>
        <YADNEWkiPQX34Tyo@lunn.ch>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 00:00:33 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> > index 3195936dc5be..b8241820679e 100644
> > --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> > +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> > @@ -55,9 +55,20 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
> >  {
> >  	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
> >  		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
> > +
> > +		if (state->interface == PHY_INTERFACE_MODE_2500BASEX) {
> > +			if (state->link) {
> > +				state->speed = SPEED_2500;
> > +				state->duplex = DUPLEX_FULL;
> > +			}
> > +
> > +			return 0;
> > +		}
> > +
> > +		state->an_complete = 1;  
> 
> Should this be here? It seems like a logically different change, it is
> not clear to me it is to do with PHY_INTERFACE_MODE_2500BASEX.

This function does not set an_complete at all, and as I understand it,
it should. But maybe this should be in different commit, and more
thought put into it. I will rethink it and send another version.

> >  		state->duplex = status &
> >  				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
> > -			                         DUPLEX_FULL : DUPLEX_HALF;
> > +						DUPLEX_FULL : DUPLEX_HALF;  
> 
> This looks like an unintended white space change.

This change is intended. There were 17 space there istead of 2 tabs + 1
space. And the last space is not needed, since it does not provide any
other alignment. Should this be in separate commit?

BTW Andrew, the code in serdes.c does many read and write calls, and it
could be simplified a lot by implementing modify, setbits and clearbits
methods, like phy.h implements. Or maybe we can use phy_mmd_* methods
here instead of mv88e6390_serdes_read/write ?

I fear such change will make future backporting of new fix commits
a pain. But I still think it should be done. What do you think?

Marek
