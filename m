Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD183174CC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbhBJX4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhBJX43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:56:29 -0500
Received: from ssl.serverraum.org (unknown [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DAC061756;
        Wed, 10 Feb 2021 15:55:49 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C2B4E22FB3;
        Thu, 11 Feb 2021 00:55:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613001332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEejHc9IILkXC9cLIYT2xFd2yXDC1JZdaFodqp4H5xU=;
        b=MYU3JYqKvrqmEAcZVDw1NIYEx6l9DWihd59xvY1cWXtdCF38U0ghTzwLo/Y5yHffo24t+B
        cUxYwlm7HG8W1YKEVMA/rg16fYpfZVa+/jaCni9nRvU6OU/kUVzfVGFkQO6OSOdthDbJnD
        etx4RO76OjSv0EdmwQxiIjTd+dgWIk4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 11 Feb 2021 00:55:31 +0100
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 7/9] net: phy: icplus: fix paged register
 access
In-Reply-To: <20210210210809.30125-8-michael@walle.cc>
References: <20210210210809.30125-1-michael@walle.cc>
 <20210210210809.30125-8-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <d30dd5aed1a1e91a05fbc37bda13b4ea@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-10 22:08, schrieb Michael Walle:
> Registers >= 16 are paged. Be sure to set the page. It seems this was
> working for now, because the default is correct for the registers used
> in the driver at the moment. But this will also assume, nobody will
> change the page select register before linux is started. The page 
> select
> register is _not_ reset with a soft reset of the PHY.
> 
> To ease the function reuse between the non-paged register space of the
> IP101A and the IP101G, add noop read_page()/write_page() callbacks so
> the IP101G functions can also be used for the IP101A.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> Changes since v2:
>  - none
> 
> Changes since v1:
>  - introduce a noop read/write_page() for the IP101A
>  - also use phy_*_paged() for the interrupt status register
> 
> Andrew, I've dropped your Reviewed-by because of this.
> 
>  drivers/net/phy/icplus.c | 65 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
> index bc2b58061507..7e0ef05b1cae 100644
> --- a/drivers/net/phy/icplus.c
> +++ b/drivers/net/phy/icplus.c
> @@ -49,6 +49,8 @@ MODULE_LICENSE("GPL");
>  #define IP101G_DIGITAL_IO_SPEC_CTRL			0x1d
>  #define IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32		BIT(2)
> 
> +#define IP101G_DEFAULT_PAGE			16
> +
>  #define IP175C_PHY_ID 0x02430d80
>  #define IP1001_PHY_ID 0x02430d90
>  #define IP101A_PHY_ID 0x02430c54
> @@ -211,23 +213,25 @@ static int ip101a_g_probe(struct phy_device 
> *phydev)
>  static int ip101a_g_config_intr_pin(struct phy_device *phydev)
>  {
>  	struct ip101a_g_phy_priv *priv = phydev->priv;
> -	int err;
> +	int oldpage, err;

besides this being uninitialized

> +
> +	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);

this is also missing a check for negative return values

will be fixed in v4

-michael

> 
>  	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
>  	switch (priv->sel_intr32) {
>  	case IP101GR_SEL_INTR32_RXER:
> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32, 0);
>  		if (err < 0)
> -			return err;
> +			goto out;
>  		break;
> 
>  	case IP101GR_SEL_INTR32_INTR:
> -		err = phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
> -				 IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
> +		err = __phy_modify(phydev, IP101G_DIGITAL_IO_SPEC_CTRL,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32,
> +				   IP101G_DIGITAL_IO_SPEC_CTRL_SEL_INTR32);
>  		if (err < 0)
> -			return err;
> +			goto out;
>  		break;
> 
>  	default:
> @@ -241,7 +245,8 @@ static int ip101a_g_config_intr_pin(struct
> phy_device *phydev)
>  		break;
>  	}
> 
> -	return 0;
> +out:
> +	return phy_restore_page(phydev, oldpage, err);
>  }
> 
>  static int ip101a_config_init(struct phy_device *phydev)
> @@ -263,8 +268,10 @@ static int ip101g_config_init(struct phy_device 
> *phydev)
> 
>  static int ip101a_g_ack_interrupt(struct phy_device *phydev)
>  {
> -	int err = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
> +	int err;
> 
> +	err = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
> +			     IP101A_G_IRQ_CONF_STATUS);
>  	if (err < 0)
>  		return err;
> 
> @@ -283,10 +290,12 @@ static int ip101a_g_config_intr(struct phy_device 
> *phydev)
> 
>  		/* INTR pin used: Speed/link/duplex will cause an interrupt */
>  		val = IP101A_G_IRQ_PIN_USED;
> -		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
> +		err = phy_write_paged(phydev, IP101G_DEFAULT_PAGE,
> +				      IP101A_G_IRQ_CONF_STATUS, val);
>  	} else {
>  		val = IP101A_G_IRQ_ALL_MASK;
> -		err = phy_write(phydev, IP101A_G_IRQ_CONF_STATUS, val);
> +		err = phy_write_paged(phydev, IP101G_DEFAULT_PAGE,
> +				      IP101A_G_IRQ_CONF_STATUS, val);
>  		if (err)
>  			return err;
> 
> @@ -300,7 +309,8 @@ static irqreturn_t
> ip101a_g_handle_interrupt(struct phy_device *phydev)
>  {
>  	int irq_status;
> 
> -	irq_status = phy_read(phydev, IP101A_G_IRQ_CONF_STATUS);
> +	irq_status = phy_read_paged(phydev, IP101G_DEFAULT_PAGE,
> +				    IP101A_G_IRQ_CONF_STATUS);
>  	if (irq_status < 0) {
>  		phy_error(phydev);
>  		return IRQ_NONE;
> @@ -316,6 +326,31 @@ static irqreturn_t
> ip101a_g_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
> 
> +/* The IP101A doesn't really have a page register. We just pretend to 
> have one
> + * so we can use the paged versions of the callbacks of the IP101G.
> + */
> +static int ip101a_read_page(struct phy_device *phydev)
> +{
> +	return IP101G_DEFAULT_PAGE;
> +}
> +
> +static int ip101a_write_page(struct phy_device *phydev, int page)
> +{
> +	WARN_ONCE(page != IP101G_DEFAULT_PAGE, "wrong page selected\n");
> +
> +	return 0;
> +}
> +
> +static int ip101g_read_page(struct phy_device *phydev)
> +{
> +	return __phy_read(phydev, IP101G_PAGE_CONTROL);
> +}
> +
> +static int ip101g_write_page(struct phy_device *phydev, int page)
> +{
> +	return __phy_write(phydev, IP101G_PAGE_CONTROL, page);
> +}
> +
>  static int ip101a_g_has_page_register(struct phy_device *phydev)
>  {
>  	int oldval, val, ret;
> @@ -390,6 +425,8 @@ static struct phy_driver icplus_driver[] = {
>  	.name		= "ICPlus IP101A",
>  	.match_phy_device = ip101a_match_phy_device,
>  	.probe		= ip101a_g_probe,
> +	.read_page	= ip101a_read_page,
> +	.write_page	= ip101a_write_page,
>  	.config_intr	= ip101a_g_config_intr,
>  	.handle_interrupt = ip101a_g_handle_interrupt,
>  	.config_init	= ip101a_config_init,
> @@ -400,6 +437,8 @@ static struct phy_driver icplus_driver[] = {
>  	.name		= "ICPlus IP101G",
>  	.match_phy_device = ip101g_match_phy_device,
>  	.probe		= ip101a_g_probe,
> +	.read_page	= ip101g_read_page,
> +	.write_page	= ip101g_write_page,
>  	.config_intr	= ip101a_g_config_intr,
>  	.handle_interrupt = ip101a_g_handle_interrupt,
>  	.config_init	= ip101g_config_init,

-- 
-michael
