Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA14424E0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhKBAw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:52:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhKBAw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Oat4dkNGPgPrMhy99YcPihYIB0B0LOufAF+2fSLtM9c=; b=3LFdum8/tu48Iz3Tf/FCDBCcgt
        hQ/j3oRtBM+RJoLmYoRJ4hh6mi3g1VwB7xLyMMQwATUHAJMXk9tdD0DnGmseE6RGPYh2xAhalaTje
        SvwV7RbmEUDrVCSXo+5YnlRViwXItm00jzFO/iAIwkqGCHHYzlw0KgHtCO7ty7mhkGIY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhhzi-00CM5B-4M; Tue, 02 Nov 2021 01:49:42 +0100
Date:   Tue, 2 Nov 2021 01:49:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYCLJnY52MoYfxD8@lunn.ch>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The use of the indirect registers is specific to PHYs, and we already
> know that various PHYs don't support indirect access, and some emulate
> access to the EEE registers - both of which are handled at the PHY
> driver level.

That is actually an interesting point. Should the ioctl call actually
use the PHY driver read_mmd and write_mmd? Or should it go direct to
the bus? realtek uses MII_MMD_DATA for something to do with suspend,
and hence it uses genphy_write_mmd_unsupported(), or it has its own
function emulating MMD operations.

So maybe the ioctl handler actually needs to use __phy_read_mmd() if
there is a phy at the address, rather than go direct to the bus?

Or maybe we should just say no, you should do this all from userspace,
by implementing C45 over C22 in userspace, the ioctl allows that, the
kernel does not need to be involved.

	Andrew
