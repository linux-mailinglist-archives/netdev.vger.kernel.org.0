Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9211149C8E
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgAZTlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 14:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgAZTlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 14:41:14 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D98382070A;
        Sun, 26 Jan 2020 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580067673;
        bh=aV6SbpYb8OLpLFa+7QxrVuRTrTzIUq+jZmrLZP/TXtA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmR623tEs8OafjTUO5S3OrrEXZkfDGrayPB9un6Vyc93O9YvkFD/oohF/784rI6rH
         Fu6Eldoosx1j5QvaUfhT7Rt8vEDFGjvfrm5CTFKrnUFB7GQ+b1HWow3Rci0fQMn/K+
         /srq0vDhpO1OM6bFrSunUHdptia3STbe/tw53qNo=
Date:   Sun, 26 Jan 2020 21:41:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126194110.GA3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 10:56:17AM -0800, Shannon Nelson wrote:
> On 1/23/20 5:05 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky<leonro@mellanox.com>
> >
> > In order to stop useless driver version bumps and unify output
> > presented by ethtool -i, let's overwrite the version string.
> >
> > Before this change:
> > [leonro@erver ~]$ ethtool -i eth0
> > driver: virtio_net
> > version: 1.0.0
> > After this change:
> > [leonro@server ~]$ ethtool -i eth0
> > driver: virtio_net
> > version: 5.5.0-rc6+
> >
> > Signed-off-by: Leon Romanovsky<leonro@mellanox.com>
> > ---
> > I wanted to change to VERMAGIC_STRING, but the output doesn't
> > look pleasant to my taste and on my system is truncated to be
> > "version: 5.5.0-rc6+ SMP mod_unload modve".
> >
> > After this patch, we can drop all those version assignments
> > from the drivers.
> >
> > Inspired by nfp and hns code.
> > ---
> >   net/core/ethtool.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> > index cd9bc67381b2..3c6fb13a78bf 100644
> > --- a/net/core/ethtool.c
> > +++ b/net/core/ethtool.c
> > @@ -17,6 +17,7 @@
> >   #include <linux/phy.h>
> >   #include <linux/bitops.h>
> >   #include <linux/uaccess.h>
> > +#include <linux/vermagic.h>
> >   #include <linux/vmalloc.h>
> >   #include <linux/sfp.h>
> >   #include <linux/slab.h>
> > @@ -776,6 +777,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
> >   		return -EOPNOTSUPP;
> >   	}
> >
> > +	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
> > +
> >   	/*
> >   	 * this method of obtaining string set info is deprecated;
> >   	 * Use ETHTOOL_GSSET_INFO instead.
> > --
> > 2.20.1
> >
>
> First of all, although I've seen some of the arguments about distros and
> their backporting, I still believe that the driver version number is
> useful.  In most cases it at least gets us in the ballpark of what
> generation the driver happens to be and is still useful. I'd really prefer
> that it is just left alone for the device manufactures and their support
> folks to deal with.
>
> Fine, I'm sure I lose that argument since there's already been plenty of
> discussion about it.
>
> Meanwhile, there is some non-zero number of support scripts and processes,
> possibly internal testing chains, that use that driver/vendor specific
> version information and will be broken by this change.  Small number?  Large
> number?  I don't know, but we're breaking them.
>
> Sure, I probably easily lose that argument too, but it still should be
> stated.
>
> This will end up affecting out-of-tree drivers as well, where it is useful
> to know what the version number is, most especially since it is different
> from what the kernel provided driver is.  How else are we to get this
> information out to the user?  If this feature gets squashed, we'll end up
> having to abuse some other mechanism so we can get the live information from
> the driver, and probably each vendor will find a different way to sneak it
> out, giving us more chaos than where we started.  At least the ethtool
> version field is a known and consistent place for the version info.
>
> Of course, out-of-tree drivers are not first class citizens, so I probably
> lose that argument as well.
>
> So if you are so all fired up about not allowing the drivers to report their
> own version number, then why report anything at all? Maybe just report a
> blank field.  As some have said, the uname info is already available else
> where, why are we sticking it here?
>
> Personally, I think this is a rather arbitrary, heavy handed and unnecessary
> slam on the drivers, and will make support more difficult in the long run.

The thing is that leaving this field as empty, for sure will break all
applications. I have a feeling that it can be close to 100% hit rate.
So, kernel version was chosen as an option, because it is already
successfully in use by at least two drivers (nfp and hns).

Leaving to deal with driver version to vendors is not an option too,
because they prove for more than once that they are not capable to
define user visible interfaces. It comes due to their natural believe
that their company is alone in the world and user visible interface
should be suitable for them only.

It is already impossible for users to distinguish properly versions
of different vendors, because they use arbitrary strings with some
numbers.

Thanks

>
> sln
>
