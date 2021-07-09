Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777A93C26E4
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhGIPgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:36:31 -0400
Received: from mail-vk1-f171.google.com ([209.85.221.171]:40947 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbhGIPgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:36:31 -0400
Received: by mail-vk1-f171.google.com with SMTP id n201so2252459vke.7;
        Fri, 09 Jul 2021 08:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DoPuT2SFJPvTn4Vb1LqA16j520FXTA6Fs1ylMoMceo4=;
        b=oGXDMuNoVcL8UEHVS6pcVzdWj9+YnyRRnWWOdejd66x791Vo4GBjyDgCJuqhELafPu
         MXgYTVqf0teUfr88oqGoJyL+mcgOzWy3f/uJrJ027Q3SaUFC8Sj+Y8o1eZ0EbpN21/5c
         /w34B5T0B+cKrW9iIGP1p+zeDemPt+v9dOKBsHTni83KpWBau+rMyfQtgnZbqXtC6BYg
         G5iCksiWuFUKyei/YLhJT4XKeSIUyUkiVvY3r5RdyKBlcQjaFQf8Nnhfs1xPQon0yNJK
         44AXGdgV2lh+CPbkqa8aHf8/OKQfnMSjNeAHlXGZAgzU0K8kgbxScejE9iSezdZkq/DT
         lJ7g==
X-Gm-Message-State: AOAM532GJ8VjkQu4n9SirPdQiiSLuXde0DMZRf/MEA8zsFbomUEOQ1zh
        WwYIQR5ifOQ68b/DA5AzdoTdmNyESi/Kc5L33QQr8JprwWE=
X-Google-Smtp-Source: ABdhPJzG67t1QPv25IAZQDVYNpREgGZALa5Tg87sIcXeWoh09FUS5YLSzo4KAV/2r3BzNFFmgEN1t9rxvBPC57/DWL4=
X-Received: by 2002:a05:6122:1207:: with SMTP id v7mr33344291vkc.2.1625844827374;
 Fri, 09 Jul 2021 08:33:47 -0700 (PDT)
MIME-Version: 1.0
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 9 Jul 2021 17:33:36 +0200
Message-ID: <CAMuHMdXno2OUHqsAfO0z43JmGkFehD+FJ2dEjEsr_P53oAAPxA@mail.gmail.com>
Subject: PHY reset may still be asserted during MDIO probe
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm investigating a network failure after kexec on the Renesas Koelsch
and Salvator-XS development boards, using the sh-eth or ravb driver.

During normal boot, the Ethernet interface is working fine:

    libphy: get_phy_c22_id:814: sh_mii: mdiobus_read() MII_PHYSID1 returned 34
    libphy: get_phy_c22_id:824: sh_mii: mdiobus_read() MII_PHYSID2 returned 5431
    libphy: get_phy_c22_id:832: sh_mii: phy_id = 0x00221537
    libphy: get_phy_device:895: sh_mii: get_phy_c22_id() returned 0
    fwnode_mdiobus_register_phy:109: sh_mii: get_phy_device() returned (ptrval)
    fwnode_mdiobus_phy_device_register:46: sh_mii: fwnode_irq_get() returned 191
    libphy: mdiobus_register_gpiod:48: mdiodev->reset_gpio = (ptrval)
    mdio_bus ee700000.ethernet-ffffffff:01:
mdiobus_register_device:88: assert MDIO reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
    mdio_bus ee700000.ethernet-ffffffff:01: phy_device_register:931:
deassert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 0)
    Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_probe:3026:
deassert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 0)
    fwnode_mdiobus_phy_device_register:75: sh_mii:
phy_device_register() returned 0
    fwnode_mdiobus_register_phy:137: sh_mii:
fwnode_mdiobus_phy_device_register() returned 0
    of_mdiobus_register:188: of_mdiobus_register_phy(sh_mii,
/soc/ethernet@ee700000/ethernet-phy@1, 1) returned 0
    sh-eth ee700000.ethernet eth0: Base address at 0xee700000,
2e:09:0a:00:6d:85, IRQ 126.

When using kexec, the PHY reset is asserted before starting the
new kernel:

    Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_detach:1759:
assert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
    kexec_core: Starting new kernel
    Bye!

The new kernel fails to probe the PHY, as the PHY reset is still
asserted:

    libphy: get_phy_c22_id:814: sh_mii: mdiobus_read() MII_PHYSID1
returned 65535
    libphy: get_phy_c22_id:824: sh_mii: mdiobus_read() MII_PHYSID2
returned 65535
    libphy: get_phy_c22_id:832: sh_mii: phy_id = 0xffffffff
    libphy: get_phy_device:895: sh_mii: get_phy_c22_id() returned -19
    fwnode_mdiobus_register_phy:109: sh_mii: get_phy_device() returned -ENODEV
    of_mdiobus_register:188: of_mdiobus_register_phy(sh_mii,
/soc/ethernet@ee700000/ethernet-phy@1, 1) returned -19
    mdio_bus ee700000.ethernet-ffffffff: MDIO device at address 1 is missing.
    sh-eth ee700000.ethernet eth0: Base address at 0xee700000,
2e:09:0a:00:6d:85, IRQ 126.

This issue can also be reproduced using unbind:

    # echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/unbind
    sh-eth ee700000.ethernet eth0: Link is Down
    Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_detach:1759:
assert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
    Micrel KSZ8041RNLI ee700000.ethernet-ffffffff:01: phy_remove:3120:
assert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)
    mdio_bus ee700000.ethernet-ffffffff:01: phy_device_remove:974:
assert PHY reset
    libphy: mdio_device_reset:124: calling gpiod_set_value_cansleep(..., 1)

and bind:

    # echo ee700000.ethernet > /sys/bus/platform/drivers/sh-eth/bind
    (same log as kexec boot)

I think fwnode_mdiobus_register_phy() should do the PHY reset (assert +
deassert) before calling get_phy_device(), but currently that happens
in phy_device_register(), which is called later.

Thanks for your comments!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
