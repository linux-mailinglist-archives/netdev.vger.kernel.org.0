Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551A3203636
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgFVLwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgFVLwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:52:46 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A299C061794;
        Mon, 22 Jun 2020 04:52:46 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnL0E-0007v8-Hk; Mon, 22 Jun 2020 13:52:42 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 3/9] net: dsa: hellcreek: Add PTP clock support
In-Reply-To: <20200619134001.GC304147@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-4-kurt@linutronix.de> <20200618172304.GG240559@lunn.ch> <878sgjqx4r.fsf@kurt> <20200619134001.GC304147@lunn.ch>
Date:   Mon, 22 Jun 2020 13:52:36 +0200
Message-ID: <87lfkftj0b.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Jun 19 2020, Andrew Lunn wrote:
> On Fri, Jun 19, 2020 at 10:26:44AM +0200, Kurt Kanzenbach wrote:
>> Hi Andrew,
>>=20
>> On Thu Jun 18 2020, Andrew Lunn wrote:
>> >> +static u64 __hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
>> >> +{
>> >> +	u16 nsl, nsh, secl, secm, sech;
>> >> +
>> >> +	/* Take a snapshot */
>> >> +	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
>> >> +
>> >> +	/* The time of the day is saved as 96 bits. However, due to hardware
>> >> +	 * limitations the seconds are not or only partly kept in the PTP
>> >> +	 * core. That's why only the nanoseconds are used and the seconds a=
re
>> >> +	 * tracked in software. Anyway due to internal locking all five
>> >> +	 * registers should be read.
>> >> +	 */
>> >> +	sech =3D hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> >> +	secm =3D hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> >> +	secl =3D hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> >> +	nsh  =3D hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> >> +	nsl  =3D hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> >> +
>> >> +	return (u64)nsl | ((u64)nsh << 16);
>> >
>> > Hi Kurt
>> >
>> > What are the hardware limitations? There seems to be 48 bits for
>> > seconds? That allows for 8925104 years?
>>=20
>> In theory, yes. Due to hardware hardware considerations only a few or
>> none of these bits are used for the seconds. The rest is zero. Meaning
>> that the wraparound is not 8925104 years, but at e.g. 8 seconds when
>> using 3 bits for the seconds.
>
> Please add this to the comment.

I will, no problem.

>
>> >> +static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
>> >> +{
>> >> +	u64 ns;
>> >> +
>> >> +	ns =3D __hellcreek_ptp_clock_read(hellcreek);
>> >> +	if (ns < hellcreek->last_ts)
>> >> +		hellcreek->seconds++;
>> >> +	hellcreek->last_ts =3D ns;
>> >> +	ns +=3D hellcreek->seconds * NSEC_PER_SEC;
>> >
>> > So the assumption is, this gets called at least once per second. And
>> > if that does not happen, there is no recovery. The second is lost.
>>=20
>> Yes, exactly. If a single overflow is missed, then the time is wrong.
>>=20
>> >
>> > I'm just wondering if there is something more robust using what the
>> > hardware does provide, even if the hardware is not perfect.
>>=20
>> I don't think there's a more robust way to do this. The overflow period
>> is a second which should be enough time to catch the overflow even if
>> the system is loaded. We did long running tests for days and the
>> mechanism worked fine. We could also consider to move the delayed work
>> to a dedicated thread which could be run with real time (SCHED_FIFO)
>> priority. But, I didn't see the need for it.
>
> If the hardware does give you 3 working bits for the seconds, you
> could make use of that for a consistency check. If nothing else, you
> could do a
>
> dev_err(dev, 'PTP time is FUBAR');

OK. I'll add a check for that.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7wm4QACgkQeSpbgcuY
8KZtdA//WegWsTtiIgimHSJcxAbCNjZZb/DQ3rwXCgmDnlbo2YyLAkZy1vihHPmQ
ap3m7rKufXNZnbRK5t0YPk8kf1X1cH2blkWRCpVkpQbvvvjfqmP9b6oK+3xY2fJx
iFZc3qpQMgVgQZGh+XcsUZXm0RbmFpCKGt1Ly8BJW7+2zK6ZU0a0Qha49VppXcMH
lPQl9sPp7NwIYCoMnTq5kfxKFS7tcyc0KEOrgdxbXLW+Zz9XkMryZ6sPXkIp2UaM
2ZZ19ha9Dolnk4/TPoMew++D/r/c3PzViYz6NwjT/CKM4PmCaCLBLVvP+np+fLAx
q72sMAPSRtVf9cbCFRycF3PPT5VBpdbnfy5zETBJATVLTVpcsNFM26K3nEUN8obQ
2Ns4t1coTgUlWMS6hcRmm5Tq9aE5ExsZQcRUkQaA712xMqVafV5rJ0nv/VvgCO4k
y5iHan7AFYrvAXm30xFdD3Wy8UThT1zCPWeFSEqQ+kzJ7cOFoeErQsdZcpv24bdh
PIUvv/a8F7U78OTOtHEpAV3Di9uAdL4dEJ4cn0H1VEOAClDJJsJbrbuwYANkMudT
WNEkmk03rhgTJuaq9jXm1hugkr/0HasCEMDD3fv/Ru1L0jUnXiR8mkFrudrA4D/e
OqmNC9FB1z92ah5diUOtkhDaORs22nb0CS2R21g/fLsC8Tu6JAY=
=hnDA
-----END PGP SIGNATURE-----
--=-=-=--
