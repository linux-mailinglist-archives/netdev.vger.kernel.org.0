Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13833DD0C2
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 08:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhHBGrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 02:47:17 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14571 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhHBGrQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 02:47:16 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627886827; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=nHnB3TRmANLoEBdz40RChvj6qkLvDtqQhTQjXZu6sVY=;
 b=aSuIefzuwiYtAoY/Rh6vr9R9o/hNH0QPAWFJHqwMBiQr5Wvny0VrjBMEo44RQ0z8VUxCwNfm
 BSjEuApHHVG5Boi6omqamErqMwIJzA+lL5xrm89N124L82/SDn+kolu8T8veA6r/PxepEugW
 QiICI9AIPdY5RuC2FirvvvSHWH0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 610794cf290ea35ee6e72795 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Aug 2021 06:46:39
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 59242C4323A; Mon,  2 Aug 2021 06:46:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35879C433F1;
        Mon,  2 Aug 2021 06:46:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 02 Aug 2021 14:46:37 +0800
From:   luoj@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH 1/3] net: mdio-ipq4019: Add mdio reset function
In-Reply-To: <YQKsnqWCfoTpTuxI@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <YQKsnqWCfoTpTuxI@lunn.ch>
Message-ID: <5eba90f41162cc19625025776fbdd0a2@codeaurora.org>
X-Sender: luoj@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-29 21:26, Andrew Lunn wrote:
> Hi Luo
> 
> For a patchset, netdev wants to see a patch 0/X which describes the
> big picture. What is the patchset as a whole doing.
> 
> Hi Andrew,
> Thanks for reminder, will provide it in the next patch set.
> 
>> +static int ipq_mdio_reset(struct mii_bus *bus)
>> +{
>> +	struct ipq4019_mdio_data *priv = bus->priv;
>> +	struct device *dev = bus->parent;
>> +	struct gpio_desc *reset_gpio;
>> +	u32 val;
>> +	int i, ret;
>> +
>> +	/* To indicate CMN_PLL that ethernet_ldo has been ready if needed */
>> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
>> +		val = readl(priv->eth_ldo_rdy);
>> +		val |= BIT(0);
>> +		writel(val, priv->eth_ldo_rdy);
>> +		fsleep(QCA_PHY_SET_DELAY_US);
>> +	}
>> +
>> +	/* Reset GEPHY if need */
>> +	if (!IS_ERR(priv->reset_ctrl)) {
>> +		reset_control_assert(priv->reset_ctrl);
>> +		fsleep(QCA_PHY_SET_DELAY_US);
>> +		reset_control_deassert(priv->reset_ctrl);
>> +		fsleep(QCA_PHY_SET_DELAY_US);
>> +	}
> 
> What exactly is being reset here? Which is GEPHY?
> 
> The MDIO bus master driver should not be touching any Ethernet
> PHYs. All it provides is a bus, nothing more.
> 
> The GEPHY is the embedded Giga Ethernet PHY in the chipset IPQ50xx, 
> there is a dedicated MDIO bus for this internal PHY.
> what the reset function does here is for resetting this dedicated MDIO 
> bus and this embedded PHY DSP hardware.
> because this dedicated MDIO bus is only connected with this internal 
> PHY on chip set IPQ50xx, so i put this
> code in the MDIO reset function.
> 
>> +
>> +	/* Configure MDIO clock frequency */
>> +	if (!IS_ERR(priv->mdio_clk)) {
>> +		ret = clk_set_rate(priv->mdio_clk, QCA_MDIO_CLK_RATE);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = clk_prepare_enable(priv->mdio_clk);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
>> +
>> +	/* Reset PHYs by gpio pins */
>> +	for (i = 0; i < gpiod_count(dev, "phy-reset"); i++) {
>> +		reset_gpio = gpiod_get_index_optional(dev, "phy-reset", i, 
>> GPIOD_OUT_HIGH);
>> +		if (IS_ERR(reset_gpio))
>> +			continue;
>> +		gpiod_set_value_cansleep(reset_gpio, 0);
>> +		fsleep(QCA_PHY_SET_DELAY_US);
>> +		gpiod_set_value_cansleep(reset_gpio, 1);
>> +		fsleep(QCA_PHY_SET_DELAY_US);
>> +		gpiod_put(reset_gpio);
>> +	}
> 
> No, there is common code in phylib to do that.
> 
> Hi Andrew,
> The common code in phylib for resetting PHY by GPIO pin is high active, 
> which is not suitable for the PHY reset here.
> for resetting the PHY, calling gpiod_set_value_cansleep(reset_gpio, 1), 
> then gpiod_set_value_cansleep(reset_gpio, 0).
> but as for resetting the PHY by GPIO pin in IPQ chipset, this is the 
> opposite process(low active) from the phylib code,
> which needs to set the GPIO output value to 0, then to 1 for reset as 
> the code above.
> 
>>  static int ipq4019_mdio_probe(struct platform_device *pdev)
>>  {
>>  	struct ipq4019_mdio_data *priv;
>>  	struct mii_bus *bus;
>> +	struct resource *res;
>>  	int ret;
>> 
>>  	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
>> @@ -182,14 +244,23 @@ static int ipq4019_mdio_probe(struct 
>> platform_device *pdev)
>>  		return -ENOMEM;
>> 
>>  	priv = bus->priv;
>> +	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
>> 
>>  	priv->membase = devm_platform_ioremap_resource(pdev, 0);
>>  	if (IS_ERR(priv->membase))
>>  		return PTR_ERR(priv->membase);
>> 
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +	if (res)
>> +		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
>> +
>> +	priv->reset_ctrl = devm_reset_control_get_exclusive(&pdev->dev, 
>> "gephy_mdc_rst");
>> +	priv->mdio_clk = devm_clk_get(&pdev->dev, "gcc_mdio_ahb_clk");
> 
> You probably want to use devm_clk_get_optional().
> 
>     Andrew
> 
> thanks for the comment, will update it in the next patch set.
