Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C76448EA62
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 14:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbiANNJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 08:09:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235859AbiANNJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 08:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YnTWFx/yPuQ1VJBPYKlDARZ46we08KrqVjJlbdgCYJc=; b=Sw/ckGTBxXX43aAOM1HZp2w+Ez
        c0haMM5HFuJ3YE9bAx+QhnWH2u7ueis4Pt8sdrZT6uzVuKm9Pp8mrpqpkM3vtD6NxUHs9/tBm2TS3
        nsFL9ZEpMXQrH2XWnBRp+S0b6KT8yhYVBVpOFWyQysliV5Dk/NjnbnYx1JCh9nqlElug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n8MKI-001Pd9-Rk; Fri, 14 Jan 2022 14:09:06 +0100
Date:   Fri, 14 Jan 2022 14:09:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
Message-ID: <YeF18mxKuO4/4G0V@lunn.ch>
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114040755.1314349-2-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 12:07:54PM +0800, Kai-Heng Feng wrote:
> BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> instead of setting another value, keep it untouched and restore the saved
> value on system resume.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 16 +++++
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 +
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++
>  drivers/net/phy/marvell.c                     | 58 ++++++++++++-------
>  include/linux/marvell_phy.h                   |  1 +
>  5 files changed, 61 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> index 8e8778cfbbadd..f8a2879e0264a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
> @@ -857,6 +857,16 @@ static const struct dmi_system_id quark_pci_dmi[] = {
>  	{}
>  };
>  
> +static const struct dmi_system_id use_preset_led[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> +		},
> +	},
> +	{}
> +};

This is a PHY property. Why is the MAC involved?

Please also think about how to make this generic, so any ACPI based
system can use it, with any PHY.

     Andrew
