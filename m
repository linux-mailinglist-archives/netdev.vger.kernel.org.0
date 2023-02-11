Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C72693256
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 17:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBKQLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 11:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBKQLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 11:11:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8F28A66;
        Sat, 11 Feb 2023 08:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=QIsGxB3foIcUzmrB1itBt2fP/mbnt75It4usqWhNhqE=; b=P7
        vtKGwpGWflFG3N+B1RRIjxiM27gprx3GRBS7un6JwuWk8/FV4d9LEQ4CwLk+IFnSxLF22ydIkzt32
        X9aBWQyuop1jYaVXEqsxufkvQT5F3P3eUtKeDSavDF2GGB9RX3+B35o5Hygx+fQ2daJPJiXTvnERk
        aEASDZm9A+FlUko=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pQsTP-004iBC-Gy; Sat, 11 Feb 2023 17:11:35 +0100
Date:   Sat, 11 Feb 2023 17:11:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
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
Subject: Re: [PATCH 08/12] net: stmmac: Add glue layer for StarFive JH7100 SoC
Message-ID: <Y+e+N/aiqCctIp6e@lunn.ch>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230211031821.976408-9-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +
> +#define JH7100_SYSMAIN_REGISTER28 0x70
> +/* The value below is not a typo, just really bad naming by StarFive ¯\_(ツ)_/¯ */
> +#define JH7100_SYSMAIN_REGISTER49 0xc8

Seems like the comment should be one line earlier?

There is value in basing the names on the datasheet, but you could
append something meaningful on the end:

#define JH7100_SYSMAIN_REGISTER49_DLYCHAIN 0xc8

???

> +	if (!of_property_read_u32(np, "starfive,gtxclk-dlychain", &gtxclk_dlychain)) {
> +		ret = regmap_write(sysmain, JH7100_SYSMAIN_REGISTER49, gtxclk_dlychain);
> +		if (ret)
> +			return dev_err_probe(dev, ret, "error selecting gtxclk delay chain\n");
> +	}

You should probably document that if starfive,gtxclk-dlychain is not
found in the DT blob, the value for the delay chain is undefined.  It
would actually be better to define it, set it to 0 for example. That
way, you know you don't have any dependency on the bootloader for
example.

	Andrew
