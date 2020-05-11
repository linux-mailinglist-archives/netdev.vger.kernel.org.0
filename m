Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BF31CDB19
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgEKNXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgEKNXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:23:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C0CC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 06:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C9swhTqKIelkto1kOgooTcDbCoTJcbIKqW8Twf2MQTs=; b=uOWxfNiRxrIEQU9XRy3pXAHY9
        C2U4SCc9iQCPQObMXfhD50AufSjslsTP/k3dUBbqtXofxDroupiGskhcuiwXlUnXeMTZBGxiqR72Y
        Dd8W/+vPHyXU3QGvusdzutgh3imkgKkdC5xb3QUmS5DuS1sfjknM0RqjDJELMdqZUx4VO+VlSpPx2
        dTHt0RXptebQAARk8FRylLHqexX5e8JUjGa4IPLXO7LwwfGv3Zearn8n2FeyHB9bAbTPhWpNIz74y
        IzRmozY8Sa6tZzMrCr3e3cOCV2ssmqkA0NxOERS3BSBBBfOGz4eTcE1fItiJra+UZW/2Hr+MqFgvV
        9B6tA08ZQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56632)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jY8Od-0006Ld-Oh; Mon, 11 May 2020 14:23:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jY8OY-0005i2-VU; Mon, 11 May 2020 14:22:58 +0100
Date:   Mon, 11 May 2020 14:22:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: check for aneg disabled and half
 duplex in phy_ethtool_set_eee
Message-ID: <20200511132258.GT1551@shell.armlinux.org.uk>
References: <8e7df680-e3c2-24ae-81d3-e24776583966@gmail.com>
 <0c8429c2-7498-efe8-c223-da3d17b1e8e6@gmail.com>
 <20200510140521.GM1551@shell.armlinux.org.uk>
 <01a6a1b2-39cc-531a-18be-44a59a5e7441@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01a6a1b2-39cc-531a-18be-44a59a5e7441@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 02:50:23PM +0200, Heiner Kallweit wrote:
> On 10.05.2020 16:05, Russell King - ARM Linux admin wrote:
> > On Sun, May 10, 2020 at 10:11:33AM +0200, Heiner Kallweit wrote:
> >> EEE requires aneg and full duplex, therefore return EPROTONOSUPPORT
> >> if aneg is disabled or aneg resulted in a half duplex mode.
> > 
> > I think this is completely wrong.  This is the ethtool configuration
> > interface for EEE that you're making fail.
> > 
> You mentioned in a parallel response that you are aware of at least
> userspace tool / use case that would be broken by this change.
> Can you please point me to this tool / use case?

ethtool with a debian interfaces file.  I have systems which are
configured thusly:

iface eno0 inet dhcp
	pre-up ip link set $IFACE up
	pre-up ethtool --set-eee $IFACE advertise 0x28

So, if you decide to fail the call ethtool makes to configure EEE
because the link happens to have negotiated half-duplex mode, the
second command will fail, which prevent Debian bringing up this
interface.  That will be a userspace regression over how it behaves
today.

> > Why should you not be able to configure EEE parameters if the link
> > happens to negotiated a half-duplex?  Why should you not be able to
> > adjust the EEE advertisment via ethtool if the link has negotiated
> > half-duplex?
> > 
> > Why should any of this configuration depend on the current state?
> 
> If EEE settings change, then phy_ethtool_set_eee() eventually
> calls genphy_restart_aneg() which sets bits BMCR_ANENABLE in the
> chip. Means if we enter the function with phydev->autoneg being
> cleared, then we'll end up with an inconsistent state
> (phydev->autoneg not reflecting chip aneg setting).
> As alternative to throwing an error we could skip triggering an
> aneg, what would you prefer?

If we want to change EEE configuration, and autoneg is disabled, why
should we forcefully re-enable it?  How are these different scenarios?

ethtool --set-eee $IFACE advertise 0x28
ethtool -s $IFACE autoneg off speed 100 duplex full
ethtool -s $IFACE autoneg on

vs

ethtool -s $IFACE autoneg off speed 100 duplex full
ethtool --set-eee $IFACE advertise 0x28
ethtool -s $IFACE autoneg on

Why should we fail in this case when all we are doing is configuring
the advertisment?

> > Why should we force people to negotiate a FD link before they can
> > then configure EEE, and then have to perform a renegotiation?
> > 
> If being in a HD mode and setting EEE returns with a success return
> code, then users may expect EEE to be active (what it is not).

I think you grossly misunderstand this interface.  This interface is
to configure the _circumstances_ under which EEE _may_ be enabled.
It doesn't say "I want EEE to be active right this damn nanosecond."

Hence, I'm NAKing this patch.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
