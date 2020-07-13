Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38FF21CE03
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 06:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGMELl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Jul 2020 00:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgGMELl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 00:11:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3669C061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 21:11:40 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jupoT-0000BJ-TV; Mon, 13 Jul 2020 06:11:33 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jupoQ-0006je-1S; Mon, 13 Jul 2020 06:11:30 +0200
Date:   Mon, 13 Jul 2020 06:11:30 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 5/5] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20200713041129.gyoldkmsti4vl4m2@pengutronix.de>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-6-o.rempel@pengutronix.de>
 <20200711182912.GP1014141@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200711182912.GP1014141@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:05:48 up 240 days, 19:24, 229 users,  load average: 0.17, 0.13,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 08:29:12PM +0200, Andrew Lunn wrote:
> On Fri, Jul 10, 2020 at 02:08:51PM +0200, Oleksij Rempel wrote:
> > This patch support for cable test for the ksz886x switches and the
> > ksz8081 PHY.
> > 
> > The patch was tested on a KSZ8873RLL switch with following results:
> > 
> > - port 1:
> >   - cannot detect any distance
> >   - provides inverted values
> >     (Errata: DS80000830A: "LinkMD does not work on Port 1",
> >      http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8873-Errata-DS80000830A.pdf)
> >     - Reports "short" on open or ok.
> >     - Reports "ok" on short.
> > 
> > - port 2:
> >   - can detect distance
> >   - can detect open on each wire of pair A (wire 1 and 2)
> >   - can detect open only on one wire of pair B (only wire 3)
> >   - can detect short between wires of a pair (wires 1 + 2 or 3 + 6)
> >   - short between pairs is detected as open.
> >     For example short between wires 2 + 3 is detected as open.
> > 
> > In order to work around the errata for port 1, the ksz8795 switch driver
> > should be extended to provide proper device tree support for the related
> > PHY nodes. So we can set a DT property to mark the port 1 as affected by
> > the errata.

Hi Andrew,
 
> Hi Oleksij
> 
> Do the PHY register read/writes pass through the DSA driver for the
> 8873?  I was wondering if the switch could intercept reads/writes on
> port1 for KSZ8081_LMD and return EOPNOTSUPP? That would be a more
> robust solution than DT properties, which are going to get forgotten.

Yes, it was my first idea as well. But this switch allows direct MDIO
access to the PHYs and this PHY driver could be used without DSA driver.
Not sure if we should support both variants?

Beside, the Port 1 need at least one more quirk. The pause souport is
announced but is not working. Should we some how clear Puase bit in the PHY and
tell PHY framework to not use it? What is the best way to do it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
