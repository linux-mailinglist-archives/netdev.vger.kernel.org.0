Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E603D1A77
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhGUWzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbhGUWzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:55:17 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8054FC061575;
        Wed, 21 Jul 2021 16:35:52 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id dj21so4566180edb.0;
        Wed, 21 Jul 2021 16:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uEqLdGKF6+rg1FAbUl0sbtAwny0zoTLNAfMvz3yVKUc=;
        b=IHRJNobmB50DI1h20Pr7f4uYikBnbtt4dMTHrvLlItiKSyBfPs1MawYLBdF6CGP7RM
         ex683UPnPIgomHpfLMJpvY5KGrTrqNSvXNlUWm8ktIxoH5Jt65uhiuDhHApFfyA0vGyf
         96IbZP2kXwnNns73bc0FMfyrur4k6tZML9tjHeEtU8WcGBt89PaSCoa9ls6RPxymHO3/
         azhEm+XTzmnTcMBlJehuAiKuEeNnzeXhu7NZ0uPvmMo4ExSSngKrXQdHVm+lbFHBqkgb
         cvpK3Ytv5LEhzH7yQZi2EcZ2JIYwm7wtV+PK/FQf8PXvFrO7E5CYy4SowQk5bntPS/yq
         MnFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uEqLdGKF6+rg1FAbUl0sbtAwny0zoTLNAfMvz3yVKUc=;
        b=fJ4tnmE3aRgnTeHt6yMaRfjaWVf+TyIRPKaA3wcsfd3jG177q7KW+88JK5XLCF7OuQ
         YYdrgUeLbjvMUa5Xi1SUAdIXcylC8BkHpUAw4/m6p8Tc0HIUnaJA9nBQusebalT9Suhk
         7Uz1vWxAS9G7EW9Bl+3ARN850PiWGqBNxpRKwrooo71q8Q5VZTwbEJ6EWTMau6yRc3DE
         gxECBTwfXsoIPUV0OzHSJZvrVYDXadjAmquOVQCK6J+XY5BQQg0qUtnDOteaoL0TElxJ
         25eAp1OJ0lO0HWtHBe1WQfrkAXBzz+GtUPaeETXUH9OjE/YKcrLubiQL2B2MsIXGWM8J
         jazg==
X-Gm-Message-State: AOAM531sPyNhcThoQwQDdh98UsgXvWyNAEHACty5E8ZhvC4gSiYQGi7m
        LXBfacUP2s+Prvj4snAOjIU=
X-Google-Smtp-Source: ABdhPJzUiY8X3xBvpDKKpn7221qkP6gD+e4ElJEdL60keo8TvM/fgy9c/3pQFiH17fa+CZO8hHxKNw==
X-Received: by 2002:a05:6402:1546:: with SMTP id p6mr44885499edx.206.1626910551162;
        Wed, 21 Jul 2021 16:35:51 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id j1sm11479752edl.80.2021.07.21.16.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 16:35:50 -0700 (PDT)
Date:   Thu, 22 Jul 2021 02:35:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: ensure linearized SKBs in case of tail
 taggers
Message-ID: <20210721233549.mhqlrt3l2bbyaawr@skbuf>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
 <20210721215642.19866-2-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210721215642.19866-2-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 11:56:41PM +0200, Lino Sanfilippo wrote:
> The function skb_put() that is used by tail taggers to make room for the
> DSA tag must only be called for linearized SKBS. However in case that the
> slave device inherited features like NETIF_F_HW_SG or NETIF_F_FRAGLIST the
> SKB passed to the slaves transmit function may not be linearized.
> Avoid those SKBs by clearing the NETIF_F_HW_SG and NETIF_F_FRAGLIST flags
> for tail taggers.
> Furthermore since the tagging protocol can be changed at runtime move the
> code for setting up the slaves features into dsa_slave_setup_tagger().
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  net/dsa/slave.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 22ce11cd770e..ae2a648ed9be 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1808,6 +1808,7 @@ void dsa_slave_setup_tagger(struct net_device *slave)
>  	struct dsa_slave_priv *p = netdev_priv(slave);
>  	const struct dsa_port *cpu_dp = dp->cpu_dp;
>  	struct net_device *master = cpu_dp->master;
> +	const struct dsa_switch *ds = dp->ds;
>  
>  	slave->needed_headroom = cpu_dp->tag_ops->needed_headroom;
>  	slave->needed_tailroom = cpu_dp->tag_ops->needed_tailroom;
> @@ -1819,6 +1820,14 @@ void dsa_slave_setup_tagger(struct net_device *slave)
>  	slave->needed_tailroom += master->needed_tailroom;
>  
>  	p->xmit = cpu_dp->tag_ops->xmit;
> +
> +	slave->features = master->vlan_features | NETIF_F_HW_TC;
> +	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
> +		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> +	slave->hw_features |= NETIF_F_HW_TC;
> +	slave->features |= NETIF_F_LLTX;
> +	if (slave->needed_tailroom)
> +		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
>  }
>  
>  static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
> @@ -1881,11 +1890,6 @@ int dsa_slave_create(struct dsa_port *port)
>  	if (slave_dev == NULL)
>  		return -ENOMEM;
>  
> -	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
> -	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
> -		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> -	slave_dev->hw_features |= NETIF_F_HW_TC;
> -	slave_dev->features |= NETIF_F_LLTX;
>  	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
>  	if (!is_zero_ether_addr(port->mac))
>  		ether_addr_copy(slave_dev->dev_addr, port->mac);
> -- 
> 2.32.0
> 

I would have probably changed the code in dsa_slave_create just like
this:

-	slave->features = master->vlan_features | NETIF_F_HW_TC;
+	slave->features = NETIF_F_HW_TC;
...
-	slave_dev->vlan_features = master->vlan_features;

and in dsa_slave_setup_tagger:

+	vlan_features = master->vlan_features;
+	slave->features &= ~vlan_features;
+	if (slave->needed_tailroom)
+		vlan_features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+	slave->features |= vlan_features;
+	slave->vlan_features = vlan_features;

no need to move around NETIF_F_HW_TC and NETIF_F_LLTX. Makes sense?

And I would probably add:

Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")
