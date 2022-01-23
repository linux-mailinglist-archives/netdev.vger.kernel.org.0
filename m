Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EBE4972BB
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbiAWPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 10:52:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49648 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238181AbiAWPwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 10:52:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EMC6Ft10JXwi16PGGMWQ1pe3LM0kkBsvwtaXhgSs0wM=; b=EO0tRbP4Cm6mmtzSNEUjPEe+fN
        gEll1aTSwCLFqWNaKAehFMt6LO3f3TV6EsNHAZGABi4xyxeHb8Tpf+vbNq26LfSK0KL9iDpWUzJZI
        +kQE8nHGPjqqqISIy1/DC/Yk4uQ+cxG41jqOjV8AQAKzMk3WcnoirV20gNJSx7do3ELU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBfAL-002OLT-JC; Sun, 23 Jan 2022 16:52:29 +0100
Date:   Sun, 23 Jan 2022 16:52:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: don't stop RXC during LPI
Message-ID: <Ye15va7tFWMgKPEE@lunn.ch>
References: <20220123141245.1060-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220123141245.1060-1-jszhang@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 10:12:45PM +0800, Jisheng Zhang wrote:
> I met can't receive rx pkt issue with below steps:
> 0.plug in ethernet cable then boot normal and get ip from dhcp server
> 1.quickly hotplug out then hotplug in the ethernet cable
> 2.trigger the dhcp client to renew lease
> 
> tcpdump shows that the request tx pkt is sent out successfully,
> but the mac can't receive the rx pkt.
> 
> The issue can easily be reproduced on platforms with PHY_POLL external
> phy. If we don't allow the phy to stop the RXC during LPI, the issue
> is gone. I think it's unsafe to stop the RXC during LPI because the mac
> needs RXC clock to support RX logic.
> 
> And the 2nd param clk_stop_enable of phy_init_eee() is a bool, so use
> false instead of 0.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6708ca2aa4f7..92a9b0b226b1 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -1162,7 +1162,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
>  
>  	stmmac_mac_set(priv, priv->ioaddr, true);
>  	if (phy && priv->dma_cap.eee) {
> -		priv->eee_active = phy_init_eee(phy, 1) >= 0;
> +		priv->eee_active = phy_init_eee(phy, false) >= 0;

This has not caused issues in the past. So i'm wondering if this is
somehow specific to your system? Does everybody else use a PHY which
does not implement this bit? Does your synthesis of the stmmac have a
different clock tree?

By changing this value for every instance of the stmmac, you are
potentially causing a power regression for stmmac implementations
which don't need the clock. So we need a clear understanding, stopping
the clock is wrong in general and so the change is correct in
general. Or this is specific to your system, and you probably need to
add priv->dma_cap.keep_rx_clock_ticking, which you set in your glue
driver,and use here to decide what to pass to phy_init_eee().

	   Andrew
