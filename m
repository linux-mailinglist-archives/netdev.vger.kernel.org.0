Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D294A7249
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344660AbiBBNya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:54:30 -0500
Received: from mail-yb1-f179.google.com ([209.85.219.179]:46676 "EHLO
        mail-yb1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344688AbiBBNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:54:22 -0500
Received: by mail-yb1-f179.google.com with SMTP id p5so61129876ybd.13;
        Wed, 02 Feb 2022 05:54:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KF5lsBDVHuWJh2maqXVzoYWsWumISdu8x7CYgh0GO0Q=;
        b=6Ni0Lc89It5hRO69mB8xAhYoK7z6qnU61195oBLF93ae2NvjVkG2amD4k7cdFwyFFg
         4Ezd3Kh1hm7MWmmdAfckQpuOf067rNiLndGv+eclxdT1TsABTdtukmFVvBytZ8bGiOjU
         mZlrb8499HMqtN3GLCNrLKhHYpYrmS6ReDZYKzU1+AX4OeNrneTYDJMR3jZ3n2z+yfsM
         uYmIhMnnJbK93Q5IY9j1BaCcFYBLjRSZmP7yMj+NK3U9GHnxzrQ+V2gPD1Xd/pvulM95
         cEEz37hxfLX301ZJPFNVFFMc/OtxW52ESMe9F/BFnqgK4QVfW1UwzLTL+64qt8FEgPuC
         PeCA==
X-Gm-Message-State: AOAM530Pi9iZOFGDoTe0qKsIA2bTA0wK0vh9WKJKZz6ME9cDbxr5hqCc
        alzrIEcmYGU38uNnw+HTXMqIj/PKJ66Oqio3h14=
X-Google-Smtp-Source: ABdhPJwWl3u2e+Brk6HodWZLquLvBayn7SaGfS0dXze63T7PPuhBAJCBWwxxLMTEXAdOZ8xcWSNxT9/rLQoMWzEnnR0=
X-Received: by 2002:a05:6902:1507:: with SMTP id q7mr44563918ybu.343.1643810062027;
 Wed, 02 Feb 2022 05:54:22 -0800 (PST)
MIME-Version: 1.0
References: <11918902.O9o76ZdvQC@kreacher> <20220201201418.67ae9005@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220201201418.67ae9005@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 2 Feb 2022 14:54:11 +0100
Message-ID: <CAJZ5v0jQ3u-sbF8F1kSDOFbPoG24yOBSADWvwp0Tgmysm8CuFA@mail.gmail.com>
Subject: Re: [PATCH v2] drivers: net: Replace acpi_bus_get_device()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        netdev <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 5:20 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 01 Feb 2022 20:58:36 +0100 Rafael J. Wysocki wrote:
> > -     struct bgx *bgx = context;
> > +     struct acpi_device *adev = acpi_fetch_acpi_dev(handle);
> >       struct device *dev = &bgx->pdev->dev;
> > -     struct acpi_device *adev;
> > +     struct bgx *bgx = context;
>
> Compiler says you can't move bgx before dev.

Right, I've obviously missed that.

> Venturing deeper into the bikesheeding territory but I'd leave the
> variable declarations be and move init of adev before the check.
> Matter of preference but calling something that needs to be error
> checked in variable init breaks the usual
>
>         ret = func(some, arguments);
>         if (ret)
>                 goto explosions;
>
> flow.

It doesn't for me, but let me send a v3.

Thanks!

> > -     if (acpi_bus_get_device(handle, &adev))
> > +     if (!adev)
> >               goto out;
