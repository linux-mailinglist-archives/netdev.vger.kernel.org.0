Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 183B7149CF3
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 22:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgAZVIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 16:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727250AbgAZVIy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 16:08:54 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C17132070A;
        Sun, 26 Jan 2020 21:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580072933;
        bh=xzaUJNcDJJ8cQ0eZxk+LY8r5/w/L49RyiRR6cOOZMpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fC/GC1zkZo/Zq+fU8DfVwp0KiXbCPm/Y4dF8266tDkqoin1nHkTbFNIwldLizAo7c
         x0PSS8cPlyeVJ5FeGjTVS3bvrkAjvltr8RcLj8k7bXLXzyrNH1MAelsrdDrXrku/3C
         uJ838CoXzm6nkxSoPRCg6AvjiMKruTZEuX0JpL2U=
Date:   Sun, 26 Jan 2020 23:08:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126210850.GB3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
 <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
 <20200126194110.GA3870@unreal>
 <20200126124957.78a31463@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200126124957.78a31463@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 12:49:57PM -0800, Jakub Kicinski wrote:
> On Sun, 26 Jan 2020 21:41:10 +0200, Leon Romanovsky wrote:
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
> >
> > The thing is that leaving this field as empty, for sure will break all
> > applications. I have a feeling that it can be close to 100% hit rate.
> > So, kernel version was chosen as an option, because it is already
> > successfully in use by at least two drivers (nfp and hns).
>
> Shannon does have a point that out of tree drivers still make use of
> this field. Perhaps it would be a more suitable first step to print the
> kernel version as default and add a comment saying upstream modules
> shouldn't overwrite it (perhaps one day CI can catch new violators).

Jakub,

Shannon proposed to remove this field and it was me who said no :)
My plan is to overwrite ->version, delete all users and add
WARN_ONEC(strcpy(..->version_)...) inside net/ethtool/ to catch
abusers.

>
> The NFP reports the git hash of the driver source plus the string
> "(oot)" for out-of-tree:
>
> https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L297
> https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L315

I was inspired by upstream code.
https://elixir.bootlin.com/linux/v5.5-rc7/source/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c#L184

>
> > Leaving to deal with driver version to vendors is not an option too,
> > because they prove for more than once that they are not capable to
> > define user visible interfaces. It comes due to their natural believe
> > that their company is alone in the world and user visible interface
> > should be suitable for them only.
> >
> > It is already impossible for users to distinguish properly versions
> > of different vendors, because they use arbitrary strings with some
> > numbers.
>
> That is true. But reporting the kernel version without even as much as
> in-tree/out-of-tree indication makes the field entirely meaningless.

The long-standing policy in kernel that we don't really care about
out-of-tree code.

Thanks
