Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD61AAC21D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 23:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404543AbfIFVmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 17:42:49 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:58912 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404462AbfIFVmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 17:42:47 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46Q9yW644qz1rD9F;
        Fri,  6 Sep 2019 23:42:43 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46Q9yW5JyZz1qqkL;
        Fri,  6 Sep 2019 23:42:43 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id wm6bBFVevb32; Fri,  6 Sep 2019 23:42:42 +0200 (CEST)
X-Auth-Info: xo1MZn8uDNecarxN163we4LGIPypF0tmItOb3KRcsiE=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  6 Sep 2019 23:42:42 +0200 (CEST)
Subject: Re: [PATCH net-next 2/3] net: dsa: microchip: add ksz9567 to ksz9477
 driver
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20190906213054.48908-1-george.mccollister@gmail.com>
 <20190906213054.48908-3-george.mccollister@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <6d8a915f-5f05-c91c-c139-26497376147d@denx.de>
Date:   Fri, 6 Sep 2019 23:41:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906213054.48908-3-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/6/19 11:30 PM, George McCollister wrote:
> Add support for the KSZ9567 7-Port Gigabit Ethernet Switch to the
> ksz9477 driver. The KSZ9567 supports both SPI and I2C. Oddly the
> ksz9567 is already in the device tree binding documentation.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c     | 9 +++++++++
>  drivers/net/dsa/microchip/ksz9477_i2c.c | 1 +
>  drivers/net/dsa/microchip/ksz9477_spi.c | 1 +
>  3 files changed, 11 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 187be42de5f1..50ffc63d6231 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1529,6 +1529,15 @@ static const struct ksz_chip_data ksz9477_switch_chips[] = {
>  		.cpu_ports = 0x07,	/* can be configured as cpu port */
>  		.port_cnt = 3,		/* total port count */
>  	},
> +	{
> +		.chip_id = 0x00956700,
> +		.dev_name = "KSZ9567",
> +		.num_vlans = 4096,
> +		.num_alus = 4096,
> +		.num_statics = 16,
> +		.cpu_ports = 0x7F,	/* can be configured as cpu port */
> +		.port_cnt = 7,		/* total physical port count */

I might be wrong, and this is just an idea for future improvement, but
is .cpu_ports = GEN_MASK(.port_cnt, 0) always ?

> +	},
>  };
>  
>  static int ksz9477_switch_init(struct ksz_device *dev)
> diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
> index 85fd0fb43941..c1548a43b60d 100644
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@ -77,6 +77,7 @@ MODULE_DEVICE_TABLE(i2c, ksz9477_i2c_id);
>  static const struct of_device_id ksz9477_dt_ids[] = {
>  	{ .compatible = "microchip,ksz9477" },
>  	{ .compatible = "microchip,ksz9897" },
> +	{ .compatible = "microchip,ksz9567" },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
> diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
> index 2e402e4d866f..f4198d6f72be 100644
> --- a/drivers/net/dsa/microchip/ksz9477_spi.c
> +++ b/drivers/net/dsa/microchip/ksz9477_spi.c
> @@ -81,6 +81,7 @@ static const struct of_device_id ksz9477_dt_ids[] = {
>  	{ .compatible = "microchip,ksz9893" },
>  	{ .compatible = "microchip,ksz9563" },
>  	{ .compatible = "microchip,ksz8563" },
> +	{ .compatible = "microchip,ksz9567" },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, ksz9477_dt_ids);
> 

Reviewed-by: Marek Vasut <marex@denx.de>

-- 
Best regards,
Marek Vasut
