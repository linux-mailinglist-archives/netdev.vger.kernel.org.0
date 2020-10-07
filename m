Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E52285B8C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 11:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgJGJGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 05:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgJGJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 05:06:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C21C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 02:06:40 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ5PB-0004Zl-6b; Wed, 07 Oct 2020 11:06:37 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ5PA-00010R-Eh; Wed, 07 Oct 2020 11:06:36 +0200
Date:   Wed, 7 Oct 2020 11:06:36 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Marek Vasut <marex@denx.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: Re: PHY reset question
Message-ID: <20201007090636.t5rsus3tnkwuekjj@pengutronix.de>
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
 <20201007081410.jk5fi6x5w3ab3726@pengutronix.de>
 <7edb2e01-bec5-05b0-aa47-caf6e214e5a0@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7edb2e01-bec5-05b0-aa47-caf6e214e5a0@denx.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:55:55 up 327 days, 14 min, 363 users,  load average: 0.16, 0.09,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-10-07 10:23, Marek Vasut wrote:
> On 10/7/20 10:14 AM, Marco Felsch wrote:
> > Hi Marek,
> 
> Hi,
> 
> [...]
> 
> > On 20-10-06 14:11, Florian Fainelli wrote:
> >> On 10/6/2020 1:24 PM, Marek Vasut wrote:
> > 
> > ...
> > 
> >>> If this happens on MX6 with FEC, can you please try these two patches?
> >>>
> >>> https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/
> >>>
> >>> https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/
> >>
> >> Your patches are not scaling across multiple Ethernet MAC drivers
> >> unfortunately, so I am not sure this should be even remotely considered a
> >> viable solution.
> > 
> > Recently I added clk support for the smcs driver [1] and dropped the
> > PHY_RST_AFTER_CLK_EN flag for LAN8710/20 devices because I had the same
> > issues. Hope this will help you too.
> > 
> > [1] https://www.spinics.net/lists/netdev/msg682080.html
> 
> I feel this might be starting to go a bit off-topic here,

You're right, just wanted to provide you a link :)

> but isn't the
> last patch 5/5 breaking existing setups ?

IMHO the solution proposed using the PHY_RST_AFTER_CLK_EN was wrong so
we needed to fix that. Yes we need to take care of DT backward
compatibility but we still must be able to fix wrong behaviours within
the driver. I could also argue that PHY_RST_AFTER_CLK_EN solution was
breaking exisitng setups too.

> The LAN8710 surely does need
> clock enabled before the reset line is toggled.

Yep and therefore you can specify it yet within the DT.

Regards,
  Marco
