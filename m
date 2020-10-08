Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E712870BF
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgJHIeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:34:15 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49040 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgJHIeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:34:15 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602146052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZblxI6kdClkP7JdkAfmuSntsrn2AeJdJse8c66s2cWk=;
        b=jii0Ujcrpa7H0Ng8lanHOZhsdDBAAEkxpZ3HeLuKdNeBRAldsURPdmbURceCYUJPNMuXmi
        mxLtEgmdiuI9xFuXc7Yzvlaw4JrVGzpfiwHE6fvmBEjQ9U/Aa1OvntBl2N0D0Iz5N9JKVv
        boLJe1Bnv2iCtgQk93o7dIOKojz53Ph8ozHt/yCNBeNfApKJJcCSECZgpRWBWcyuf4Dxwc
        C8ZB4dCm+kABlKt8s8QBEF0okyyJJQ0yJm74y25HoEu4F0+WTrku8usKIxqtbXD1SaC3hm
        AUtCuDCXlYYrpvkKKL58lMBB384thS8MR5O5mtB1cb+EzYx8ML0J0XGlCf0xzw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602146052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZblxI6kdClkP7JdkAfmuSntsrn2AeJdJse8c66s2cWk=;
        b=K1ihxIGbqo5hwLc1Eh5rJ5fwOdYi9LXvqPGXezI61JyHLvtguUm0YmyzleSOjdoEbB+Cqe
        uNas94cr6dHf5+DQ==
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
In-Reply-To: <20201007105458.gdbrwyzfjfaygjke@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de> <20201004112911.25085-5-kurt@linutronix.de> <20201004143000.blb3uxq3kwr6zp3z@skbuf> <87imbn98dd.fsf@kurt> <20201006072847.pjygwwtgq72ghsiq@skbuf> <87tuv77a83.fsf@kurt> <20201006133222.74w3r2jwwhq5uop5@skbuf> <87r1qb790w.fsf@kurt> <20201006140102.6q7ep2w62jnilb22@skbuf> <87lfgiqpze.fsf@kurt> <20201007105458.gdbrwyzfjfaygjke@skbuf>
Date:   Thu, 08 Oct 2020 10:34:11 +0200
Message-ID: <87362pjev0.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Oct 07 2020, Vladimir Oltean wrote:
> On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach wrote:
>> For instance the hellcreek switch has actually three ptp hardware
>> clocks and the time stamping can be configured to use either one of
>> them.
>
> The sja1105 also has a corrected and an uncorrected PTP clock that can
> take timestamps. Initially I had thought I'd be going to spend some time
> figuring out multi-PHC support, but now I don't see any practical reason
> to use the uncorrected PHC for anything.

Just out of curiosity: How do you implement 802.1AS then? My
understanding is that the free-running clock has to be used for the
calculation of the peer delays and such meaning there should be a way to
get access to both PHCs or having some form of cross timestamping
available.

The hellcreek switch can take cross snapshots of all three ptp clocks in
hardware for that purpose.

>> > So when you'll poll for TX timestamps, you'll receive a TX
>> > timestamp from the PHY and another one from the switch, and those will
>> > be in a race with one another, so you won't know which one is which.
>>=20
>> OK. So what happens if the driver will accept to disable hardware
>> timestamping? Is there anything else that needs to be implemented? Are
>> there (good) examples?
>
> It needs to not call skb_complete_tx_timestamp() and friends.
>
> For PHY timestamping, it also needs to invoke the correct methods for RX
> and for TX, where the PHY timestamping hooks will get called. I don't
> think that DSA is compatible yet with PHY timestamping, but it is
> probably a trivial modification.

Hmm? If DSA doesn't support PHY timestamping how are other DSA drivers
dealing with it then? I'm getting really confused.

Furthermore, there is no hellcreek hardware available with timestamping
capable PHYs. How am I supposed to even test this?

For now, until there is hardware available, PHY timestamping is not
supported with the hellcreek switch.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9+zwMACgkQeSpbgcuY
8KY2Aw//R6iNHizAQT6wLfzBWuBN3AjdMRKGD78FoiMcyUUe0ysdDXtHbT784w3l
F8Kmi3YLM5cFxp211Y11Y/qwAd77Or4DbrlV2EPxeoZMHjVQ/yoo+Ss1z97Zb6yj
UoZL6suVBvCyNwegGL1HCkVuJAR3gojjaki74zEiJ1XrCSNiQpknLVYjarvqysoY
H7BD4sf117jAprhB1fNttJb1MxVUyLLt6x8QFZygLh34EWpiM+WvigfeE5eM9B4T
E1w1Nu689D/arttrv2mXzbJKWBbswBSDLaaVx1d6knsMu/3yFCvYwUFP77+8cERZ
XeUa2ay2TfTdPWkP+41Rn54TE9sSpRLqIUevhXtMqrmdQbvHFkapjCbZtENIpioM
nli1S4lzrnMhmeqHs6xBQobUDfs/QIYNfJTyUSvy9MQL1bkFEg5ymXRdwhJtXp8J
A+TjF5D823MjNhTkPZOHeVCD6s8zjRovFP+/S3vkAIlHHW2tLb4d+IwZbYdN3Ui1
ewIDFj97RYKPxjHFazbhFlolKMYa8szvb2A+hGSPT01n6ndCbiowaganft60U6jr
DTT74eVVcb8sISB959ICQGcOT/sWzaYYtSAk+KUGt7U0PFPnt3VpudSgr8/sPZTP
bKoHn4SvwMPd+PeHGNR3TgJ0ICZ5bZ+520eVjfO2TXHgtX8zfYY=
=NmXJ
-----END PGP SIGNATURE-----
--=-=-=--
