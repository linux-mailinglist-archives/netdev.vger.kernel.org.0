Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4DCC314D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730582AbfJAKYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:24:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:17390 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbfJAKYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 06:24:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 03:24:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,570,1559545200"; 
   d="asc'?scan'208";a="220954053"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 01 Oct 2019 03:24:35 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 1/5] x86: tsc: add tsc to art helpers
In-Reply-To: <alpine.DEB.2.21.1908151458560.1923@nanos.tec.linutronix.de>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-2-felipe.balbi@linux.intel.com> <alpine.DEB.2.21.1907160952040.1767@nanos.tec.linutronix.de> <87y2zvt1hk.fsf@gmail.com> <alpine.DEB.2.21.1908151458560.1923@nanos.tec.linutronix.de>
Date:   Tue, 01 Oct 2019 13:24:31 +0300
Message-ID: <87y2y4vk4g.fsf@gmail.com>
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

(sorry for the long delay, got caught up in other tasks)

Thomas Gleixner <tglx@linutronix.de> writes:
> On Thu, 15 Aug 2019, Felipe Balbi wrote:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> > On Tue, 16 Jul 2019, Felipe Balbi wrote:
>> >
>> > So some information what those interfaces are used for and why they are
>> > needed would be really helpful.
>>=20
>> Okay, I have some more details about this. The TGPIO device itself uses
>> ART since TSC is not directly available to anything other than the
>> CPU. The 'problem' here is that reading ART incurs extra latency which
>> we would like to avoid. Therefore, we use TSC and scale it to
>> nanoseconds which, would be the same as ART to ns.
>
> Fine. But that's not really correct:
>
>       TSC =3D art_to_tsc_offset + ART * scale;

From=20silicon folks I got the equation:

ART =3D ECX * EBX / EAX;

If I'm reading this correctly, that's basically what
native_calibrate_tsc() does (together with some error checking the safe
defaults). Couldn't we, instead, just have a single function like below?

u64 convert_tsc_to_art_ns()
{
	return x86_platform.calibrate_tsc();
}

Another way would be extract the important parts from
native_calibrate_tsc() into a separate helper. This would safe another
call to cpuid(0x15,...);

>> >> +void get_tsc_ns(struct system_counterval_t *tsc_counterval, u64 *tsc=
_ns)
>
> Why is this not returning the result instead of having that pointer
> indirection?

That can be changed easily, no worries.

>> >> +{
>> >> +	u64 tmp, res, rem;
>> >> +	u64 cycles;
>> >> +
>> >> +	tsc_counterval->cycles =3D clocksource_tsc.read(NULL);
>> >> +	cycles =3D tsc_counterval->cycles;
>> >> +	tsc_counterval->cs =3D art_related_clocksource;
>
> So this does more than returning the TSC time converted to nanoseconds. T=
he
> function name should reflect this. Plus both functions want kernel-doc
> explaining what they do.

convert_tsc_to_art_ns()? That would be analogous to convert_art_to_tsc()
and convert_art_ns_to_tsc().

cheers

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl2TKV8ACgkQzL64meEa
mQavbw/8DuVOATQnOMj+Ng0sKlu26pZeFznN46wERGArebhbba4GAz4DY55ONSR/
1tX4bovky6KOmLh7p+rzHlR0IQ66osWP/pl0F1hVAG/zXabH5jya8TiSnmbZEMMG
s3mAPu8WyEeoPXBT964w/wmnu7fvS/hHnRYhkfLJ16E59/7SiFYz6H6RphKmq6iH
a+ykrTKt97UNw8HDFyNrfl+cTIfHELOxvzxu2ppBI5soaOjFmYC2Wtiw1SpORWBS
p4WPOk8kmwVQzCQPf1EqF0nC0nBCcniPKcxzFKz6OjBXbASbarftabp1M1i+COW3
vwQTKavAbKaCxJs6HfXxSS9f59nkKlZN7Owp1xRCglT/3b9XGwZLmecu8t8Cw9z2
QNBhBorXsrJwf26Xot+GgxpUYPDhetkSfHAOGoXRe/+ZXSJnceH51cif6PXrCEk1
x5/BrsK5ATMKeioVpiriHkdRFAg9EdsPaXoVkaEWBvQWMKNLQppdItz8NyNWYM1D
E/qfICZzZGpAeHkukVIw8rbFFeFgSF8Vr8ARjqW7MNBtDM9P7xg/fyJvbQ+E9KTT
GoZXc4EsjlgcMzpgFgDWlWkCMvQxf3dtx8PEshEe44LeEJRlw2MaCTlsjoNRHAld
/NLsiCENtVMLWmaPLIy4wHtNNiP29orf9xVoOyUqFTobx5RVsuk=
=keGU
-----END PGP SIGNATURE-----
--=-=-=--
