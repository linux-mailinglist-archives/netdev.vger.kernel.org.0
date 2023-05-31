Return-Path: <netdev+bounces-6850-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E64C718694
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195DC1C20ED1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99043174CF;
	Wed, 31 May 2023 15:43:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B747914289;
	Wed, 31 May 2023 15:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB03C433D2;
	Wed, 31 May 2023 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685547825;
	bh=ESS78bXnXhVjtfsUYy6p4W39tAYJRUUHJ5splXBwcp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kB8rKYO7anvEjQHoA/ZmTHSzVYwLTIaD4++nFJYQjtbwqM509tW1SeUWH9gHwm5nR
	 gqfzUQ3Gpm3Njrig9l+Q6mDN97YDocfwUK/TCLMXgQE+IDrRoYrVNa5O9ZvSGnSlGw
	 Kve4j/HU6m9qczQaybj94YFAUF37IcSm6gJC2bmgA3ukCRYNvG4yVIgPcRmevh6jLm
	 BpIWCH6CDGqU/OYQkrskL9xWnqu60mAnYxfXloyK+5ywOrBHlfEJWhnVwjU1Fa2v+6
	 a4SHYEcEw56kCRIHmcqx1rJcHyFy+sch7AUa5EocbVsMjyC6l+cskPdSGSIqOMgBm4
	 JiXJaYC5O1JkQ==
Date: Wed, 31 May 2023 17:43:41 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Tariq Toukan <ttoukan.linux@gmail.com>,
	Daniel Borkmann <borkmann@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>, gal@nvidia.com,
	netdev@vger.kernel.org, echaudro@redhat.com,
	andrew.gospodarek@broadcom.com
Subject: Re: [PATCH bpf-next] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
Message-ID: <ZHdrLSDC7UfLKKfp@lore-desk>
References: <168554475365.3262482.9868965521545045945.stgit@firesoul>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vDYsJJfcttrwy4LX"
Content-Disposition: inline
In-Reply-To: <168554475365.3262482.9868965521545045945.stgit@firesoul>


--vDYsJJfcttrwy4LX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Currently we observed a significant performance degradation in
> samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
> added in commit 772251742262 ("samples/bpf: fixup some tools to be able
> to support xdp multibuffer").
>=20
> This patch reduce the overhead by avoiding to read/load shared_info
> (sinfo) memory area, when XDP packet don't have any frags. This improves
> performance because sinfo is located in another cacheline.
>=20
> Function bpf_xdp_pointer() is used by BPF helpers bpf_xdp_load_bytes()
> and bpf_xdp_store_bytes(). As a help to reviewers, xdp_get_buff_len() can
> potentially access sinfo.
>=20
> Perf report show bpf_xdp_pointer() percentage utilization being reduced
> from 4,19% to 3,37% (on CPU E5-1650 @3.60GHz).
>=20
> The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
> should also take effect for that.
>=20
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/filter.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 968139f4a1ac..a635f537d499 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3948,20 +3948,24 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsig=
ned long off,
> =20
>  void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
>  {
> -	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
>  	u32 size =3D xdp->data_end - xdp->data;
> +	struct skb_shared_info *sinfo;
>  	void *addr =3D xdp->data;
>  	int i;
> =20
>  	if (unlikely(offset > 0xffff || len > 0xffff))
>  		return ERR_PTR(-EFAULT);
> =20
> -	if (offset + len > xdp_get_buff_len(xdp))
> -		return ERR_PTR(-EINVAL);
> +	if (likely((offset < size))) /* linear area */
> +		goto out;

Hi Jesper,

please correct me if I am wrong but looking at the code, in this way
bpf_xdp_pointer() will return NULL (and not ERR_PTR(-EINVAL)) if:
- offset < size
- offset + len > xdp_get_buff_len()

doing so I would say bpf_xdp_copy_buf() will copy the full packet starting =
=66rom
offset leaving some part of the auxiliary buffer possible uninitialized.
Do you think it is an issue?

Regards,
Lorenzo

> =20
> -	if (offset < size) /* linear area */
> +	if (likely(!xdp_buff_has_frags(xdp)))
>  		goto out;
> =20
> +	if (offset + len > xdp_get_buff_len(xdp))
> +		return ERR_PTR(-EINVAL);
> +
> +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>  	offset -=3D size;
>  	for (i =3D 0; i < sinfo->nr_frags; i++) { /* paged area */
>  		u32 frag_size =3D skb_frag_size(&sinfo->frags[i]);
>=20
>=20

--vDYsJJfcttrwy4LX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZHdrLQAKCRA6cBh0uS2t
rJyeAQDbw9DItb89PwRH7tQ18ohtXQmCryTtwWLF0pcPBjTc+AEA497f4P0xfiHk
cQNJhpnCwV4kdArXmzgYItAXdom+bAw=
=Wlur
-----END PGP SIGNATURE-----

--vDYsJJfcttrwy4LX--

