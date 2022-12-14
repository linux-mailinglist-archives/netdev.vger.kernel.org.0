Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846564CCCC
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiLNPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbiLNPCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:02:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B345F120B4
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649BCB818E5
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 15:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B50C433D2;
        Wed, 14 Dec 2022 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671030128;
        bh=vD+GqNFlovVM2Z212zxTX+ZolBo2v7dFpxlo2mi2IPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=alBMptzCH1w4DUcuIoxryCKTElcCtveyohbAz2G02pgR1uorf0wzaKEUPasZ1JU1G
         P4jIrDmnZxaJMPOXL2rdw8Op217cc0UuKRE5LdPgN9g0xSJef1gqrBcQh6U7phLIVi
         2NBNROnjrg3GF5GSegcj2f8vcKP2IEz420iMuoQfsMUOUsDfreVW+/kh3ljOwT77QY
         DBPRfpzcWNitfeSoWfgMgAs0xyMx2Jyd8aXK/C/PtyGUGD2RXcH9zjKMBDRbhMzhEt
         xbyXq9PXsA1KJKz9026Sc8nxksPkdnyfHSfpa2Ctj4mshAkTx7iC5k+LzETYhgG5CG
         IDrUtfS4myhLg==
Date:   Wed, 14 Dec 2022 16:02:04 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [RFT] net: ethernet: enetc: do not always access skb_shared_info
 in the XDP path
Message-ID: <Y5nlbERhXA7CYfHd@lore-desk>
References: <8acb59077ff51eb58ca164e432be63194a92b0bf.1670924659.git.lorenzo@kernel.org>
 <20221213195551.iev4u5niyzvyflyc@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UHYs918ZgPhW9smA"
Content-Disposition: inline
In-Reply-To: <20221213195551.iev4u5niyzvyflyc@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UHYs918ZgPhW9smA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,
>=20
> On Tue, Dec 13, 2022 at 10:46:43AM +0100, Lorenzo Bianconi wrote:
> > Move XDP skb_shared_info structure initialization in from
> > enetc_map_rx_buff_to_xdp() to enetc_add_rx_buff_to_xdp() and do not alw=
ays
> > access skb_shared_info in the xdp_buff/xdp_frame since it is located in=
 a
> > different cacheline with respect to hard_start and data xdp pointers.
> > Rely on XDP_FLAGS_HAS_FRAGS flag to check if it really necessary to acc=
ess
> > non-linear part of the xdp_buff/xdp_frame.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > This patch is based on the following series not applied yet to next-nex=
t:
> > https://patchwork.kernel.org/project/netdevbpf/cover/cover.1670680119.g=
it.lorenzo@kernel.org/
> > ---
> >  drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net=
/ethernet/freescale/enetc/enetc.c
> > index cd8f5f0c6b54..2ed6b163f3c8 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> > @@ -1305,6 +1305,10 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct=
 enetc_bdr *tx_ring,
> >  	xdp_tx_swbd->xdp_frame =3D NULL;
> > =20
> >  	n++;
> > +
> > +	if (!xdp_frame_has_frags(xdp_frame))
> > +		goto out;
> > +
>=20
> Tested this with single-buffer devmap XDP_REDIRECT, can't test with
> multi-buffer I think.

ack, thx for testing. I will add this patch to the prvious series.
In oreder to test it with xdp-mb I think you can redirect into a cpumap and
then attach a program on the cpumap to redirect back to the nic, but for the
moment you need to comment out this line:

https://github.com/torvalds/linux/blob/master/net/core/filter.c#L4291

Regards,
Lorenzo

>=20
> >  	xdp_tx_swbd =3D &xdp_tx_arr[n];
> > =20
> >  	shinfo =3D xdp_get_shared_info_from_frame(xdp_frame);
> > @@ -1334,7 +1338,7 @@ static int enetc_xdp_frame_to_xdp_tx_swbd(struct =
enetc_bdr *tx_ring,
> >  		n++;
> >  		xdp_tx_swbd =3D &xdp_tx_arr[n];
> >  	}
> > -
> > +out:
> >  	xdp_tx_arr[n - 1].is_eof =3D true;
> >  	xdp_tx_arr[n - 1].xdp_frame =3D xdp_frame;
> > =20
> > @@ -1390,16 +1394,12 @@ static void enetc_map_rx_buff_to_xdp(struct ene=
tc_bdr *rx_ring, int i,
> >  {
> >  	struct enetc_rx_swbd *rx_swbd =3D enetc_get_rx_buff(rx_ring, i, size);
> >  	void *hard_start =3D page_address(rx_swbd->page) + rx_swbd->page_offs=
et;
> > -	struct skb_shared_info *shinfo;
> > =20
> >  	/* To be used for XDP_TX */
> >  	rx_swbd->len =3D size;
> > =20
> >  	xdp_prepare_buff(xdp_buff, hard_start - rx_ring->buffer_offset,
> >  			 rx_ring->buffer_offset, size, false);
> > -
> > -	shinfo =3D xdp_get_shared_info_from_buff(xdp_buff);
> > -	shinfo->nr_frags =3D 0;
> >  }
> > =20
> >  static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
> > @@ -1407,7 +1407,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc=
_bdr *rx_ring, int i,
> >  {
> >  	struct skb_shared_info *shinfo =3D xdp_get_shared_info_from_buff(xdp_=
buff);
> >  	struct enetc_rx_swbd *rx_swbd =3D enetc_get_rx_buff(rx_ring, i, size);
> > -	skb_frag_t *frag =3D &shinfo->frags[shinfo->nr_frags];
> > +	skb_frag_t *frag;
> > =20
> >  	/* To be used for XDP_TX */
> >  	rx_swbd->len =3D size;
> > @@ -1415,6 +1415,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc=
_bdr *rx_ring, int i,
> >  	if (!xdp_buff_has_frags(xdp_buff)) {
> >  		xdp_buff_set_frags_flag(xdp_buff);
> >  		shinfo->xdp_frags_size =3D size;
> > +		shinfo->nr_frags =3D 0;
>=20
> Tested this and enetc_map_rx_buff_to_xdp() with single-buffer and
> multi-buffer XDP_TX.
>=20
> >  	} else {
> >  		shinfo->xdp_frags_size +=3D size;
> >  	}
> > @@ -1422,6 +1423,7 @@ static void enetc_add_rx_buff_to_xdp(struct enetc=
_bdr *rx_ring, int i,
> >  	if (page_is_pfmemalloc(rx_swbd->page))
> >  		xdp_buff_set_frag_pfmemalloc(xdp_buff);
> > =20
> > +	frag =3D &shinfo->frags[shinfo->nr_frags];
> >  	skb_frag_off_set(frag, rx_swbd->page_offset);
> >  	skb_frag_size_set(frag, size);
> >  	__skb_frag_set_page(frag, rx_swbd->page);
> > --=20
> > 2.38.1
> >
>=20
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Thanks.

--UHYs918ZgPhW9smA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY5nlbAAKCRA6cBh0uS2t
rKraAQDALP+pd1QEK2E7AL8X//Zzo55ce0Wrf96nQdp0rryb7QD/TgG/rohWxBEx
DcuAU8yU9FpHoYIUVyue77tOkJcIrQo=
=i0ni
-----END PGP SIGNATURE-----

--UHYs918ZgPhW9smA--
