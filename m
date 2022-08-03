Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3F5888E3
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 10:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiHCIxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 04:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiHCIxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 04:53:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0CF1BEA0
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 01:53:21 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oJA7n-00050L-F8; Wed, 03 Aug 2022 10:53:07 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 17D08C1EBC;
        Wed,  3 Aug 2022 08:53:05 +0000 (UTC)
Date:   Wed, 3 Aug 2022 10:53:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220803085303.2u4l5l6wmualq33v@pengutronix.de>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-2-matej.vasilevski@seznam.cz>
 <20220802092907.d2xtbqulkvzcwfgj@pengutronix.de>
 <20220803000903.GB4457@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xzz6ga4t26gszo6c"
Content-Disposition: inline
In-Reply-To: <20220803000903.GB4457@hopium>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xzz6ga4t26gszo6c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.08.2022 02:09:03, Matej Vasilevski wrote:
[...]

> > > @@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_p=
riv *priv, struct canfd_frame *c
> > >  	if (unlikely(len > wc * 4))
> > >  		len =3D wc * 4;
> > > =20
> > > -	/* Timestamp - Read and throw away */
> > > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > > -	ctucan_read32(priv, CTUCANFD_RX_DATA);
> > > +	/* Timestamp */
> > > +	tstamp_low =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> > > +	tstamp_high =3D ctucan_read32(priv, CTUCANFD_RX_DATA);
> > > +	*timestamp =3D concatenate_two_u32(tstamp_high, tstamp_low) & priv-=
>cc.mask;
> > > =20
> > >  	/* Data */
> > >  	for (i =3D 0; i < len; i +=3D 4) {
> > > @@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
> > >  	struct net_device_stats *stats =3D &ndev->stats;
> > >  	struct canfd_frame *cf;
> > >  	struct sk_buff *skb;
> > > +	u64 timestamp;
> > >  	u32 ffw;
> > > =20
> > >  	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
> > > @@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
> > >  		return 0;
> > >  	}
> > > =20
> > > -	ctucan_read_rx_frame(priv, cf, ffw);
> > > +	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
> > > +	if (priv->timestamp_enabled)
> > > +		ctucan_skb_set_timestamp(priv, skb, timestamp);
> >=20
> > Can the ctucan_skb_set_timestamp() and ctucan_read_timestamp_counter()
> > happen concurrently? AFAICS they are all called from ctucan_rx_poll(),
> > right?
>=20
> Yes, I see no problem when two ctucan_read_timestamp_counter run
> concurrently, same goes for two ctucan_skb_set_timestamp and=20
> ctucan_skb_set_timestamp concurrently with
> ctucan_read_timestamp_counter.

Right!

> The _counter() function only reads from the core's registers and returns
> a new timestamp. The _set_timestamp() only writes to the skb, but the
> skb will be allocated new in every _rx_poll() call.
>=20
> The only concurrency issue I can remotely see is when the periodic worker
> updates timecounter->cycle_last, right when the value is used in
> timecounter_cyc2time (from _set_timestamp()). But I don't think this is
> worth using some synchronization primitive.

Yes, I'm worried about the cycle_last on 32 bit systems.

[...]

> > > +	priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> > > +	priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> >=20
> > Does the driver use these 2 if timestamping is not possible?
>=20
> Cc.mask is always used in ctucan_read_rx_frame(), cc.read isn't used
> when timestamps aren't possible. I can move cc.read inside the 'if' for
> maximal efficiency.

Ok

> > > +	if (priv->timestamp_possible) {
> > > +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_=
freq,
> > > +				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
> > > +		priv->work_delay_jiffies =3D
> > > +			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
> > > +		if (priv->work_delay_jiffies =3D=3D 0)
> > > +			priv->timestamp_possible =3D false;
> >=20
> > You'll get a higher precision if you take the mask into account, at
> > least if the counter overflows before CTUCANFD_MAX_WORK_DELAY_SEC:
> >=20
> >         maxsec =3D min(CTUCANFD_MAX_WORK_DELAY_SEC, priv->cc.mask / tim=
estamp_freq);
> > =09
> >         clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timesta=
mp_freq, NSEC_PER_SEC,  maxsec);
> >         work_delay_in_ns =3D clocks_calc_max_nsecs(&priv->cc.mult, &pri=
v->cc.shift, 0, &priv->cc.mask, NULL);
> >=20
> > You can use clocks_calc_max_nsecs() to calculate the work delay.
>=20
> This is a good point, thanks. I'll incorporate it into the patch.

And do this calculation after a clk_prepare_enable(), see other mail to
Pavel
| https://lore.kernel.org/all/20220803083718.7bh2edmsorwuv4vu@pengutronix.d=
e/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xzz6ga4t26gszo6c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLqN20ACgkQrX5LkNig
012MQwf/U3eWqTxuKrYL/ao4tsuw1uSjG+Ei6ecFUYM+ni1t2o/oyFBTnb3jIK1J
aHtap+kiVgNhvrAox65oRyZu8DUOfK4VZDoSZkwscCun/1NLDA0OEGszBM+l29vY
3Cmxmo+zCZWmhTBYsSgBg4Rd/JgnMI5IxdaNgDbSJ4D3d4iPhijBpXMNHQrsNCXT
6MzFXoZkaYc1z0fj5DiwI3BDJqO55eTxwAeT5BjTF8hovT9Assbz6Zl/CejmwjYo
DHVoAvmH08Lwc2pgcyefWb3MPyVq6BtRqLVDx0mYlUS1BykaZeq5JrwSYMCMfZZw
RSzbL4upE9hwnIJpGdlfiGonVLI18A==
=dmdW
-----END PGP SIGNATURE-----

--xzz6ga4t26gszo6c--
