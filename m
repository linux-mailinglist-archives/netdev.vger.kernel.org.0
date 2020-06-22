Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40086203775
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgFVNH2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 22 Jun 2020 09:07:28 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:51805 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgFVNHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:07:11 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 463C54000B;
        Mon, 22 Jun 2020 13:07:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200620151001.GL304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com> <20200619122300.2510533-6-antoine.tenart@bootlin.com> <20200620151001.GL304147@lunn.ch>
Subject: Re: [PATCH net-next v3 5/8] net: phy: mscc: 1588 block initialization
To:     Andrew Lunn <andrew@lunn.ch>
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Message-ID: <159283122502.1456598.2577905456018345790@kwain>
Date:   Mon, 22 Jun 2020 15:07:05 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Quoting Andrew Lunn (2020-06-20 17:10:01)
> On Fri, Jun 19, 2020 at 02:22:57PM +0200, Antoine Tenart wrote:
> > From: Quentin Schulz <quentin.schulz@bootlin.com>
> > 
> > This patch adds the first parts of the 1588 support in the MSCC PHY,
> > with registers definition and the 1588 block initialization.
> > 
> > Those PHYs are distributed in hardware packages containing multiple
> > times the PHY. The VSC8584 for example is composed of 4 PHYs. With
> > hardware packages, parts of the logic is usually common and one of the
> > PHY has to be used for some parts of the initialization. Following this
> > logic, the 1588 blocks of those PHYs are shared between two PHYs and
> > accessing the registers has to be done using the "base" PHY of the
> > group. This is handled thanks to helpers in the PTP code (and locks).
> > We also need the MDIO bus lock while performing a single read or write
> > to the 1588 registers as the read/write are composed of multiple MDIO
> > transactions (and we don't want other threads updating the page).
> 
> Locking sounds complex. I assume LOCKDEP was your friend in getting
> this correct and deadlock free.

I agree, locking is not straight forward. But it's actually not that
complex:

- The MDIO bus lock is used for all TS/PHC register access.
- There is one lock for PHC operations and one for timestamping
  operations. The two are never used in the same function. We could use
  the same lock; introducing more waiting.
- There is one shared lock for GPIO operations. It is only used in
  PHC functions, in two places.

And I realized I can remove the locks from vsc8584_ptp_init, as PHC/TS
helpers are not registered until the PHY is initialized.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
