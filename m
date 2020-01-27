Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211EA14A33A
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgA0LqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:46:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34930 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729724AbgA0LqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:46:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=py0/AUeA9tDP937GDApbDIhhJ7mPRllvuk6jqlAolLw=; b=GOimjhJ60sQTWMTcrsW+8/RXc
        I/aWpmkEN1wmeFYPsQY7wYMww/awb5QDQvVADkiDJ8Kkq8Php4f3d88i2W9V47tt++YlKWm9XXY1W
        WF5JpCLsAOk26UM8d6w4yKz+u2VydMbhoIV/8rlUAxiJzHFEt0EL9fuYggga9AAAgbMlT3aI2iR3b
        NXnUV9CoULdc5yTeNdth7mWTKstGISo1EUfc/a7tX1Fka7NruUDvVsnhWBAJ1FzbLutTDXGyXzQo4
        Ont9UQf1UtnTB+ofsYzuMZTTWFeev5RFoAtVlW3yhao9YTXbDBcJbzTolNMYK8CICjggq8hEM1G8j
        T+tWanbag==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60536)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iw2qC-00011S-Lg; Mon, 27 Jan 2020 11:46:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iw2q8-0001NE-Ro; Mon, 27 Jan 2020 11:46:00 +0000
Date:   Mon, 27 Jan 2020 11:46:00 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127114600.GU25745@shell.armlinux.org.uk>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 11:38:05AM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Jan/27/2020, 11:21:02 (UTC+00:00)
> 
> > On Mon, Jan 27, 2020 at 12:09:11PM +0100, Jose Abreu wrote:
> > > When we don't have any real PHY driver connected and we get link up from
> > > PCS we shall configure MAC and PCS for the desired speed and also
> > > resolve the flow control settings from MAC side.
> > 
> > This is certainly the wrong place for it.  Please hold off on this patch
> > for the time being.  Thanks.
> 
> This is actually the change that makes everything work ...
> 
> I need to configure PCS before Aneg is complete and then I need to 
> configure MAC once Aneg is done and link is up with the outcome speed and 
> flow control.

Yes, I realise that, but it comes with the expense of potentially
breaking mvneta and mvpp2, where the settings are automatically
passed between the PCS and MAC in hardware. I also believe DSA
works around this, and I need to look at that.

However, right now I'm in the middle of rebasing my git tree on
top of v5.5 and can't say much more until I've finished that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
