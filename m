Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2246111CD33
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 13:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfLLMcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 07:32:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:53394 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729092AbfLLMcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 07:32:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D740AC35;
        Thu, 12 Dec 2019 12:32:07 +0000 (UTC)
Message-ID: <0a3e22d627a70cb60237c811b5874b9a4413329f.camel@suse.de>
Subject: Re: [PATCH v4 7/8] linux/log2.h: Fix 64bit calculations in
 roundup/down_pow_two()
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Robin Murphy <robin.murphy@arm.com>, andrew.murray@arm.com,
        maz@kernel.org, linux-kernel@vger.kernel.org,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     james.quinlan@broadcom.com, mbrugger@suse.com,
        f.fainelli@gmail.com, phil@raspberrypi.org, wahrenst@gmx.net,
        jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.con>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, kexec@lists.infradead.org,
        linux-nfs@vger.kernel.org
Date:   Thu, 12 Dec 2019 13:31:57 +0100
In-Reply-To: <70c6b704-a12a-fb44-e93f-a6db12ed928f@arm.com>
References: <20191203114743.1294-1-nsaenzjulienne@suse.de>
         <20191203114743.1294-8-nsaenzjulienne@suse.de>
         <70c6b704-a12a-fb44-e93f-a6db12ed928f@arm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-FrLm7Huzs2OM/GGn8vDZ"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-FrLm7Huzs2OM/GGn8vDZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Robin,

On Thu, 2019-12-05 at 17:48 +0000, Robin Murphy wrote:
> On 03/12/2019 11:47 am, Nicolas Saenz Julienne wrote:
> > Some users need to make sure their rounding function accepts and return=
s
> > 64bit long variables regardless of the architecture. Sadly
> > roundup/rounddown_pow_two() takes and returns unsigned longs. It turns
> > out ilog2() already handles 32/64bit calculations properly, and being
> > the building block to the round functions we can rework them as a
> > wrapper around it.
>=20
> Neat! Although all the additional ULL casts this introduces seem=20
> somewhat unwelcome - I suppose the (1ULL << (ilog2(n))) makes it=20
> effectively always return unsigned long long now. Might it make sense to=
=20
> cast the return value to typeof(n) to avoid this slightly non-obvious=20
> behaviour (and the associated churn)?

It might alleviate some of the churn alright but I don't think a cast is re=
ally
going to make the behaviour more obvious. Say your expression is a big mess=
,
you'll have to analyze it to infer the output type, keeping in mind things =
like
integer promotion. See this example, 'params->nelem_hint' and
'params->min_size' are u16:

	diff --git a/lib/rhashtable.c b/lib/rhashtable.c
	index bdb7e4cadf05..70908678c7a8 100644
	--- a/lib/rhashtable.c
	+++ b/lib/rhashtable.c
	@@ -950,7 +950,7 @@ static size_t rounded_hashtable_size(const struct rhas=
htable_params *params)

		if (params->nelem_hint)
			retsize =3D max(roundup_pow_of_two(params->nelem_hint * 4 / 3),
	-                             (unsigned long)params->min_size);
	+                             (unsigned long long)params->min_size);
		else
			retsize =3D max(HASH_DEFAULT_SIZE,
				      (unsigned long)params->min_size);

With a cast the patch will look like this:

	diff --git a/lib/rhashtable.c b/lib/rhashtable.c
	index bdb7e4cadf05..70908678c7a8 100644
	--- a/lib/rhashtable.c
	+++ b/lib/rhashtable.c
	@@ -950,7 +950,7 @@ static size_t rounded_hashtable_size(const struct rhas=
htable_params *params)

		if (params->nelem_hint)
			retsize =3D max(roundup_pow_of_two(params->nelem_hint * 4 / 3),
	-                             (unsigned long)params->min_size);
	+                             (int)params->min_size);
		else
			retsize =3D max(HASH_DEFAULT_SIZE,
				      (unsigned long)params->min_size);

To me it's even less obvious than with a fixed ULL.

My intuition tells me to keep it as similar as the old behaviour, at the
expense of the extra churn (which is not that different from the current st=
atus
quo anyway). That said, I'll be happy to change it.

Regards,
Nicolas


--=-FrLm7Huzs2OM/GGn8vDZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3yMz0ACgkQlfZmHno8
x/50Nwf8DZv64TadvwE8CB4bWgsqMtbiu/fef5NUbUYuFUED8TIdE3BewSgcKkjR
UcmnTnVxq9m204FNfGnEcHAS2TjDnv2GvkRDGKIAoXt2ewgnMSoS5cwHJrHfHLr9
KX2ULSnGQqqtWEYGUe9h/hzd1mfC0gun3Mqafs1lQD7h2XeckKMt0iEa/WtfYGnP
8UJbPU5wHnCJwEbQHCtc+mV/kcQfh+3u5OHh3O4KQHcBo5TJVJovpZ6jBV4uBV1G
ePj2s84UCGZcXy1ZuwV2g32zpn8RgDXDWmdEgJ3hi1bTYZZzG4YQc2sTpjidvRB7
86UCrw4pWQ/M0pNf1UdlDlf+jz7Njw==
=1uX6
-----END PGP SIGNATURE-----

--=-FrLm7Huzs2OM/GGn8vDZ--

