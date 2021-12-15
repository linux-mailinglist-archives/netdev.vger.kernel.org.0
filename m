Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52700475549
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241229AbhLOJhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:37:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236594AbhLOJhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 04:37:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bWabqgzy31ROygG4sHuqWrrrRhdegIiJSCjnLPiSdfU=; b=kukt+hJokNzP8MUmjYG18ln/N4
        xjUgKOvA9C3x+68bB7tsOqpiTlwzEABmSgmcB6d3+2683Qqxq8UvegwpCpz/atYNcPrjeUkcxv95A
        5dbbtppfnnRAmRvP1JPMlk38QP27FAszoDy1DzUk1Y63dNTUlYSbglJ7S7M4IR6GD9wo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxQiS-00Gcwt-1v; Wed, 15 Dec 2021 10:36:52 +0100
Date:   Wed, 15 Dec 2021 10:36:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <Ybm3NDeq96TSjh+k@lunn.ch>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
 <YbjofqEBIjonjIgg@lunn.ch>
 <20211214223548.GA47132@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214223548.GA47132@francesco-nb.int.toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 11:35:48PM +0100, Francesco Dolcini wrote:
> Hello Andrew,
> 
> On Tue, Dec 14, 2021 at 07:54:54PM +0100, Andrew Lunn wrote:
> > What i don't particularly like about this is that the MAC driver is
> > doing it. Meaning if this PHY is used with any other MAC, the same
> > code needs adding there.
> This is exactly the same case as phy_reset_after_clk_enable() [1][2], to
> me it does not look that bad.
> 
> > So maybe in the phy driver, add a suspend handler, which asserts the
> > reset. This call here will take it out of reset, so applying the reset
> > you need?
> Asserting the reset in the phylib in suspend path is a bad idea, in the
> general case in which the PHY is powered in suspend the
> power-consumption is likely to be higher if the device is in reset
> compared to software power-down using the BMCR register (at least for
> the PHY datasheet I checked).

Maybe i don't understand your hardware.

You have a regulator providing power of the PHY.

You have a reset, i guess a GPIO, connected to the reset pin of the
PHY.

What you could do is:

PHY driver suspend handler does a phy_device_reset(ndev->phydev, 1)
to put the PHY into reset.

MAC driver disables the regulator.

Power consumption should now be 0, since it does not have any power.

On resume, the MAC enables the regulator. At this point, the PHY gets
power, but is still held in reset. It is now consuming power, but not
doing anything. The MAC calls phy_hw_init(), which calls
phy_device_reset(ndev->phydev, 0), taking the PHY out of reset.

Hopefully, this release from reset is enough to make the PHY work.

Doing it like this also addresses Russell point. phy_hw_init() is not
putting the device into reset, it is only taking it out of reset, if
it happens to be already in reset. So we are not slowing down link up
for everybody.

    Andrew
