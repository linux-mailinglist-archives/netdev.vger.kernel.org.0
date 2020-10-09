Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521D82881DC
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 07:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbgJIF63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 01:58:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55150 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgJIF63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 01:58:29 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602223107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wreLDN3qeHtkyiAt9aCHE3544pR0J7Q6j++tUgd9+QM=;
        b=kDDl8lHwgsBB2CL00/ma1X2pSR0wk3O5XSbwu1XjyFHhPua1g69yg2wrBNNY/+tRM9R/yG
        l9vMCZEQBQ0EA/ScxhCjPiTFIlWBtD9i2yh+fV4uD7i6w65PC9wYtEuYEcychpidc2x7Me
        2680wjaWn8jSMuj2bl6hp9kM/QNcGJ4CbRmq0HP3h/SIn9OBhj/wakIbKYSOaiTSiG/Rhx
        6Hd/7NgBCTBkb46Bi9cQ9EMgfSX3nxcW+kO1LzwDL746RuOm71xYPYItuv9sFAAHUmtwPD
        EIKBPyoS9DkP0JQ7GSyRt2lAUC5jiB5+Q6EYeGXsiLL1cXbqUKn3GvT5t6TQZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602223107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wreLDN3qeHtkyiAt9aCHE3544pR0J7Q6j++tUgd9+QM=;
        b=z6kXFUOeZ3knfKz0Bxy371X86utGl5FNZw1Di+T/g/O82HP8HaLY9laVyrRtAj/uEVsjwH
        nU14oOW4o3KSOXCg==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20201008114926.2c4slmnmqkncsogz@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-3-kurt@linutronix.de> <20201004125601.aceiu4hdhrawea5z@skbuf> <87lfgj997g.fsf@kurt> <20201006092017.znfuwvye25vsu4z7@skbuf> <878scj8xxr.fsf@kurt> <20201008114926.2c4slmnmqkncsogz@skbuf>
Date:   Fri, 09 Oct 2020 07:58:24 +0200
Message-ID: <871ri8ndof.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Oct 08 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 12:13:04PM +0200, Kurt Kanzenbach wrote:
>> >> >> +static const struct hellcreek_platform_data de1soc_r1_pdata =3D {
>> >> >> +	.num_ports	 =3D 4,
>> >> >> +	.is_100_mbits	 =3D 1,
>> >> >> +	.qbv_support	 =3D 1,
>> >> >> +	.qbv_on_cpu_port =3D 1,
>> >> >
>> >> > Why does this matter?
>> >>=20
>> >> Because Qbv on the CPU port is a feature and not all switch variants
>> >> have that. It will matter as soon as TAPRIO is implemented.
>> >
>> > How do you plan to install a tc-taprio qdisc on the CPU port?
>>=20
>> That's an issue to be sorted out.
>
> Do you have a compelling use case for tc-taprio on the CPU port though?
> I've been waiting for someone to put one on the table.

Yes, we do. This feature is a must for switched endpoints. Imagine one
port is connected to a PLC with tight cycle times and the other port is
connected to the out side world doing best effort traffic. Under no
circumstances should the ingressing best effort traffic interfere with
the incoming real time traffic. Using strict priorities is not enough as
a best effort frame still might block the wire for a certain period of
time. Therefore, this feature exists in the hardware and Qbv is needed
on the CPU port.

> If it's just "nice to have", I don't think that DSA will change just to
> accomodate that. The fact that the CPU port doesn't have a net device is
> already pretty much the established behavior.

Yes, I know that. Anyhow we'll have to find a solution to that problem.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9//AAACgkQeSpbgcuY
8KZz2Q/8C+RGw2pGgmvkroEpuTyFKh/X6W2iDlHiCKNr/U/P8pKGPoN07oklQ56X
F17V4kHpR6wAlDg0saD/PRdWR2DicEGxlYVteiB03SU7zg1CbUFw9Mh3CixQ6mQ1
YoAuOG5qu1SzDqan1Lp5q7BWUp4XoKB6me2SyiI6UmQGnorg46VMdEwKvcAQAU8h
8VGOeld+BuidtGrZfGX9trJ1N7Gs8zycyGbMNozeNcDByPBOJwKs6tdpOLEOSKDC
ETht+MUKTC7ds4QQIuQVuxaR52xkde1RkzCerdsoq0FJtctEwktKVNkzSz8z+jqD
viKprIOYj+9bL+O0FzpubwZ9ZJyM46zV0EUO79TQv9K9kQaZTzBHCrQ4indcUmUp
tuJoxtrP+A+LtcKwdpQ9MupbLgXjFaqfm4zYEl0vaQXDwBkUteawQDJAca1RrPYy
uCsS125k9SFRUh2QCeBFNY9KlytRlzM/EFH04JV78CHe1xKwJ6fXTrkrDELfDCkp
vqUP8QRXetmBMTzuYJnbUDLtebGt9HeTK+EkxCLXVzt+gLU6NCpATZaziqRnA/4E
4Yk/9cxmFA/2GlePS8AyUcu5XN/WXpXpFI1yUrKNxlndd4F4Yam1apw0lZgUY5Ok
Bqm/MIrrfiKP1+/7uUGn9zcI4oaOWRaB6tWUgRFcUKu6D9+BCVY=
=VAOA
-----END PGP SIGNATURE-----
--=-=-=--
