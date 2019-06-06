Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACEA37FB2
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfFFVhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:37:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50868 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFFVho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:37:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kCb21q6OsUaw6LFqL4EomvNCd3Nu/w+Cn2RSWWq1kNc=; b=aO0FQQSC4SGiVZ8bkb7SpFZ/P
        zlbtSl4ps6OoAVrSgEf/0+jeJuY7qV3HqT7Kcxv/BWyfeFofC30M8uGP/X6gNMOb3637taMDUY4nP
        BAhQY2F/rStnXfQeT5vI4fqK/q4R4ooVyl+orb4EdBT07y5afiXa3mFzwu+ge39gzYBQl1b3FKN2v
        FsesyQvaszPaTKBIanp3u19918bMor+aUi8rbzQPnefHTcT0fKZ+BkGFBV/VT9FchFJ4ZE+C+bf+A
        udlCqoW+Q7hBtsF+Zm0JuM+mfdkmqB0JG0qjcTaKTL3AqJVJW4CX4f9biaRXL0Z40nNnSvRCavQlm
        hxD2XZD0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52890)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hZ04p-000053-Eg; Thu, 06 Jun 2019 22:37:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hZ04n-0003ai-8H; Thu, 06 Jun 2019 22:37:37 +0100
Date:   Thu, 6 Jun 2019 22:37:37 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606213737.gkguop42slwp4g75@shell.armlinux.org.uk>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
 <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
 <20190606183611.GD28371@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606183611.GD28371@lunn.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 08:36:11PM +0200, Andrew Lunn wrote:
> 65;5402;1c> I don't like too much state changes outside control of the state machine,
> > like in phy_start / phy_stop / phy_error. I think it would be better
> > if a state change request is sent to the state machine, and the state
> > machine decides whether the requested transition is allowed.
> 
> Hi Heiner
> 
> I initially though that phy_error() would be a good way to do what
> Russell wants. But the locks get in the way. Maybe add an unlocked
> version which PHY drivers can use to indicate something fatal has
> happened?

I think a way better solution would be if the phy_start() and
phy_stop() calls were forwarded to the PHY driver so that it has
an opportunity to:

(1) refuse a phy_start() if the PHY is not able to operate correctly,
    which would mean ip link set dev X up fails.

(2) for fiber capable PHYs, pass on to the SFP layer whether the
    network device is up or not.

I seem to remember from the original report that the problem with
the PHY without firmware is that the link apparently comes up
(despite the MMDs reporting that they are in reset) but the
negotiation results are incorrect and no data is able to pass -
but don't quote me on that, and we've now lost a reporter to test
this.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
