Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B86D643DB8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLFHkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiLFHkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:40:00 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA3F193D3;
        Mon,  5 Dec 2022 23:39:55 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 7515224E1D3;
        Tue,  6 Dec 2022 15:39:47 +0800 (CST)
Received: from EXMBX173.cuchost.com (172.16.6.93) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 6 Dec
 2022 15:39:47 +0800
Received: from [192.168.120.49] (171.223.208.138) by EXMBX173.cuchost.com
 (172.16.6.93) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 6 Dec
 2022 15:39:45 +0800
Message-ID: <97418c57-ba31-aa16-ed8f-208dad4ac0d2@starfivetech.com>
Date:   Tue, 6 Dec 2022 15:39:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1 4/7] net: phy: motorcomm: Add YT8531 phy support
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-5-yanhong.wang@starfivetech.com>
 <Y4jK5VBVuAnl55Xz@lunn.ch>
Content-Language: en-US
From:   yanhong wang <yanhong.wang@starfivetech.com>
In-Reply-To: <Y4jK5VBVuAnl55Xz@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX173.cuchost.com
 (172.16.6.93)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/1 23:40, Andrew Lunn wrote:
>> +static const struct ytphy_reg_field ytphy_rxtxd_grp[] = {
>> +	{ "rx_delay_sel", GENMASK(13, 10), 0x0 },
>> +	{ "tx_delay_sel_fe", GENMASK(7, 4), 0xf },
>> +	{ "tx_delay_sel", GENMASK(3, 0), 0x1 }
>> +};
>> +
>> +static const struct ytphy_reg_field ytphy_txinver_grp[] = {
>> +	{ "tx_inverted_1000", BIT(14), 0x0 },
>> +	{ "tx_inverted_100", BIT(14), 0x0 },
>> +	{ "tx_inverted_10", BIT(14), 0x0 }
>> +};
>> +
>> +static const struct ytphy_reg_field ytphy_rxden_grp[] = {
>> +	{ "rxc_dly_en", BIT(8), 0x1 }
>> +};
>> +
>> +static int ytphy_config_init(struct phy_device *phydev)
>> +{
>> +	struct device_node *of_node;
>> +	u32 val;
>> +	u32 mask;
>> +	u32 cfg;
>> +	int ret;
>> +	int i = 0;
>> +
>> +	of_node = phydev->mdio.dev.of_node;
>> +	if (of_node) {
>> +		ret = of_property_read_u32(of_node, ytphy_rxden_grp[0].name, &cfg);
> 
> You need to document the device tree binding.
> 
> Frank Sae always gets the locking wrong in this driver. Have you
> tested your patch with lockdep enabled?
> 

I will add document to describe details in the next version, such as "rx_delay_sel","tx_inverted_10" etc.

>     Andrew


