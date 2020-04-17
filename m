Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786701AE1F6
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgDQQPY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Apr 2020 12:15:24 -0400
Received: from mailoutvs15.siol.net ([185.57.226.206]:45694 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728105AbgDQQPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:15:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 7E3B3524BB0;
        Fri, 17 Apr 2020 18:15:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 8zL-mRWm0sXI; Fri, 17 Apr 2020 18:15:19 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 1358A524C5F;
        Fri, 17 Apr 2020 18:15:19 +0200 (CEST)
Received: from jernej-laptop.localnet (cpe-194-152-20-232.static.triera.net [194.152.20.232])
        (Authenticated sender: jernej.skrabec@siol.net)
        by mail.siol.net (Postfix) with ESMTPA id 03505524C64;
        Fri, 17 Apr 2020 18:15:17 +0200 (CEST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@siol.net>
To:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     mripard@kernel.org, wens@csie.org, lee.jones@linaro.org,
        linux@armlinux.org.uk, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] net: phy: Add support for AC200 EPHY
Date:   Fri, 17 Apr 2020 18:15:17 +0200
Message-ID: <6176364.4vTCxPXJkl@jernej-laptop>
In-Reply-To: <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net> <20200416185758.1388148-3-jernej.skrabec@siol.net> <0340f85c-987f-900b-53c8-d29b4672a8fa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dne četrtek, 16. april 2020 ob 22:18:52 CEST je Heiner Kallweit napisal(a):
> On 16.04.2020 20:57, Jernej Skrabec wrote:
> > AC200 MFD IC supports Fast Ethernet PHY. Add a driver for it.
> > 
> > Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> > ---
> > 
> >  drivers/net/phy/Kconfig  |   7 ++
> >  drivers/net/phy/Makefile |   1 +
> >  drivers/net/phy/ac200.c  | 206 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 214 insertions(+)
> >  create mode 100644 drivers/net/phy/ac200.c
> > 
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 3fa33d27eeba..16af69f69eaf 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -288,6 +288,13 @@ config ADIN_PHY
> > 
> >  	  - ADIN1300 - Robust,Industrial, Low Latency 10/100/1000 Gigabit
> >  	  
> >  	    Ethernet PHY
> > 
> > +config AC200_PHY
> > +	tristate "AC200 EPHY"
> > +	depends on NVMEM
> > +	depends on OF
> > +	help
> > +	  Fast ethernet PHY as found in X-Powers AC200 multi-function 
device.
> > +
> > 
> >  config AMD_PHY
> >  
> >  	tristate "AMD PHYs"
> >  	---help---
> > 
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index 2f5c7093a65b..b0c5b91900fa 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -53,6 +53,7 @@ obj-$(CONFIG_SFP)		+= sfp.o
> > 
> >  sfp-obj-$(CONFIG_SFP)		+= sfp-bus.o
> >  obj-y				+= $(sfp-obj-y) $(sfp-obj-m)
> > 
> > +obj-$(CONFIG_AC200_PHY)		+= ac200.o
> > 
> >  obj-$(CONFIG_ADIN_PHY)		+= adin.o
> >  obj-$(CONFIG_AMD_PHY)		+= amd.o
> >  aquantia-objs			+= aquantia_main.o
> > 
> > diff --git a/drivers/net/phy/ac200.c b/drivers/net/phy/ac200.c
> > new file mode 100644
> > index 000000000000..3d7856ff8f91
> > --- /dev/null
> > +++ b/drivers/net/phy/ac200.c
> > @@ -0,0 +1,206 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/**
> > + * Driver for AC200 Ethernet PHY
> > + *
> > + * Copyright (c) 2020 Jernej Skrabec <jernej.skrabec@siol.net>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/mfd/ac200.h>
> > +#include <linux/nvmem-consumer.h>
> > +#include <linux/of.h>
> > +#include <linux/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define AC200_EPHY_ID			0x00441400
> > +#define AC200_EPHY_ID_MASK		0x0ffffff0
> > +
> 
> You could use PHY_ID_MATCH_MODEL() here.

Hm... This doesn't work with dynamically allocated memory, right?

Best regards,
Jernej


