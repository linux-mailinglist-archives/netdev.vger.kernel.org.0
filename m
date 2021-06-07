Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5AE39D6B0
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhFGIGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 04:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:05:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9FAC061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:04:07 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAEv-000168-59; Mon, 07 Jun 2021 10:04:05 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lqAEu-00070f-Nr; Mon, 07 Jun 2021 10:04:04 +0200
Date:   Mon, 7 Jun 2021 10:04:04 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 7/7] usbnet: run unbind() before
 unregister_netdev()
Message-ID: <20210607080404.5r2gsmz6w2cnpleq@pengutronix.de>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-8-o.rempel@pengutronix.de>
 <YLq6G9luZrXW5vry@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLq6G9luZrXW5vry@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:02:56 up 186 days, 22:09, 46 users,  load average: 0.10, 0.09,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 01:41:15AM +0200, Andrew Lunn wrote:
> On Fri, Jun 04, 2021 at 03:42:44PM +0200, Oleksij Rempel wrote:
> > unbind() is the proper place to disconnect PHY, but it will fail if
> > netdev is already unregistered.
> 
> O.K, this partially answers the question i was about to ask for the
> previous patch.
> 
> void phy_start(struct phy_device *phydev)
> {
> 	mutex_lock(&phydev->lock);
> 
> 	if (phydev->state != PHY_READY && phydev->state != PHY_HALTED) {
> 		WARN(1, "called from state %s\n",
> 		     phy_state_to_str(phydev->state));
> 		goto out;
> 	}
> 
> By skipping phy_error(), phydev->state is not set to PHY_HALTED. So if
> you try to start the phy again, without disconnecting it, it looks
> like there could be a problem.
> 
> But with this patch, i assume the PHY will always be disconnected and
> later reconnected when the device is replugged.

Yes. The PHY is disconnected and the PHY driver is unbinded.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
