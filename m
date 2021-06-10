Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64093A2603
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFJICw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:02:52 -0400
Received: from out28-97.mail.aliyun.com ([115.124.28.97]:51002 "EHLO
        out28-97.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhFJIC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:02:29 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436536|-1;CH=green;DM=|CONTINUE|false|;DS=||;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KQMISdx_1623312022;
Received: from 192.168.88.129(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KQMISdx_1623312022)
          by smtp.aliyun-inc.com(10.147.41.120);
          Thu, 10 Jun 2021 16:00:23 +0800
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YMGEutCet7fP1NZ9@lunn.ch>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
Date:   Thu, 10 Jun 2021 16:00:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YMGEutCet7fP1NZ9@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2021/6/10 上午11:19, Andrew Lunn wrote:
>> +static int jz4775_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +	struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +	unsigned int val;
>
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
>> +		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII\n");
>> +		break;
> So this does what DT writes expect. They put 'rgmii-id' as phy
> mode. The MAC does not add a delay. PHY_INTERFACE_MODE_RGMII_ID is
> passed to the PHY and it adds the delay. And frames flow to/from the
> PHY and users are happy. The majority of MAC drivers are like this.


Got it, thanks!


>
>> +static int x2000_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +	struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +	unsigned int val;
> Here we have a complete different story.
>
>
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
>> +
>> +		if (mac->tx_delay == 0) {
>> +			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
>> +		} else {
>> +			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY);
>> +
>> +			if (mac->tx_delay > MACPHYC_TX_DELAY_MAX)
>> +				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_MAX - 1);
>> +			else
>> +				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, mac->tx_delay - 1);
>> +		}
> What are the units of tx_delay. The DT binding should be pS, and you
> need to convert from that to whatever the hardware is using.


The manual does not tell how much ps a unit is.

I am confirming with Ingenic, but there is no reply

at the moment. Can we follow Rockchip's approach?

According to the description in "rockchip-dwmac.yaml"

and the related code in "dwmac-rk.c", it seems that their

delay parameter seems to be the value used by the hardware

directly instead of ps.


> If mac->tx_delay is greater than MACPHYC_TX_DELAY_MAX, please return
> -EINVAL when parsing the binding. We want the DT writer to know they
> have requested something the hardware cannot do.


Sure, I'll change it in the next version.


> So if the device tree contains 'rgmii' for PHY mode, you can use this
> for when you have long clock lines on your board adding the delay, and
> you just need to fine tune the delay, add a few pS. The PHY will also
> not add a delay, due to receiving PHY_INTERFACE_MODE_RGMII.
>
>> +
>> +		if (mac->rx_delay == 0) {
>> +			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
>> +		} else {
>> +			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_DELAY);
>> +
>> +			if (mac->rx_delay > MACPHYC_RX_DELAY_MAX)
>> +				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, MACPHYC_RX_DELAY_MAX - 1);
>> +			else
>> +				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, mac->rx_delay - 1);
>> +		}
>> +
>> +		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII\n");
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_RGMII_ID:
>> +		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN) |
>> +			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
>> +		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII_ID\n");
>> +		break;
> So this one is pretty normal. The MAC does not add a delay,
> PHY_INTERFACE_MODE_RGMII_ID is passed to the PHY, and it adds the
> delay. The interface will likely work.
>
>> +
>> +	case PHY_INTERFACE_MODE_RGMII_RXID:
>> +		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII) |
>> +			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
>> +
>> +		if (mac->tx_delay == 0) {
>> +			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
>> +		} else {
>> +			val |= FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY);
>> +
>> +			if (mac->tx_delay > MACPHYC_TX_DELAY_MAX)
>> +				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_MAX - 1);
>> +			else
>> +				val |= FIELD_PREP(MACPHYC_TX_DELAY_MASK, mac->tx_delay - 1);
>> +		}
> So here, the PHY is going to be passed PHY_INTERFACE_MODE_RGMII_RXID.
> The PHY will add a delay in the receive path. The MAC needs to add the
> delay in the transmit path. So tx_delay needs to be the full 2ns, not
> just a small fine tuning value, or the PCB is adding the delay. And
> you also cannot fine tune the RX delay, since rx_delay is ignored.
>
>> +
>> +		dev_dbg(mac->dev, "MAC PHY Control Register: PHY_INTERFACE_MODE_RGMII_RXID\n");
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_RGMII_TXID:
>> +		val = FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII) |
>> +			  FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_ORIGIN);
>> +
>> +		if (mac->rx_delay == 0) {
>> +			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN);
>> +		} else {
>> +			val |= FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_DELAY);
>> +
>> +			if (mac->rx_delay > MACPHYC_RX_DELAY_MAX)
>> +				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, MACPHYC_RX_DELAY_MAX - 1);
>> +			else
>> +				val |= FIELD_PREP(MACPHYC_RX_DELAY_MASK, mac->rx_delay - 1);
>> +		}
> And here we have the opposite to PHY_INTERFACE_MODE_RGMII_RXID.
>
> So you need to clearly document in the device tree binding when
> rx_delay and tx_delay are used, and when they are ignored. You don't
> want to have DT writers having to look deep into the code to figure
> this out.


Sure, maybe I should write a new independent document

for Ingenic instead of just making corresponding changes

in "snps, dwmac.yaml"


>
> Personally, i would simply this, in a big way. I see two options:
>
> 1) The MAC never adds a delay. The hardware is there, but simply don't
> use it, to keep thing simple, and the same as nearly every other MAC.
>
> 2) If the hardware can do small steps of delay, allow this delay, both
> RX and TX, to be configured in all four modes, in order to allow for
> fine tuning. Leave the PHY to insert the majority of the delay.


It seems that this method is better, I will adopt it in v3.


>> +	/* Get MAC PHY control register */
>> +	mac->regmap = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "mode-reg");
>> +	if (IS_ERR(mac->regmap)) {
>> +		dev_err(&pdev->dev, "%s: failed to get syscon regmap\n", __func__);
>> +		goto err_remove_config_dt;
>> +	}
> Please document this in the device tree binding.


Sure.


>
>> +
>> +	ret = of_property_read_u32(pdev->dev.of_node, "rx-clk-delay", &mac->rx_delay);
>> +	if (ret)
>> +		mac->rx_delay = 0;
>> +
>> +	ret = of_property_read_u32(pdev->dev.of_node, "tx-clk-delay", &mac->tx_delay);
>> +	if (ret)
>> +		mac->tx_delay = 0;
> Please take a look at dwmac-mediatek.c. It handles delays nicely. I
> would suggest that is the model to follow.


Sure.


Thanks and best regards!


>
>         Andrew
