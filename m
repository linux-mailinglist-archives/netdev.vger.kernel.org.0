Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C0110B68C
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfK0TQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:16:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:34596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726593AbfK0TQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 14:16:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C825BACEF;
        Wed, 27 Nov 2019 19:16:36 +0000 (UTC)
Message-ID: <c3885c2ed8bec892290c3d957c8c5012039b6759.camel@suse.de>
Subject: Re: [PATCH v3 1/7] linux/log2.h: Add roundup/rounddown_pow_two64()
 family of functions
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Robin Murphy <robin.murphy@arm.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Date:   Wed, 27 Nov 2019 20:16:27 +0100
In-Reply-To: <c08863a7-49c6-962e-e968-92adb8ee2cc9@arm.com>
References: <20191126091946.7970-1-nsaenzjulienne@suse.de>
         <20191126091946.7970-2-nsaenzjulienne@suse.de>
         <20191126125137.GA10331@unreal>
         <6e0b9079-9efd-2884-26d1-3db2d622079d@arm.com>
         <b30002d48c9d010a1ee81c16cd29beee914c3b1d.camel@suse.de>
         <c08863a7-49c6-962e-e968-92adb8ee2cc9@arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-O+wgk4AZ6l++1CDkyqmb"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-O+wgk4AZ6l++1CDkyqmb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 19:06 +0000, Robin Murphy wrote:
> On 27/11/2019 6:24 pm, Nicolas Saenz Julienne wrote:
> > On Wed, 2019-11-27 at 18:06 +0000, Robin Murphy wrote:
> > > On 26/11/2019 12:51 pm, Leon Romanovsky wrote:
> > > > On Tue, Nov 26, 2019 at 10:19:39AM +0100, Nicolas Saenz Julienne wr=
ote:
> > > > > Some users need to make sure their rounding function accepts and
> > > > > returns
> > > > > 64bit long variables regardless of the architecture. Sadly
> > > > > roundup/rounddown_pow_two() takes and returns unsigned longs. Cre=
ate a
> > > > > new generic 64bit variant of the function and cleanup rougue cust=
om
> > > > > implementations.
> > > >=20
> > > > Is it possible to create general roundup/rounddown_pow_two() which =
will
> > > > work correctly for any type of variables, instead of creating speci=
al
> > > > variant for every type?
> > >=20
> > > In fact, that is sort of the case already - roundup_pow_of_two() itse=
lf
> > > wraps ilog2() such that the constant case *is* type-independent. And
> > > since ilog2() handles non-constant values anyway, might it be reasona=
ble
> > > to just take the strongly-typed __roundup_pow_of_two() helper out of =
the
> > > loop as below?
> > >=20
> > > Robin
> > >=20
> >=20
> > That looks way better that's for sure. Some questions.
> >=20
> > > ----->8-----
> > > diff --git a/include/linux/log2.h b/include/linux/log2.h
> > > index 83a4a3ca3e8a..e825f8a6e8b5 100644
> > > --- a/include/linux/log2.h
> > > +++ b/include/linux/log2.h
> > > @@ -172,11 +172,8 @@ unsigned long __rounddown_pow_of_two(unsigned lo=
ng n)
> > >     */
> > >    #define roundup_pow_of_two(n)			\
> > >    (						\
> > > -	__builtin_constant_p(n) ? (		\
> > > -		(n =3D=3D 1) ? 1 :			\
> > > -		(1UL << (ilog2((n) - 1) + 1))	\
> > > -				   ) :		\
> > > -	__roundup_pow_of_two(n)			\
> > > +	(__builtin_constant_p(n) && (n =3D=3D 1)) ?	\
> > > +	1 : (1UL << (ilog2((n) - 1) + 1))	\
> >=20
> > Then here you'd have to use ULL instead of UL, right? I want my 64bit v=
alue
> > everywhere regardless of the CPU arch. The downside is that would affec=
t
> > performance to some extent (i.e. returning a 64bit value where you used=
 to
> > have
> > a 32bit one)?
>=20
> True, although it's possible that 1ULL might result in the same codegen=
=20
> if the compiler can see that the result is immediately truncated back to=
=20
> long anyway. Or at worst, I suppose "(typeof(n))1" could suffice,=20
> however ugly. Either way, this diff was only an illustration rather than=
=20
> a concrete proposal, but it might be an interesting diversion to=20
> investigate.
>=20
> On that note, though, you should probably be using ULL in your current=
=20
> patch too.

I actually meant to, the fix got lost. Thanks for pointing it out.

As I see Leon also likes this, I'll try out this implementation and come ba=
ck
with some results.

Regards,
Nicolas


--=-O+wgk4AZ6l++1CDkyqmb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3ey4sACgkQlfZmHno8
x/4qGggAi4+Q7jM0+bmigNE35y3GihyLXM3ahA2qmQ9ftiZshh+Z8XQUYcRi7852
LsPNmYpHjwV3LyoaBXdnHaIVR5I1rE6RXSAZEK4xRF872qqm9rKDeMGF1GXxrw3u
BJl/LR2xhGkhYepUUAiZ+vGy3FyTfl8ADH/V9AHtFtvXuFTpStBZS3/xYgaO9mRa
E0hCB01yKy14h+FAXRiEB0E6onkyAqWjLHPmAXCGmk4ZsJwAjdVr3QyVq6AUBBKt
CaBQ7gUU8NOTg8ZE9WDRdTfIlQ+1Gpiu2xk1jML8Y1eCGxB3wtXy0t5GdjOaiwzi
fzp73AN5N4UigGnR/sl3LgJQXPe3yA==
=ixwn
-----END PGP SIGNATURE-----

--=-O+wgk4AZ6l++1CDkyqmb--

