Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9458EF32ED
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbfKGPZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:25:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727142AbfKGPZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 10:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VHLQviatAs9ZqQQx5vMAJFgFa1NM1ztWGrBG/mJfE5Y=; b=SNApodmS+wmwSmGN98S/JbBJcL
        ok9iCajzq0gFB9BtWRnzQ5ZgCyMvhJ8K2aDsBm6JK0LWuGxYTA68Z6stS2PcDaMZVa9K1xxLmgNZv
        AEWqR2tS/OuvaWCjybh4X/ydcWIdgsKLxRfWWbUZc5ErVPxKLw2yx+jZALgfj0aOCvOU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSjfA-0006jB-3F; Thu, 07 Nov 2019 16:25:32 +0100
Date:   Thu, 7 Nov 2019 16:25:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] enetc: add ioctl() support for PHY-related ops
Message-ID: <20191107152532.GD7344@lunn.ch>
References: <20191107083937.18228-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107083937.18228-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 09:39:37AM +0100, Michael Walle wrote:
> If there is an attached PHY try to handle the requested ioctl with its
> handler, which allows the userspace to access PHY registers, for
> example. This will make mii-diag and similar tools work.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index b6ff89307409..25af207f1962 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1599,7 +1599,10 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
>  	if (cmd == SIOCGHWTSTAMP)
>  		return enetc_hwtstamp_get(ndev, rq);
>  #endif
> -	return -EINVAL;
> +
> +	if (!ndev->phydev)
> +		return -EINVAL;

Hi Michael

I think EOPNOTSUPP is normal. Yes, you are just moving around what was
there before, but you could make this improvement as well.

If you don't want to:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
