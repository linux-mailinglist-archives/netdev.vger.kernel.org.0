Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E826C40C9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCVDKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCVDKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822357DB6;
        Tue, 21 Mar 2023 20:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18EDA61E10;
        Wed, 22 Mar 2023 03:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBFFC433D2;
        Wed, 22 Mar 2023 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679454614;
        bh=EoRmQVKZda3Kaw+obz4g6ex3TDnd9Bc2t7OczVEjfCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sbE8F39jhkQF29LF3KT9pV7+ZXD7mEcVIGSKn7k+vtdM9xqsGprUiiImBgUV+iJ0s
         i7znxBUSzFl8TrRk+NVDXgzUmK9uFL4aBex/0nwyMLnTzIr0PjZZ2y+hGCDlqGs/bg
         +SHnNvihZQsfwbtOqFG3CcMGl2dF58FC+6386YYQQFuIY6ZVAp+L9myfqTYk0K+0Wj
         qMmUnTThqDJ7AjAfPpqpG3zljkxpMn3YUuMhFwX3v0n2Y1wM3Iy/ryXEKzzl/X/Mc7
         ULSyersgA14JPHO4dm8VPI0ZLMgEeALhMhE9biCrYubM+f5KxrTrx2/peuIW7YT8HZ
         efkJAzJ4/UVog==
Date:   Tue, 21 Mar 2023 20:10:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCHv1 1/2] net: ethernet: stmmac: dwmac-rk: fix optional
 clock handling
Message-ID: <20230321201012.74487996@kernel.org>
In-Reply-To: <20230317174243.61500-2-sebastian.reichel@collabora.com>
References: <20230317174243.61500-1-sebastian.reichel@collabora.com>
        <20230317174243.61500-2-sebastian.reichel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 18:42:42 +0100 Sebastian Reichel wrote:
> -	bsp_priv->mac_clk_rx = devm_clk_get(dev, "mac_clk_rx");
> +	bsp_priv->mac_clk_rx = devm_clk_get_optional(dev, "mac_clk_rx");
>  	if (IS_ERR(bsp_priv->mac_clk_rx))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"mac_clk_rx");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_rx),
> +				"cannot get clock %s\n", "mac_clk_rx");
>  
> -	bsp_priv->mac_clk_tx = devm_clk_get(dev, "mac_clk_tx");
> +	bsp_priv->mac_clk_tx = devm_clk_get_optional(dev, "mac_clk_tx");
>  	if (IS_ERR(bsp_priv->mac_clk_tx))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"mac_clk_tx");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->mac_clk_tx),
> +				"cannot get clock %s\n", "mac_clk_tx");
>  
> -	bsp_priv->aclk_mac = devm_clk_get(dev, "aclk_mac");
> +	bsp_priv->aclk_mac = devm_clk_get_optional(dev, "aclk_mac");
>  	if (IS_ERR(bsp_priv->aclk_mac))
> -		dev_err(dev, "cannot get clock %s\n",
> -			"aclk_mac");
> +		return dev_err_probe(dev, PTR_ERR(bsp_priv->aclk_mac),
> +				"cannot get clock %s\n", "aclk_mac");

Can we turn this into a loop

struct {
	struct whatever **ptr;
	const char *name;
} clocks[] = {
	{ &bsp_priv->mac_clk_rx, "mac_clk_rx" },
	{ &bsp_priv->mac_clk_tx, "mac_clk_tx" },
	...
}

for (i=0; i < ARRAY_SIZE...) {
	*clocks[i]->ptr = devm_clk_get_optional(dev, clocks[i]->name);
	if (IS_ERR(*clocks[i]->ptr))
		return dev_err_probe(dev, PTR_ERR(*clocks[i]->ptr),
				     "cannot get clock %s\n", 
				     *clocks[i]->name);
}

?

Or alternatively inline the name of the clock into the error message?
Right now the %s format printing looks neither here nor there, and also
the continuation line is misaligned (should start right under "dev").


FWIW seems like it should be fine for net-next without the fixes tag.
