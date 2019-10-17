Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE44DABA8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502268AbfJQMBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:01:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:63187 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502256AbfJQMBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 08:01:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 05:01:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,307,1566889200"; 
   d="asc'?scan'208";a="226141770"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 17 Oct 2019 05:01:48 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
In-Reply-To: <alpine.DEB.2.21.1910171256580.1824@nanos.tec.linutronix.de>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-2-felipe.balbi@linux.intel.com> <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de> <87y2zvt1hk.fsf@gmail.com> <alpine.DEB.2.21.1908151458560.1923@nanos.tec.linutronix.de> <87y2y4vk4g.fsf@gmail.com> <alpine.DEB.2.21.1910171256580.1824@nanos.tec.linutronix.de>
Date:   Thu, 17 Oct 2019 15:01:44 +0300
Message-ID: <871rvblgwn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Thomas Gleixner <tglx@linutronix.de> writes:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> > On Thu, 15 Aug 2019, Felipe Balbi wrote:
>> >> Thomas Gleixner <tglx@linutronix.de> writes:
>> >> > On Tue, 16 Jul 2019, Felipe Balbi wrote:
>> >> >
>> >> > So some information what those interfaces are used for and why they=
 are
>> >> > needed would be really helpful.
>> >>=20
>> >> Okay, I have some more details about this. The TGPIO device itself us=
es
>> >> ART since TSC is not directly available to anything other than the
>> >> CPU. The 'problem' here is that reading ART incurs extra latency which
>> >> we would like to avoid. Therefore, we use TSC and scale it to
>> >> nanoseconds which, would be the same as ART to ns.
>> >
>> > Fine. But that's not really correct:
>> >
>> >       TSC =3D art_to_tsc_offset + ART * scale;
>>=20
>> From silicon folks I got the equation:
>>=20
>> ART =3D ECX * EBX / EAX;
>
> What is the content of ECX/EBX/EAX and where is it coming from?

Since last email, I got a bit of extra information about how all of
these should work.

ECX contains crystal rate of TSC, EBX and EAX contain constants for
converting between TSC and ART.

So, ART =3D tsc_cycles * EBX/EAX, this will give me ART cycles. Also, the
time gpio IP needs ART cycles to be written to its comparator
registers, but the PTP framework wants time in nanoseconds.

Therefore we need two new conversion functions:
convert_tsc_to_art_cycles() and something which gives us current TSC in
nanoseconds.

>> If I'm reading this correctly, that's basically what
>> native_calibrate_tsc() does (together with some error checking the safe
>> defaults). Couldn't we, instead, just have a single function like below?
>>=20
>> u64 convert_tsc_to_art_ns()
>> {
>> 	return x86_platform.calibrate_tsc();
>> }
>
> Huch? How is that supposed to work? calibrate_tsc() returns the TSC
> frequency.

Yup, that was a total brain fart.

>> Another way would be extract the important parts from
>> native_calibrate_tsc() into a separate helper. This would safe another
>> call to cpuid(0x15,...);
>
> What for?
>
> The relation between TSC and ART is already established via detect_art()
> which reads all relevant data out of CPUID(ART_CPUID_LEAF).
>
> We use exactly that information for convert_art_to_tsc() so the obvious
> solution for calculating ART from TSC is to do the reverse operation.
>
> convert_art_to_tsc()
> {
>         rem =3D do_div(art, art_to_tsc_denominator);
>
>         res =3D art * art_to_tsc_numerator;
>         tmp =3D rem * art_to_tsc_numerator;
>
>         do_div(tmp, art_to_tsc_denominator);
>         res +=3D tmp + art_to_tsc_offset;
> }
>
> which is translated into math:
>
>       TSC =3D ART * SCALE + OFFSET
>
> where
>
>       SCALE =3D N / D
>
> and
>
>       N =3D CPUID(ART_CPUID_LEAF).EAX
>       D =3D CPUID(ART_CPUID_LEAF).EBX
>
> So the obvious reverse operation is:
>
>      ART =3D (TSC - OFFSET) / SCALE;
>
> Translating that into code should not be rocket science.

Right, that's where we got after talking to other folks.

Do you have any preferences for the function names? Or does
convert_tsc_to_art() sound ok?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl2oWCgACgkQzL64meEa
mQaskg//UjTHS4UimreqJKDM7FsvbGB2vp3sEB2o2x6PGs69BwPUJzruHrSPmWxF
IT3YOZdQU4RX3T4K8q283FKJ6oUViOHEoGMN7C9ey83mrl8GkC8Pl1uxXOefwPxA
cvEuoCMagJofHl54D7J9kLuCw2dugRFuWSqs+Xy1duZKC0vWm0w+qxR0R+K8Y5tq
EpPc/LFm5hyxqZnvsiexWUF2RcGZ/qA6G655/AZ1AZxXh4l8XbnnTpjBr6eZOsTT
9DkYSzQ/PciUmPA4fswB1aXgXBtONJckpLw6BMdW1Y/BR66d5CVeaXbaiv6awq53
PH+R0qsqsVlFyG4KsbjM1CPIq4GlndMlmGd5G3Eklxnv96veT0KpLeSZjF2VocTu
1ewKWZLJnGLIIW7PUR/Lwmpt0ATUzWNKJaY4IOhnXztjuaNyTWrSuoTVgkd4LyKn
pCqfUa+lSKuRETbkEa02iJKIbfSWr7EKeFknGfO3cGRShgwSb/tGNSfmdnKwxFuy
+qAFR6xCTLg/zdG0vIFv8LF+y+k3E02QPI4pYClQr3pEiLKap17dIcGXVQ2D0cfm
/IP9tLQ2btt2JXjEbcnm1VxqgelSjG+0jJwQXhEHelKt9p4Qcby+5w95PQSHkR1H
dx3L3iC0znAC6fjLDySgjqHpHCwFHMw5yDUEIYpvXUrKMMpiYH8=
=NUAn
-----END PGP SIGNATURE-----
--=-=-=--
