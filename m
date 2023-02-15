Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67D5697275
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjBOAIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBOAII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:08:08 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8211DBF5;
        Tue, 14 Feb 2023 16:08:07 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 890DE660217D;
        Wed, 15 Feb 2023 00:08:04 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676419686;
        bh=zoW3noIDVP825JbgOO/Z2/ogb3Eb9ppZTgw5s0u1c6c=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UfvWpf+J3tW+akDw4oW44yeBej/Sq4UK3l7YLde3GTyggOvzrm6Ey9KYOBf0Dch/y
         1pFHF63nR3TlRsC3Aj0VOX5DvVHeNBKnuyZqRF0tRlnNIrSbCP+hU1ZCnSmvUg3qvX
         R6vNoD1ZEVdWkz2ZsquvmQtfWOI5VpL2yHXn0oh/AkXfFKK4NVnnZfAbG2SXw1HGbV
         SX5mfN82oCQaQ0Xa5ehpLghlF/WW4YSASlkw5Wb9F6CFzEzN+Vt8y89a3mdJDd4bdo
         QbITCjffcDyanACGG60Jp9Yu089C5uEnzns31zBFW5/BwbFb25oYS0BgapW32IKtJK
         GJD1oSkYLWrcA==
Message-ID: <d1769dac-9e80-2f0d-6a5c-386ef70e1547@collabora.com>
Date:   Wed, 15 Feb 2023 02:08:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
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
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <Y+e+N/aiqCctIp6e@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/23 18:11, Andrew Lunn wrote:
>> +
>> +#define JH7100_SYSMAIN_REGISTER28 0x70
>> +/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
>> +#define JH7100_SYSMAIN_REGISTER49 0xc8
> 
> Seems like the comment should be one line earlier?
> 
> There is value in basing the names on the datasheet, but you could
> append something meaningful on the end:
> 
> #define JH7100_SYSMAIN_REGISTER49_DLYCHAIN 0xc8
> 
> ???

Unfortunately the JH7100 datasheet I have access to doesn't provide any 
information regarding the SYSCTRL-MAINSYS related registers. Maybe Emil 
could provide some details here?

>> +	if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk_dlychain)) {
>> +		ret = regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, gtxclk_dlychain);
>> +		if (ret)
>> +			return dev_err_probe(dev, ret, "error selecting gtxclk delay chain\n");
>> +	}
> 
> You should probably document that if starfive,gtxclk-dlychain is not
> found in the DT blob, the value for the delay chain is undefined.  It
> would actually be better to define it, set it to 0 for example. That
> way, you know you don't have any dependency on the bootloader for
> example.

Sure, I will set it to 0.

> 
> 	Andrew

Thanks for reviewing,
Cristian
