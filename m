Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8476670F0E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjARAv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:51:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjARAuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:50:14 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EB948597;
        Tue, 17 Jan 2023 16:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=0HCpBuDUlZrcaYoduPW/Z+1qpg8yIbgenbGVPx9MOfk=; b=vV
        m8kryVeZkEM87hthlDf5125GXBr4uT2ZkjLFASwXfys3F2ONkUp9EskecwNpN7VRj3Sj/KSDpL8fT
        P90u4Q0CiTJIhrrwLW//dJIvE2InyPGwgK+0Tw8gKPqnt1lYMUlq/8So4Ta8zQ9FnghNrN3KWu6s2
        brSv+//fMoHqXo0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHwTR-002NcW-Ps; Wed, 18 Jan 2023 01:38:41 +0100
Date:   Wed, 18 Jan 2023 01:38:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <Y8c/kQiZ4S11ua3z@lunn.ch>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
 <20230116181618.2iz54jywj7rqzygu@skbuf>
 <Y8XJ3WoP+YKCjTlF@lunn.ch>
 <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 05:05:53PM +0100, Marcin Wojtas wrote:
> Hi Andrew and Vladimir,
> 
> pon., 16 sty 2023 o 23:04 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > On Mon, Jan 16, 2023 at 08:16:18PM +0200, Vladimir Oltean wrote:
> > > On Mon, Jan 16, 2023 at 05:50:13PM +0000, Russell King (Oracle) wrote:
> > > > On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > > > > fixed-link PHYs API is used by DSA and a number of drivers
> > > > > and was depending on of_. Switch to fwnode_ so to make it
> > > > > hardware description agnostic and allow to be used in ACPI
> > > > > world as well.
> > > >
> > > > Would it be better to let the fixed-link PHY die, and have everyone use
> > > > the more flexible fixed link implementation in phylink?
> > >
> > > Would it be even better if DSA had some driver-level prerequisites to
> > > impose for ACPI support - like phylink support rather than adjust_link -
> > > and we would simply branch off to a dsa_shared_port_link_register_acpi()
> > > function, leaving the current dsa_shared_port_link_register_of() alone,
> > > with all its workarounds and hacks? I don't believe that carrying all
> > > that logic over to a common fwnode based API is the proper way forward.
> 
> In the past couple of years, a number of subsystems have migrated to a
> more generic HW description abstraction (e.g. a big chunk of network,
> pinctrl, gpio). ACPI aside, with this patchset one can even try to
> describe the switch topology with the swnode (I haven't tried that
> though). I fully agree that there should be no 0-day baggage in the
> DSA ACPI binding (FYI the more fwnode- version of the
> dsa_shared_port_validate_of() cought one issue in the WIP ACPI
> description in my setup). On the other hand, I find fwnode_/device_
> APIs really helpful for most of the cases - ACPI/OF/swnode differences
> can be hidden to a generic layer and the need of maintaining separate
> code paths related to the hardware description on the driver/subsystem
> level is minimized.

It looks like we are heading towards three different descriptions. OF,
ACPI and swnode. Each is likely to be different. OF has a lot of
history in it, deprecated things etc, which should not appear in the
others. So i see a big ugly block of code for the OF binding, and
hopefully clean and tidy code for ACPI binding and a clean and tidy
bit of code for swmode.,

It would be nice if the results of that parsing could be presented to
the drivers in a uniform way, so the driver itself does not need to
care where the information came from. But to me it is clear that this
uniform layer has no direct access to the databases, since the
database as are different.

	Andrew
