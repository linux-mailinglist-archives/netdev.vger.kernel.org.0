Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F725696C89
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbjBNSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjBNSMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:12:46 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF30A8;
        Tue, 14 Feb 2023 10:12:42 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 59EC86602174;
        Tue, 14 Feb 2023 18:12:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676398360;
        bh=0/EG0sklC8qUexXu0LYmfC2BO1OVBbV9Fcsg9x+88a4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m0/HxerAwjPWxchWbVHrWiidbzPuqSL30laX0/Fa8a6CXl8+IjtWG74Eml/d7BIJk
         dYi0I+FNt4t4GqhEcuAfI1Rqlb98CMZ+u2D179uTxp/UMogSEHpenrfYk2WwvYp5wS
         V0DX/gTadp9vSNI0LWsr6pcFZR4JNCli1X1Da6QuYboYAEcSyxGtsWV/xSgjCa2yEp
         Psph/A9m256McoWjzZ+sfoTNCnXcUyJ1wE/A+fqcC3YDNOQWdIuE+LlM0MikAV3Ocr
         bspbDLgNKxznYOi4F0o5HMbPJkTXGdCtBVwhddBy0kbHHv3lhIUh3dnh3U3Syzr6bE
         pvhOS/697MvLw==
Message-ID: <fcfc3ede-6799-4dc2-d390-148370dfc5c8@collabora.com>
Date:   Tue, 14 Feb 2023 20:12:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
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
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
 <dbf26e3f-6a4f-cd15-c7d3-b0c1c482b83b@linaro.org>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <dbf26e3f-6a4f-cd15-c7d3-b0c1c482b83b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 11:26, Krzysztof Kozlowski wrote:
> On 11/02/2023 04:18, Cristian Ciocaltea wrote:
>> From: Emil Renner Berthing <kernel@esmil.dk>
>>
>> This adds a glue layer for the Synopsys DesignWare MAC IP core on the
>> StarFive JH7100 SoC.
>>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> [drop references to JH7110, update JH7100 compatible string]
>> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>> ---
>>   MAINTAINERS                                   |   1 +
>>   drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>>   drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>   .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
>>   4 files changed, 169 insertions(+)
>>   create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index d48468b81b94..defedaff6041 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -19820,6 +19820,7 @@ STARFIVE DWMAC GLUE LAYER
>>   M:	Emil Renner Berthing <kernel@esmil.dk>
>>   S:	Maintained
>>   F:	Documentation/devicetree/bindings/net/starfive,jh7100-dwmac.yaml
>> +F:	drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>>   
>>   STARFIVE JH7100 CLOCK DRIVERS
>>   M:	Emil Renner Berthing <kernel@esmil.dk>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> index f77511fe4e87..2c81aa594291 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
>> @@ -165,6 +165,18 @@ config DWMAC_SOCFPGA
>>   	  for the stmmac device driver. This driver is used for
>>   	  arria5 and cyclone5 FPGA SoCs.
>>   
>> +config DWMAC_STARFIVE
>> +	tristate "StarFive DWMAC support"
> 
> Bring only one driver.
> 
> https://lore.kernel.org/all/20230118061701.30047-6-yanhong.wang@starfivetech.com/

Already mentioned in the cover letter that we have this overlap (will be 
merged into a single driver).

Thanks,
Cristian

> 
> Best regards,
> Krzysztof
> 
> 
