Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290525BD80
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgICIl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:41:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:48492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgICIl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:41:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 100D6B706;
        Thu,  3 Sep 2020 08:41:27 +0000 (UTC)
Date:   Thu, 3 Sep 2020 10:41:22 +0200
From:   Petr Tesarik <ptesarik@suse.cz>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org
Subject: Re: RTL8402 stops working after hibernate/resume
Message-ID: <20200903104122.1e90e03c@ezekiel.suse.cz>
In-Reply-To: <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
        <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
        <20200716105835.32852035@ezekiel.suse.cz>
        <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/F0PlOo0hAUR0SqykBSgVWM/";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/F0PlOo0hAUR0SqykBSgVWM/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Heiner,

this issue was on the back-burner for some time, but I've got some
interesting news now.

On Sat, 18 Jul 2020 14:07:50 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

>[...]
> Maybe the following gives us an idea:
> Please do "ethtool -d <if>" after boot and after resume from suspend,
> and check for differences.

The register dump did not reveal anything of interest - the only
differences were in the physical addresses after a device reopen.

However, knowing that reloading the driver can fix the issue, I copied
the initialization sequence from init_one() to rtl8169_resume() and
gave it a try. That works!

Then I started removing the initialization calls one by one. This
exercise left me with a call to rtl_init_rxcfg(), which simply sets the
RxConfig register. In other words, these is the difference between
5.8.4 and my working version:

--- linux-orig/drivers/net/ethernet/realtek/r8169_main.c	2020-09-02 22:43:0=
9.361951750 +0200
+++ linux/drivers/net/ethernet/realtek/r8169_main.c	2020-09-03 10:36:23.915=
803703 +0200
@@ -4925,6 +4925,9 @@
=20
 	clk_prepare_enable(tp->clk);
=20
+	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_37)
+		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
+
 	if (netif_running(tp->dev))
 		__rtl8169_resume(tp);
=20
This is quite surprising, at least when the device is managed by
NetworkManager, because then it is closed on wakeup, and the open
method should call rtl_init_rxcfg() anyway. So, it might be a timing
issue, or incorrect order of register writes.

Since I have no idea why the above change fixes my issue, I'm hesitant
to post it as a patch. It might break other people's systems...

Petr T

--Sig_/F0PlOo0hAUR0SqykBSgVWM/
Content-Type: application/pgp-signature
Content-Description: Digitální podpis OpenPGP

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHl2YIZkIo5VO2MxYqlA7ya4PR6cFAl9QrDIACgkQqlA7ya4P
R6d0RAf+P+N+LfrA80VunO1YGVUBQghbfGN5Qu04x5z1N2Pxtu+KSpnnN+nnAZSE
WXO7aqiVqflPwOEZezD10vFCmdaW7wdOyUSsSzygxj6Kvl/IsTEMVv9xJinvbHIa
3dFl8VNDl4X5m8AG6/eDn3jKxykRuZhz4N7rfUbpUZSDyKs2o0XkRT8rd8QRPZkx
I+YwNsFeOa5nHSG8vpob3X2r3oMDy0asy1N6Fd0M9KQ7dcl1NDJ1HRA6UuQU8+Xp
Csk6lgh3OZ9JvgSmSwvok1zKoxId9sgfSauLJ/Khw6JDme/CaP1ttwUYN9zmHB6D
/eFguthk86nMTxAMg9vrDX8x5EtU7Q==
=csjp
-----END PGP SIGNATURE-----

--Sig_/F0PlOo0hAUR0SqykBSgVWM/--
