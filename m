Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF2697B24
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 12:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbjBOLvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 06:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjBOLve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 06:51:34 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F014513C;
        Wed, 15 Feb 2023 03:51:32 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 319A86602181;
        Wed, 15 Feb 2023 11:51:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676461890;
        bh=QSCp6bo6FjxCSjfy/l3o4z89Z1La9kTv6gN3Uu+EpL4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=A4rqdwtauXFIbQbOGHfLvjjQ6dlZiEqLF0CG/sWghsauCpAP2mXYKVMwkBAi8uEqZ
         WyAnVKG1j4VGABIVUzHJKddu8kq1OX83D1bLDMHtGsHI0oTkwtBXfMA4Hpi9kWPQHQ
         SEL0utAZxVaMKf2Rn3/aUwiy2nTVGox5FI2O/ZIxZdnaanRmdNZIk8hG7PXJMdadHn
         7p01MjXuIbSf0cggW1k1sHvKuqRRXNk2UdSqWWaS2ECm5wmKJXU5+bWLLesiDLkBTy
         0Qf3noLv63LboE1TWJ1VuVVP0d2wQjP+LjbDiK6j9PO8YUdgtvqbiop5Cg/d3aw3Ar
         FDekpJ+BswxCw==
Message-ID: <68708ef5-9a7f-b7e5-a7a0-e08f6d5ae3a3@collabora.com>
Date:   Wed, 15 Feb 2023 13:51:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Content-Language: en-US
To:     Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
 <Y+e+N/aiqCctIp6e@lunn.ch>
 <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
 <CAJM55Z8Uq2ZU3KvJZKDLZUJDLEyvHjCRJKcYn5CAOR0c2rhT7Q@mail.gmail.com>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <CAJM55Z8Uq2ZU3KvJZKDLZUJDLEyvHjCRJKcYn5CAOR0c2rhT7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 13:20, Emil Renner Berthing wrote:
> On Wed, 15 Feb 2023 at 01:09, Cristian Ciocaltea
> <cristian.ciocaltea@collabora.com> wrote:
>>
>> On 2/11/23 18:11, Andrew Lunn wrote:
>>>> +
>>>> +#define JH7100_SYSMAIN_REGISTER28 0x70
>>>> +/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
>>>> +#define JH7100_SYSMAIN_REGISTER49 0xc8
>>>
>>> Seems like the comment should be one line earlier?
> 
> Well yes, the very generic register names are also bad, but this
> comment refers to the fact that it kind of makes sense that register
> 28 has the offset
>    28 * 4 bytes pr. register = 0x70
> ..but then register 49 is oddly out of place at offset 0xc8 instead of
>    49 * 4 bytes pr. register = 0xc4
> 
>>> There is value in basing the names on the datasheet, but you could
>>> append something meaningful on the end:
>>>
>>> #define JH7100_SYSMAIN_REGISTER49_DLYCHAIN 0xc8
>>
>> Unfortunately the JH7100 datasheet I have access to doesn't provide any
>> information regarding the SYSCTRL-MAINSYS related registers. Maybe Emil
>> could provide some details here?
> 
> This is reverse engineered from the auto generated headers in their u-boot:
> https://github.com/starfive-tech/u-boot/blob/JH7100_VisionFive_devel/arch/riscv/include/asm/arch-jh7100/syscon_sysmain_ctrl_macro.h
> 
> Christian, I'm happy that you're working on this, but mess like this
> and waiting for the non-coherent dma to be sorted is why I didn't send
> it upstream yet.

Thank you for clarifying this and for all the work you have done so far, 
Emil! If you don't mind, I would be glad to continue helping with this 
mainlining effort.

>>>> +    if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk_dlychain)) {
>>>> +            ret = regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, gtxclk_dlychain);
>>>> +            if (ret)
>>>> +                    return dev_err_probe(dev, ret, "error selecting gtxclk delay chain\n");
>>>> +    }
>>>
>>> You should probably document that if starfive,gtxclk-dlychain is not
>>> found in the DT blob, the value for the delay chain is undefined.  It
>>> would actually be better to define it, set it to 0 for example. That
>>> way, you know you don't have any dependency on the bootloader for
>>> example.
>>
>> Sure, I will set it to 0.
>>
>>>
>>>        Andrew
>>
>> Thanks for reviewing,
>> Cristian
>>
>> _______________________________________________
>> linux-riscv mailing list
>> linux-riscv@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-riscv
