Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF4C4EF77E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349421AbiDAP5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350607AbiDAPoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:44:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EB62B9A0C;
        Fri,  1 Apr 2022 08:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G5qMjCe4z3bEfBal1XdVkrll0up+2huRFDPmKjNNvZM=; b=TgneTeH3lNOFIHdWtZMCCTWIAX
        yEqFi3B5jt3eClafhbCGoxz40Vf6IYzwlNxwCodpuo0rGpCumzaq8CM8yiSasOFyA26K/jKnaKW6O
        pubylpzYuzb9VELrBAQisOclpTofg6t4grXTgSgj+VbtMyVBjkrHRwfpO13KW8ciEf9U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naIQg-00DgwX-L0; Fri, 01 Apr 2022 16:39:10 +0200
Date:   Fri, 1 Apr 2022 16:39:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net v2 0/3] net: phy: micrel: Remove latencies support
 lan8814
Message-ID: <YkcOjlR++GwLWyT5@lunn.ch>
References: <20220401110522.3418258-1-horatiu.vultur@microchip.com>
 <Ykb2yoXHib6l9gkT@lunn.ch>
 <20220401141120.imsolvsl2xpnnf4q@lx-anielsen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401141120.imsolvsl2xpnnf4q@lx-anielsen>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 04:11:20PM +0200, Allan W. Nielsen wrote:
> On 01.04.2022 14:57, Andrew Lunn wrote:
> > On Fri, Apr 01, 2022 at 01:05:19PM +0200, Horatiu Vultur wrote:
> > > Remove the latencies support both from the PHY driver and from the DT.
> > > The IP already has some default latencies values which can be used to get
> > > decent results. It has the following values(defined in ns):
> > > rx-1000mbit: 429
> > > tx-1000mbit: 201
> > > rx-100mbit:  2346
> > > tx-100mbit:  705
> > 
> > So one alternative option here is that ptp4l looks at
> > 
> > /sys/class/net/<ifname>/phydev/phy_id
> > 
> > to identify the PHY, listens to netlink messages to determine the link
> > speed and then applies the correction itself in user space. That gives
> > you a pretty generic solution, works for any existing PHY and pretty
> > much any existing kernel version.  And if you want board specific
> > values you can override them in the ptp4l configuration file.
>
> I think it is good to have both options. If you want PTP4L to compensate
> in user-space, do not call the tunable, if you want to HW to compensate,
> call the tunable (this is useful both for users using ptp4l and other
> ptpimplementations).
>
> If system behaves strange, it is easy to see what delays has been
> applied.

I don't actually think that is true. How wound i know that

> > > rx-1000mbit: 429
> > > tx-1000mbit: 201
> > > rx-100mbit:  2346
> > > tx-100mbit:  705

are the default values? I cannot just look at them and obviously see
they are not the default values. I would need to learn what the
default values are of every PHY in linux which allows the PHY to
perform a correction.

Are you also saying that ptp4l needs to read the values from the
driver, calculate the differ from the defaults, and then apply that
difference to the correction specified in the configuration file it
will apply in userspace?

Does the PTP API enforce mutual exclusion for a device? Can there be
multiple applications running on an interface, some which assume the
hardware is configured to perform corrections and some which will
apply the correction in user space?

Richard?

	Andrew


