Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD06939F50B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 13:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhFHLfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 07:35:37 -0400
Received: from out28-194.mail.aliyun.com ([115.124.28.194]:40036 "EHLO
        out28-194.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhFHLff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 07:35:35 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07732842|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0809714-0.0100507-0.908978;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KPPW5GU_1623152014;
Received: from 192.168.88.129(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KPPW5GU_1623152014)
          by smtp.aliyun-inc.com(10.147.41.137);
          Tue, 08 Jun 2021 19:33:36 +0800
Subject: Re: [PATCH 2/2] net: stmmac: Add Ingenic SoCs MAC support.
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
References: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623086867-119039-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YL6zYgGdqxqL9c0j@lunn.ch>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <6532a195-65db-afb3-37a2-f68bfed9d908@wanyeetech.com>
Date:   Tue, 8 Jun 2021 19:33:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <YL6zYgGdqxqL9c0j@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2021/6/8 上午8:01, Andrew Lunn wrote:
>>   config DWMAC_ROCKCHIP
>>   	tristate "Rockchip dwmac support"
>> -	default ARCH_ROCKCHIP
>> +	default MACH_ROCKCHIP
>>   	depends on OF && (ARCH_ROCKCHIP || COMPILE_TEST)
>>   	select MFD_SYSCON
>>   	help
>> @@ -164,7 +176,7 @@ config DWMAC_STI
>>   
>>   config DWMAC_STM32
>>   	tristate "STM32 DWMAC support"
>> -	default ARCH_STM32
>> +	default MACH_STM32
> It would be good to explain in the commit message why you are changing
> these two. It is not obvious.


Apologize for my carelessness, this is left over accidentally when 
cleaning up the code, I will remove them in the next version.


>
>> +static int jz4775_mac_set_mode(struct plat_stmmacenet_data *plat_dat)
>> +{
>> +	struct ingenic_mac *mac = plat_dat->bsp_priv;
>> +	int val;
>> +
>> +	switch (plat_dat->interface) {
>> +	case PHY_INTERFACE_MODE_MII:
>> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_MII);
>> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_MII\n");
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_GMII:
>> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_GMII);
>> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_GMII\n");
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_RMII:
>> +		val = FIELD_PREP(MACPHYC_TXCLK_SEL_MASK, MACPHYC_TXCLK_SEL_INPUT) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RMII);
>> +		pr_debug("MAC PHY Control Register: PHY_INTERFACE_MODE_RMII\n");
>> +		break;
>> +
>> +	case PHY_INTERFACE_MODE_RGMII:
> What about the other three RGMII modes?
>
>> +	case PHY_INTERFACE_MODE_RGMII:
>> +		val = FIELD_PREP(MACPHYC_TX_SEL_MASK, MACPHYC_TX_SEL_DELAY) |
>> +			  FIELD_PREP(MACPHYC_TX_DELAY_MASK, MACPHYC_TX_DELAY_63_UNIT) |
>> +			  FIELD_PREP(MACPHYC_RX_SEL_MASK, MACPHYC_RX_SEL_ORIGIN) |
>> +			  FIELD_PREP(MACPHYC_PHY_INFT_MASK, MACPHYC_PHY_INFT_RGMII);
> What exactly does MACPHYC_TX_DELAY_63_UNIT mean here? Ideally, the MAC
> should not be adding any RGMII delays. It should however pass mode
> through to the PHY, so it can add the delays, if the mode indicates it
> should, e.g. PHY_INTERFACE_MODE_RGMII_ID. This is also why you should
> be handling all 4 RGMII modes here, not just one.


MACPHYC_TX_DELAY_63_UNIT means set MAC TX clk delay to 63 units (similar to the "tx-delay" in dwmac-rk.c). However, the manual does not clearly describe the time span of one unit, after consulting engineer of Ingenic, I learned that the value is recommended to be set to 63.
I will change it to be similar to the way done in dwmac-rk.c.

Thanks and best regards!


>
> 	 Andrew
