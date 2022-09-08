Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC325B1907
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiIHJnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIHJnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E2E129529;
        Thu,  8 Sep 2022 02:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4CC61BFB;
        Thu,  8 Sep 2022 09:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C763C433C1;
        Thu,  8 Sep 2022 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662630187;
        bh=JY9PNtpyXUxCn8gB5zkJ5qofhqe+usXQS02HsM/X8K4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEMsI8urtMgADhMIcHUMuw28qEKdlf7F82wtFKFXgb0AIxUJ/dcBMrCk6WxeRXyFW
         javWtoyOpnGTLqEJMxXxc+bSTb9veFzhWMf9o5xVCbMiehs3H4Gs6EKdK3ank3dDSX
         TS8jHA4lGHVmYMnuE6dO6Hu93UOlmKZUri68ZoorN6HncBzSl/tNbHegjMVonL5CfG
         7Y6eCUxtOUDu0rF0fIZ9APt3YH0vFc7zppJCRF9nTSUaOGQAKBMilW0ka1GMg7TFXA
         ejcM6il0rTV9pxmmJfKRtd581cSaVtE7WtBQuWR8nu6BKx2s7MBQ1eWeF0kZjUysDY
         46U3FltjHSKKA==
Date:   Thu, 8 Sep 2022 10:42:58 +0100
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
Subject: Re: [RESEND PATCH v16 mfd 5/8] pinctrl: microchip-sgpio: add ability
 to be used in a non-mmio configuration
Message-ID: <Yxm5IqED2bWZwaIF@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-6-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-6-colin.foster@in-advantage.com>
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

> There are a few Ocelot chips that can contain SGPIO logic, but can be
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
> 
> Add support for these non-memory-mapped configurations.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
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
>  drivers/pinctrl/pinctrl-microchip-sgpio.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
