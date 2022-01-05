Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CE64851FC
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbiAELom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiAELol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 06:44:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F24C061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 03:44:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n54iF-0003Vf-RG; Wed, 05 Jan 2022 12:44:15 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-7899-4998-133d-b4b9.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7899:4998:133d:b4b9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6D7DF6D18F8;
        Wed,  5 Jan 2022 11:44:11 +0000 (UTC)
Date:   Wed, 5 Jan 2022 12:44:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     syzbot <syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        eric.dumazet@gmail.com, hawk@kernel.org,
        intel-wired-lan-owner@osuosl.org, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in pskb_expand_head
Message-ID: <20220105114410.brzea3f5flgn5nl2@pengutronix.de>
References: <0000000000007ea16705d0cfbb53@google.com>
 <0000000000000fbea205d388d749@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pvmbkuebz5fmhav3"
Content-Disposition: inline
In-Reply-To: <0000000000000fbea205d388d749@google.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pvmbkuebz5fmhav3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.12.2021 16:19:20, syzbot wrote:
>  skb_over_panic net/core/skbuff.c:118 [inline]
>  skb_over_panic net/core/skbuff.c:118 [inline] net/core/skbuff.c:1986
>  skb_put.cold+0x24/0x24 net/core/skbuff.c:1986 net/core/skbuff.c:1986
>  isotp_rcv_cf net/can/isotp.c:570 [inline]
>  isotp_rcv_cf net/can/isotp.c:570 [inline] net/can/isotp.c:668
>  isotp_rcv+0xa38/0x1e30 net/can/isotp.c:668 net/can/isotp.c:668

> struct tpcon {
> 	int idx;
> 	int len;
        ^^^
> 	u32 state;
> 	u8 bs;
> 	u8 sn;
> 	u8 ll_dl;
> 	u8 buf[MAX_MSG_LENGTH + 1];
> };
>=20
> static int isotp_rcv_ff(struct sock *sk, struct canfd_frame *cf, int ae)
> {

[...]

> 	/* Check for FF_DL escape sequence supporting 32 bit PDU length */
> 	if (so->rx.len) {
> 		ff_pci_sz =3D FF_PCI_SZ12;
> 	} else {
> 		/* FF_DL =3D 0 =3D> get real length from next 4 bytes */
> 		so->rx.len =3D cf->data[ae + 2] << 24;
> 		so->rx.len +=3D cf->data[ae + 3] << 16;
> 		so->rx.len +=3D cf->data[ae + 4] << 8;
> 		so->rx.len +=3D cf->data[ae + 5];
> 		ff_pci_sz =3D FF_PCI_SZ32;
> 	}

Full 32 Bit PDUs don't work with struct tpcon::len being an "int". I
think converting it to "unsigned int" should be done.

[...]

> }
>=20
> static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
> 			struct sk_buff *skb)
> {
> 	struct isotp_sock *so =3D isotp_sk(sk);
> 	struct sk_buff *nskb;
> 	int i;
>=20
> 	if (so->rx.state !=3D ISOTP_WAIT_DATA)
> 		return 0;
>=20
> 	/* drop if timestamp gap is less than force_rx_stmin nano secs */
> 	if (so->opt.flags & CAN_ISOTP_FORCE_RXSTMIN) {
> 		if (ktime_to_ns(ktime_sub(skb->tstamp, so->lastrxcf_tstamp)) <
> 		    so->force_rx_stmin)
> 			return 0;
>=20
> 		so->lastrxcf_tstamp =3D skb->tstamp;
> 	}
>=20
> 	hrtimer_cancel(&so->rxtimer);
>=20
> 	/* CFs are never longer than the FF */
> 	if (cf->len > so->rx.ll_dl)
> 		return 1;
>=20
> 	/* CFs have usually the LL_DL length */
> 	if (cf->len < so->rx.ll_dl) {
> 		/* this is only allowed for the last CF */
> 		if (so->rx.len - so->rx.idx > so->rx.ll_dl - ae - N_PCI_SZ)
> 			return 1;
> 	}
>=20
> 	if ((cf->data[ae] & 0x0F) !=3D so->rx.sn) {
> 		/* wrong sn detected - report 'illegal byte sequence' */
> 		sk->sk_err =3D EILSEQ;
> 		if (!sock_flag(sk, SOCK_DEAD))
> 			sk_error_report(sk);
>=20
> 		/* reset rx state */
> 		so->rx.state =3D ISOTP_IDLE;
> 		return 1;
> 	}
> 	so->rx.sn++;
> 	so->rx.sn %=3D 16;
>=20
> 	for (i =3D ae + N_PCI_SZ; i < cf->len; i++) {
> 		so->rx.buf[so->rx.idx++] =3D cf->data[i];
> 		if (so->rx.idx >=3D so->rx.len)
> 			break;
> 	}
>=20
> 	if (so->rx.idx >=3D so->rx.len) {
> 		/* we are done */
> 		so->rx.state =3D ISOTP_IDLE;
>=20
> 		if ((so->opt.flags & ISOTP_CHECK_PADDING) &&
> 		    check_pad(so, cf, i + 1, so->opt.rxpad_content)) {
> 			/* malformed PDU - report 'not a data message' */
> 			sk->sk_err =3D EBADMSG;
> 			if (!sock_flag(sk, SOCK_DEAD))
> 				sk_error_report(sk);
> 			return 1;
> 		}
>=20
> 		nskb =3D alloc_skb(so->rx.len, gfp_any());
> 		if (!nskb)
> 			return 1;
>=20
> 		memcpy(skb_put(nskb, so->rx.len), so->rx.buf,
                       ^^^^^^^
> 		       so->rx.len);

This is where the skb_over_panic() happens.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pvmbkuebz5fmhav3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHVhIcACgkQqclaivrt
76mBngf7Bm/34wnau/lFJUMXxyFtcxMVjizZum0kCMtMp2ZnYDP1z1vz0vQLYwfL
+QMi7i4lNu2Be7FLZrB4Vqh0wDrtw5nv67Bff3UnWoMlyZCr6Oq1rbEdWue+F1uk
SE/TideImjzKVlcYze/p3dCTYPhnu2h2nvjQ7iRfApiOrGEYyRDawCG2rhcOO2ke
og60OLmP4bv7sfGLzpGZtnAzR+GxnLFC4pa7I1QH4ry62uzBTlDHE8g1ebM2bwfB
q/jcxK28uPZ7pU30y3DF/obRvJ1PUPBKfYr461VNHPLxg2CVh/3JJDfNAr6VcdvS
uTcgP18dcs5u2hMK2yWlmT6Yfi4Qow==
=30q3
-----END PGP SIGNATURE-----

--pvmbkuebz5fmhav3--
