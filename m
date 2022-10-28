Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D09610BED
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJ1IKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJ1IKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:10:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF558162
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:09:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooKQZ-0007ch-Oa; Fri, 28 Oct 2022 10:09:19 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0F2D110C7C1;
        Fri, 28 Oct 2022 07:33:40 +0000 (UTC)
Date:   Fri, 28 Oct 2022 09:33:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        socketcan@hartkopp.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@rempel-privat.de,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
Message-ID: <20221028073339.hx5pyysuyzhdj64q@pengutronix.de>
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="raf7tojhhyjubw35"
Content-Disposition: inline
In-Reply-To: <20221028033342.173528-1-shaozhengchao@huawei.com>
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


--raf7tojhhyjubw35
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 11:33:42, Zhengchao Shao wrote:
> It causes NULL pointer dereference when testing as following:
> (a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
> (b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
>     link device, and bind vxcan device to bond device (can also use
>     ifenslave command to bind vxcan device to bond device).
> (c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
> (d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.
>=20
> The bond device invokes the can-raw protocol registration interface to
> receive CAN packets. However, ml_priv is not allocated to the dev,
> dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
> it will occur the NULL pointer dereference issue.
>=20
> The following is the stack information:
> BUG: kernel NULL pointer dereference, address: 0000000000000008
> PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
> Oops: 0000 [#1] PREEMPT SMP
> RIP: 0010:can_rx_register+0x12d/0x1e0
> Call Trace:
> <TASK>
> raw_enable_filters+0x8d/0x120
> raw_enable_allfilters+0x3b/0x130
> raw_bind+0x118/0x4f0
> __sys_bind+0x163/0x1a0
> __x64_sys_bind+0x1e/0x30
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> </TASK>
>=20
> Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct n=
et_device")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/can/af_can.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index 9503ab10f9b8..ef2697f3ebcb 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -450,7 +450,7 @@ int can_rx_register(struct net *net, struct net_devic=
e *dev, canid_t can_id,
> =20
>  	/* insert new receiver  (dev,canid,mask) -> (func,data) */
> =20
> -	if (dev && dev->type !=3D ARPHRD_CAN)
> +	if (dev && (dev->type !=3D ARPHRD_CAN || dev->ml_priv_type !=3D ML_PRIV=
_CAN))

You can use the helper function: can_get_ml_priv() instead of open
coding the check.

Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--raf7tojhhyjubw35
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNbhdAACgkQrX5LkNig
013DfQf/f6F6T4cOHX1pTUywDes+4MKN3tQ11QC9BCFHY1yuu/OHyZpfy0EXoStL
8YAMKSrICpScDn2p4tk9miem+afaT3i/nBBCBYukFwB6bie6BKjuR4fFstRE3vLv
KlGxx+qiG5Gj0ALYYCmcxhQ93JTUuudoEdnv89gQcZssvFauJ4MuyofkuAgOtHCc
ugJrrDhwFGvdbykx1zGx4cReWOPAgznI9dCdzatURyeWlRN8TRkXzTSgehjSGDOY
/ILD6efINIzvhOUFitmn62FXVfHxoXnjsJSyCWS7Qpix9pMTtZTsLBpD3fexlgWT
3xAQgV4P0/Jv7hmPVyDv8bspOvXTFw==
=13LQ
-----END PGP SIGNATURE-----

--raf7tojhhyjubw35--
