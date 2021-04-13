Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F1F35DCD5
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbhDMKwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236800AbhDMKwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:52:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC43C061574;
        Tue, 13 Apr 2021 03:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AyA21hCwDZr44tPRW26rnzyhYZ7wNBvoep8VeScz3VQ=; b=KW64bWZPv7mAcY0rtoikq5GWu
        ZwntBdejvJO8lY/s7jHil3J4Iy4whTvPkfqiHdkhaxvWQmu0wOkY7T8Dy+8HFVhqAqfq9lQWdSN40
        aJqawPMaZ5lNIQWk0qOUkd0G7JtNvGrEMqpK0JXyNZahhQ1Z6/1i8amynpR5UvVxqP4Skk1g8YSNY
        y990OmrYXF4OsnCjiJKqAMYNfQTjOAF92Mar/e81f/PVqz7PKHqEpz0IXwqVrrITNDkxOk1WCCA61
        GqYJiG4UnrsNAgNvdLXLaf5MdPkKoXUkS2tut7LAozWehylPoGFtKwKvw7vHbWCt5Hn1ebzCLWGS9
        vGntaCmUA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52372)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lWGe2-0005Xz-Bj; Tue, 13 Apr 2021 11:51:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lWGe0-00088B-CB; Tue, 13 Apr 2021 11:51:44 +0100
Date:   Tue, 13 Apr 2021 11:51:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
Message-ID: <20210413105144.GN1463@shell.armlinux.org.uk>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
 <c03053f59a89ef6ea4a4f2ce15aee4b4f4892745.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c03053f59a89ef6ea4a4f2ce15aee4b4f4892745.camel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 12:00:45PM +0200, Lucas Stach wrote:
> I agree with the opinion that those PHY fixups introduce more harm than
> good. Essentially they are pushing board specific configuration values
> into the PHY, without any checks that the fixup is even running on the
> specific board it was targeted at.

Yes and no. The problem is, that's an easy statement to make when one
doesn't understand what they're all doing.

Some are "board specific" in that the normal setup for e.g. iMX6 would
be to enable clock output from the AR8035 PHY and feed that into the
iMX6 - as far as I'm aware, that's the only working configuration for
that SoC and PHY. However, it's also true that this fixup should not
be applied unconditionally.

Then there's SmartEEE - it has been found that the PHY defaults for
this lead to link drops independent of the board and SoC that it is
connected to. It seems that the PHY is essentially broken - it powers
up with SmartEEE enabled, and when connected to another SmartEEE
supporting device, it seems guaranteed that it will result in link
drops in its default configuration.

Freescale's approach has apparently been to unconditionally disable
SmartEEE for all their platforms because of this. With a bit of
research however (as has been done by Jon and myself) we've found
that increasing the Tw parameter for 1G connections results in a
much more stable link.

So, just saying that these are bad without actually understanding what
they are doing is _also_ bad.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
