Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0E5B18F7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiIHJlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 05:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiIHJln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 05:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E06311CD66;
        Thu,  8 Sep 2022 02:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0E3B8204E;
        Thu,  8 Sep 2022 09:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604A5C433D6;
        Thu,  8 Sep 2022 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662630094;
        bh=gjJ/TGqcRR9ecAt4ZR7yQsjCFx/p0Rwdk5hZZDpIpBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AsH3FSqMr1GKGMBQZDYaMZfZeckDY9jUfgTJP+iIsOTzuzBeg142Sx6pdGnBqSTs6
         ZvLAOFSUDMVN/CPlf35w61diFPXpsIroGtTkwbran2hcE7LVtIHl93zqj8PIgwYQ4w
         xbI5bRNpaMC2KS+yMPcWfdfUL00LcXpvzNBA82y3P1CLKqA8WjohsW+K7iNTR9HWZy
         +KiYb21KMuxF3NgrAIyPHl9jsgra2KYZknsyearVHuHuvk3EDejdUhVrWznW9G4FB3
         tEyMhDpeVSQfdycot7P0M0xGORy8Xhl65w2YVW1/Y3rgq19FdXdxOTs0Xo4weEt2N/
         HiNxkAf+TilhA==
Date:   Thu, 8 Sep 2022 10:41:27 +0100
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
Subject: Re: [RESEND PATCH v16 mfd 2/8] net: mdio: mscc-miim: add ability to
 be used in a non-mmio configuration
Message-ID: <Yxm4x4qwlaGKF19X@google.com>
References: <20220905162132.2943088-1-colin.foster@in-advantage.com>
 <20220905162132.2943088-3-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220905162132.2943088-3-colin.foster@in-advantage.com>
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

> There are a few Ocelot chips that contain the logic for this bus, but are
> controlled externally. Specifically the VSC7511, 7512, 7513, and 7514. In
> the externally controlled configurations these registers are not
> memory-mapped.
> 
> Add support for these non-memory-mapped configurations.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
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
>  drivers/net/mdio/mdio-mscc-miim.c | 42 +++++++++----------------------
>  1 file changed, 12 insertions(+), 30 deletions(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
