Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD12FAAE3
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbhARUEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437801AbhARUDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:03:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E481C061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:03:08 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1l1ajo-0004iO-WC; Mon, 18 Jan 2021 21:02:57 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1l1ajl-00070s-Of; Mon, 18 Jan 2021 21:02:53 +0100
Date:   Mon, 18 Jan 2021 21:02:53 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: Re: [PATCH v4 net-next 0/5] net: phy: Fix SMSC LAN87xx external reset
Message-ID: <20210118200253.m2pahxgn7ui7vups@pengutronix.de>
References: <MW4PR17MB42439280269409B3094724CCDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR17MB42439280269409B3094724CCDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:45:33 up 47 days,  9:51, 29 users,  load average: 0.13, 0.07,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Laurent,

thanks for your patches :) Can you check your setup since we get 6
individual emails: 'git send-email --thread ...' ;)

On 21-01-18 16:57, Badel, Laurent wrote:
> ﻿Description:
> External PHY reset from the FEC driver was introduced in commit [1] to 
> mitigate an issue with iMX SoCs and LAN87xx PHYs. The issue occurs 
> because the FEC driver turns off the reference clock for power saving 
> reasons [2], which doesn't work out well with LAN87xx PHYs which require 
> a running REF_CLK during the power-up sequence.

Not only during the power-up sequence. The complete phy internal state
machine (the hardware state machine) gets confused if the clock is
turned off randomly.

> As a result, the PHYs 
> occasionally (and unpredictably) fail to establish a stable link and 
> require a hardware reset to work reliably.
> 
> As previously noted [3], the solution in [1] integrates poorly with the
> PHY abstraction layer, and it also performs many unnecessary resets. This
> patch series suggests a simpler solution to this problem, namely to hold
> the PHY in reset during the time between the PHY driver probe and the first
> opening of the FEC driver.

Holding the Phy within reset during the FEC is in reset seems wrong to
me because: The clock can be supplied by an external crystal/oszi. This
would add unnecessary delays. Also this is again a FEC/SMSC combination
fix again. The phy has the same problem on other hosts if they are the
clock provider and toggling the ref-clk.

> To illustrate why this is sufficient, below is a representation of the PHY
> RST and REF_CLK status at relevant time points (note that RST signal is
> active-low for LAN87xx):
> 
>  1. During system boot when the PHY is probed:
>  RST    111111111111111111111000001111111111111
>  CLK    000011111111111111111111111111111000000
>  REF_CLK is enabled during fec_probe(), and there is a short reset pulse
>  due to mdiobus_register_gpiod() which calls gpiod_get_optional() with

There is also a deprecated "phy-reset-gpios" did you test this as well?

>  the GPIOD_OUT_LOW flag, which sets the initial value to 0. The reset is
>  deasserted by phy_device_register() shortly after.  After that, the PHY
>  runs without clock until the FEC is opened, which causes the unstable 
>  link issue.

Nope that's not true, you can specify the clock within the device-tree
so the fec-ref-clk isn't disabled anymore.

>  2. At first opening of the FEC:

...

> Extensive testing with LAN8720 confirmed that the REF_CLK can be disabled
> without problems as long as the PHY is either in reset or in power-down 
> mode (which is relevant for suspend-to-ram as well).

You can't disable the clock. What you listing here means that the smsc
phy needs to be re-initialized after such an clock loss. If we can
disbale the clock randomly we wouldn't need to re-initialize the phy
again.

Regards,
  Marco
