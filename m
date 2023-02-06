Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8281168B55F
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 06:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBFFrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 00:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBFFrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 00:47:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191491ABDE
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 21:47:31 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pOuLT-0007FS-UW; Mon, 06 Feb 2023 06:47:15 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pOuLR-0004Iw-Ji; Mon, 06 Feb 2023 06:47:13 +0100
Date:   Mon, 6 Feb 2023 06:47:13 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <20230206054713.GD12366@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 04, 2023 at 02:13:32AM +0200, Vladimir Oltean wrote:
> On Wed, Feb 01, 2023 at 03:58:22PM +0100, Oleksij Rempel wrote:
> > With this patch series we provide EEE control for KSZ9477 family of switches and
> > AR8035 with i.MX6 configuration.
> > According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
> > we consume 0,192W less power per port if EEE is enabled.
> 
> What is the code flow through the kernel with EEE? I wasn't able to find
> a good explanation about it.
> 
> Is it advertised by default, if supported? I guess phy_advertise_supported()
> does that.

Ack.

> But is that desirable? Doesn't EEE cause undesired latency for MAC-level
> PTP timestamping on an otherwise idle link?

Theoretically, MAC controls Low Power Idle states and even with some
"Wake" latency should be fully aware of actual ingress and egress time
stamps.

Practically, right now I do not have such HW to confirm it. My project
is affected by EEE in different ways:
- with EEE PTP has too much jitter
- without EEE, the devices consumes too much power in standby mode with
  WoL enabled. Even switching to 10BaseT less power as 100BaseTX with
  EEE would do.

My view is probably biased by my environment - PTP is relatively rare
use case. EEE saves power (0,2W+0,2W per link in my case). Summary power
saving of all devices is potentially equal to X amount of power plants. 
So, EEE should be enabled by default.

Beside, flow control (enabled by default) affects PTP in some cases too.

May be ptp4l should warn about this options? We should be able to detect
it from user space.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
