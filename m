Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC53FAA00E
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbfIEKkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:40:47 -0400
Received: from mga05.intel.com ([192.55.52.43]:2752 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732763AbfIEKkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:40:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 03:40:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="asc'?scan'208";a="212736836"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 05 Sep 2019 03:40:45 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v2 2/2] PTP: add support for one-shot output
In-Reply-To: <20190831150149.GB1692@localhost>
References: <20190829095825.2108-1-felipe.balbi@linux.intel.com> <20190829095825.2108-2-felipe.balbi@linux.intel.com> <20190829172509.GB2166@localhost> <20190829172848.GC2166@localhost> <87r253ulpn.fsf@gmail.com> <20190831150149.GB1692@localhost>
Date:   Thu, 05 Sep 2019 13:40:41 +0300
Message-ID: <87ef0vowk6.fsf@gmail.com>
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
>> seems like this should be defined together with the other flags? If
>> that's the case, it seems like we would EXTTS and PEROUT masks.
>
> Yes, let's make the meanings of the bit fields clear...
>
> --- ptp_clock.h ---
>
> /*
>  * Bits of the ptp_extts_request.flags field:
>  */
> #define PTP_ENABLE_FEATURE	BIT(0)
> #define PTP_RISING_EDGE		BIT(1)
> #define PTP_FALLING_EDGE	BIT(2)
> #define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE | \
> 				 PTP_RISING_EDGE | \
> 				 PTP_FALLING_EDGE)
>
> /*
>  * Bits of the ptp_perout_request.flags field:
>  */
> #define PTP_PEROUT_ONE_SHOT	BIT(0)
> #define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
>
> struct ptp_extts_request {
> 	unsigned int flags;  /* Bit field of PTP_EXTTS_VALID_FLAGS. */
> };
>
> struct ptp_perout_request {
> 	unsigned int flags;  /* Bit field of PTP_PEROUT_VALID_FLAGS. */
> };

Below you can find the combined patch. Locally, I have it split into two
patches, but this lets us look at the full picture. I'll send it as v3
series of two patches on Monday if you like the result. Let me know if
you prefer that I convert the flags to BIT() macro calls instead.

8<------------------------------------------------------------------------

From=20633a8214c86a43dcf880d7aed33758b576933369 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Wed, 14 Aug 2019 10:31:08 +0300
Subject: [PATCH 1/5] PTP: introduce new versions of IOCTLs

The current version of the IOCTL have a small problem which prevents us
from extending the API by making use of reserved fields. In these new
IOCTLs, we are now making sure that flags and rsv fields are zero which
will allow us to extend the API in the future.

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
=2D--
 drivers/ptp/ptp_chardev.c      | 63 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ptp_clock.h | 26 ++++++++++++--
 2 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 18ffe449efdf..9c18476d8d10 100644
=2D-- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -126,7 +126,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd=
, unsigned long arg)
 	switch (cmd) {
=20
 	case PTP_CLOCK_GETCAPS:
+	case PTP_CLOCK_GETCAPS2:
 		memset(&caps, 0, sizeof(caps));
+
 		caps.max_adj =3D ptp->info->max_adj;
 		caps.n_alarm =3D ptp->info->n_alarm;
 		caps.n_ext_ts =3D ptp->info->n_ext_ts;
@@ -139,11 +141,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int c=
md, unsigned long arg)
 		break;
=20
 	case PTP_EXTTS_REQUEST:
+	case PTP_EXTTS_REQUEST2:
+		memset(&req, 0, sizeof(req));
+
 		if (copy_from_user(&req.extts, (void __user *)arg,
 				   sizeof(req.extts))) {
 			err =3D -EFAULT;
 			break;
 		}
