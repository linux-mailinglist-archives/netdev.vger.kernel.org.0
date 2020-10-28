Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9182D29D3B1
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbgJ1VqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:46:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:37316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgJ1Vnn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:43:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 84628AD45;
        Wed, 28 Oct 2020 00:53:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EEB9560736; Wed, 28 Oct 2020 01:53:39 +0100 (CET)
Date:   Wed, 28 Oct 2020 01:53:39 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        David.Laight@aculab.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201028005339.45daonidsidbzawn@lion.mk-sys.cz>
References: <20201027145114.226918-1-idosch@idosch.org>
 <20201027145305.48ca1123@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027145305.48ca1123@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 02:53:05PM -0700, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 16:51:14 +0200 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > With the ioctl interface, when autoneg is enabled, but without
> > specifying speed, duplex or link modes, the advertised link modes are
> > set to the supported link modes by the ethtool user space utility.
> 
> > With the netlink interface, the same thing is done by the kernel, but
> > only if speed or duplex are specified. In which case, the advertised
> > link modes are set by traversing the supported link modes and picking
> > the ones matching the specified speed or duplex.
> 
> > Fix this incompatibility problem by introducing a new flag in the
> > ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> > the flag is to indicate to the kernel that it needs to be compatible
> > with the legacy ioctl interface. A patch to the ethtool user space
> > utility will make sure the flag is set, when supported by the kernel.
> 
> I did not look at the legacy code but I'm confused by what you wrote.
> 
> IIUC for ioctl it's the user space that sets the advertised.
> For netlink it's the kernel.
> So how does the legacy flag make the kernel behave like it used to?

The idea why I suggested "legacy" as the name was that it allowed
ethtool to preserve the old behaviour (without having to query for
supported modes first). But from this point of view it's indeed a bit
confusing.

> If anything LEGACY should mean - don't populate advertised at all,
> user space will do it.

I would prefer not inverting the flag so that at least for the netlink
API, the default semantics would be that ETHTOOL_A_LINKMODES_AUTONEG=1
without other attributes means "enable autonegotiation" as expected
(without touching other settings).

> Also the semantics of a "LEGACY" flag are a little loose for my taste,
> IMHO a new flag attr would be cleaner. ETHTOOL_A_LINKMODES_AUTO_POPULATE?
> But no strong feelings.

Actually, when I suggested using a flag, I had a request specific flag
in mind, not a global one. As for the name, how about
ETHTOOL_A_LINKMODES_ADVERTISE_ALL? It should be probably forbidden to
combine it with ETHTOOL_A_LINKMODES_OURS then.

Michal
