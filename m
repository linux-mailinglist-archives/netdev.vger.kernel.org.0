Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61B52EC0A
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348114AbiETMYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344126AbiETMYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:24:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34BE62100
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PVkmyJT3vYf7t94vlejM0rMSGP8EOH5hz1RRkDCoLmI=; b=j0g25qMXEbW6HcYCLF6gZPkNSR
        oXr+jQ8aX+SucuHMLkLlDMgF4+GaCIqECGpKTvh41OQp9HE121r09jj2CWvKRDl2tzxrSQWGDphJQ
        p00i+YlaptB94oxwLvLKm7YRna4gI19jbu7IBsqyC70egonzp5xY6RLWXeErrpSjZDPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ns1gV-003chV-W6; Fri, 20 May 2022 14:24:47 +0200
Date:   Fri, 20 May 2022 14:24:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <YoeIj2Ew5MPvPcvA@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520004500.2250674-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * netif_carrier_local_changes_start() - enter local link reconfiguration
> + * @dev: network device
> + *
> + * Mark link as unstable due to local administrative actions. This will
> + * cause netif_carrier_off() to behave like netif_carrier_admin_off() until
> + * netif_carrier_local_changes_end() is called.
> + */
> +static inline void netif_carrier_local_changes_start(struct net_device *dev)
> +{
> +	set_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
> +}
> +
> +static inline void netif_carrier_local_changes_end(struct net_device *dev)
> +{
> +	clear_bit(__LINK_STATE_NOCARRIER_LOCAL, &dev->state);
> +}
> +

Since these don't perform reference counting, maybe a WARN_ON() if the
bit is already set/not set.

>  void netif_carrier_on(struct net_device *dev);
>  void netif_carrier_off(struct net_device *dev);
> +void netif_carrier_admin_off(struct net_device *dev);
>  void netif_carrier_event(struct net_device *dev);

I need some examples of how you see this used. I can see two ways:

At the start of a reconfigure, the driver calls
netif_carrier_local_changes_start() and once it is all over and ready
to do work again, it calls netif_carrier_local_changes_end().

The driver has a few netif_carrier_off() calls changed to
netif_carrier_admin_off(). It is then unclear looking at the code
which of the calls to netif_carrier_on() match the off.

Please could you pick a few drivers, and convert them? Maybe include a
driver which makes use of phylib, which should be doing control of the
carrier based on the actual link status.

	Andrew
