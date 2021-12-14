Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711DA474B44
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhLNSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:55:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhLNSzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 13:55:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xI0do2HFpY4bOgtySrFnnpUGU3UNw1oNzn3oDrvpjSo=; b=00sXeakN5qQx7sYRkgCBzuISFH
        vrpaugQ4HLeOpWk7mPZBjLjQeUY5sEe8SUM6Zk6c4eNfq2fXMynsmc7VUQxwOUEcm6va4zlQvSLoP
        CzD92tW/EVVxtQfifVSmUpZYvkRS2mNA6yWFI9AsWten9OjcK0KAXVovZQifzIVhUyN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxCww-00GYVJ-TU; Tue, 14 Dec 2021 19:54:54 +0100
Date:   Tue, 14 Dec 2021 19:54:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <YbjofqEBIjonjIgg@lunn.ch>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214121638.138784-4-philippe.schenker@toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 01:16:38PM +0100, Philippe Schenker wrote:
> Reset the eth PHY after resume in case the power was switched off
> during suspend, this is required by some PHYs if the reset signal
> is controlled by software.
> 
> Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
> 
> ---
> 
>  drivers/net/ethernet/freescale/fec_main.c | 1 +

Hi Philippe

What i don't particularly like about this is that the MAC driver is
doing it. Meaning if this PHY is used with any other MAC, the same
code needs adding there.

Is there a way we can put this into phylib? Maybe as part of
phy_init_hw()? Humm, actually, thinking aloud:

int phy_init_hw(struct phy_device *phydev)
{
	int ret = 0;

	/* Deassert the reset signal */
	phy_device_reset(phydev, 0);

So maybe in the phy driver, add a suspend handler, which asserts the
reset. This call here will take it out of reset, so applying the reset
you need?

   Andrew
