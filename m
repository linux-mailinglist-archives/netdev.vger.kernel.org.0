Return-Path: <netdev+bounces-665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E356F8D85
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 03:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B3A6281153
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 01:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48F51118;
	Sat,  6 May 2023 01:30:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BDF10E6
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 01:30:27 +0000 (UTC)
Received: from out28-4.mail.aliyun.com (out28-4.mail.aliyun.com [115.124.28.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CCF1991;
	Fri,  5 May 2023 18:30:23 -0700 (PDT)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1096482|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.122501-0.00138785-0.876111;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.SZWUQ06_1683336615;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.SZWUQ06_1683336615)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 09:30:16 +0800
Message-ID: <ba94f81c-3fc0-303c-f0f9-8fd0ab7d33fe@motor-comm.com>
Date: Sat, 6 May 2023 09:29:28 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
To: Samin Guo <samin.guo@starfivetech.com>, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org, netdev@vger.kernel.org,
 Peter Geis <pgwipeout@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>,
 Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230505090558.2355-1-samin.guo@starfivetech.com>
 <20230505090558.2355-3-samin.guo@starfivetech.com>
Content-Language: en-US
From: Frank Sae <Frank.Sae@motor-comm.com>
In-Reply-To: <20230505090558.2355-3-samin.guo@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/5 17:05, Samin Guo wrote:
> The motorcomm phy (YT8531) supports the ability to adjust the drive
> strength of the rx_clk/rx_data, and the default strength may not be
> suitable for all boards. So add configurable options to better match
> the boards.(e.g. StarFive VisionFive 2)
> 
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  drivers/net/phy/motorcomm.c | 46 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 2fa5a90e073b..191650bb1454 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -236,6 +236,7 @@
>   */
>  #define YTPHY_WCR_TYPE_PULSE			BIT(0)
>  
> +#define YTPHY_PAD_DRIVE_STRENGTH_REG		0xA010
>  #define YTPHY_SYNCE_CFG_REG			0xA012
>  #define YT8521_SCR_SYNCE_ENABLE			BIT(5)
>  /* 1b0 output 25m clock
> @@ -260,6 +261,14 @@
>  #define YT8531_SCR_CLK_SRC_REF_25M		4
>  #define YT8531_SCR_CLK_SRC_SSC_25M		5
>  
> +#define YT8531_RGMII_RXC_DS_DEFAULT		0x3
> +#define YT8531_RGMII_RXC_DS_MAX			0x7
> +#define YT8531_RGMII_RXC_DS			GENMASK(15, 13)
> +#define YT8531_RGMII_RXD_DS_DEFAULT		0x3
> +#define YT8531_RGMII_RXD_DS_MAX			0x7
> +#define YT8531_RGMII_RXD_DS_LOW			GENMASK(5, 4) /* Bit 1/0 of rxd_ds */
> +#define YT8531_RGMII_RXD_DS_HI			BIT(12) /* Bit 2 of rxd_ds */


YT8531_RGMII_xxx is bit define for YTPHY_PAD_DRIVE_STRENGTH_REG, so it is better to put it under the define of YTPHY_PAD_DRIVE_STRENGTH_REG.

YT8531_RGMII_xxx bit define as reverse order:
#define YTPHY_PAD_DRIVE_STRENGTH_REG		0xA010
#define YT8531_RGMII_RXC_DS			GENMASK(15, 13)
#define YT8531_RGMII_RXD_DS_HI			BIT(12) /* Bit 2 of rxd_ds */     <-------
#define YT8531_RGMII_RXD_DS_LOW			GENMASK(5, 4) /* Bit 1/0 of rxd_ds */
...

> +
>  /* Extended Register  end */
>  
>  #define YTPHY_DTS_OUTPUT_CLK_DIS		0
> @@ -1495,6 +1504,7 @@ static int yt8531_config_init(struct phy_device *phydev)
>  {
>  	struct device_node *node = phydev->mdio.dev.of_node;
>  	int ret;
> +	u32 ds, val;
>  
>  	ret = ytphy_rgmii_clk_delay_config_with_lock(phydev);
>  	if (ret < 0)
> @@ -1518,6 +1528,42 @@ static int yt8531_config_init(struct phy_device *phydev)
>  			return ret;
>  	}
>  
> +	ds = YT8531_RGMII_RXC_DS_DEFAULT;
> +	if (!of_property_read_u32(node, "motorcomm,rx-clk-driver-strength", &val)) {
> +		if (val > YT8531_RGMII_RXC_DS_MAX)
> +			return -EINVAL;
> +
> +		ds = val;
> +	}
> +
> +	ret = ytphy_modify_ext_with_lock(phydev,
> +					 YTPHY_PAD_DRIVE_STRENGTH_REG,
> +					 YT8531_RGMII_RXC_DS,
> +					 FIELD_PREP(YT8531_RGMII_RXC_DS, ds));
> +	if (ret < 0)
> +		return ret;
> +
> +	ds = FIELD_PREP(YT8531_RGMII_RXD_DS_LOW, YT8531_RGMII_RXD_DS_DEFAULT);
> +	if (!of_property_read_u32(node, "motorcomm,rx-data-driver-strength", &val)) {
> +		if (val > YT8531_RGMII_RXD_DS_MAX)
> +			return -EINVAL;
> +
> +		if (val > FIELD_MAX(YT8531_RGMII_RXD_DS_LOW)) {
> +			ds = val & FIELD_MAX(YT8531_RGMII_RXD_DS_LOW);
> +			ds = FIELD_PREP(YT8531_RGMII_RXD_DS_LOW, ds);
> +			ds |= YT8531_RGMII_RXD_DS_HI;
> +		} else {
> +			ds = FIELD_PREP(YT8531_RGMII_RXD_DS_LOW, val);
> +		}
> +	}
> +
> +	ret = ytphy_modify_ext_with_lock(phydev,
> +					 YTPHY_PAD_DRIVE_STRENGTH_REG,
> +					 YT8531_RGMII_RXD_DS_LOW | YT8531_RGMII_RXD_DS_HI,
> +					 ds);
> +	if (ret < 0)
> +		return ret;
> +
>  	return 0;
>  }
>  

