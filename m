Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DC83D2525
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhGVNZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:25:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhGVNZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9I5Yn7jbTPFxeXXmcV2hyvn+AXm6wM45iGZ04yQBfXQ=; b=bMKIeQtSLgDOkvicAxFY0sKlS4
        kF+iLqp2nfKqlyFO6hmC2k/RqoQ+vBpSIKd++M/TYjDiN7E49QOmRyGFcbSsFCt4Guu9TJFKD1DUB
        XkPjjIh1GtXMizQwobvTW6tsqSIkVX6pMC5b5AT3YDYckq1fzHtTFdcnNJAyuNUcG+sw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6ZKQ-00EL32-0X; Thu, 22 Jul 2021 16:05:34 +0200
Date:   Thu, 22 Jul 2021 16:05:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 net-next 1/1] net: ethernet: ti: cpsw: allow MTU >
 1500 when overridden by module parameter
Message-ID: <YPl7LdLMMTmhSu1z@lunn.ch>
References: <20210721210538.22394-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721210538.22394-1-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 02:05:38PM -0700, Colin Foster wrote:
> The module parameter rx_packet_max can be overridden at module load or
> boot args. But it doesn't adjust the max_mtu for the device accordingly.
> 
> If a CPSW device is to be used in a DSA architecture, increasing the
> MTU by small amounts to account for switch overhead becomes necessary.
> This way, a boot arg of cpsw.rx_packet_max=1600 should allow the MTU
> to be increased to values of 1520, which is necessary for DSA tagging
> protocols like "ocelot" and "seville".

Hi Colin

As far as your patch goes, it makes sense.

However, module parameters are unlikely by netdev maintainers. Having
to set one in order to make DSA work is not nice. What is involved in
actually removing the module parameter and making the MTU change work
without it?

> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index c0cd7de88316..d400163c4ef2 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1625,6 +1625,14 @@ static int cpsw_probe(struct platform_device *pdev)
>  		goto clean_cpts;
>  	}
>  
> +	/* adjust max_mtu to match module parameter rx_packet_max */
> +	if (cpsw->rx_packet_max > CPSW_MAX_PACKET_SIZE) {
> +		ndev->max_mtu = ETH_DATA_LEN + (cpsw->rx_packet_max -
> +				CPSW_MAX_PACKET_SIZE);
> +		dev_info(dev, "overriding default MTU to %d\n\n",
> +			 ndev->max_mtu);

There is no need for dev_info(). You could consider dev_dbg(), or just
remove it.

       Andrew
