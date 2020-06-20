Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C292024D2
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgFTPkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:40:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbgFTPkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 11:40:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmfbE-001PRD-2h; Sat, 20 Jun 2020 17:40:08 +0200
Date:   Sat, 20 Jun 2020 17:40:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v3 6/8] net: phy: mscc: timestamping and PHC
 support
Message-ID: <20200620154008.GO304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-7-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619122300.2510533-7-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:22:58PM +0200, Antoine Tenart wrote:
> To get and set the PHC time, a GPIO has to be used and changes are only
> retrieved or committed when on a rising edge. The same GPIO is shared by
> all PHYs, so the granularity of the lock protecting it has to be
> different from the ones protecting the 1588 registers (the VSC8584 PHY
> has 2 1588 blocks, and a single load/save pin).

I guess you thought about this GPIO quite a bit.

It appears you have the mutex in the shared structure, but each PHY
has its own gpio_desc, even though it should be for the same GPIO? The
binding requires each PHY has the GPIO, even though it is the same
GPIO. And there does not appear to be any checking that each PHY
really does have the same GPIO.

Ideally there would be a section in DT for the package, and this GPIO
would be there. But i don't see an good way to do this.

This does not feel right to me, but i've no good idea how it can be
made better :-(

     Andrew
 
