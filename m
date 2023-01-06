Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEED65FC34
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 08:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjAFHmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 02:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjAFHmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 02:42:11 -0500
Received: from out29-175.mail.aliyun.com (out29-175.mail.aliyun.com [115.124.29.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EEE72D3D;
        Thu,  5 Jan 2023 23:42:07 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436261|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.109322-0.000592706-0.890086;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.QlpPXTO_1672990921;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QlpPXTO_1672990921)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 15:42:02 +0800
Message-ID: <e74ff413-6d7d-63a3-ece4-c2fc555fea9d@motor-comm.com>
Date:   Fri, 6 Jan 2023 15:42:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v1 2/3] net: phy: Add dts support for Motorcomm
 yt8521/yt8531s gigabit ethernet phy
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-3-Frank.Sae@motor-comm.com> <Y7cC2MKYK4omdZKg@lunn.ch>
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <Y7cC2MKYK4omdZKg@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/6 01:03, Andrew Lunn wrote:
> On Thu, Jan 05, 2023 at 03:30:23PM +0800, Frank wrote:
>> Add dts support for yt8521 and yt8531s. This patch has
>> been tested on AM335x platform which has one YT8531S interface
>> card and passed all test cases.
>>
>> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
>> ---
>>  drivers/net/phy/motorcomm.c | 517 ++++++++++++++++++++++++++++++------
>>  1 file changed, 434 insertions(+), 83 deletions(-)
>>
>> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
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
> 
> Please do the lower case conversion as a separate patch.
> 

I will fix.

>>  
>>  /* YT8521/YT8531S Register Overview
>>   *	UTP Register space	|	FIBER Register space
>> @@ -144,6 +145,16 @@
>>  #define YT8521_ESC1R_SLEEP_SW			BIT(15)
>>  #define YT8521_ESC1R_PLLON_SLP			BIT(14)
>>  
>> +/* Phy Serdes analog cfg2 Register */
>> +#define YTPHY_SERDES_ANALOG_CFG2_REG		0xA1
>> +#define YTPHY_SAC2R_TX_AMPLITUDE_MASK		((0x7 << 13) | (0x7 << 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_LOW		((0x7 << 13) | (0x0 << 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_MIDDLE	((0x5 << 13) | (0x5 << 1))
>> +#define YT8521_SAC2R_TX_AMPLITUDE_HIGH		((0x3 << 13) | (0x6 << 1))
> 
> So there are two values which control the amplitude? Buts 1-3, and bit
> 7-9?  Can they be used independently?  Also, 7, 5, 3 is also add. Does
> bit 0 of this value have some special meaning? Please document this
> fully.
> 

There are three values which control the amplitude,  13-15,3 and 1-2.
They be used independently. Maybe it is good to expose three type ( 0:
low;   1: middle;   2: high)to dts.

Bit	Symbol		Access	default	Description
15:13	Tx_swing_sel	RW	0x0	TX driver stage2 amplitude control
12	Tx_driver_stg1	RW	0x1	TX driver stage1 amplitude control
11	Reserved	RO	0x0	Reserved
10:8	Tx_ckdiv10_con	RW	0x0	tx divide by 10 clock delay control
7:4	Reserved	RO	0x0	Reserved
3	Tx_post_stg1	RW	0x0	TX driver post stage1 amplitude control
2:1	Tx_de_sel	RW	0x0	TX driver post stage2 amplitude control
0	Tx_pd		RW	0x0	power down analog tx


>> +#define YT8531S_SAC2R_TX_AMPLITUDE_LOW		((0x0 << 13) | (0x0 << 1))
>> +#define YT8531S_SAC2R_TX_AMPLITUDE_MIDDLE	((0x0 << 13) | (0x1 << 1))
>> +#define YT8531S_SAC2R_TX_AMPLITUDE_HIGH		((0x0 << 13) | (0x2 << 1))
> 
> This more sense, but why the 0 << 13? What do the bits 13-? mean?

0 << 13 means 13-15 bit all zero.
bits 13- mans the start bit is 13.

> 
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
>>  #define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) | BIT(0))
>>  #define YT8521_CCR_MODE_UTP_TO_RGMII		0
>> @@ -178,22 +190,27 @@
>>  #define YT8521_MODE_POLL			0x3
>>  
>>  #define YT8521_RGMII_CONFIG1_REG		0xA003
>> -
>> +#define YT8521_RC1R_TX_CLK_SEL_MASK		BIT(14)
>> +#define YT8521_RC1R_TX_CLK_SEL_ORIGINAL		(0x0 << 14)
>> +#define YT8521_RC1R_TX_CLK_SEL_INVERTED		(0x1 << 14)
> 
> Please use the BIT macro.
> 

ok, change

+#define YT8521_RC1R_TX_CLK_SEL_MASK		BIT(14)
+#define YT8521_RC1R_TX_CLK_SEL_ORIGINAL		(0x0 << 14)
+#define YT8521_RC1R_TX_CLK_SEL_INVERTED		(0x1 << 14)

to

+#define YT8521_RC1R_TX_CLK_SEL_INVERTED		BIT(14)

