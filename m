Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF620292631
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgJSLE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:04:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:40350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJSLEY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 07:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2390EAF47;
        Mon, 19 Oct 2020 11:04:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8FAC760563; Mon, 19 Oct 2020 13:04:22 +0200 (CEST)
Date:   Mon, 19 Oct 2020 13:04:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 07:19:34AM +0000, Danielle Ratson wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Saturday, October 17, 2020 1:16 AM
> > 
> > I'm not sure i fully understand all these different link modes, but
> > i thought these 5 are all 100G using 2 lanes? So why cannot the user
> > simply do
> > 
> > ethtool -s swp1 advertise 100000baseKR2/Full
> > 
> > and the driver can figure out it needs to use two lanes at 50G?
> > 
> >     Andrew
> 
> Hi Andrew,
> 
> Thanks for the feedback.
> 
> I guess you mean " ethtool -s swp1 advertise 100000baseKR2/Full on".
> 
> First, the idea might work but only for auto negotiation mode, whereas
> the lanes parameter is a solution for both.
> 
> Second, the command as you have suggested it, wouldn't change anything
> in the current situation as I checked. We can disable all the others
> and leave only the one we want but the command doesn't filter the
> other link modes but it just turns the mentioned link modes up if they
> aren't. However, the lanes parameter is a selector, which make it much
> more user friendly in my opinion.

It would be quite easy to extend the ethtool command line parser to
allow also

  ethtool -s <dev> advertise <mode> ...

in addition to already supported

  ethtool -s <dev> advertise <mask>
  ethtool -s <dev> advertise <mask>/<mask>
  ethtool -s { <mode> { on | off } } ...

Parser converting simple list of values into a maskless bitset is
already there so it would be only matter of checking if there are at
least two arguments and second is "on" or "off" and using corresponding
parser. I think it would be useful independently of this series.

> Also, we can't turn only one of them up. But you have to set for
> example:
> 
> $ ethtool -s swp1 advertise 100000baseKR2/Full on 100000baseSR2/Full on 100000baseCR2/Full on 100000baseLR2_ER2_FR2/Full on 100000baseDR2/Full on
> 
> Am I missing something?

IIUC Jakub's concern is rather about real life need for such selectors,
i.e. how realistic is "I want a(ny) 100Gb/s mode with two lanes" as an
actual user need; if it wouldn't be mostly (or only) used as a quick way
to distinguish between two supported 100Gb/s modes.

IMHO if we go this way, we should consider going all the way, i.e. allow
also selecting by the remaining part of the mode ("media type", e.g.
"LR", not sure what the official name is) and, more important, get full
information about link mode in use from driver (we only get speed and
duplex at the moment). But that would require changes in the
get_linksettings() interface and drivers.

Michal
