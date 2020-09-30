Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C78F27F258
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgI3TJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:09:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgI3TJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:09:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNhTT-00Gwmn-K4; Wed, 30 Sep 2020 21:09:11 +0200
Date:   Wed, 30 Sep 2020 21:09:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <20200930190911.GU3996795@lunn.ch>
References: <20200930174419.345cc9b4@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930174419.345cc9b4@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
> Hi,
> 
> A GE phy supports pad isolation which can save power in WOL mode. But once the
> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
> the phy is "isolated". To make the PHY work normally, I need to move the
> enabling isolation to suspend hook, so far so good. But the isolation isn't
> enabled in system shutdown case, to support this, I want to add shutdown hook
> to net phy_driver, then also enable the isolation in the shutdown hook. Is
> there any elegant solution?

> Or we can break the assumption: ethernet can still send/receive pkts after
> enabling WoL, no?

That is not an easy assumption to break. The MAC might be doing WOL,
so it needs to be able to receive packets.

What you might be able to assume is, if this PHY device has had WOL
enabled, it can assume the MAC does not need to send/receive after
suspend. The problem is, phy_suspend() will not call into the driver
is WOL is enabled, so you have no idea when you can isolate the MAC
from the PHY.

So adding a shutdown in mdio_driver_register() seems reasonable.  But
you need to watch out for ordering. Is the MDIO bus driver still
running?

   Andrew
