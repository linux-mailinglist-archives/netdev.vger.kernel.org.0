Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAD52FDB98
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 22:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733003AbhATU4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389788AbhATUxB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 15:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10B9A233FC;
        Wed, 20 Jan 2021 20:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611175938;
        bh=8jBF67VISxuT/xu2rcoO5YE2FU88OFticdYf54+neO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N5+QPs/+DlLJt3MClwur9O+wbKTIHuhCZO1VVEg8KCi0KUGwZU0XaVmJBd/K8SOdz
         cEzlwRbPCzeRUL92LOaLG3+3089C3zNhwSfg9YkO9sJ70ZNsc3OXJjUzdq6Cv+skzI
         uQ+DIRkP//QC6bZTLNu6zeypikx0R1XyPDBuKUmj7JfObyOYNU2C5ebQ5Aoa7GYsPg
         07E5RfDaVTnJIS3588nJV65f3gpv3VlcZ+3ItM3EcpYFKZReSNI8z9r19FnQwTFCJp
         p8VUIwhGYO2M00l1IuVVUkLQXOCs80dksUXtNmGbDSIgYqCI5cgFQNfisGIh2UQfND
         5oJ72HvNobAzg==
Date:   Wed, 20 Jan 2021 12:52:17 -0800
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
Subject: Re: [PATCH v10 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20210120125217.6394e6a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftj8s8nwgmx.fsf%l.stelmach@samsung.com>
References: <20210115172722.516468bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CGME20210120193032eucas1p26566e957da7a75bc0818fe08e055bec8@eucas1p2.samsung.com>
        <dleftj8s8nwgmx.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 20:30:14 +0100 Lukasz Stelmach wrote:
> > You need to use 64 bit stats, like struct rtnl_link_stats64.
> > On a 32bit system at 100Mbps ulong can wrap in minutes.
> >  
> 
> Let me see. At first glance
> 
> git grep -l ndo_get_stats\\\> drivers/net/ethernet/  | xargs grep -li SPEED_100\\\>
> 
> quite a number of Fast Ethernet drivers use net_device_stats. Let me
> calculate.
> 
> - bytes
>   100Mbps is ~10MiB/s
>   sending 4GiB at 10MiB/s takes 27 minutes
> 
> - packets
>   minimum frame size is 84 bytes (840 bits on the wire) on 100Mbps means
>   119048 pps at this speed it takse 10 hours to transmit 2^32 packets
> 
> Anyway, I switched to rtnl_link_stats64. Tell me, is it OK to just
> memcpy() in .ndo_get_stats64?

Yup, you can just memcpy() your local copy over the one you get as an
argument of ndo_get_stats64

> >> +	struct work_struct	ax_work;  
> >
> > I don't see you ever canceling / flushing this work.
> > You should do that at least on driver remove if not close.  
> 
> Done.
> 
> Does it mean most drivers do it wrong?
> 
>     git grep INIT_WORK drivers/net/ethernet/ | \
>     sed -e 's/\(^[^:]*\):[^>]*->\([^,]*\),.*/\1        \2/' | \
>     while read file var; do \
>         grep -H $var $file;
>     done | grep INIT_WORK\\\|cancel_work

Some may use flush, but I wouldn't be surprised if there were bugs like
this out there.
