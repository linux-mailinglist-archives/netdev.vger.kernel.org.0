Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE345BF6FE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiIUHHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiIUHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:07:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C75C4663F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:07:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oatop-0003As-K9; Wed, 21 Sep 2022 09:06:51 +0200
Received: from pengutronix.de (hardanger-2.fritz.box [IPv6:2a03:f580:87bc:d400:f566:9915:77e6:ceb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3EEF7E8203;
        Wed, 21 Sep 2022 07:06:50 +0000 (UTC)
Date:   Wed, 21 Sep 2022 09:06:49 +0200
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
Subject: Re: [PATCH v4 2/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220920221450.poy5phzx564k36qn@pengutronix.de>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
 <20220914233944.598298-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dvrixjtqc5qvlwxk"
Content-Disposition: inline
In-Reply-To: <20220914233944.598298-3-matej.vasilevski@seznam.cz>
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


--dvrixjtqc5qvlwxk
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s5pcgxzoguqlmlik"
Content-Disposition: inline


--s5pcgxzoguqlmlik
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.09.2022 01:39:43, Matej Vasilevski wrote:
[...]

>  	/* Check for big-endianity and set according IO-accessors */
>  	if ((ctucan_read32(priv, CTUCANFD_DEVICE_ID) & 0xFFFF) !=3D CTUCANFD_ID=
) {
> @@ -1425,6 +1582,49 @@ int ctucan_probe_common(struct device *dev, void _=
_iomem *addr, int irq, unsigne
> =20
>  	priv->can.clock.freq =3D can_clk_rate;
> =20
> +	/* Obtain timestamping counter bit size */
> +	timestamp_bit_size =3D FIELD_GET(REG_ERR_CAPT_TS_BITS,
> +				       ctucan_read32(priv, CTUCANFD_ERR_CAPT));
> +
> +	/* The register value is actually bit_size - 1 */
> +	if (timestamp_bit_size) {
> +		timestamp_bit_size +=3D 1;
> +	} else {
> +		/* For 2.x versions of the IP core, we will assume 64-bit counter
> +		 * if there was a 0 in the register.
> +		 */
> +		u32 version_reg =3D ctucan_read32(priv, CTUCANFD_DEVICE_ID);
> +		u32 major =3D FIELD_GET(REG_DEVICE_ID_VER_MAJOR, version_reg);
> +
> +		if (major =3D=3D 2)
> +			timestamp_bit_size =3D 64;
> +		else
> +			priv->timestamp_possible =3D false;
> +	}
> +
> +	/* Setup conversion constants and work delay */
> +	priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> +	if (priv->timestamp_possible) {
> +		u64 max_cycles;
> +		u64 work_delay_ns;
> +		u32 maxsec =3D min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> +				   div_u64(priv->cc.mask, timestamp_freq));
> +
> +		priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> +				       timestamp_freq, NSEC_PER_SEC, maxsec);
> +
> +		/* shortened copy of clocks_calc_max_nsecs() */
> +		max_cycles =3D div_u64(ULLONG_MAX, priv->cc.mult);
> +		max_cycles =3D min(max_cycles, priv->cc.mask);
> +		work_delay_ns =3D clocksource_cyc2ns(max_cycles, priv->cc.mult,
> +						   priv->cc.shift) >> 1;

I just ported the code to another driver with dynamic frequency and
width. I noticed that the shift of 1 is not enough. With 2 it works.

regards,
MArc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--s5pcgxzoguqlmlik--

--dvrixjtqc5qvlwxk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMquAcACgkQrX5LkNig
012aPQf+P/mj/TEcAdI3Be4pkcF4qImtZF6LaZM5OrHc4iFbySunnpJHsg0FKrir
0gai4uY2wGpxWkNc5yZri5B83wWMtQsBJP/+ct0Nju8VnQADAlgGBBBMwK77qWR9
qfHRIQLL/MiWtZAQkxE/wLBGBQQhRHz1aZOv/wqn292wOMF81MS1e83AVHHHr/8E
YQ/x5lrgtVd1+JtgoAPNvmpKNvIqwa8dUmrKHT18RBwkOE+lz6qsr8wYKMz6P5Ix
ggULkhfKCqrGF9rx9Xbx8xBQGbxc12/qW6//E08UmcyXAJMEr6ljP5qz1pskDMCa
TcwPwhXXkmKEh77CClksVGgjIUue+w==
=mHOw
-----END PGP SIGNATURE-----

--dvrixjtqc5qvlwxk--
