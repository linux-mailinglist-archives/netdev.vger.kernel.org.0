Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE0A168634
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgBUSQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:16:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:37660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgBUSQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 13:16:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1BB4EAC50;
        Fri, 21 Feb 2020 18:16:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7F839E0099; Fri, 21 Feb 2020 19:16:22 +0100 (CET)
Date:   Fri, 21 Feb 2020 19:16:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH, net-next, v5, 2/2] net/ethtool: Introduce link_ksettings
 API for virtual network devices
Message-ID: <20200221181622.GD5607@unicorn.suse.cz>
References: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
 <20200218175227.8511-3-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218175227.8511-3-cforno12@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:52:27AM -0600, Cris Forno wrote:
> With get/set link settings functions in core/ethtool.c, ibmveth,
> netvsc, and virtio now use the core's helper function.
> 
> Funtionality changes that pertain to ibmveth driver include:
> 
>   1. Changed the initial hardcoded link speed to 1GB.
> 
>   2. Added support for allowing a user to change the reported link
>   speed via ethtool.
> 
> Changes to the netvsc driver include:
> 
>   1. When netvsc_get_link_ksettings is called, it will defer to the VF
>   device if it exists to pull accelerated networking values, otherwise
>   pull default or user-defined values.
> 
>   2. Similarly, if netvsc_set_link_ksettings called and a VF device
>   exists, the real values of speed and duplex are changed.
> 
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
[...]
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 65e12cb..f733ec5 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
[...]
> @@ -1187,18 +1193,19 @@ static int netvsc_set_link_ksettings(struct net_device *dev,
>  				     const struct ethtool_link_ksettings *cmd)
>  {
>  	struct net_device_context *ndc = netdev_priv(dev);
> -	u32 speed;
> +	struct net_device *vf_netdev = rtnl_dereference(ndc->vf_netdev);
>  
> -	speed = cmd->base.speed;
> -	if (!ethtool_validate_speed(speed) ||
> -	    !ethtool_validate_duplex(cmd->base.duplex) ||
> -	    !netvsc_validate_ethtool_ss_cmd(cmd))
> -		return -EINVAL;
> +	if (vf_netdev) {
> +		if (!vf_netdev->ethtool_ops->set_link_ksettings)
> +			return -EOPNOTSUPP;
>  
> -	ndc->speed = speed;
> -	ndc->duplex = cmd->base.duplex;
> +		return vf_netdev->ethtool_ops->set_link_ksettings(vf_netdev,
> +								  cmd);
> +	}
>  
> -	return 0;
> +	return ethtool_virtdev_set_link_ksettings(dev, cmd,
> +						  &ndc->speed, &ndc->duplex,
> +						  &netvsc_validate_ethtool_ss_cmd);
>  }

I may be missing something obvious but I cannot see how does
netvsc_validate_ethtool_ss_cmd() differ from ethtool_virtdev_validate_cmd().
If it does, it would be probably worth a comment at the function.

Michal Kubecek
