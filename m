Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9259C5BE504
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 13:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiITL4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 07:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiITL4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 07:56:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A0672EF6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 04:56:35 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oabrd-00031k-MN; Tue, 20 Sep 2022 13:56:33 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:f217:a1f4:d2af:5b7c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 29108E7614;
        Tue, 20 Sep 2022 11:56:33 +0000 (UTC)
Date:   Tue, 20 Sep 2022 13:56:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Juergen Borleis <jbe@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: fec: limit register access on i.MX6UL
Message-ID: <20220920115624.zgycbbzijudr7muc@pengutronix.de>
References: <20220920095106.66924-1-jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hqa2x4iyrwdnlys5"
Content-Disposition: inline
In-Reply-To: <20220920095106.66924-1-jbe@pengutronix.de>
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


--hqa2x4iyrwdnlys5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20.09.2022 11:51:06, Juergen Borleis wrote:
> Using 'ethtool -d [=E2=80=A6]' on an i.MX6UL leads to a kernel crash:
>=20
>    Unhandled fault: external abort on non-linefetch (0x1008) at [=E2=80=
=A6]
>=20
> due to this SoC has less registers in its FEC implementation compared to =
other
> i.MX6 variants. Thus, a run-time decision is required to avoid access to
> non-existing registers.
>=20
> Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 50 +++++++++++++++++++++--
>  1 file changed, 47 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethe=
rnet/freescale/fec_main.c
> index 6152f6d..ab620b4 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2382,6 +2382,31 @@ static u32 fec_enet_register_offset[] =3D {
>  	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
>  	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
>  };
> +/* for i.MX6ul */
> +static u32 fec_enet_register_offset_6ul[] =3D {
> +	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
> +	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
> +	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
> +	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
> +	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
> +	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
> +	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
> +	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
> +	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
> +	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
> +	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
> +	RMON_T_P_GTE2048, RMON_T_OCTETS,
> +	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
> +	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
> +	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
> +	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
> +	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
> +	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
> +	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
> +	RMON_R_P_GTE2048, RMON_R_OCTETS,
> +	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
> +	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
> +};
>  #else
>  static __u32 fec_enet_register_version =3D 1;
>  static u32 fec_enet_register_offset[] =3D {
> @@ -2406,7 +2431,26 @@ static void fec_enet_get_regs(struct net_device *n=
dev,
>  	u32 *buf =3D (u32 *)regbuf;
>  	u32 i, off;
>  	int ret;
> -
> +#if defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M52=
8x) || \
> +	defined(CONFIG_M520x) || defined(CONFIG_M532x) || defined(CONFIG_ARM) |=
| \
> +	defined(CONFIG_ARM64) || defined(CONFIG_COMPILE_TEST)
> +	struct platform_device_id *dev_info =3D
> +			(struct platform_device_id *)fep->pdev->id_entry;
> +	u32 *reg_list;
> +	u32 reg_cnt;
> +
> +	if (strcmp(dev_info->name, "imx6ul-fec")) {
> +		reg_list =3D fec_enet_register_offset;
> +		reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset);
> +	} else {
> +		reg_list =3D fec_enet_register_offset_6ul;
> +		reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset_6ul);
> +	}

What about using of_machine_is_compatible()?

> +#else
> +	/* coldfire */
> +	static u32 *reg_list =3D fec_enet_register_offset;
> +	static const u32 reg_cnt =3D ARRAY_SIZE(fec_enet_register_offset);
> +#endif

Why do you need the ifdef?

>  	ret =3D pm_runtime_resume_and_get(dev);
>  	if (ret < 0)
>  		return;
> @@ -2415,8 +2459,8 @@ static void fec_enet_get_regs(struct net_device *nd=
ev,
> =20
>  	memset(buf, 0, regs->len);
> =20
> -	for (i =3D 0; i < ARRAY_SIZE(fec_enet_register_offset); i++) {
> -		off =3D fec_enet_register_offset[i];
> +	for (i =3D 0; i < reg_cnt; i++) {
> +		off =3D reg_list[i];
> =20
>  		if ((off =3D=3D FEC_R_BOUND || off =3D=3D FEC_R_FSTART) &&
>  		    !(fep->quirks & FEC_QUIRK_HAS_FRREG))

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hqa2x4iyrwdnlys5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMpqmYACgkQrX5LkNig
012rdgf/QKQBF08kAEHZcLSoXnU/ChCTH0bhjItfeyK+Q1tzOcxaqZJpj123RAMQ
wrH3duVbm9hLpS5aC9CVyKj7qso5nqOT6uymU/lnsj/3elqYgrJVLzMiVNMrtBZL
1T+8Mo4v7C4CeUOdoyXTBEjF4BiQrNSmXqd3JwcH7hMMj1uWRzgSbtkC0vDvCFCL
XOlLiGwy/Sab7S4RtMHgkRHTHxiNURI9l1n8mqCYTnLfLCBFk187rm6MAlomYzv/
gWwzH8vY3OEVAd7VbUHpZQqeVKRzzk1jPZQZNDse2ixHCZsFnf5RHRxYYfNUIPjo
iwUnDaxvok5GNB+v3u1zKDE7v3078A==
=fMtx
-----END PGP SIGNATURE-----

--hqa2x4iyrwdnlys5--
