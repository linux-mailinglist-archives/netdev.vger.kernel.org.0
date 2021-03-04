Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA10A32D6A4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhCDP1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 10:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhCDP12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 10:27:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E614C061761
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 07:26:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHprr-00015l-Vn; Thu, 04 Mar 2021 16:26:24 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3b3:61f5:ff65:ce3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B552A5EDCD1;
        Thu,  4 Mar 2021 15:26:19 +0000 (UTC)
Date:   Thu, 4 Mar 2021 16:26:18 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210304152618.rqajqmzcqqhszfem@pengutronix.de>
References: <20210302215435.18286-1-dariobin@libero.it>
 <20210302215435.18286-6-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wgmmyfwmn76i5d4s"
Content-Disposition: inline
In-Reply-To: <20210302215435.18286-6-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wgmmyfwmn76i5d4s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.03.2021 22:54:34, Dario Binacchi wrote:
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index 77b9aee56154..0052ba5197e0 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
[...]
> -struct net_device *alloc_c_can_dev(void)
> +struct net_device *alloc_c_can_dev(int msg_obj_num)
>  {
>  	struct net_device *dev;
>  	struct c_can_priv *priv;
> +	int msg_obj_tx_num =3D msg_obj_num / 2;
> =20
> -	dev =3D alloc_candev(sizeof(struct c_can_priv), C_CAN_MSG_OBJ_TX_NUM);
> +	dev =3D alloc_candev(sizeof(*priv) + sizeof(u32) * msg_obj_tx_num,
> +			   msg_obj_tx_num);

I've converted this to make use of the struct_size() macro:

+       dev =3D alloc_candev(struct_size(priv, dlc, msg_obj_tx_num),
+                          msg_obj_tx_num);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wgmmyfwmn76i5d4s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBA/BgACgkQqclaivrt
76m4zwgAny/+Z6viYUgp3sOUmSnJzENe19yvsk7JUDQ10FUvBTGDASIHY9qEg+Sn
nJ1EDa8d37+SO7SYusaiogXzxV61vnZSmvfrzERCN8kH4jVRscNXd6tD12P04FDS
6Jj+Oks0+hYL0+9r8qzR9NPZzoxWqWbUyGk4tEnYFQ84LALZjmWpEeOv/ORKv6UI
KJPTl1asXcVOj1gyq0AvAHaND0Ei+t2lmej5iA4dxxdi8dIt1nYq+tDo8IGl5jqa
cPaP4jKopOHMaOgwYzpPieG4NXoBvai3XxfxjP+ZWUB70MU3YfP5JCn0m+tqAOsh
bshqNyienPr57S0oyUuXkt9zikG61w==
=LgIH
-----END PGP SIGNATURE-----

--wgmmyfwmn76i5d4s--
