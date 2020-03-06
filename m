Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1912617B2E1
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCFA1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:27:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgCFA1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 19:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8ejlDEybagNTsW8N9uArf6A+6DevL9wHepboFJQ9c7o=; b=0tCB1z/xO39mFVsNjgzyMWVqvy
        jOAzLe9tUsoOxbXDavzMiufjlKC/qgkjtGYuavT9ekSkbIOLdIsUlGM5v12FWm4FbxDF+pzxUA6UA
        SJ7S+D8st70ZjCo7CgsmXnsM5duuFXn6J5D4Gfli6XNi7Yv+xHyB0IxHqK703zd7AOXk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jA0pt-0000uV-7M; Fri, 06 Mar 2020 01:27:29 +0100
Date:   Fri, 6 Mar 2020 01:27:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306002729.GA2450@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305234557.GE25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 11:45:57PM +0000, Russell King - ARM Linux admin wrote:
> On Thu, Mar 05, 2020 at 11:54:07PM +0100, Andrew Lunn wrote:
> > On Thu, Mar 05, 2020 at 12:41:39PM +0000, Russell King - ARM Linux admin wrote:
> > > Andrew Lunn mentioned that the Serdes PCS found in Marvell DSA switches
> > > does not automatically update the switch MACs with the link parameters.
> > > Currently, the DSA code implements a work-around for this.
> > > 
> > > This series improves the Serdes integration, making use of the recent
> > > phylink changes to support split MAC/PCS setups.  One noticable
> > > improvement for userspace is that ethtool can now report the link
> > > partner's advertisement.
> > 
> > Hi Russel
> > 
> > I started testing this patchset today. But ran into issues with ZII
> > scu4-aib and ZII devel c. I think the CPU port is running at the wrong
> > speed, but i'm not sure yet. Nor do i know if it is this patchset, or
> > something earlier.
> 
> It could be this patch set; remember the integration of phylink into
> DSA for CPU and inter-switch ports is already broken, particularly
> for links that do not specify any fixed-link properties.
> 
> For ZII platforms, the fixed link parameters are specified, so this
> should not be the case.

Hi Russell

I think phylink integration for DSA for CPU ports is partly to
blame. I was testing with a port which required working DSA links.
devel C does not have fixed links for the DSA ports.

However, SCU4-AIB i was testing with does have fixed links everywhere.
Yet this also fails.

> FYI, the port status and control register for the CPU port on the
> ZII rev C should be:
> 
> 0 = 0xd04
> 1 = 0x203d

Yes, that is part of the funny thing. I see 0xe04 for 0. But 1 seems
correct. The data sheet also suggests when the port is forced, the
values in 0 don't reflect the actual values. However, in the good
case, i do have 0xd04.

I need to separate out breakage from CPU/DSA integration and possible
breakage from this patchset. I'm now testing using a copper port on
the first switch, so eliminating a DSA link.

    Andrew
