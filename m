Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA612EEA7E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729554AbhAHAnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAHAnW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 19:43:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C977E23447;
        Fri,  8 Jan 2021 00:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610066562;
        bh=zFjV8Qe+cCvRBaYc0sIbBRC/hYhhtKQXcu0a4xr8txI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kMEGf+9NL8V2le6o+bRyiIj3Sx4Qf8cwqHEwy+7Z9Pqh9uBNRl2upNj+XfzE4LxnS
         5uso/9qsuKp7hOdHlPNSQglXbbRv2mgH5N45jHg37NG6VpQYdtzwEbi/IYB+hpV/Dk
         SEEElBxaFRr0wnE90QFyPuakiZ+HMOShar5wjrihupdKh4mkSRY1D2PViA0IU8uTOJ
         OjBbGPp4dceR3mk1dDcInWtpnhHcmj/Y7Ayk9n7zuyurruR8dOzj25pH6cnEEzI2Ek
         6jxzZUQylVRzBNSee1W8JeUnU/C+CVumhSrxWbGi5yZCoV+5QA8kH58u+pmlXFv981
         c1rJppV1KXBSg==
Date:   Thu, 7 Jan 2021 16:42:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net-next repost v2 2/7] ethtool: Get link mode in use
 instead of speed and duplex parameters
Message-ID: <20210107164240.17fcda6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106130622.2110387-3-danieller@mellanox.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-3-danieller@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 15:06:17 +0200 Danielle Ratson wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> Currently, when user space queries the link's parameters, as speed and
> duplex, each parameter is passed from the driver to ethtool.
> 
> Instead, get the link mode bit in use, and derive each of the parameters
> from it in ethtool.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> ---
>  Documentation/networking/ethtool-netlink.rst |   1 +
>  include/linux/ethtool.h                      |   1 +
>  include/uapi/linux/ethtool.h                 |   2 +
>  net/ethtool/linkmodes.c                      | 252 ++++++++++---------
>  4 files changed, 137 insertions(+), 119 deletions(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 05073482db05..c21e71e0c0e8 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -406,6 +406,7 @@ Kernel response contents:
>    ``ETHTOOL_A_LINKMODES_PEER``                bitset  partner link modes
>    ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
>    ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
> +  ``ETHTOOL_A_LINKMODES_LINK_MODE``           u8      link mode

Are there other places in the uapi we already limit ourselves to 
u8 / max 255? Otherwise u32 is better, the nlattr will be padded,
anyway.

>    ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
>    ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
>    ==========================================  ======  ==========================
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index afae2beacbc3..668a7737a483 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -129,6 +129,7 @@ struct ethtool_link_ksettings {
>  		__ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
>  	} link_modes;
>  	u32	lanes;
> +	enum ethtool_link_mode_bit_indices link_mode;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 80edae2c24f7..f61f726d1567 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1733,6 +1733,8 @@ enum ethtool_link_mode_bit_indices {
>  
>  #define SPEED_UNKNOWN		-1
>  
> +#define LINK_MODE_UNKNOWN	-1

Why do we need this? Link mode is output only, so just don't report 
the nlattr when it's unknown.

>  static inline int ethtool_validate_speed(__u32 speed)
>  {
>  	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;


> @@ -29,7 +150,9 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
>  {
>  	struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
>  	struct net_device *dev = reply_base->dev;
> +	const struct link_mode_info *link_info;
>  	int ret;
> +	unsigned int i;

rev xmas tree

>  	data->lsettings = &data->ksettings.base;
>  
> @@ -43,6 +166,16 @@ static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
>  		goto out;
>  	}
>  
> +	if (data->ksettings.link_mode) {
> +		for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; i++) {
> +			if (data->ksettings.link_mode == i) {

I stared at this for a minute, the loop is entirely pointless, right?

> +				link_info = &link_mode_params[i];
> +				data->lsettings->speed = link_info->speed;
> +				data->lsettings->duplex = link_info->duplex;
> +			}
> +		}
> +	}
> +
>  	data->peer_empty =
>  		bitmap_empty(data->ksettings.link_modes.lp_advertising,
>  			     __ETHTOOL_LINK_MODE_MASK_NBITS);
