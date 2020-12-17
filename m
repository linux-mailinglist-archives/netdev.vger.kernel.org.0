Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BD82DD2F8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbgLQOYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:24:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgLQOYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 09:24:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kpuBe-00CVvk-Jw; Thu, 17 Dec 2020 15:23:22 +0100
Date:   Thu, 17 Dec 2020 15:23:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v4 net-next 2/2] net: phy: mchp: Add 1588 support for
 LAN8814 Quad PHY
Message-ID: <20201217142322.GD2981994@lunn.ch>
References: <20201217124150.8444-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217124150.8444-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int lan8814_read_page_reg(struct phy_device *phydev,
> +				 int page, u32 addr)
> +{
> +	u32 data;
> +
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, page);
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, (page | 0x4000));
> +	data = phy_read(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA);
> +
> +	return data;
> +}
> +
> +static int lan8814_write_page_reg(struct phy_device *phydev,
> +				  int page, u16 addr, u16 val)
> +{
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, page);
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
> +	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, (page | 0x4000));
> +	val = phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
> +	if (val != 0) {
> +		phydev_err(phydev, "Error: phy_write has returned error %d\n",
> +			   val);
> +		return val;
> +	}
> +	return 0;
> +}

You seem to of ignored my comment about using phy_read_mmd() and
phy_write_mmd()? If i'm wrong and these will not work, please say
so. Don't just ignore comments.

    Andrew
