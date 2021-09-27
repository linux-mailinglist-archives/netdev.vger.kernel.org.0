Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DF5419EF3
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 21:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbhI0TM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 15:12:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235964AbhI0TM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 15:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Mh3yzrEcylJtn9qpK9BS26cL4bktBLXdV9NfJgr9pkE=; b=VtaXEGSDXcFg5ttxnKr9X1K0lX
        +eazji396RJZYvzxxeYFIqkRQV7nfY80eMaefttMmK5HixKgp6G8nTliASfcpcdjRSuMQWkVRnW0x
        xr+LFC2bei3f0wvhuy7wIDp5U/oLWTrj7voxHXe2ACf3/u++k2kW5+s0cGSF9OY5IB7k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mUw1U-008Ubl-9q; Mon, 27 Sep 2021 21:10:44 +0200
Date:   Mon, 27 Sep 2021 21:10:44 +0200
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
Message-ID: <YVIXNEmhoMW7c1S/@lunn.ch>
References: <20210923202216.16091-1-asmaa@nvidia.com>
 <20210923202216.16091-2-asmaa@nvidia.com>
 <YU26lIUayYXU/x9l@lunn.ch>
 <CACRpkdbUJF6VUPk9kCMPBvjeL3frJAbHq+h0-z7P-a1pSU+fiw@mail.gmail.com>
 <CH2PR12MB38951F2326196AB5B573A73DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHQQcv2M6soJR6u@lunn.ch>
 <CH2PR12MB389585F7D5EFE5E2453593DBD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YVHbo/cJcHzxUk+d@lunn.ch>
 <CH2PR12MB3895E69636DDB3811C0EAE3DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR12MB3895E69636DDB3811C0EAE3DD7A79@CH2PR12MB3895.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Asmaa>> Thank you very much for the detailed and clear explanation!
> we only enable/support link up/down interrupts. QA has tested
> bringing up/down the network interface +200 times in a loop.

The micrel driver currently only uses two interrupts of the available
8. So it will be hard to trigger the problem with the current
driver. Your best way to trigger it is going to bring the link down as
soon as it goes up. So you get first a link up, and then a link down
very shortly afterwards.

There is however nothing stopping developers making use of the other
interrupts. That will then increase the likelihood of problems.

What does help you is that the interrupt register is clear on read. So
the race condition window is small.

> The software interrupt and handler is not registered
> based on the GPIO interrupt but rather a HW interrupt which is
> common to all GPIO pins (irrelevant here, but this is edge triggered):
> ret = devm_request_irq(dev, irq, mlxbf2_gpio_irq_handler,
>                                         IRQF_SHARED, name, gs);

IRQF_SHARED implied level. You cannot have a shared interrupt which is
using edges.

      Andrew
