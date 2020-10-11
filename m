Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1CC28AAF5
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbgJKWiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387717AbgJKWiC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 18:38:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4242074A;
        Sun, 11 Oct 2020 22:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602455881;
        bh=quv0zD5Nab+EI6T5ftDZTMifD2p8XdCvaHU2lb8siN0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pIYDtv79fA/m4WuwD2VAx1Y2Td1NHI16Vk9CI8TyFR9Modmcro28CwiNj/d1fP3nb
         lUdcaxopVfZ7TbjUXuLLoGgCR+c/qFxDA71epeETkpokdf9We2fSVWiz9aXG4+cLkb
         90L3vv89dfa3FJ7ImoUnpQqOo3bnNnSuG91TsIGg=
Date:   Sun, 11 Oct 2020 15:37:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com,
        danieller@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>, johannes@sipsolutions.net
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010154119.3537085-2-idosch@idosch.org>
References: <20201010154119.3537085-1-idosch@idosch.org>
        <20201010154119.3537085-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 18:41:14 +0300 Ido Schimmel wrote:
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

What's the use for this in practical terms? Isn't the lane count
basically implied by the module that gets plugged in?

> +/* Lanes, 1, 2, 4 or 8. */
> +#define ETHTOOL_LANES_1			1
> +#define ETHTOOL_LANES_2			2
> +#define ETHTOOL_LANES_4			4
> +#define ETHTOOL_LANES_8			8

Not an extremely useful set of defines, not sure Michal would agree.

> +#define ETHTOOL_LANES_UNKNOWN		0

>  struct link_mode_info {
>  	int				speed;
> +	int				lanes;

why signed?

>  	u8				duplex;
>  };

> @@ -274,16 +277,17 @@ const struct nla_policy ethnl_linkmodes_set_policy[] = {
>  	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_U8 },
>  	[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG]	= { .type = NLA_U8 },
> +	[ETHTOOL_A_LINKMODES_LANES]		= { .type = NLA_U32 },

NLA_POLICY_VALIDATE_FN(), not sure why the types for this
validation_type are limited.. Johannes, just an abundance of caution?

> +	} else if (!lsettings->autoneg) {
> +		/* If autoneg is off and lanes parameter is not passed from user,
> +		 * set the lanes parameter to UNKNOWN.
> +		 */
> +		ksettings->lanes = ETHTOOL_LANES_UNKNOWN;

you assume UNKNOWN is zero by doing !lanes in auto_linkmodes -
that's inconsistent.

> +	}
> +
>  	ret = ethnl_update_bitset(ksettings->link_modes.advertising,
>  				  __ETHTOOL_LINK_MODE_MASK_NBITS,
>  				  tb[ETHTOOL_A_LINKMODES_OURS], link_mode_names,

