Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8DF1D3F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732452AbfKFSMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:12:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfKFSMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 13:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ql6gwXAOAwvh2zRxBMnKt0ol68zRLOWR3hAo8drYM2U=; b=O+pJTJfsDgHm+psr+qtQYtRB1J
        lBjczeTu2OQRHA2uLuGUZJi4piArK6u4sgkP+osKQd8DpRBdEasXO699aC/ROcs2nWGP/y4i/8a+l
        SQvZMKqDdlPZ4j8xyfBCaOH0xoxX0amPjPpgaru/AzX+d/fb28lOPTVPbF2Ws0j6oYsI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSPnM-0000oB-My; Wed, 06 Nov 2019 19:12:40 +0100
Date:   Wed, 6 Nov 2019 19:12:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe Roullier <christophe.roullier@st.com>
Cc:     robh@kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        mark.rutland@arm.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: ethernet: stmmac: Add support for
 syscfg clock
Message-ID: <20191106181240.GG30762@lunn.ch>
References: <20191106101220.12693-1-christophe.roullier@st.com>
 <20191106101220.12693-2-christophe.roullier@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106101220.12693-2-christophe.roullier@st.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 11:12:17AM +0100, Christophe Roullier wrote:
> Add optional support for syscfg clock in dwmac-stm32.c
> Now Syscfg clock is activated automatically when syscfg
> registers are used
> 
> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 28 +++++++++++--------
>  1 file changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> index 4ef041bdf6a1..be7d58d83cfa 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c
> @@ -152,19 +152,24 @@ static int stm32mp1_clk_prepare(struct stm32_dwmac *dwmac, bool prepare)
>  	int ret = 0;
>  
>  	if (prepare) {
> -		ret = clk_prepare_enable(dwmac->syscfg_clk);
> -		if (ret)
> -			return ret;
> -
> +		if (dwmac->syscfg_clk) {
> +			ret = clk_prepare_enable(dwmac->syscfg_clk);
> +			if (ret)
> +				return ret;
> +		}

Hi Christophe

I think you did not understand what i said.  clk_prepare_enable() is
happy to take a NULL pointer. So you don't need this new guard. You
don't need this change at all.

>  		if (dwmac->clk_eth_ck) {
>  			ret = clk_prepare_enable(dwmac->clk_eth_ck);
>  			if (ret) {
> -				clk_disable_unprepare(dwmac->syscfg_clk);
> +				if (dwmac->syscfg_clk)
> +					clk_disable_unprepare
> +						(dwmac->syscfg_clk);

clk_disable_unprepare() is happy to take a NULL pointer...

	Andrew
