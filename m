Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43533E4600
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhHINCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:02:55 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:52093 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbhHINCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:02:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628514154; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=KtUqhdxeXHYQtJGeZBIygKhoiIrAgKcUwoMNQMcw69A=; b=sHO0lnukSCa3WYutr3UecqW0x0sssCpJ4FjWl0II7FiArJ7+k1oP9b5by3eqLwsUugw1TN4h
 JXOCgR1ZnIo+FuNTbJJSmzsca0N3keKXBm66S/TaG8mRq/WJPWE4jnRPE8dL171cCmCNsmkl
 5XnD7ZkQ/CWD7KFAmT2jMPWabZA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61112735b3873958f56de78e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 09 Aug 2021 13:01:41
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 150F5C43144; Mon,  9 Aug 2021 13:01:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.92.0.248] (unknown [180.166.53.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76709C433F1;
        Mon,  9 Aug 2021 13:01:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76709C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=luoj@codeaurora.org
Subject: Re: [PATCH v1 1/2] net: mdio: Add the reset function for IPQ MDIO
 driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
References: <20210808072111.8365-1-luoj@codeaurora.org>
 <20210808072111.8365-2-luoj@codeaurora.org> <YQ/3ycEU9zkn8idJ@lunn.ch>
From:   Jie Luo <luoj@codeaurora.org>
Message-ID: <a698552a-0bc2-c0d4-d6f8-0d70c50373bb@codeaurora.org>
Date:   Mon, 9 Aug 2021 21:01:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQ/3ycEU9zkn8idJ@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/8/2021 11:27 PM, Andrew Lunn wrote:
>> +static int ipq_mdio_reset(struct mii_bus *bus)
>> +{
>> +	struct ipq4019_mdio_data *priv = bus->priv;
>> +	u32 val;
>> +	int ret;
>> +
>> +	/* To indicate CMN_PLL that ethernet_ldo has been ready if platform resource 1
>> +	 * is specified in the device tree.
>> +	 * */
>> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
>> +		val = readl(priv->eth_ldo_rdy);
>> +		val |= BIT(0);
>> +		writel(val, priv->eth_ldo_rdy);
>> +		fsleep(IPQ_PHY_SET_DELAY_US);
>> +	}
>> +
>> +	/* Configure MDIO clock source frequency if clock is specified in the device tree */
>> +	if (!IS_ERR_OR_NULL(priv->mdio_clk)) {
>> +		ret = clk_set_rate(priv->mdio_clk, IPQ_MDIO_CLK_RATE);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = clk_prepare_enable(priv->mdio_clk);
>> +		if (ret)
>> +			return ret;
>> +	}
> These !IS_ERR() are pretty ugly. So
>
>> @@ -182,14 +221,22 @@ static int ipq4019_mdio_probe(struct platform_device *pdev)
>>   		return -ENOMEM;
>>   
>>   	priv = bus->priv;
>> +	priv->eth_ldo_rdy = IOMEM_ERR_PTR(-EINVAL);
>>   
>>   	priv->membase = devm_platform_ioremap_resource(pdev, 0);
>>   	if (IS_ERR(priv->membase))
>>   		return PTR_ERR(priv->membase);
>>   
>> +	priv->mdio_clk = devm_clk_get_optional(&pdev->dev, "gcc_mdio_ahb_clk");
> If this returns an error, it is a real error. You should not ignore
> it. Fail the probe returning the error. That then means when the reset
> function is called priv->mdio_clk contains either a clock, or NULL,
> which the clk API is happy to take. No need for an if.
>
>
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +	if (res)
>> +		priv->eth_ldo_rdy = devm_ioremap_resource(&pdev->dev, res);
> platform_get_resource() returns a pointer or NULL. There is no error
> code. So
>
>> +	if (!IS_ERR(priv->eth_ldo_rdy)) {
> is actually wrong, should simply become
>
>> +	if (priv->eth_ldo_rdy) {
>    Andrew

Hi Andrew,

Thanks for the kindly review and the comments, will follow it in the 
next patch set.

