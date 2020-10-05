Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1316B283116
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 09:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJEHqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 03:46:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:42754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgJEHqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 03:46:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48427B26B;
        Mon,  5 Oct 2020 07:46:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E4C7D6035C; Mon,  5 Oct 2020 09:46:00 +0200 (CEST)
Date:   Mon, 5 Oct 2020 09:46:00 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "ayal@nvidia.com" <ayal@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201005074600.xkbomksbbuliuyft@lion.mk-sys.cz>
References: <20201004101707.2177320-1-idosch@idosch.org>
 <07b469aea4494fdeb11f4915459540a4@AcuMS.aculab.com>
 <20201004133757.GA2189885@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004133757.GA2189885@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 04:37:57PM +0300, Ido Schimmel wrote:
> On Sun, Oct 04, 2020 at 12:46:31PM +0000, David Laight wrote:
> > From: Ido Schimmel
> > > Sent: 04 October 2020 11:17
> > > 
> > > With the ioctl interface, when autoneg is enabled, but without
> > > specifying speed, duplex or link modes, the advertised link modes are
> > > set to the supported link modes by the ethtool user space utility.
> > ...
> > > Fix this incompatibility problem by introducing a new flag in the
> > > ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> > > the flag is to indicate to the kernel that it needs to be compatible
> > > with the legacy ioctl interface. A patch to the ethtool user space
> > > utility will make sure the flag is always set.
> > 
> > You need to do that the other way around.
> > You can't assume the kernel and application are updated
> > at the same time.
> 
> Thanks, David. In case ethtool is updated without updating the kernel we
> will indeed get an error:
> 
> # ethtool -s eth0 autoneg on
> netlink error: unrecognized request flags (offset 36)
> netlink error: Operation not supported
> 
> Will wait for Michal's comments before doing another round.

Inverting the logic of the flag wouldn't help much as any tool using the
inverted flag would have the same problem with older kernels. Also,
ethtool needs to handle such errors for any newly added global flag as
discussed in

  http://lkml.kernel.org/r/20200923224510.h3kpgczd6wkpoitp@lion.mk-sys.cz

I'll be too busy today but I'll try to propose a patch implementing the
retry logic in ethtool tomorrow morning.

Michal
