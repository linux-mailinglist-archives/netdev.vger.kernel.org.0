Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A0E149EDD
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 06:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0Ft7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 00:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0Ft7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 00:49:59 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9F8214AF;
        Mon, 27 Jan 2020 05:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580104198;
        bh=K+fu988Uet7GW8hiUc2COzyQq2bbkhraJGtq/zvzsoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w/iD1jQyJfjXGvp2zPx7yS/+Nd7ZlirSbG6GT0hVOn0eZiyLG4thXWgdLxjt9eLXL
         OQO752f0URAsE2siF9Z82TAV7EToMSZj3o2XQoVhmH4OyX8ommR2jHTeJ+DFQEWc/E
         Bz4m8MLDypnKkPSBaD2pSLk+1ntwkM/6XKFW+PSQ=
Date:   Mon, 27 Jan 2020 07:49:55 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200127054955.GG3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
 <20200126210850.GB3870@unreal>
 <20200126133353.77f5cb7e@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200126133353.77f5cb7e@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 01:33:53PM -0800, Jakub Kicinski wrote:
> On Sun, 26 Jan 2020 23:08:50 +0200, Leon Romanovsky wrote:
> > On Sun, Jan 26, 2020 at 12:49:57PM -0800, Jakub Kicinski wrote:
> > > On Sun, 26 Jan 2020 21:41:10 +0200, Leon Romanovsky wrote:
> > > > > This will end up affecting out-of-tree drivers as well, where it is useful
> > > > > to know what the version number is, most especially since it is different
> > > > > from what the kernel provided driver is.  How else are we to get this
> > > > > information out to the user?  If this feature gets squashed, we'll end up
> > > > > having to abuse some other mechanism so we can get the live information from
> > > > > the driver, and probably each vendor will find a different way to sneak it
> > > > > out, giving us more chaos than where we started.  At least the ethtool
> > > > > version field is a known and consistent place for the version info.
>
> > > Shannon does have a point that out of tree drivers still make use of
> > > this field. Perhaps it would be a more suitable first step to print the
> > > kernel version as default and add a comment saying upstream modules
> > > shouldn't overwrite it (perhaps one day CI can catch new violators).
> >
> > Shannon proposed to remove this field and it was me who said no :)
>
> Obviously, we can't remove fields from UAPI structs.
>
> > My plan is to overwrite ->version, delete all users and add
> > WARN_ONEC(strcpy(..->version_)...) inside net/ethtool/ to catch
> > abusers.
>
> What I was thinking just now was: initialize ->version to utsname
> before drivers are called, delete all upstream users, add a coccicheck
> for upstream drivers which try to report the version.
>
> > > The NFP reports the git hash of the driver source plus the string
> > > "(oot)" for out-of-tree:
> > >
> > > https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L297
> > > https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L315
> >
> > I was inspired by upstream code.
> > https://elixir.bootlin.com/linux/v5.5-rc7/source/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c#L184
>
> Right, upstream nfp reports kernel version (both in modinfo and ethtool)
> GitHub/compat/backport/out-of-tree reports kernel version in which the
> code was expected to appear in modinfo:
>
> https://github.com/Netronome/nfp-drv-kmods/commit/7ec15c47caf5dbdf1f9806410535ad5b7373ec34#diff-492d7fa4004d885a38cfa889ed1adbe7L1284
>
> And git hash of the driver source plus out of tree marker in ethtool.
>
> That means it's out-of-tree driver which has to carry the extra code
> and require extra feeding. As backport should IMHO.
>
> > > > Leaving to deal with driver version to vendors is not an option too,
> > > > because they prove for more than once that they are not capable to
> > > > define user visible interfaces. It comes due to their natural believe
> > > > that their company is alone in the world and user visible interface
> > > > should be suitable for them only.
> > > >
> > > > It is already impossible for users to distinguish properly versions
> > > > of different vendors, because they use arbitrary strings with some
> > > > numbers.
> > >
> > > That is true. But reporting the kernel version without even as much as
> > > in-tree/out-of-tree indication makes the field entirely meaningless.
> >
> > The long-standing policy in kernel that we don't really care about
> > out-of-tree code.
>
> Yeah... we all know it's not that simple :)

It is simple, unfortunately netdev people like to complicate things
by declaring ABI in very vague way which sometimes goes so far that
it ends more strict than anyone would imagine.

We, RDMA and many other subsystems mentioned in that ksummit thread,
removed MODULE_VERSION() a long time ago and got zero complains from
the real users.

>
> The in-tree driver versions are meaningless and cause annoying churn
> when people arbitrarily bump them. If we can get people to stop doing
> that we'll be happy, that's all there is to it.
>
> Out of tree the field is useful, so we don't have to take it away just
> as a matter of principle. If we can't convince people to stop bringing
> the versions into the tree that'll be another story...

As Shannon pointed, even experienced people will try to sneak those
changes. I assume that it is mainly because they are pushed to do it
by the people who doesn't understand Linux kernel process.

Thanks
