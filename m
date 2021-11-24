Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E045C980
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 17:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbhKXQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 11:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhKXQHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 11:07:50 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ABBC061574;
        Wed, 24 Nov 2021 08:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5ZjtfcVB4wsq2lV3EPnmXCKirI/GyR928eeJPaIdR7Q=; b=xHAUtbKXS2c2yCggLXgbB/5qq8
        UIXgJJG9Vf4PSj3Ptpd/MOM6RIEflWW/kF7ZOXgUii9aVJwpjMlLs4Z3DKJyQXWUs3jb8IaUDCKnR
        KiI/FxzxDQAJF7Hfaiudp1Vb1uZ9It1GGwHm/97OeVD/hXZyLEkMLkHyaoZjKAKevCblQXvuR6ueo
        aU3uwOjh+ytgSp5o8JKwekLXXXPVgv2kuPHJ1S8KiPm/7dbli39MLwJKxmDq5Z2sNzp60QWrjzloJ
        PwNen3X607QB94fQMC52djGHljVq7zkDARbrvxWv0y/M0Fgyqn0rFBD9BAkX5PRQ4bIUZmAZ/MFjr
        07XQEOpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55858)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mpul8-0000qd-FW; Wed, 24 Nov 2021 16:04:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mpul7-0001Jj-1K; Wed, 24 Nov 2021 16:04:33 +0000
Date:   Wed, 24 Nov 2021 16:04:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, p.zabel@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <YZ5ikamCVeyGFw3x@shell.armlinux.org.uk>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
 <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
 <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
 <YZ5UXdiNNf011skU@shell.armlinux.org.uk>
 <20211124154323.44liimrwzthsh547@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124154323.44liimrwzthsh547@soft-dev3-1.localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 04:43:23PM +0100, Horatiu Vultur wrote:
> > > Actually, port->config.phy_mode will not get zeroed. Because right after
> > > the memset it follows: 'config = port->config'.
> > 
> > Ah, missed that, thanks. However, why should portmode and phy_mode be
> > different?
> 
> Because the serdes knows only few modes(QSGMII, SGMII, GMII) and this
> information will come from DT. So I would like to have one variable that
> will configure the serdes ('phy_mode') and one will configure the MAC
> ('portmode').

I don't follow why you need this to be different.

Isn't the point of interfaces such as phy_set_mode_ext() such that we
can achieve independence of the details of what is behind that
interface - so, as it takes a PHY interface mode, if we're operating
in 1000BASE-X, we pass that to phy_set_mode_ext(). It is then the
responsibility of the Serdes PHY driver to decide that means "sgmii"
mode for the Serdes?

For example, the Marvell CP110 comphy driver does this:

        if (submode == PHY_INTERFACE_MODE_1000BASEX)
                submode = PHY_INTERFACE_MODE_SGMII;

because the serdes phy settings for PHY_INTERFACE_MODE_1000BASEX are
no different from PHY_INTERFACE_MODE_SGMII - and that detail is hidden
from the network driver.

The next question this brings up is... you're setting all the different
interface modes in phylink_config.supported_interfaces, which basically
means you're giving permission for phylink to switch between any of
those modes. So, what if the serdes is in QSGMII mode but phylink
requests SGMII mode. Doesn't your driver architecture mean that if
you're in QSGMII mode you can't use SGMII or GMII mode?

Is there some kind of restriction that you need to split this, or is
this purely down to the way this driver has been written?

I don't see any other driver in the kernel making this kind of split.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
