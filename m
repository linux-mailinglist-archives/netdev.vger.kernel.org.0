Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8013D26C0A4
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 11:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgIPJc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 05:32:26 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35159 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgIPJcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 05:32:09 -0400
Received: by mail-ot1-f67.google.com with SMTP id o6so6092588ota.2;
        Wed, 16 Sep 2020 02:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gO1cQYnIv6MCy6jmh/NLJk3GH4hMeS1DLmzxepSLtGM=;
        b=abSTZ0MaKLaRTMchdXSXttySB2E3IwUOC3VYtoMR9KmVQSsKsWmyt4/ubwotREUhXR
         kqLKya3QpKGshqQT1pyUox2ARwJH6s97hk04fRb/5oDHMQLnBI9hCKnWFgAzwW2jQ0XZ
         4rXWg1sYzj/aNKIrfwJ3PSlVUkEaEbLhZeGZ8vBCV69MBvwxVlVupUoIR5pRZsioM48j
         gxmlk7JVsI7PJRHAyF3fcP73kFWBYDnGLM9DEihyjqyHXbFP0LsqI61cji6VdPKpUgil
         SR0TydHxoC7vy5CPQ3kt0AvTKEZE3Foyvjbi2npvz1u7fdM/kElb5+bcoKwlZgMtsvLM
         XQYw==
X-Gm-Message-State: AOAM531G4Jc4yxcwws0jFMyVYzhAq5pugKmvpMMdlUBHU14Nzxd4+htk
        hZkw1ycaj52xGQ1lBOwbHP+PVsdxQqv7E3OKIqQ=
X-Google-Smtp-Source: ABdhPJwhDnkwCr9zt3bOfU6s/ZJWMCNXhnDAAzPnyJvN+ilTJMp4LBOFeBI2qOENQxSb53FbTLQFuE979X4DNea2iBs=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr15568721oth.145.1600248728028;
 Wed, 16 Sep 2020 02:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200820094307.3977-1-ashiduka@fujitsu.com>
In-Reply-To: <20200820094307.3977-1-ashiduka@fujitsu.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 16 Sep 2020 11:31:56 +0200
Message-ID: <CAMuHMdXns4N=pUW=iq=CJz8dtNObt1jAOhAaxQ2UA4bTqQ9AwA@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ashizuka-san,

On Thu, Aug 20, 2020 at 2:55 PM Yuusuke Ashizuka <ashiduka@fujitsu.com> wrote:
> When this driver is built as a module, I cannot rmmod it after insmoding
> it.
> This is because that this driver calls ravb_mdio_init() at the time of
> probe, and module->refcnt is incremented by alloc_mdio_bitbang() called
> after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod
> cannot be performed.
>
> $ lsmod
> Module                  Size  Used by
> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
>
> Call ravb_mdio_init() at open and free_mdio_bitbang() at close, thereby
> rmmod is possible in the ifdown state.
>
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Thanks for your patch, which is now commit 1838d6c62f578366 ("ravb:
Fixed to be able to unload modules") in v5.9-rc4 (backported to stable
v4.4, v4.9, v4.14, v4.19, v5.4, and v5.8).

This is causing a regression during resume from s2idle/s2ram on (at
least) Salvator-X(S) and Ebisu.  Reverting that commit fixes this.

During boot, the Micrel PHY is detected correctly:

    Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
PHY driver [Micrel KSZ9031 Gigabit PHY]
(mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=228)
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

During resume, if CONFIG_MODULES=n, it falls back to the Generic PHY
(case A):

    Generic PHY e6800000.ethernet-ffffffff:00: attached PHY driver
[Generic PHY] (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00,
irq=POLL)
    ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

and Ethernet still works (degraded, due to polling).

During resume, if CONFIG_MODULES=y, MDIO initialization fails (case B):

    mdio_bus e6800000.ethernet-ffffffff:00: error -16 loading PHY
driver module for ID 0x00221622
    ravb e6800000.ethernet eth0: failed to initialize MDIO
    PM: dpm_run_callback(): ravb_resume+0x0/0x1b8 returns -16
    PM: Device e6800000.ethernet failed to resume: error -16

and Ethernet no longer works.

Case B happens because usermodehelper_disabled is set to UMH_DISABLED
during system suspend, causing request_module() to return -EBUSY.
Ignoring -EBUSY in phy_request_driver_module(), like was done for
-ENOENT in commit 21e194425abd65b5 ("net: phy: fix issue with loading
PHY driver w/o initramfs"), makes it fall back to the Generic PHY, cfr.
case A.

For case A, I haven't found out yet why it falls back to the Generic PHY.

Thanks for your comments!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
