Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A027629E6CC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgJ2JDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:03:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:41076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgJ2JDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 05:03:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 07B80ABA2;
        Thu, 29 Oct 2020 09:03:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 787B0604D8; Thu, 29 Oct 2020 10:03:28 +0100 (CET)
Date:   Thu, 29 Oct 2020 10:03:28 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        David.Laight@aculab.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201029090328.jwl7w7noeib3d4cz@lion.mk-sys.cz>
References: <20201027145114.226918-1-idosch@idosch.org>
 <20201027145305.48ca1123@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201028005339.45daonidsidbzawn@lion.mk-sys.cz>
 <20201028173436.GA504959@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028173436.GA504959@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 07:34:36PM +0200, Ido Schimmel wrote:
> On Wed, Oct 28, 2020 at 01:53:39AM +0100, Michal Kubecek wrote:
> > On Tue, Oct 27, 2020 at 02:53:05PM -0700, Jakub Kicinski wrote:
> > > 
> > > I did not look at the legacy code but I'm confused by what you wrote.
> > > 
> > > IIUC for ioctl it's the user space that sets the advertised.
> > > For netlink it's the kernel.
> > > So how does the legacy flag make the kernel behave like it used to?
> > 
> > The idea why I suggested "legacy" as the name was that it allowed
> > ethtool to preserve the old behaviour (without having to query for
> > supported modes first). But from this point of view it's indeed a bit
> > confusing.
> 
> I think it would be best to solve this by having user space query the
> kernel for supported link modes if autoneg is being enabled without
> additional parameters. Then user space will issue a set request with
> ETHTOOL_A_LINKMODES_OURS being set to all supported link modes.
> 
> It does not require kernel changes and would be easier on users that
> currently need to resort to old ethtool despite having a kernel that
> supports netlink-based ethtool.

That would certainly be a solution. I'm not exactly happy about having
to issue two requests but (1) it would be limited to specific case with
"autoneg on" without advertise, speed and duplex (and lanes, when/if
it's introduced), (2) we would need an extra request to check support of
the flag anyway and (3) supported modes of a device are unlikely to
change so that we don't have to worry about races.

Michal
