Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACDC29EBEA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 13:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgJ2MfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 08:35:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgJ2MfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 08:35:00 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY78f-0049Z4-HE; Thu, 29 Oct 2020 13:34:45 +0100
Date:   Thu, 29 Oct 2020 13:34:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: stmmac: platform: remove useless if/else
Message-ID: <20201029123445.GH933237@lunn.ch>
References: <1603938832-53705-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603938832-53705-1-git-send-email-zou_wei@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 10:33:52AM +0800, Zou Wei wrote:
> Fix the following coccinelle report:
> 
> ./drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:233:6-8:
> WARNING: possible condition with no effect (if == else)
> 
> Both branches are the same, so remove the else if/else altogether.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index af34a4c..f6c69d0 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -230,8 +230,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
>  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
>  	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
>  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
> -	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
> -		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
>  	else
>  		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;

I actually prefer the original code. Code is also documentation. It
documents the fact, if "snps,tx-sched-sp" is in device tree, we use
MTL_TX_ALGORITHM_SP, but otherwise we default to MTL_TX_ALGORITHM_SP.

As with my suggestion for forcedeth, i would move the default setting
to before the whole if/else if/else block to document it is the
default.

Or just consider this a false positive and leave it alone. I can see
value in the coccinelle script, but it is going to have a lot of false
positive cases, so i'm not sure there is value in working around them
all.

	Andrew
