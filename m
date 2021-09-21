Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5C74137AD
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhIUQhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:37:37 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:44649 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIUQhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:37:36 -0400
Received: by mail-ot1-f49.google.com with SMTP id h9-20020a9d2f09000000b005453f95356cso2371650otb.11;
        Tue, 21 Sep 2021 09:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccB1TqgPixwZOMJX7Se8DC8OOCVRgEfUWG7yso7W/K8=;
        b=JwSJlRsQP0FOL36BrYuAV0qM15O3vlQxzEwsAe1QrZwD78YOc9R7DIEUDm1t+HbAmn
         Nh5Baz0AWXA7V6NQ+O2+Ultvc3SQ6c0f5hKJCOb+cVcghFAUoMgAM2GNvLHoAd3v9ATP
         lLujX3Hrexvzloymd8wPZbdKCrSGc2or5WsyfWHC1zJS5DCL0nODn5KKQ+4rwWSwJlYY
         8M+lZjMdaC0IazArYkZ/YLtb+Wx2GFT3C+BfOKr2WZUl+V8ocjuHig2p6fab0BMtN6V+
         IdsjY20aG9IDY6pJ5zvsfs0B7wqL13MbY64QAoNsCUFG1elqf87N3zlq6ManBQDzMQ7U
         8Bgg==
X-Gm-Message-State: AOAM531N/oz+6xON0JAY/2mm6lkmIvjn54b4k8rxq+M9rV1eyZ/hXYgl
        a0tz+l6Sk7SlmDIiF/nr3iFwQJSchWy/khfoDMQ=
X-Google-Smtp-Source: ABdhPJzbsXQsAVFtgj2PK5PgTyv3N2S44oY7GakTwTV8/siQewoWIlssIu5Eft0pmceiGMbOr0Gyxjdz4mh3drq36iA=
X-Received: by 2002:a05:6830:165a:: with SMTP id h26mr1735296otr.301.1632242167433;
 Tue, 21 Sep 2021 09:36:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com> <20210915170940.617415-3-saravanak@google.com>
 <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch> <YUoFFXtWFAhLvIoH@kroah.com>
In-Reply-To: <YUoFFXtWFAhLvIoH@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 21 Sep 2021 18:35:56 +0200
Message-ID: <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
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

On Tue, Sep 21, 2021 at 6:15 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Sep 19, 2021 at 03:16:34AM +0200, Andrew Lunn wrote:
> > > > diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> > > > index 59828516ebaf..9f4ad719bfe3 100644
> > > > --- a/include/linux/fwnode.h
> > > > +++ b/include/linux/fwnode.h
> > > > @@ -22,10 +22,15 @@ struct device;
> > > >   * LINKS_ADDED:        The fwnode has already be parsed to add fwnode links.
> > > >   * NOT_DEVICE: The fwnode will never be populated as a struct device.
> > > >   * INITIALIZED: The hardware corresponding to fwnode has been initialized.
> > > > + * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
> > > > + *                          driver needs its child devices to be bound with
> > > > + *                          their respective drivers as soon as they are
> > > > + *                          added.
> > >
> > > The fact that this requires so much comment text here is a clear
> > > band-aid indication to me.
> >
> > This whole patchset is a band aid, but it is for stable, to fix things
> > which are currently broken. So we need to answer the question, is a
> > bad aid good enough for stable, with the assumption a real fix will
> > come along later?
>
> Fix it properly first, don't worry about stable.
>
> But what is wrong with this as-is?  What needs to be done that is not
> happening here that you feels still needs to be addressed?

The existing code attempts to "enforce" device links where the
supplier is a direct ancestor of the consumer (e.g. its parent), which
is questionable by itself (why do that?) and that's the source of the
underlying issue (self-inflicted circular dependencies that cause
devices to wait for a deferred probe forever) which this patchest
attempts to avoid by adding an extra flag to the driver core and
expecting specific drivers to mark their devices as "special".  And
that's "until we have a real fix".
