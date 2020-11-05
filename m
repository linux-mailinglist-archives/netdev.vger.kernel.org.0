Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7992A74DC
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 02:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730737AbgKEBVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 20:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbgKEBVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 20:21:46 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F344206CB;
        Thu,  5 Nov 2020 01:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604539305;
        bh=w9Hzj5WWD3RcjzHzTzDRPDTXsWtu/mrSVsjUOafAHiU=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=c0YLzsxFeGXcEzBlnp2wkmj5tMV1rRUDx5Vtjg9N02Jyx5DuYu++imU3ccvWjXAgB
         8a4pZzkFDZtDHl7h7N7LG5SL1yXK66LRNZc6WnuwmVzffyaPxLkKh4g014tkZtDykN
         OqcJNYembJ1uHxYCAA+DNhFKGG9cbXSj+knnMdrQ=
Message-ID: <fd2d2c3ec2fd7a34c9c74098d85da9f06f47821f.camel@kernel.org>
Subject: Re: [PATCH net-next 6/6] ionic: useful names for booleans
From:   Saeed Mahameed <saeed@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Date:   Wed, 04 Nov 2020 17:21:44 -0800
In-Reply-To: <20201104223354.63856-7-snelson@pensando.io>
References: <20201104223354.63856-1-snelson@pensando.io>
         <20201104223354.63856-7-snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 14:33 -0800, Shannon Nelson wrote:
> With a few more uses of true and false in function calls, we
> need to give them some useful names so we can tell from the
> calling point what we're doing.
> 

Aha! The root cause of the issue is passing booleans to functions in
first place, it is usually a bad idea that could lead to complication
and overloading the design for no reason, please see my suggestion in
the previous patch maybe you can apply the same approach on some of the
booleans below.


> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++-------
> -
>  drivers/net/ethernet/pensando/ionic/ionic_lif.h |  8 ++++++++
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index a58bb572b23b..a0d2989a0d8d 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -1074,22 +1074,22 @@ static int ionic_lif_addr(struct ionic_lif
> *lif, const u8 *addr, bool add,
>  
>  static int ionic_addr_add(struct net_device *netdev, const u8 *addr)
>  {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, true, true);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR,
> CAN_SLEEP);
>  }
>  
>  static int ionic_ndo_addr_add(struct net_device *netdev, const u8
> *addr)
>  {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, true, false);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, ADD_ADDR,
> CAN_NOT_SLEEP);
>  }
>  
>  static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
>  {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, false, true);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR,
> CAN_SLEEP);
>  }
>  
>  static int ionic_ndo_addr_del(struct net_device *netdev, const u8
> *addr)
>  {
> -	return ionic_lif_addr(netdev_priv(netdev), addr, false, false);
> +	return ionic_lif_addr(netdev_priv(netdev), addr, DEL_ADDR,
> CAN_NOT_SLEEP);
>  }
>  
>  static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int
> rx_mode)
> @@ -1214,7 +1214,7 @@ static void ionic_set_rx_mode(struct net_device
> *netdev, bool from_ndo)
>  
>  static void ionic_ndo_set_rx_mode(struct net_device *netdev)
>  {
> -	ionic_set_rx_mode(netdev, true);
> +	ionic_set_rx_mode(netdev, FROM_NDO);
>  }
>  
>  static __le64 ionic_netdev_features_to_nic(netdev_features_t
> features)
> @@ -1805,7 +1805,7 @@ static int ionic_txrx_init(struct ionic_lif
> *lif)
>  	if (lif->netdev->features & NETIF_F_RXHASH)
>  		ionic_lif_rss_init(lif);
>  
> -	ionic_set_rx_mode(lif->netdev, false);
> +	ionic_set_rx_mode(lif->netdev, NOT_FROM_NDO);
>  
>  	return 0;
>  
> @@ -2813,7 +2813,7 @@ static int ionic_station_set(struct ionic_lif
> *lif)
>  		 */
>  		if (!ether_addr_equal(ctx.comp.lif_getattr.mac,
>  				      netdev->dev_addr))
> -			ionic_lif_addr(lif, netdev->dev_addr, true,
> true);
> +			ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR,
> CAN_SLEEP);
>  	} else {
>  		/* Update the netdev mac with the device's mac */
>  		memcpy(addr.sa_data, ctx.comp.lif_getattr.mac, netdev-
> >addr_len);
> @@ -2830,7 +2830,7 @@ static int ionic_station_set(struct ionic_lif
> *lif)
>  
>  	netdev_dbg(lif->netdev, "adding station MAC addr %pM\n",
>  		   netdev->dev_addr);
> -	ionic_lif_addr(lif, netdev->dev_addr, true, true);
> +	ionic_lif_addr(lif, netdev->dev_addr, ADD_ADDR, CAN_SLEEP);
>  
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> index 0224dfd24b8a..493de679b498 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
> @@ -13,6 +13,14 @@
>  
>  #define IONIC_MAX_NUM_NAPI_CNTR		(NAPI_POLL_WEIGHT + 1)
>  #define IONIC_MAX_NUM_SG_CNTR		(IONIC_TX_MAX_SG_ELEMS
> + 1)
> +
> +#define ADD_ADDR	true
> +#define DEL_ADDR	false
> +#define CAN_SLEEP	true
> +#define CAN_NOT_SLEEP	false
> +#define FROM_NDO	true
> +#define NOT_FROM_NDO	false
> +
>  #define IONIC_RX_COPYBREAK_DEFAULT	256
>  #define IONIC_TX_BUDGET_DEFAULT		256
>  

