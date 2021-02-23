Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF073223B8
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBWBa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhBWBa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 20:30:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DFFF64E57;
        Tue, 23 Feb 2021 01:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614043816;
        bh=ncie3eGoP1Lo7pENaLRqCW2fkUMl2yR3qc5u8v9f/Cs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyaOfdQ9yb+Jt1rs6BqyaFO5YLrlUhDHHOh2P6qeIQvBeKoXJV6f/o5WInaM0gWds
         567BIW+sx8ibyf8SpHpSMFPxwhfG9tUAFIwAJC0omA/3h+qtASKo4guFtMrr5QOG2O
         wTqnSPJ5TiwOfiTRz2a9quZsIasxGTyXiNfjzMyTpeGemqWvZAH26YoHbgp7wnnG81
         FPqUI5oZUQKmcRF/2NqkbGNjb1WybkM8DtHTk7d6fReE0HIiGIpHULqejofiDpqn6f
         BJU1QTcKUCM5RKK5csIN8uc0xTYwrYy6zeS+lgNRFioqoePS5mLm143FDaZ/2FRMUs
         WyDxYAHySz5YA==
Date:   Mon, 22 Feb 2021 17:30:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: introduce CAN specific pointer in the
 struct net_device
Message-ID: <20210222173012.39e82e8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222150251.12911-1-o.rempel@pengutronix.de>
References: <20210222150251.12911-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 16:02:51 +0100 Oleksij Rempel wrote:
> Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
> ml_priv") the CAN framework uses per device specific data in the AF_CAN
> protocol. For this purpose the struct net_device->ml_priv is used. Later
> the ml_priv usage in CAN was extended for other users, one of them being
> CAN_J1939.
> 
> Later in the kernel ml_priv was converted to an union, used by other
> drivers. E.g. the tun driver started storing it's stats pointer.
> 
> Since tun devices can claim to be a CAN device, CAN specific protocols
> will wrongly interpret this pointer, which will cause system crashes.
> Mostly this issue is visible in the CAN_J1939 stack.
> 
> To fix this issue, we request a dedicated CAN pointer within the
> net_device struct.
> 
> Reported-by: syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com
> Fixes: 20dd3850bcf8 ("can: Speed up CAN frame receiption by using ml_priv")
> Fixes: ffd956eef69b ("can: introduce CAN midlayer private and allocate it automatically")
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Fixes: 497a5757ce4e ("tun: switch to net core provided statistics counters")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index ddf4cfc12615..6e25c6f0f190 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1584,6 +1584,16 @@ enum netdev_priv_flags {
>  #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
>  #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
>  
> +/**
> + * enum netdev_ml_priv_type - &struct net_device ml_priv_type
> + *
> + * This enum specifies the type of the struct net_device::ml_priv pointer.
> + */

kdoc (scripts/kernel-doc -none include/linux/netdevice.h) is not happy
about the fact enum values are not defined. Perhaps they will be
sufficiently self-explanatory to not bother documenting?

Maybe just:

/* Specifies the type of the struct net_device::ml_priv pointer */

?

> +enum netdev_ml_priv_type {
> +	ML_PRIV_NONE,
> +	ML_PRIV_CAN,
> +};
> +
>  /**
>   *	struct net_device - The DEVICE structure.
>   *
> @@ -1779,6 +1789,7 @@ enum netdev_priv_flags {
>   * 	@nd_net:		Network namespace this network device is inside
>   *
>   * 	@ml_priv:	Mid-layer private
> +	@ml_priv_type:  Mid-layer private type

missing '*' at the start of the line

>   * 	@lstats:	Loopback statistics
>   * 	@tstats:	Tunnel statistics
>   * 	@dstats:	Dummy statistics
> @@ -2094,8 +2105,10 @@ struct net_device {
>  	possible_net_t			nd_net;
>  
>  	/* mid-layer private */
> +	void				*ml_priv;
> +	enum netdev_ml_priv_type	ml_priv_type;
> +
>  	union {
> -		void					*ml_priv;
>  		struct pcpu_lstats __percpu		*lstats;
>  		struct pcpu_sw_netstats __percpu	*tstats;
>  		struct pcpu_dstats __percpu		*dstats;
> @@ -2286,6 +2299,29 @@ static inline void netdev_reset_rx_headroom(struct net_device *dev)
>  	netdev_set_rx_headroom(dev, -1);
>  }
>  
> +static inline void *netdev_get_ml_priv(struct net_device *dev,
> +				       enum netdev_ml_priv_type type)
> +{
> +	if (dev->ml_priv_type != type)
> +		return NULL;
> +
> +	return dev->ml_priv;
> +}
> +
> +static inline void netdev_set_ml_priv(struct net_device *dev,
> +				      void *ml_priv,
> +				      enum netdev_ml_priv_type type)
> +{
> +	WARN_ONCE(dev->ml_priv_type && dev->ml_priv_type != type,
> +		  "Overwriting already set ml_priv_type (%u) with different ml_priv_type (%u)!\n",
> +		  dev->ml_priv_type, type);
> +	WARN_ONCE(!dev->ml_priv_type && dev->ml_priv,
> +		  "Overwriting already set ml_priv and ml_priv_type is ML_PRIV_NONE!\n");

nit: do we need the _ONCE() this helper should be used on control path
     and relatively rarely, no?

> +	dev->ml_priv = ml_priv;
> +	dev->ml_priv_type = type;
> +}
> +
>  /*
>   * Net namespace inlines
>   */

> @@ -454,6 +455,7 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
>  		j1939_local_ecu_put(priv, jsk->addr.src_name, jsk->addr.sa);
>  	} else {
>  		struct net_device *ndev;
> +		struct can_ml_priv *can_ml;

nit: rev xmas tree

>  
>  		ndev = dev_get_by_index(net, addr->can_ifindex);
>  		if (!ndev) {
