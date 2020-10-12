Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C3628BE99
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390747AbgJLREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:04:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:59758 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390355AbgJLREC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 13:04:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 42FF6ABAD;
        Mon, 12 Oct 2020 17:04:00 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A9E58603A2; Mon, 12 Oct 2020 19:03:59 +0200 (CEST)
Date:   Mon, 12 Oct 2020 19:03:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, danieller@nvidia.com, andrew@lunn.ch,
        f.fainelli@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201012170359.tmh5hgvgjuuigaio@lion.mk-sys.cz>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010154119.3537085-2-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 06:41:14PM +0300, Ido Schimmel wrote:
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
> 
> Example:
> 
> $ ethtool -s swp1 lanes 4
> $ ethtool swp1
>   Settings for swp1:
> 	Supported ports: [ FIBRE ]
>         Supported link modes:   1000baseKX/Full
>                                 10000baseKR/Full
>                                 40000baseCR4/Full
> 				40000baseSR4/Full
> 				40000baseLR4/Full
>                                 25000baseCR/Full
>                                 25000baseSR/Full
> 				50000baseCR2/Full
>                                 100000baseSR4/Full
> 				100000baseCR4/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  40000baseCR4/Full
> 				40000baseSR4/Full
> 				40000baseLR4/Full
>                                 100000baseSR4/Full
> 				100000baseCR4/Full
>         Advertised pause frame use: No
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Speed: Unknown!
>         Duplex: Unknown! (255)
>         Auto-negotiation: on
>         Port: Direct Attach Copper
>         PHYAD: 0
>         Transceiver: internal
>         Link detected: no
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
[...]
>  static const struct link_mode_info link_mode_params[] = {
> -	__DEFINE_LINK_MODE_PARAMS(10, T, Half),
> -	__DEFINE_LINK_MODE_PARAMS(10, T, Full),
> -	__DEFINE_LINK_MODE_PARAMS(100, T, Half),
> -	__DEFINE_LINK_MODE_PARAMS(100, T, Full),
> -	__DEFINE_LINK_MODE_PARAMS(1000, T, Half),
> -	__DEFINE_LINK_MODE_PARAMS(1000, T, Full),
> +	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Half),
> +	__DEFINE_LINK_MODE_PARAMS(10, T, 1, Full),
> +	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Half),
> +	__DEFINE_LINK_MODE_PARAMS(100, T, 1, Full),
> +	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Half),
> +	__DEFINE_LINK_MODE_PARAMS(1000, T, 1, Full),

Technically, 4 may be more appropriate for 1000base-T, 2500base-T,
5000base-T and 10000base-T but it's probably just a formality. While
there is 1000base-T1, I'm not sure if we can expect a device which would
support e.g. both 1000base-T and 1000base-T1 (or some other colliding
combination of modes).

Michal
