Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37036149CFA
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgAZVUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgAZVUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 16:20:04 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E4562070A;
        Sun, 26 Jan 2020 21:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580073602;
        bh=m2BU/KQN8cxgGSvDMhW9dRcxyNEvM7baX/UG+pZ3hbI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4YrQyqw9Ms0BMo/6BGEP2mcGdt2iQKg6senL1hhc+2IM1Xlu5Vjr1qtI5z2p5gPc
         89aL2p80haix4d9FQ4C4jnPL23lmsErywJRG+qEhy4I46cP1DheQiOGgFqn16zzjs1
         RvzbuWB4X0y/OtsQWI3kt1qb1g4tdfu24QIWA+LY=
Date:   Sun, 26 Jan 2020 23:19:59 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126211959.GC3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <67fa104b-8b0e-dd70-3cc3-04dd008639be@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <67fa104b-8b0e-dd70-3cc3-04dd008639be@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 12:52:05PM -0800, Shannon Nelson wrote:
> On 1/26/20 11:41 AM, Leon Romanovsky wrote:
> > On Sun, Jan 26, 2020 at 10:56:17AM -0800, Shannon Nelson wrote:
> > > On 1/23/20 5:05 AM, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky<leonro@mellanox.com>
> > > >
> > > > In order to stop useless driver version bumps and unify output
> > > > presented by ethtool -i, let's overwrite the version string.
> > > >
> > > > Before this change:
> > > > [leonro@erver ~]$ ethtool -i eth0
> > > > driver: virtio_net
> > > > version: 1.0.0
> > > > After this change:
> > > > [leonro@server ~]$ ethtool -i eth0
> > > > driver: virtio_net
> > > > version: 5.5.0-rc6+
> > > >
> > > > Signed-off-by: Leon Romanovsky<leonro@mellanox.com>
> > > > ---
> > > > I wanted to change to VERMAGIC_STRING, but the output doesn't
> > > > look pleasant to my taste and on my system is truncated to be
> > > > "version: 5.5.0-rc6+ SMP mod_unload modve".
> > > >
> > > > After this patch, we can drop all those version assignments
> > > > from the drivers.
> > > >
> > > > Inspired by nfp and hns code.
> > > > ---
> > > >    net/core/ethtool.c | 3 +++
> > > >    1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > > > index cd9bc67381b2..3c6fb13a78bf 100644
> > > > --- a/net/core/ethtool.c
> > > > +++ b/net/core/ethtool.c
> > > > @@ -17,6 +17,7 @@
> > > >    #include <linux/phy.h>
> > > >    #include <linux/bitops.h>
> > > >    #include <linux/uaccess.h>
> > > > +#include <linux/vermagic.h>
> > > >    #include <linux/vmalloc.h>
> > > >    #include <linux/sfp.h>
> > > >    #include <linux/slab.h>
> > > > @@ -776,6 +777,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
> > > >    		return -EOPNOTSUPP;
> > > >    	}
> > > >
> > > > +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
> > > > +
> > > >    	/*
> > > >    	 * this method of obtaining string set info is deprecated;
> > > >    	 * Use ETHTOOL_GSSET_INFO instead.
> > > > --
> > > > 2.20.1
> > > >
> > > First of all, although I've seen some of the arguments about distros and
> > > their backporting, I still believe that the driver version number is
> > > useful.  In most cases it at least gets us in the ballpark of what
> > > generation the driver happens to be and is still useful. I'd really prefer
> > > that it is just left alone for the device manufactures and their support
> > > folks to deal with.
> > >
> > > Fine, I'm sure I lose that argument since there's already been plenty of
> > > discussion about it.
> > >
> > > Meanwhile, there is some non-zero number of support scripts and processes,
> > > possibly internal testing chains, that use that driver/vendor specific
> > > version information and will be broken by this change.  Small number?  Large
> > > number?  I don't know, but we're breaking them.
> > >
> > > Sure, I probably easily lose that argument too, but it still should be
> > > stated.
> > >
> > > This will end up affecting out-of-tree drivers as well, where it is useful
> > > to know what the version number is, most especially since it is different
> > > from what the kernel provided driver is.  How else are we to get this
> > > information out to the user?  If this feature gets squashed, we'll end up
> > > having to abuse some other mechanism so we can get the live information from
> > > the driver, and probably each vendor will find a different way to sneak it
> > > out, giving us more chaos than where we started.  At least the ethtool
> > > version field is a known and consistent place for the version info.
> > >
> > > Of course, out-of-tree drivers are not first class citizens, so I probably
> > > lose that argument as well.
> > >
> > > So if you are so all fired up about not allowing the drivers to report their
> > > own version number, then why report anything at all? Maybe just report a
> > > blank field.  As some have said, the uname info is already available else
> > > where, why are we sticking it here?
> > >
> > > Personally, I think this is a rather arbitrary, heavy handed and unnecessary
> > > slam on the drivers, and will make support more difficult in the long run.
> > The thing is that leaving this field as empty, for sure will break all
> > applications. I have a feeling that it can be close to 100% hit rate.
> > So, kernel version was chosen as an option, because it is already
> > successfully in use by at least two drivers (nfp and hns).
>
> I'm glad that works for those drivers.
>
> > Leaving to deal with driver version to vendors is not an option too,
> > because they prove for more than once that they are not capable to
> > define user visible interfaces. It comes due to their natural believe
> > that their company is alone in the world and user visible interface
> > should be suitable for them only.
>
> So you want to remove the one reliable place to put some information we find
> useful, thus forcing us to come up with creative new places to put it? 

What exactly do you find reliable in random string printed by ethtool?

> Shall we remove the firmware version number as well when we start abusing it
> by adding driver version information?

It is unrelated and I have hard time to understand your question, firmware
is not part of the kernel and firmware version needed to tight specific driver
to specific version. It doesn't need to be general by definition.

>
> There has been a lot of work over the years to try to corral and unify
> various bits of information so that everyone can access it the same way, and
> now you're trying to remove one of those methods. This will only force
> driver writers to get "creative" on how to get the info they need out to the
> user.

I'm not removing, but fixing something that was broken for a long time
already. The version thing comes from pre-git era and it doesn't make
sense for a long time already.

>
> > It is already impossible for users to distinguish properly versions
> > of different vendors, because they use arbitrary strings with some
> > numbers.
>
> Shall we also fix it so those pesky distros can't add their own arbitrary
> version numbers to the kernel?
>
> Again, I think you are trying to remove a useful bit of information.  Just
> because it isn't useful to you doesn't mean it is useless to others.
>

Again, I'm not removing it.

Feel free to start discussion in ksummit mailing list on why it is so
useful that we need to update driver version independently from the
main kernel version.

If you success to convince Linus and Greg, we will be happy to update
our driver version every week like a clock.

Thanks

> sln
>
