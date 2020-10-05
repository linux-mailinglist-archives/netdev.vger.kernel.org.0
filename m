Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB5C284277
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 00:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgJEWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 18:25:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgJEWZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 18:25:52 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A569F2076E;
        Mon,  5 Oct 2020 22:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601936751;
        bh=xuF7KDkVMm7Tl30WZFYZAz39xWsAxyjtzrh1vSdyaQU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ArooJQte9Q5g4SHodvVdpePkjXQ4e6ugVRYDy4jHVlpgxL4kGwxj84VKO2Sta1XQp
         oXy1TbxHpxgGSjeNlRMungUbDaNf7m4ac8wBLMv6UqP30xqMtIWiuhMGTgAAFMMtVJ
         ynqalo8M8MPrMeZfmdY2ou4OzLB7hV3KMAP299cg=
Date:   Tue, 6 Oct 2020 00:24:54 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, sameehj@amazon.com, dsahern@kernel.org,
        echaudro@redhat.com
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201005222454.GB3501@localhost.localdomain>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
 <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
 <20201005115247.72429157@carbon>
 <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

>=20
> In general I see no reason to populate these fields before the XDP
> program runs. Someone needs to convince me why having frags info before
> program runs is useful. In general headers should be preserved and first
> frag already included in the data pointers. If users start parsing further
> they might need it, but this series doesn't provide a way to do that
> so IMO without those helpers its a bit difficult to debate.

We need to populate the skb_shared_info before running the xdp program in o=
rder to
allow the ebpf sanbox to access this data. If we restrict the access to the=
 first
buffer only I guess we can avoid to do that but I think there is a value al=
lowing
the xdp program to access this data.
A possible optimization can be access the shared_info only once before runn=
ing
the ebpf program constructing the shared_info using a struct allocated on t=
he
stack.
Moreover we can define a "xdp_shared_info" struct to alias the skb_shared_i=
nfo
one in order to have most on frags elements in the first "shared_info" cach=
e line.

>=20
> Specifically for XDP_TX case we can just flip the descriptors from RX
> ring to TX ring and keep moving along. This is going to be ideal on
> 40/100Gbps nics.
>=20
> I'm not arguing that its likely possible to put some prefetch logic
> in there and keep the pipe full, but I would need to see that on
> a 100gbps nic to be convinced the details here are going to work. Or
> at minimum a 40gbps nic.
>=20
> >=20
> >=20

[...]

> Not against it, but these things are a bit tricky. Couple things I still
> want to see/understand
>=20
>  - Lets see a 40gbps use a prefetch and verify it works in practice
>  - Explain why we can't just do this after XDP program runs

how can we allow the ebpf program to access paged data if we do not do that?

>  - How will we read data in the frag list if we need to parse headers
>    inside the frags[].
>=20
> The above would be best to answer now rather than later IMO.
>=20
> Thanks,
> John

Regards,
Lorenzo

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3udNAAKCRA6cBh0uS2t
rNMlAP9TbHfDmUkp+EEiIpqyabNH/7HNTb+QO0gsYq8ksfHA/AD9G0TaWWeqS14C
u5Hdk9qBy4YdXBx19SSTno2LxLgZvA8=
=Nufs
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
