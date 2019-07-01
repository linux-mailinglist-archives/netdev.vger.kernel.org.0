Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9295C1F4
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbfGAR0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:26:52 -0400
Received: from mga05.intel.com ([192.55.52.43]:29647 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbfGAR0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:26:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jul 2019 10:26:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,440,1557212400"; 
   d="asc'?scan'208";a="157358237"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 01 Jul 2019 10:26:51 -0700
Message-ID: <1203ebd7c815a4aba4cf6ff12c4d7a8548c51952.camel@intel.com>
Subject: Re: [net-next 08/15] iavf: Fix up debug print macro
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Joe Perches <joe@perches.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Date:   Mon, 01 Jul 2019 10:27:17 -0700
In-Reply-To: <9408eb59ecaa3e245fd71ec0211a34c3fb0e324b.camel@perches.com>
References: <20190628224932.3389-1-jeffrey.t.kirsher@intel.com>
         <20190628224932.3389-9-jeffrey.t.kirsher@intel.com>
         <9408eb59ecaa3e245fd71ec0211a34c3fb0e324b.camel@perches.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-s/9T3Yq9eTbqzYHkqaXV"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-s/9T3Yq9eTbqzYHkqaXV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-06-29 at 13:42 -0700, Joe Perches wrote:
> On Fri, 2019-06-28 at 15:49 -0700, Jeff Kirsher wrote:
> > This aligns the iavf_debug() macro with the other Intel drivers.
> >=20
> > Add the bus number, bus_id field to i40e_bus_info so output shows
> > each physical port(i.e func) in following format:
> >   [[[[<domain>]:]<bus>]:][<slot>][.[<func>]]
> > domains are numbered from 0 to ffff), bus (0-ff), slot (0-1f) and
> > function (0-7).
> >=20
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > ---
> >  drivers/net/ethernet/intel/iavf/iavf_osdep.h | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> > b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> > index d39684558597..a452ce90679a 100644
> > --- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> > +++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> > @@ -44,8 +44,12 @@ struct iavf_virt_mem {
> >  #define iavf_allocate_virt_mem(h, m, s)
> > iavf_allocate_virt_mem_d(h, m, s)
> >  #define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
> > =20
> > -#define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s,
> > ##__VA_ARGS__)
> > -extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
> > -	__printf(3, 4);
> > +#define iavf_debug(h, m, s, ...)				\
> > +do {							=09
> > \
> > +	if (((m) & (h)->debug_mask))				\
> > +		pr_info("iavf %02x:%02x.%x " s,			\
> > +			(h)->bus.bus_id, (h)->bus.device,	\
> > +			(h)->bus.func, ##__VA_ARGS__);		\
> > +} while (0)
>=20
> Why not change the function to do this?
>=20
> And if this is really wanted this particular way
> the now unused function should be removed too.
>=20
> But I suggest emitting at KERN_DEBUG and using
> the more typical %pV vsprintf extension.

I see what you are saying, I was only looking at the macro in the osdep
to align with our other drivers and sync up with our internal driver
code.  Let me review the iavf driver debug function to see if there are
additional fix-ups/sync-ups needed.

>=20
> ---
>=20
>  drivers/net/ethernet/intel/iavf/iavf_main.c  | 25 ++++++++++++++--
> ---------
>  drivers/net/ethernet/intel/iavf/iavf_osdep.h |  9 ++++++---
>  2 files changed, 20 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 881561b36083..8504fd71d398 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -143,25 +143,28 @@ enum iavf_status iavf_free_virt_mem_d(struct
> iavf_hw *hw,
>  }
> =20
>  /**
> - * iavf_debug_d - OS dependent version of debug printing
> + * _iavf_debug - OS dependent version of debug printing
>   * @hw:  pointer to the HW structure
>   * @mask: debug level mask
> - * @fmt_str: printf-type format description
> + * @fmt: printf-type format description
>   **/
> -void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
> +void _iavf_debug(const struct iavf_hw *hw, u32 mask, const char
> *fmt, ...)
>  {
> -	char buf[512];
> -	va_list argptr;
> +	struct va_format vaf;
> +	va_list args;
> =20
> -	if (!(mask & ((struct iavf_hw *)hw)->debug_mask))
> +	if (!(hw->debug_mask & mask))
>  		return;
> =20
> -	va_start(argptr, fmt_str);
> -	vsnprintf(buf, sizeof(buf), fmt_str, argptr);
> -	va_end(argptr);
> +	va_start(args, fmt);
> =20
> -	/* the debug string is already formatted with a newline */
> -	pr_info("%s", buf);
> +	vaf.fmt =3D fmt;
> +	vaf.va =3D &args;
> +
> +	pr_debug("iavf %02x:%02x.%x %pV",
> +		 hw->bus.bus_id, hw->bus.device, hw->bus.func, &vaf);
> +
> +	va_end(args);
>  }
> =20
>  /**
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> index d39684558597..0e6ac7d262c8 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
> @@ -44,8 +44,11 @@ struct iavf_virt_mem {
>  #define iavf_allocate_virt_mem(h, m, s) iavf_allocate_virt_mem_d(h,
> m, s)
>  #define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
> =20
> -#define iavf_debug(h, m, s, ...)  iavf_debug_d(h, m, s,
> ##__VA_ARGS__)
> -extern void iavf_debug_d(void *hw, u32 mask, char *fmt_str, ...)
> -	__printf(3, 4);
> +struct iavf_hw;
> +
> +__printf(3, 4)
> +void _iavf_debug(const struct iavf_hw *hw, u32 mask, const char
> *fmt, ...);
> +#define iavf_debug(hw, mask, fmt, ...)			=09
> 	\
> +	_iavf_debug(hw, mask, fmt, ##__VA_ARGS__)
> =20
>  #endif /* _IAVF_OSDEP_H_ */
>=20
>=20


--=-s/9T3Yq9eTbqzYHkqaXV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl0aQnUACgkQ5W/vlVpL
7c5kKxAAg93E8Vy1gg22APPqvrB+lcpzn/hbDpvY3QK9PxDuWZ3pxFepzzj/1TSh
yTFO/ULCQwT1JY9lvdomczh1uEyUOgZi1kfvmDAuBdFcqxEh5qtqrbVJe0Bq3rkV
RAsn1SLmmxtUKhgL4YDeD09dhYOBkm+rp6N8yXrGr+QoEtJMiSCgteFIRVkhKWRr
C4dni0ApmqG7M0/4CH0Ng6kKnj0PMYh8aR01/pn1+cMlEYUzZfupBN6iANE3winR
/V3k/lp699/yF/AvXYEfOqLniFqNNE9ggps7YD9icOEUGGW77AR2C5yZ8R+Z1975
0utR5n5NMEpRgUq59I7+0XNwejc/DthF57nwZ3nagPel14qS5UQ7H+PsEI00QLIw
TO1OcS3Hovr0PvpaAqO1lwaJpZUBc82HfG+F3VQcNI313KWlBB+Zqwoj/NIE+rEy
SD1Y8Gp9P6VokmQTr8fpRysV5Qhung1h/CMMAR5NpY3r0c0/4+/Y6OsLpA9S3ccT
ngMMVKUNf1TcEfT0DIIiCd/1o3WigqD1UvPOdaYU0sFuJcid1sj+DmARo5lU9V81
bdtgPhZvXuD1m+VPBOmpMMy4Z/smTbzZhZwYstd1f5K2jf42Ae7AvVVyzGumO+Ew
CRMT4nHIVYYHM44SCr7mMmsJ15Tryk40Lj5oVnglNCBcYvUDsMs=
=aFFD
-----END PGP SIGNATURE-----

--=-s/9T3Yq9eTbqzYHkqaXV--

