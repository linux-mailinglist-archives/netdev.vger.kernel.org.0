Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604C2213CF2
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGCPqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgGCPqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 11:46:34 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CED020870;
        Fri,  3 Jul 2020 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593791194;
        bh=Znad7IpnrnOr4RwkJUGseuqoPFFypmTvYp79cZVND1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q36+MwKYGyC0CgvhMdd1JfpeEttF9COsBkkk1n3ccEF8S8ZO1FIM3KOGHQOeEXdn7
         PHpvMkkhj08IGBaf+1KaWLcz8eBEkuKceHcW4F5fvyrEMBrFlGdGr/XkZpyFVmRPuD
         VU1mAmrzizFPaEunfg44+EhSdYxYY+2Vp7NDKNKA=
Date:   Fri, 3 Jul 2020 17:46:28 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH v5 bpf-next 5/9] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
Message-ID: <20200703154628.GA1321275@localhost.localdomain>
References: <cover.1593521029.git.lorenzo@kernel.org>
 <a6bb83a429f3b073e97f81ec3935b8ebe89fbd71.1593521030.git.lorenzo@kernel.org>
 <cb2f7b80-7c0f-4f96-6285-87cc615c7484@iogearbox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <cb2f7b80-7c0f-4f96-6285-87cc615c7484@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 6/30/20 2:49 PM, Lorenzo Bianconi wrote:
> [...]

[...]

> > +	prog =3D READ_ONCE(rcpu->prog);
>=20
> What purpose does the READ_ONCE() have here, also given you don't use it =
in above check?
> Since upon map update you realloc, repopulate and then xchg() the rcpu en=
try itself, there
> is never the case where you xchg() or WRITE_ONCE() the rcpu->prog, so wha=
t does READ_ONCE()
> serve in this context? Imho, it should probably just be deleted and plain=
 rcpu->prog used
> to avoid confusion.

Hi Daniel,

ack, I will fix it in v6

>=20
> > +	for (i =3D 0; i < n; i++) {
> > +		struct xdp_frame *xdpf =3D frames[i];
> > +		u32 act;
> > +		int err;
> > +
> > +		rxq.dev =3D xdpf->dev_rx;
> > +		rxq.mem =3D xdpf->mem;
> > +		/* TODO: report queue_index to xdp_rxq_info */
> > +
> > +		xdp_convert_frame_to_buff(xdpf, &xdp);
> > +
> > +		act =3D bpf_prog_run_xdp(prog, &xdp);
> > +		switch (act) {
> > +		case XDP_PASS:
> > +			err =3D xdp_update_frame_from_buff(&xdp, xdpf);
> > +			if (err < 0) {
> > +				xdp_return_frame(xdpf);
> > +				stats->drop++;
> > +			} else {
> > +				frames[nframes++] =3D xdpf;
> > +				stats->pass++;
> > +			}
> > +			break;
> > +		default:
> > +			bpf_warn_invalid_xdp_action(act);
> > +			/* fallthrough */
> > +		case XDP_DROP:
> > +			xdp_return_frame(xdpf);
> > +			stats->drop++;
> > +			break;
> > +		}
> > +	}
> > +
> > +	xdp_clear_return_frame_no_direct();
> > +
> > +	rcu_read_unlock();
> > +
> > +	return nframes;
> > +}
> [...]
> > +bool cpu_map_prog_allowed(struct bpf_map *map)
> > +{
> > +	return map->map_type =3D=3D BPF_MAP_TYPE_CPUMAP &&
> > +	       map->value_size !=3D offsetofend(struct bpf_cpumap_val, qsize);
> > +}
> > +
> > +static int __cpu_map_load_bpf_program(struct bpf_cpu_map_entry *rcpu, =
int fd)
> > +{
> > +	struct bpf_prog *prog;
> > +
> > +	prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, false);
>=20
> Nit: why the _dev variant; just use bpf_prog_get_type()?

ack, I will fix in v6

Regards,
Lorenzo

>=20
> > +	if (IS_ERR(prog))
> > +		return PTR_ERR(prog);
> > +
> > +	if (prog->expected_attach_type !=3D BPF_XDP_CPUMAP) {
> > +		bpf_prog_put(prog);
> > +		return -EINVAL;
> > +	}
> > +
> > +	rcpu->value.bpf_prog.id =3D prog->aux->id;
> > +	rcpu->prog =3D prog;
> > +
> > +	return 0;
> > +}
> > +

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXv9S0gAKCRA6cBh0uS2t
rBp0AQCYpXSLx/gv7UpvJjXkSe0UQ9Fo+rCcGAd+0615xSslzQEA2z50xPnnHSRz
ocaOEfktigpIZoVV5PAhkjW9oqHqCgY=
=ldE7
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