+		if (((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
+			req.extts.rsv[0] || req.extts.rsv[1]) &&
+			cmd =3D=3D PTP_EXTTS_REQUEST2) {
+			err =3D -EINVAL;
+			break;
+		} else if (cmd =3D=3D PTP_EXTTS_REQUEST) {
+			req.extts.flags &=3D ~PTP_EXTTS_VALID_FLAGS;
+			req.extts.rsv[0] =3D 0;
+			req.extts.rsv[1] =3D 0;
+		}
 		if (req.extts.index >=3D ops->n_ext_ts) {
 			err =3D -EINVAL;
 			break;
@@ -154,11 +169,27 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int c=
md, unsigned long arg)
 		break;
=20
 	case PTP_PEROUT_REQUEST:
+	case PTP_PEROUT_REQUEST2:
+		memset(&req, 0, sizeof(req));
+
 		if (copy_from_user(&req.perout, (void __user *)arg,
 				   sizeof(req.perout))) {
 			err =3D -EFAULT;
 			break;
 		}
+		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
+			req.perout.rsv[0] || req.perout.rsv[1] ||
+			req.perout.rsv[2] || req.perout.rsv[3]) &&
+			cmd =3D=3D PTP_PEROUT_REQUEST2) {
+			err =3D -EINVAL;
+			break;
+		} else if (cmd =3D=3D PTP_PEROUT_REQUEST) {
+			req.perout.flags &=3D ~PTP_PEROUT_VALID_FLAGS;
+			req.perout.rsv[0] =3D 0;
+			req.perout.rsv[1] =3D 0;
+			req.perout.rsv[2] =3D 0;
+			req.perout.rsv[3] =3D 0;
+		}
 		if (req.perout.index >=3D ops->n_per_out) {
 			err =3D -EINVAL;
 			break;
@@ -169,6 +200,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd=
, unsigned long arg)
 		break;
=20
 	case PTP_ENABLE_PPS:
+	case PTP_ENABLE_PPS2:
+		memset(&req, 0, sizeof(req));
+
 		if (!capable(CAP_SYS_TIME))
 			return -EPERM;
 		req.type =3D PTP_CLK_REQ_PPS;
@@ -177,6 +211,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd=
, unsigned long arg)
 		break;
=20
 	case PTP_SYS_OFFSET_PRECISE:
+	case PTP_SYS_OFFSET_PRECISE2:
 		if (!ptp->info->getcrosststamp) {
 			err =3D -EOPNOTSUPP;
 			break;
@@ -201,6 +236,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd=
, unsigned long arg)
 		break;
=20
 	case PTP_SYS_OFFSET_EXTENDED:
+	case PTP_SYS_OFFSET_EXTENDED2:
 		if (!ptp->info->gettimex64) {
 			err =3D -EOPNOTSUPP;
 			break;
@@ -232,6 +268,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd=
, unsigned long arg)
 		break;
=20
 	case PTP_SYS_OFFSET:
+	case PTP_SYS_OFFSET2:
 		sysoff =3D memdup_user((void __user *)arg, sizeof(*sysoff));
 		if (IS_ERR(sysoff)) {
 			err =3D PTR_ERR(sysoff);
@@ -266,10 +303,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int c=
md, unsigned long arg)
 		break;
=20
 	case PTP_PIN_GETFUNC:
+	case PTP_PIN_GETFUNC2:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err =3D -EFAULT;
 			break;
 		}
+		if ((pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
+				|| pd.rsv[3] || pd.rsv[4])
+			&& cmd =3D=3D PTP_PIN_GETFUNC2) {
+			err =3D -EINVAL;
+			break;
+		} else if (cmd =3D=3D PTP_PIN_GETFUNC) {
+			pd.rsv[0] =3D 0;
+			pd.rsv[1] =3D 0;
+			pd.rsv[2] =3D 0;
+			pd.rsv[3] =3D 0;
+			pd.rsv[4] =3D 0;
+		}
 		pin_index =3D pd.index;
 		if (pin_index >=3D ops->n_pins) {
 			err =3D -EINVAL;
@@ -285,10 +335,23 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int c=
md, unsigned long arg)
 		break;
=20
 	case PTP_PIN_SETFUNC:
+	case PTP_PIN_SETFUNC2:
 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
 			err =3D -EFAULT;
 			break;
 		}
