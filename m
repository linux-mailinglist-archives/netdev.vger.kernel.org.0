Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C06E5B18FB
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiIHJmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiIHJmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:42:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5249DB14CD;
        Thu,  8 Sep 2022 02:42:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F366FB82054;
        Thu,  8 Sep 2022 09:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9926AC433D6;
        Thu,  8 Sep 2022 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662630123;
        bh=ntPtZqkKQgA88xitl7MbgJ0C7eK0xZrwocnCU7VRuew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tE7YZ4K9o+VxFD5FsuXdd0Zel+JvLhbkWw1RHmZS8/U6uv7o7eQQDhpHZAoaC2ArY
         Xi/wTRN3zduhbyS6aSQ3vTigRp/V8Mu3oCo59zcsEHQyBIVv76SD7agU0gE2OFowYg
         qqtdYMMBUeAAko+5gKbPQGTrnCaf59/vGu4Boo1GtGfHt9romvmoxt1dKySq2hhhnF
         96W3He9ANeFeTYxwL0EIrwdcb7i63cE8sKzOktoZ+6ohnPT9jqnSmZDD6+ARraRz3y
         WsMJkZq2cLyiN/Kl5JvOH7XMuIEnuhGjQsi8qw/w3hrn7s/PEsX38K0a37scAiBTuE
         c2+5pctL62D4w==
Date:   Thu, 8 Sep 2022 10:41:55 +0100
From:   Lee Jones <lee@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, katie.morris@in-advantage.com
Subject: Re: [RESEND PATCH v16 mfd 3/8] pinctrl: ocelot: add ability to be
 used in a non-mmio configuration
Message-ID: <Yxm447l7hNKrKbto@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 05 Sep 2022, Colin Foster wrote:

> There are a few Ocelot chips that contain pinctrl logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
> 
> Add support for these non-memory-mapped configurations.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> 
> v16
>     * Add Andy Reviewed-by tag
> 
> v15
>     * No changes
> 
> v14
>     * Add Reviewed and Acked tags
> 
> ---
>  drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
