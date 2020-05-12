Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7188D1CF2E0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 12:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgELKvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 06:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgELKvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 06:51:15 -0400
Received: from localhost.localdomain (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B120205ED;
        Tue, 12 May 2020 10:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589280675;
        bh=IpkhdYCbj6qfQehlR88vLxW2GWnp5Cb9Bc+yoK6NChY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CA2ddsycpgRQR4CTaG36VX0Xktc3CEu9+QDFOh3Y55nRX+W/QK//g19YI3B8x4Vav
         jjElkrwa+HmxxXJru1DEK292HC1xxwrJWr+vuD00a12LwbW7mHIx8YZWqK1YhHl0Bq
         WnNgurQI+/Rj4/llp0jPlECWvnYDfWUtx9zQgZ00=
Date:   Tue, 12 May 2020 12:51:09 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: set MAX_CPUS
 according to NR_CPUS
Message-ID: <20200512105109.GA79080@localhost.localdomain>
References: <79b8dd36280e5629a5e64b89528f9d523cb7262b.1589227441.git.lorenzo@kernel.org>
 <c3fa2001-ef77-46c4-c0de-3335e7934db9@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <c3fa2001-ef77-46c4-c0de-3335e7934db9@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 5/11/20 1:24 PM, Lorenzo Bianconi wrote:
> > xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
> > allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
> > cpu_map_alloc() requires max_entries to be less than NR_CPUS.
> > Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
> > and get currently running cpus in xdp_redirect_cpu_user.c
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   samples/bpf/xdp_redirect_cpu_kern.c |  2 +-
> >   samples/bpf/xdp_redirect_cpu_user.c | 29 ++++++++++++++++-------------
> >   2 files changed, 17 insertions(+), 14 deletions(-)
> >=20

[...]

> >   static void mark_cpus_unavailable(void)
> >   {
> > -	__u32 invalid_cpu =3D MAX_CPUS;
> > +	__u32 invalid_cpu =3D n_cpus;
> >   	int ret, i;
> > -	for (i =3D 0; i < MAX_CPUS; i++) {
> > +	for (i =3D 0; i < n_cpus; i++) {
> >   		ret =3D bpf_map_update_elem(cpus_available_map_fd, &i,
> >   					  &invalid_cpu, 0);
> >   		if (ret) {
> > @@ -688,6 +689,8 @@ int main(int argc, char **argv)
> >   	int prog_fd;
> >   	__u32 qsize;
> > +	n_cpus =3D get_nprocs();
>=20
> get_nprocs() gets the number of available cpus, not including offline cpu=
s.
> But gaps may exist in cpus, e.g., get_nprocs() returns 4, and cpus are
> 0-1,4-5. map updates will miss cpus 4-5. And in this situation,
> map_update will fail on offline cpus.
>=20
> This sample test does not need to deal with complication of
> cpu offlining, I think. Maybe we can get
> 	n_cpus =3D get_nprocs();
> 	n_cpus_conf =3D get_nprocs_conf();
> 	if (n_cpus !=3D n_cpus_conf) {
> 		/* message that some cpus are offline and not supported. */
> 		return error
> 	}
>=20

Hi Yonghong,

thanks for pointing this out. Why not just use:

n_cpus =3D get_nprocs_conf()

and let the user pick the right cpu id with 'c' option (since it is mandato=
ry)?

Regards,
Lorenzo

> > +
> >   	/* Notice: choosing he queue size is very important with the
> >   	 * ixgbe driver, because it's driver page recycling trick is
> >   	 * dependend on pages being returned quickly.  The number of
> > @@ -757,7 +760,7 @@ int main(int argc, char **argv)
> >   		case 'c':
> >   			/* Add multiple CPUs */
> >   			add_cpu =3D strtoul(optarg, NULL, 0);
> > -			if (add_cpu >=3D MAX_CPUS) {
> > +			if (add_cpu >=3D n_cpus) {
> >   				fprintf(stderr,
> >   				"--cpu nr too large for cpumap err(%d):%s\n",
> >   					errno, strerror(errno));
> >=20

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXrp/mgAKCRA6cBh0uS2t
rN/DAP90B2TeM9DB/K3hrdzFOerTyi43JdbjiNm6iIrySR5FMAEAhtDL+VIt4CNd
3IfRt6ag2dRigA8SVae39IItMa9wsAo=
=p+oK
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
