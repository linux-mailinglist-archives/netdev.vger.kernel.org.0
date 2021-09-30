Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED641E2A4
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347862AbhI3UXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:23:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48556 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347353AbhI3UXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:23:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 72B1122402;
        Thu, 30 Sep 2021 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633033296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9g75lAyLFkTda2g/McMXgcaclXSCYLuRfhdLWCumKkY=;
        b=HM+Nwl06H49OgFnqiCTo5iCOqxkA4mAvz2ISiH6/rhSrPSPOy5zmf6HA20TBUY62PgWC2Y
        hdx16umL/14tIco1SSHD7lOTX2t0FBQ/krAlhIX7rEgy1mlFnhj35cffsJz567wtT+x3un
        RwaWhx7PeuvaBLOBG3oaClo4XOfo4Fs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633033296;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9g75lAyLFkTda2g/McMXgcaclXSCYLuRfhdLWCumKkY=;
        b=v+tSPTAOfpLU5b2RrylfG1dCVV6kVZmEziDBWFVNeK5bq+redCtw3ZBNKJk8BfPTip57o4
        RRwiZQ1UalFxIvCA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 64FCAA3B81;
        Thu, 30 Sep 2021 20:21:36 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4A50E603E0; Thu, 30 Sep 2021 22:21:33 +0200 (CEST)
Date:   Thu, 30 Sep 2021 22:21:33 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 1/7] cmis: Fix CLEI code parsing
Message-ID: <20210930202133.rspuswnnbnnhlgeb@lion.mk-sys.cz>
References: <20210917144043.566049-1-idosch@idosch.org>
 <20210917144043.566049-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3ybpthoeyshqsjg3"
Content-Disposition: inline
In-Reply-To: <20210917144043.566049-2-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3ybpthoeyshqsjg3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 17, 2021 at 05:40:37PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
>=20
> In CMIS, unlike SFF-8636, there is no presence indication for the CLEI
> code (Common Language Equipment Identification) field. The field is
> always present, but might not be supported. In which case, "a value of
> all ASCII 20h (spaces) shall be entered".
>=20
> Therefore, remove the erroneous check which seems to be influenced from
> SFF-8636 and only print the string if it is supported and has a non-zero
> length.
>=20
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  cmis.c | 8 +++++---
>  cmis.h | 3 +--
>  2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/cmis.c b/cmis.c
> index 1a91e798e4b8..2a48c1a1d56a 100644
> --- a/cmis.c
> +++ b/cmis.c
> @@ -307,6 +307,8 @@ static void cmis_show_link_len(const __u8 *id)
>   */
>  static void cmis_show_vendor_info(const __u8 *id)
>  {
> +	const char *clei =3D (const char *)(id + CMIS_CLEI_START_OFFSET);
> +
>  	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
>  		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
>  	cmis_show_oui(id);
> @@ -319,9 +321,9 @@ static void cmis_show_vendor_info(const __u8 *id)
>  	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
>  		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
> =20
> -	if (id[CMIS_CLEI_PRESENT_BYTE] & CMIS_CLEI_PRESENT_MASK)
> -		sff_show_ascii(id, CMIS_CLEI_START_OFFSET,
> -			       CMIS_CLEI_END_OFFSET, "CLEI code");
> +	if (strlen(clei) && strcmp(clei, CMIS_CLEI_BLANK))
> +		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
> +			       "CLEI code");
>  }
> =20
>  void qsfp_dd_show_all(const __u8 *id)

Is it safe to assume that the string will be always null terminated?
Looking at the code below, CMIS_CLEI_BLANK consists of 10 spaces which
would fill the whole block at offsets 0xBE through 0xC7 with spaces and
offset 0xC8 is used as CMIS_PWR_CLASS_OFFSET. Also, sff_show_ascii()
doesn't seem to expect a null terminated string, rather a space padded
one.

Michal


> diff --git a/cmis.h b/cmis.h
> index 78ee1495bc33..d365252baa48 100644
> --- a/cmis.h
> +++ b/cmis.h
> @@ -34,10 +34,9 @@
>  #define CMIS_DATE_VENDOR_LOT_OFFSET		0xBC
> =20
>  /* CLEI Code (Page 0) */
> -#define CMIS_CLEI_PRESENT_BYTE			0x02
> -#define CMIS_CLEI_PRESENT_MASK			0x20
>  #define CMIS_CLEI_START_OFFSET			0xBE
>  #define CMIS_CLEI_END_OFFSET			0xC7
> +#define CMIS_CLEI_BLANK				"          "
> =20
>  /* Cable assembly length */
>  #define CMIS_CBL_ASM_LEN_OFFSET			0xCA
> --=20
> 2.31.1
>=20

--3ybpthoeyshqsjg3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmFWHEcACgkQ538sG/LR
dpUdJwgAuPphJeVjEXRM1tfCvISWSoYyDvgR54ZsuGIlLMtq1RPPf5ZUigAG/AeV
ZbJmFSJ2mVF1dmMmlImpKyFM9wh/nDSaj1qZ5Ss5NG+1AIhgtAmabkV/ZzgJUJas
XAlSPE8cm0F9403005D4h7ph195jQTWyJ3R0XAjkIH/5Y6At6OqmYnzDbeEte90E
FxCE8aQEi8xFt6vRSKnawuQMMUxsFV5kZvp/2f+Yoz7k2vaVVcvMiQV6yxlSDMha
Ipt3DITi7ompOlxUBgPbi67EVfZYGACWg2YIgk1Tyi21QcQ+JGvLkW1Z8aA/sGP7
Tn5MprgphdQt4976v20hmRgE85ypqg==
=kUtx
-----END PGP SIGNATURE-----

--3ybpthoeyshqsjg3--
