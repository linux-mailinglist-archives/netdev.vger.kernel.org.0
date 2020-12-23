Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12542E21AC
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgLWUn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728909AbgLWUn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:43:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07BEF221F5;
        Wed, 23 Dec 2020 20:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608756196;
        bh=qPWdlTT5isJ7/s5HRSUrKaJSxvw1ueGsx54WFWdNKm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TbbpsIZtTMcbktVA9rngn3/6DJW41W00VIpFP/Yrx/P76tMSPF7jmTlAHP+QoVQlL
         KRlPb/GXY6a68pY3f/ZID1Fx+NV9QfCqiich8w4+m68MiqI/wjLpWFM7FL/SJ3MvD0
         TW8+hcmqcRN7sjuwG0u6H+arM9tkmhjYWRI8X1g2Cgo6LaLH0FaoamOWOB60p9/ZOG
         9JIBszdcB9BxEleV37OZMhW2Iax+xbqyTzMXpBWdEXKTjOC+kmOwn2BFxXQOqB0GPw
         egwfsyiE/y5hMKObmvebuy5LdEOYdS9CIxQ6bNcp+dNCboGUvRDemQmjU8gDhT77lZ
         nBZlbXeS2qvMg==
Date:   Wed, 23 Dec 2020 12:43:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking
 the maps and dev->tc_num
Message-ID: <20201223124315.27451932@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160875571511.1783433.16922263997505181889@kwain.local>
References: <20201221193644.1296933-1-atenart@kernel.org>
        <20201221193644.1296933-2-atenart@kernel.org>
        <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
        <160862887909.1246462.8442420561350999328@kwain.local>
        <CAKgT0UfzNA8qk+QFTN6ihXTxZkcE=vfrjBtyHKL6_9Yyzxt=eQ@mail.gmail.com>
        <20201223102729.6463a5c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875219353.1783433.8066935261216141538@kwain.local>
        <20201223121110.65effe06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <160875571511.1783433.16922263997505181889@kwain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 21:35:15 +0100 Antoine Tenart wrote:
> > > - For net-next, to resend patches 2 and 3 from v2 (they'll have to be
> > >   slightly reworked, to take into account the review from Alexander a=
nd
> > >   the rtnl lock). The patches can be sent once the ones for net land =
in
> > >   net-next. =20
> >=20
> > If the direction is to remove xps_map_mutex, why would we need patch 2?
> > =F0=9F=A4=94 =20
>=20
> Only the patches for net are needed to fix the race conditions.
>=20
> In addition to use the xps_map mutex, patches 2 and 3 from v2 factorize
> the code into a single function, as xps_cpus_show and xps_rxqs_show
> share the same logic. That would improve maintainability, but isn't
> mandatory.
>=20
> Sorry, it was not very clear...

I like the cleanup, sorry I'm net very clear either.

My understanding was that patch 2 was only needed to have access to the
XPS lock, if we don't plan to use that lock netif_show_xps_queue() can
stay in the sysfs file, right? I'm all for the cleanup and code reuse
for rxqs, I'm just making sure I'm not missing anything. I wasn't
seeing a reason to move netif_show_xps_queue(), that's all.
