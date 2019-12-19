Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CB11270CB
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLSWgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:36:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:52012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfLSWgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:36:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AA364AD45;
        Thu, 19 Dec 2019 22:36:03 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 20336E008B; Thu, 19 Dec 2019 23:36:03 +0100 (CET)
Date:   Thu, 19 Dec 2019 23:36:03 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 1/2] Three virtual devices (ibmveth,
 virtio_net, and netvsc) all have similar code to set/get link settings and
 validate ethtool command. To eliminate duplication of code, it is factored
 out into core/ethtool.c.
Message-ID: <20191219223603.GC21614@unicorn.suse.cz>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
 <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 01:40:56PM -0600, Cris Forno wrote:
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
>  include/linux/ethtool.h |  2 ++
>  net/core/ethtool.c      | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 95991e43..1b0417b 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -394,6 +394,8 @@ struct ethtool_ops {
>  					  struct ethtool_coalesce *);
>  	int	(*set_per_queue_coalesce)(struct net_device *, u32,
>  					  struct ethtool_coalesce *);
> +	bool    (*virtdev_validate_link_ksettings)(const struct
> +						   ethtool_link_ksettings *);
>  	int	(*get_link_ksettings)(struct net_device *,
>  				      struct ethtool_link_ksettings *);
>  	int	(*set_link_ksettings)(struct net_device *,
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index cd9bc67..4091a94 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c

You should probably rebase on top of current net-next; this file has
been moved to net/ethtool/ioctl.c recently.

> @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
>  	return 0;
>  }
>  
> +/* Check if the user is trying to change anything besides speed/duplex */
> +static bool
> +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> +{
> +	struct ethtool_link_ksettings diff1 = *cmd;
> +	struct ethtool_link_ksettings diff2 = {};
> +
> +	/* cmd is always set so we need to clear it, validate the port type
> +	 * and also without autonegotiation we can ignore advertising
> +	 */
> +	diff1.base.speed = 0;
> +	diff2.base.port = PORT_OTHER;
> +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> +	diff1.base.duplex = 0;
> +	diff1.base.cmd = 0;
> +	diff1.base.link_mode_masks_nwords = 0;
> +
> +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> +		bitmap_empty(diff1.link_modes.supported,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> +		bitmap_empty(diff1.link_modes.advertising,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&

Isn't this condition always true? You zeroed the advertising bitmap
above. Could you just omit this part and clearing of advertising above?

> +		bitmap_empty(diff1.link_modes.lp_advertising,
> +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}

Another idea: instead of zeroing parts of diff1, you could copy these
members from *cmd to diff2 and compare cmd->base with diff2.base. You
could then drop diff1. And you wouldn't even need whole struct
ethtool_link_ksettings for diff2 as you only compare embedded struct
ethtool_link_settings (and check two bitmaps in cmd->link_modes).

> +
>  /* convert a kernel internal ethtool_link_ksettings to
>   * ethtool_link_usettings in user space. return 0 on success, errno on
>   * error.
> @@ -660,6 +686,17 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
>  	return store_link_ksettings_for_user(useraddr, &link_ksettings);
>  }
>  
> +static int
> +ethtool_virtdev_get_link_ksettings(struct net_device *dev,
> +				   struct ethtool_link_ksettings *cmd,
> +				   u32 *speed, u8 *duplex)
> +{
> +	cmd->base.speed = *speed;
> +	cmd->base.duplex = *duplex;
> +	cmd->base.port = PORT_OTHER;
> +	return 0;
> +}

speed and duplex can be passed by value here; if you prefer pointers,
please make them const.

Michal Kubecek
