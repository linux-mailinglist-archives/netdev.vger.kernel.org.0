Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E23AC115FA
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEBJFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:05:43 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:46782 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfEBJFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:05:43 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 3720F4725;
        Thu,  2 May 2019 11:05:40 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id d6160ae8;
        Thu, 2 May 2019 11:05:38 +0200 (CEST)
Date:   Thu, 2 May 2019 11:05:38 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Alban Bedel <albeu@free.fr>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>
Subject: Re: [PATCH v2 1/4] of_net: Add NVMEM support to of_get_mac_address
Message-ID: <20190502090538.GD346@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1556456002-13430-1-git-send-email-ynezz@true.cz>
 <1556456002-13430-2-git-send-email-ynezz@true.cz>
 <20190501201925.GA15495@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501201925.GA15495@bogus>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob Herring <robh@kernel.org> [2019-05-01 15:19:25]:

Hi Rob,

> > +	struct property *pp;

...

> > +	pp = kzalloc(sizeof(*pp), GFP_KERNEL);
> > +	if (!pp)
> > +		return NULL;
> > +
> > +	pp->name = "nvmem-mac-address";
> > +	pp->length = ETH_ALEN;
> > +	pp->value = kmemdup(mac, ETH_ALEN, GFP_KERNEL);
> > +	if (!pp->value || of_add_property(np, pp))
> > +		goto free;
> 
> Why add this to the DT?

I've just carried it over from v1 ("of_net: add mtd-mac-address support to
of_get_mac_address()")[1] as nobody objected about this so far. 

Honestly I don't know if it's necessary to have it, but so far address,
mac-address and local-mac-address properties provide this DT nodes, so I've
simply thought, that it would be good to have it for MAC address from NVMEM as
well in order to stay consistent.

Just FYI, my testing ar9331_8dev_carambola2.dts[2] currently produces
following runtime DT content:

 root@OpenWrt:/# find /sys/firmware/devicetree/ -name *nvmem* -o -name *addr@*
 /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partition@ff0000/nvmem-cells
 /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partition@ff0000/nvmem-cells/eth-mac-addr@0
 /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partition@ff0000/nvmem-cells/eth-mac-addr@6
 /sys/firmware/devicetree/base/ahb/spi@1f000000/flash@0/partitions/partition@ff0000/nvmem-cells/wifi-mac-addr@1002
 /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-cells
 /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-mac-address
 /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-cell-names
 /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-cells
 /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-mac-address
 /sys/firmware/devicetree/base/ahb/eth@1a000000/nvmem-cell-names
 /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-cells
 /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-mac-address
 /sys/firmware/devicetree/base/ahb/eth@19000000/nvmem-cell-names

 root@OpenWrt:/# hexdump -C /sys/firmware/devicetree/base/ahb/wmac@18100000/nvmem-mac-address
 00000000  00 03 7f 11 52 da                                 |....R.|
 00000006

 root@OpenWrt:/# ip addr show wlan0
 4: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:03:7f:11:52:da brd ff:ff:ff:ff:ff:ff

1. https://patchwork.ozlabs.org/patch/1086628/
2. https://git.openwrt.org/?p=openwrt/staging/ynezz.git;a=blob;f=target/linux/ath79/dts/ar9331_8dev_carambola2.dts;h=349c91e760ca5a56d65c587c949fed5fb6ea980e;hb=349c91e760ca5a56d65c587c949fed5fb6ea980e

> You have the struct device ptr, so just use devm_kzalloc() if you need an
> allocation.

I'll address this in v3, thanks.

-- ynezz
