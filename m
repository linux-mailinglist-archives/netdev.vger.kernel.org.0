Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45732501EB9
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347329AbiDNWxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347490AbiDNWw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:52:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0E85BD33;
        Thu, 14 Apr 2022 15:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=6Rbdl/1BonGg6Rc4KgsdKY/Z1yZFlNKpLtWwel+nVE4=; b=AP
        2xGpMMVu42umyMUQIbZIdJu+w2JxWsMwMjVrFqkLFFwfBuoyQf+mVzjVXPFBYdt4hCnX1FlCT1iUA
        zwaOGGAcPHIl5AhHBuza57GqpAQeOj1jWd2/iP1mRsY0NitXQIqKoIb9cvkqCubVwTj2u8IXwnVde
        LYBhot/4qoDjA2w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nf8I3-00FswS-9t; Fri, 15 Apr 2022 00:50:15 +0200
Date:   Fri, 15 Apr 2022 00:50:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <YlilJ8Do4LIBAEXb@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-3-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:40PM +0200, Clément Léger wrote:
> The switch that is present on the Renesas RZ/N1 SoC uses a specific
> VLAN value followed by 6 bytes which contains forwarding configuration.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  net/dsa/Kconfig          |   8 +++
>  net/dsa/Makefile         |   1 +
>  net/dsa/tag_rzn1_a5psw.c | 112 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+)
>  create mode 100644 net/dsa/tag_rzn1_a5psw.c
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 8cb87b5067ee..e5b17108fa22 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -132,6 +132,13 @@ config NET_DSA_TAG_RTL8_4
>  	  Say Y or M if you want to enable support for tagging frames for Realtek
>  	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
>  
> +config NET_DSA_TAG_RZN1_A5PSW
> +	tristate "Tag driver for Renesas RZ/N1 A5PSW switch"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for
> +	  Renesas RZ/N1 embedded switch that uses a 8 byte tag located after
> +	  destination MAC address.
> +
>  config NET_DSA_TAG_LAN9303
>  	tristate "Tag driver for SMSC/Microchip LAN9303 family of switches"
>  	help
> @@ -159,4 +166,5 @@ config NET_DSA_TAG_XRS700X
>  	  Say Y or M if you want to enable support for tagging frames for
>  	  Arrow SpeedChips XRS700x switches that use a single byte tag trailer.
>  
> +
>  endif
> diff --git a/net/dsa/Makefile b/net/dsa/Makefile
> index 9f75820e7c98..af28c24ead18 100644
> --- a/net/dsa/Makefile
> +++ b/net/dsa/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
>  obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
> +obj-$(CONFIG_NET_DSA_TAG_RZN1_A5PSW) += tag_rzn1_a5psw.o
>  obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
>  obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
>  obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
> diff --git a/net/dsa/tag_rzn1_a5psw.c b/net/dsa/tag_rzn1_a5psw.c
> new file mode 100644
> index 000000000000..7818c1c0fca2
> --- /dev/null
> +++ b/net/dsa/tag_rzn1_a5psw.c
> @@ -0,0 +1,112 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Schneider Electric
> + *
> + * Clément Léger <clement.leger@bootlin.com>
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/etherdevice.h>
> +#include <net/dsa.h>
> +
> +#include "dsa_priv.h"
> +
> +/* To define the outgoing port and to discover the incoming port a TAG is
> + * inserted after Src MAC :
> + *
> + *       Dest MAC       Src MAC           TAG         Type
> + * ...| 1 2 3 4 5 6 | 1 2 3 4 5 6 | 1 2 3 4 5 6 7 8 | 1 2 |...
> + *                                |<--------------->|
> + *
> + * See struct a5psw_tag for layout
> + */
> +
> +#define A5PSW_TAG_VALUE			0xE001
> +#define A5PSW_TAG_LEN			8
> +#define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
> +/* This is both used for xmit tag and rcv tagging */
> +#define A5PSW_CTRL_DATA_PORT		GENMASK(3, 0)
> +
> +struct a5psw_tag {
> +	u16 ctrl_tag;
> +	u16 ctrl_data;
> +	u32 ctrl_data2;
> +};
> +
> +static struct sk_buff *a5psw_tag_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct a5psw_tag *ptag, tag = {0};
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u32 data2_val;

It might be worth adding a BUILD_BUG_ON(sizeof(tag) != A5PSW_TAG_LEN);

That does not cost anything at runtime, and avoids hard to find bugs
when the compiler does not do what you expect in terms of packing.

     Andrew
