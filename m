Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951FF35E154
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhDMOZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:25:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhDMOZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:25:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWJyv-00GU2L-WE; Tue, 13 Apr 2021 16:25:34 +0200
Date:   Tue, 13 Apr 2021 16:25:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Subject: Re: [PATCH net-next 2/5] net: phy: marvell: fix HWMON enable
 register for 6390
Message-ID: <YHWp3UToOvq8k3wJ@lunn.ch>
References: <20210413075538.30175-1-kabel@kernel.org>
 <20210413075538.30175-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210413075538.30175-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 09:55:35AM +0200, Marek Behún wrote:
> Register 27_6.15:14 has the following description in 88E6393X
> documentation:
>   Temperature Sensor Enable
>     0x0 - Sample every 1s
>     0x1 - Sense rate decided by bits 10:8 of this register
>     0x2 - Use 26_6.5 (One shot Temperature Sample) to enable
>     0x3 - Disable
> 
> This is compatible with how the 6390 code uses this register currently,
> but the 6390 code handles it as two 1-bit registers (somewhat), instead
> of one register with 4 possible values.
> 
> Rename this register and define all 4 values according to 6393X
> documentation.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/phy/marvell.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> index 63788d5c13eb..bae2a225b550 100644
> --- a/drivers/net/phy/marvell.c
> +++ b/drivers/net/phy/marvell.c
> @@ -113,11 +113,11 @@
>  #define MII_88E1540_COPPER_CTRL3_FAST_LINK_DOWN		BIT(9)
>  
>  #define MII_88E6390_MISC_TEST		0x1b
> -#define MII_88E6390_MISC_TEST_SAMPLE_1S		0
> -#define MII_88E6390_MISC_TEST_SAMPLE_10MS	BIT(14)
> -#define MII_88E6390_MISC_TEST_SAMPLE_DISABLE	BIT(15)
> -#define MII_88E6390_MISC_TEST_SAMPLE_ENABLE	0
> -#define MII_88E6390_MISC_TEST_SAMPLE_MASK	(0x3 << 14)
> +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S	(0x0 << 14)
> +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE		(0x1 << 14)
> +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_ONESHOT	(0x2 << 14)
> +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE		(0x3 << 14)
> +#define MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK			(0x3 << 14)
>  
>  #define MII_88E6390_TEMP_SENSOR		0x1c
>  #define MII_88E6390_TEMP_SENSOR_MASK	0xff
> @@ -2352,9 +2352,8 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
>  	if (ret < 0)
>  		goto error;
>  
> -	ret = ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
> -	ret |= MII_88E6390_MISC_TEST_SAMPLE_ENABLE |
> -		MII_88E6390_MISC_TEST_SAMPLE_1S;
> +	ret = ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
> +	ret |= MII_88E6390_MISC_TEST_TEMP_SENSOR_ENABLE_SAMPLE_1S;

So this is identical

>  
>  	ret = __phy_write(phydev, MII_88E6390_MISC_TEST, ret);
>  	if (ret < 0)
> @@ -2381,8 +2380,8 @@ static int m88e6390_get_temp(struct phy_device *phydev, long *temp)
>  	if (ret < 0)
>  		goto error;
>  
> -	ret = ret & ~MII_88E6390_MISC_TEST_SAMPLE_MASK;
> -	ret |= MII_88E6390_MISC_TEST_SAMPLE_DISABLE;
> +	ret = ret & ~MII_88E6390_MISC_TEST_TEMP_SENSOR_MASK;
> +	ret |= MII_88E6390_MISC_TEST_TEMP_SENSOR_DISABLE;

And here we have gone from 0x2 to 0x3?

Have you checked the 6390 datasheet for this?

I will test these patches later.

     Andrew
