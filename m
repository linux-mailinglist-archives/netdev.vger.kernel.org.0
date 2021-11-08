Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005D8449A54
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbhKHQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239237AbhKHQ6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 412BB61359;
        Mon,  8 Nov 2021 16:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636390517;
        bh=73xZNMiB0b69lbkq94dIYpFj2aFKD8oUkTayw0x68iE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rCHlWIfQ4/Tb8NJAaDH1+1VSPbBdk+81zCumc2m97l214RDr6VWt5015Afm/LAqIz
         jS78taXHZHXh0JZ7l5LVILOHBx5ABCTrMmzZ75YFCdmpEiF9XSVyGf+bD38duzP6pn
         HYmNBphViXHgF6WkxoUfEe/djhwdFgvjEGhCzpwaurLl/Wekt8DQ36xlnqgVtelGz0
         8PPO7oq1+iW6pashvrxWvYASOz42qsdeWjqkwH+pNJAmOScugHLMOxD1GPoAPnA498
         KIXDHdajbKuOlf1EclhCcZShTE/oRM27j3BeCpCXCvEJaLDaJZpQt0rLR4KfskZMM9
         9ldqQ18jOfS1A==
Date:   Mon, 8 Nov 2021 17:55:14 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <YYlWcuUwcKGYtWAR@lore-desk>
References: <cover.1636044387.git.lorenzo@kernel.org>
 <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
 <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xITWf0TXIjoVm+iW"
Content-Disposition: inline
In-Reply-To: <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xITWf0TXIjoVm+iW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu,  4 Nov 2021 18:35:32 +0100 Lorenzo Bianconi wrote:
> > This change adds support for tail growing and shrinking for XDP multi-b=
uff.
> >=20
> > When called on a multi-buffer packet with a grow request, it will always
> > work on the last fragment of the packet. So the maximum grow size is the
> > last fragments tailroom, i.e. no new buffer will be allocated.
> >=20
> > When shrinking, it will work from the last fragment, all the way down to
> > the base buffer depending on the shrinking size. It's important to ment=
ion
> > that once you shrink down the fragment(s) are freed, so you can not grow
> > again to the original size.
>=20
> > +static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	skb_frag_t *frag =3D &sinfo->frags[sinfo->nr_frags - 1];
> > +	int size, tailroom;
> > +
> > +	tailroom =3D xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(frag);
>=20
> I know I complained about this before but the assumption that we can
> use all the space up to xdp->frame_sz makes me uneasy.
>=20
> Drivers may not expect the idea that core may decide to extend the=20
> last frag.. I don't think the skb path would ever do this.
>=20
> How do you feel about any of these options:=20
>  - dropping this part for now (return an error for increase)
>  - making this an rxq flag or reading the "reserved frag size"
>    from rxq (so that drivers explicitly opt-in)
>  - adding a test that can be run on real NICs
> ?

I think this has been added to be symmetric with bpf_xdp_adjust_tail().
I do think there is a real use-case for it so far so I am fine to just
support the shrink part.

@Eelco, Jesper, Toke: any comments on it?

>=20
> > +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> > +{
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> > +	int i, n_frags_free =3D 0, len_free =3D 0, tlen_free =3D 0;
> > +
> > +	if (unlikely(offset > ((int)xdp_get_buff_len(xdp) - ETH_HLEN)))
>=20
> nit: outer parens unnecessary

ack, I will fix it.

>=20
> > +		return -EINVAL;
>=20
>=20
> > @@ -371,6 +371,7 @@ static void __xdp_return(void *data, struct xdp_mem=
_info *mem, bool napi_direct,
> >  		break;
> >  	}
> >  }
> > +EXPORT_SYMBOL_GPL(__xdp_return);
>=20
> Why the export?

ack, I will remove it

Regards,
Lorenzo

--xITWf0TXIjoVm+iW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYYlWcgAKCRA6cBh0uS2t
rMhFAP951P9Jfjubg29iOaVDzvoQwuu3XLUydvhhSDBHtmv0oAEAyOQ2gtNDqurQ
dQ3XHeg6EeFGUsan+B8+2Dt2CX1QzQ0=
=conI
-----END PGP SIGNATURE-----

--xITWf0TXIjoVm+iW--
