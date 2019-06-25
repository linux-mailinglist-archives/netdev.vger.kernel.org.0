Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6372152FF0
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 12:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfFYKeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 06:34:22 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50294 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfFYKeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 06:34:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9JfX7iQmjBDo3pDtoFcbOTAp5d7caPSzcHl2kcohZp4=; b=00ewTRfjhB5xcHkCaHSWrzlCs
        UmJq6O4dLdpKSXHs6+W+cNlWJuRUZ12vZ96fvGFdSpBcp34N5bj2xPlgqP/Lwd6C7aNb6JATsxAMJ
        v2JKKzd9SgPjiB8tylyltZS9ONzOV7mA5ZuqPcTP6DF1VUbKK6JSZqTXXp/i5EXcpKbnmfVeDGP58
        x5rQ7NT2Ax+fWzWWrfjznzz9XWOnTcBq6eAF1Gvvo7cRhO85j3RTp2joBahATc2faZP2D6a/yMm7u
        AwF+z0rE5xT2ridICk/hVCJESkHYwc8lQkHzGKliFhfDwMm29THuhbp0HJ847L18Htxz2SbrZFUFd
        YCCP+RwjQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58982)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfimC-0005pp-Ny; Tue, 25 Jun 2019 11:34:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfim8-00078r-VN; Tue, 25 Jun 2019 11:34:08 +0100
Date:   Tue, 25 Jun 2019 11:34:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v5 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190625103408.5rh2slqobruavyju@shell.armlinux.org.uk>
References: <1561378210-11033-1-git-send-email-pthombar@cadence.com>
 <1561378274-12357-1-git-send-email-pthombar@cadence.com>
 <20190624134233.suowuortj5dcbxdg@shell.armlinux.org.uk>
 <SN2PR07MB2480B53AFE512F46986A1CAFC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
 <20190625092930.ootk5nvbkqqvfbtd@shell.armlinux.org.uk>
 <SN2PR07MB24800C63DCBC143B3A802A6EC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN2PR07MB24800C63DCBC143B3A802A6EC1E30@SN2PR07MB2480.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 09:38:37AM +0000, Parshuram Raju Thombare wrote:
> 
> >> >In which case, gem_phylink_validate() must clear the support mask when
> >> >SGMII mode is requested to indicate that the interface mode is not
> >> >supported.
> >> >The same goes for _all_ other PHY link modes that the hardware does not
> >> >actually support, such as PHY_INTERFACE_MODE_10GKR...
> >> If interface is not supported by hardware probe returns with error, so we don't
> >> net interface is not registered at all.
> >That does not negate my comment above.
> Sorry if I misunderstood your question, but hardware supports interfaces and based
> on that link modes are supported. So if interface is not supported by hardware,
> net device is not registered and there will be no phylink_validate call.
> If hardware support particular interface, link modes supported by interface
> are added to (not cleared from) supported mask, provided configs is not trying to limit 
> data rate using GIGABIT_ENABLE* macro.

Why do you want to use phylink?

If you are only interested in supporting 10G PHYs, you don't need
phylink for that.

If you are interested in supporting SFPs as well, then using phylink
makes sense, but you need to implement your phylink conversion properly,
and that means supporting dynamic switching of the PHY interface mode,
and allowing phylink to determine whether a PHY interface mode is
supported or not.

However, with what you've indicated through our discussion, your MAC
does not support BASE-X modes, nor does it support 10GBASE-R, both of
which are required for direct connection of SFP or SFP+ modules.

The only phy link mode that you support which SFPs can make use of is
SGMII, and that will only be useful for copper SFPs configured for
SGMII mode.  It basically means you can not use any fiber SFPs.

The only other way SFPs can be supported is via an intermediary PHY to
convert the MAC interface to BASE-X, SGMII or 10GBASE-R, and we don't
yet have support for that in mainline.

So, given that you seem unwilling to take on board my comments, and
your hardware does not appear support SFPs, I'm wondering what the
point of this conversion actually is.

As a result of our reviews, I've been improving the documentation for
phylink, so there has been some positives coming out of this - which
will hopefully help others to avoid the same mistakes.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
