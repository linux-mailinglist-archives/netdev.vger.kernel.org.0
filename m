Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D309D306AD0
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhA1B5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:57:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhA1B5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:57:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4wXp-002xfn-Lw; Thu, 28 Jan 2021 02:56:25 +0100
Date:   Thu, 28 Jan 2021 02:56:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mike Looijmans <mike.looijmans@topic.nl>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Prevent spike on MDIO bus reset signal
Message-ID: <YBIZyWZNoQeJ7Bt4@lunn.ch>
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

Did you look at the per PHY reset? mdiobus_register_gpiod() gets the
GPIO with GPIOD_OUT_LOW. mdiobus_register_device() then immediately
sets it high.

So it looks like it suffers from the same problem.

   Andrew
