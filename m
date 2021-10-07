Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE642547E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbhJGNoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:44:16 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:33081 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbhJGNoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:44:13 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C93BC22221;
        Thu,  7 Oct 2021 15:42:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1633614138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nAoO7AWrOb3QR2CnHzp2nG12nDEceP8PRE8VLCSZ0wE=;
        b=ejAhu7N+hhEGWqJeSlKxI5Hg/HSmv8dfMsYylF7UjHq2l5SgXnyGRkx9FFhu+rtlJmJK+s
        51UJuBOrrrcsFIv651e3yMaziq20ioC2x7mS5yMk6JXGwxoHzF3tQ+1WOIIOjX+go65xGV
        gckJR+k+bu3tSaL7HnNZ9kJmrHuQP5I=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Oct 2021 15:42:17 +0200
From:   Michael Walle <michael@walle.cc>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 2/3] eth: platform: add a helper for loading
 netdev->dev_addr
In-Reply-To: <20211007132511.3462291-3-kuba@kernel.org>
References: <20211007132511.3462291-1-kuba@kernel.org>
 <20211007132511.3462291-3-kuba@kernel.org>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <16f34ede9a885a443bb7c46255ee804f@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-10-07 15:25, schrieb Jakub Kicinski:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> There is a handful of drivers which pass netdev->dev_addr as
> the destination buffer to eth_platform_get_mac_address().
> Add a helper which takes a dev pointer instead, so it can call
> an appropriate helper.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
..

> +/**
> + * platform_get_ethdev_address - Set netdev's MAC address from a given 
> device
> + * @dev:	Pointer to the device
> + * @netdev:	Pointer to netdev to write the address to
> + *
> + * Wrapper around eth_platform_get_mac_address() which writes the 
> address
> + * directly to netdev->dev_addr.
> + */
> +int platform_get_ethdev_address(struct device *dev, struct net_device 
> *netdev)
> +{
> +	u8 addr[ETH_ALEN];
> +	int ret;
> +
> +	ret = eth_platform_get_mac_address(dev, addr);

this eventually calls ether_addr_copy(), which has a note:
   Please note: dst & src must both be aligned to u16.

Is this true for this addr on the stack?

-michael
