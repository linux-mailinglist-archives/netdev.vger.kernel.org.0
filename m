Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF8F5B18F1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiIHJlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbiIHJk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:40:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A01DDAB98;
        Thu,  8 Sep 2022 02:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8DD661C1D;
        Thu,  8 Sep 2022 09:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5287AC433D6;
        Thu,  8 Sep 2022 09:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662630056;
        bh=5RUm81zlERyd6+Ku9Ye7uJNcw3jwPTJ2bSQ9G+rtz/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Frp7Mtje39BEl9ywxYXj2XQNm+g0nazFVUP/IpDYJf+CWzSayLbBJ2I7et4jv6wGB
         BbTqnkNiToYzsPOFxTPaPWXoK01UhmMGnw5H08khA5XB5Dsbyap9zOWTA9CMpZniUe
         4A991NF5lB8u9gf4A0RverqSsQ4bQH4skSN2ZBazBx34WfdqJmsBb/0AyjHtEMt3nl
         5nDjVQFALRX5hJFBZy88TBGGdOQFl+HQuXKKN7oB38PhZXXHMd/ZP0sdtpkknlc5E7
         7cJUk9bgvr+pt9ap0kgh1s3ZwTxwaRR68N/Y5LHR5Hzig2PpCmIDQTqF/Ito7yqGMN
         mw3cXjQhNJ3Og==
Date:   Thu, 8 Sep 2022 10:40:48 +0100
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
Subject: Re: [RESEND PATCH v16 mfd 1/8] mfd: ocelot: add helper to get regmap
 from a resource
Message-ID: <Yxm4oMq8dpsFg61b@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-2-colin.foster@in-advantage.com>
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

> Several ocelot-related modules are designed for MMIO / regmaps. As such,
> they often use a combination of devm_platform_get_and_ioremap_resource()
> and devm_regmap_init_mmio().
> 
> Operating in an MFD might be different, in that it could be memory mapped,
> or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
> instead of IORESOURCE_MEM becomes necessary.
> 
> When this happens, there's redundant logic that needs to be implemented in
> every driver. In order to avoid this redundancy, utilize a single function
> that, if the MFD scenario is enabled, will perform this fallback logic.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
> v16
>     * Add Andy Reviewed-by tag
> 
> v15
>     * Add missed errno.h and ioport.h includes
>     * Add () to function references in both the commit log and comments
> 
> v14
>     * Add header guard
>     * Change regs type from u32* to void*
>     * Add Reviewed-by tag
> 
> ---
>  MAINTAINERS                |  5 +++
>  include/linux/mfd/ocelot.h | 62 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
>  create mode 100644 include/linux/mfd/ocelot.h

Applied, thanks.

-- 
Lee Jones [李琼斯]
