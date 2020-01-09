Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8451135D44
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbgAIP6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:58:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54922 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbgAIP6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fx3RgaLQG8a7qGoeLN8LdchrvtPP+95Yqk6dq1XYDpQ=; b=rhYEWxFjsEVMwkcGHZMfEtYhf
        Dl7THTbVwGPHEfseOyvK9hECYscav6MLoITLj6BzJqyZT3pyMnViLzmbhLYaSt41Ye7ZsPbvH2WGc
        dV+CDhbMOvbmiuhUGNz/YE4OL+WDMT+lHEZCduYl9RG/jSJFAMSDm+QGm6/HEKWyZ6xodiuO9ORYz
        UeArmVZPBDrdVZBlbKva6uTlEehCN6QkI7XduGdi2P1tJYdh7cWPjvFngNjRFpPymUA76SbMJ80Fq
        ia6ylxsMrjOEIBoACXZ7yZE+d9i/sXTybZvOSkERqCt6iyg+zfCwc5bJlHDEF/SyR8YpVGAhUe1Yx
        RxIVC5O4A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60200)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipaCI-0005x5-Fn; Thu, 09 Jan 2020 15:58:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipaCH-0000cF-FD; Thu, 09 Jan 2020 15:58:09 +0000
Date:   Thu, 9 Jan 2020 15:58:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109155809.GQ25745@shell.armlinux.org.uk>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 03:03:24PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 09/01/2020 14:41, Andrew Lunn wrote:
> > On Thu, Jan 09, 2020 at 01:47:31PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > On node with 4.19.93 and a SFP module (specs at the bottom) the following is
> > > intermittently observed:
> > Please make sure Russell King is in Cc: for SFP issues.
> > 
> > The state machine has been reworked recently. Please could you try
> > net-next, or 5.5-rc5.
> > 
> > Thanks
> > 	Andrew
> Unfortunately testing those branches is not feasible since the router (see
> architecture below) that host the SFP module deploys the OpenWrt downstream
> distro with LTS kernels - in their Master development branch 4.19.93 being
> the most recent on offer.

I don't think the rework will make any difference in this case, and
I don't think there's anything failing in the software here.  The
reported problem seems to be this:

 sfp sfp: module transmit fault indicated
 sfp sfp: module transmit fault recovered
 sfp sfp: module transmit fault indicated
 sfp sfp: module persistently indicates fault, disabling

which occurs if the module asserts the TX_FAULT signal.  The SFP MSA
defines that this indicates a problem with the laser safety circuitry,
and defines a way to reset the fault (by pulsing TX_DISABLE and going
through another initialisation).

When TX_FAULT is asserted for the first time, "module transmit fault
indicated" is printed, and we start the process of recovery.  If we
successfully recover, then "module transmit fault recovered" will be
printed.

We try several times to recover the fault, and once we're out of
retries, "module persistently indicates fault, disabling" will be
printed; at that point, we've declared the module to be dead, and
we won't do anything further with it.

This is by design; if the module is saying that the laser safety
circuitry is faulty, then endlessly resetting the module to recover
from that fault is not sane.

However, there's some modules (particularly GPON modules) that do
things quite differently from what the SFP MSA says, which is
extremely annoying and frustrating for those of us who are trying to
implement the host support.  There are some which seem to assert
TX_FAULT for unknown reasons.

In your original post (which you need to have sent to me, I don't
read netdev) you've provided "SFP module specs" - not really, you
provided the ethtool output, which is not the same as the module
specs.  Many modules have misleading EEPROM information, sometimes
to work around what people call "vendor lockin" or maybe to get
their module to work in some specific equipment.  In any case,
EEPROM information is not a specification.

For example, your module claims to be a 1000BASE-SX module.  If
I lookup "allnet ALL4781", I find that it's a VDSL2 module.  That
isn't a 1000BASE-SX module - 1000BASE-SX is an IEEE 802.3 defined
term to mean 1000BASE-X over fiber using a short-wavelength laser.

So, given that it doesn't have a laser, why is it raising TX_FAULT.
No idea; these modules are a law to themselves.

I think the only thing we could do is to implement a workaround to
ignore TX_FAULT for this module... great, more quirks. :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
