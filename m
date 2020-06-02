Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE961EB887
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgFBJ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgFBJ3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 05:29:40 -0400
Received: from localhost (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A0D206A4;
        Tue,  2 Jun 2020 09:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591090179;
        bh=UC3pXiH2tnw4aBuc0VA0/W9vSxetKUqH4B8YG8SO44Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M6EFIlEE8dT34ylIIb2KZfFZE/oK7lAO1whcQhd0/pfw+2h2apsgrawl3ooTauqLL
         C+LhWFr2ThZYgaAG81IQQxeXca5Ksiw1yZRkcevzh/CvBR+OTSEvb5LnARktJ/SZuy
         an1LfwuMLdrs/BVDKWXKYe5P+W7VvDMCo8UxaT8A=
Date:   Tue, 2 Jun 2020 11:29:34 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, toke@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org
Subject: Re: [PATCH bpf-next 4/6] bpf: cpumap: add the possibility to attach
 an eBPF program to cpumap
Message-ID: <20200602092934.GB11951@localhost.localdomain>
References: <cover.1590960613.git.lorenzo@kernel.org>
 <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
 <20200602095300.486ae35c@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <20200602095300.486ae35c@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, 31 May 2020 23:46:49 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index 57402276d8af..24ab0a6b9772 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -51,6 +51,10 @@ struct xdp_bulk_queue {
> >  /* CPUMAP value */
> >  struct bpf_cpumap_val {
> >  	u32 qsize;	/* queue size */
> > +	union {
> > +		int fd;	/* program file descriptor */
> > +		u32 id;	/* program id */
> > +	} prog;
> >  };
>  =20
> Please name the union 'bpf_prog' and not 'prog'.
> We should match what David Ahern did for devmap.

Hi Jesper,

ack, I will align the struct to David's one in v2.

Regards,
Lorenzo

>=20
> Even-though we are NOT exposing this in the UAPI header-file, this still
> becomes a UAPI interface (actually kABI).  The struct member names are
> still important, even-though this is a binary layout, because the BTF
> info is basically documenting this API.
>=20
> Notice when kernel is compiled with BTF info, you (or end-user) can use
> pahole to "reverse" the struct layout (comments don't survive, so we
> need descriptive member names):
>=20
> $ pahole bpf_devmap_val
> struct bpf_devmap_val {
> 	__u32                      ifindex;              /*     0     4 */
> 	union {
> 		int                fd;                   /*     4     4 */
> 		__u32              id;                   /*     4     4 */
> 	} bpf_prog;                                      /*     4     4 */
> 	struct {
> 		unsigned char      data[24];             /*     8    24 */
> 	} storage;                                       /*     8    24 */
>=20
> 	/* size: 32, cachelines: 1, members: 3 */
> 	/* last cacheline: 32 bytes */
> };
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20
>=20
> $ bpftool btf dump file /sys/kernel/btf/vmlinux format c | grep -A10 'str=
uct bpf_devmap_val {'
> struct bpf_devmap_val {
> 	__u32 ifindex;
> 	union {
> 		int fd;
> 		__u32 id;
> 	} bpf_prog;
> 	struct {
> 		unsigned char data[24];
> 	} storage;
> };
>=20

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXtYb+wAKCRA6cBh0uS2t
rMkJAQDV7YaKfjBJPS1NUPr7M9ifAME+GWHMnd1+lU4G00C9lQEAoWJKM2M32ahA
O+N7fsx00anLR/mct0XTAT26YfwjnQQ=
=63vN
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
