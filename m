Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936D939C3FE
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFDXnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:43:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46442 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhFDXnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=teq76F1L+vznO9dqAxiuiuGN4JsSwry7FJ5qogca0Mc=; b=lYBFk45noY7CbcsbIsOxD1/iPw
        elbOkYUn/juRIzIbjNoRQ9MrvIVpfoemozWdO3SLgVGGVxLpM6jdZsA576iMy/+yiCx/NW7zKm8wx
        enMcB3LfbmwCjIFxTmuY/j8zqrZAnOHEs5gQP7AIRQhR5ySfJSFKOaW6m0hoX2XSs1Ao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpJRD-007sRw-D7; Sat, 05 Jun 2021 01:41:15 +0200
Date:   Sat, 5 Jun 2021 01:41:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 7/7] usbnet: run unbind() before
 unregister_netdev()
Message-ID: <YLq6G9luZrXW5vry@lunn.ch>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604134244.2467-8-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 03:42:44PM +0200, Oleksij Rempel wrote:
> unbind() is the proper place to disconnect PHY, but it will fail if
> netdev is already unregistered.

O.K, this partially answers the question i was about to ask for the
previous patch.

void phy_start(struct phy_device *phydev)
{
	mutex_lock(&phydev->lock);

	if (phydev->state != PHY_READY && phydev->state != PHY_HALTED) {
		WARN(1, "called from state %s\n",
		     phy_state_to_str(phydev->state));
		goto out;
	}

By skipping phy_error(), phydev->state is not set to PHY_HALTED. So if
you try to start the phy again, without disconnecting it, it looks
like there could be a problem.

But with this patch, i assume the PHY will always be disconnected and
later reconnected when the device is replugged.

      Andrew
