Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47460410712
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 16:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbhIROkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 10:40:21 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:42705 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhIROkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 10:40:18 -0400
Received: by mail-ot1-f52.google.com with SMTP id 67-20020a9d0449000000b00546e5a8062aso4892230otc.9;
        Sat, 18 Sep 2021 07:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gZJEYCVEBx8sBImAvvT2WV4qs0yfviZDu0/wBlsAicI=;
        b=qis65Hug5TVuUHnsvqvOhVn9BySyTfoBgBP8XiBNwZ1/3RHOIX/JlG5TYwfrE+Y8QS
         zHHucC8fZHNQcnrl1hiv5qSUAcV2svldFa11KNedC/KKCWmk4fcggjddvzGnTuOlM1dX
         PuDveAyU3soGu9iyaV0iGLZeJ9RGapQ6WnaJpGlyNiubz0Ztv940glOqYpv4DomsMQBz
         mDG7XkfK83IVbLG58USVwbV0ot+dhxoK1iB7ce9A4cnjBWHoUOUNRkwhh5R5E4xufyGy
         i2426vfMhJczHcHw3rdW3ikRteVhVSGBD/WMoCGRExd9TxiThZQT9PYyboLPrzP2gUqR
         sUrw==
X-Gm-Message-State: AOAM531LGyhsFGkSAZHF2QGAwcAwK+Lnz+IH3Z9aO14Tcvx/tRIiRRgh
        xtwpjc6C4Fe5SZNGrVDiFuGHNd/qPAPLzUwYIv8=
X-Google-Smtp-Source: ABdhPJzS6kQn2cn4I13oE+77M60tyFIAacrtZLX5Byjw07mAFfev8XsHX0wa+PG/1pvvnuyz77reTuJdKh+oSXcyvsg=
X-Received: by 2002:a05:6830:34b:: with SMTP id h11mr14254121ote.319.1631975934194;
 Sat, 18 Sep 2021 07:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com> <20210915170940.617415-2-saravanak@google.com>
In-Reply-To: <20210915170940.617415-2-saravanak@google.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Sat, 18 Sep 2021 16:38:42 +0200
Message-ID: <CAJZ5v0iM6U9_xuXjghDR+8upHA+SdZdmp2nGaOhaLTPR54BhmA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] driver core: fw_devlink: Improve handling of
 cyclic dependencies
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
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 7:09 PM Saravana Kannan <saravanak@google.com> wrote:
>
> When we have a dependency of the form:
>
> Device-A -> Device-C
>         Device-B
>
> Device-C -> Device-B
>
> Where,
> * Indentation denotes "child of" parent in previous line.
> * X -> Y denotes X is consumer of Y based on firmware (Eg: DT).
>
> We have cyclic dependency: device-A -> device-C -> device-B -> device-A
>
> fw_devlink current treats device-C -> device-B dependency as an invalid
> dependency and doesn't enforce it but leaves the rest of the
> dependencies as is.
>
> While the current behavior is necessary, it is not sufficient if the
> false dependency in this example is actually device-A -> device-C. When
> this is the case, device-C will correctly probe defer waiting for
> device-B to be added, but device-A will be incorrectly probe deferred by
> fw_devlink waiting on device-C to probe successfully. Due to this, none
> of the devices in the cycle will end up probing.
>
> To fix this, we need to go relax all the dependencies in the cycle like
> we already do in the other instances where fw_devlink detects cycles.
> A real world example of this was reported[1] and analyzed[2].
>
> [1] - https://lore.kernel.org/lkml/0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com/
> [2] - https://lore.kernel.org/lkml/CAGETcx8peaew90SWiux=TyvuGgvTQOmO4BFALz7aj0Za5QdNFQ@mail.gmail.com/
> Fixes: f9aa460672c9 ("driver core: Refactor fw_devlink feature")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/base/core.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index e65dd803a453..316df6027093 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1772,14 +1772,21 @@ static int fw_devlink_create_devlink(struct device *con,
>          * be broken by applying logic. Check for these types of cycles and
>          * break them so that devices in the cycle probe properly.
>          *
> -        * If the supplier's parent is dependent on the consumer, then
> -        * the consumer-supplier dependency is a false dependency. So,
> -        * treat it as an invalid link.
> +        * If the supplier's parent is dependent on the consumer, then the
> +        * consumer and supplier have a cyclic dependency. Since fw_devlink
> +        * can't tell which of the inferred dependencies are incorrect, don't
> +        * enforce probe ordering between any of the devices in this cyclic
> +        * dependency. Do this by relaxing all the fw_devlink device links in
> +        * this cycle and by treating the fwnode link between the consumer and
> +        * the supplier as an invalid dependency.
>          */
>         sup_dev = fwnode_get_next_parent_dev(sup_handle);
>         if (sup_dev && device_is_dependent(con, sup_dev)) {
> -               dev_dbg(con, "Not linking to %pfwP - False link\n",
> -                       sup_handle);
> +               dev_info(con, "Fixing up cyclic dependency with %pfwP (%s)\n",
> +                        sup_handle, dev_name(sup_dev));

Why not dev_dbg()?

Other than this, the change makes sense to me.

> +               device_links_write_lock();
> +               fw_devlink_relax_cycle(con, sup_dev);
> +               device_links_write_unlock();
>                 ret = -EINVAL;
>         } else {
>                 /*
> --
> 2.33.0.309.g3052b89438-goog
>
