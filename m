Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B564480AD
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbhKHOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 09:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238244AbhKHOCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 09:02:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6DC610F8;
        Mon,  8 Nov 2021 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636380003;
        bh=WfHvSuevDQfhnqE3cvocrDk8cqA+XSzcSW5Zrajjtqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLG2YcEG4ryVfHg+uwnTd8R7Fx9xeMRgpHvPbCijvrO5FCUron35DbP0KY8BYxEJN
         8D7tmiln8pVQ38qRtdFujasv2jTiONDm69+CKiHnVN9aeAjazr/ZGqk9aiROruiD1j
         L5Ex/KAqZ1hEcytSgRgmggYoh0pwbpiIBLm5FgsbY32LgA4Z5rYHCsCOxQnLki5NTC
         Vd7Jd+3wOX53UI7uH7IQdGZGU/R8FXMt4mpZH5qMDto2icPcgozarPhOg3gkp3WvV2
         7VjUPpHJ8EKK1ryfSiSYQudBP+Xi8d6Q+M2uq+p1e7l1LUqKGqUZ9MWDM3LxZYdKCL
         wvFJivKHZjklg==
Date:   Mon, 8 Nov 2021 14:59:59 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 13/23] bpf: add multi-buffer support to xdp
 copy helpers
Message-ID: <YYktX7swvejoYdnN@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <637cb9a21958e1a5026faba6255debf21d229d1d.1636044387.git.lorenzo@kernel.org>
 <20211105162933.113ce3c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rm7KPlRnDUjf1PVS"
Content-Disposition: inline
In-Reply-To: <20211105162933.113ce3c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rm7KPlRnDUjf1PVS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  4 Nov 2021 18:35:33 +0100 Lorenzo Bianconi wrote:
> > -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
> > +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
> >  				  unsigned long off, unsigned long len)
> >  {
> > -	memcpy(dst_buff, src_buff + off, len);
> > +	unsigned long base_len, copy_len, frag_off_total;
> > +	struct xdp_buff *xdp =3D (struct xdp_buff *)ctx;
> > +	struct skb_shared_info *sinfo;
> > +	int i;
> > +
> > +	if (likely(!xdp_buff_is_mb(xdp))) {
>=20
> Would it be better to do
>=20
> 	if (xdp->data_end - xdp->data >=3D off + len)
>=20
> ?

Hi Jakub,

I am fine with the patch (just a typo inline), thx :)
I will let Eelco to comment since he wrote the original code.
If there is no objections, I will integrate it in v18.

Regards,
Lorenzo

>=20
> > +		memcpy(dst_buff, xdp->data + off, len);
> > +		return 0;
> > +	}
> > +
> > +	base_len =3D xdp->data_end - xdp->data;
> > +	frag_off_total =3D base_len;
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +
> > +	/* If we need to copy data from the base buffer do it */
> > +	if (off < base_len) {
> > +		copy_len =3D min(len, base_len - off);
> > +		memcpy(dst_buff, xdp->data + off, copy_len);
> > +
> > +		off +=3D copy_len;
> > +		len -=3D copy_len;
> > +		dst_buff +=3D copy_len;
> > +	}
> > +
> > +	/* Copy any remaining data from the fragments */
> > +	for (i =3D 0; len && i < sinfo->nr_frags; i++) {
> > +		skb_frag_t *frag =3D &sinfo->frags[i];
> > +		unsigned long frag_len, frag_off;
> > +
> > +		frag_len =3D skb_frag_size(frag);
> > +		frag_off =3D off - frag_off_total;
> > +		if (frag_off < frag_len) {
> > +			copy_len =3D min(len, frag_len - frag_off);
> > +			memcpy(dst_buff,
> > +			       skb_frag_address(frag) + frag_off, copy_len);
> > +
> > +			off +=3D copy_len;
> > +			len -=3D copy_len;
> > +			dst_buff +=3D copy_len;
> > +		}
> > +		frag_off_total +=3D frag_len;
> > +	}
> > +
>=20
> nit: can't help but feel that you can merge base copy and frag copy:
>=20
> 	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> 	next_frag =3D &sinfo->frags[0];
> 	end_frag =3D &sinfo->frags[sinfo->nr_frags];
>=20
> 	ptr_off =3D 0;
> 	ptr_buf =3D xdp->data;
> 	ptr_len =3D xdp->data_end - xdp->data;
>=20
> 	while (true) {
> 		if (off < ptr_off + ptr_len) {
> 			copy_off =3D ptr_off - off;

I guess here should be:
			copy_off =3D off - ptr_off;

> 			copy_len =3D min(len, ptr_len - copy_off);
> 			memcpy(dst_buff, ptr_buf + copy_off, copy_len);
>=20
> 			off +=3D copy_len;
> 			len -=3D copy_len;
> 			dst_buff +=3D copy_len;
> 		}
>=20
> 		if (!len || next_frag =3D=3D end_frag)
> 			break;
> =09
> 		ptr_off +=3D ptr_len;
> 		ptr_buf =3D skb_frag_address(next_frag);
> 		ptr_len =3D skb_frag_size(next_frag);
> 		next_frag++;
> 	}
>=20
> Up to you.

--rm7KPlRnDUjf1PVS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYktXwAKCRA6cBh0uS2t
rPHlAQDOzNg9hQkQB8ZgqMlCa3Jmw2BYgUdqX5fVI0A7zDB6vAD/cGGDdVGkpWAd
Om6WTI6PNRuyelb6MqCJ/8zNgc2MJwg=
=kbpx
-----END PGP SIGNATURE-----

--rm7KPlRnDUjf1PVS--
