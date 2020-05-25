Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4D01E0AF2
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389607AbgEYJpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 05:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389333AbgEYJpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 05:45:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DB5C061A0E;
        Mon, 25 May 2020 02:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3bACHP/iXQB5QepDjM2EEIvav5CoPo/q4qnp/hrIGzA=; b=Y9HnJnaI/t+3UiP3Fjrk+7Aam
        wUXPN9RAY8XMQC64F7dkhR1KWMVsoTts1DdUL+JaE12D/JOgMZgLS8XyNVVbKW7oHK4H67EyzsiK5
        iDTk2BtJbLNCieC024X7146iSUhFh7m942L422Dk6c9ip+0zcwTe15K4+j+qOMCz8CjKOkawgrqCb
        AOr0Ey2R9b/gdI4TqpFLIS4dOxbIaHpJK3YOwiATeUsC6PZwx2y8SIwpn5AwzXi+B0sSrlFlyrPUt
        5PW4IkIfraWeJDlcRu/n7qzHhGPeQuvlNMR/M7v3KdqQV/sFVr7gpxWiCpsW1iO1vC2jbu1pG+43c
        JGGbrGj6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36734)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd9fy-0004sg-GE; Mon, 25 May 2020 10:45:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd9fs-0004GD-Fs; Mon, 25 May 2020 10:45:36 +0100
Date:   Mon, 25 May 2020 10:45:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/11] net: phy: Don't report success if devices weren't
 found
Message-ID: <20200525094536.GK1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-2-jeremy.linton@arm.com>
 <20200523182054.GW1551@shell.armlinux.org.uk>
 <e6e08ca4-5a6d-5ea3-0f97-946f1d403568@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6e08ca4-5a6d-5ea3-0f97-946f1d403568@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 09:46:55PM -0500, Jeremy Linton wrote:
> Hi,
> 
> Thanks for taking a look at this.
> 
> On 5/23/20 1:20 PM, Russell King - ARM Linux admin wrote:
> > On Fri, May 22, 2020 at 04:30:49PM -0500, Jeremy Linton wrote:
> > > C45 devices are to return 0 for registers they haven't
> > > implemented. This means in theory we can terminate the
> > > device search loop without finding any MMDs. In that
> > > case we want to immediately return indicating that
> > > nothing was found rather than continuing to probe
> > > and falling into the success state at the bottom.
> > 
> > This is a little confusing when you read this comment:
> > 
> >                          /*  If mostly Fs, there is no device there,
> >                           *  then let's continue to probe more, as some
> >                           *  10G PHYs have zero Devices In package,
> >                           *  e.g. Cortina CS4315/CS4340 PHY.
> >                           */
> > 
> > Since it appears to be talking about the case of a PHY where *devs will
> > be zero.  However, tracking down the original submission, it seems this
> > is not the case at all, and the comment is grossly misleading.
> > 
> > It seems these PHYs only report a valid data in the Devices In Package
> > registers for devad=0 - it has nothing to do with a zero Devices In
> > Package.
> 
> Yes, this ended up being my understanding of this commit, and is part of my
> justification for starting the devices search at the reserved address 0
> rather than 1.
> 
> > 
> > Can I suggest that this comment is fixed while we're changing the code
> > to explicitly reject this "zero Devices In package" so that it's not
> > confusing?
> 
> Its probably better to kill it in 5/11 with a mention that we are starting
> at a reserved address?
> 
> OTOH, I'm a bit concerned that reading at 0 as the first address will cause
> problems because the original code was only triggering it after a read
> returning 0xFFFFFFFF at a valid MMD address. It does simplify/clarify the
> loop though. If it weren't for this 0 read, I would have tried to avoid some
> of the additional MMD reserved addresses.

Yes, that is the worry, and as MMD 0 is marked as reserved, I don't
think we should routinely probe it.

As I've already mentioned, note that bit 0 of devices-in-package does
not mean that there is a MMD 0 implemented, even if bit 0 is set.  Bit
0 means that the clause 22 register set is available through clause 22
cycles.  So, simplifying the loop to start at 0 and removing the work-
around could end up breaking Cortina PHYs if they don't set bit 0 in
their devices in package - but I don't see why we should depend on bit 0
being set for their workaround.

So, I think you're going to have to add a work-around to ignore bit 0,
which brings up the question whether this is worth it or not.

Hence, I think this is a "simplifcation" too far.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
