Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A74D452B64
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhKPHQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:16:11 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:50560 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhKPHOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 02:14:50 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637046711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnGDRiA2GCNHA7+o/Kt/Z6WrOLAsUftsLdDJdaf+aMk=;
        b=PLI5G4tFO+Iv8x/Ap8BE/ME6/KHpWVxrO12NvgsmxN4L4a6Wqf39IMzObA05L2vH28O+B4
        ixNuzzZtpe5OR9C3FmKTZIpD/S/Ldk9pQrWkMqgi7OjK/JXK9j3wH5mlkup57alLiQQ8CQ
        J4GJLQUcAv/JrPgcJzP7kkXyKCghd/r63loFkKHqDkJT4UBfqBQEv3t+mRvdP/jCO/Mj+T
        VLCodYQaDBVsfIlHgVc6V+Qzycsfoi+BRjES4XWEMKvjTiohG5atlu3HUFDx4v1YcYzqoz
        /zm2lDBcX/kWR31p9Gfw1Usdbe7UK5zUyeIVHVNM5DSwt4TIPRgSzHJBRrqLlw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637046711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnGDRiA2GCNHA7+o/Kt/Z6WrOLAsUftsLdDJdaf+aMk=;
        b=GJZcFJJ2kjRHGyRRr6IMHztvaC5EwyDNRZmM55GsyFJ+iW5tqE+L50H622ToCKGNVZSTmK
        bD6N6z4PxhIERIBQ==
To:     Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH] net: stmmac: Fix signed/unsigned wreckage
In-Reply-To: <87mtm578cs.ffs@tglx>
References: <87mtm578cs.ffs@tglx>
Date:   Tue, 16 Nov 2021 08:11:49 +0100
Message-ID: <87fsrwbmmi.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain


+ BL

On Mon Nov 15 2021, Thomas Gleixner wrote:
> The recent addition of timestamp correction to compensate the CDC error
> introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
> it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().
>
> The issue is:
>
>     s64 adjust = 0;
>     u64 ns;
>
>     adjust += -(2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate));
>     ns += adjust;
>
> works by chance on 64bit, but falls apart on 32bit because the compiler
> knows that adjust fits into 32bit and then treats the addition as a u64 +
> u32 resulting in an off by ~2 seconds failure.
>
> The RX variant uses an u64 for adjust and does the adjustment via
>
>     ns -= adjust;
>
> because consistency is obviously overrated.
>
> Get rid of the pointless zero initialized adjust variable and do:
>
> 	ns -= (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
>
> which is obviously correct and spares the adjust obfuscation. Aside of that
> it yields a more accurate result because the multiplication takes place
> before the integer divide truncation and not afterwards.
>
> Stick the calculation into an inline so it can't be accidentaly
> disimproved. Return an u32 from that inline as the result is guaranteed
> to fit which lets the compiler optimize the substraction.
>
> Fixes: 3600be5f58c1 ("net: stmmac: add timestamp correction to rid CDC sync error")
> Reported-by: Benedikt Spranger <b.spranger@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Benedikt Spranger <b.spranger@linutronix.de>
> Cc: stable@vger.kernel.org

Thanks!

Tested-by: Kurt Kanzenbach <kurt@linutronix.de> # Intel EHL

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGTWbUTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpipkD/9MkdVNwJ84dNRdtUwmfnQlsI0n2kQ0
QMO1jWI59xY8lA4XWOVOEY0AekbhUCWUArZBoDsCLrAEWCIMAIZttxhtXqcy6c6p
x6t0IpgZ7aR0Tvs1MPgbxziIrJ2G9GMr3AE/NOrumCZZP9AObNbaryvVLcqU3Xjr
RDwcuAFINPM6Efn2XTP5k3Jn4dMJ8oE/m4AcsXX4RwX0FhoqmbjUKYJ3zwl4D8Iv
XNSbvC7OfMYLms6s2i/uQgceQytskCyvgcxo5QqUvv/O+K5wpads0xO+ufomanhZ
WRdKdbQoxLv+OavVMUw2HjviX3fQL1BmEm8Rtsm9fLQwquyIOc7Zcr2AxxWSW1q/
t3a0zVubbyJTUBB3Snp+KET8iCMytaWEEWgXZPParopENix+k1+dRaeQg9NdWSzf
rxxfAMVrA6wmSji3+9ncMLZHY0za73Rg5IGB+Zr4myTZCZ+dKED09URyuWmvtBPF
SafxnISUTaUsoOGtvPNy6SkMNjoZ2aeOrazT3szOCVG6naI+D44ah1e8eEqz+r+R
hgBwOYPQmvpSz9wm7kgi2GlaVsOvSMU7VspXkA8wVnx6rkBUpzbDB+LsakzFlTAt
bh/F2XFgnBWElq2JsIIxaiBuzbMFlbpC7z+7BtUbAFG/mfcMbypJY/neGFbEdpUY
4W+Azq1JFAZbPQ==
=ykXB
-----END PGP SIGNATURE-----
--=-=-=--
