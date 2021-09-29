Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F05741CD5D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346699AbhI2U0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:26:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39554 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346361AbhI2U0d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 16:26:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lh+F5ZjCx0bOA0ZJvvdGRxDGTO4CVU+5ejZ1orJFARo=; b=MUWnnwDTA13YTmHBToqcVGDNT5
        ePCd5dqFdM8DbuueNSvx9nvtXef2xRllw5xAQodxwVgSP22IWwn95jfAu9MY5mjXm9tczXEM+7wi5
        fLdgN9nLR2ly4pwjSQgu4+siBw1mWaxFZfmDlbTr8cBJQkGWuVNAcjPhvYO8ya8Hc7oQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVg8E-008qF0-Kf; Wed, 29 Sep 2021 22:24:46 +0200
Date:   Wed, 29 Sep 2021 22:24:46 +0200
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
Message-ID: <YVTLjp1RSPGNZlUJ@lunn.ch>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com>
 <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHbo/cJcHzxUk+d@lunn.ch>
 <CH2PR12MB389530F4A65840FE04DC8628D7A89@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB389530F4A65840FE04DC8628D7A89@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In KSZ9031, Register MII_KSZPHY_INTCS=0x1B reports all interrupt events and
> clear on read. So if there are 4 different interrupts, once it is read once, all 4 clear at once.
> The micrel.c driver has defined ack_interrupt to read the above reg and is called every time the
> interrupt handler phy_interrupt is called. So in this case, we should be good.
> The code flow in our case would look like this:
> - 2 interrupt sources (for example, link down followed by link up) set in MII_KSZPHY_INTCS
> - interrupt handler (phy_interrupt) reads MII_KSZPHY_INT which automatically clears both
> interrupts
> - another internal source triggers and sets the register.
> - The second edge will be caught accordingly by the GPIO.

I still think there is a small race window. You product manager needs
to decide if that is acceptable, or if you should poll the PHY.

Anyway, it is clear the hardware only does level interrupts, so the
GPIO driver should only accept level interrupts. -EINVAL otherwise.

I also assume you have a ACPI blob which indicates what sort of
interrupts that should be used, level low, falling edge etc. Since
that is outside of the kernel, i will never know what you decide to
put there. Ideally, until the hardware is fixed, you should not list
any interrupt and fallback to polling.

    Andrew
