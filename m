Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5ECC7663F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfGZMu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:50:56 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:38407 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfGZMu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:50:56 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 89D6C20004;
        Fri, 26 Jul 2019 12:50:53 +0000 (UTC)
Date:   Fri, 26 Jul 2019 14:50:53 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] mvpp2: refactor MTU change code
Message-ID: <20190726125053.GA5031@kwain>
References: <20190725231931.24073-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190725231931.24073-1-mcroce@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,

On Fri, Jul 26, 2019 at 01:19:31AM +0200, Matteo Croce wrote:
> The MTU change code can call napi_disable() with the device already down,
> leading to a deadlock. Also, lot of code is duplicated unnecessarily.
> 
> Rework mvpp2_change_mtu() to avoid the deadlock and remove duplicated code.
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

As this is a fix sent to net, you could add a Fixes: tag.

Otherwise this looks good,
Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 41 ++++++-------------
>  1 file changed, 13 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 2f7286bd203b..60eb98f99571 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3612,6 +3612,7 @@ static int mvpp2_set_mac_address(struct net_device *dev, void *p)
>  static int mvpp2_change_mtu(struct net_device *dev, int mtu)
>  {
>  	struct mvpp2_port *port = netdev_priv(dev);
> +	bool running = netif_running(dev);
>  	int err;
>  
>  	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
> @@ -3620,40 +3621,24 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
>  		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
>  	}
>  
> -	if (!netif_running(dev)) {
> -		err = mvpp2_bm_update_mtu(dev, mtu);
> -		if (!err) {
> -			port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
> -			return 0;
> -		}
> -
> -		/* Reconfigure BM to the original MTU */
> -		err = mvpp2_bm_update_mtu(dev, dev->mtu);
> -		if (err)
> -			goto log_error;
> -	}
> -
> -	mvpp2_stop_dev(port);
> +	if (running)
> +		mvpp2_stop_dev(port);
>  
>  	err = mvpp2_bm_update_mtu(dev, mtu);
> -	if (!err) {
> +	if (err) {
> +		netdev_err(dev, "failed to change MTU\n");
> +		/* Reconfigure BM to the original MTU */
> +		mvpp2_bm_update_mtu(dev, dev->mtu);
> +	} else {
>  		port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
> -		goto out_start;
>  	}
>  
> -	/* Reconfigure BM to the original MTU */
> -	err = mvpp2_bm_update_mtu(dev, dev->mtu);
> -	if (err)
> -		goto log_error;
> -
> -out_start:
> -	mvpp2_start_dev(port);
> -	mvpp2_egress_enable(port);
> -	mvpp2_ingress_enable(port);
> +	if (running) {
> +		mvpp2_start_dev(port);
> +		mvpp2_egress_enable(port);
> +		mvpp2_ingress_enable(port);
> +	}
>  
> -	return 0;
> -log_error:
> -	netdev_err(dev, "failed to change MTU\n");
>  	return err;
>  }
>  
> -- 
> 2.21.0
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
