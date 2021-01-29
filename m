Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCFE308E7A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233355AbhA2U0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:26:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233365AbhA2UY0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:24:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l5aIo-003FK8-EP; Fri, 29 Jan 2021 21:23:34 +0100
Date:   Fri, 29 Jan 2021 21:23:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <YBRuxtP3CTiATzDa@lunn.ch>
References: <20210126073337.20393-1-mike.looijmans@topic.nl>
 <YBIZyWZNoQeJ7Bt4@lunn.ch>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.949ef384-8293-46b8-903f-40a477c056ae.7228ddf2-6794-42a0-8b0b-3821446cdb40@emailsignatures365.codetwo.com>
 <1b153bce-a66a-45ee-a5c6-963ea6fb1c82.0d2bd5fa-15cc-4b27-b94e-83614f9e5b38.7855d092-e2c3-4ba5-a029-2a0bbce637e1@emailsignatures365.codetwo.com>
 <956acc58-6ec8-c3d5-1310-7305c3b5a471@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <956acc58-6ec8-c3d5-1310-7305c3b5a471@topic.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 09:45:41AM +0100, Mike Looijmans wrote:
> Hi Andrew,
> 
> Response below...

Hi Mike

Everybody here knows that top posting is evil, we don't do it. We
expect the replay to be inline.

> > Hi Mike
> > 
> > Did you look at the per PHY reset? mdiobus_register_gpiod() gets the
> > GPIO with GPIOD_OUT_LOW. mdiobus_register_device() then immediately
> > sets it high.
> > 
> > So it looks like it suffers from the same problem.
> 
> Well, now that I have your attention...
> 
> The per PHY reset was more broken

It has history. It was designed to be used for PHYs which needed a
reset after the clock was changed. It assumed the PHY would probe,
which some do when held in reset.

But the GPIO is not the only problem. Some PHYs need a regulator
enabled, some need a clock enabled. The core has no idea what order to
do this in. It should be the PHY driver that does this, since it
should have knowledge of the PHY, and can do things in the correct
order. But if the PHY does not respond, it is not discovered, and so
the driver does not load. If that case, you can put the PHY ID into
the compatible string, and the core will load the correct driver and
probe it, allow it to turn on whatever it needs.

This has been discussed a few times and this is what we decided on.
Maybe we need to improve the documentation.

      Andrew