?

> 
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
>> +#define YT8521_RC1R_RX_DELAY_MASK		(0xF << YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_RX_DELAY_EN			(0xF << YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << YT8521_RC1R_RX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << YT8521_RC1R_FE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << YT8521_RC1R_GE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << YT8521_RC1R_GE_TX_DELAY_BIT)
>> +#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << YT8521_RC1R_GE_TX_DELAY_BIT)
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
>> +#define YT8521_SCR_CLK_SRC_MASK			(BIT(2) | BIT(1))
>> +#define YT8521_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
>> +#define YT8521_SCR_CLK_SRC_REF_25M		(0x3 << 1)
>> +#define YT8521_SCR_SYNCE_ENABLE			BIT(5)
>> +#define YT8521_SCR_CLK_FRE_SEL_MASK		BIT(3)
>> +#define YT8521_SCR_CLK_FRE_SEL_125M		(0x1 << 3)
>> +#define YT8521_SCR_CLK_FRE_SEL_25M		(0x0 << 3)
> 
> Whenever it is a single bit, please use the BIT macro.

I wwill fix.

> 
>> +#define YT8531_SCR_CLK_SRC_MASK			(BIT(3) | BIT(2) | BIT(1))
>> +#define YT8531_SCR_CLK_SRC_PLL_125M		(0x0 << 1)
>> +#define YT8531_SCR_CLK_SRC_REF_25M		(0x4 << 1)
>> +#define YT8531_SCR_SYNCE_ENABLE			BIT(6)
>> +#define YT8531_SCR_CLK_FRE_SEL_MASK		BIT(4)
>> +#define YT8531_SCR_CLK_FRE_SEL_125M		(0x1 << 4)
>> +#define YT8531_SCR_CLK_FRE_SEL_25M		(0x0 << 4)
>>  
>>  /* Extended Register  end */
>>  
>> +#define YTPHY_DTS_MAX_TX_AMPLITUDE		0x2
>> +#define YTPHY_DTS_MAX_DELAY_VAL			2250
>> +#define YTPHY_DTS_STEP_DELAY_VAL		150
>> +#define YTPHY_DTS_INVAL_VAL			0xFF
>> +
>> +#define YTPHY_DTS_OUTPUT_CLK_DIS		0
>> +#define YTPHY_DTS_OUTPUT_CLK_25M		25000000
>> +#define YTPHY_DTS_OUTPUT_CLK_125M		125000000
>> +
>>  struct yt8521_priv {
>>  	/* combo_advertising is used for case of YT8521 in combo mode,
>>  	 * this means that yt8521 may work in utp or fiber mode which depends
>> @@ -243,6 +282,30 @@ struct yt8521_priv {
>>  	 * YT8521_RSSR_TO_BE_ARBITRATED
>>  	 */
>>  	u8 reg_page;
>> +
>> +	/* The following parameters are from dts */
>> +	/* rx delay = rx_delay_basic + rx_delay_additional
>> +	 * basic delay is ~2ns, 0 = off, 1 = on
>> +	 * rx_delay_additional,delay time = 150ps * val
>> +	 */
>> +	u8 rx_delay_basic;
>> +	u8 rx_delay_additional;
>> +
>> +	/* tx_delay_ge is tx_delay for 1000Mbps
>> +	 * tx_delay_fe is tx_delay for 100Mbps or 10Mbps
>> +	 * delay time = 150ps * val
>> +	 */
>> +	u8 tx_delay_ge;
>> +	u8 tx_delay_fe;
>> +	u8 sds_tx_amplitude;
>> +	bool keep_pll_enabled;
>> +	bool auto_sleep_disabled;
>> +	bool clock_ouput;	/* output clock ctl: 0=off, 1=on */
>> +	bool clock_freq_125M;	/* output clock freq selcect: 0=25M, 1=125M */
>> +	bool tx_clk_adj_enabled;/* tx clk adj ctl: 0=off, 1=on */
>> +	bool tx_clk_10_inverted;
>> +	bool tx_clk_100_inverted;
>> +	bool tx_clk_1000_inverted;
> 
> Do you need to store all these values? In general, PHY drivers parse
> DT, and program the hardware directly. If these values are lost on
> reset, and you need to perform a reset for normal operation, then yes,
> it makes sense to store them. But in general, that is not how hardware
> works.
> 

I will fix.

>> +static int ytphy_parse_dt(struct phy_device *phydev)
>> +{
>> +	struct device_node *node = phydev->mdio.dev.of_node;
>> +	struct yt8521_priv *priv = phydev->priv;
>> +	u32 freq, val;
>> +	int ret;
>> +
>> +	priv->rx_delay_additional = YTPHY_DTS_INVAL_VAL;
>> +	priv->sds_tx_amplitude = YTPHY_DTS_INVAL_VAL;
>> +	priv->rx_delay_basic = YTPHY_DTS_INVAL_VAL;
>> +	priv->tx_delay_ge = YTPHY_DTS_INVAL_VAL;
>> +	priv->tx_delay_fe = YTPHY_DTS_INVAL_VAL;
>> +
>> +	if (!IS_ENABLED(CONFIG_OF_MDIO)) {
> 
> No other PHY driver does this. Why is this here?
> 
> As a general rule, if you do something which no other driver does, you
> are doing something wrong. All PHY drivers should basically look the
> same, follow the same structure, etc. So it is a good idea to review 5
> other drivers, and make your driver look similar.
> 

I will fix.

>> +		priv->auto_sleep_disabled = true;
>> +		priv->keep_pll_enabled = true;
>> +		return 0;
>> +	}
>> +
>> +	ret = of_property_read_u32(node, "motorcomm,clk-out-frequency", &freq);
>> +	if (ret < 0)
>> +		freq = YTPHY_DTS_OUTPUT_CLK_DIS;/* default value as dts*/
>> +
>> +	switch (freq) {
>> +	case YTPHY_DTS_OUTPUT_CLK_DIS:
>> +		priv->clock_ouput = false;
>> +		break;
>> +	case YTPHY_DTS_OUTPUT_CLK_25M:
>> +		priv->clock_freq_125M = false;
>> +		priv->clock_ouput = true;
>> +		break;
>> +	case YTPHY_DTS_OUTPUT_CLK_125M:
>> +		priv->clock_freq_125M = true;
>> +		priv->clock_ouput = true;
>> +		break;
>> +	default:
>> +		phydev_err(phydev, "invalid motorcomm,clk-out-frequency\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!of_property_read_u32(node, "motorcomm,rx-delay-basic", &val)) {
>> +		if (val > 1) {
>> +			phydev_err(phydev,
>> +				   "invalid motorcomm,rx-delay-basic\n");
>> +			return -EINVAL;
>> +		}
>> +		priv->rx_delay_basic = val;
>> +	}
>> +
>> +	if (!of_property_read_u32(node, "motorcomm,rx-delay-additional-ps", &val)) {
>> +		if (val > YTPHY_DTS_MAX_DELAY_VAL) {
>> +			phydev_err(phydev, "invalid motorcomm,rx-delay-additional-ps\n");
>> +			return -EINVAL;
>> +		}
> 
> Please check the value is also one of the supported values. Please do
> that for all your delays.
> 

The following code check the supported values.

if (val)
			val /= YTPHY_DTS_STEP_DELAY_VAL;
		priv->rx_delay_additional = val;


rx-delay-additional-ps = reg_val(0-15) *150ps. so val >
YTPHY_DTS_MAX_DELAY_VAL 2250 is err.
rx_delay_additional is store the reg_val (0-15).

>> +	if (of_property_read_bool(node, "motorcomm,keep-pll-enabled"))
>> +		priv->keep_pll_enabled = true;
> 
> I think this only makes sense when priv->clock_output is true? Please
> test for that.
> 

No,priv->clock_output is used to output 25Mhz or 125Mhz for mac.
priv->keep_pll_enabled is used to enable RXC clock when no wire plug.

> 
>> +static int ytphy_rgmii_clk_delay_config(struct phy_device *phydev)
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
>> +	/* If rx_delay_additional and tx_delay_* are all not be seted in dts,
>> +	 * then used the fixed *_DELAY_DIS or *_DELAY_EN. Otherwise, use the
>> +	 * value set by rx_delay_additional, tx_delay_ge and tx_delay_fe.
>> +	 */
> 
> So what you should be doing here is always respecting
> phydev->interface. You can then fine tune the delays using
> rx-internal-delay-ps and tx-internal-delay-ps.
> 

I will fix.

>> +static int ytphy_probe_helper(struct phy_device *phydev)
>> +{
>> +	struct device *dev = &phydev->mdio.dev;
>> +	struct yt8521_priv *priv;
>> +	int ret;
>> +
>> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>> +
>> +	phydev->priv = priv;
>> +
>> +	ret = ytphy_parse_dt(phydev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	phy_lock_mdio_bus(phydev);
>> +	ret = ytphy_clk_out_config(phydev);
>> +	phy_unlock_mdio_bus(phydev);
>> +	return ret;
>> +}
>> +
>>  /**
>>   * yt8521_probe() - read chip config then set suitable polling_mode
>>   * @phydev: a pointer to a &struct phy_device
>> @@ -601,16 +983,15 @@ static int yt8521_write_page(struct phy_device *phydev, int page)
>>   */
>>  static int yt8521_probe(struct phy_device *phydev)
>>  {
>> -	struct device *dev = &phydev->mdio.dev;
>>  	struct yt8521_priv *priv;
>>  	int chip_config;
>>  	int ret;
>>  
>> -	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>> -	if (!priv)
>> -		return -ENOMEM;
>> +	ret = ytphy_probe_helper(phydev);
>> +	if (ret < 0)
>> +		return ret;
>>  
>> -	phydev->priv = priv;
>> +	priv = phydev->priv;
> 
> I don't see why you added this probe helper.
> 
> Is this to make the driver look more like the vendor driver? Please
> seperate refactoring patches from new functionality. We want to see
> lots of simple, obviously correct patches which are easy to review.
> 

I will fix.

>      Andrew
>   
