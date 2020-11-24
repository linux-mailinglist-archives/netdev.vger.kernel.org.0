Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB62C33B5
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389117AbgKXWM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:12:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:41002 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388540AbgKXWM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:12:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EEA3BAC66;
        Tue, 24 Nov 2020 22:12:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7274560786; Tue, 24 Nov 2020 23:12:25 +0100 (CET)
Date:   Tue, 24 Nov 2020 23:12:25 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201124221225.6ae444gcl7npoazh@lion.mk-sys.cz>
References: <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
 <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 09:47:53AM +0000, Danielle Ratson wrote:
> 
> 
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Thursday, October 22, 2020 7:28 PM
> > To: Danielle Ratson <danieller@nvidia.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>; Andrew Lunn <andrew@lunn.ch>; Jakub Kicinski <kuba@kernel.org>; Ido Schimmel
> > <idosch@idosch.org>; netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw
> > <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>; johannes@sipsolutions.net
> > Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI with lanes
> > 
> > On Thu, Oct 22, 2020 at 06:15:48AM +0000, Danielle Ratson wrote:
> > > > -----Original Message-----
> > > > From: Michal Kubecek <mkubecek@suse.cz>
> > > > Sent: Wednesday, October 21, 2020 11:48 AM
> > > >
> > > > Ah, right, it does. But as you extend struct ethtool_link_ksettings
> > > > and drivers will need to be updated to provide this information,
> > > > wouldn't it be more useful to let the driver provide link mode in
> > > > use instead (and derive number of lanes from it)?
> > >
> > > This is the way it is done with the speed parameter, so I have aligned
> > > it to it. Why the lanes should be done differently comparing to the
> > > speed?
> > 
> > Speed and duplex have worked this way since ages and the interface was probably introduced back in times when combination of
> > speed and duplex was sufficient to identify the link mode. This is no longer the case and even adding number of lanes wouldn't make
> > the combination unique. So if we are going to extend the interface now and update drivers to provide extra information, I believe it
> > would be more useful to provide full information.
> > 
> > Michal
> 
> Hi Michal,
> 
> What do you think of passing the link modes you have suggested as a
> bitmask, similar to "supported", that contains only one positive bit?
> Something like that:
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index afae2beacbc3..dd946c88daa3 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -127,6 +127,7 @@ struct ethtool_link_ksettings {
>                 __ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
>                 __ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
>                 __ETHTOOL_DECLARE_LINK_MODE_MASK(lp_advertising);
> +               __ETHTOOL_DECLARE_LINK_MODE_MASK(chosen);
>         } link_modes;
>         u32     lanes;
>  };
> 
> Do you have perhaps a better suggestion?

Not sure if it's better but as we know there is only one mode, we could
simply pass the index. We would still need to reserve a special value
for none/unknown but getting an index would make lookup easier.

> And the speed and duplex parameters should be removed from being
> passed like as well, right?

We cannot remove them from struct ethtool_link_settings and the ioctl
and netlink messages as those are part of UAPI and we have to preserve
backward compatibility. But drivers which provide link mode would not
need to fill speed and duplex in their ->get_link_ksettings() as the
common code could do that for them.

Michal
