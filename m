Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D775572097
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiGLQRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiGLQRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:17:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD8ACA6CD
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:17:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB72618BB
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 16:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9EDC3411C;
        Tue, 12 Jul 2022 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657642641;
        bh=oqq/WdmBuEl1Rl5+R67LlYTwmvLQF2s3XfxauN4nrEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lwn2ERXUVRN4Q5jp43UlZbbjS87iSNU7WuMREr/vsCC768pnkTs1d8ZoXhGArd7z3
         Rc+e8ks7WpaMLmhp+vecb0z5LkbS9Q3YAj26EDf/yNM8TWVASIn4q4tkx6GB1E1+bx
         +MGU4DyYvVNpTxLsGo48QVExjAXBjRpHKSe12+jA0sje89BmxciP3yDSLz1hJVPEyH
         mu8/AOF32snEDr9WvD2m+vEh3iuXPSzSeMrzBRRz5zUX/oxr5PZ/jKrNlsibCpyYyT
         Oe35P9XvMvrv9gYFh3FGizTwAV/yoamXaNJgKlB/j+8Sq/W7830x9EUKHtfJClatjv
         7JiEOwHMAT5oQ==
Date:   Tue, 12 Jul 2022 18:17:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        jbrouer@redhat.com
Subject: Re: [PATCH net-next 3/4] net: ethernet: mtk_eth_soc: introduce xdp
 ethtool counters
Message-ID: <Ys2ejYSuUN8QnlIr@lore-desk>
References: <cover.1657381056.git.lorenzo@kernel.org>
 <6a522ca5588fde75f42d4d812e8990eca6d8952d.1657381057.git.lorenzo@kernel.org>
 <2112728b3e53609c46d6403bffd563d62846a1d6.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NNuiGEB2UBQpZqTi"
Content-Disposition: inline
In-Reply-To: <2112728b3e53609c46d6403bffd563d62846a1d6.camel@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NNuiGEB2UBQpZqTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
>=20
> This is allocating on the stack and clearing a relatively large struct
> for every poll() call, which is not good.
>=20
> Why can't you touch directly the eth->mac[i]->hw_stats.xdp_stats
> counters where needed?

I am currently relying on xdp_stats to flush xdp maps but I can rework a bit
the code to remove this dependency. I will fix it in v2.

Regards,
Lorenzo

>=20
> >  	struct bpf_prog *prog =3D READ_ONCE(eth->prog);
> >  	struct dim_sample dim_sample =3D {};
> >  	struct mtk_rx_ring *ring;
> > @@ -1535,7 +1574,6 @@ static int mtk_poll_rx(struct napi_struct *napi, =
int budget,
> >  	struct sk_buff *skb;
> >  	u8 *data, *new_data;
> >  	struct mtk_rx_dma_v2 *rxd, trxd;
> > -	bool xdp_do_redirect =3D false;
> >  	int done =3D 0, bytes =3D 0;
> > =20
> >  	while (done < budget) {
> > @@ -1597,12 +1635,10 @@ static int mtk_poll_rx(struct napi_struct *napi=
, int budget,
> >  					 false);
> >  			xdp_buff_clear_frags_flag(&xdp);
> > =20
> > -			ret =3D mtk_xdp_run(ring, prog, &xdp, netdev);
> > -			if (ret !=3D XDP_PASS) {
> > -				if (ret =3D=3D XDP_REDIRECT)
> > -					xdp_do_redirect =3D true;
> > +			ret =3D mtk_xdp_run(ring, prog, &xdp, netdev,
> > +					  &xdp_stats[mac]);
> > +			if (ret !=3D XDP_PASS)
> >  				goto skip_rx;
> > -			}
> > =20
> >  			skb =3D build_skb(data, PAGE_SIZE);
> >  			if (unlikely(!skb)) {
> > @@ -1725,8 +1761,8 @@ static int mtk_poll_rx(struct napi_struct *napi, =
int budget,
> >  			  &dim_sample);
> >  	net_dim(&eth->rx_dim, dim_sample);
> > =20
> > -	if (prog && xdp_do_redirect)
> > -		xdp_do_flush_map();
> > +	if (prog)
> > +		mtk_xdp_rx_complete(eth, xdp_stats);
> > =20
> >  	return done;
> >  }
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.h
> > index a1cea93300c1..629cdcdd632a 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> > @@ -570,6 +570,16 @@ struct mtk_tx_dma_v2 {
> >  struct mtk_eth;
> >  struct mtk_mac;
> > =20
> > +struct mtk_xdp_stats {
> > +	u64 rx_xdp_redirect;
> > +	u64 rx_xdp_pass;
> > +	u64 rx_xdp_drop;
> > +	u64 rx_xdp_tx;
> > +	u64 rx_xdp_tx_errors;
> > +	u64 tx_xdp_xmit;
> > +	u64 tx_xdp_xmit_errors;
> > +};
> > +
> >  /* struct mtk_hw_stats - the structure that holds the traffic statisti=
cs.
> >   * @stats_lock:		make sure that stats operations are atomic
> >   * @reg_offset:		the status register offset of the SoC
> > @@ -593,6 +603,8 @@ struct mtk_hw_stats {
> >  	u64 rx_checksum_errors;
> >  	u64 rx_flow_control_packets;
> > =20
> > +	struct mtk_xdp_stats	xdp_stats;
> > +
> >  	spinlock_t		stats_lock;
> >  	u32			reg_offset;
> >  	struct u64_stats_sync	syncp;
>=20

--NNuiGEB2UBQpZqTi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYs2ejQAKCRA6cBh0uS2t
rIgOAQC4eKeI0u9OQ2vP84ZFVJUmW7jV3TQejAH09noU7AqoCAEA+LHScNs9kETW
IO0i1hThcoTVO8QwJKIlFzOESHKkQgU=
=ENEd
-----END PGP SIGNATURE-----

--NNuiGEB2UBQpZqTi--
