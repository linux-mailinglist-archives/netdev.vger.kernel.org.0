Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9048C26FE2B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIRNV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:21:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgIRNV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:21:56 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJGKh-00FElo-Rb; Fri, 18 Sep 2020 15:21:47 +0200
Date:   Fri, 18 Sep 2020 15:21:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: realtek: enable ALDPS to save power
 for RTL8211F
Message-ID: <20200918132147.GB3631014@lunn.ch>
References: <20200918104756.557f9129@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918104756.557f9129@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 10:47:56AM +0800, Jisheng Zhang wrote:
> Enable ALDPS function to save power when link down.

Hi Jisheng

It would be nice to give a hint what ALDPS means. It is not one of the
standard acronyms i know of, so it could be Realtek specific.

> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
>  drivers/net/phy/realtek.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 95dbe5e8e1d8..961570186822 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -39,6 +39,10 @@
>  #define RTL8201F_ISR				0x1e
>  #define RTL8201F_IER				0x13
>  
> +#define RTL8211F_ALDPS_PLL_OFF			BIT(1)
> +#define RTL8211F_ALDPS_ENABLE			BIT(2)
> +#define RTL8211F_ALDPS_XTAL_OFF			BIT(12)
> +
>  #define RTL8366RB_POWER_SAVE			0x15
>  #define RTL8366RB_POWER_SAVE_ON			BIT(12)
>  
> @@ -178,8 +182,12 @@ static int rtl8211f_config_init(struct phy_device *phydev)
>  {
>  	struct device *dev = &phydev->mdio.dev;
>  	u16 val_txdly, val_rxdly;
> +	u16 val;
>  	int ret;
>  
> +	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
> +	phy_modify_paged_changed(phydev, 0xa43, 0x18, val, val);

Could we avoid some of these magic numbers? The datasheet seems to
call 0x18 PHYCR1, etc.

     Andrew
