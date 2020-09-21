Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5748D272532
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIUNQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:16:32 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44675 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgIUNQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:16:32 -0400
Received: by mail-oi1-f194.google.com with SMTP id 185so16850602oie.11;
        Mon, 21 Sep 2020 06:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55UvncN9emgCCrmaj1gu4vYImqn+PFIM+sAMY5GaIow=;
        b=KTdft9EKjB0kw3Nw+3ByxYKU+kGeTwppqnKGEOAG31zZeO5gTMLLGeGTJrjh1RzHar
         tJQe0ZK8ZI8Tc4HnvgYBJTv23Ha7wj3Gl7yPP/SDksUD8Jmu7rjOECP7PwVN+DG/6IfA
         JOZ0Bbq3Xgzb3anR006FdpBzHZyRuRbmGO/A0EZ2QWFnmR+8mLhomkddjgbuXvp55Son
         Ug+u4bg2dbe73kVvLHaStNaLv/Pcq37QpdEjHbxvnO5ivDDwBWEMs3JH9X6wUiLIsjKc
         73DWhG8V2aR1AfhHuQpbsmbySYbkYHbuCAGr3TyoIQa118KEMe/5Pl8ihRpoSPSu9sSe
         J5Zg==
X-Gm-Message-State: AOAM530WRmOtWJrxT6OGShHAOYrbLqt8d+FjCy2w22Wg30Ki9qKIiHff
        Z8ALta3M+I2WiSccS/NnA2x58IiJYc8RyzhYfQqZfHkaZzM=
X-Google-Smtp-Source: ABdhPJwBot/z+//SxjF/p/w/MPDhBPmStMLHpdg1bc++OIc5oQKRLtdTF88aoYZXnqoQmx6TfIOw90wDYUVKOp3L5vY=
X-Received: by 2002:aca:4441:: with SMTP id r62mr16539084oia.153.1600694191169;
 Mon, 21 Sep 2020 06:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200820094307.3977-1-ashiduka@fujitsu.com> <CAMuHMdXns4N=pUW=iq=CJz8dtNObt1jAOhAaxQ2UA4bTqQ9AwA@mail.gmail.com>
In-Reply-To: <CAMuHMdXns4N=pUW=iq=CJz8dtNObt1jAOhAaxQ2UA4bTqQ9AwA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Sep 2020 15:16:19 +0200
Message-ID: <CAMuHMdWxNHKUX+4DRZZMjvN0CdRu98SV4QTvgFokeFDu4vJfJA@mail.gmail.com>
Subject: Re: [PATCH v3] ravb: Fixed to be able to unload modules
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 11:31 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Aug 20, 2020 at 2:55 PM Yuusuke Ashizuka <ashiduka@fujitsu.com> wrote:
> > When this driver is built as a module, I cannot rmmod it after insmoding
> > it.
> > This is because that this driver calls ravb_mdio_init() at the time of
> > probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
> > after that.
> > Therefore, even if ifup is not performed, the driver is in use and rmmod
> > cannot be performed.
> >
> > $ lsmod
> > Module                  Size  Used by
> > ravb                   40960  1
> > $ rmmod ravb
> > rmmod: ERROR: Module ravb is in use
> >
> > Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
> > rmmod is possible in the ifdown state.
> >
> > Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> > Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> > Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
>
> Thanks for your patch, which is now commit 1838d6c62f578366 ("ravb:
> Fixed to be able to unload modules") in v5.9-rc4 (backported to stable
> v4.4, v4.9, v4.14, v4.19, v5.4, and v5.8).
>
> This is causing a regression during resume from s2idle/s2ram on (at
> least) Salvator-X(S) and Ebisu.  Reverting that commit fixes this.
>
> During boot, the Micrel PHY is detected correctly:
>
>     Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
> PHY driver [Micrel KSZ9031 Gigabit PHY]
> (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=228)
>     ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

phy_device_register() calls device_add(), which is immediately bound to
the micrel driver.

> During resume, if CONFIG_MODULES=n, it falls back to the Generic PHY
> (case A):
>
>     Generic PHY e6800000.ethernet-ffffffff:00: attached PHY driver
> [Generic PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00,
> irq=POLL)
>     ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
>
> and Ethernet still works (degraded, due to polling).
>
> During resume, if CONFIG_MODULES=y, MDIO initialization fails (case B):
>
>     mdio_bus e6800000.ethernet-ffffffff:00: error -16 loading PHY
> driver module for ID 0x00221622
>     ravb e6800000.ethernet eth0: failed to initialize MDIO
>     PM: dpm_run_callback(): ravb_resume+0x0/0x1b8 returns -16
>     PM: Device e6800000.ethernet failed to resume: error -16
>
> and Ethernet no longer works.
>
> Case B happens because usermodehelper_disabled is set to UMH_DISABLED
> during system suspend, causing request_module() to return -EBUSY.
> Ignoring -EBUSY in phy_request_driver_module(), like was done for
> -ENOENT in commit 21e194425abd65b5 ("net: phy: fix issue with loading
> PHY driver w/o initramfs"), makes it fall back to the Generic PHY, cfr.
> case A.
>
> For case A, I haven't found out yet why it falls back to the Generic PHY.

During system suspend, defer_all_probes is set to true, to avoid drivers
being probed while suspended.  Hence phy_device_register() calling
device_add() merely adds the device, but does not probe it yet
(really_probe() returns early)"

   dpm_resume+0x128/0x4f8
     device_resume+0xcc/0x1b0
       dpm_run_callback+0x74/0x340
         ravb_resume+0x190/0x1b8
           ravb_open+0x84/0x770
             of_mdiobus_register+0x1e0/0x468
               of_mdiobus_register_phy+0x1b8/0x250
                 of_mdiobus_phy_device_register+0x178/0x1e8
                   phy_device_register+0x114/0x1b8
                     device_add+0x3d4/0x798
                       bus_probe_device+0x98/0xa0
                         device_initial_probe+0x10/0x18
                           __device_attach+0xe4/0x140
                             bus_for_each_drv+0x64/0xc8
                               __device_attach_driver+0xb8/0xe0
                                 driver_probe_device.part.11+0xc4/0xd8
                                   really_probe+0x32c/0x3b8


Hence registering PHY devices from a net_device's ndo_open() call back
must not be done.

I will send a formal revert later today.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
