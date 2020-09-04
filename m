Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5818C25D2B0
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgIDHui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgIDHug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 03:50:36 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D8D206A5;
        Fri,  4 Sep 2020 07:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599205836;
        bh=XluIqMQIyB2TewpkkEABII1rp2IWDA6ok08LzrjnmTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r32MLR+/hHHQHZFC/MHLahXZi/4/jef4em4qvuaSL2Zr8gC8DCp2zicWo6fGtN3JI
         z+XspnOFgftyM3yxeidfxn2C1bntySgw+02e79zpUucHmI9WXGRIrGaErUd8OrbIHa
         Tbbpn8V8ME5nUQBfWkzM/VAYEkrkCZwBQLRnYApM=
Date:   Fri, 4 Sep 2020 09:50:31 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 6/9] bpf: helpers: add
 bpf_xdp_adjust_mb_header helper
Message-ID: <20200904075031.GC2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <b7475687bb09aac6ec051596a8ccbb311a54cb8a.1599165031.git.lorenzo@kernel.org>
 <20200904011358.kbdxf4awugi3qwjl@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <20200904011358.kbdxf4awugi3qwjl@ast-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Sep 03, 2020 at 10:58:50PM +0200, Lorenzo Bianconi wrote:
> > +BPF_CALL_2(bpf_xdp_adjust_mb_header, struct  xdp_buff *, xdp,
> > +	   int, offset)
> > +{
> > +	void *data_hard_end, *data_end;
> > +	struct skb_shared_info *sinfo;
> > +	int frag_offset, frag_len;
> > +	u8 *addr;
> > +
> > +	if (!xdp->mb)
> > +		return -EOPNOTSUPP;
> > +
> > +	sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +
> > +	frag_len =3D skb_frag_size(&sinfo->frags[0]);
> > +	if (offset > frag_len)
> > +		return -EINVAL;
> > +
> > +	frag_offset =3D skb_frag_off(&sinfo->frags[0]);
> > +	data_end =3D xdp->data_end + offset;
> > +
> > +	if (offset < 0 && (-offset > frag_offset ||
> > +			   data_end < xdp->data + ETH_HLEN))
> > +		return -EINVAL;
> > +
> > +	data_hard_end =3D xdp_data_hard_end(xdp); /* use xdp->frame_sz */
> > +	if (data_end > data_hard_end)
> > +		return -EINVAL;
> > +
> > +	addr =3D page_address(skb_frag_page(&sinfo->frags[0])) + frag_offset;
> > +	if (offset > 0) {
> > +		memcpy(xdp->data_end, addr, offset);
> > +	} else {
> > +		memcpy(addr + offset, xdp->data_end + offset, -offset);
> > +		memset(xdp->data_end + offset, 0, -offset);
> > +	}
> > +
> > +	skb_frag_size_sub(&sinfo->frags[0], offset);
> > +	skb_frag_off_add(&sinfo->frags[0], offset);
> > +	xdp->data_end =3D data_end;
> > +
> > +	return 0;
> > +}
>=20
> wait a sec. Are you saying that multi buffer XDP actually should be skb b=
ased?
> If that's what mvneta driver is doing that's fine, but that is not a
> reasonable requirement to put on all other drivers.

I did not got what you mean here. The xdp multi-buffer layout uses the skb_=
shared_info
at the end of the first buffer to link subsequent frames [0] and we rely on=
 skb_frag*
utilities to set/read offset and length of subsequent buffers.

Regards,
Lorenzo

[0] http://people.redhat.com/lbiancon/conference/NetDevConf2020-0x14/add-xd=
p-on-driver.html - XDP multi-buffers section

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1HxxAAKCRA6cBh0uS2t
rIpLAQDiTAjUYrTjOy6gd11Cqrv92+f37rJBH4Zy0RrMW2MRZwD/QcGydur0orez
RXS5z9YdKpQ1gjxSVb05cRVDz25IEAM=
=1ds7
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
