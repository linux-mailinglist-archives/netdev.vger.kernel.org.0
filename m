Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10EE2B846C
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgKRTKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:10:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgKRTKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:10:19 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfSqP-007m0s-2m; Wed, 18 Nov 2020 20:10:17 +0100
Date:   Wed, 18 Nov 2020 20:10:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Ruslan V. Sushko" <rus@sushko.dev>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset
Message-ID: <20201118191017.GH1800835@lunn.ch>
References: <20201116164301.977661-1-rus@sushko.dev>
 <20201118105251.0f3c9ac8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118105251.0f3c9ac8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 10:52:51AM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 08:43:01 -0800 Ruslan V. Sushko wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > When the switch is hardware reset, it reads the contents of the
> > EEPROM. This can contain instructions for programming values into
> > registers and to perform waits between such programming. Reading the
> > EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
> > after deasserting the reset GPIO. So poll the EEPROM done bit to
> > ensure it is complete.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Ruslan Sushko <rus@sushko.dev>
> 
> Andrew, do we need this in net?

I was wondering about that. I actually recommend leaving the EEPROM
empty. The driver has no idea what magic the EEPROM has done, and so
will stomp over it, or make assumptions which are not true about
register values.

But Zodiac has valid use cases of putting stuff into the EEPROM, and
they are aware of the danger. And this patch has got lost at least
once, causing lots of head scratching. So getting it into 5.10 makes
sense for them. I don't think it needs to go further back.

Not sure what Fixes: tag to use.

    Andrew
