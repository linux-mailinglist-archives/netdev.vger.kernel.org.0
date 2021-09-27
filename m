Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81A4196CE
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhI0O6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:58:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33900 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhI0O6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OSZSvQFG7O4SxG9se9x14daH7zm+W8BUgPWCOS3jbis=; b=b3ok4SdmPhMIWP3Ea5yrSayVu6
        Z5GxVANQjdNDET/0Z0Oa54t+a8v88c1WMeFGSpgVM6Mp578phmrN8mDsHwJDgdze8PZLSWLd5u7LD
        yjBA+YGCgLqmWmXjAYOy0wuA4cU3sg5iRKLEHVfEkzP/xknYrh/FpHM2/mlog6a1amZw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUs3X-008S9d-7N; Mon, 27 Sep 2021 16:56:35 +0200
Date:   Mon, 27 Sep 2021 16:56:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH v3 1/2] gpio: mlxbf2: Introduce IRQ support
Message-ID: <YVHbo/cJcHzxUk+d@lunn.ch>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com>
 <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 02:19:45PM +0000, Asmaa Mnebhi wrote:
> 
> > The BlueField GPIO HW only support Edge interrupts.
> 
> O.K. So please remove all level support from this driver,
> and return -EINVAL if requested to do level.
> This also means, you cannot use interrupts with the
> Ethernet PHY. The PHY is using level interrupts.
> 
> Why not? The HW folks said it is alright because they
> Do some internal conversion of PHY signal and we have tested
> This extensively.

So the PHY is level based. The PHY is combing multiple interrupt
sources into one external interrupt. If any of those internal
interrupt sources are active, the external interrupt is active. If
there are multiple active sources at once, the interrupt stays low,
until they are all cleared. This means there is not an edge per
interrupt. There is one edge when the first internal source occurs,
and no more edges, even if there are more internal interrupts.

The general flow in the PHY interrupt handler is to read the interrupt
status register, which tells you which internal interrupts have
fired. You then address these internal interrupts one by one. This can
take some time, MDIO is a slow bus etc. While handling these interrupt
sources, it could be another internal interrupt source triggers. This
new internal interrupt source keeps the external interrupt active. But
there has not been an edge, since the interrupt handler is still
clearing the sources which caused the first interrupt. With level
interrupts, this is not an issue. When the interrupt handler exits,
the interrupt is re-enabled. Since it is still active, due to the
unhandled internal interrupt sources, the level interrupt immediately
fires again. the handler then sees this new interrupt and handles
it. At that point the level interrupt goes inactive.

Now think about what happens if you are using an edge interrupt
controller with a level interrupt. You get the first edge, and call
the interrupt handler. And then there are no more edges, despite there
being more interrupts. You not only loose the new interrupt, you never
see any more interrupts. You PHY link can go up and down, it can try
to report being over temperature, that it has detected power from the
peer, cable tests have passed, etc. But since there is no edge, there
is never an interrupt.

So you say it has been extensively tested. Has it been extensively
tested with multiple internal interrupt sources at the same time? And
with slight timing variations, so that you trigger this race
condition? It is not going to happen very often, but when it does, it
is going to be very bad.

	Andrew

