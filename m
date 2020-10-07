Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54C0285D0D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgJGKjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:39:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42738 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgJGKjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:39:53 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602067191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DyTO6nNH3VT0YkDiBwoY6iLnyasMfYs/rQZg2axs0do=;
        b=iPYPKOAqg3ZavBsrgasT9+vNkcqGOs9XW+mdvnpa0hLk/Vt2FtKmHQZCuAZ4OtHLcIFloa
        CYfNQ6hhCKc4ThAWDtrBFflmKMi+KdfuG1l2hwF47vUwGxmEL5i3z7STc3GvaM5Na85nEV
        1SXnISWJf/lpt7Nf15ydpK0K+nbiCdoyUcg6zgJW6ju1QQcZ07xiXW8hrJa+3joLj2sxwz
        DE4r9loTtWm6PRMj37nTB10DL9hCuIvE07DP1kuqOmd/Knn8d4A3WSfmq0uU8KDCkbcwkE
        SvgOeaoMVOge6oztDs0YSF4IO5iRbmjyMxom2bQD53YXToalVVc+uNolzG5Zkg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602067191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DyTO6nNH3VT0YkDiBwoY6iLnyasMfYs/rQZg2axs0do=;
        b=ajgj4QkIIQpu2oCJw+9X5U6pVrjt0bdQtRXZ5FNcgXLpcTYpneJ7XTHP87ecKK6FoWeKX9
        4GMPiFwz2/ZBihDw==
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
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for hardware timestamping
In-Reply-To: <20201006140102.6q7ep2w62jnilb22@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-5-kurt@linutronix.de> <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt> <20201006072847.pjygwwtgq72ghsiq@skbuf> <87tuv77a83.fsf@kurt> <20201006133222.74w3r2jwwhq5uop5@skbuf> <87r1qb790w.fsf@kurt> <20201006140102.6q7ep2w62jnilb22@skbuf>
Date:   Wed, 07 Oct 2020 12:39:49 +0200
Message-ID: <87lfgiqpze.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Oct 06 2020, Vladimir Oltean wrote:
> On Tue, Oct 06, 2020 at 03:56:31PM +0200, Kurt Kanzenbach wrote:
>> On Tue Oct 06 2020, Vladimir Oltean wrote:
>> > On Tue, Oct 06, 2020 at 03:30:36PM +0200, Kurt Kanzenbach wrote:
>> >> That's the point. The user (or anybody else) cannot disable hardware
>> >> stamping, because it is always performed. So, why should it be allowed
>> >> to disable it even when it cannot be disabled?
>> >
>> > Because your driver's user can attach a PTP PHY to your switch port, a=
nd
>> > the network stack doesn't support multiple TX timestamps attached to t=
he
>> > same skb. They'll want the TX timestamp from the PHY and not from your
>> > switch.
>>=20
>> Yeah, sure. That use case makes sense. What's the problem exactly?
>
> The SO_TIMESTAMPING / SO_TIMESTAMPNS cmsg socket API simply doesn't have
> any sort of identification for a hardware TX timestamp (where it came
> from).

This is sounds like a problem. For instance the hellcreek switch has
actually three ptp hardware clocks and the time stamping can be
configured to use either one of them. How would the user space
distinguish what time stamp is taken by which clock? This is not a
problem at the moment, because currently only the synchronized clock is
exported to user space. See change log of this patch.

> So when you'll poll for TX timestamps, you'll receive a TX
> timestamp from the PHY and another one from the switch, and those will
> be in a race with one another, so you won't know which one is which.

OK. So what happens if the driver will accept to disable hardware
timestamping? Is there anything else that needs to be implemented? Are
there (good) examples?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl99mvUACgkQeSpbgcuY
8KYpYA/+NZ7x6UiwCygVWpIliPBWn1e5Z8sYKM2LClYibjm32fUKUbxj3JyPGg9F
vmhcRp6eFX+AItyhzd6NG+whOa72HyxQDCi7JvW52NHavnOlpmeeKu+g9bc9rTxJ
ihd7DR4lHt+wpDM/8khGX4yQMFkjbAAN62nDziVPhHAVQFKOvLmLj7ns0q4HpcVw
Atq+idodnY0qWrm0byWDn1OrVbKHkw2hmYgmsBH//bdjA7fspsCgoWxU3A5aF70l
u4dB5zj7bcTS/osxZeYocWBlbEuLdzzt+4eqPVdYUuwh69bBaCwPvDXXmF9ot6jp
xrMaLmgnhil+zverXQNKMY8KNXfNtAAg10XM/av4Uqf/pSgAlEzQ3HHC9qUTd+m4
Tfv+bpVOu24PdnwMkvwhGYXn9s3GNCe1w9nMeftabqKIg322XE39azgTNLy/l27x
+kiLOKkU1IaibGKNbSKErRB1PH3gQIMNfn3VCvYnpvRB4ezCH2T0v7ldpntIUBui
mH/q850jNaV0ig9n/Ju9vuZUwKefU0745qa1KMTNqu2oH/AQ5WOpboQ4X9U0NBy1
W+Tbl0ub0v27SNkAiVzkfeGRH4b6l+OASCryEIOc+NU26zfXp/dczAYXCEXdRvRG
unBwF5t6zEk2Nin/Hf/dQh/XH0w3BfreM4snHQ/t6kyYvsxQNcU=
=r52S
-----END PGP SIGNATURE-----
--=-=-=--
