Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2DA413A68
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 20:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhIUS62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 14:58:28 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:38687 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhIUS61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 14:58:27 -0400
Received: by mail-ot1-f52.google.com with SMTP id c6-20020a9d2786000000b005471981d559so8256520otb.5;
        Tue, 21 Sep 2021 11:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eV7OqCzNTmtz8a37D7yz/JSHz8NlPnMG62v9vN3eHxw=;
        b=iAywxJBgHOzYXwh1y+S/y1aQbYhqpQZGirP7AI1CH6Rzh/xgC2S//QEmeTWx8SpJaq
         xH0zFaX63hBkXm8mspqNzBmVnAYyzmpr/cLgCz/pLVjPIGg6JGAEMMQ5PyetrUXF4pui
         32IuPOgWwWk0HXDksiKRDsQwMH5YV2QCfXVw0monk8b49VqBuG/B7NgPzbdW7NdKPwfn
         VsufiutCja6CbJxo/rNpFkjdLrjPu4/Lt3/lxxb9OKh7Th5uyBLfA9OTZB2Ty1XLesK8
         eTTHaEP0OxcXHkPN9uxURZzTxIzBHxPO2Otb7yg1w6GjzIwdKIy6foFXcwB6nn3s/4Dn
         wCLA==
X-Gm-Message-State: AOAM530NXwEQg/5ztVprp2wLjKgzUlynefekXfbDRh6Xg7sOBJi4PJ98
        J1+IIuzc8L+1hRGQim3Cxj96hnAC+ssOzJeMTdA=
X-Google-Smtp-Source: ABdhPJxUJaNRd6w2vd96JNTLSzhfnTfzZ4d/uk/tfTMYfM1NysI5eXJLJd2A/XyGy5NjR1kT0oZYZF1yQKTHUs51mX4=
X-Received: by 2002:a05:6830:165a:: with SMTP id h26mr2336373otr.301.1632250618522;
 Tue, 21 Sep 2021 11:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com> <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch> <YUoFFXtWFAhLvIoH@kroah.com> <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch>
In-Reply-To: <YUocuMM4/VKzNMXq@lunn.ch>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 21 Sep 2021 20:56:47 +0200
Message-ID: <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 7:56 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > The existing code attempts to "enforce" device links where the
> > supplier is a direct ancestor of the consumer (e.g. its parent), which
> > is questionable by itself (why do that?)
>
> In this case, we have an Ethernet switch as the parent device. It
> registers an interrupt controller, to the interrupt subsystem. It also
> registers an MDIO controller to the MDIO subsystem. The MDIO subsystem
> finds the Ethernet PHYs on the MDIO bus, and registers the PHYs to the
> PHY subsystem.
>
> Device tree is then used to glue all the parts together. The PHY has
> an interrupt output which is connected to the interrupt controller,
> and a standard DT property is used to connect the two. The MACs in the
> switch are connected to the PHYs, and standard DT properties are used
> to connect them together. So we have a loop. But the driver model does
> not have a problem with this, at least not until fw_devlink came
> along. As soon as a resource is registered with a subsystem, it can be
> used. Where as fw_devlink seems to assume a resource cannot be used
> until the driver providing it completes probe.

It works at a device level, so it doesn't know about resources.  The
only information it has is of the "this device may depend on that
other device" type and it uses that information to figure out a usable
probe ordering for drivers.

> Now, we could ignore all these subsystems, re-invent the wheels inside
> the switch driver, and then not have suppliers and consumers at all,
> it is all internal. But that seems like a bad idea, more wheels, more
> bugs.
>
> So for me, the real fix is that fw_devlink learns that resources are
> available as soon as they are registered, not when the provider device
> completes probe.

Because it doesn't know about individual resources, it cannot really do that.

Also if the probe has already started, it may still return
-EPROBE_DEFER at any time in theory, so as a rule the dependency is
actually known to be satisfied when the probe has successfully
completed.

However, making children wait for their parents to complete probing is
generally artificial, especially in the cases when the children are
registered by the parent's driver.  So waiting should be an exception
in these cases, not a rule.
