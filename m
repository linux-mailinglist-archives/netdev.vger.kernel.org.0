Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30ED32FFB5E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 04:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbhAVDpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 22:45:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbhAVDpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 22:45:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12DEF2076B;
        Fri, 22 Jan 2021 03:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611287092;
        bh=VE02TSiSBh/929RKNo5Sc/tlNod1rZxJ0rdosfYygP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OAHCPbptVi2Dck7VuNV6PGcWfGvDP6fG7VfSbuIEFUaG91CmzCQ7JXqth+GizpUcs
         o8NaKKZp42lqCxm0G8aS8Geait3jTaVGhPjmnojnE1Fa+OP7La+3l14JdsozRLwdtP
         zUbum64QY3kkAmsfRZNgEBsC9T0tGTN2GQzN8sxGjkQeLOZpsAWuIGc3GLU/o05MRD
         LED1CM42zMvtmguMb+7amKwNVcXd/UnY4uiS2301tIU51wPdDGdLQkvlCMkaej8dgA
         Lyb+Vti3WOAMB8miJR6tlydcmy7A0IPLRYB+/VD2pbLXmZU1kixdyUmIrMtOFVA6B1
         PJR50rDZm4y6w==
Date:   Thu, 21 Jan 2021 19:44:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 1/7] ethtool: Extend link modes settings
 uAPI with lanes
Message-ID: <20210121194451.3fe8c8bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120093713.4000363-2-danieller@nvidia.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
        <20210120093713.4000363-2-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 11:37:07 +0200 Danielle Ratson wrote:
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

> Signed-off-by: Danielle Ratson <danieller@nvidia.com>

> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index cde753bb2093..80edae2c24f7 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1738,6 +1738,8 @@ static inline int ethtool_validate_speed(__u32 speed)
>  	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
>  }
>  
> +#define ETHTOOL_LANES_UNKNOWN		0

I already complained about these unnecessary uAPI constants, did you
reply to that and I missed it?

Don't report the nlattr if it's unknown, we have netlink now, those
constants are from times when we returned structures and all fields 
had to have a value.

>  /* Duplex, half or full. */
>  #define DUPLEX_HALF		0x00
>  #define DUPLEX_FULL		0x01
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index e2bf36e6964b..a286635ac9b8 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -227,6 +227,7 @@ enum {
>  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
> +	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKMODES_CNT,
> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index c5bcb9abc8b9..fb7d73250864 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -152,12 +152,14 @@ const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
>  
>  struct link_mode_info {
>  	int				speed;
> +	u32				lanes;

This is not uapi, we can make it u8 now, save a few (hundred?) bytes 
of memory and bump it to u16 later.

>  	u8				duplex;
>  };

> @@ -353,10 +358,39 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  
>  	*mod = false;
>  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
> +	req_lanes = tb[ETHTOOL_A_LINKMODES_LANES];
>  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
>  
>  	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
>  			mod);
> +
> +	if (req_lanes) {
> +		u32 lanes_cfg = nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);

req_lanes == tb[ETHTOOL_A_LINKMODES_LANES], right?

Please use req_lanes variable where possible.

> +
> +		if (!is_power_of_2(lanes_cfg)) {
> +			NL_SET_ERR_MSG_ATTR(info->extack,
> +					    tb[ETHTOOL_A_LINKMODES_LANES],
> +					    "lanes value is invalid");
> +			return -EINVAL;
> +		}
> +
> +		/* If autoneg is off and lanes parameter is not supported by the
> +		 * driver, return an error.
> +		 */
> +		if (!lsettings->autoneg &&
> +		    !dev->ethtool_ops->cap_link_lanes_supported) {
> +			NL_SET_ERR_MSG_ATTR(info->extack,
> +					    tb[ETHTOOL_A_LINKMODES_LANES],
> +					    "lanes configuration not supported by device");
> +			return -EOPNOTSUPP;
> +		}

This validation does not depend on the current settings at all, it's
just input validation, it can be done before rtnl_lock is taken (in a
new function).

You can move ethnl_validate_master_slave_cfg() to that function as well
(as a cleanup before this patch).

> +	} else if (!lsettings->autoneg) {
> +		/* If autoneg is off and lanes parameter is not passed from user,
> +		 * set the lanes parameter to UNKNOWN.
> +		 */
> +		ksettings->lanes = ETHTOOL_LANES_UNKNOWN;
> +	}
> +
>  	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
>  				  __ETHTOOL_LINK_MODE_MASK_NBITS,
>  				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,
