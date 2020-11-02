Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081322A3696
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKBWgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgKBWgp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:36:45 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6795B20786;
        Mon,  2 Nov 2020 22:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604356605;
        bh=M77JQwpHVytx1fH56+uLb62c1dilDbZryCn3QRwJzmk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mtEFA7EL69HW3/33YCjCSwvlSwXqVsri+z36u12G6vwVtzIl3Qoptf2JQCQsRY9+Q
         cprNPSh5aWiDaQ7SyQ7/C/sHTMMAwkalPWM1PMepiPzqMV1aq6OFV2b+cT0qD1bKvt
         VFES6bdwz4LcQvfkpJIXMqNfWMXc4c01QTKaIKCg=
Message-ID: <4ca1f21d5f8a119fe6483df370b64af6a33e565e.camel@kernel.org>
Subject: Re: [PATCH net-next 0/5] net: add and use dev_get_tstats64
From:   Saeed Mahameed <saeed@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Mon, 02 Nov 2020 14:36:43 -0800
In-Reply-To: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
References: <25c7e008-c3fb-9fcd-f518-5d36e181c0cb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-01 at 13:33 +0100, Heiner Kallweit wrote:
> It's a frequent pattern to use netdev->stats for the less frequently
> accessed counters and per-cpu counters for the frequently accessed
> counters (rx/tx bytes/packets). Add a default ndo_get_stats64()
> implementation for this use case. Subsequently switch more drivers
> to use this pattern.
> 
> Heiner Kallweit (5):
>   net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
>   net: make ip_tunnel_get_stats64 an alias for dev_get_tstats64
>   ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
>   net: dsa: use net core stats64 handling
>   tun: switch to net core provided statistics counters
> 

not many left,

$ git grep dev_fetch_sw_netstats drivers/

drivers/infiniband/hw/hfi1/ipoib_main.c:        dev_fetch_sw_netstats(s
torage, priv->netstats);
drivers/net/macsec.c:   dev_fetch_sw_netstats(s, dev->tstats);
drivers/net/usb/qmi_wwan.c:     dev_fetch_sw_netstats(stats, priv-
>stats64);
drivers/net/usb/usbnet.c:       dev_fetch_sw_netstats(stats, dev-
>stats64);
drivers/net/wireless/quantenna/qtnfmac/core.c:  dev_fetch_sw_netstats(s
tats, vif->stats64);

Why not convert them as well ?
macsec has a different implementation, but all others can be converted.


