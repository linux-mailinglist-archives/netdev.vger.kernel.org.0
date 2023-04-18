Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14B6E6B34
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDRRie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 13:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjDRRid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 13:38:33 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Apr 2023 10:38:29 PDT
Received: from bues.ch (bues.ch [IPv6:2a01:138:9005::1:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC63F3C0E;
        Tue, 18 Apr 2023 10:38:29 -0700 (PDT)
Received: by bues.ch with esmtpsa (Exim 4.94.2)
        (envelope-from <m@bues.ch>)
        id 1ponwS-001CPg-VD; Tue, 18 Apr 2023 18:12:26 +0200
Date:   Tue, 18 Apr 2023 18:12:04 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lvc-project@linuxtesting.org>,
        Natalia Petrova <n.petrova@fintech.ru>
Subject: Re: [PATCH v2] b43legacy: Add checking for null for
 ssb_get_devtypedata(dev)
Message-ID: <20230418181204.473e7898@barney>
In-Reply-To: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
References: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3AByzQCFCjpBABSpZxJ8d0Q";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/3AByzQCFCjpBABSpZxJ8d0Q
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Apr 2023 07:29:18 -0700
Nikita Zhandarovich <n.zhandarovich@fintech.ru> wrote:

> Since second call of ssb_get_devtypedata() may fail as well as the
> first one, the NULL return value in 'wl' will be later dereferenced in
> calls to b43legacy_one_core_attach() and schedule_work().

No, the second call can't fail, because b43legacy_wireless_init() will
always initialize it before returning 0.

> a/drivers/net/wireless/broadcom/b43legacy/main.c +++
> b/drivers/net/wireless/broadcom/b43legacy/main.c @@ -3857,7 +3857,11
> @@ static int b43legacy_probe(struct ssb_device *dev, if (err)
>  			goto out;
>  		wl =3D ssb_get_devtypedata(dev);
> -		B43legacy_WARN_ON(!wl);
> +		if (!wl) {
> +			B43legacy_WARN_ON(!wl);
> +			err =3D -ENODEV;
> +			goto out;

And the 'goto out' would be the wrong error recovery path, too.

> +		}
>  	}
>  	err =3D b43legacy_one_core_attach(dev, wl);
>  	if (err)


Nack.
Please drop this patch. The code is correct as-is.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/3AByzQCFCjpBABSpZxJ8d0Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmQ+wVQACgkQ9TK+HZCN
iw7NzQ/9Ggyc5BtRToTBofdZbjnH/R/WeFz+RxXwxYLinJkQ/Cq6ilPkvqwf7w+y
6HltbMZ3xDd2+wqG9PGKwTqNy0on4Ja92nBZ+rh4zyIfOb8ng3/i6dkNkzd67QAc
vPzBblo2UMf8IUyJMhUGixGNNAZ+QK2iosPETZyG6Kk/UOVbkc1Ht2/Gxo67S2mK
rxezpiS253ECGpfkz7dFvooCwga2UmejgY3C547dcvmNTvvLh9xYFe99f1PtQc7m
IphZn5VLXOx1ptjVSzm2DE7pQjNdU0VaeGOjolmGtyBoWC2DqgqKEuDDgxkGhs2y
ZBLp8adRdGaZyU0Vp88xZJJtMXLrl2hvRqM29rSCRIve5FUjRkDovBbRsaVoogsy
1SHYuKwpY97j+PW8eZgsJ4L13cDsSZUYGcRG0l9rrq3B8K02VFEnAlFN/D0WXdRY
HKILvc3xjo+8MmM01gXeTfLan7i3PiTvi03cxM88Inh0zMQ1zV1w+eaXYR8VDpmF
grhBA94GsbeulgkNL19Lj7HQOmJ74QRWF+r2HhgwOlEOy7bqYKkM4Ht1Op4Sx85j
FpgQzjuGo9cVAZTVdr5JBPfI7Yd+1WJZm92HlR9iII9JFhrrDA19u11zTuBy6j/n
g6Y7bIyJiTmBD8trj8nRno2QVB75qevcQFBu/yOVXCwd68hzxlg=
=OX2A
-----END PGP SIGNATURE-----

--Sig_/3AByzQCFCjpBABSpZxJ8d0Q--
