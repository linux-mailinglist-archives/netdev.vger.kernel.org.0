Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFFF3F41D8
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 00:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhHVWDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 18:03:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhHVWDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 18:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=XtFp2sfQGI9MtcX5yHorUorYBvtJq7LSPa9bIVaT4Uw=; b=ph
        j9QWk5XivwbBP5aZkmzBc0RxAuQdKujo52E61s2iJdm/D5RA5NNJFxXWMNS/n745RKrzsP0pD8pc+
        jYJEGoszGlAHJV81idKHEnu9U3EMqIclKH9Bt8sadUDZvOLAIaxgsz0aSzB0276D74eLm1Iz4WK4g
        JZrR36D0MpbWR4s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mHvY2-003Nhl-QB; Mon, 23 Aug 2021 00:02:34 +0200
Date:   Mon, 23 Aug 2021 00:02:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <YSLJervLt/xNIKHn@lunn.ch>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210822193145.1312668-4-alvin@pqrs.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:41PM +0200, Alvin Šipraga wrote:
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 548285539752..470a2f3e8f75 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -99,6 +99,12 @@ config NET_DSA_TAG_RTL4_A
>  	  Realtek switches with 4 byte protocol A tags, sich as found in
>  	  the Realtek RTL8366RB.
>  
> +config NET_DSA_TAG_RTL8_4
> +	tristate "Tag driver for Realtek 8 byte protocol 4 tags"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames for Realtek
> +	  switches with 8 byte protocol 4 tags, such as the Realtek RTL8365MB-VC.
> +

Hi Alvin

This file is sorted based on the tristate text. As such, the
NET_DSA_TAG_RTL4_A is in the wrong place. So i can understand why you
put it here, but place move it after the Qualcom driver.

> @@ -11,6 +11,7 @@ obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
> +obj-$(CONFIG_NET_DSA_TAG_RTL8_4) += tag_rtl8_4.o
>  obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
>  obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
>  obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o

The CONFIG_NET_DSA_TAG_RTL4_A is also in the wrong place...

> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> new file mode 100644
> index 000000000000..1082bafb6a2e
> --- /dev/null
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -0,0 +1,178 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Handler for Realtek 8 byte switch tags
> + *
> + * Copyright (C) 2021 Alvin Šipraga <alsi@bang-olufsen.dk>
> + *
> + * NOTE: Currently only supports protocol "4" found in the RTL8365MB, hence
> + * named tag_rtl8_4.
> + *
> + * This "proprietary tag" header has the following format:

I think they are all proprietary. At least, there is no
standardization across vendors.

> + *
> + *  -------------------------------------------
> + *  | MAC DA | MAC SA | 8 byte tag | Type | ...
> + *  -------------------------------------------
> + *     _______________/            \______________________________________
> + *    /                                                                   \
> + *  0                                  7|8                                 15
> + *  |-----------------------------------+-----------------------------------|---
> + *  |                               (16-bit)                                | ^
> + *  |                       Realtek EtherType [0x8899]                      | |
> + *  |-----------------------------------+-----------------------------------| 8
> + *  |              (8-bit)              |              (8-bit)              |
> + *  |          Protocol [0x04]          |              REASON               | b
> + *  |-----------------------------------+-----------------------------------| y
> + *  |   (1)  | (1) | (2) |   (1)  | (3) | (1)  | (1) |    (1)    |   (5)    | t
> + *  | FID_EN |  X  | FID | PRI_EN | PRI | KEEP |  X  | LEARN_DIS |    X     | e
> + *  |-----------------------------------+-----------------------------------| s
> + *  |   (1)  |                       (15-bit)                               | |
> + *  |  ALLOW |                        TX/RX                                 | v
> + *  |-----------------------------------+-----------------------------------|---
> + *
> + * With the following field descriptions:
> + *
> + *    field      | description
> + *   ------------+-------------
> + *    Realtek    | 0x8899: indicates that this is a proprietary Realtek tag;
> + *     EtherType |         note that Realtek uses the same EtherType for
> + *               |         other incompatible tag formats (e.g. tag_rtl4_a.c)
> + *    Protocol   | 0x04: indicates that this tag conforms to this format
> + *    X          | reserved
> + *   ------------+-------------
> + *    REASON     | reason for forwarding packet to CPU

Are you allowed to document reason? This could be interesting for some
of the future work.

> + *    FID_EN     | 1: packet has an FID
> + *               | 0: no FID
> + *    FID        | FID of packet (if FID_EN=1)
> + *    PRI_EN     | 1: force priority of packet
> + *               | 0: don't force priority
> + *    PRI        | priority of packet (if PRI_EN=1)
> + *    KEEP       | preserve packet VLAN tag format
> + *    LEARN_DIS  | don't learn the source MAC address of the packet
> + *    ALLOW      | 1: treat TX/RX field as an allowance port mask, meaning the
> + *               |    packet may only be forwarded to ports specified in the
> + *               |    mask
> + *               | 0: no allowance port mask, TX/RX field is the forwarding
> + *               |    port mask
> + *    TX/RX      | TX (switch->CPU): port number the packet was received on
> + *               | RX (CPU->switch): forwarding port mask (if ALLOW=0)
> + *               |                   allowance port mask (if ALLOW=1)

There are some interesting fields here. It will be interesting to see
what we can do with the switch.

> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/bits.h>
> +
> +#include "dsa_priv.h"
> +
> +#define RTL8_4_TAG_LEN			8
> +#define RTL8_4_ETHERTYPE		0x8899

Please add this to include/uapi/linux/if_ether.h

> +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	__be16 *p;
> +	u16 etype;
> +	u8 proto;
> +	u8 *tag;
> +	u8 port;
> +	u16 tmp;
> +
> +	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	tag = dsa_etype_header_pos_rx(skb);
> +
> +	/* Parse Realtek EtherType */
> +	p = (__be16 *)tag;
> +	etype = ntohs(*p);
> +	if (unlikely(etype != RTL8_4_ETHERTYPE)) {
> +		netdev_dbg(dev, "non-realtek ethertype 0x%04x\n", etype);

You probably want to rate limit these sorts of prints. You have
limited controller of what frames come in, and if somebody can craft
bad frames, they can make you send all your time printing messages to
the log.

    Andrew
