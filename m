Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E922E07F2
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgLVJWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgLVJWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 04:22:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46ED823103;
        Tue, 22 Dec 2020 09:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608628881;
        bh=rqQmZc4J87CLNLEEe9GXaoVMtU+5grABrljy6Wl44ZU=;
        h=In-Reply-To:References:Cc:To:Subject:From:Date:From;
        b=GzEDi32EgDPs1p/j2mf5vyUX6XF2hwGactGKiTf1jO5bLX0X7NoeIo63rd7kpC3mG
         toH/HFMzanf4IFu6PuPcqwG2VVynqIe2/ZSB1ginr5QpA6pS3WRWf08FKAoYvUv3E6
         doqt0/tGWbjt9Xvyo1HDe8O5Tv4AZK1ypsf/aB02leRB7bH1+bofq9yis3GiDeT9uh
         krE4sJK3dilXYM5PQvTxRQvT8uoGGWT6eML5FMfyzkkNycaL19pvLHOg0RCHc4sKJz
         a0YEewYT1j51uUss6dXmSl6N4Ty1yO/aAxh4MTPWM3uK4e+Lcp1sc/JOgp4lD+2w2r
         mt5VweMcrx/eQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-2-atenart@kernel.org> <CAKgT0UfTgYhED1f6vdsoT72A3=D2Grh4U-A6pp43FLZoCs30Gw@mail.gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v2 1/3] net: fix race conditions in xps by locking the maps and dev->tc_num
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <160862887909.1246462.8442420561350999328@kwain.local>
Date:   Tue, 22 Dec 2020 10:21:19 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alexander, Jakub,

Quoting Alexander Duyck (2020-12-22 00:21:57)
>=20
> Looking over this patch it seems kind of obvious that extending the
> xps_map_mutex is making things far more complex then they need to be.
>=20
> Applying the rtnl_mutex would probably be much simpler. Although as I
> think you have already discovered we need to apply it to the store,
> and show for this interface. In addition we probably need to perform
> similar locking around traffic_class_show in order to prevent it from
> generating a similar error.

I don't think we have the same kind of issues with traffic_class_show:
dev->num_tc is used, but not for navigating through the map. Protecting
only a single read wouldn't change much. We can still think about what
could go wrong here without the lock, but that is not related to this
series of fixes.

If I understood correctly, as things are a bit too complex now, you
would prefer that we go for the solution proposed in v1?

I can still do the code factoring for the 2 sysfs show operations, but
that would then target net-next and would be in a different series. So I
believe we'll use the patches of v1, unmodified.

Jakub, should I send a v3 then?

Thanks!
Antoine
