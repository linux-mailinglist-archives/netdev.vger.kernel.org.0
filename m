Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB62C4CBD
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731709AbgKZBmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731508AbgKZBmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:42:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E364020B1F;
        Thu, 26 Nov 2020 01:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606354936;
        bh=1n7rTiSq/Dl9ElQSRoo+DQUTBlTZJshQf6dUa/6L/Yg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tt7UxcPh2Kf5CU4/rC7P1QT91+o/GEI3er56O1WMH+wgM7SY03wr9QReKx+gmAscc
         KC0+dFqwIoGCEB3kuNMQomc+OvI6mSCWKxJ/7YOy3nGMGJX7FmCexAJ+kXUwEEubmR
         V1gF/6fIA9o/lHKcP84rB4uMQU4R6y5aW8ykREcA=
Date:   Wed, 25 Nov 2020 17:42:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201125193740.36825-3-george.mccollister@gmail.com>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
        <20201125193740.36825-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 13:37:39 -0600 George McCollister wrote:
> Add a driver with initial support for the Arrow SpeedChips XRS7000
> series of gigabit Ethernet switch chips which are typically used in
> critical networking applications.
> 
> The switches have up to three RGMII ports and one RMII port.
> Management to the switches can be performed over i2c or mdio.
> 
> Support for advanced features such as PTP and
> HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> may be added at a later date.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

You need to add symbol exports otherwise this won't build with
allmodconfig:

ERROR: modpost: "xrs7004f_info"
[drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined! ERROR: modpost:
"xrs7004e_info" [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined!
ERROR: modpost: "xrs7003f_info"
[drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined! ERROR: modpost:
"xrs7003e_info" [drivers/net/dsa/xrs700x/xrs700x_mdio.ko] undefined!
ERROR: modpost: "xrs7004f_info"
[drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined! ERROR: modpost:
"xrs7004e_info" [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined!
ERROR: modpost: "xrs7003f_info"
[drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined! ERROR: modpost:
"xrs7003e_info" [drivers/net/dsa/xrs700x/xrs700x_i2c.ko] undefined!

> +	{XRS_RX_UNDERSIZE_L, "rx_undersize"},
> +	{XRS_RX_FRAGMENTS_L, "rx_fragments"},
> +	{XRS_RX_OVERSIZE_L, "rx_oversize"},
> +	{XRS_RX_JABBER_L, "rx_jabber"},
> +	{XRS_RX_ERR_L, "rx_err"},
> +	{XRS_RX_CRC_L, "rx_crc"},

As Vladimir already mentioned to you the statistics which have
corresponding entries in struct rtnl_link_stats64 should be reported
the standard way. The infra for DSA may not be in place yet, so best 
if you just drop those for now.
