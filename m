Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16372EEA77
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbhAHAfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:35:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAHAfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:35:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DA22368A;
        Fri,  8 Jan 2021 00:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610066106;
        bh=quIQ8VM4oqEzWHeZEigAF+sHf2B/8IwMhYfzJ9gySjw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YPrCyp1hKdv4iBu6ugZwX9LapoRS9jSa6u7W2IVc2zLJMBMUxNVgQMagMXtK33ZDI
         JnssIpibtw7Ba75vf23yta0pfbaC7etycJg1G5ArIDJ7yozo7/u1hHUh9OKK/opure
         wF6z9iNrnujqm15hCaq469GT7bLoe1PZ4nRkd8rq48rxQ0B1swXnJ+o+f4Zf5TKoq3
         kvWww2DgPc0CExv9RjRYRaYw7bf68FrntaollcNe1xqNwN+XIBm0abimyReoCAr6ex
         MrIWmJuz7fr//MXXsyPuTuE+prJB8w/l7PeX4rC/U2mXeoQa7K8Q5tZS+TTWWqAJt9
         i5yjYqIH3DxKw==
Date:   Thu, 7 Jan 2021 16:35:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next repost v2 1/7] ethtool: Extend link modes
 settings uAPI with lanes
Message-ID: <20210107163504.55018c73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106130622.2110387-2-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-2-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 15:06:16 +0200 Danielle Ratson wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> Currently, when auto negotiation is on, the user can advertise all the
> linkmodes which correspond to a specific speed, but does not have a
> similar selector for the number of lanes. This is significant when a
> specific speed can be achieved using different number of lanes.  For
> example, 2x50 or 4x25.
> 
> Add 'ETHTOOL_A_LINKMODES_LANES' attribute and expand 'struct
> ethtool_link_settings' with lanes field in order to implement a new
> lanes-selector that will enable the user to advertise a specific number
> of lanes as well.
> 
> When auto negotiation is off, lanes parameter can be forced only if the
> driver supports it. Add a capability bit in 'struct ethtool_ops' that
> allows ethtool know if the driver can handle the lanes parameter when
> auto negotiation is off, so if it does not, an error message will be
> returned when trying to set lanes.

> @@ -420,6 +423,7 @@ struct ethtool_pause_stats {
>   * of the generic netdev features interface.
>   */
>  struct ethtool_ops {
> +	u32     capabilities;

An appropriately named bitfield seems better. Alternatively maybe let
the driver specify which lane counts it can accept?

And please remember to add the kdoc.

>  	u32	supported_coalesce_params;
>  	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
>  	int	(*get_regs_len)(struct net_device *);

> @@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
>  	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
>  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },

Please set the min and max for the policy, so userspace can at least
see that part.

> +static bool ethnl_validate_lanes_cfg(u32 cfg)
> +{
> +	switch (cfg) {
> +	case 1:
> +	case 2:
> +	case 4:
> +	case 8:
> +		return true;

And with the policy checking min and max this can be turned into
a simple is_power_of_2() call.

> +	}
> +
> +	return false;
> +}
