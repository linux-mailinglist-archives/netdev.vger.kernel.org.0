Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73F61E8034
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgE2O2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:28:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726849AbgE2O2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 10:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6f6HO6IWYZtffRNN7g7LjyrbPlN80JpFiMaQCdj9GIg=; b=3eVLzMr5wuCxVckgNs/Fhh/tTC
        qP5nJUOkgJhXWPISsRiFWS6nEk7K/TAQitDjXktu4i1ZONTZZjJ1pF1SmEbEhgP/CIGcqpz0wUn6G
        2i7FiF+UT5I2BnlbBWG7H9rHcB2KoGy6m4IZPG+d7EPCdJKDbPSyzGIpaMD3OxJKf+xU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jefzj-003eU0-64; Fri, 29 May 2020 16:28:23 +0200
Date:   Fri, 29 May 2020 16:28:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] ravb: Mask PHY mode to avoid inserting delays twice
Message-ID: <20200529142823.GC869823@lunn.ch>
References: <20200529122540.31368-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529122540.31368-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:25:40PM +0200, Geert Uytterhoeven wrote:
> Until recently, the Micrel KSZ9031 PHY driver ignored any PHY mode
> ("RGMII-*ID") settings, but used the hardware defaults, augmented by
> explicit configuration of individual skew values using the "*-skew-ps"
> DT properties.  The lack of PHY mode support was compensated by the
> EtherAVB MAC driver, which configures TX and/or RX internal delay
> itself, based on the PHY mode.
> 
> However, now the KSZ9031 driver has gained PHY mode support, delays may
> be configured twice, causing regressions.  E.g. on the Renesas
> Salvator-X board with R-Car M3-W ES1.0, TX performance dropped from ca.
> 400 Mbps to 0.1-0.3 Mbps, as measured by nuttcp.
> 
> As internal delay configuration supported by the KSZ9031 PHY is too
> limited for some use cases, the ability to configure MAC internal delay
> is deemed useful and necessary.  Hence a proper fix would involve
> splitting internal delay configuration in two parts, one for the PHY,
> and one for the MAC.  However, this would require adding new DT
> properties, thus breaking DTB backwards-compatibility.
> 
> Hence fix the regression in a backwards-compatibility way, by letting
> the EtherAVB driver mask the PHY mode when it has inserted a delay, to
> avoid the PHY driver adding a second delay.  This also fixes messages
> like:
> 
>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: *-skew-ps values should be used only with phy-mode = "rgmii"
> 
> as the PHY no longer sees the original RGMII-*ID mode.
> 
> Solving the issue by splitting configuration in two parts can be handled
> in future patches, and would require retaining a backwards-compatibility
> mode anyway.
> 
> Fixes: bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for the KSZ9031 PHY")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
