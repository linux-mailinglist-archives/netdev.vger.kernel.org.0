Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77566438BBD
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhJXUD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:03:26 -0400
Received: from mleia.com ([178.79.152.223]:47018 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhJXUDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 16:03:25 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Oct 2021 16:03:25 EDT
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id E0A2B2E3E5;
        Sun, 24 Oct 2021 19:55:13 +0000 (UTC)
Subject: Re: [PATCH] net: nxp: lpc_eth.c: avoid hang when bringing interface
 down
To:     Trevor Woerner <twoerner@gmail.com>, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ARM/LPC32XX SOC SUPPORT" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20211024175003.7879-1-twoerner@gmail.com>
From:   Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <47e68cfd-6c59-3d47-78cc-c2971c379146@mleia.com>
Date:   Sun, 24 Oct 2021 22:55:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211024175003.7879-1-twoerner@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20211024_195513_938277_201D596E 
X-CRM114-Status: GOOD (  17.13  )
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Trevor,

On 10/24/21 8:50 PM, Trevor Woerner wrote:
> A hard hang is observed whenever the ethernet interface is brought
> down. If the PHY is stopped before the LPC core block is reset,
> the SoC will hang. Comparing lpc_eth_close() and lpc_eth_open() I
> re-arranged the ordering of the functions calls in lpc_eth_close() to
> reset the hardware before stopping the PHY.
> 
> Signed-off-by: Trevor Woerner <twoerner@gmail.com>
> ---
>   drivers/net/ethernet/nxp/lpc_eth.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
> index d29fe562b3de..c910fa2f40a4 100644
> --- a/drivers/net/ethernet/nxp/lpc_eth.c
> +++ b/drivers/net/ethernet/nxp/lpc_eth.c
> @@ -1015,9 +1015,6 @@ static int lpc_eth_close(struct net_device *ndev)
>   	napi_disable(&pldat->napi);
>   	netif_stop_queue(ndev);
>   
> -	if (ndev->phydev)
> -		phy_stop(ndev->phydev);
> -
>   	spin_lock_irqsave(&pldat->lock, flags);
>   	__lpc_eth_reset(pldat);
>   	netif_carrier_off(ndev);
> @@ -1025,6 +1022,8 @@ static int lpc_eth_close(struct net_device *ndev)
>   	writel(0, LPC_ENET_MAC2(pldat->net_base));
>   	spin_unlock_irqrestore(&pldat->lock, flags);
>   
> +	if (ndev->phydev)
> +		phy_stop(ndev->phydev);
>   	clk_disable_unprepare(pldat->clk);
>   
>   	return 0;
> 

thank you for the fix!

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
Best wishes,
Vladimir
