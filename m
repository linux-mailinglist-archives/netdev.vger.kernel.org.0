Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB32B49B596
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 15:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386617AbiAYOCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 09:02:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53066 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385581AbiAYN7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 08:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ox78QD2G7Vl4O8u8fw2FuKHaFOQlJwcYfnNDAIdWWt4=; b=GGtpgHhjFCVP5d5DvN9Be/8S37
        qPF6rga96LpRgWr7aKH/DGBZwNQi76wPWZXDVAXOWYhuY0eBJTbW1hHLIkpRVTPHkrh+eu1iB4TQx
        yK6KbUeJ1vCQDN0S1T5UwI2qL7oxhb4kcmcI49fN4SDSOgLyBOqWRCKUMk4ezWq5/RQM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCMM9-002esZ-4A; Tue, 25 Jan 2022 14:59:33 +0100
Date:   Tue, 25 Jan 2022 14:59:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        leon@kernel.org
Subject: Re: [PATCH v13, 2/2] net: Add dm9051 driver
Message-ID: <YfACRXnsAUVxlZze@lunn.ch>
References: <20220125085837.10357-1-josright123@gmail.com>
 <20220125085837.10357-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125085837.10357-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dm9051_mdiobus_read(struct mii_bus *mdiobus, int phy_id, int reg)
> +{
> +	struct board_info *db = mdiobus->priv;
> +	unsigned int val = 0;
> +	int ret;
> +
> +	if (phy_id == DM9051_PHY_ID) {

phy_id is a poor choice of name. It normally means the value you find
in register 2 and 3 of the PHY which identifies the manufacture, make
and possibly revision.

If you look at the read function prototype in struct mii_bus:

https://elixir.bootlin.com/linux/v5.17-rc1/source/include/linux/phy.h#L357

the normal name is addr.

Ideally your driver needs to look similar to other drivers. Ideally
you use the same variable names for the same things. That makes it
easier for somebody else to read your driver and debug it. It makes it
easier to review, etc. It is worth spending time reading a few other
drivers and looking for common patterns, and making use of those
patterns in your driver.

> +static int dm9051_map_phyup(struct board_info *db)
> +{
> +	int ret;
> +
> +	/* ~BMCR_PDOWN to power-up the internal phy
> +	 */
> +	ret = mdiobus_modify(db->mdiobus, DM9051_PHY_ID, MII_BMCR, BMCR_PDOWN, 0);
> +	if (ret < 0)
> +		return ret;

You are still touching PHY registers from the MAC driver. Why is your
PHY driver not going this as part of the _config() function?

    Andrew
