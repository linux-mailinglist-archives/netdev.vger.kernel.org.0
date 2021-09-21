Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FCD413BE8
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbhIUVEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:04:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233740AbhIUVEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 17:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=prpIZcxjvdXTKyMRNo5Wbn7PrK6WuARtzohRlOC6YHU=; b=2WvwaUkUIq1tNnXUQuhHTtZ5wd
        fBMTVNrGTpiogLWrUqRBTgeI7zYujZQ5bu+Zs84B3OyGCrlZf2nDBbVs3ZkkZomRO920dAGLU58dh
        Z9q52nNVmVyvnHYRRy8heqQGFXL/DuZi6snFXMtvluRXE28LHJwk/gAHvGf1lInesPS4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSmun-007gZb-UF; Tue, 21 Sep 2021 23:02:57 +0200
Date:   Tue, 21 Sep 2021 23:02:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for
 FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
Message-ID: <YUpIgTqyrDRXMUyC@lunn.ch>
References: <20210915170940.617415-1-saravanak@google.com>
 <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch>
 <YUoFFXtWFAhLvIoH@kroah.com>
 <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch>
 <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch>
 <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> There are cases where the children try to probe too quickly (before
> the parent has had time to set up all the resources it's setting up)
> and the child defers the probe. Even Andrew had an example of that
> with some ethernet driver where the deferred probe is attempted
> multiple times wasting time and then it eventually succeeds.

And i prefer an occasional EPROBE_DEFER over a broken Ethernet switch,
which is the current state. I'm happy to see optimisations, but not at
the expense of breaking working stuff.

> Also, this assumption that the child will be bound successfully upon
> addition forces the parent/child drivers to play initcall chicken

We have never had any initcall chicken problems. The switch drivers
all are standard mdio_module_driver, module_platform_driver,
module_i2c_driver, module_pci_driver. Nothing special here. Things
load in whatever order they load, and it all works out, maybe with an
EPROBE_DEFER cycle. Which is good, we get our error paths tested, and
sometimes find bugs that way.

     Andrew
