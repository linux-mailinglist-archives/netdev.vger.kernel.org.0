Return-Path: <netdev+bounces-7237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44AE771F3EA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99A2A280DCA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD7823D47;
	Thu,  1 Jun 2023 20:34:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B817522626;
	Thu,  1 Jun 2023 20:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75ACC433EF;
	Thu,  1 Jun 2023 20:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685651668;
	bh=Mnnfz2r5Op38QMz6j9BxF0kYJuTDHNDQS2cvTMeM8ZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SaiRvpRrD2e2BZXpZ4Ba6fhoQ4cUyMRQyWi9Hc9TY7GqD5VItwXQLcpSpo1JAIkes
	 IVU8dv+jvqz65e0nyC9112DkB5Nrz8oWGvmvccoXiULk+SuK8d1r1wF6iwPfBEGOY6
	 k1hZCAwlDE8UIBeWGoPXLOUZgALL9gGG8DClML1EU2LM0c33KI1f3J99K/JLyoVdS3
	 dGZN84mP27GqktBr9qZI++OgKg4W7B9Nd0w0cBnVH7vYyxeegEs2uxR+BoTanDNqgG
	 QJ5gQC4nAsVJ0eUg6FTCqpx+hZ7T/UA8srVq9Ua3LtgXSHepDTTCOvIzfFcsmspbCj
	 T7ZiHFSoPUD3w==
Date: Thu, 1 Jun 2023 22:34:24 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Tariq Toukan <ttoukan.linux@gmail.com>,
	Daniel Borkmann <borkmann@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>, gal@nvidia.com,
	netdev@vger.kernel.org, echaudro@redhat.com,
	andrew.gospodarek@broadcom.com
Subject: Re: [PATCH bpf-next V2] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
Message-ID: <ZHkA0JhRYD7WXSp+@lore-desk>
References: <168563651438.3436004.17735707525651776648.stgit@firesoul>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uRBYIfcwr8jGNzzW"
Content-Disposition: inline
In-Reply-To: <168563651438.3436004.17735707525651776648.stgit@firesoul>


--uRBYIfcwr8jGNzzW
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
> potentially access sinfo, but it uses xdp_buff_has_frags() flags bit check
> to avoid accessing sinfo in no-frags case.
>=20
> The likely/unlikely instrumentation lays out asm code such that sinfo
> access isn't interleaved with no-frags case (checked on GCC 12.2.1-4).
> The generated asm code is more compact towards the no-frags case.
>=20
> The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
> should also take effect for that.
>=20
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/filter.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 968139f4a1ac..961db5bd2f94 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3948,20 +3948,21 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, unsig=
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
> +	if (unlikely(offset + len > xdp_get_buff_len(xdp)))
>  		return ERR_PTR(-EINVAL);
> =20
> -	if (offset < size) /* linear area */
> +	if (likely((offset < size))) /* linear area */

nit: you can drop a round bracket here. Other than that:

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

>  		goto out;
> =20
> +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
>  	offset -=3D size;
>  	for (i =3D 0; i < sinfo->nr_frags; i++) { /* paged area */
>  		u32 frag_size =3D skb_frag_size(&sinfo->frags[i]);
>=20
>=20

--uRBYIfcwr8jGNzzW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZHkA0AAKCRA6cBh0uS2t
rLHzAQDSrz39Fq0T2XrlgwXdHozeOqrVFWB0wXGYb9ywITc42wEA+llRVStBRgQi
3DdZ+W8/qmqU+8fmYu/1HwegeBreEgk=
=SNO5
-----END PGP SIGNATURE-----

--uRBYIfcwr8jGNzzW--

