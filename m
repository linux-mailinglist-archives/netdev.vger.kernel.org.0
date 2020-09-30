Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB47127E46B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgI3I7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:59:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:60696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3I7U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 04:59:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 284C3ADAB;
        Wed, 30 Sep 2020 08:59:18 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C415C60787; Wed, 30 Sep 2020 10:59:17 +0200 (CEST)
Date:   Wed, 30 Sep 2020 10:59:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, ayal@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930072529.GA1788067@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:25:29AM +0300, Ido Schimmel wrote:
> On Tue, Sep 29, 2020 at 06:44:55PM +0200, Michal Kubecek wrote:
> > On Tue, Sep 29, 2020 at 07:02:47PM +0300, Ido Schimmel wrote:
> > > diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> > > index 7044a2853886..a9458c76209e 100644
> > > --- a/net/ethtool/linkmodes.c
> > > +++ b/net/ethtool/linkmodes.c
> > > @@ -288,9 +288,9 @@ linkmodes_set_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
> > >  };
> > >  
> > >  /* Set advertised link modes to all supported modes matching requested speed
> > > - * and duplex values. Called when autonegotiation is on, speed or duplex is
> > > - * requested but no link mode change. This is done in userspace with ioctl()
> > > - * interface, move it into kernel for netlink.
> > > + * and duplex values, if specified. Called when autonegotiation is on, but no
> > > + * link mode change. This is done in userspace with ioctl() interface, move it
> > > + * into kernel for netlink.
> > >   * Returns true if advertised modes bitmap was modified.
> > >   */
> > >  static bool ethnl_auto_linkmodes(struct ethtool_link_ksettings *ksettings,
> > > @@ -381,7 +381,6 @@ static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **tb,
> > >  	ethnl_update_u8(&lsettings->master_slave_cfg, master_slave_cfg, mod);
> > >  
> > >  	if (!tb[ETHTOOL_A_LINKMODES_OURS] && lsettings->autoneg &&
> > > -	    (req_speed || req_duplex) &&
> > >  	    ethnl_auto_linkmodes(ksettings, req_speed, req_duplex))
> > >  		*mod = true;
> > 
> > I'm afraid we will have to cope with existing drivers hiding advertised
> > mode setting when autonegotiation is off. Could we at least limit the
> > call to such drivers, i.e. replacing that line with something like
> > 
> > 	(req_speed || req_duplex || (!old_autoneg && advertised_empty))
> > 
> > where old_autoneg would be the original value of lsettings->autoneg and
> > advertised_empty would be set if currently reported advertised modes are
> > zero?
> 
> I don't think so. Doing:
> 
> # ethtool -s eth0 autoneg
> 
> Is a pretty established behavior to enable all the supported advertise
> bits. Here is an example with an unpatched kernel, two ethtool versions
> (ioctl & netlink) and e1000 in QEMU.

I didn't say that ethtool does not behave like this. I just said it was
a very unfortunate idea and suggested to only preserve this unfortunate
behaviour for drivers like mlxsw which reset advertised modes whenever
autonegotiation is turned off (which is something that should be IMHO
fixed regardless of the result of this discussion). After all, even the
behaviour of

  ethtool -s $dev autoneg on speed $s duplex $d

you mentioned earlier does in fact work with ioctl only for a limited
(and very small) set of link modes, only if both speed and duplex are
provided and even then it only chooses one of matching modes, completely
ignoring what the device supports. If we wanted to be 100% compatible,
e.g.

  ethtool -s <dev> autoneg on speed 100000
  ethtool -s <dev> autoneg on speed 100000 duplex full

would have to ignore the parameters and enable all supported modes while
the same commands with "1000" instead of "100000" would work as expected
(as long as the device supports 1000baseT/Full and not one the other
three 1000base*/Full modes). That doesn't sound like a good idea to me.

How about this compromise? Let's introduce a "legacy" flag which would
allow "ethtool -s <dev> autoneg on" do what it used to do while we would
not taint the kernel-userspace API with this special case so that
ETHTOOL_MSG_LINKMODES_SET request with only ETHTOOL_A_LINKMODES_AUTONEG
(but no other attributes like _SPEED or _DUPLEX) would leave advertised
link modes untouched unless the "legacy" flag is set. If the "legacy"
flag is set in the request, such request would set advertised modes to
all supported.

Michal
