Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F73EF82F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 04:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhHRCr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 22:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbhHRCrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 22:47:25 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A7CC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:46:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i8so2327100ybt.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XNIAHafnlugGFWLCEZD2k7I4mrhZin69jNflZduOntw=;
        b=tPZ5FoT4ByGL3QaXvlhoZv5zx3JBTxSsHdErUvIaq4nOIaZ8HtckKuYgzSs5enR3qD
         yS7nR8732HQ3MC0fwEbfbRNSN130wU5VJin1eW+CICgdPr/VmQdk+dxGHCRHeCoDjpEg
         Pdj+50Njm2W7mjrPRufhQeWIthVUNkTfHYfnwp2TtRmqp/l1ZXUx+4V7uKtiuTJeAoKt
         oJRLWj/n6XKVTLiVWUuuf9KljFXLSqd+hevvOHhY+mCD9MC48PadqCG162L+sqdvLGvS
         KzzWZTlyD/HR2ehigO4Y3DUR0MXUzGsMtXPpsU1RoTMfA17iUD3JiH6HqOV0B9DmsOZ2
         uobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XNIAHafnlugGFWLCEZD2k7I4mrhZin69jNflZduOntw=;
        b=SF+ApyXcgXIHOCBYFJAdBF25X9cq46DiwDkZDDCUbqNH18fbwiLWBARWmqwFb4Cy9X
         F2PL9W0yFUi1HPgz/Bzk5FSkyDsvVyVRAJV8cAHQDGS0W6Ub1r9gVuSWagu4YnP4GG+A
         lJ6RN3Xqyq9XjpErvugOu3nr2HNR6tl+3yp+XoN7FOkddLI8kbHVm1kVHJ9eMFooVWHc
         9SRUqfR5i7PZ2eTYjefUzIZogRcy2VqvgGxzJK6C7XW0REytwt08rXs7xYKTlPznV6Ua
         2tc+pKqV6ivVon7MT2J6n5P7kSFS/qsTeHkbqHCy3H+ytFd0k3jI04OAAI1cuWfbrSic
         EGzA==
X-Gm-Message-State: AOAM532MRNGmGDK8/IH2iAeazmGcUDLQxN/H3cCIsAV/u5U8bYD7Eb6O
        e5Mmk63nUGzAZus7IYCswtZqZ7ikqdtp6a+q9heDRg==
X-Google-Smtp-Source: ABdhPJzbwkSJJUes16UJuRVjAcolQE0/dFH0263hcHBJJTJSUp8Uhve6Jyjw2MdMAgcw6FMa7wgrIB6LV2YMFVHFTso=
X-Received: by 2002:a25:804:: with SMTP id 4mr7907865ybi.346.1629254810296;
 Tue, 17 Aug 2021 19:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
