Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674AA4EE0B1
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235121AbiCaSgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiCaSgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6082325E6
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 11:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD6E2618B8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 18:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A898CC3410F;
        Thu, 31 Mar 2022 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648751696;
        bh=X6NTpNvZhRcC0c7Y87tDuzaPq7We9GTfqz8d+pFqZs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mugRf5kleNEa8iI8jbsUud66NCva2npOUIVDaMvqgpb+VYWltWxx2mc7oGeXPD5Ie
         qq9lmG4XCCnjJrKMy4po0/YFrDR5N0a+sXYq2Jz9GuwccRXnAx21cBunBS4ogmFV8h
         rGUAa7on+59yc61RJYVuOt8gn93SqgdrjCgoBlmcLrwO68MC5F1XIGKR1JsE3XjJwO
         U8Rzfs7B1BYOr6dRJQqUPy93wD2SCCJztk0greZhn+gSwWczbtnaR6/MYCU0nsSdk+
         HEJSmqMAQBAgdAnY0ymEQ0dAS9D4h5flsClRZ3dd/KQ+C7Abfn4hNn+bm+d9VvHLAJ
         JpKj82V9qNVHg==
Date:   Thu, 31 Mar 2022 11:34:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen-Yu Tsai <wens@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: Fix unset max_speed difference between DT
 and non-DT platforms
Message-ID: <20220331113454.03bc84b7@kernel.org>
In-Reply-To: <20220331171827.12483-1-wens@kernel.org>
References: <20220331171827.12483-1-wens@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Apr 2022 01:18:27 +0800 Chen-Yu Tsai wrote:
> From: Chen-Yu Tsai <wens@csie.org>
> 
> In commit 9cbadf094d9d ("net: stmmac: support max-speed device tree
> property"), when DT platforms don't set "max-speed", max_speed is set to
> -1; for non-DT platforms, it stays the default 0.
> 
> Prior to commit eeef2f6b9f6e ("net: stmmac: Start adding phylink support"),
> the check for a valid max_speed setting was to check if it was greater
> than zero. This commit got it right, but subsequent patches just checked
> for non-zero, which is incorrect for DT platforms.
> 
> In commit 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> the conversion switched completely to checking for non-zero value as a
> valid value, which caused 1000base-T to stop getting advertised by
> default.
> 
> Instead of trying to fix all the checks, simply leave max_speed alone if
> DT property parsing fails.
> 
> Fixes: 9cbadf094d9d ("net: stmmac: support max-speed device tree property")
> Fixes: 92c3807b9ac3 ("net: stmmac: convert to phylink_get_linkmodes()")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---

You should always CC authors of patches you put on CC as they have 
the most context to review, usually. Please use get_maintainers.pl
and repost.

> This was first noticed on ROC-RK3399-PC, and also observed on ROC-RK3328-CC.
> The fix was tested on ROC-RK3328-CC and Libre Computer ALL-H5-ALL-CC.
> 
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 5d29f336315b..11e1055e8260 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -431,8 +431,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>  	plat->phylink_node = np;
>  
>  	/* Get max speed of operation from device tree */
> -	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
> -		plat->max_speed = -1;
> +	of_property_read_u32(np, "max-speed", &plat->max_speed);
>  
>  	plat->bus_id = of_alias_get_id(np, "ethernet");
>  	if (plat->bus_id < 0)

