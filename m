Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC1160BC9C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 23:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiJXV6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 17:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiJXV6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 17:58:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F605142D
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 13:12:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1on3el-0002i6-BB; Mon, 24 Oct 2022 22:02:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E2D6D108D21;
        Mon, 24 Oct 2022 20:02:39 +0000 (UTC)
Date:   Mon, 24 Oct 2022 22:02:38 +0200
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
Subject: Re: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20221024200238.tgqkjjyagklglshu@pengutronix.de>
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
 <20221012062558.732930-3-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="34f4uvw3wqv6t5uh"
Content-Disposition: inline
In-Reply-To: <20221012062558.732930-3-matej.vasilevski@seznam.cz>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--34f4uvw3wqv6t5uh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.10.2022 08:25:56, Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and

Later in the code you set struct ethtool_ts_info::tx_types but the
driver doesn't set TX timestamps, does it?

> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.
>=20
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>

[...]

> diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/c=
tucanfd/ctucanfd_base.c
> index b8da15ea6ad9..079819d53e23 100644
> --- a/drivers/net/can/ctucanfd/ctucanfd_base.c
> +++ b/drivers/net/can/ctucanfd/ctucanfd_base.c

[...]

> @@ -950,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, =
int quota)
>  			cf->data[1] |=3D CAN_ERR_CRTL_RX_OVERFLOW;
>  			stats->rx_packets++;
>  			stats->rx_bytes +=3D cf->can_dlc;
> +			if (priv->timestamp_enabled) {
> +				u64 tstamp =3D ctucan_read_timestamp_counter(priv);
> +
> +				ctucan_skb_set_timestamp(priv, skb, tstamp);
> +			}
>  			netif_rx(skb);
>  		}
> =20
> @@ -1230,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
>  		goto err_chip_start;
>  	}
> =20
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_init(priv);
> +

This is racy. You have to init the timestamping before the start of the
chip, i.e. enabling the IRQs. I had the same problem with the gs_usb
driver:

| https://lore.kernel.org/all/20220921081329.385509-1-mkl@pengutronix.de

>  	netdev_info(ndev, "ctu_can_fd device registered\n");
>  	napi_enable(&priv->napi);
>  	netif_start_queue(ndev);
> @@ -1262,6 +1306,8 @@ static int ctucan_close(struct net_device *ndev)
>  	ctucan_chip_stop(ndev);
>  	free_irq(ndev->irq, ndev);
>  	close_candev(ndev);
> +	if (priv->timestamp_possible)
> +		ctucan_timestamp_stop(priv);

Can you make this symmetric with respect to the ctucan_open() function.
> =20
>  	pm_runtime_put(priv->dev);
> =20
> @@ -1294,15 +1340,88 @@ static int ctucan_get_berr_counter(const struct n=
et_device *ndev, struct can_ber
>  	return 0;
>  }

[...]

> @@ -1385,15 +1534,29 @@ int ctucan_probe_common(struct device *dev, void =
__iomem *addr, int irq, unsigne
> =20
>  	/* Getting the can_clk info */
>  	if (!can_clk_rate) {
> -		priv->can_clk =3D devm_clk_get(dev, NULL);
> +		priv->can_clk =3D devm_clk_get_optional(dev, "core");
> +		if (!priv->can_clk)
> +			/* For compatibility with (older) device trees without clock-names */
> +			priv->can_clk =3D devm_clk_get(dev, NULL);
>  		if (IS_ERR(priv->can_clk)) {
> -			dev_err(dev, "Device clock not found.\n");
> +			dev_err(dev, "Device clock not found: %pe.\n", priv->can_clk);
>  			ret =3D PTR_ERR(priv->can_clk);
>  			goto err_free;
>  		}
>  		can_clk_rate =3D clk_get_rate(priv->can_clk);
>  	}
> =20
> +	if (!timestamp_clk_rate) {
> +		priv->timestamp_clk =3D devm_clk_get(dev, "ts");
> +		if (IS_ERR(priv->timestamp_clk)) {
> +			/* Take the core clock instead */
> +			dev_info(dev, "Failed to get ts clk\n");
> +			priv->timestamp_clk =3D priv->can_clk;
> +		}
> +		clk_prepare_enable(priv->timestamp_clk);
> +		timestamp_clk_rate =3D clk_get_rate(priv->timestamp_clk);
> +	}
> +
>  	priv->write_reg =3D ctucan_write32_le;
>  	priv->read_reg =3D ctucan_read32_le;
> =20
> @@ -1424,6 +1587,50 @@ int ctucan_probe_common(struct device *dev, void _=
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
> +	if (priv->timestamp_possible) {
> +		u64 max_cycles;
> +		u64 work_delay_ns;
> +		u32 maxsec;
> +
> +		priv->cc.read =3D ctucan_read_timestamp_cc_wrapper;
> +		priv->cc.mask =3D CYCLECOUNTER_MASK(timestamp_bit_size);
> +		maxsec =3D min_t(u32, CTUCANFD_MAX_WORK_DELAY_SEC,
> +			       div_u64(priv->cc.mask, timestamp_clk_rate));
> +		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift,
> +				       timestamp_clk_rate, NSEC_PER_SEC, maxsec);
> +
> +		/* shortened copy of clocks_calc_max_nsecs() */
> +		max_cycles =3D div_u64(ULLONG_MAX, priv->cc.mult);
> +		max_cycles =3D min(max_cycles, priv->cc.mask);
> +		work_delay_ns =3D clocksource_cyc2ns(max_cycles, priv->cc.mult,
> +						   priv->cc.shift) >> 2;

I think we can use cyclecounter_cyc2ns() for this, see:

| https://elixir.bootlin.com/linux/v6.0.3/source/drivers/net/ethernet/ti/cp=
ts.c#L642

BTW: This is the only networking driver using clocks_calc_mult_shift()
(so far) :D

> +		priv->work_delay_jiffies =3D nsecs_to_jiffies(work_delay_ns);
> +
> +		if (priv->work_delay_jiffies =3D=3D 0)
> +			priv->timestamp_possible =3D false;
> +	}
> +

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--34f4uvw3wqv6t5uh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNW71sACgkQrX5LkNig
0121xQf/VK9b6jSM1BJRgkG6LmBz/uImEDzN1TO6YGR549TK+6BX4Q1iIXtqFuu7
YBrwDTvYD5oOG8ljHpE8UtL6+PCJd1vQ/wyzdIJ9Xo9FLUYSG6c0o2kWtraVB6bo
1fVr8uwjpBkwyxKas3x5Q3qQsU1HKRgYQf5g9iApRCUiUKUOSd+4elZXxbmhGEm+
c70ZZOH6e7ms849I/Lt2AKpuL6sE9Jb8lg3pYpwS14gYkHf98rvYrlDMY1Dm02sT
3fiOzEr7pUNvFvDpsa9x1qLjlJFFp/RPstXMT6duq/Ui3/+QLKg1+P2uHKqUGx/u
KtNBy2sATH4YI+oncxnomNvpYzwFEw==
=JwQ+
-----END PGP SIGNATURE-----

--34f4uvw3wqv6t5uh--
