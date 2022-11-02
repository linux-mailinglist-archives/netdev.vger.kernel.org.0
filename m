Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B46156BF
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 01:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiKBAtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 20:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKBAs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 20:48:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF37015832;
        Tue,  1 Nov 2022 17:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R3t1/PtFRukR3DTN5dw0xr3D2iRQOcJcwJDabN8WoqY=; b=k+9rA9GBEMT2v2v5k6cpq+Qf8n
        wc9TUex0nKhotDyP26vyXHCVH5cCmX3e3cP5SBrHL+xJgzpC6eUKlWBitRUTe5Ms9PYv6Ppxvy9So
        OvIa1GRa1DYdVrw5kV2tYe1Nx9HBF3mFN/6kGVpmrUiwS+QhlqcqlgJtF6uYCnyOTkk0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq1vN-0019Xl-QK; Wed, 02 Nov 2022 01:48:09 +0100
Date:   Wed, 2 Nov 2022 01:48:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, roman.gushchin@linux.dev
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for network
 interfaces used by netconsole
Message-ID: <Y2G+SYXyZAB/r3X0@lunn.ch>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102002420.2613004-1-andy.ren@getcruise.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 05:24:20PM -0700, Andy Ren wrote:
> This patch enables support for live renaming of network interfaces
> initialized by netconsole.
> 
> This resolves an issue seen when netconsole is configured to boot as a
> built-in kernel module with a kernel boot argument. As stated in the
> kernel man page - As a built-in, netconsole initializes immediately
> after NIC cards and will bring up the specified interface as soon as
> possible. Consequently, the renaming of specified interfaces will fail
> and return EBUSY. This is because by default, the kernel disallows live
> renaming unless the device explicitly sets a priv_flags bit
> (e.g: IFF_LIVE_RENAME_OK or IFF_LIVE_ADDR_CHANGE), and so renaming after
> a network interface is up returns EBUSY.
> 
> The changes to the kernel are as of following:
> 
> - Addition of a iface_live_renaming boolean flag to the netpoll struct,
> used to enable/disable interface live renaming. False by default
> - Changes to check for the aforementioned flag in network and ethernet
> driver interface renaming code
> - Adds a new optional "*" parameter to the netconsole configuration
> string that enables interface live renaming when included
> (e.g. netconsole=+*....). When this optional parameter is included,
> "iface_live_renaming" is set to true


>  /**
>   * eth_header - create the Ethernet header
> @@ -288,8 +289,10 @@ int eth_prepare_mac_addr_change(struct net_device *dev, void *p)
>  {
>  	struct sockaddr *addr = p;
>  
> -	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev))
> +	if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) && netif_running(dev) &&
> +	    !netpoll_live_renaming_enabled(dev))
>  		return -EBUSY;
> +
>  	if (!is_valid_ether_addr(addr->sa_data))
>  		return -EADDRNOTAVAIL;
>  	return 0;

There is no mention of this in the commit message.

Changing the interface name while running is probably not an
issue. There are a few drivers which report the name to the firmware,
presumably for logging, and phoning home, but it should not otherwise
affect the hardware.

However, changing the MAC address does need changes to the hardware
configuration, and not all can do that while the interface is running.
So i think this last part needs some justification.

   Andrew
