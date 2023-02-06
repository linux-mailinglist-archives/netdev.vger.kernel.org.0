Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0584068C278
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBFQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjBFQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:07:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A01E7A88;
        Mon,  6 Feb 2023 08:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6yhmU5Aj7NOteiUxigfkd0O6jgTm4huNWcrZ7HcVw4s=; b=2jXFx1bj0ZR6HbUWHUe2JKIOsY
        cfIeL/ydCyPNIjXkWxaa5a1L2Rjwm8cCwAXz6pmZJhEafa43Tzhsc9tpiU09Z/w6KbHH8qwKT3kC6
        NpZgYl4kXOUOJdkb4jMteQlCMhPaFwAJnHP57sWlYbLGNGP8iKcigzYUfsVhxYsIiBLs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP3ay-004DSq-5P; Mon, 06 Feb 2023 16:39:52 +0100
Date:   Mon, 6 Feb 2023 16:39:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
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
Message-ID: <Y+EfSKRwQMRgEurL@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
 <20230206054713.GD12366@pengutronix.de>
 <20230206141038.vp5pdkjyco6pyosl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206141038.vp5pdkjyco6pyosl@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > What is the code flow through the kernel with EEE? I wasn't able to find
> > > a good explanation about it.
> > > 
> > > Is it advertised by default, if supported? I guess phy_advertise_supported()
> > > does that.

The old flow is poorly defined. If the MAC supports EEE, it should
call phy_init_eee(). That looks at the results of auto-neg and returns
if EEE has been negotiated or not.

However, i'm not aware of any code which disables by default the
advertisement of EEE, or actually enables the negotiation of EEE. So
there are probably a number of PHYs which are EEE capable, connected
to a MAC driver which does not call phy_init_eee() and are advertising
EEE and negotiating EEE. There might also be a subset of that which
are actually doing EEE, despite not calling phy_init_eee().

So the current code is not good, and there is a danger we introduce
power regressions as we sort this out.

The current MAC/PHY API is pretty broken. We probably should be
handling this similar to pause. A MAC which supports pause should call
phy_support_asym_pause() or phy_support_sym_pause() which will cause
the PHY to advertise its supported Pause modes. So we might want to
add a phy_support_eee()? We then want the result of EEE negotiation
available in phydev for when the link_adjust() callback is called.

A quick look at a few MAC drivers seems to indicate many are getting
it wrong and don't actually wait for the result of the auto-neg....

   Andrew

