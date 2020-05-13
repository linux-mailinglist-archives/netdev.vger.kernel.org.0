Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6811D14FC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 15:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387935AbgEMNcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 09:32:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733281AbgEMNcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 09:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HyO1+4PL1ry4EHRvApM2dkFGIw/Z4bh+/HXu49Gei1w=; b=lJ2nSg+2amnjt4bLbGibfEWJG1
        UGeYTelQhtqRIMYYa8byavoe0uLrrqmfQ+b4N90hQ7fQk4TWwKO7DArZP78dxfnNveugSdqgI0PQM
        gkPovlywJ/Qv0Gom9Sxn7enQJWVfxgruXaOwnJVbDgCQrv7cv008a2XCPd3kVL3DDR8g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYrUX-002AEv-Qj; Wed, 13 May 2020 15:32:09 +0200
Date:   Wed, 13 May 2020 15:32:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513133209.GC499265@lunn.ch>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513120648.14415-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 02:06:48PM +0200, Oleksij Rempel wrote:
> The cable test seems to be support by all of currently support Atherso
> PHYs, so add support for all of them. This patch was tested only on
> AR9331 PHY with following results:
> - No cable is detected as short
> - A 15m long cable connected only on one side is detected as 9m open.

That sounds wrong. What about a shorted 15m cable? Is it also 9m?  Do
you have any other long cables you can test with? Is it always 1/2 the
cable length?

> - A cable test with active link partner will provide no usable results.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/at803x.c | 141 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 141 insertions(+)
> 
> diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> index f4fec5f644e91..03ec500defb34 100644
> --- a/drivers/net/phy/at803x.c
> +++ b/drivers/net/phy/at803x.c
> @@ -7,11 +7,13 @@
>   * Author: Matus Ujhelyi <ujhelyi.m@gmail.com>
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/phy.h>
>  #include <linux/module.h>
>  #include <linux/string.h>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/of_gpio.h>
>  #include <linux/bitfield.h>
>  #include <linux/gpio/consumer.h>
> @@ -48,6 +50,20 @@
>  #define AT803X_SMART_SPEED_BYPASS_TIMER		BIT(1)
>  #define AT803X_LED_CONTROL			0x18
>  
> +/* Cable Tester Contol Register */
> +#define AT803X_CABLE_DIAG_CTRL			0x16
> +#define AT803X_CABLE_DIAG_MDI_PAIR		GENMASK(9, 8)
> +#define AT803X_CABLE_DIAG_EN			BIT(0)
> +
> +/* Cable Tester Status Register */
> +#define AT803X_CABLE_DIAG_STATUS		0x1c
> +#define AT803X_CABLE_DIAG_RESULT		GENMASK(9, 8)
> +#define AT803X_CABLE_DIAG_RESULT_OK		0
> +#define AT803X_CABLE_DIAG_RESULT_SHORT		1
> +#define AT803X_CABLE_DIAG_RESULT_OPEN		2
> +#define AT803X_CABLE_DIAG_RESULT_FAIL		3
> +#define AT803X_CABLE_DIAG_DTIME			GENMASK(7, 0)
> +
>  #define AT803X_DEVICE_ADDR			0x03
>  #define AT803X_LOC_MAC_ADDR_0_15_OFFSET		0x804C
>  #define AT803X_LOC_MAC_ADDR_16_31_OFFSET	0x804B
> @@ -122,6 +138,7 @@ MODULE_AUTHOR("Matus Ujhelyi");
>  MODULE_LICENSE("GPL");
>  
>  struct at803x_priv {
> +	struct phy_device *phydev;
>  	int flags;
>  #define AT803X_KEEP_PLL_ENABLED	BIT(0)	/* don't turn off internal PLL */
>  	u16 clk_25m_reg;
> @@ -129,6 +146,9 @@ struct at803x_priv {
>  	struct regulator_dev *vddio_rdev;
>  	struct regulator_dev *vddh_rdev;
>  	struct regulator *vddio;
> +	struct work_struct cable_test_work;
> +	bool cable_test_finished;
> +	int cable_test_ret;
>  };
>  
>  struct at803x_context {
> @@ -168,6 +188,113 @@ static int at803x_debug_reg_mask(struct phy_device *phydev, u16 reg,
>  	return phy_write(phydev, AT803X_DEBUG_DATA, val);
>  }
  
> +static void at803x_cable_test_work(struct work_struct *work)
> +{
> +	struct at803x_priv *priv = container_of(work, struct at803x_priv,
> +						cable_test_work);
> +	struct phy_device *phydev = priv->phydev;
> +	int i, ret = 0, pairs = 4;
> +
> +	if (phydev->phy_id == ATH9331_PHY_ID)
> +		pairs = 2;
> +
> +	for (i = 0; i < pairs; i++) {
> +		ret = at803x_cable_test_pair(phydev, i);
> +		if (ret)
> +			break;
> +	}
> +
> +	priv->cable_test_ret = ret;
> +	priv->cable_test_finished = true;
> +
> +	phy_queue_state_machine(phydev, 0);
> +}
> +
> +static int at803x_cable_test_start(struct phy_device *phydev)
> +{
> +	struct at803x_priv *priv = phydev->priv;
> +
> +	if (!priv->cable_test_finished) {
> +		phydev_err(phydev, "cable test is already running\n");
> +		return -EIO;
> +	}
> +
> +	priv->cable_test_finished = false;
> +	schedule_work(&priv->cable_test_work);

You don't need the work queue. You cannot spend a long time in
at803x_cable_test_start(), but you can in
at803x_cable_test_get_status(). So start the first the measurement of
the first pair in at803x_cable_test_start(), and do the rest in
of the work in at803x_cable_test_get_status().

If we see there is a common pattern of wanting
at803x_cable_test_get_status() to run immediately, not one second
later, we can change to core to support that.

       Andrew
