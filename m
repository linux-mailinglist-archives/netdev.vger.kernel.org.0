Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A43307FAF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhA1U1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:27:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:56380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229831AbhA1U1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:27:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7D54AAC6;
        Thu, 28 Jan 2021 20:26:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8DF456030C; Thu, 28 Jan 2021 21:26:32 +0100 (CET)
Date:   Thu, 28 Jan 2021 21:26:32 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Edwin Peer <edwin.peer@broadcom.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Message-ID: <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com>
 <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
 <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
 <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
 <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 01:22:02PM +0000, Danielle Ratson wrote:
> > -----Original Message-----
> > From: Edwin Peer <edwin.peer@broadcom.com>
> > Sent: Tuesday, January 26, 2021 7:14 PM
> > To: Danielle Ratson <danieller@nvidia.com>
> > Cc: netdev <netdev@vger.kernel.org>; David S . Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Jiri Pirko
> > <jiri@nvidia.com>; Andrew Lunn <andrew@lunn.ch>; f.fainelli@gmail.com; Michal Kubecek <mkubecek@suse.cz>; mlxsw
> > <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>
> > Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of speed and duplex parameters
> > 
> > For one thing, it's cleaner if the driver API is symmetric. The
> > proposed solution sets attributes in terms of speeds and lanes,
> > etc., but it gets them in terms of a compound link_info. But, this
> > asymmetry aside, if link_mode may eventually become R/W at the
> > driver API, as you suggest, then it is more appropriate to guard it
> > with a capability bit, as has been done for lanes, rather than use
> > the -1 special value to indicate that the driver did not set it.
> > 
> > Regards,
> > Edwin Peer
> 
> This patchset adds lanes parameter, not link_mode. The link_mode
> addition was added as a read-only parameter for the reasons we
> mentioned, and I am not sure that implementing the symmetric side is
> relevant for this patchset.
> 
> Michal, do you think we will use the Write side of the link_mode
> parameter?

It makes sense, IMHO. Unless we also add "media" (or whatever name would
be most appropriate) parameter, we cannot in general fully determine the
link mode by speed, duplex and lanes. And using "advertise" to select
a specific mode with disabled autonegotiation would be rather confusing,
I believe. (At the moment, ethtool does not even support syntax like
"advertise <mode>" but it will be easy to support
"advertise <mode>... [--]" and I think we should extend the syntax to
support it, regardless of what we choose.) So if we want to allow user
to pick a specific link node by name or bit mask (or rather index?),
I would prefer using a separate parameter.

>            And if so, do you think it is relevant for this specific
> patchset?

I don't see an obvious problem with leaving that part for later so
I would say it's up to you.

Michal
