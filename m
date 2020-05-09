Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D6E1CBE69
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 09:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgEIHdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728625AbgEIHdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 03:33:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7757FC061A0C
        for <netdev@vger.kernel.org>; Sat,  9 May 2020 00:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=h+zkK0AP+yuAtI51LZ1qvVGlm7aYzOXHLUWK9RzDFK0=; b=vzyhZrqBlA0GasfbulocdZ6KK
        oUrbQXB03DYW53zCnzBZmWeOfy9bM4l57/3sRtRTQN/+17DKo07oInmggqnezzxh5AntAZ3HKqrBP
        VWeHgi/xW1bmg5g9e8/+dTKiUz8C4ePi+CGlrAdrMCRaBt481yAzH6TNRtfGbMsqU+BtEhZg9AIGr
        am4ijD3+1LU8WVyUmeF/bZVIiDl2o3pqrNlXTFazxZQAE6yYQy/MXefLy70GWiGIrVSfHsyXfkORQ
        fKPqFl8BTc9fG6UNnr4yfZ/hzBLpLehlwGm9kOPWaNGbGEc0BKyNfMqbGuT/WALbe+edEMoIvzb1q
        z5SxwWjrw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:55650)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jXJym-0003CI-I9; Sat, 09 May 2020 08:33:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jXJyi-0002dd-7F; Sat, 09 May 2020 08:32:56 +0100
Date:   Sat, 9 May 2020 08:32:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
Message-ID: <20200509073256.GZ1551@shell.armlinux.org.uk>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
 <20200414.164825.457585417402726076.davem@davemloft.net>
 <CAGnkfhw45WBjaYFcrO=vK0pbYvhzan970vtxVj8urexhh=WU_A@mail.gmail.com>
 <20200508213816.GY1551@shell.armlinux.org.uk>
 <20200509063631.GA1691791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509063631.GA1691791@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 08:36:31AM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 08, 2020 at 10:38:16PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, May 08, 2020 at 11:32:39PM +0200, Matteo Croce wrote:
> > > On Wed, Apr 15, 2020 at 1:48 AM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > > Date: Tue, 14 Apr 2020 20:47:53 +0100
> > > >
> > > > > This series fixes a problem with the 88x3310 PHY on Macchiatobin
> > > > > coming out of powersave mode noticed by Matteo Croce.  It seems
> > > > > that certain PHY firmwares do not properly exit powersave mode,
> > > > > resulting in a fibre link not coming up.
> > > > >
> > > > > The solution appears to be to soft-reset the PHY after clearing
> > > > > the powersave bit.
> > > > >
> > > > > We add support for reporting the PHY firmware version to the kernel
> > > > > log, and use it to trigger this new behaviour if we have v0.3.x.x
> > > > > or more recent firmware on the PHY.  This, however, is a guess as
> > > > > the firmware revision documentation does not mention this issue,
> > > > > and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
> > > > > later does not.
> > > >
> > > > Series applied, thanks.
> > > >
> > > 
> > > Hi,
> > > 
> > > should we queue this to -stable?
> > > The 10 gbit ports don't work without this fix.
> > 
> > It has a "Fixes:" tag, so it should be backported automatically.
> 
> That is a wild guess that it might happen sometime in the future.
> Please use the cc: stable@ tag as is documented for the past 15+ years
> instead of relying on us to randomly notice a Fixes: tag.

Not for netdev material.  Netdev has its own rules:

https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

Q: I see a network patch and I think it should be backported to stable.
   various stable releases?

A: Normally Greg Kroah-Hartman collects stable commits himself, but
   for networking, Dave collects up patches he deems critical for the
   networking subsystem, and then hands them off to Greg.
...

Q: I see a network patch and I think it should be backported to stable.
   Should I request it via "stable@vger.kernel.org" like the references in
   the kernel's Documentation/process/stable-kernel-rules.rst file say?

A: No, not for networking.  Check the stable queues as per above 1st to see
   if it is already queued.  If not, then send a mail to netdev, listing
   the upstream commit ID and why you think it should be a stable candidate.
...

Q: I have created a network patch and I think it should be backported to
   stable.  Should I add a "Cc: stable@vger.kernel.org" like the references
   in the kernel's Documentation/ directory say?

A: No.  See above answer.  In short, if you think it really belongs in
   stable, then ensure you write a decent commit log that describes who
   gets impacted by the bugfix and how it manifests itself, and when the
   bug was introduced.  If you do that properly, then the commit will
   get handled appropriately and most likely get put in the patchworks
   stable queue if it really warrants it.
...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
