Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967A52B9F63
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgKTAky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKTAky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:40:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F50C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YcEcxsCh+VnQE7uf1Lr/R8Djeq9Fmug7soMO6/vBKD0=; b=DYKrEhx7SjOD3kXYPTjZ7aU0s
        ZEX2Pcb5iEhRgEsCfrt6IlumNEhcOIjGCskFOYoPTMFRj/ezZbAPBO9iSTnYWAu+ul3Loy4FXqv8Q
        vNOij0Xf0c6H3fCqkvrdBzmhiq3iEP0nLa0qoeITXceu1yPPZCHeXY7XNEwN0epIKLABDAgpMtJW5
        7SzEHuifUa3sE75x/SufetUzLfjHSel/9KDZUZQ4YQsgO0wxAMN54kwrai8A2yS5C/+hBBsOHPWhz
        mtRxIbjGKLanc2n21KS762fbsmIngL8FJAXxpqJ6LfcVw2V1FEKecQF16oJyA66W0MWB/b+AXUUdd
        XDR1K/4OA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33610)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kfuTq-0002us-D8; Fri, 20 Nov 2020 00:40:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kfuTo-0002bm-Vb; Fri, 20 Nov 2020 00:40:48 +0000
Date:   Fri, 20 Nov 2020 00:40:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120004048.GO1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com>
 <20201119145500.GL1551@shell.armlinux.org.uk>
 <20201119162451.4c8d220d@bootlin.com>
 <87k0uh9dd0.fsf@waldekranz.com>
 <20201119231613.GN1551@shell.armlinux.org.uk>
 <87eekoanvj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eekoanvj.fsf@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 01:11:12AM +0100, Tobias Waldekranz wrote:
> On Thu, Nov 19, 2020 at 23:16, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > On Thu, Nov 19, 2020 at 11:43:39PM +0100, Tobias Waldekranz wrote:
> >> On Thu, Nov 19, 2020 at 16:24, Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:
> >> > I don't think we have a way to distinguish from the DT if we are in
> >> > SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
> >> > the same, we don't have any information in DT about wether or not the
> >> > PHY is wired to a Copper RJ45 port.
> >> >
> >> > Maybe we should have a way to indicate if a PHY is wired to a Copper
> >> > port in DT ?
> >> 
> >> Do you mean something like:
> >> 
> >> SGMII->SGMII (Fibre):
> >> ethernet-phy@0 {
> >>    sfp = <&sfp0>;
> >> };
> >> 
> >> SGMII->MDI (Copper):
> >> ethernet-phy@0 {
> >>     mdi;
> >> };
> >> 
> >> SGMII->Auto Media Detect
> >> ethernet-phy@0 {
> >>     mdi;
> >>     sfp = <&sfp0>;
> >> };
> >
> > This isn't something we could realistically do - think about how many
> > DT files are out there today which would not have this for an existing
> > PHY. The default has to be that today's DT descriptions continue to work
> > as-is, and that includes ones which already support copper and fibre
> > either with or without a sfp property.
> >
> > So, we can't draw any conclusion about whether the fiber interface is
> > wired from whether there is a sfp property or not.
> >
> > We also can't draw a conclusion about whether the copper side is wired
> > using a "mdi" property, or whether there is a "sfp" property or not.
> >
> > The only thing we could realistically do today is to introduce a
> > property like:
> >
> > 	mdi = "disabled" | "okay";
> >
> > to indicate whether the copper port can be used, and maybe something
> > similar for the fiber interface.  Maybe as you suggest, not "okay"
> > but specifying the number of connected pairs would be a good idea,
> > or maybe that should be a separate property?
> 
> Maybe you could have optional media nodes under the PHY instead, so that
> you don't involve the SFP property in the logic (SGMII can be connected
> to lots of things after all):

I think you're advocating calling the fiber interface "SGMII", which
would be totally wrong.

SGMII is a Cisco modification of 802.3 1000base-X to allow 10M and 100M
speeds to be used over a single serdes lane in each direction.

1000base-X is what you run over a fiber link. This is not SGMII. Using
"SGMII" for 1000base-X is incorrect, but a common abuse of the term in
industry. Abusing a term does not make it correct, especially when it
comes to defining further standards.

(This is one of my pet peaves, sorry.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
