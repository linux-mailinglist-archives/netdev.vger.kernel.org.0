Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A340517779C
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgCCNpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:45:09 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35810 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgCCNpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0yup3mARE7euXRUrinjIYjaiwDrqny/kYWdlvrncAsM=; b=Ix1npxEPg/BN0E66WionUlpl8
        Q18ezX5tE6P7m/7P/HHPmMZvqgsmXup3cAB30aHQToKLFr/i68zA0CT2w7bR6/O84vRlrK5Q1xHSc
        0u6DH/xvf+nwKahGZe2l5TkLEs5RBQMhMEnte6XylwWjCg4LjhLShgD0ChfGliYGlDzWjCEKm2xVV
        OPXethEeNJaKdpWvTSiI4vhvxU1ZEGskg4JMDxWuA7jO1+yT0rU2IK1f+HLmHYQRG4Q5JrEyLOCMI
        Ycg0OqQ2xFq4QhBeS3LLBpRp+dape+V88KmRLCmfFhL0CeLmEnZy7HCV/55icBNaSvrEmXf4So7lg
        LX+baEtPg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:48182)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j97qz-0008H7-2z; Tue, 03 Mar 2020 13:44:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j97qv-0005wH-1l; Tue, 03 Mar 2020 13:44:53 +0000
Date:   Tue, 3 Mar 2020 13:44:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, mkl@pengutronix.de,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, kernel@pengutronix.de,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, david@protonic.nl,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1] net: dsa: sja1105: add 100baseT1_Full support
Message-ID: <20200303134452.GL25745@shell.armlinux.org.uk>
References: <20200303074414.30693-1-o.rempel@pengutronix.de>
 <CA+h21hrkVr4-Bgop0bor9nkKDUm4dYdyuDWJ_jthjKpy98ZQ1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrkVr4-Bgop0bor9nkKDUm4dYdyuDWJ_jthjKpy98ZQ1A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 12:04:04PM +0200, Vladimir Oltean wrote:
> On Tue, 3 Mar 2020 at 09:44, Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > Validate 100baseT1_Full to make this driver work with TJA1102 PHY.
> >
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> I was expecting this patch sooner or later.
> 
> Acked-by: Vladimir Oltean <olteanv@gmail.com>
> 
> I should take this opportunity and express the fact that it is strange
> for MAC drivers to have to sign off all possible copper and fiber
> media types in their .phylink_validate method. Sooner or later
> somebody is going to want to add 1000Base-T1 too. I don't think it is
> going to scale very well. Russell, with your plan to make MAC drivers
> just populate a bitmap of phy_modes (MII side), is it also going to
> get rid of media side validation?

You're touching on a concern I've had for some time that the link modes
mix together several different parameters: speed, duplex, and media.

What we actually want for a MAC is to know which speeds and duplexes
they support for each interface mode, and then translate that to the
ethtool link modes as appropriate.  That isn't a problem I've addressed
yet, but something that could be addressed.

I've just updated my net-queue with a bunch of stuff that's been
sitting in other branches (some published, some not), which includes
the PHY_INTERFACE_MODE bitmap changes - everything from and including
"net: mvpp2: add port support helpers" concerns the bitmap stuff.

At the moment, it has to support both the new bitmap solution and the
legacy solution, but hopefully in time we can drop the legacy solution.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
