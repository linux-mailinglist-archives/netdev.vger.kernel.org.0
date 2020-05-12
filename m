Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C981CFDDC
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbgELSzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELSzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:55:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A95C061A0C;
        Tue, 12 May 2020 11:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DuQnObfma1WkHbZTabF7H6jt3JFEZVYaxX/fV7nd448=; b=axN1tHeYZOvpIpOkUd9+uCAo6
        qPudqbtLx7aB8HRwCO1SUYvxdvgSs13lLUn73AP/d4yPNbDnNxhAzT8Gxluo3LQwl4yEzEUeNJHjc
        c4QPOo4TThM90ylJhfmyIEMullmaS2E2x9waVkDBwZzi21sh2msQQnMkdvk/aLEDS5pSXRXL4jgjR
        5taA7oIzbvUBgWr/89+vLjOdC0Ho0PloE0E1Oxjx6ofqcwnb4Qz0NXUE6X9zXU7HH1WOQgNN1jIfZ
        SHOjKDnp7byR+fp5rtU0Wb/+Fy8JMDOQhRJ0ZUGOJVsRAodVINVY6pF2Hx5Zgshgbx0TRaDJpJ4gP
        JnoAUeCIg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:57156)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jYa3Y-0002OC-Vh; Tue, 12 May 2020 19:55:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jYa3T-0006yT-FF; Tue, 12 May 2020 19:55:03 +0100
Date:   Tue, 12 May 2020 19:55:03 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Doug Berger <opendmb@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: ethernet: validate pause autoneg
 setting
Message-ID: <20200512185503.GD1551@shell.armlinux.org.uk>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-2-git-send-email-opendmb@gmail.com>
 <20200512004714.GD409897@lunn.ch>
 <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae63b295-b6e3-6c34-c69d-9e3e33bf7119@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 11:31:39AM -0700, Doug Berger wrote:
> This was intended as a fix, but I thought it would be better to keep it
> as part of this set for context and since net-next is currently open.
> 
> The context is trying to improve the phylib support for offloading
> ethtool pause configuration and this is something that could be checked
> in a single location rather than by individual drivers.
> 
> I included it here to get feedback about its appropriateness as a common
> behavior. I should have been more explicit about that.
> 
> Personally, I'm actually not that fond of this change since it can
> easily be a source of confusion with the ethtool interface because the
> link autonegotiation and the pause autonegotiation are controlled by
> different commands.
> 
> Since the ethtool -A command performs a read/modify/write of pause
> parameters, you can get strange results like these:
> # ethtool -s eth0 speed 100 duplex full autoneg off
> # ethtool -A eth0 tx off
> Cannot set device pause parameters: Invalid argument
> #
> Because, the get read pause autoneg as enabled and only the tx_pause
> member of the structure was updated.

This looks like the same argument I've been having with Heiner over
the EEE interface, except there's a difference here.

# ethtool -A eth0 autoneg on
# ethtool -s eth0 autoneg off speed 100 duplex full

After those two commands, what is the state of pause mode?  The answer
is, it's disabled.

# ethtool -A eth0 autoneg off rx on tx on

is perfectly acceptable, as we are forcing pause modes at the local
end of the link.

# ethtool -A eth0 autoneg on

Now, the question is whether that should be allowed or not - but this
is merely restoring the "pause" settings that were in effect prior
to the previous command.  It does not enable pause negotiation,
because autoneg as a whole is disabled, but it _allows_ pause
negotiation to occur when autoneg is enabled at some point in the
future.

Also, allowing "ethtool -A eth0 autoneg on" when "ethtool -s eth0
autoneg off" means you can configure the negotiation parameters
_before_ triggering a negotiation cycle on the link.  In other words,
it would avoid:

# ethtool -s eth0 autoneg on
# # Link renegotiates
# ethtool -A eth0 autoneg on
# # Link renegotiates a second time

and it also means that if stuff has already been scripted to avoid
this, nothing breaks.

If we start rejecting ethtool -A because autoneg is disabled, then
things get difficult to configure - we would need ethtool documentation
to state that autoneg must be enabled before configuration of pause
and EEE can be done.  IMHO, that hurts usability, and adds confusion.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
