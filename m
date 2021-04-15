Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1853615D9
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbhDOXK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:10:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhDOXK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:10:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXB7s-00GyY2-Pu; Fri, 16 Apr 2021 01:10:20 +0200
Date:   Fri, 16 Apr 2021 01:10:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: mediatek: ppe: fix busy wait loop
Message-ID: <YHjH3DxteZrID2hW@lunn.ch>
References: <20210415230234.14895-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415230234.14895-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 04:02:34PM -0700, Ilya Lipnitskiy wrote:
> The intention is for the loop to timeout if the body does not succeed.
> The current logic calls time_is_before_jiffies(timeout) which is false
> until after the timeout, so the loop body never executes.
> 
> time_is_after_jiffies(timeout) will return true until timeout is less
> than jiffies, which is the intended behavior here.
> 
> Fixes: ba37b7caf1ed ("net: ethernet: mtk_eth_soc: add support for initializing the PPE")
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
> Cc: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_ppe.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
> index 71e1ccea6e72..af3c266297aa 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
> @@ -46,7 +46,7 @@ static int mtk_ppe_wait_busy(struct mtk_ppe *ppe)
>  {
>  	unsigned long timeout = jiffies + HZ;
>  
> -	while (time_is_before_jiffies(timeout)) {
> +	while (time_is_after_jiffies(timeout)) {
>  		if (!(ppe_r32(ppe, MTK_PPE_GLO_CFG) & MTK_PPE_GLO_CFG_BUSY))
>  			return 0;

Maybe see is iopoll.h can be used.

      Andrew

>  
> -- 
> 2.31.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
