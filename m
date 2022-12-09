Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF46647FAF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLII6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiLII6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E61249B72
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AED8B827EF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 08:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65628C433D2;
        Fri,  9 Dec 2022 08:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670576290;
        bh=MnVn496NwzIZSw+vqXnDMokE/mpOLw7XdKtXQlLVMq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgkhVhIfQxpJH9a3oMMDQCIggN4FoR4UH8O0huHsZS3FC6fAGKMZzWXemb3EkUuQ/
         66n7oRHbP7yX6k1fGZvNQ6+gWagJzJ/A7FgWEpF6WXI6z/NdPvHRA0XmX/UfDu4GcJ
         jLB0vQ5HhnzAvGbhZGe9LKzb48NB8ljViaYzF5yqMyLTXnrSbr2YGUIzm/dtXI7qBc
         EOaHPpTxguuiQufp2QAmW6ZJNVoE+nUA7g3YMz0GFFgO1WOvsS0LmSBQvdgLHhQsM7
         M2dJpseNXaN2TEEjpu7fOEeu7X19SdTMV4yGUcf91Ib94x7Mm/569SDjCR3UsgdqL1
         IR27KHPzrUh9g==
Date:   Fri, 9 Dec 2022 09:58:06 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: ethernet: enetc: unlock XDP_REDIRECT
 for XDP non-linear buffers
Message-ID: <Y5L4niz1l9ytUsf8@lore-desk>
References: <1dc514b266e19b1e5973d038a0189ab6e4acb93a.1670544817.git.lorenzo@kernel.org>
 <20221209005821.virs3rtc2tth2lja@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BMWeOAMGbI0Pfw2D"
Content-Disposition: inline
In-Reply-To: <20221209005821.virs3rtc2tth2lja@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BMWeOAMGbI0Pfw2D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Dec 09, 2022 at 01:19:44AM +0100, Lorenzo Bianconi wrote:
> > Even if full XDP_REDIRECT is not supported yet for non-linear XDP buffe=
rs
> > since we allow redirecting just into CPUMAPs, unlock XDP_REDIRECT for
> > S/G XDP buffer and rely on XDP stack to properly take care of the
> > frames.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > Changes since v1:
> > - drop Fixes tag
> > - unlock XDP_REDIRECT
> > - populate missing XDP metadata
> >=20
> > Please note this patch is just compile tested
> > ---
>=20
> How would you like me to test this patch?

Hi Vladimir,

you can use xdp_redirect_cpu sample available in the kernel source tree.

>=20
> >  drivers/net/ethernet/freescale/enetc/enetc.c | 27 +++++++++-----------
> >  1 file changed, 12 insertions(+), 15 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net=
/ethernet/freescale/enetc/enetc.c
> > index 8671591cb750..9fd15e1e692d 100644
> > --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> > +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> > @@ -1412,6 +1412,16 @@ static void enetc_add_rx_buff_to_xdp(struct enet=
c_bdr *rx_ring, int i,
> >  	/* To be used for XDP_TX */
> >  	rx_swbd->len =3D size;
> > =20
> > +	if (!xdp_buff_has_frags(xdp_buff)) {
> > +		xdp_buff_set_frags_flag(xdp_buff);
> > +		shinfo->xdp_frags_size =3D size;
> > +	} else {
> > +		shinfo->xdp_frags_size +=3D size;
> > +	}
> > +
> > +	if (page_is_pfmemalloc(rx_swbd->page))
> > +		xdp_buff_set_frag_pfmemalloc(xdp_buff);
> > +
> >  	skb_frag_off_set(frag, rx_swbd->page_offset);
> >  	skb_frag_size_set(frag, size);
> >  	__skb_frag_set_page(frag, rx_swbd->page);
> > @@ -1601,22 +1611,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_=
bdr *rx_ring,
> >  			}
> >  			break;
> >  		case XDP_REDIRECT:
> > -			/* xdp_return_frame does not support S/G in the sense
> > -			 * that it leaks the fragments (__xdp_return should not
> > -			 * call page_frag_free only for the initial buffer).
> > -			 * Until XDP_REDIRECT gains support for S/G let's keep
> > -			 * the code structure in place, but dead. We drop the
> > -			 * S/G frames ourselves to avoid memory leaks which
> > -			 * would otherwise leave the kernel OOM.
> > -			 */
> > -			if (unlikely(cleaned_cnt - orig_cleaned_cnt !=3D 1)) {
> > -				enetc_xdp_drop(rx_ring, orig_i, i);
> > -				rx_ring->stats.xdp_redirect_sg++;
> > -				break;
> > -			}
> > -
> >  			tmp_orig_i =3D orig_i;
> > -
> >  			while (orig_i !=3D i) {
> >  				enetc_flip_rx_buff(rx_ring,
> >  						   &rx_ring->rx_swbd[orig_i]);
> > @@ -1628,6 +1623,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_b=
dr *rx_ring,
> >  				enetc_xdp_free(rx_ring, tmp_orig_i, i);
> >  			} else {
> >  				xdp_redirect_frm_cnt++;
> > +				if (xdp_buff_has_frags(&xdp_buff))
> > +					rx_ring->stats.xdp_redirect_sg++;
>=20
> Ideally we'd remove this counter altogether. Nothing interesting to see.

ok, I will get rid of it in the next version.

Regards,
Lorenzo

>=20
> >  				rx_ring->stats.xdp_redirect++;
> >  			}
> >  		}
> > --=20
> > 2.38.1
> >

--BMWeOAMGbI0Pfw2D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY5L4ngAKCRA6cBh0uS2t
rF+GAQCx2GbrgCSX7l2mHCJeNBmsM8f7NfakLH6nyFUjCFsVBQEA1f6sRhAZ5U/M
m2UV3LgKKlHer/3Eo2ypu0D+WKROCw8=
=D5MC
-----END PGP SIGNATURE-----

--BMWeOAMGbI0Pfw2D--
