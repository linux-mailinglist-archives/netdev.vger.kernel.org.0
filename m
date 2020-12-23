Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219192E21C2
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgLWU5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgLWU5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:57:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10F3922283;
        Wed, 23 Dec 2020 20:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608757019;
        bh=w9trtVYU9YFPGD/CjcB7w7pmj0FTTRIMnOUAteoSgrE=;
        h=In-Reply-To:References:To:From:Subject:Cc:Date:From;
        b=iIdzn4EKVuCGfeDP9H6c4RE0YvcUEm4geJEbEv+26YaKubazZvx9qVDfSWvVcmNz/
         RehuZuZBypkms2VyyUqFCVOy/KLdltyym7gyXX9LTvwc7t9yoLLpdG03yrutoTAyx6
         Hkd/KCM8M7gAvgqgbPiztmzX4x9rEZDsxkOuu0+1xhRq1WJez9VQdP76dLSxVAPFcu
         1ouN95fPf5+qEFWHSoVbU/DTL9Yb9yjyocoXYsXtoGG7W7/LQa48LIC2FI2Dd8zS+/
         PDOIUUojDl4HF9PCY0lsrVsFnDsVMm3MDHVoX6+1VNuN/c/b6ziTIkIgcDYzKNvQhC
         fPODfCjQWkQ9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201223124315.27451932@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org> <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com> <160862887909.1246462.8442420561350999328@kwain.local> <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com> <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <160875219353.1783433.8066935261216141538@kwain.local> <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <160875571511.1783433.16922263997505181889@kwain.local> <20201223124315.27451932@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the maps and dev->tc_num
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Message-ID: <160875701664.1783433.16072409555972227523@kwain.local>
Date:   Wed, 23 Dec 2020 21:56:56 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2020-12-23 21:43:15)
> On Wed, 23 Dec 2020 21:35:15 +0100 Antoine Tenart wrote:
> > > > - For net-next, to resend patches 2 and 3 from v2 (they'll have to =
be
> > > >   slightly reworked, to take into account the review from Alexander=
 and
> > > >   the rtnl lock). The patches can be sent once the ones for net lan=
d in
> > > >   net-next. =20
> > >=20
> > > If the direction is to remove xps_map_mutex, why would we need patch =
2?
> > > =F0=9F=A4=94 =20
> >=20
> > Only the patches for net are needed to fix the race conditions.
> >=20
> > In addition to use the xps_map mutex, patches 2 and 3 from v2 factorize
> > the code into a single function, as xps_cpus_show and xps_rxqs_show
> > share the same logic. That would improve maintainability, but isn't
> > mandatory.
> >=20
> > Sorry, it was not very clear...
>=20
> I like the cleanup, sorry I'm net very clear either.
>=20
> My understanding was that patch 2 was only needed to have access to the
> XPS lock, if we don't plan to use that lock netif_show_xps_queue() can
> stay in the sysfs file, right? I'm all for the cleanup and code reuse
> for rxqs, I'm just making sure I'm not missing anything. I wasn't
> seeing a reason to move netif_show_xps_queue(), that's all.

You understood correctly, the only reason to move this code out of sysfs
was to access the xps_map lock. Without the need, the code can stay in
sysfs.

Patch 2 is not only moving the code out of sysfs, but also reworking
xps_cpus_show. I think I now see where the confusion comes from: the
reason patches 2 and 3 were in two different patches was because they
were targeting net and different kernel versions. They could be squashed
now.

Antoine
