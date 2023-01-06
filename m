Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C62565FAE7
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjAFFXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAFFXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:23:52 -0500
Received: from out29-50.mail.aliyun.com (out29-50.mail.aliyun.com [115.124.29.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF5C6ADB4;
        Thu,  5 Jan 2023 21:23:48 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436317|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0216452-0.214104-0.764251;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.QlhozBy_1672982622;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QlhozBy_1672982622)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 13:23:43 +0800
Message-ID: <3203cf98-b9e4-db71-f7b3-3e1f23a29a49@motor-comm.com>
Date:   Fri, 6 Jan 2023 13:24:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Frank <Frank.Sae@motor-comm.com>
Subject: Re: [PATCH net-next v1 2/3] net: phy: Add dts support for Motorcomm
 yt8521/yt8531s gigabit ethernet phy
To:     Arun.Ramadoss@microchip.com, andrew@lunn.ch, robh+dt@kernel.org,
        pgwipeout@gmail.com, linux@armlinux.org.uk, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        hkallweit1@gmail.com
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hua.sun@motor-comm.com, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-3-Frank.Sae@motor-comm.com>
 <810493a3ae0845061a99b31974d7b689f5bf6f65.camel@microchip.com>
Content-Language: en-US
In-Reply-To: <810493a3ae0845061a99b31974d7b689f5bf6f65.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Hi Arun Ramadoss,

On 2023/1/5 17:01, Arun.Ramadoss@microchip.com wrote:
> Hi Frank,
>
> On Thu, 2023-01-05 at 15:30 +0800, Frank wrote:
>> Add dts support for yt8521 and yt8531s. This patch has
>> been tested on AM335x platform which has one YT8531S interface
>> card and passed all test cases.
>
> As per the commit message and description, it mentions adding dts
> support. But this patch does lot of things. Add elaborate description
> or split the patch logically.
>

I will fix.

>>
>> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
>> ---
>>  drivers/net/phy/motorcomm.c | 517 ++++++++++++++++++++++++++++++--
>> ----
>>  1 file changed, 434 insertions(+), 83 deletions(-)
>>
>> diff --git a/drivers/net/phy/motorcomm.c
>> b/drivers/net/phy/motorcomm.c
>> index 685190db72de..7ebcca374a67 100644
>> --- a/drivers/net/phy/motorcomm.c
>> +++ b/drivers/net/phy/motorcomm.c
>> @@ -10,10 +10,11 @@
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>>  #include <linux/phy.h>
>> +#include <linux/of.h>
>>
>>  #define PHY_ID_YT8511		0x0000010a
>> -#define PHY_ID_YT8521		0x0000011A
>> -#define PHY_ID_YT8531S		0x4F51E91A
>> +#define PHY_ID_YT8521		0x0000011a
>> +#define PHY_ID_YT8531S		0x4f51e91a
>>
>>  /* YT8521/YT8531S Register Overview
>>   *	UTP Register space	|	FIBER Register space
>> @@ -144,6 +145,16 @@
>>  #define YT8521_ESC1R_SLEEP_SW			BIT(15)
>>  #define YT8521_ESC1R_PLLON_SLP			BIT(14)
>>
>> +/* Phy Serdes analog cfg2 Register */
>> +#define YTPHY_SERDES_ANALOG_CFG2_REG		0xA1
>> +#define YTPHY_SAC2R_TX_AMPLITUDE_MASK		((0x7 << 13) |
>> (0x7 << 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_LOW		((0x7 << 13) |
>> (0x0 << 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_MIDDLE	((0x5 << 13) | (0x5 <<
>> 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_HIGH		((0x3 << 13) |
>> (0x6 << 1))
>> +#define YT8531S_SAC2R_TX_AMPLITUDE_LOW		((0x0 << 13) |
>> (0x0 << 1))
>> +#define YT8531S_SAC2R_TX_AMPLITUDE_MIDDLE	((0x0 << 13) | (0x1 <<
>> 1))
>> +#define YT8531S_SAC2R_TX_AMPLITUDE_HIGH		((0x0 << 13) |
>> (0x2 << 1))
>> +
>>  /* Phy fiber Link timer cfg2 Register */
>>  #define YT8521_LINK_TIMER_CFG2_REG		0xA5
>>  #define YT8521_LTCR_EN_AUTOSEN			BIT(15)
>> @@ -161,6 +172,7 @@
>>
>>  #define YT8521_CHIP_CONFIG_REG			0xA001
>>  #define YT8521_CCR_SW_RST			BIT(15)
>> +#define YT8521_CCR_RXC_DLY_EN			BIT(8)
>>
>>  #define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) |
>> BIT(0))
>>  #define YT8521_CCR_MODE_UTP_TO_RGMII		0
>> @@ -178,22 +190,27 @@
>>  #define YT8521_MODE_POLL			0x3
>>
>>  #define YT8521_RGMII_CONFIG1_REG		0xA003
>> -
>> +#define YT8521_RC1R_TX_CLK_SEL_MASK		BIT(14)
>> +#define YT8521_RC1R_TX_CLK_SEL_ORIGINAL		(0x0 << 14)
>> +#define YT8521_RC1R_TX_CLK_SEL_INVERTED		(0x1 << 14)
>>  /* TX Gig-E Delay is bits 3:0, default 0x1
>>   * TX Fast-E Delay is bits 7:4, default 0xf
>>   * RX Delay is bits 13:10, default 0x0
>>   * Delay = 150ps * N
>>   * On = 2250ps, off = 0ps
>>   */
>> -#define YT8521_RC1R_RX_DELAY_MASK		(0xF << 10)
>> -#define YT8521_RC1R_RX_DELAY_EN			(0xF << 10)
>> -#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << 10)
>> -#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << 4)
>> -#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << 4)
>> -#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << 4)
>> -#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << 0)
>> -#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << 0)
>> -#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << 0)
>> +#define YT8521_RC1R_GE_TX_DELAY_BIT		(0)
>> +#define YT8521_RC1R_FE_TX_DELAY_BIT		(4)
>> +#define YT8521_RC1R_RX_DELAY_BIT		(10)
>> +#define YT8521_RC1R_RX_DELAY_MASK		(0xF <<
>> YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_RX_DELAY_EN			(0xF <<
>> YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_RX_DELAY_DIS		(0x0 <<
>> YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF <<
>> YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF <<
>> YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 <<
>> YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF <<
>> YT8521_RC1R_GE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF <<
>> YT8521_RC1R_GE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 <<
>> YT8521_RC1R_GE_TX_DELAY_BIT)
>>
>
> This can be splitted as preparatory patch like using BIT macro instead
> of magic number.
>

I will fix.

>>
>>  #define YTPHY_MISC_CONFIG_REG			0xA006
>>  #define YTPHY_MCR_FIBER_SPEED_MASK		BIT(0)
>> @@ -222,11 +239,33 @@
>>   */
>>  #define YTPHY_WCR_TYPE_PULSE			BIT(0)
>>
>> -#define YT8531S_SYNCE_CFG_REG			0xA012
>> -#define YT8531S_SCR_SYNCE_ENABLE		BIT(6)
>> +#define YTPHY_SYNCE_CFG_REG			0xA012
>> +#define YT8521_SCR_CLK_SRC_MASK			(BIT(2) |
>> BIT(1))
>
> For the mask, you can consider using GENMASK macro
>

I will fix.

>> +#define YT8521_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
>> +#define YT8521_SCR_CLK_SRC_REF_25M		(0x3 << 1)
>> +#define YT8521_SCR_SYNCE_ENABLE			BIT(5)
>> +#define YT8521_SCR_CLK_FRE_SEL_MASK		BIT(3)
>> +#define YT8521_SCR_CLK_FRE_SEL_125M		(0x1 << 3)
>> +#define YT8521_SCR_CLK_FRE_SEL_25M		(0x0 << 3)
>> +#define YT8531_SCR_CLK_SRC_MASK			(BIT(3) |
>> BIT(2) | BIT(1))
>> +#define YT8531_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
>> +#define YT8531_SCR_CLK_SRC_REF_25M		(0x4 << 1)
>> +#define YT8531_SCR_SYNCE_ENABLE			BIT(6)
>> +#define YT8531_SCR_CLK_FRE_SEL_MASK		BIT(4)
>> +#define YT8531_SCR_CLK_FRE_SEL_125M		(0x1 << 4)
>> +#define YT8531_SCR_CLK_FRE_SEL_25M		(0x0 << 4)
>>
>>
>> +
>> +static int ytphy_clk_out_config(struct phy_device *phydev)
>> +{
>> +	struct yt8521_priv *priv = phydev->priv;
>> +	u16 set = 0;
>> +	u16 mask;
>> +
>> +	switch (phydev->drv->phy_id) {
>> +	case PHY_ID_YT8511:
>> +		/* YT8511 will be supported later */
>> +		return -EOPNOTSUPP;
>> +	case PHY_ID_YT8521:
>> +		mask = YT8521_SCR_SYNCE_ENABLE;
>> +		if (priv->clock_ouput) {
>> +			mask |= YT8521_SCR_CLK_SRC_MASK;
>> +			mask |= YT8521_SCR_CLK_FRE_SEL_MASK;
>
> You can consider assigning mask in single statement.

I will fix.

>
>> +			set |= YT8521_SCR_SYNCE_ENABLE;
>> +			if (priv->clock_freq_125M) {
>> +				set |= YT8521_SCR_CLK_FRE_SEL_125M;
>> +				set |= YT8521_SCR_CLK_SRC_PLL_125M;
>
> Similarly here.

I will fix.

>
>> +			} else {
>> +				set |= YT8521_SCR_CLK_FRE_SEL_25M;
>> +				set |= YT8521_SCR_CLK_SRC_REF_25M;
>> +			}
>> +		}
>> +		break;
>> +	case PHY_ID_YT8531:
>> +	case PHY_ID_YT8531S:
>> +		mask = YT8531_SCR_SYNCE_ENABLE;
>> +		if (priv->clock_ouput) {
>> +			mask |= YT8531_SCR_CLK_SRC_MASK;
>> +			mask |= YT8531_SCR_CLK_FRE_SEL_MASK;
>> +			set |= YT8531_SCR_SYNCE_ENABLE;
>> +			if (priv->clock_freq_125M) {
>> +				set |= YT8531_SCR_CLK_FRE_SEL_125M;
>> +				set |= YT8531_SCR_CLK_SRC_PLL_125M;
>> +			} else {
>> +				set |= YT8531_SCR_CLK_FRE_SEL_25M;
>> +				set |= YT8531_SCR_CLK_SRC_REF_25M;
>> +			}
>> +		}
>> +		break;
>> +	default:
>> +		phydev_err(phydev, "invalid phy id\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return ytphy_modify_ext(phydev, YTPHY_SYNCE_CFG_REG, mask,
>> set);
>> +}
>> +
>> ++static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
>> +{
>> +	struct yt8521_priv *priv = phydev->priv;
>> +	u16 mask = 0;
>> +	u16 val = 0;
>> +	int ret;
>> +
>> +	/* rx delay basic controlled by dts.*/
>> +	if (priv->rx_delay_basic != YTPHY_DTS_INVAL_VAL) {
>> +		if (priv->rx_delay_basic)
>> +			val = YT8521_CCR_RXC_DLY_EN;
>> +		ret = ytphy_modify_ext(phydev, YT8521_CHIP_CONFIG_REG,
>> +				       YT8521_CCR_RXC_DLY_EN, val);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	val = 0;
>> +	/* If rx_delay_additional and tx_delay_* are all not be seted
>> in dts,
>> +	 * then used the fixed *_DELAY_DIS or *_DELAY_EN. Otherwise,
>> use the
>> +	 * value set by rx_delay_additional, tx_delay_ge and
>> tx_delay_fe.
>> +	 */
>> +	if ((priv->rx_delay_additional & priv->tx_delay_ge & priv-
>>> tx_delay_fe)
>> +	   == YTPHY_DTS_INVAL_VAL) {
>> +		switch (phydev->interface) {
>> +		case PHY_INTERFACE_MODE_RGMII:
>> +			val |= YT8521_RC1R_GE_TX_DELAY_DIS;
>> +			val |= YT8521_RC1R_FE_TX_DELAY_DIS;
>> +			val |= YT8521_RC1R_RX_DELAY_DIS;
>
> Single statement would be suffice.

I will fix.

>
>> +			break;
>> +		case PHY_INTERFACE_MODE_RGMII_RXID:
>> +			val |= YT8521_RC1R_GE_TX_DELAY_DIS;
>> +			val |= YT8521_RC1R_FE_TX_DELAY_DIS;
>> +			val |= YT8521_RC1R_RX_DELAY_EN;
>> +			break;
>> +		case PHY_INTERFACE_MODE_RGMII_TXID:
>> +			val |= YT8521_RC1R_GE_TX_DELAY_EN;
>> +			val |= YT8521_RC1R_FE_TX_DELAY_EN;
>> +			val |= YT8521_RC1R_RX_DELAY_DIS;
>> +			break;
>> +		case PHY_INTERFACE_MODE_RGMII_ID:
>> +			val |= YT8521_RC1R_GE_TX_DELAY_EN;
>> +			val |= YT8521_RC1R_FE_TX_DELAY_EN;
>> +			val |= YT8521_RC1R_RX_DELAY_EN;
>> +			break;
>> +		default: /* do not support other modes */
>> +			return -EOPNOTSUPP;
>> +		}
>> +		mask = YT8521_RC1R_RX_DELAY_MASK |
>> YT8521_RC1R_FE_TX_DELAY_MASK
>> +		       | YT8521_RC1R_GE_TX_DELAY_MASK;
>> +	}
>> +
>>
>>  /**
>>   * ytphy_utp_read_lpa() - read LPA then setup lp_advertising for utp
>>   * @phydev: a pointer to a &struct phy_device
>> @@ -1125,6 +1486,34 @@ static int yt8521_resume(struct phy_device
>> *phydev)
>>  	return yt8521_modify_utp_fiber_bmcr(phydev, BMCR_PDOWN, 0);
>>  }
>>
>>
>> @@ -1778,7 +2129,7 @@ static struct phy_driver motorcomm_phy_drvs[] =
>> {
>>  		PHY_ID_MATCH_EXACT(PHY_ID_YT8531S),
>>  		.name		= "YT8531S Gigabit Ethernet",
>>  		.get_features	= yt8521_get_features,
>> -		.probe		= yt8531s_probe,
>> +		.probe		= yt8521_probe,
>>  		.read_page	= yt8521_read_page,
>>  		.write_page	= yt8521_write_page,
>>  		.get_wol	= ytphy_get_wol,
>> @@ -1804,7 +2155,7 @@ static const struct mdio_device_id
>> __maybe_unused motorcomm_tbl[] = {
>>  	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
>>  	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
>>  	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8531S) },
>> -	{ /* sentinal */ }
>> +	{ /* sentinel */ }
>
> It should go as separate patch.

I will fix.

>>  };
>>
>>  MODULE_DEVICE_TABLE(mdio, motorcomm_tbl);
