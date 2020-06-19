Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAB2003D4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbgFSI0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730651AbgFSI0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:26:48 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D41C06174E;
        Fri, 19 Jun 2020 01:26:48 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmCMH-00045F-OX; Fri, 19 Jun 2020 10:26:45 +0200
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
In-Reply-To: <20200618172304.GG240559@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-4-kurt@linutronix.de> <20200618172304.GG240559@lunn.ch>
Date:   Fri, 19 Jun 2020 10:26:44 +0200
Message-ID: <878sgjqx4r.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

On Thu Jun 18 2020, Andrew Lunn wrote:
>> +static u64 __hellcreek_ptp_clock_read(struct hellcreek *hellcreek)
>> +{
>> +	u16 nsl, nsh, secl, secm, sech;
>> +
>> +	/* Take a snapshot */
>> +	hellcreek_ptp_write(hellcreek, PR_COMMAND_C_SS, PR_COMMAND_C);
>> +
>> +	/* The time of the day is saved as 96 bits. However, due to hardware
>> +	 * limitations the seconds are not or only partly kept in the PTP
>> +	 * core. That's why only the nanoseconds are used and the seconds are
>> +	 * tracked in software. Anyway due to internal locking all five
>> +	 * registers should be read.
>> +	 */
>> +	sech = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> +	secm = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> +	secl = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> +	nsh  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> +	nsl  = hellcreek_ptp_read(hellcreek, PR_SS_SYNC_DATA_C);
>> +
>> +	return (u64)nsl | ((u64)nsh << 16);
>
> Hi Kurt
>
> What are the hardware limitations? There seems to be 48 bits for
> seconds? That allows for 8925104 years?

In theory, yes. Due to hardware hardware considerations only a few or
none of these bits are used for the seconds. The rest is zero. Meaning
that the wraparound is not 8925104 years, but at e.g. 8 seconds when
using 3 bits for the seconds.

I've discussed this the Hirschmann people and they suggested to use the
nanoseconds only. That's what I did here.

>
>> +static u64 __hellcreek_ptp_gettime(struct hellcreek *hellcreek)
>> +{
>> +	u64 ns;
>> +
>> +	ns = __hellcreek_ptp_clock_read(hellcreek);
>> +	if (ns < hellcreek->last_ts)
>> +		hellcreek->seconds++;
>> +	hellcreek->last_ts = ns;
>> +	ns += hellcreek->seconds * NSEC_PER_SEC;
>
> So the assumption is, this gets called at least once per second. And
> if that does not happen, there is no recovery. The second is lost.

Yes, exactly. If a single overflow is missed, then the time is wrong.

>
> I'm just wondering if there is something more robust using what the
> hardware does provide, even if the hardware is not perfect.

I don't think there's a more robust way to do this. The overflow period
is a second which should be enough time to catch the overflow even if
the system is loaded. We did long running tests for days and the
mechanism worked fine. We could also consider to move the delayed work
to a dedicated thread which could be run with real time (SCHED_FIFO)
priority. But, I didn't see the need for it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7sdsQACgkQeSpbgcuY
8KbFFBAA0dobohar7yXi0fNY+RHMDqZnkGjoqMsFXOs4jItq/gtu0Iq45nLnYM6F
BrgFGQ17E4aKVKav98CeCOi8LfpzRSxg928o8fRdPqVHAIshJb9F97Zg1F0vZhT3
8KrZhP6EkxoBiMkDYWdY613Y54yGi5c6Of8MrJHXwRlWHIfXaTc0T1of96o2jqYF
50XS+ZMmp9CNfFKerVKOBd2wiNHXXYMkNllgAckXGWAMyIWASRi5SSqt8ItauVx5
KduSgsQBvH2+1JXCZcOcIk+7SHDGrlNYtTq1uqstiz+SlYkLKWhrrOeWTzZbdQB1
SDTtSoBaCCyQjcywzPh397FSUAupE/nIhPseOTdXzeCr/dH7Cs1WlRdyQyVom21F
jbhMkr47R+0++1IktnoVgOt7/pOZ3YrXN/jt4ZgQsE00p7BN1zCxROe1HOkgkVzU
rA95tU37Kiv38aYychbYvSp4jB4ebT1jjs7kQ6b9wMghJrt+9kJifzQUNvemhM10
dq4ZwkLOxjqdvVeInp0GOhnQvoGMnoG4EnIVQiKrGzDmpB75GJvfASufFU/JTIMU
mKF32D7AGjlxSZtl33zOjYetTt8aiSA6U7wG1z+om1Brvq6AxyC5lSeRzzstjBNK
1Dw2YA1k3cWjgSTMGrNAB+uwP/oZjq70VO8P8p/1SqJ6bbMmYK4=
=3IPt
-----END PGP SIGNATURE-----
--=-=-=--
