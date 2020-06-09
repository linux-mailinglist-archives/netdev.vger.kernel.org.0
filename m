Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0B1F3A6E
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgFIMLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729094AbgFIMLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:11:33 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C000C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 05:11:33 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jid6K-0007sT-3d; Tue, 09 Jun 2020 14:11:32 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jid6J-0005En-9w; Tue, 09 Jun 2020 14:11:31 +0200
Date:   Tue, 9 Jun 2020 14:11:31 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mvneta: add support for 2.5G DRSGMII mode
Message-ID: <20200609121131.GJ11869@pengutronix.de>
References: <20200608074716.9975-1-s.hauer@pengutronix.de>
 <20200608160801.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608160801.GO1551@shell.armlinux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:53:29 up 110 days, 15:23, 126 users,  load average: 0.02, 0.10,
 0.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 05:08:01PM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Jun 08, 2020 at 09:47:16AM +0200, Sascha Hauer wrote:
> > The Marvell MVNETA Ethernet controller supports a 2.5 Gbps SGMII mode
> > called DRSGMII.
> > 
> > This patch adds a corresponding phy-mode string 'drsgmii' and parses it
> > from DT. The MVNETA then configures the SERDES protocol value
> > accordingly.
> > 
> > It was successfully tested on a MV78460 connected to a FPGA.
> 
> Digging around, this is Armada XP?  Which SoCs is this mode supported?
> There's no mention of DRSGMII in the A38x nor A37xx documentation which
> are later than Armada XP.

It's an Armada XP MV78460 in my case. I have no idea what other SoCs
this mode is supported on.

> 
> What exactly is "drsgmii"?  It can't be "double-rate" SGMII because that
> would give you 2Gbps max instead of the 1Gbps, but this gives 2.5Gbps,
> so I'm really not sure using "drsgmii" is a good idea.  It may be what
> Marvell call it, but we really need to know if there's some vendor
> neutral way to refer to it.

The abbreviation really is for "Double Rated SGMII". It seems it has 2.5
times the clock rate than ordinary SGMII. Another term I found is HSGMII
(High serial gigabit media-independent interface) which also has
2.5Gbps.

Anyway, I just learned from the paragraph you added to
Documentation/networking/phy.rst that 1000BASEX differs from SGMII in
the format of the control word. As we have a fixed link to a FPGA the
control word seems to be unused, at least the Port MAC Control Register0
PortType setting bit doesn't change anything. So I can equally well use
the existing 2500BASEX mode.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
