Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5E2E20F2
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbgLWThR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgLWThR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 14:37:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F2C322202;
        Wed, 23 Dec 2020 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608752196;
        bh=1D5Iynoo5CSgModaUyibjHKSmHY39reLEMiW+yosW2o=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=t1xS2x8PRV8NWzCG2lSXRvjXyT85ZVxq33blrJvcSlVLXd1u8DGI4F9Oo0Rtllz4V
         FGX3P2gFkz+lYpoIplUsQRwOv5Y1YdH76vmM0KdrhXXEvE5BQOYCHshzp/FoYhSmwN
         3fWj9KDlXb/ZxMXwmCPtR4d0Xjftm8lpxnUWFbqGir5kNHJOBNcTC1aP+WPWi9exd5
         z0LtBvLzqzytRKHgEdVS9GS9qUj5x756N+OaY6wTOzpr0iXR8tgInjR46GRkmidTRz
         Jz9QMvSrrZeybvs0YHGUPcBXqBmNvwz5NSWHbCmj90k8B5NbyBEnd/1mdBiMtpin8K
         aQUs7nOMrVjCQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org> <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com> <160862887909.1246462.8442420561350999328@kwain.local> <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com> <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the maps and dev->tc_num
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Message-ID: <160875219353.1783433.8066935261216141538@kwain.local>
Date:   Wed, 23 Dec 2020 20:36:33 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Quoting Jakub Kicinski (2020-12-23 19:27:29)
> On Tue, 22 Dec 2020 08:12:28 -0800 Alexander Duyck wrote:
> > On Tue, Dec 22, 2020 at 1:21 AM Antoine Tenart <atenart@kernel.org> wro=
te:
> >=20
> > > If I understood correctly, as things are a bit too complex now, you
> > > would prefer that we go for the solution proposed in v1? =20
> >=20
> > Yeah, that is what I am thinking. Basically we just need to make sure
> > the num_tc cannot be updated while we are reading the other values.
>=20
> Yeah, okay, as much as I dislike this approach 300 lines may be a little
> too large for stable.
>=20
> > > I can still do the code factoring for the 2 sysfs show operations, but
> > > that would then target net-next and would be in a different series. S=
o I
> > > believe we'll use the patches of v1, unmodified. =20
>=20
> Are you saying just patch 3 for net-next?

The idea would be to:

- For net, to take all 4 patches from v1. If so, do I need to resend
  them?

- For net-next, to resend patches 2 and 3 from v2 (they'll have to be
  slightly reworked, to take into account the review from Alexander and
  the rtnl lock). The patches can be sent once the ones for net land in
  net-next.

> We need to do something about the fact that with sysfs taking
> rtnl_lock xps_map_mutex is now entirely pointless. I guess its value
> eroded over the years since Tom's initial design so we can just get
> rid of it.

We should be able to remove the mutex (I'll double check as more
functions are involved). If so, I can send a patch to net-next.

Thanks!
Antoine