In-Reply-To: <20210817223101.7wbdofi7xkeqa2cp@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 17 Aug 2021 19:46:14 -0700
Message-ID: <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 3:31 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Alvin,
>
> On Tue, Aug 17, 2021 at 09:25:28PM +0000, Alvin =C5=A0ipraga wrote:
> > I have an observation that's slightly out of the scope of your patch,
> > but I'll post here on the off chance that you find it relevant.
> > Apologies if it's out of place.
> >
> > Do these integrated NXP PHYs use a specific PHY driver, or do they just
> > use the Generic PHY driver?
>
> They refuse to probe at all with the Generic PHY driver. I have been
> caught off guard a few times now when I had a kernel built with
> CONFIG_NXP_C45_TJA11XX_PHY=3Dn and their probing returns -22 in that case=
.
>
> > If the former is the case, do you experience that the PHY driver fails
> > to get probed during mdiobus registration if the kernel uses
> > fw_devlink=3Don?
>
> I don't test with "fw_devlink=3Don" in /proc/cmdline, this is the first
> time I do it. It behaves exactly as you say.
>
> >
> > In my case I am writing a new subdriver for realtek-smi, a DSA driver
> > which registers an internal MDIO bus analogously to sja1105, which is
> > why I'm asking. I noticed a deferred probe of the PHY driver because th=
e
> > supplier (ethernet-switch) is not ready - presumably because all of thi=
s
> > is happening in the probe of the switch driver. See below:
> >
> > [   83.653213] device_add:3270: device: 'SMI-0': device_add
> > [   83.653905] device_pm_add:136: PM: Adding info for No Bus:SMI-0
> > [   83.654055] device_add:3270: device: 'platform:ethernet-switch--mdio=
_bus:SMI-0': device_add
> > [   83.654224] device_link_add:843: mdio_bus SMI-0: Linked as a sync st=
ate only consumer to ethernet-switch
> > [   83.654291] libphy: SMI slave MII: probed
> > ...
> > [   83.659809] device_add:3270: device: 'SMI-0:00': device_add
> > [   83.659883] bus_add_device:447: bus: 'mdio_bus': add device SMI-0:00
> > [   83.659970] device_pm_add:136: PM: Adding info for mdio_bus:SMI-0:00
> > [   83.660122] device_add:3270: device: 'platform:ethernet-switch--mdio=
_bus:SMI-0:00': device_add
> > [   83.660274] devices_kset_move_last:2701: devices_kset: Moving SMI-0:=
00 to end of list
> > [   83.660282] device_pm_move_last:203: PM: Moving mdio_bus:SMI-0:00 to=
 end of list
> > [   83.660293] device_link_add:859: mdio_bus SMI-0:00: Linked as a cons=
umer to ethernet-switch
> > [   83.660350] __driver_probe_device:736: bus: 'mdio_bus': __driver_pro=
be_device: matched device SMI-0:00 with driver RTL8365MB-VC Gigabit Etherne=
t
> > [   83.660365] device_links_check_suppliers:1001: mdio_bus SMI-0:00: pr=
obe deferral - supplier ethernet-switch not ready
> > [   83.660376] driver_deferred_probe_add:138: mdio_bus SMI-0:00: Added =
to deferred list
>
> So it's a circular dependency? Switch cannot finish probing because it
> cannot connect to PHY, which cannot probe because switch has not
> finished probing, which....

Hi Vladimir/Alvin,

If there's a cyclic dependency between two devices, then fw_devlink=3Don
is smart enough to notice that. Once it notices a cycle, it knows that
it can't tell which one is the real dependency and which one is the
false dependency and so stops enforcing ordering between the devices
in the cycle.

But fw_devlink doesn't understand all the properties yet. Just most of
them and I'm always trying to add more. So when it only understands
the property that's causing the false dependency but not the property
that causes the real dependency, it can cause issues like this where
fw_devlink=3Don enforces the false dependency and the driver/code
enforces the real dependency. These are generally easy to fix -- you
just need to teach fw_devlink how to parse more properties.

This is just a preliminary analysis since I don't have all the info
yet -- so I could be wrong. With that said, I happened to be working
on adding fw_devlink support for phy-handle property and I think it
should fix your issue with fw_devlink=3Don. Can you give [1] a shot?

If it doesn't fix it, can one of you please point me to an upstream
dts (not dtsi) file for a platform in which you see this issue? And
ideally also the DT nodes and their drivers that are involved in this
cycle? With that info, I should be able to root cause this if the
patch above doesn't already fix it.

>
> So how is it supposed to be solved then? Intuitively the 'mdio_bus SMI-0:=
00'
> device should not be added to the deferred list, it should have everythin=
g
> it needs right now (after all, it works without fw_devlink). No?
>
> It might be the late hour over here too, but right now I just don't
> know. Let me add Saravana to the discussion too, he made an impressive
> analysis recently on a PHY probing issue with mdio-mux,

Lol, thanks for the kind words.

> so the PHY
> library probing dependencies should still be fresh in his mind, maybe he
> has an idea what's wrong.

[1] - https://lore.kernel.org/lkml/20210818021717.3268255-1-saravanak@googl=
e.com/T/#u

Thanks,
Saravana
