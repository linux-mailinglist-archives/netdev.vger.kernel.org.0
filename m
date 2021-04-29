Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A37036EBA3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 15:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhD2Nyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 09:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233862AbhD2Nyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 09:54:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70F42613F9;
        Thu, 29 Apr 2021 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619704447;
        bh=CN8JucJ9GuVVCMmHCNZaLNLhmnMYq7sALnPmuRA4ZWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jGYuc6aRP4DI74OgkJqomjenX3IDnKnq/2wxpi2ujDJ/Fw1wLWgYqB+EYMp21lmn1
         p1NeT2igL2Z0xjHLyMG7A6uIaoSV4Ysee29xirS7EI0chokDJcF8modwPHSTYhB6KJ
         Kfh4EyyQ6eQTUXfk73yHjG0YdIPOqBCvEVz51Ufgs4WWPlJaDWASTxS0xgOMo14ofG
         vaaJRa0+YcgGCSUNVj24wtFvoaRfSHBVxEycLE7aaki6FZrEt3wFoQl3q+S6FvqQAb
         hIDz5X5us0yr5dzTkmrj0l/TtqECgrNxCg3wRVrwHdJ6EzZ7QIWRtjC/ozjLD7g0Ls
         FbLi+hRMNPG/A==
Date:   Thu, 29 Apr 2021 15:54:02 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com
Subject: Re: [PATCH v8 bpf-next 01/14] xdp: introduce mb in xdp_buff/xdp_frame
Message-ID: <YIq6eoS+5UZRTi/5@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <eef58418ab78408f4a5fbd3d3b0071f30ece2ccd.1617885385.git.lorenzo@kernel.org>
 <20210429153629.1fef2386@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xTj/FSH9T4pSqGpm"
Content-Disposition: inline
In-Reply-To: <20210429153629.1fef2386@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xTj/FSH9T4pSqGpm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >  static __always_inline void
> > @@ -116,7 +120,8 @@ struct xdp_frame {
> >  	u16 len;
> >  	u16 headroom;
> >  	u32 metasize:8;
> > -	u32 frame_sz:24;
> > +	u32 frame_sz:23;
> > +	u32 mb:1; /* xdp non-linear frame */
> >  	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> >  	 * while mem info is valid on remote CPU.
> >  	 */
>=20
> So, it seems that these bitfield's are the root-cause of the
> performance regression.  Credit to Alexei whom wisely already point
> this out[1] in V2 ;-)
>=20
> [1] https://lore.kernel.org/netdev/20200904010705.jm6dnuyj3oq4cpjd@ast-mb=
p.dhcp.thefacebook.com/

yes, shame on me..yesterday I recalled email from Alexei debugging the issue
reported by Magnus.
In the current approach I am testing (not posted upstream yet) I reduced the
size of xdp_mem_info as proposed by Jesper in [0] and I added a flags field
in xdp_frame/xdp_buff we can use for multiple features (e.g. multi-buff or =
hw csum
hints). Doing so, running xdp_rxq_info sample on ixgbe 10Gbps NIC I do not =
have any
performance regressions for xdp_tx or xdp_drop. Same results have been repo=
rted by
Magnus off-list on i40e (we have a 1% regression on xdp_sock tests iiuc).
I will continue working on this.

Regards,
Lorenzo

[0] https://patchwork.kernel.org/project/netdevbpf/patch/20210409223801.104=
657-2-mcroce@linux.microsoft.com/

>=20
>=20
> > @@ -179,6 +184,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *fr=
ame, struct xdp_buff *xdp)
> >  	xdp->data_end =3D frame->data + frame->len;
> >  	xdp->data_meta =3D frame->data - frame->metasize;
> >  	xdp->frame_sz =3D frame->frame_sz;
> > +	xdp->mb =3D frame->mb;
> >  }
> > =20
> >  static inline
> > @@ -205,6 +211,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> >  	xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
> >  	xdp_frame->metasize =3D metasize;
> >  	xdp_frame->frame_sz =3D xdp->frame_sz;
> > +	xdp_frame->mb =3D xdp->mb;
> > =20
> >  	return 0;
> >  }
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--xTj/FSH9T4pSqGpm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYIq6dwAKCRA6cBh0uS2t
rNyoAQCqSsfP4Ibzr71tSSiwpwI1fKFcny8g4zacoVFoqGne2wEA7tVvs8e74yaO
fA3QrFcx8v8Bb8NuA4eaMqNUttjyxws=
=ttf/
-----END PGP SIGNATURE-----

--xTj/FSH9T4pSqGpm--
