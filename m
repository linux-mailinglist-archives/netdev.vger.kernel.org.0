Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72D025ED60
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 10:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgIFInu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 04:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgIFInu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 04:43:50 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AB82098B;
        Sun,  6 Sep 2020 08:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599381828;
        bh=foUHQzkuDrcRzdS9l9cNLPLIBxNFJXUO5ZAjBIQE9rM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r9Iph8MuB2DVevRLfzS142nIwqCcKzzlFffQnVIvpP1FFj8LSim7Jrq2RtCTVDyFx
         3iDRV4MhZt5uB3QXdXD2u7IFY9Q1RigirIw2bDLeuEXqGZDKbcbtz+I/K10Sgn+vat
         4V5Lol8Ms/gjuWwDtebP3SIyjBNwEzqiB8Ra44Ds=
Date:   Sun, 6 Sep 2020 10:43:43 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org
Subject: Re: [PATCH v2 net-next 5/9] net: mvneta: add multi buffer support to
 XDP_TX
Message-ID: <20200906084343.GA2785@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <2a5b39dd780f9d3ef7ff060699beca57413c3761.1599165031.git.lorenzo@kernel.org>
 <pj41zl1rjfqslp.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <pj41zl1rjfqslp.fsf@u68c7b5b1d2d758.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20

[...]

> > -	buf->xdpf =3D xdpf;
> > -	tx_desc->command =3D MVNETA_TXD_FLZ_DESC;
> > -	tx_desc->buf_phys_addr =3D dma_addr;
> > -	tx_desc->data_size =3D xdpf->len;
> > +	/*last descriptor */
> > +	if (tx_desc)
> > +		tx_desc->command |=3D MVNETA_TXD_L_DESC | MVNETA_TXD_Z_PAD;
>=20
>        When is this condition not taken ? You initialize tx_desc        to
> NULL, but it seems to me like you always set it inside        the for loop
> to the output of mvneta_txq_next_desc_get()        which doesn't look like
> it returns NULL. The for loop runs 1 iteration or `sinfo->nr_frage + 1`
> iterations (which also equals or larger than 1).

ack, right. I will fix it in v3.

Regards,
Lorenzo

>=20
> > -	mvneta_txq_inc_put(txq);
> > -	txq->pending++;
> > -	txq->count++;
> > +	txq->pending +=3D num_frames;
> > +	txq->count +=3D num_frames;
> >  	return MVNETA_XDP_TX;
> >  }
>=20

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1ShPAAKCRA6cBh0uS2t
rAH/AP9mp1Mg9Hwuuubg/HtIDSmayf9twnSrSr1lwNrCCMyTIQEAnE+OnGNEK2pz
5LLDpUGqSTDt1ZEc6Y+jXxqSR/nylQg=
=Syby
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
