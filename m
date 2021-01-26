Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E66303E82
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403825AbhAZNPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:15:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391830AbhAZNPc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 08:15:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4OB6-002hfZ-42; Tue, 26 Jan 2021 14:14:40 +0100
Date:   Tue, 26 Jan 2021 14:14:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <YBAVwFlLsfVEHd+E@lunn.ch>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126073337.20393-1-mike.looijmans@topic.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 08:33:37AM +0100, Mike Looijmans wrote:
> The mdio_bus reset code first de-asserted the reset by allocating with
> GPIOD_OUT_LOW, then asserted and de-asserted again. In other words, if
> the reset signal defaulted to asserted, there'd be a short "spike"
> before the reset.
> 
> Instead, directly assert the reset signal using GPIOD_OUT_HIGH, this
> removes the spike and also removes a line of code since the signal
> is already high.

Hi Mike

This however appears to remove the reset pulse, if the reset line was
already low to start with. Notice you left

fsleep(bus->reset_delay_us);

without any action before it? What are we now waiting for?  Most data
sheets talk of a reset pulse. Take the reset line high, wait for some
time, take the reset low, wait for some time, and then start talking
to the PHY. I think with this patch, we have lost the guarantee of a
low to high transition.

Is this spike, followed by a pulse actually causing you problems? If
so, i would actually suggest adding another delay, to stretch the
spike. We have no control over the initial state of the reset line, it
is how the bootloader left it, we have to handle both states.

   Andrew
