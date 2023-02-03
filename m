Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9500B688EF0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBCFYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBCFYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:24:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE8A1F5C1;
        Thu,  2 Feb 2023 21:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4589F61D68;
        Fri,  3 Feb 2023 05:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FFBC433D2;
        Fri,  3 Feb 2023 05:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675401880;
        bh=xXuXX/4dXghFD9OuRNy9yclf9Tgd8hQw+zZIPTdTdxw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LC+H23DawUteZ0zmGUmwaUJnUbqf3sFlyJ5fMm0dk8HlAkBLCoTfWdVZtU05gVIap
         Pac6w7xDvg1WAOIkV/49ZpMPuPRuPrONuoiih+ssj/icnHk389ctRC+b55L7ANZUwB
         qVmgNllrdRkNG88gfxSHbvMTnpkiUAJm01muRHzj3ic4HY8T/iOMUpVG/VcEymedrJ
         8B03pgYind9b86TfY9dxX9vK6EsdDIsH15bTSenOGTBT7CXXKnh5ExtAIYNeViYu/E
         sU5BWMaTTbOb0O9mbAg/l2s5i8iIBy3okWR+8JKr+q2+Hzwkurf7u4duMtgPkp6GA9
         odai2NZ4RDX/g==
Date:   Thu, 2 Feb 2023 21:24:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Clark Wang <xiaoning.wang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V3 1/2] net: phylink: add a function to resume phy alone
 to fix resume issue with WoL enabled
Message-ID: <20230202212438.18ebcc38@kernel.org>
In-Reply-To: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
References: <20230202081559.3553637-1-xiaoning.wang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Feb 2023 16:15:59 +0800 Clark Wang wrote:
> Issue we met:
> On some platforms, mac cannot work after resumed from the suspend with WoL
> enabled.
> 
> The cause of the issue:
> 1. phylink_resolve() is in a workqueue which will not be executed immediately.
>    This is the call sequence:
>        phylink_resolve()->phylink_link_up()->pl->mac_ops->mac_link_up()
>    For stmmac driver, mac_link_up() will set the correct speed/duplex...
>    values which are from link_state.
> 2. In stmmac_resume(), it will call stmmac_hw_setup() after called the
>    phylink_resume(), because mac need phy rx_clk to do the reset.
>    stmmac_core_init() is called in function stmmac_hw_setup(), which will
>    reset the mac and set the speed/duplex... to default value.
> Conclusion: Because phylink_resolve() cannot determine when it is called, it
>             cannot be guaranteed to be called after stmmac_core_init().
> 	    Once stmmac_core_init() is called after phylink_resolve(),
> 	    the mac will be misconfigured and cannot be used.
> 
> In order to avoid this problem, add a function called phylink_phy_resume()
> to resume phy separately. This eliminates the need to call phylink_resume()
> before stmmac_hw_setup().
> 
> Add another judgement before called phy_start() in phylink_start(). This way
> phy_start() will not be called multiple times when resumes. At the same time,
> it may not affect other drivers that do not use phylink_phy_resume().
> 
> Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>

Patch 2/2 never made it to the list. You'll need to repost.
While I have you - some minor nit picks:

> +/**
> + * phylink_phy_resume() - resume phy alone
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + *
> + * In the MAC driver using phylink, if the MAC needs the clock of the phy

You use MAC in capital letters buy phy in lower case, be consistent.

> + * when it resumes, can call this function to resume the phy separately.

missing "it" ? Otherwise the sentence is missing a subject.

> + * Then proceed to MAC resume operations.
> + */
> +void phylink_phy_resume(struct phylink *pl)
> +{
> +	ASSERT_RTNL();
> +
> +	if (!test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)
> +	    && pl->phydev) {

&& goes at the end of the line, not start

> +		phy_start(pl->phydev);
> +		pl->mac_resume_phy_separately = true;
> +	}
> +
> +}
> +EXPORT_SYMBOL_GPL(phylink_phy_resume);
