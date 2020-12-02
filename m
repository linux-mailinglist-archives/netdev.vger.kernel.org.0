Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2D92CC354
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389095AbgLBRTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:19:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389070AbgLBRTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:19:35 -0500
Date:   Wed, 2 Dec 2020 09:18:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606929534;
        bh=gdrIoUwM4Jc/bJ/Co4EbSzcZQeThPm4Zexr4TFqA+CM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=oBN3nitMLZKbd6AWlOeY3V9jesJoJpzC+hiz6NaZY21ZoXjGC+0jhss9M1MNakmaw
         K0jlcJAPBGJP5evgjM8/V6GCtJ4sAAzwUrsBQ8Fg5lE+nh+jK32xSWsT5ABnAJ2ggl
         /TvUmkv9rnLcfbTgbcezyUFVU2ZWFxJ6b6z+KM7E=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201202091852.69a02069@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <dleftj8sageb97.fsf%l.stelmach@samsung.com>
References: <20201125132621.628ac98b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20201202104645eucas1p25335c0b07b106f932006f2a5bce88b6e@eucas1p2.samsung.com>
        <dleftj8sageb97.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 11:46:28 +0100 Lukasz Stelmach wrote:
> >> +	status = netif_rx(skb);  
> >
> > If I'm reading things right this is in process context, so netif_rx_ni()
> >  
> 
> Is it? The stack looks as follows
> 
>     ax88796c_skb_return()
>     ax88796c_rx_fixup()
>     ax88796c_receive()
>     ax88796c_process_isr()
>     ax88796c_work()
> 
> and ax88796c_work() is a scheduled in the system_wq.

Are you asking if work queue gets run in process context? It does.

> >> +	if (status != NET_RX_SUCCESS)
> >> +		netif_info(ax_local, rx_err, ndev,
> >> +			   "netif_rx status %d\n", status);  
> >
> > Again, it's inadvisable to put per packet prints without any rate
> > limiting in the data path.  
> 
> Even if limmited by the msglvl flag, which is off by default?

I'd err on the side of caution, but up to you.
