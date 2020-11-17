Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5842B55D7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbgKQArR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731037AbgKQArR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:47:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CCEA24671;
        Tue, 17 Nov 2020 00:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605574036;
        bh=rPWJfCqsuVnjxAmYVb4r3dL+PxTHHrZEcJIk+3OQ4d8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sxRNLCm0zw4h2DiKuLqETLg0JGIBnOyShrR09xFB/+LH37VbDp8QD1096ekPtIkqG
         W6TBWplp0PLJVlMPqtF+EWqaEK6LTbM8cPjUZ/t/pDMm6FYbpGmGvKiTDtjyJzAi5O
         FuT75b+EyBskuZ3gNVWN9j17fDIa7jY/SbpbSxhY=
Date:   Mon, 16 Nov 2020 16:47:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v3 2/4] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201116164715.163197b7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113231655.139948-2-acardace@redhat.com>
References: <20201113231655.139948-1-acardace@redhat.com>
        <20201113231655.139948-2-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 00:16:53 +0100 Antonio Cardace wrote:
> diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
> index f1884d90a876..169154dba0cc 100644
> --- a/drivers/net/netdevsim/ethtool.c
> +++ b/drivers/net/netdevsim/ethtool.c
> @@ -13,9 +13,9 @@ nsim_get_pause_stats(struct net_device *dev,
>  {
>  	struct netdevsim *ns = netdev_priv(dev);
>  
> -	if (ns->ethtool.report_stats_rx)
> +	if (ns->ethtool.pauseparam.report_stats_rx)
>  		pause_stats->rx_pause_frames = 1;
> -	if (ns->ethtool.report_stats_tx)
> +	if (ns->ethtool.pauseparam.report_stats_tx)
>  		pause_stats->tx_pause_frames = 2;
>  }
>  
> @@ -25,8 +25,8 @@ nsim_get_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
>  	struct netdevsim *ns = netdev_priv(dev);
>  
>  	pause->autoneg = 0; /* We don't support ksettings, so can't pretend */
> -	pause->rx_pause = ns->ethtool.rx;
> -	pause->tx_pause = ns->ethtool.tx;
> +	pause->rx_pause = ns->ethtool.pauseparam.rx;
> +	pause->tx_pause = ns->ethtool.pauseparam.tx;
>  }
>  
>  static int
> @@ -37,28 +37,88 @@ nsim_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam *pause)
>  	if (pause->autoneg)
>  		return -EINVAL;
>  
> -	ns->ethtool.rx = pause->rx_pause;
> -	ns->ethtool.tx = pause->tx_pause;
> +	ns->ethtool.pauseparam.rx = pause->rx_pause;
> +	ns->ethtool.pauseparam.tx = pause->tx_pause;
> +	return 0;
> +}

Please separate the refactoring / moving pauseparam into another struct 
out to its own patch. This makes review easier.

> +static int nsim_get_coalesce(struct net_device *dev,
> +			     struct ethtool_coalesce *coal)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(coal, &ns->ethtool.coalesce, sizeof(ns->ethtool.coalesce));
> +	return 0;
> +}
> +
> +static int nsim_set_coalesce(struct net_device *dev,
> +			     struct ethtool_coalesce *coal)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(&ns->ethtool.coalesce, coal, sizeof(ns->ethtool.coalesce));
> +	return 0;
> +}
> +
> +static void nsim_get_ringparam(struct net_device *dev,
> +			       struct ethtool_ringparam *ring)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(ring, &ns->ethtool.ring, sizeof(ns->ethtool.ring));
> +}
> +
> +static int nsim_set_ringparam(struct net_device *dev,
> +			      struct ethtool_ringparam *ring)
> +{
> +	struct netdevsim *ns = netdev_priv(dev);
> +
> +	memcpy(&ns->ethtool.ring, ring, sizeof(ns->ethtool.ring));
>  	return 0;
>  }
>  
>  static const struct ethtool_ops nsim_ethtool_ops = {
> -	.get_pause_stats	= nsim_get_pause_stats,
> -	.get_pauseparam		= nsim_get_pauseparam,
> -	.set_pauseparam		= nsim_set_pauseparam,
> +	.get_pause_stats	        = nsim_get_pause_stats,
> +	.get_pauseparam		        = nsim_get_pauseparam,
> +	.set_pauseparam		        = nsim_set_pauseparam,
> +	.supported_coalesce_params	= ETHTOOL_COALESCE_ALL_PARAMS,

Please make this member first. I think that's what all drivers do.

> +	.set_coalesce			= nsim_set_coalesce,
> +	.get_coalesce			= nsim_get_coalesce,
> +	.get_ringparam			= nsim_get_ringparam,
> +	.set_ringparam			= nsim_set_ringparam,
>  };
