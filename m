Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAA94C6417
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbiB1Hw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiB1Hwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:52:54 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D89268F93
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:52:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nOap1-0001vV-8e; Mon, 28 Feb 2022 08:51:55 +0100
Received: from pengutronix.de (unknown [90.153.54.255])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 71C443E7DC;
        Mon, 28 Feb 2022 07:51:48 +0000 (UTC)
Date:   Mon, 28 Feb 2022 08:51:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, thunder.leizhen@huawei.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: usb: fix a possible memory leak in
 esd_usb2_start_xmit
Message-ID: <20220228075146.hvui3iow7niupij4@pengutronix.de>
References: <20220225060019.21220-1-hbh25y@gmail.com>
 <20220225155621.7zmfukra63qcxjo5@pengutronix.de>
 <69b0dd44-93ac-fa33-f9c1-6f787185ab47@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pr4shtl3qkndepze"
Content-Disposition: inline
In-Reply-To: <69b0dd44-93ac-fa33-f9c1-6f787185ab47@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pr4shtl3qkndepze
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2022 10:05:03, Hangyu Hua wrote:
> I get it. But this means ems_usb_start_xmit have a redundant
> dev_kfree_skb beacause can_put_echo_skb delete original skb and
> can_free_echo_skb delete the cloned skb. While this code is harmless
> do you think we need to delete it ?

ACK. This dev_kfree_skb() should be deleted:

| 	err =3D usb_submit_urb(urb, GFP_ATOMIC);
| 	if (unlikely(err)) {
| 		can_free_echo_skb(netdev, context->echo_index, NULL);
|=20
| 		usb_unanchor_urb(urb);
| 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
| 		dev_kfree_skb(skb);

Can you create a patch?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pr4shtl3qkndepze
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIcfw8ACgkQrX5LkNig
013s5Qf/cixRpxrVZSNb0YLxaWmpHJZftGDRiFeLEL1xTAq8HiLAf4gwMj83iuTJ
EKew+Gcumf5JPzXtx8ojvik+BW/VwXSQtm9iOwJl6nvospA2wG5qX5Zpp9nPaKwY
KnNTuBNKoT3O+LyyN5drlaxIiDc0//X7M0WkUXC5l8nQfNo1ksU/8I37XyMJZYTm
YvUvRH9ymviK2Ahe+qi/yCFzwS6oAp/mzMQqLPOs4jBmbQLmAxIlNrxYwi6ZBlBS
REmg4Mr1kfc3SnR/8SIBEVbRq+6BQisAi/fCRLhcV/BUeCatKAlENQjXpehd8Gjk
SAJfTgYdDUvf0O9/l4EL1DsgR/UDtA==
=Aimr
-----END PGP SIGNATURE-----

--pr4shtl3qkndepze--
