Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0C92024B4
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgFTPKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:10:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgFTPKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 11:10:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmf85-001PKY-4e; Sat, 20 Jun 2020 17:10:01 +0200
Date:   Sat, 20 Jun 2020 17:10:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v3 5/8] net: phy: mscc: 1588 block initialization
Message-ID: <20200620151001.GL304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619122300.2510533-6-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:22:57PM +0200, Antoine Tenart wrote:
> From: Quentin Schulz <quentin.schulz@bootlin.com>
> 
> This patch adds the first parts of the 1588 support in the MSCC PHY,
> with registers definition and the 1588 block initialization.
> 
> Those PHYs are distributed in hardware packages containing multiple
> times the PHY. The VSC8584 for example is composed of 4 PHYs. With
> hardware packages, parts of the logic is usually common and one of the
> PHY has to be used for some parts of the initialization. Following this
> logic, the 1588 blocks of those PHYs are shared between two PHYs and
> accessing the registers has to be done using the "base" PHY of the
> group. This is handled thanks to helpers in the PTP code (and locks).
> We also need the MDIO bus lock while performing a single read or write
> to the 1588 registers as the read/write are composed of multiple MDIO
> transactions (and we don't want other threads updating the page).

Locking sounds complex. I assume LOCKDEP was your friend in getting
this correct and deadlock free.

> +	/* For multiple port PHYs; the MDIO address of the base PHY in the
> +	 * pair of two PHYs that share a 1588 engine. PHY0 and PHY2 are coupled.
> +	 * PHY1 and PHY3 as well. PHY0 and PHY1 are base PHYs for their
> +	 * respective pair.

There are some evil hardware engineers out there :-(

It would be good it Richard gave this code a once over.

   Andrew
