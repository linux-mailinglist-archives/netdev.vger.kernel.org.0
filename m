Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4B68C5EB
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBFSh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbjBFShV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:37:21 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329E32C67E
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:37:17 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pP6MU-0006UG-Vd; Mon, 06 Feb 2023 19:37:06 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pP6MU-00012i-CE; Mon, 06 Feb 2023 19:37:06 +0100
Date:   Mon, 6 Feb 2023 19:37:06 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
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
Message-ID: <20230206183706.GH12366@pengutronix.de>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
 <20230206054713.GD12366@pengutronix.de>
 <20230206141038.vp5pdkjyco6pyosl@skbuf>
 <Y+EfSKRwQMRgEurL@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+EfSKRwQMRgEurL@lunn.ch>
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

On Mon, Feb 06, 2023 at 04:39:52PM +0100, Andrew Lunn wrote:
> > > > What is the code flow through the kernel with EEE? I wasn't able to find
> > > > a good explanation about it.
> > > > 
> > > > Is it advertised by default, if supported? I guess phy_advertise_supported()
> > > > does that.
> 
> The old flow is poorly defined. If the MAC supports EEE, it should
> call phy_init_eee(). That looks at the results of auto-neg and returns
> if EEE has been negotiated or not.
> 
> However, i'm not aware of any code which disables by default the
> advertisement of EEE, or actually enables the negotiation of EEE. So
> there are probably a number of PHYs which are EEE capable, connected
> to a MAC driver which does not call phy_init_eee() and are advertising
> EEE and negotiating EEE. There might also be a subset of that which
> are actually doing EEE, despite not calling phy_init_eee().
> 
> So the current code is not good, and there is a danger we introduce
> power regressions as we sort this out.
> 
> The current MAC/PHY API is pretty broken. We probably should be
> handling this similar to pause. A MAC which supports pause should call
> phy_support_asym_pause() or phy_support_sym_pause() which will cause
> the PHY to advertise its supported Pause modes. So we might want to
> add a phy_support_eee()? We then want the result of EEE negotiation
> available in phydev for when the link_adjust() callback is called.

Good point.

SmartEEE will be probably a bit more challenging. If MAC do not
advertise EEE support, SmartEEE can be enabled. But it would break PTP
if SmartEEE is active. Except SmartEEE capable PHY implements own PTP
support. In any case, user space will need extra information to
identify potential issues.

> A quick look at a few MAC drivers seems to indicate many are getting
> it wrong and don't actually wait for the result of the auto-neg....

Some ethernet driver trying to do own EEE state detection, and doing
false positive detection on not supported states - for example half
duplex.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
