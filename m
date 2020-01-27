Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDB14A691
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgA0Ov3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:51:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgA0Ov3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XhfMsVONMq1GlEnz3UKz8jb69fs6RfdWw5Dn3X7mvYg=; b=V8y4z9fuelY302DWTQ8dgVLBP+
        +6LshB1sn4p1pGZGhzUxn6Kw+ALaFQtc5mxbKTVZq7wUMJFhvW3MsO4BrzIYdUrgjXbINKTUWpqJN
        qi/yy8k8Mu1YDoNxtu9q20+xuKFTG7sqQebXPbIeDt/r0daRnnCNVwt78r36jtiVYOC4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iw5jH-0006nz-Gd; Mon, 27 Jan 2020 15:51:07 +0100
Date:   Mon, 27 Jan 2020 15:51:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127145107.GE13647@lunn.ch>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127140834.GW25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can you give a hint which platform this is and how to reproduce it
> please?

Hi Russell

Devel C has issues with its fibre ports. I tend to test with
sff2/port9 not sff3/port3, because i also have the copper port plugged
in. If the copper gets link before the fibre, copper is used.

What i see is that after the SERDES syncs, its registers indicate a 1G
link, full duplex, etc. But the MAC is using 10/Half. And hence no
packets go through. If i set the MAC to the same as the PCS, i can at
least transmit. Receive does not work, but i think that is something
else. The statistics counters indicate the SERDES is receiving frames,
but the MAC statistic counters suggests the MAC never sees them.

I've also had issues with the DSA links, also being configured to
10/Half. That seems to be related to having a phy-mode property in
device tree. I need to add a fixed-link property to set the correct
speed. Something is broken here, previously the fixed-link was only
needed if the speed needed to be lower than the ports maximum. I think
that is a separate issue i need to dig into, not part of the PCS to
MAC transfer.

Heiner has another device which has an Aquantia PHY running in an odd
mode so that it does 1G over a T2 link. It uses SGMII for this, and
that is where we first noticed the issue of the MAC and PCS having
different configurations.

      Andrew
