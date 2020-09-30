Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE28327F381
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgI3Upd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:45:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:42112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3Upc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 16:45:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BE93AD7F;
        Wed, 30 Sep 2020 20:45:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EB56760787; Wed, 30 Sep 2020 22:45:30 +0200 (CEST)
Date:   Wed, 30 Sep 2020 22:45:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, ayal@nvidia.com,
        danieller@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net] ethtool: Fix incompatibility between netlink and
 ioctl interfaces
Message-ID: <20200930204530.3xu7trqxu7su5vi7@lion.mk-sys.cz>
References: <20200929160247.1665922-1-idosch@idosch.org>
 <20200929164455.pzymi4chmvl3yua5@lion.mk-sys.cz>
 <20200930072529.GA1788067@shredder>
 <20200930085917.xr2orisrg3oxw6cw@lion.mk-sys.cz>
 <20200930200653.GC1850258@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930200653.GC1850258@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:06:53PM +0300, Ido Schimmel wrote:
> On Wed, Sep 30, 2020 at 10:59:17AM +0200, Michal Kubecek wrote:
> > How about this compromise? Let's introduce a "legacy" flag which would
> > allow "ethtool -s <dev> autoneg on" do what it used to do while we would
> > not taint the kernel-userspace API with this special case so that
> > ETHTOOL_MSG_LINKMODES_SET request with only ETHTOOL_A_LINKMODES_AUTONEG
> > (but no other attributes like _SPEED or _DUPLEX) would leave advertised
> > link modes untouched unless the "legacy" flag is set. If the "legacy"
> > flag is set in the request, such request would set advertised modes to
> > all supported.
> 
> Sorry for the delay, busy with other obligations. Regarding the "legacy"
> flag suggestion, do you mean that the ethtool user space utility will
> always set it in ETHTOOL_MSG_LINKMODES_SET request in order to maintain
> backward compatibility with the ioctl interface?

Yes, that is what I meant. We could also do the opposite (ioctl
compatibility by default and a flag for the way it works now) but
I would prefer the default (on userspace-kernel API level) to be "only
ETHTOOL_A_LINKMODES_AUTONEG attribute means we only want to switch
autonegotiation and touch nothing else".

Michal
