Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C13149CE7
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgAZUt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:49:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAZUt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 15:49:59 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D73E206F0;
        Sun, 26 Jan 2020 20:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580071798;
        bh=jY+cxvFBsfjlLclgEOv0B56WnSgAKQJ+plo0iuiLErE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nAQg3s1Wc57icOj9JyB5ZMNZ4NA/xeazI8/rD1XTzg3tA/tXiYF6uQBvg+io7YuNK
         jL9z/MeQ6EJe3bhbnvmkYkC5QAMjVpHhgcn/aqy3o/XT+EKtZfW6wsUSA3vgiznNnU
         VInaxheMeB5HUongvwbYBQOa+uEKEA0m+VOFU294=
Date:   Sun, 26 Jan 2020 12:49:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/core: Replace driver version to be kernel
 version
Message-ID: <20200126124957.78a31463@cakuba>
In-Reply-To: <20200126194110.GA3870@unreal>
References: <20200123130541.30473-1-leon@kernel.org>
        <43d43a45-18db-f959-7275-63c9976fdf40@pensando.io>
        <20200126194110.GA3870@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jan 2020 21:41:10 +0200, Leon Romanovsky wrote:
> > This will end up affecting out-of-tree drivers as well, where it is use=
ful
> > to know what the version number is, most especially since it is differe=
nt
> > from what the kernel provided driver is.=C2=A0 How else are we to get t=
his
> > information out to the user?=C2=A0 If this feature gets squashed, we'll=
 end up
> > having to abuse some other mechanism so we can get the live information=
 from
> > the driver, and probably each vendor will find a different way to sneak=
 it
> > out, giving us more chaos than where we started.=C2=A0 At least the eth=
tool
> > version field is a known and consistent place for the version info.
> >
> > Of course, out-of-tree drivers are not first class citizens, so I proba=
bly
> > lose that argument as well.
> >
> > So if you are so all fired up about not allowing the drivers to report =
their
> > own version number, then why report anything at all? Maybe just report a
> > blank field.=C2=A0 As some have said, the uname info is already availab=
le else
> > where, why are we sticking it here?
> >
> > Personally, I think this is a rather arbitrary, heavy handed and unnece=
ssary
> > slam on the drivers, and will make support more difficult in the long r=
un. =20
>=20
> The thing is that leaving this field as empty, for sure will break all
> applications. I have a feeling that it can be close to 100% hit rate.
> So, kernel version was chosen as an option, because it is already
> successfully in use by at least two drivers (nfp and hns).

Shannon does have a point that out of tree drivers still make use of
this field. Perhaps it would be a more suitable first step to print the
kernel version as default and add a comment saying upstream modules
shouldn't overwrite it (perhaps one day CI can catch new violators).

The NFP reports the git hash of the driver source plus the string
"(oot)" for out-of-tree:

https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L297
https://github.com/Netronome/nfp-drv-kmods/blob/master/src/Kbuild#L315

> Leaving to deal with driver version to vendors is not an option too,
> because they prove for more than once that they are not capable to
> define user visible interfaces. It comes due to their natural believe
> that their company is alone in the world and user visible interface
> should be suitable for them only.
>=20
> It is already impossible for users to distinguish properly versions
> of different vendors, because they use arbitrary strings with some
> numbers.

That is true. But reporting the kernel version without even as much as
in-tree/out-of-tree indication makes the field entirely meaningless.
