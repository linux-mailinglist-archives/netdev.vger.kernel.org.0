Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAEB38D1CC
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhEUXDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 19:03:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52320 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhEUXDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 19:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3eyE3j5kXNd1R9JtqozjVpdwVfwoFMX9qTw0dtg6Eag=; b=Y/IWALEaqAdpSlte4v7iVSOwAo
        9TaWujfQH+3JJ6HlthNKl3F+UHv6WbvkWcjsAjTDfGdqTQGbr5bxqz6wFeHAvia3ThdOhU6u35GU0
        eIvAjbHEGSUjguLV11Z86B11XH2Z+41FSk8UDZulo9+o+VPH0X0pSb/ylzrGDwrfa0V4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lkE9n-005LZE-6o; Sat, 22 May 2021 01:02:15 +0200
Date:   Sat, 22 May 2021 01:02:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dpaa2-eth: don't print error from
 dpaa2_mac_connect if that's EPROBE_DEFER
Message-ID: <YKg79wM9jBETgPLv@lunn.ch>
References: <20210521141220.4057221-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521141220.4057221-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 05:12:20PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When booting a board with DPAA2 interfaces defined statically via DPL
> (as opposed to creating them dynamically using restool), the driver will
> print an unspecific error message.
> 
> This change adds the error code to the message, and avoids printing
> altogether if the error code is EPROBE_DEFER, because that is not a
> cause of alarm.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index e0c3c58e2ac7..8433aa730c42 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -4164,10 +4164,11 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
>  
>  	if (dpaa2_eth_is_type_phy(priv)) {
>  		err = dpaa2_mac_connect(mac);
> -		if (err) {
> -			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
> +		if (err && err != -EPROBE_DEFER)
> +			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe",
> +				   ERR_PTR(err));

Hi Vladimir

it might be worth adding a netdev_err_probe(), making use of
dev_err_probe().

	Andrew
