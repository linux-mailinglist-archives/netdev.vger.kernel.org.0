Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EAD410739
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 17:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236670AbhIRPEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 11:04:43 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:42910 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231336AbhIRPEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 11:04:42 -0400
Received: by mail-oi1-f176.google.com with SMTP id bi4so18274369oib.9;
        Sat, 18 Sep 2021 08:03:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qF9YJTFb2QTzE7mXJCIub9h+/PjhBuWOCyut5wCaiw4=;
        b=DHMFNKrfDuVUoL0UaS9x2P/k2/CJ7/aZJvZSzHbgslx7ukJfgUqjMdjjwmsXBDoFJp
         ar+/8LAW63lgzV8wC4GUPgRS0zfuNH5n4uOxGrZgM8lk23ib/CWEc8UiQbIxEjie655N
         q5ISj86kzd+kJ5PrTku5U4YI7wYuDRJyX26KLaVHEbQ2uCRkhtAJTKKmn+/857rAykPP
         z1Fvxg6OHuq0LePaMUlr9OAxUpKPhs7EpjuDYDfe4iToxbG856mwIxgQW1WipjZJIHAv
         9iATy5SSZZy3y/eQdC2DJDdasM1jcHwmG0NK9duRnykeNA11g87WlYLet8tOp36K8W3A
         byUw==
X-Gm-Message-State: AOAM533o4+lBekDbcYiy3dwxyKteRz8Um4uudphnUNgps0FUlTjln0KK
        1lDwNJKoHkhHB7TU3idRLqZcRMVfoaVGH9RKSo0=
X-Google-Smtp-Source: ABdhPJyKbRzDSF0qrXYIZqR0WY+s6cR+uKcKghvR41DFiSP6UPKnFqNzF4feaQpYNwh+35GtPJNeeAERuSz0et35sw4=
X-Received: by 2002:a05:6808:10ce:: with SMTP id s14mr17623306ois.157.1631977397972;
 Sat, 18 Sep 2021 08:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com> <20210915170940.617415-3-saravanak@google.com>
In-Reply-To: <20210915170940.617415-3-saravanak@google.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sat, 18 Sep 2021 17:03:06 +0200
Message-ID: <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
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

On Wed, Sep 15, 2021 at 7:09 PM Saravana Kannan <saravanak@google.com> wrote:
>
> If a parent device is also a supplier to a child device, fw_devlink=on by
> design delays the probe() of the child device until the probe() of the
> parent finishes successfully.
>
> However, some drivers of such parent devices (where parent is also a
> supplier) expect the child device to finish probing successfully as soon as
> they are added using device_add() and before the probe() of the parent
> device has completed successfully. One example of such a case is discussed
> in the link mentioned below.
>
> Add a flag to make fw_devlink=on not enforce these supplier-consumer
> relationships, so these drivers can continue working.
>
> Link: https://lore.kernel.org/netdev/CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com/
> Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/core.c    | 19 +++++++++++++++++++
>  include/linux/fwnode.h | 11 ++++++++---
>  2 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 316df6027093..21d4cb5d3767 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1722,6 +1722,25 @@ static int fw_devlink_create_devlink(struct device *con,
>         struct device *sup_dev;
>         int ret = 0;
>
> +       /*
> +        * In some cases, a device P might also be a supplier to its child node
> +        * C. However, this would defer the probe of C until the probe of P
> +        * completes successfully. This is perfectly fine in the device driver
> +        * model. device_add() doesn't guarantee probe completion of the device
> +        * by the time it returns.

That's right.

However, I don't quite see a point in device links where the supplier
is a direct ancestor of the consumer.  From the PM perspective they
are simply redundant and I'm not sure about any other use cases where
they aren't.

So what's the reason to add them in the first place?

> +        *
> +        * However, there are a few drivers that assume C will finish probing
> +        * as soon as it's added and before P finishes probing. So, we provide
> +        * a flag to let fw_devlink know not to delay the probe of C until the
> +        * probe of P completes successfully.

Well, who's expected to set that flag and when?  This needs to be
mentioned here IMO.

> +        *
> +        * When such a flag is set, we can't create device links where P is the
> +        * supplier of C as that would delay the probe of C.
> +        */
> +       if (sup_handle->flags & FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD &&
> +           fwnode_is_ancestor_of(sup_handle, con->fwnode))
> +               return -EINVAL;
> +
>         sup_dev = get_dev_from_fwnode(sup_handle);
>         if (sup_dev) {
>                 /*
> diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
> index 59828516ebaf..9f4ad719bfe3 100644
> --- a/include/linux/fwnode.h
> +++ b/include/linux/fwnode.h
> @@ -22,10 +22,15 @@ struct device;
>   * LINKS_ADDED:        The fwnode has already be parsed to add fwnode links.
>   * NOT_DEVICE: The fwnode will never be populated as a struct device.
>   * INITIALIZED: The hardware corresponding to fwnode has been initialized.
> + * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
> + *                          driver needs its child devices to be bound with
> + *                          their respective drivers as soon as they are
> + *                          added.

The fact that this requires so much comment text here is a clear
band-aid indication to me.

>   */
> -#define FWNODE_FLAG_LINKS_ADDED                BIT(0)
> -#define FWNODE_FLAG_NOT_DEVICE         BIT(1)
> -#define FWNODE_FLAG_INITIALIZED                BIT(2)
> +#define FWNODE_FLAG_LINKS_ADDED                        BIT(0)
> +#define FWNODE_FLAG_NOT_DEVICE                 BIT(1)
> +#define FWNODE_FLAG_INITIALIZED                        BIT(2)
> +#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD   BIT(3)
>
>  struct fwnode_handle {
>         struct fwnode_handle *secondary;
> --
> 2.33.0.309.g3052b89438-goog
>
