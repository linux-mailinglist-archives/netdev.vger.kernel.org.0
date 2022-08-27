Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBDC5A38A6
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 18:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiH0QJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 12:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiH0QJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 12:09:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969752A97D
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 09:09:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oRyNC-00063X-8h; Sat, 27 Aug 2022 18:09:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 32905D5030;
        Sat, 27 Aug 2022 16:09:24 +0000 (UTC)
Date:   Sat, 27 Aug 2022 18:09:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     =?utf-8?B?Q3PDs2vDoXM=?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, qiangqing.zhang@nxp.com,
        Andrew Lunn <andrew@lunn.ch>, kernel@pengutronix.de
Subject: BUG: Re: [PATCH v3 resubmit] fec: Restart PPS after link state change
Message-ID: <20220827160922.642zlcd5foopozru@pengutronix.de>
References: <20220822081051.7873-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nmiq5bnmmqpp4iua"
Content-Disposition: inline
In-Reply-To: <20220822081051.7873-1-csokas.bence@prolan.hu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nmiq5bnmmqpp4iua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.08.2022 10:10:52, Cs=C3=B3k=C3=A1s Bence wrote:
> On link state change, the controller gets reset,
> causing PPS to drop out and the PHC to lose its
> time and calibration. So we restart it if needed,
> restoring calibration and time registers.
>=20
> Changes since v2:
> * Add `fec_ptp_save_state()`/`fec_ptp_restore_state()`
> * Use `ktime_get_real_ns()`
> * Use `BIT()` macro
> Changes since v1:
> * More ECR #define's
> * Stop PPS in `fec_ptp_stop()`
>=20
> Signed-off-by: Cs=C3=B3k=C3=A1s Bence <csokas.bence@prolan.hu>

current net-next/main fails on my imx6 with:

| [   14.001542] BUG: sleeping function called from invalid context at kern=
el/locking/mutex.c:283                                                     =
                                           =20
| [   14.010604] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 13,=
 name: kworker/0:1                                                         =
                                           =20
| [   14.018737] preempt_count: 201, expected: 0                           =
                                                                           =
                                           =20
| [   14.022931] CPU: 0 PID: 13 Comm: kworker/0:1 Not tainted 6.0.0-rc2+ #2=
25                                                                         =
                                           =20
| [   14.029643] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)=
                                                                           =
                                           =20
| [   14.036175] Workqueue: events_power_efficient phy_state_machine       =
                                                                           =
                                           =20
| [   14.042121] [<c010ffe0>] (unwind_backtrace) from [<c010ac04>] (show_st=
ack+0x10/0x14)                                                             =
                                           =20
| [   14.049889] [<c010ac04>] (show_stack) from [<c0ccab04>] (dump_stack_lv=
l+0x40/0x4c)                                                               =
                                           =20
| [   14.057479] [<c0ccab04>] (dump_stack_lvl) from [<c014ed7c>] (__might_r=
esched+0x11c/0x154)                                                        =
                                           =20
| [   14.065678] [<c014ed7c>] (__might_resched) from [<c0cd9c20>] (mutex_lo=
ck+0x18/0x58)                                                              =
                                           =20
| [   14.073356] [<c0cd9c20>] (mutex_lock) from [<c082b59c>] (fec_ptp_getti=
me+0x2c/0xc4)                                                              =
                                           =20
| [   14.081035] [<c082b59c>] (fec_ptp_gettime) from [<c082bff4>] (fec_ptp_=
save_state+0x14/0x50)                                                      =
                                           =20
| [   14.089403] [<c082bff4>] (fec_ptp_save_state) from [<c0826ee0>] (fec_r=
estart+0x40/0x6f4)                                                         =
                                           =20
| [   14.097510] [<c0826ee0>] (fec_restart) from [<c082b170>] (fec_enet_adj=
ust_link+0xb0/0x21c)                                                       =
                                           =20
| [   14.105789] [<c082b170>] (fec_enet_adjust_link) from [<c0819bb4>] (phy=
_link_change+0x28/0x54)                                                    =
                                           =20
| [   14.114333] [<c0819bb4>] (phy_link_change) from [<c0815688>] (phy_chec=
k_link_status+0x78/0xb4)
| [   14.122969] [<c0815688>] (phy_check_link_status) from [<c0816bec>] (ph=
y_state_machine+0x68/0x29c)
| [   14.131857] [<c0816bec>] (phy_state_machine) from [<c0140604>] (proces=
s_one_work+0x1f8/0x410)
| [   14.140398] [<c0140604>] (process_one_work) from [<c01419c8>] (worker_=
thread+0x2c/0x544)
| [   14.148502] [<c01419c8>] (worker_thread) from [<c0148a4c>] (kthread+0x=
e4/0xf0)
| [   14.155739] [<c0148a4c>] (kthread) from [<c0100170>] (ret_from_fork+0x=
14/0x24)
| [   14.162973] Exception stack(0xc2097fb0 to 0xc2097ff8)
| [   14.168032] 7fa0:                                     00000000 0000000=
0 00000000 00000000
| [   14.176217] 7fc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
| [   14.184402] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000
| [   14.191309] fec 2188000.ethernet lan0: Link is Up - 100Mbps/Full - flo=
w control rx/tx

Reverting this patch "fixes" the problem.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nmiq5bnmmqpp4iua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMKQbAACgkQrX5LkNig
010bEAf/UWJ+/nOWssgQgwArjVxAvpQhXfmZ8Tiv8eCHstsOwWPBh95qPLZpA6f6
npFTo5cp7VQafut8HWQxGTxksyXqt5GooZz0SCjHOBCUDKiAGsU//CsovpSR2Hiz
mnSV3O0nRfdTc+ZP21/GmwbEsHn+GoomnqvAqDONByg/SmOf/e9XuLGJFXG/hfag
+fVS7d/GlLmWUU5W57T4g/Hj8l9BQ/nqK7dlUT0ND3tJ0au162PVIU9b5lwm/Uuj
KuIu2JDglxvKaDLhgtcFW31cQCMsHpujGMIRxvLm25ATdwRWOyYn3/yxZEx7fan4
+HjKNyZ1IM2uYnnGq/4ssuk3dBMERA==
=PkKR
-----END PGP SIGNATURE-----

--nmiq5bnmmqpp4iua--
