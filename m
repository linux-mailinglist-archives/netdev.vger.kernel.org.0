Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A999469641
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbhLFNIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:08:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243777AbhLFNIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=NhEwzWU/qPdq7k1DeYXqnguBwzCFfvpMixlYF0ay2NM=; b=eKV3SW3cBbvmMvhmC7HoVk0py3
        AaKO6ZmmXeyp2W0zIgfWaiCMpU5fiKL4hBD6UPKp/7IRN8xR2Vy41PBl8v79TGy3lJvzdRJdntjL3
        cUeksgB5vYyXIgRSgl074LJANXnI6UbZdGHkZvyhXXcNynY3XyeooGSVWtiH8OOd4Eic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muDfl-00Ff2V-FQ; Mon, 06 Dec 2021 14:04:49 +0100
Date:   Mon, 6 Dec 2021 14:04:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nicolas.diaz@nxp.com,
        rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: Re: [PATCH] net: fec: only clear interrupt of handling queue in
 fec_enet_rx_queue()
Message-ID: <Ya4KcYlZypEDjQbC@lunn.ch>
References: <20211206090553.28615-1-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206090553.28615-1-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 05:05:53PM +0800, Joakim Zhang wrote:
> Only clear interrupt of handling queue in fec_enet_rx_queue(), to avoid
> missing packets caused by clear interrupt of other queues.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 09df434b2f87..eeefed3043ad 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1506,7 +1506,12 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  			break;
>  		pkt_received++;
>  
> -		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
> +		if (queue_id == 0)
> +			writel(FEC_ENET_RXF_0, fep->hwp + FEC_IEVENT);
> +		else if (queue_id == 1)
> +			writel(FEC_ENET_RXF_1, fep->hwp + FEC_IEVENT);
> +		else
> +			writel(FEC_ENET_RXF_2, fep->hwp + FEC_IEVENT);

The change itself seems find.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But could it be moved out of the loop? If you have a budget of 64,
don't you clear this bit 64 times? Can you just clearing it once on
exit?

    Andrew
