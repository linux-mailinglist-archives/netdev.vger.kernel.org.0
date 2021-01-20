Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE92FCB64
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbhATHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbhATHTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:19:08 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA3C061575
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:18:28 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611127106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MiSK9muvkYaLWdLJPs5L/uq12BAhJoYtL9uzVwOpQgc=;
        b=K9tC/JE/8MZKka4RAzkXjEvyOaajKsHG5Uwviqp6geo8QDbwTu8zn2wbG2U5WCg7l1lIJD
        /+XZllZrpSPXH5wF57ZMVrEGmnCITwBJgSfdLgkgIMDwL3T6mUe19ZXf3JQqvVlOsODIL9
        ylgalwn278u6GJCN2nsbiASLDcRMN2k1cJaxmlNp9RHPxvHFqX8z/fRpWjMBMANkH65tbm
        W1VbXbmk4a/NEGzNC94i9Uo0j+O4cVwfO5CeA3IZ7vkXLLtxvpF79/wdUaruy5d9diUV7g
        sOhMuplXmyZP2A0FX8hPT1i/ZeelWwOXLdX9cueBXbTOuAYpmY6JvbHrPP3dsQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611127106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MiSK9muvkYaLWdLJPs5L/uq12BAhJoYtL9uzVwOpQgc=;
        b=qmz08gCqUPlC5qt2WiIj7LdHBRCt/cDtlr39PGf9rg6pQvC/K1ApVtE9wHMdkGQ1Ihu/BB
        UjW1KzX/sFVAUZDg==
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/1] net: dsa: hellcreek: Add TAPRIO offloading support
In-Reply-To: <20210119155703.7064800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210116124922.32356-1-kurt@linutronix.de> <20210116124922.32356-2-kurt@linutronix.de> <20210119155703.7064800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 20 Jan 2021 08:18:15 +0100
Message-ID: <87turc2i14.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue Jan 19 2021, Jakub Kicinski wrote:
> On Sat, 16 Jan 2021 13:49:22 +0100 Kurt Kanzenbach wrote:
>> +	if (base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC)
>> +		return true;
>> +
>> +	return false;
>
> nit:
> 	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;

Sure.

>> +	/* Schedule periodic schedule check */
>> +	schedule_delayed_work(&hellcreek_port->schedule_work,
>> +			      HELLCREEK_SCHEDULE_PERIOD);
>
> Why schedule this work every 2 seconds rather than scheduling it
> $start_time - 8 sec + epsilon?

The two seconds are taken from the programming guide. That's why I used
it.

The PTP frequency starts to matter for large deltas. In theory the
rescheduling period can be increased [1]. Should I adjust it?=20

>
>> +static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
>> +					struct tc_taprio_qopt_offload *schedule)
>> +{
>> +	/* Does this hellcreek version support Qbv in hardware? */
>> +	if (!hellcreek->pdata->qbv_support)
>> +		return false;
>> +
>> +	/* cycle time can only be 32bit */
>> +	if (schedule->cycle_time > (u32)-1)
>> +		return false;
>> +
>> +	/* cycle time extension is not supported */
>> +	if (schedule->cycle_time_extension)
>> +		return false;
>
> What's the story with entries[i].command? I see most drivers validate
> the command is what they expect.
>

Good catch! I'll add the validation.

Thanks,
Kurt

[1] - https://lkml.kernel.org/netdev/20200901144755.jd2wnmweywwvkwvl@skbuf/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmAH2TcACgkQeSpbgcuY
8Ka2aQ/+Ni7jwyEmoJ80/b/+hehBXkvi6ucX8hR/hfheAP5B6J2FRs6UqrTAEwDZ
4paVsQss5KlLjod3qeZ3xJET96ckHl0gIzajDdDMkFgGQbDWeRKp6p+tJALyz5Rp
ALJeWdDVivYL65gjm0cy+ohgbw1+t95nmofr9yn4q9SuisI8+vpJo/10zjbkIz2L
t2xNgdL9j289uqRxHRnFA28mQFa1CCTZCCkSEqIQacPI82Iq3i0wPQfYChCoxJOE
o5M9fyrvkEvujUvwGpbpGGa7ykP356rbHXakUwmgt1jGs0hh2KyME2xq1JBnJPKU
nDDlgCSz0UZtcs9xDGYmupSOlZhSrxTdqFf7P2udiYCQJLyV/922/mmkI0Cuuc7h
6CQfvhGLLNT6dundotX4yEXDqbrm/rmI0jh5KECSXmhdHpbKl3HXVdxiyEfPn6VR
y4hOsXhzIsWeQxUBQ1g3FM+2rKtmJEQJCdC76NWazvaVPNPZLVh93sCeazbmS7YI
/r399OyBAZX340bVYXpYC7FnyAXS90p6VnuqCGpNNK12k9VPrtSgHS9xSQ8wC1kC
GeC8vE6oNOJDEb39FgyE8tkK5feaHCNkPOf2llOoELAoHA5/1QjiUIzSeir5dmZn
nbadn3bZH8MRKUOpkC7XqQuFF+KB6z9sFWgriiOv2jao4l7ppxQ=
=gQNg
-----END PGP SIGNATURE-----
--=-=-=--
