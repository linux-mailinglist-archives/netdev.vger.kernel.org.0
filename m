Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593421CEF00
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgELIWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgELIWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:22:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D220EC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 01:22:19 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYQB0-0005YY-Sn; Tue, 12 May 2020 10:22:10 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYQAr-0004sc-3z; Tue, 12 May 2020 10:22:01 +0200
Date:   Tue, 12 May 2020 10:22:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: signal quality and cable diagnostic
Message-ID: <20200512082201.GB16536@pengutronix.de>
References: <20200511141310.GA2543@pengutronix.de>
 <20200511143337.GC413878@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200511143337.GC413878@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:49:14 up 243 days, 19:37, 460 users,  load average: 12.55,
 13.30, 14.42
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 04:33:37PM +0200, Andrew Lunn wrote:
> On Mon, May 11, 2020 at 04:13:10PM +0200, Oleksij Rempel wrote:
> > Hi Andrew,
> > 
> > First of all, great work! As your cable diagnostic patches are in
> > net-next now and can be used as base for the follow-up discussion.
> > 
> > Do you already have ethtool patches somewhere? :=) Can you please give a
> > link for testing?
> 
> Hi Oleksij
> 
> It was mentioned in the cover note
> 
> https://github.com/lunn/ethtool/tree/feature/cable-test-v4
> 
> > 
> > I continue to work on TJA11xx PHY and need to export some additional
> > cable diagnostic/link stability information: Signal Quality Index (SQI).
> 
> Is this something you want to continually make available, or just as
> part of cable diagnostics. Additional nested attributes can be added
> to the cable test results structure, and the user space code just
> dumps whatever it finds. So it should be easy to have something like:
> 
> Pair A: OK
> Pair A: Signal Quality Index class D

At least for automotive, avionics, (rockets till it is deployed :D)
etc... the cable integrity will probably not change, except we have some
sudden water infiltration into the cable, etc :)

However the SQI will probably change on a much shorter timescales, e.g.
crosstalk from other T1 links or EMI from motors, radio transceivers,
etc... We could sample this information during cable test, but also
provide an interface to sample this information later during normal
operation.

The NXP phy additionally offers the possibility to specify a warning
threshold for the SQI, to generate a warning interrupt. There is a
configurable fault threshold, too. However the spec doesn't mention
this. If needed (in the future), polling for SQI in the kernel would be
easier to implement if the PHY doesn't support interrupts.

According to the IEEE802.3bw paper we expect following noise sources:
================================================================================
a) Echo from the local transmitter on the same cable pair, is caused by
the hybrid function for bidirectional data transmission in the
BroadR-Reach duplex channel and by the impedance discontinuities in the
link segment. Echo cancellation techniques, up to each PHY implementer,
shall be used to achieve the objective BER level.

b) The typical background noise is mainly due to thermal noise.  Thermal
noise, with level roughly at -140 dBm/Hz, is not a critical contributor
that would impact performance. BroadR- Reach signaling allows a robust
margin over a 15m UTP channel to combat thermal noise.

c) There is no FEXT or NEXT as BroadR-Reach is a one pair solution. When
multiple cable pairs are bundled, the alien XTALK (NEXT/FEXT) become
interference sources.  Since the transmitted symbols from the alien
noise source in one cable are not available to another cable,
cancellation cannot be done.  When there are multiple pairs of UTP
cables bundled together, where all pairs carry 100 Mb/s links, then each
duplex link is disturbed by neighboring links, degrading the signal
quality on the victim pair.
================================================================================

according to the "c", I would expect worst SQI as soon as communication
will start on other bundled cable pairs.

When it comes to SQI the NXP data sheet and the opensig spec gives us:

https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
SQI=0 | worse then A | unstable link  |
SQI=1 | Class A      | unstable link  |
SQI=2 | Class B      | unstable link  |
SQI=3 | Class C      | good link      |
SQI=4 | Class D      | good link      | BER < 10^-10
SQI=5 | Class E      | good link      |
SQI=6 | Class F      | very good link |
SQI=7 | Class G      | very good link |

http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
SQI=0 |             < 18dB | 
SQI=1 | 18dB <= SNR < 19dB | BER > 10^-10
SQI=2 | 19dB <= SNR < 20dB |
------+--------------------+--------------
SQI=3 | 20dB <= SNR < 21dB |
SQI=4 | 21dB <= SNR < 22dB | BER < 10^-10
SQI=5 | 22dB <= SNR < 23dB |
SQI=6 | 23dB <= SNR < 24dB |
SQI=7 | 24dB <= SNR        |

So I think we should pass raw SQI value to user space, at least in the
first implementation.

What do you think about this?

> Are the classes part of the Open Alliance specification? Ideally we
> want to report something standardized, not something proprietary to
> NXP.
> 
> 	Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
