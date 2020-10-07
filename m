Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486DB285FDF
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgJGNOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:14:07 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:56677 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgJGNOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:14:06 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4C5vtL3vpBz9wjx;
        Wed,  7 Oct 2020 15:14:02 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4C5vsz63wHz2TTLX;
        Wed,  7 Oct 2020 15:13:43 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 7 Oct
 2020 15:13:17 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: microchip: add ksz9563 to ksz9477 I2C driver
Date:   Wed, 7 Oct 2020 15:13:15 +0200
Message-ID: <5079657.ehXnlxHBby@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201007122107.GA112961@lunn.ch>
References: <20201007093049.13078-1-ceggers@arri.de> <20201007122107.GA112961@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201007-151347-4C5vsz63wHz2TTLX-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> What chip_id values does it use? I don't see it listed in
> ksz9477_switch_chips.

here a short dump of the first chip registers:

>         Chip ID0     00
>         Chip ID1_2   9893      Chip ID      9893
>         Chip ID3     60        Revision ID  6              Reset         normal
>         Chip ID4     1C        SKU ID       1C

In ksz9477_switch_detect(), the 32 bit value is built from only
the 2 middle bytes: 0x00989300. The number of port (3) is also
assigned within this function:

> 	if ((id_lo & 0xf) == 3) {
> 		/* Chip is from KSZ9893 design. */
> 		dev->features |= IS_9893;
> 		/* Chip does not support gigabit. */
> 		if (data8 & SW_QW_ABLE)
> 			dev->features &= ~GBIT_SUPPORT;
> 		dev->mib_port_cnt = 3;
> 		dev->phy_port_cnt = 2;
> 	} ...

The chip id 0x00989300 does already exist in ksz9477_switch_chips:

> 	{
> 		.chip_id = 0x00989300,
> 		.dev_name = "KSZ9893",
> 		.num_vlans = 4096,
> 		.num_alus = 4096,
> 		.num_statics = 16,
> 		.cpu_ports = 0x07,	/* can be configured as cpu port */
> 		.port_cnt = 3,		/* total port count */
> 	},

But my chip is really a KSZ9563.

Best regards
Christian



