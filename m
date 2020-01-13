Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62741139465
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 16:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgAMPJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 10:09:58 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34174 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgAMPJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 10:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dokAm0ED72qxDdCwVsdV+xDs6tBSBowsCaBP+8QEtGo=; b=xDaM+KTpWI3r0PYfS63CBdwPu
        SgfjCoYRIySSJVjrCJJShXN8AkjZesbpdMf8bNo5NrAcpIejqcn8rhtEFdzUfRcvxiy3eAdsk9XaK
        7nybwz2TJI19BfrDuZnw+fMcojTj4J1q+Z+VQKCNH7Dr+GZICy0/MfGmDyjufZX7JViyq2Vanjl19
        Zn0nTp5TApJKIqnWkysk5YRFUFpERCuPQbFzlnjcwri43xR3N3ApKEDIQJq6vOxP51/fZDsW8fq6f
        hY/HQwaAZszosRv/2YX0ty+41UyVWkUkioVeNsy970GQxnrTBMo2eslUHjbHrf4/La0XP8ehVMnzk
        S7619dN3Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33728)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ir1Li-00052a-2h; Mon, 13 Jan 2020 15:09:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ir1Le-0004Xb-Ox; Mon, 13 Jan 2020 15:09:46 +0000
Date:   Mon, 13 Jan 2020 15:09:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Message-ID: <20200113150946.GO25745@shell.armlinux.org.uk>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
 <CA+h21hqYeq_D5hLi8yssNko6ucNSVCFMQxqkvGcGxL86niu7pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqYeq_D5hLi8yssNko6ucNSVCFMQxqkvGcGxL86niu7pA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 04:50:18PM +0200, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Mon, 13 Jan 2020 at 16:19, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > I've recently suggested a patch to phylink to add a generic helper to
> > read the state from a generic 802.3 clause 37 PCS, but I guess that
> > won't be sufficient for an XPCS.  However, it should give some clues
> > if you're intending to use phylink.
> >
> 
> I don't think the PCS implementations out there are sufficiently
> similar to be driven by a unified driver, and at least nothing
> mandates that for now. Although the configuration interface is MDIO
> with registers quasi-compliant to C22 or C45, many times bits in
> BMCR/BMSR are not implemented, you can't typically achieve full
> functionality [ sometimes not at all ] without writing to some
> vendor-specific registers, there might be errata workarounds that need
> to be implemented through PCS writes, often the PCS driver needs to be
> correlated with a MMIO region corresponding to that SerDes lane for
> stuff such as eye parameters.
> The code duplication isn't even all that bad.

That's opinion.

The PCS register set is defined in 802.3, and there are at least two
implementations I've come across that are compliant. I suspect there
are many more that are also compliant out there.

> _But_ I am not sure how PHYLINK comes into play here. A PHY driver
> should work with the plain PHY library too. Dealing with clause 73
> autoneg indicates to me that this is more than just a MAC PCS,
> therefore it shouldn't be tied in with PHYLINK.

I think you're looking at this wrong, or you have a misunderstanding
of where phylink sits in this.

phylink is there to help deal with SFPs, and to manage the MAC side
of the link which *includes* the MAC PCS, and interface that to
either a PHY or a SFP.  phylink has always assumed right from day
one that it will be talking to the MAC _and_ MAC PCS.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
