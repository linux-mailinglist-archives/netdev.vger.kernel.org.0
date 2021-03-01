Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC9327D67
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhCALhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhCALhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:37:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6C6C06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:36:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGgqU-0004vZ-O1; Mon, 01 Mar 2021 12:36:14 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E3F005EB192;
        Mon,  1 Mar 2021 11:36:12 +0000 (UTC)
Date:   Mon, 1 Mar 2021 12:36:12 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/6] can: c_can: fix control interface used by
 c_can_do_tx
Message-ID: <20210301113612.rvbjnqacqstseokm@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-4-dariobin@libero.it>
 <20210226084456.l2oztlesjzl6t2nm@pengutronix.de>
 <942251933.544595.1614508531322@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yq2w6x3aott2pfwm"
Content-Disposition: inline
In-Reply-To: <942251933.544595.1614508531322@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yq2w6x3aott2pfwm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.02.2021 11:35:31, Dario Binacchi wrote:
> > On 25.02.2021 22:51:52, Dario Binacchi wrote:
> > > According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let=
 RX use
> > > IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).
> >=20
> > Is this a fix?
> >=20
>=20
> I think that If I consider what is described in the 640916db2bf7
> commit, using the IF_RX interface in a tx routine is wrong.

Yes, IF_RX is used in c_can_do_tx(), but that's called from
c_can_poll(), which runs ins NAPI.

As far as I understand 640916db2bf7 ("can: c_can: Make it SMP safe")
fixes the race condition that c_can_poll() and c_can_start_xmit() both
access the same IF. See again the patch description:

| The hardware has two message control interfaces, but the code only uses t=
he
| first one. So on SMP the following can be observed:
|=20
| CPU0            CPU1
| rx_poll()
|   write IF1     xmit()
|                 write IF1
|   write IF1

It's not 100% accurate, as the race condition is not just
c_can_do_rx_poll() against the c_can_start_xmit(), but the whole
c_can_poll() against c_can_start_xmit().

If you think my analysis is correct, please update the patch and add a
comment to clarify why IF_RX is used instead of changing it to IF_TX.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yq2w6x3aott2pfwm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA80akACgkQqclaivrt
76lmNAf+K8+BpPxNctjZO/WLuktbWGjezyM/yhftX3gPoo8YBrpACGQ4/HBs1mIn
7QYXMJMM2H3JI3HzAQ5YTKhQRvMamAm71SgcrbCZ+72cVwUkOpRd7PhxUNTsAOyG
1txJpZI9Na/bP7RiaRk3vk11wPB2oIiJz/FhT1By27U7j1rOoK+xBaU0+LpVIAJB
+ZhK+P/RoxCN+8/LQSW0M6sOxfyPeuj3E88tMW+vzutJ/puwsuFJhXhYt9I/d8JA
J04LcyV5m6Mv1omeykP6x6+dTmyar/VJMgQMm1PiOcimRCLNtJV8YAIK9nN5p1ok
hnj2rndapVwoSy6tLJ6kJ2aCgVCOlA==
=YGWX
-----END PGP SIGNATURE-----

--yq2w6x3aott2pfwm--
