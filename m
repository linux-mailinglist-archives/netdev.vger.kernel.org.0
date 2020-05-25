Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1933C1E08A7
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbgEYIUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731393AbgEYIUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:20:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72AC061A0E;
        Mon, 25 May 2020 01:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xrmvJaWubnjFTpNiW+zE/kAk/rWAsR9PlwlUmAPBcSU=; b=kWTq3gFZnpgr6eUomTw3dMoHl
        cfqphxbxiOM2PfHvnCr8j11lD1wq6Mxm0AatdALSkB8Wxmiese4dLnuzMjezkwAX4fuweFuQHDr2I
        C2L3UZBce3zO9vsD7wWchhcuma5yWSjgj1H8JLmsWfyTCBrKQ6QbpxqGVwRh6AFGc3x9UfG2nTKmg
        VAmifAT58HEzpxYcJTqcN9CDTQu4IxAtvYrKtInHJE0B4igfAydo8YJLHQO6dVSPHTgXq8hZiTAQr
        8HEBol4nOehjb/wnD44vnPWbgLSlZWAJirBJiNM3/UVEjnqlze0XG0yVRdIKNtIN+YSifjO3oQxLG
        xvKEb17lA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36700)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jd8Lm-0004h6-MG; Mon, 25 May 2020 09:20:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jd8Ll-0004CK-Dt; Mon, 25 May 2020 09:20:45 +0100
Date:   Mon, 25 May 2020 09:20:45 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/11] net: phy: reset invalid phy reads of 0 back to
 0xffffffff
Message-ID: <20200525082045.GG1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-8-jeremy.linton@arm.com>
 <20200523184459.GA1551@shell.armlinux.org.uk>
 <d6d71908-58a0-96c9-b046-9a4739cc7bcd@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6d71908-58a0-96c9-b046-9a4739cc7bcd@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 11:20:01PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/23/20 1:44 PM, Russell King - ARM Linux admin wrote:
> > On Fri, May 22, 2020 at 04:30:55PM -0500, Jeremy Linton wrote:
> > > MMD's in the device list sometimes return 0 for their id.
> > > When that happens lets reset the id back to 0xfffffff so
> > > that we don't get a stub device created for it.
> > > 
> > > This is a questionable commit, but i'm tossing it out
> > > there along with the comment that reading the spec
> > > seems to indicate that maybe there are further registers
> > > that could be probed in an attempt to resolve some futher
> > > "bad" phys. It sort of comes down to do we want unused phy
> > > devices floating around (potentially unmatched in dt) or
> > > do we want to cut them off early and let DT create them
> > > directly.
> > 
> > I'm not sure what you mean "stub device" or "unused phy devices
> > floating around" - the individual MMDs are not treated as separate
> > "phy devices", but as one PHY device as a whole.
> > 
> 
> Well, I guess its clearer to say phy/mmd devices with a phy_id=0. Which is a
> problem if we don't have DT overriding the phy_id for a given address.
> Although AFAIK given a couple of the /sys/bus/mdio_bus/devices lists I've
> seen, and after studying this code for a while now, I think "bogus" phy's
> might be getting created*. I was far to easy, to upset the cart when I was
> hacking on this set, and end up with a directory chuck full of phys.
> 
> So this gets close to one of the questions I asked in the cover letter. This
> patch and 09/11 serve to cut off possibly valid phy's which are failing to
> identify themselves using the standard registers. Which per the 802.3 spec
> there is a blurb about 0 in the id registers for some cases. Its not really
> a critical problem for ACPI machines to have these phys around (OTOH, there
> might be issues with c22 phys on c45 electrical buses that respond to c45
> reg requests but don't set the c22 regs flag, I haven't seen that yet.).

If you have a classical clause 22 PHY on a clause 45 bus, it isn't
going to respond to clause 45 cycles, so it isn't going to respond to
a request to read the devices-in-package register, so there is no
"c22 regs" flag.

> I
> considered dropping this patch, and 9/11 was a last minute addition. I kept
> it because I was worried all those extra "reserved" MMDs would end up with
> id = 0's in there and break something.
> 
> * In places where there isn't actually a phy, likely a large part of the
> problem was clearing the c22 bit, which allowed 0xFFFFFFFF returns to slip
> through the devices list.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
