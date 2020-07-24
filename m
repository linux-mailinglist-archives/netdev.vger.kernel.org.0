Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075AE22C632
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 15:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGXNTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 09:19:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53570 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbgGXNTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 09:19:20 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyxbZ-006g4C-8n; Fri, 24 Jul 2020 15:19:17 +0200
Date:   Fri, 24 Jul 2020 15:19:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Message-ID: <20200724131917.GE1472201@lunn.ch>
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 04:09:57PM -0400, Bryan Whitehead wrote:
> The LCPLL Reset sequence is added to the initialization path
> of the VSC8574 Family of phy drivers.
> 
> The LCPLL Reset sequence is known to reduce hardware inter-op
> issues when using the QSGMII MAC interface.
> 
> This patch is submitted to net-next to avoid merging conflicts that
> may arise if submitted to net.
> 
> Signed-off-by: Bryan Whitehead <Bryan.Whitehead@microchip.com>
> ---
>  drivers/net/phy/mscc/mscc_main.c | 90 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 90 insertions(+)
> 
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index a4fbf3a..f2fa221 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -929,6 +929,90 @@ static bool vsc8574_is_serdes_init(struct phy_device *phydev)
>  }
>  
>  /* bus->mdio_lock should be locked when using this function */
> +/* Page should already be set to MSCC_PHY_PAGE_EXTENDED_GPIO */
> +static int vsc8574_wait_for_micro_complete(struct phy_device *phydev)
> +{
> +	u16 timeout = 500;
> +	u16 reg18g = 0;
> +
> +	reg18g = phy_base_read(phydev, 18);
> +	while (reg18g & 0x8000) {
> +		timeout--;
> +		if (timeout == 0)
> +			return -1;

Hi Bryan

-ETIMEDOUT;

But as Florian said, please add a phy_base_read_poll_timeout()
following what phy_read_poll_timeout() does.

> +		usleep_range(1000, 2000);
> +		reg18g = phy_base_read(phydev, 18);
> +	}
> +
> +	return 0;
> +}


> +
> +/* bus->mdio_lock should be locked when using this function */
> +static int vsc8574_reset_lcpll(struct phy_device *phydev)
> +{
> +	u16 reg_val = 0;
> +	int ret = 0;
> +
> +	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
> +		       MSCC_PHY_PAGE_EXTENDED_GPIO);
> +
> +	/* Read LCPLL config vector into PRAM */
> +	phy_base_write(phydev, 18, 0x8023);
> +	ret = vsc8574_wait_for_micro_complete(phydev);
> +	if (ret)
> +		goto done;
...
> +
> +done:
> +	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
> +	return ret;
> +}

So if vsc8574_wait_for_micro_complete() was to return -1, you pass it
on.

> +
> +/* bus->mdio_lock should be locked when using this function */
>  static int vsc8574_config_pre_init(struct phy_device *phydev)
>  {
>  	static const struct reg_val pre_init1[] = {
> @@ -1002,6 +1086,12 @@ static int vsc8574_config_pre_init(struct phy_device *phydev)
>  	bool serdes_init;
>  	int ret;
>  
> +	ret = vsc8574_reset_lcpll(phydev);
> +	if (ret) {
> +		dev_err(dev, "failed lcpll reset\n");
> +		return ret;
> +	}

And pass it on further. It could reach user space as an errno. It is
just safer to always use an errno value.

     Andrew
