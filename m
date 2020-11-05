Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491622A74D8
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgKEBSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:18:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgKEBSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:18:32 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A76204EC;
        Thu,  5 Nov 2020 01:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604539111;
        bh=3mnr5IbBhdw3e+Y+o75X+GuICmemGkvaUdlU80jSZQA=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=kB42mHTnPk70jyIEdwwIxgHXgo9y68jS6v3IK0pV8wEF6YkCovuqB6r64WQEjAvEt
         P6igoPWYzvMUgVwK19Pd6y1dmhiFrQ+Pw3jfy9HU98oSLUBcPpnisbu8bmnkt3L8Mo
         k1Nqo0+gvbTpBKGon44xZE1rBobD3jE8PGZN+z/Q=
Message-ID: <def8bcc5da4c10e021aff6a756ddcbf4487057f6.camel@kernel.org>
Subject: Re: [PATCH net-next 5/6] ionic: use mc sync for multicast filters
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Wed, 04 Nov 2020 17:18:30 -0800
In-Reply-To: <20201104223354.63856-6-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
         <20201104223354.63856-6-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
> We should be using the multicast sync routines for the
> multicast filters.
> 
> Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 28044240caf2..a58bb572b23b 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1158,6 +1158,14 @@ static void ionic_dev_uc_sync(struct
> net_device *netdev, bool from_ndo)
>  
>  }
>  
> +static void ionic_dev_mc_sync(struct net_device *netdev, bool
> from_ndo)
> +{
> +	if (from_ndo)
> +		__dev_mc_sync(netdev, ionic_ndo_addr_add,
> ionic_ndo_addr_del);
> +	else
> +		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
> +}
> +

I don't see any point of this function since it is used in one place.
just unfold it in the caller and you will endup with less code.

also keep in mind passing boolean to functions is usually a bad idea, 
and only complicates things, keep things simple and explicit, let the
caller do what is necessary to be done, so if you must do this if
condition, do it at the caller level.

and for a future patch i strongly recommend to remove this from_ndo
flag, it is really straight forward to do for this function
1) you can just pass _addr_add/del function pointers directly
to ionic_set_rx_mode
2) remove _ionic_lif_rx_mode from ionic_set_rx_mode and unfold it in
the caller since the function is basically one giant if condition which
is called only from two places.

>  static void ionic_set_rx_mode(struct net_device *netdev, bool
> from_ndo)
>  {
>  	struct ionic_lif *lif = netdev_priv(netdev);
> @@ -1189,7 +1197,7 @@ static void ionic_set_rx_mode(struct net_device
> *netdev, bool from_ndo)
>  	}
>  
>  	/* same for multicast */
> -	ionic_dev_uc_sync(netdev, from_ndo);
> +	ionic_dev_mc_sync(netdev, from_ndo);
>  	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
>  	if (netdev_mc_count(netdev) > nfilters) {
>  		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;

