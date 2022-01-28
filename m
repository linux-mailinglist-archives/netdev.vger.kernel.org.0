Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6299D49F0E0
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345262AbiA1CS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:18:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345221AbiA1CS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 21:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2h4iTM+n+82xH0OyqPlHoMU120tLrCO+ovFn9Zti4+s=; b=zHEIr1WwJZYf2cAjyBXZS1UX01
        2BAipTyD508sufc90nE34yrSmb4ivvYxSZGXE3tWE6NwJkSFYIZSb8IaQKj5IcVv4G13Da3k4WoYL
        jPEpNsR6yQ0uj96mY7ryx53wZgpWngNnlF8Ywh0S0Xf0tUcqnblOwJHmNG5SSHVFxu7A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nDGqc-0034iv-CJ; Fri, 28 Jan 2022 03:18:46 +0100
Date:   Fri, 28 Jan 2022 03:18:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        leon@kernel.org
Subject: Re: [PATCH v14, 2/2] net: Add dm9051 driver
Message-ID: <YfNShpsWZhbff/C4@lunn.ch>
References: <20220127032701.23056-1-josright123@gmail.com>
 <20220127032701.23056-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127032701.23056-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dm9051_mdiobus_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct board_info *db = bus->priv;
> +	unsigned int val = 0xffff;
> +	int ret;
> +
> +	if (addr == DM9051_PHY_ID) {

Thanks for fixing the variable name. But don't you think it would of
made sense to rename DM9051_PHY_ID as well? DM9051_PHY_ADDR?

> +static int dm9051_set_pauseparam(struct net_device *ndev,
> +				 struct ethtool_pauseparam *pause)
> +{
> +	struct board_info *db = to_dm9051_board(ndev);
> +	u8 fcr = 0;
> +	int ret;
> +
> +	db->eth_pause = *pause;
> +
> +	if (pause->autoneg)
> +		db->phydev->autoneg = AUTONEG_ENABLE;
> +	else
> +		db->phydev->autoneg = AUTONEG_DISABLE;
> +

pause->autoneg means that pause is negotiated as part of autoneg in
general. But pause->autoneg does not mean turn on autoneg. The
ksetting calls should be used for that.

If pause->autoneg is false, you write the pause settings direct to the
MAC. If it is true, you should call phy_set_sym_pause(). Once
negotiation has completed the link change callback will be called, and
you program the MAC with what has been negotiated.

    Andrew
