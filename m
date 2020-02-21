Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C741C168587
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgBURti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:49:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:56376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726955AbgBURti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 12:49:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 94187AC5C;
        Fri, 21 Feb 2020 17:49:35 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B3109E0099; Fri, 21 Feb 2020 18:49:34 +0100 (CET)
Date:   Fri, 21 Feb 2020 18:49:34 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com,
        davem@davemloft.net, willemdebruijn.kernel@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH, net-next, v5, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
Message-ID: <20200221174934.GC5607@unicorn.suse.cz>
References: <20200218175227.8511-1-cforno12@linux.vnet.ibm.com>
 <20200218175227.8511-2-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218175227.8511-2-cforno12@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:52:26AM -0600, Cris Forno wrote:
> Three virtual devices (ibmveth, virtio_net, and netvsc) all have
> similar code to get link settings and validate ethtool command. To
> eliminate duplication of code, it is factored out into core/ethtool.c.
> 
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
>  include/linux/ethtool.h |  8 ++++++++
>  net/ethtool/ioctl.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e43..fbc38f0 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -420,4 +420,12 @@ struct ethtool_rx_flow_rule *
>  ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input);
>  void ethtool_rx_flow_rule_destroy(struct ethtool_rx_flow_rule *rule);
>  
> +bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd);
> +int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
> +				       const struct ethtool_link_ksettings *cmd,
> +				       u32 *dev_speed, u8 *dev_duplex,
> +				       bool (*ethtool_virtdev_validate_cmd)
> +				       (const struct ethtool_link_ksettings *));

Using the same argument name as the default function used for it is
rather confusing.

Using a typedef for the type might make the declaration a bit easier to
read.

> +
> +
>  #endif /* _LINUX_ETHTOOL_H */
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index b987052..173e083 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -459,6 +459,25 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>  	return 0;
>  }
>  
> +/* Check if the user is trying to change anything besides speed/duplex */
> +bool ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> +{
> +	struct ethtool_link_settings base2 = {};
> +
> +	base2.speed = cmd->base.speed;
> +	base2.port = PORT_OTHER;
> +	base2.duplex = cmd->base.duplex;
> +	base2.cmd = cmd->base.cmd;
> +	base2.link_mode_masks_nwords = cmd->base.link_mode_masks_nwords;

These could go into the initialization but I guess it's a matter of
taste.

> +	return !memcmp(&base2, &cmd->base, sizeof(base2)) &&
> +		bitmap_empty(cmd->link_modes.supported,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +		bitmap_empty(cmd->link_modes.lp_advertising,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +EXPORT_SYMBOL(ethtool_virtdev_validate_cmd);
> +
>  /* convert a kernel internal ethtool_link_ksettings to
>   * ethtool_link_usettings in user space. return 0 on success, errno on
>   * error.
> @@ -581,6 +600,32 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
>  	return err;
>  }
>  
> +int ethtool_virtdev_set_link_ksettings(struct net_device *dev,
> +				       const struct ethtool_link_ksettings *cmd,
> +				       u32 *dev_speed, u8 *dev_duplex,
> +				       bool (*dev_virtdev_validate_cmd)
> +				       (const struct ethtool_link_ksettings *))

The argument is named different than in the declaration which is also
a bit confusing.

> +{
> +	bool (*validate)(const struct ethtool_link_ksettings *);
> +	u32 speed;
> +	u8 duplex;
> +
> +	validate = dev_virtdev_validate_cmd ? dev_virtdev_validate_cmd :
> +		ethtool_virtdev_validate_cmd;

This can be shortened to

	validate = dev_virtdev_validate_cmd ?: ethtool_virtdev_validate_cmd;

The only thing I really don't like is the confusing naming of handler
argument (different between declaration and definition and one of them
conflicting with function used as default for that argument). The rest
is just nitpicking.

Michal Kubecek

> +	speed = cmd->base.speed;
> +	duplex = cmd->base.duplex;
> +	/* don't allow custom speed and duplex */
> +	if (!ethtool_validate_speed(speed) ||
> +	    !ethtool_validate_duplex(duplex) ||
> +	    !(*validate)(cmd))
> +		return -EINVAL;
> +	*dev_speed = speed;
> +	*dev_duplex = duplex;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ethtool_virtdev_set_link_ksettings);
> +
>  /* Query device for its ethtool_cmd settings.
>   *
>   * Backward compatibility note: for compatibility with legacy ethtool, this is
> -- 
> 1.8.3.1
> 