+		if ((pd.rsv[0] || pd.rsv[1] || pd.rsv[2]
+				|| pd.rsv[3] || pd.rsv[4])
+			&& cmd =3D=3D PTP_PIN_SETFUNC2) {
+			err =3D -EINVAL;
+			break;
+		} else if (cmd =3D=3D PTP_PIN_SETFUNC) {
+			pd.rsv[0] =3D 0;
+			pd.rsv[1] =3D 0;
+			pd.rsv[2] =3D 0;
+			pd.rsv[3] =3D 0;
+			pd.rsv[4] =3D 0;
+		}
 		pin_index =3D pd.index;
 		if (pin_index >=3D ops->n_pins) {
 			err =3D -EINVAL;
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1bc794ad957a..cbdc0d97b471 100644
=2D-- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -25,11 +25,21 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
=20
=2D/* PTP_xxx bits, for the flags field within the request structures. */
+/*
+ * Bits of the ptp_extts_request.flags field:
+ */
 #define PTP_ENABLE_FEATURE (1<<0)
 #define PTP_RISING_EDGE    (1<<1)
 #define PTP_FALLING_EDGE   (1<<2)
+#define PTP_EXTTS_VALID_FLAGS	(PTP_ENABLE_FEATURE |	\
+				 PTP_RISING_EDGE |	\
+				 PTP_FALLING_EDGE)
=20
+/*
+ * Bits of the ptp_perout_request.flags field:
+ */
+#define PTP_PEROUT_ONE_SHOT (1<<0)
+#define PTP_PEROUT_VALID_FLAGS	(~PTP_PEROUT_ONE_SHOT)
 /*
  * struct ptp_clock_time - represents a time value
  *
@@ -67,7 +77,7 @@ struct ptp_perout_request {
 	struct ptp_clock_time start;  /* Absolute start time. */
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
=2D	unsigned int flags;           /* Reserved for future use. */
+	unsigned int flags;
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
=20
@@ -149,6 +159,18 @@ struct ptp_pin_desc {
 #define PTP_SYS_OFFSET_EXTENDED \
 	_IOWR(PTP_CLK_MAGIC, 9, struct ptp_sys_offset_extended)
=20
+#define PTP_CLOCK_GETCAPS2  _IOR(PTP_CLK_MAGIC, 10, struct ptp_clock_caps)
+#define PTP_EXTTS_REQUEST2  _IOW(PTP_CLK_MAGIC, 11, struct ptp_extts_reque=
st)
+#define PTP_PEROUT_REQUEST2 _IOW(PTP_CLK_MAGIC, 12, struct ptp_perout_requ=
est)
+#define PTP_ENABLE_PPS2     _IOW(PTP_CLK_MAGIC, 13, int)
+#define PTP_SYS_OFFSET2     _IOW(PTP_CLK_MAGIC, 14, struct ptp_sys_offset)
+#define PTP_PIN_GETFUNC2    _IOWR(PTP_CLK_MAGIC, 15, struct ptp_pin_desc)
+#define PTP_PIN_SETFUNC2    _IOW(PTP_CLK_MAGIC, 16, struct ptp_pin_desc)
+#define PTP_SYS_OFFSET_PRECISE2 \
+	_IOWR(PTP_CLK_MAGIC, 17, struct ptp_sys_offset_precise)
+#define PTP_SYS_OFFSET_EXTENDED2 \
+	_IOWR(PTP_CLK_MAGIC, 18, struct ptp_sys_offset_extended)
+
 struct ptp_extts_event {
 	struct ptp_clock_time t; /* Time event occured. */
 	unsigned int index;      /* Which channel produced the event. */
=2D-=20
2.23.0


=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEElLzh7wn96CXwjh2IzL64meEamQYFAl1w5ikACgkQzL64meEa
mQbwhw//QR9zKOURzDECiTDuaFWVFfTbQwuIKk5YykFM2LdCI5qc1TsCd0dEueVG
Wt7DEkeFrjrgvH1rnPLQlXGcaq4a/icX/vPx4N+cV92HS8KfVyun/wVRLQPPoazE
Twe5PTFKo6ez++bw1Dn8KHxT+CKeuA5TQUN3Fkkh1qSI9USnXNob2Dl+1OY6vc8k
d8T4rGyNIsKpt2yKnZBL1qmEgTiRVjEwRYnK1js329c5TwPMs5SDolJ90iOrvX63
mOc3zYjlO9SdM8eX3ZTMpgDdRA1a2OEqu35jNSYNORwjS3c7QJsYubkwsKd0366x
LyRlsZFJx1fjeToSe/uxqmnD0eQRabAkQKVwClC6CLCyenPSROOWwk/TFxPFCIur
FDZbbL9jE6l8WsRK1TVnvY8Puhs0aB2hTRlDToYrJj9b6bH0uONGTGoY8Io/LJT6
NmpmFwLBVrYfr+6BuvaWtars44jqybCPm0/Fl8hOXzd8WJRni1W0WTToE7qP6mDf
zsQaKAxUP68+iXZLN1BSkwaePE4FOOgwVFQmCEwhxcNQrH/xgKO5VduXkB/HUe4x
2mImCjTkOMkNOEdFwvGzPh2PpCNJFrkj/43ECYbKVI8W+gfI+Q06kSsjDcrnn7N6
m1dm6PUSOq2P13Q5z1EdLk/Bdzo41Rn2EsNMG40hLixdotPRaJE=
=rVLn
-----END PGP SIGNATURE-----
--=-=-=--
