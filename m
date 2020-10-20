Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2922129333F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 04:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgJTCkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 22:40:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbgJTCkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 22:40:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUhZA-002aty-Sb; Tue, 20 Oct 2020 04:40:00 +0200
Date:   Tue, 20 Oct 2020 04:40:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     Chris Heally <cphealy@gmail.com>, netdev@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20201020024000.GV456889@lunn.ch>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 12:14:04PM +1000, Greg Ungerer wrote:
> Hi Andrew,
> 
> Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt driven
> MDIO with polled IO") breaks the FEC driver on at least one of
> the ColdFire platforms (the 5208). Maybe others, that is all I have
> tested on so far.
> 
> Specifically the driver no longer finds any PHY devices when it probes
> the MDIO bus at kernel start time.
> 
> I have pinned the problem down to this one specific change in this commit:
> 
> > @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct platform_device *pdev)
> >  	if (suppress_preamble)
> >  		fep->phy_speed |= BIT(7);
> > +	/* Clear MMFR to avoid to generate MII event by writing MSCR.
> > +	 * MII event generation condition:
> > +	 * - writing MSCR:
> > +	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
> > +	 *	  mscr_reg_data_in[7:0] != 0
> > +	 * - writing MMFR:
> > +	 *	- mscr[7:0]_not_zero
> > +	 */
> > +	writel(0, fep->hwp + FEC_MII_DATA);
> 
> At least by removing this I get the old behavior back and everything works
> as it did before.
> 
> With that write of the FEC_MII_DATA register in place it seems that
> subsequent MDIO operations return immediately (that is FEC_IEVENT is
> set) - even though it is obvious the MDIO transaction has not completed yet.
> 
> Any ideas?

Hi Greg

This has come up before, but the discussion fizzled out without a
final patch fixing the issue. NXP suggested this

writel(0, fep->hwp + FEC_MII_DATA);

Without it, some other FEC variants break because they do generate an
interrupt at the wrong time causing all following MDIO transactions to
fail.

At the moment, we don't seem to have a clear understanding of the
different FEC versions, and how their MDIO implementations vary.

	  Andrew
