Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC8D10B59D
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfK0SYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:24:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:42432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727105AbfK0SYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 13:24:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C8F7ADBF;
        Wed, 27 Nov 2019 18:24:12 +0000 (UTC)
Message-ID: <b30002d48c9d010a1ee81c16cd29beee914c3b1d.camel@suse.de>
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
Date:   Wed, 27 Nov 2019 19:24:07 +0100
In-Reply-To: <6e0b9079-9efd-2884-26d1-3db2d622079d@arm.com>
References: <20191126091946.7970-1-nsaenzjulienne@suse.de>
         <20191126091946.7970-2-nsaenzjulienne@suse.de>
         <20191126125137.GA10331@unreal>
         <6e0b9079-9efd-2884-26d1-3db2d622079d@arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-mxyStPsVH/f4qNVW2wlv"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-mxyStPsVH/f4qNVW2wlv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 18:06 +0000, Robin Murphy wrote:
> On 26/11/2019 12:51 pm, Leon Romanovsky wrote:
> > On Tue, Nov 26, 2019 at 10:19:39AM +0100, Nicolas Saenz Julienne wrote:
> > > Some users need to make sure their rounding function accepts and retu=
rns
> > > 64bit long variables regardless of the architecture. Sadly
> > > roundup/rounddown_pow_two() takes and returns unsigned longs. Create =
a
> > > new generic 64bit variant of the function and cleanup rougue custom
> > > implementations.
> >=20
> > Is it possible to create general roundup/rounddown_pow_two() which will
> > work correctly for any type of variables, instead of creating special
> > variant for every type?
>=20
> In fact, that is sort of the case already - roundup_pow_of_two() itself=
=20
> wraps ilog2() such that the constant case *is* type-independent. And=20
> since ilog2() handles non-constant values anyway, might it be reasonable=
=20
> to just take the strongly-typed __roundup_pow_of_two() helper out of the=
=20
> loop as below?
>=20
> Robin
>=20

That looks way better that's for sure. Some questions.

> ----->8-----
> diff --git a/include/linux/log2.h b/include/linux/log2.h
> index 83a4a3ca3e8a..e825f8a6e8b5 100644
> --- a/include/linux/log2.h
> +++ b/include/linux/log2.h
> @@ -172,11 +172,8 @@ unsigned long __rounddown_pow_of_two(unsigned long n=
)
>    */
>   #define roundup_pow_of_two(n)			\
>   (						\
> -	__builtin_constant_p(n) ? (		\
> -		(n =3D=3D 1) ? 1 :			\
> -		(1UL << (ilog2((n) - 1) + 1))	\
> -				   ) :		\
> -	__roundup_pow_of_two(n)			\
> +	(__builtin_constant_p(n) && (n =3D=3D 1)) ?	\
> +	1 : (1UL << (ilog2((n) - 1) + 1))	\

Then here you'd have to use ULL instead of UL, right? I want my 64bit value
everywhere regardless of the CPU arch. The downside is that would affect
performance to some extent (i.e. returning a 64bit value where you used to =
have
a 32bit one)?

Also, what about callers to this function on platforms with 32bit 'unsigned
longs' that happen to input a 64bit value into this. IIUC we'd have a chang=
e of
behaviour.

Regards,
Nicolas


--=-mxyStPsVH/f4qNVW2wlv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3ev0cACgkQlfZmHno8
x/7bZggAoQCurviCXXa381xJwqPJoSkVo+ESY4pKxZ8criUSzcK0v7Snj8tUrs+B
F6O3wS+0QIF0LcdHj48Rihbx2Ls980iATSGd+7REU4JrPWLjecMDqz9smaA8/mm+
8iO/OghEVch7cGpeDW/XLbdKCRWbWoqUCkZiyDIBeRQ5/RZs8pNSZ5k6yXpglval
Hn1RDO1O+Ux+IzX50cSagoiBUVEOHcSfxNM1t88eT90fKRo4bs/xJ+OcFByqCnzx
9RGZD2KWJiEsVOL3+HWLiB8m84UHAZGQwyMB5ZiMuh4f/hfaHo/9tBTUc1DG9Qcs
fyfOer6A4i/IvO29wvmBFubbD5Noxw==
=YNW2
-----END PGP SIGNATURE-----

--=-mxyStPsVH/f4qNVW2wlv--

