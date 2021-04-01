Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19C6A351C24
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhDASNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:13:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:41126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237309AbhDASIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 14:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5056461382;
        Thu,  1 Apr 2021 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617295763;
        bh=P4Wu31cgAjtO3VpXOXOPtwyrVVPoSyC14LnSgQ2dWZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i6bIr+ziyrP9UxI9zBf5DM13zFr3vCSC7fFMVEG9+rgyOyrXeCwNuoAPXcuff8t8z
         hbJiocxOSndKA0IUM4dkpuzDvTA8mX4p2ehCisAoSS/eAGlqhaZa1pWSABGC1fHvSs
         eGxlW1zQv6vXGHcOHTJLoi1E04EUcfTZ4y4dtPljax5gzAuGq5BHeZ+V19oGqDxBjh
         npiPKNpT9qCPv+sHfqhvOQoV1j1L369Ca8DeesrLvPc4pnD06A3FnanKojfRntStyw
         4VmcghTK2gyVbpnhwlcZxjAzUzHFEmstwKP1qBoX2LzMLPrGCKK6DmYH+VxIYugFmW
         xHLipmqPqwY/Q==
Date:   Thu, 1 Apr 2021 18:49:19 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <YGX5j7RDQIXlh69L@lore-desk>
References: <e01b1a562c523f64049fa45da6c031b0749ca412.1617267115.git.lorenzo@kernel.org>
 <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fwaRRj5zPkdm8YeH"
Content-Disposition: inline
In-Reply-To: <CAPhsuW4QTOgC+fDYRZnVwWtt3NTS9D+56mpP04Kh3tHrkD7G1A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fwaRRj5zPkdm8YeH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Apr 1, 2021 at 1:57 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >

[...]

> > -                       /* Inject into network stack */
> > -                       ret =3D netif_receive_skb_core(skb);
> > -                       if (ret =3D=3D NET_RX_DROP)
> > -                               drops++;
>=20
> I guess we stop tracking "drops" with this patch?
>=20
> Thanks,
> Song

Hi Song,

we do not report the packets dropped by the stack but we still count the dr=
ops
in the cpumap. If you think they are really important I guess we can change
return value of netif_receive_skb_list returning the dropped packets or
similar. What do you think?

Regards,
Lorenzo

>=20
> > +                       list_add_tail(&skb->list, &list);
> >                 }
> > +               netif_receive_skb_list(&list);
> > +
> >                 /* Feedback loop via tracepoint */
> >                 trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched,=
 &stats);
> >
> > --
> > 2.30.2
> >

--fwaRRj5zPkdm8YeH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYGX5jAAKCRA6cBh0uS2t
rHmIAQCUC8XmyYRkhjiBloWbAl9ZeUzp2vO73h1covAR/ZA4RwEAqHPO5mGL7CHb
1B8W5Zbh8cT9dS60Bgb+opcGc6+EvQg=
=ynkg
-----END PGP SIGNATURE-----

--fwaRRj5zPkdm8YeH--
