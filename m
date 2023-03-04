Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F736AAA9A
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCDPEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 10:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCDPEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 10:04:44 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC64D324;
        Sat,  4 Mar 2023 07:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3EW+cE1iPdOSlYV+9XVPWeV5/ZUNFFr2RNIs7Bm7Q44=; b=1au3pzdpramIt1YwUPSqtQumKR
        0r4t1ixg0lzWmEO/XivdFeomCxi/BBZopPzoFBt/tpl4omWM2O8Yg/YVr5kOtVyb5gqwjWoZDbn+v
        xOOW/5Dxdcx7RRU10CY85NgVYCy1Z+3nWwhx5U4ah5qO62qa59w7B6V9IqrIw1z3fT8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pYTQy-006S1R-4R; Sat, 04 Mar 2023 16:04:28 +0100
Date:   Sat, 4 Mar 2023 16:04:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wang Yufen <wangyufen@huawei.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 3/4] net: Let the active time stamping layer be
 selectable.
Message-ID: <ZANd/LE8Jk+0gPdI@lunn.ch>
References: <20230303164248.499286-1-kory.maincent@bootlin.com>
 <20230303164248.499286-4-kory.maincent@bootlin.com>
 <640289d5ef54c_cc8e2087a@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <640289d5ef54c_cc8e2087a@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Should setting netdev->selected_timestamping_layer be limited to
> choices that the device supports?
> 
> At a higher level, this series assumes that any timestamp not through
> phydev is a MAC timestamp. I don't think that is necessarily true for
> all devices. Some may timestamp at the phy, but not expose a phydev.
> This is a somewhat pedantic point. I understand that the purpose of
> the series is to select from among two sets of APIs.

Network drivers tend to fall into one of two classes.

1) Linux drives the whole hardware, MAC, PCS, PHY, SPF cage, LEDs etc.

2) Linux drives just the MAC, and the rest is hidden away by firmware.

For this to work, the MAC API should be sufficient to configure and
get status information for things which are hidden away from Linux.
An example of this is the ethtool .get_link_ksettings, which mostly
deals with PHY settings. Those which have linux controlling the
hardware call phy_ethtool_get_link_ksettings to get phylib to do the
work, where as if the hardware is hidden away, calls into the firmware
are made to implement the API.

When we are talking about time stamping, i assume you are talking
about firmware driver the lower level hardware. I can see two ways
this could go:

1) The MAC driver registers two timestamping devices with the core,
one for the MAC and another for the PHY. In that case, all we need is
the registration API to include some sort of indicator what layer this
time stamper works at. The core can then expose to user space that
there are two, and mux kAPI calls to one or the other.

2) Despite the hardware having two stampers, it only exposes one to
the PTP core. Firmware driven hardware already has intimate knowledge
of the hardware, since it has to have firmware to drive the hardware,
so it should be able to say which is the better stamper. So it just
exposes that one.

So i think the proposed API does work for firmware driven stampers,
but we might need to extend ptp_caps to include a level indication,
MAC, bump in the wire, PHY, etc.

     Andrew
