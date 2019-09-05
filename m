Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350E6A9F33
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732110AbfIEKDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:03:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:52358 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbfIEKDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:03:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 03:03:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="asc'?scan'208";a="182779968"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga008.fm.intel.com with ESMTP; 05 Sep 2019 03:03:50 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
In-Reply-To: <20190831144732.GA1692@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com> <20190829095825.2108-2-felipe.balbi@linux.intel.com> <20190829172509.GB2166@localhost> <20190829172848.GC2166@localhost> <87r253ulpn.fsf@gmail.com> <20190831144732.GA1692@localhost>
Date:   Thu, 05 Sep 2019 13:03:46 +0300
Message-ID: <87h85roy9p.fsf@gmail.com>
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

Richard Cochran <richardcochran@gmail.com> writes:
> On Fri, Aug 30, 2019 at 11:00:20AM +0300, Felipe Balbi wrote:
>> >> @@ -177,9 +177,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned i=
nt cmd, unsigned long arg)
>> >>  			err =3D -EFAULT;
>> >>  			break;
>> >>  		}
>> >> -		if ((req.perout.flags || req.perout.rsv[0] || req.perout.rsv[1]
>> >> -				|| req.perout.rsv[2] || req.perout.rsv[3])
>> >> -			&& cmd =3D=3D PTP_PEROUT_REQUEST2) {
>> >> +		if ((req.perout.rsv[0] || req.perout.rsv[1] || req.perout.rsv[2]
>> >> +			|| req.perout.rsv[3]) && cmd =3D=3D PTP_PEROUT_REQUEST2) {
>> >
>> > Please check that the reserved bits of req.perout.flags, namely
>> > ~PTP_PEROUT_ONE_SHOT, are clear.
>>=20
>> Actually, we should check more. PEROUT_FEATURE_ENABLE is still valid
>> here, right? So are RISING and FALLING edges, no?
>
> No.  The ptp_extts_request.flags are indeed defined:
>
> struct ptp_extts_request {
> 	...
> 	unsigned int flags;  /* Bit field for PTP_xxx flags. */
> 	...
> };
>
> But the ptp_perout_request.flags are reserved:
>
> struct ptp_perout_request {
> 	...
> 	unsigned int flags;           /* Reserved for future use. */
> 	...
> };

This a bit confusing, really. Specially when the comment right above
those flags states:

/* PTP_xxx bits, for the flags field within the request structures. */

The request "structures" include EXTTS and PEROUT:

struct ptp_clock_request {
	enum {
		PTP_CLK_REQ_EXTTS,
		PTP_CLK_REQ_PEROUT,
		PTP_CLK_REQ_PPS,
	} type;
	union {
		struct ptp_extts_request extts;
		struct ptp_perout_request perout;
	};
};

Seems like we will, at least, make it clear which flags are valid for
which request structures.

> For this ioctl, the test for enable/disable is
> ptp_perout_request.period is zero:
>
> 		enable =3D req.perout.period.sec || req.perout.period.nsec;
> 		err =3D ops->enable(ops, &req, enable);
>
> The usage pattern here is taken from timer_settime(2).

got it

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1w3YIACgkQzL64meEa
mQZ4Tw//aydsxj0fUogJ3Owf7UEMyY3lxgJ/ksnZi3Yu5c/0i6uhPysMUQC+oKQ/
SnY8pPTRe/4cwHwP/GQlCM0Ke5kGW6O48EY3JAO2/19gfEYU1PAb3/nhkngNVLnE
YGry+95dB54oOPo7RhyKddidttqC4dkf5vbSQVtMOG4qP1AxFq0k7YZ8qfJXxtrQ
Wuko8VL3JfG2uqJgQ6/20i1W6yC61cKLUhaXJxEsSuQaE9QbdkDuPfJ3L37uLQPM
zhx1uedyUwUyrRbOfnICTK5xqXLWmTOstYckK+Wh4/LjFquyyPCsFHNs0ZmtrQWV
aAkrX3NA6QrBSqwj3/iUr+6+xFMYrVCuj1haUuRbhSVNfSg9hkQXgP+m8kJbTCGX
yX2wzKe7wl7M0CEln2QEbSmuMKP5oqY0lo9Nj+s/ZDk17EkgQ9g7djYY59osO/MP
92DRp4ys63ajR3DLB6YlUi8yW5iC3R0kCJfxfbvnJIn3QJ3fmlC5l5P+eCZISoxq
p4/QlJNscCI/BFffs861sM2bRipPf7wVHo13PJ8IWrQtlrrYKQCcPvArqke1xB/Y
rPuXPWt/DEzVwH/kxoKQYq3V8yDqOhW477NmLKKub8X6CY4itGg+PHdGXMxfD6BT
/vtnPtWCQVyB5ZNh+BivXv9+Vyo/ZHhtoUF2eKqRUugH51YuDqI=
=SuGX
-----END PGP SIGNATURE-----
--=-=-=--
