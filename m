Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB8BD104E32
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 09:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUIk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 03:40:27 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35258 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUIk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 03:40:26 -0500
Received: by mail-oi1-f195.google.com with SMTP id n16so2493458oig.2;
        Thu, 21 Nov 2019 00:40:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYICoFLL+R2xvDQ8cwBkNAKd3by5y4Cxd304NbLmaIE=;
        b=HVhnUvMAh8wem30dowa9kUagLzgZxs3FRP/anrgWM/dF91mS6HefVHGgsoOTmfRBDq
         y38X7DgjRSF4IvXRYP3KO65M7y7iwU+z+0tqGCaNFPA5N/I+2gDmcKQYLLfrieZshxDW
         ns/XwwnZwcT4CMFxlmrNslNVT8tG+iC0CZVLuTDaEqCH0yDyZpQLhsFHvUkyjhLITNhL
         UuG5XitOZG71tPP1d2Uw5nTnH5iQBfXuhHP0YbbsUHzlPFN/RtPJqfYF/dWqg6QQNLa/
         G7+IDgf/4hd5XhserHpr/wS8Y0s9jezzJ5NiB/sy3GKLvt/ZNjgtX4jXePeNA2aOr/YI
         Y7TQ==
X-Gm-Message-State: APjAAAUC98lhrxMCWMh7adzw6e0InxeuW8mufCam6a1s4UFPALEhE8bn
        8LpSeNUNGHZ6RXh0XAs29yW7jrP2EahOaBPBOng=
X-Google-Smtp-Source: APXvYqxnVq+jscUnYP9bfh7AUNn5QzQBwT+e+2DvkUrqJIYwAxE1DMjnsiCfiRXfPIrBk8pt+0sYHc7gV+wf2pljfzs=
X-Received: by 2002:a05:6808:5d9:: with SMTP id d25mr6649344oij.54.1574325624177;
 Thu, 21 Nov 2019 00:40:24 -0800 (PST)
MIME-Version: 1.0
References: <20191118181505.32298-1-marek.behun@nic.cz> <20191119102744.GD32742@smile.fi.intel.com>
 <alpine.DEB.2.21.1911201053330.25420@ramsan.of.borg> <20191121020822.GD18325@lunn.ch>
 <94309e1b-d8f0-676f-5865-cff94832d830@david-bauer.net>
In-Reply-To: <94309e1b-d8f0-676f-5865-cff94832d830@david-bauer.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 21 Nov 2019 09:40:13 +0100
Message-ID: <CAMuHMdUZAKZGjv312bHawqZkjq+ea7HZ8LrghMun0aNWEO3whA@mail.gmail.com>
Subject: Re: [PATCH net 1/1] mdio_bus: fix mdio_register_device when
 RESET_CONTROLLER is disabled
To:     David Bauer <mail@david-bauer.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, Nov 21, 2019 at 9:38 AM David Bauer <mail@david-bauer.net> wrote:
> On 11/21/19 3:08 AM, Andrew Lunn wrote:
> >> The difference with the non-optional case is that
> >> __devm_reset_control_get() registers a cleanup function if there's
> >> no error condition, even for NULL (which is futile, will send a patch).
> >>
> >> However, more importantly, mdiobus_register_reset() calls a devm_*()
> >> function on "&mdiodev->dev" ("mdio_bus ee700000.ethernet-ffffffff:01"),
> >> which is a different device than the one being probed
> >> (("ee700000.ethernet"), see also the callstack below).
> >> In fact "&mdiodev->dev" hasn't been probed yet, leading to the WARNING
> >> when it is probed later.
> >>
> >>     [<c0582de8>] (mdiobus_register_device) from [<c05810e0>] (phy_device_register+0xc/0x74)
> >>     [<c05810e0>] (phy_device_register) from [<c0675ef4>] (of_mdiobus_register_phy+0x144/0x17c)
> >>     [<c0675ef4>] (of_mdiobus_register_phy) from [<c06760f0>] (of_mdiobus_register+0x1c4/0x2d0)
> >>     [<c06760f0>] (of_mdiobus_register) from [<c0589f0c>] (sh_eth_drv_probe+0x778/0x8ac)
> >>     [<c0589f0c>] (sh_eth_drv_probe) from [<c0516ce8>] (platform_drv_probe+0x48/0x94)
> >>
> >> Has commit 71dd6c0dff51b5f1 ("net: phy: add support for
> >> reset-controller") been tested with an actual reset present?
>
> I'm using it on a AR9132 board, however the mdio bus is probed before the
> ethernet driver, hence why i was not experiencing this misbehavior.

Thank you, that explains it.

> >> Are Ethernet drivers not (no longer) allowed to register MDIO busses?
> >
> > That is not good. The devm_reset_control_get() call need replaces with
> > an unmanaged version, and a call to reset_control_put() added to
> > mdiobus_unregister_device().
> >
> > David, could you look at this, it was a patch from you that added
> > this.
>
> I will prepare patches to fix this bug.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
