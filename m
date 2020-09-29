Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579B827D3CD
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgI2QpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:45:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:40484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgI2Qo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 12:44:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1D020B281;
        Tue, 29 Sep 2020 16:44:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A1E2F60787; Tue, 29 Sep 2020 18:44:55 +0200 (CEST)
Date:   Tue, 29 Sep 2020 18:44:55 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        ayal@nvidia.com, danieller@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
References: <20200929160247.1665922-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929160247.1665922-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 07:02:47PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> With the ioctl interface, when autoneg is enabled, but without
> specifying speed, duplex or link modes, the advertised link modes are
> set to the supported link modes by the ethtool user space utility.
> 
[...] 
> 
> With the netlink interface, the same thing is done by the kernel, but
> only if speed or duplex are specified. In which case, the advertised
> link modes are set by traversing the supported link modes and picking
> the ones matching the specified speed or duplex.
> 
> However, if speed nor duplex are specified, the driver is passed an
> empty advertised link modes bitmap. This causes the mlxsw driver to
> return an error. Other drivers might also be affected. Example:

This is not completely correct. What actually happens is that the
advertised modes bitmap is left untouched. The reason why advertised
modes are cleared for mlxsw is that this driver reports empty advertised
modes whenever autonegotiation is disabled.

This is similar to recent discussions about distinguishing between
configuration and state. One of them was related to EEE settings, one to
pause settings, one to WoL settings vs. general wakeup enable/disable:

  http://lkml.kernel.org/r/20200511132258.GT1551@shell.armlinux.org.uk
  http://lkml.kernel.org/r/20200512185503.GD1551@shell.armlinux.org.uk
  http://lkml.kernel.org/r/20200521192342.GE8771@lion.mk-sys.cz

All of these are about common problem: we have a settings A and B such
that B is only effective if A is enabled. Should we report B as disabled
whenever A is disabled? I believe - and the consensus in those
discussions seemed to be - that we should report and set A and B
independently to distinguish between configuration (what user wants) and
state (how the device behaves). There is also practical aspect: (1) if
we don't do this, switching A off and on would reset the value of B even
if no change of B was requested and (2) commands setting A and B must be
issued in a specific order for changes of B to take effect.

Unfortunately there are drivers like mlxsw (I'm not sure how many) which
report zero advertised bitmap whenever autonegotiation is off.

> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index 7044a2853886..a9458c76209e 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -288,9 +288,9 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
>  };
>  
>  /* Set advertised link modes to all supported modes matching requested speed
> - * and duplex values. Called when autonegotiation is on, speed or duplex is
> - * requested but no link mode change. This is done in userspace with ioctl()
> - * interface, move it into kernel for netlink.
> + * and duplex values, if specified. Called when autonegotiation is on, but no
> + * link mode change. This is done in userspace with ioctl() interface, move it
> + * into kernel for netlink.
>   * Returns true if advertised modes bitmap was modified.
>   */
>  static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
> @@ -381,7 +381,6 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
>  	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
>  
>  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
> -	    (req_speed || req_duplex) &&
>  	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
>  		*mod = true;

I'm afraid we will have to cope with existing drivers hiding advertised
mode setting when autonegotiation is off. Could we at least limit the
call to such drivers, i.e. replacing that line with something like

	(req_speed || req_duplex || (!old_autoneg && advertised_empty))

where old_autoneg would be the original value of lsettings->autoneg and
advertised_empty would be set if currently reported advertised modes are
zero?

Michal
