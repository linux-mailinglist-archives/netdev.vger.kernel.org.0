Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7310440FAC8
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhIQOwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:52:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238266AbhIQOwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 10:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C77C60FED;
        Fri, 17 Sep 2021 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631890271;
        bh=w2FcaLZBhWjv4VzM7AXLSn21yNm1APIXPTRFoygpwvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcGisOuGH71sY5ZPHJgCIWJ8+iDhKARmTQUE+Z01ofy3DeqEFZdurr5BuN/khpufJ
         ZbgkoRBhqTlkda333rLGEtPxk+EF2k+4qDKdPyUlzCPFbkkOolZYfSUAS+RLC+XtmX
         RqunVSrbCl+fAU8O6CznrfXTbevGl3fS+2KIKw262hMNXgg64x5Y4dpN1/TPovul8f
         E5JAobJfTfb7ga6vyibbqh9dmIGz5MQaHAg09Dxdwge+zW50rmv80jMio/b0iW9QRw
         huCRGU8absykC7DG2fhMSTtJ5s/zbKMREA25y12f4fOUfL+VDtfOEWGU2JBS46YMAo
         hILmFTgq1MyzA==
Date:   Fri, 17 Sep 2021 16:51:06 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YUSrWiWh57Ys7UdB@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9zAs7T1175FknEoo"
Content-Disposition: inline
In-Reply-To: <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9zAs7T1175FknEoo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 10 Sep 2021 18:14:06 +0200 Lorenzo Bianconi wrote:
> > The two following ebpf helpers (and related selftests) has been introdu=
ced:
> > - bpf_xdp_adjust_data:
> >   Move xdp_md->data and xdp_md->data_end pointers in subsequent fragmen=
ts
> >   according to the offset provided by the ebpf program. This helper can=
 be
> >   used to read/write values in frame payload.
> > - bpf_xdp_get_buff_len:
> >   Return the total frame size (linear + paged parts)
>=20
> > More info about the main idea behind this approach can be found here [1=
][2].
>=20
> Is there much critique of the skb helpers we have? My intuition would
> be to follow a similar paradigm from the API perspective. It may seem
> trivial to us to switch between the two but "normal" users could easily
> be confused.
>=20
> By skb paradigm I mean skb_pull_data() and bpf_skb_load/store_bytes().
>=20
> Alternatively how about we produce a variation on skb_header_pointer()
> (use on-stack buffer or direct access if the entire region is in one
> frag).
>=20
> bpf_xdp_adjust_data() seems to add cost to helpers and TBH I'm not sure
> how practical it would be to applications. My understanding is that the
> application is not supposed to make assumptions about the fragment
> geometry, meaning data can be split at any point. Parsing data
> arbitrarily split into buffers is hard if pull() is not an option, let
> alone making such parsing provably correct.
>=20
> Won't applications end up building something like skb_header_pointer()
> based on bpf_xdp_adjust_data(), anyway? In which case why don't we
> provide them what they need?

Please correct me if I am wrong, here you mean in bpf_xdp_adjust_data()
we are moving the logic to read/write data across fragment boundaries
to the caller. Right.
I do not have a clear view about what could be a real use-case for the help=
er
(maybe John can help on this), but similar to what you are suggesting, what
about doing something like bpf_skb_load/store_bytes()?

- bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, u32 len,
		     void *data)

- bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, u32 len,
		      void *data)

the helper can take care of reading/writing across fragment boundaries
and remove any layout info from the caller. The only downside here
(as for bpf_skb_load/store_bytes()) is we need to copy. But in a
real application, is it actually an issue? (since we have much less
pps for xdp multi-buff).
Moreover I do not know if this solution will requires some verifier
changes.

@John: can this approach works in your use-case?

Anyway I think we should try to get everyone on the same page here since the
helper can change according to specific use-case. Since this series is on t=
he
agenda for LPC next week, I hope you and others who have an opinion about t=
his
will find the time to come and discuss it during the conference :)

Regards,
Lorenzo
>=20
> say:=20
>=20
> void *xdp_mb_pointer(struct xdp_buff *xdp_md, u32 flags,=20
>                      u32 offset, u32 len, void *stack_buf)
>=20
> flags and offset can be squashed into one u64 as needed. Helper returns
> pointer to packet data, either real one or stack_buf. Verifier has to
> be taught that the return value is NULL or a pointer which is safe with
> offsets up to @len.
>=20
> If the reason for access is write we'd also need:
>=20
> void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags,=20
>                            u32 offset, u32 len, void *stack_buf)
>=20
> Same inputs, if stack buffer was used it does write back, otherwise nop.
>=20
> Sorry for the longish email if I'm missing something obvious and/or
> discussed earlier.
>=20
>=20
> The other thing I wanted to double check - was the decision on program
> compatibility made? Is a new program type an option? It'd be extremely
> useful operationally to be able to depend on kernel enforcement.

--9zAs7T1175FknEoo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYUSrVwAKCRA6cBh0uS2t
rF61AQDmLDR/YEhJelyYt5ru1sfHdYDFeMrAQg0pUkMfQre4cgD9HrfchWKfueHb
L9Kfn64WQALh9pnAThjpNblMNpJbNwg=
=qpc4
-----END PGP SIGNATURE-----

--9zAs7T1175FknEoo--
