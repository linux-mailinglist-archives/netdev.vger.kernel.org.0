Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C135A3C1C36
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhGHXnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:43:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46848 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGHXnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 19:43:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AC9AD22223;
        Thu,  8 Jul 2021 23:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625787648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAyJiUM3SEl/diYnvMrP08rNlTVCOq7Z4ZHFaPrJBRE=;
        b=ZRkc/u3bk1VNGpxUtXugn+lIfobDB3pUXs9UmtC0kBVg6ChlxssUe702LmVPHV3PvqBKMS
        8ZvkvO2oNVEfJPHs33zQJlzpxM17ptPMJpWlwdTfhY7E8WFDI1sqXagElxmuEpdkhLRtv0
        5mkhQhJ9pEp8J4ktbZN4fOS0h/CaNtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625787648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yAyJiUM3SEl/diYnvMrP08rNlTVCOq7Z4ZHFaPrJBRE=;
        b=fMfZPbBs4Rg5RgCpR0rdCqwe33tZYqBmQqwaKQOC8/w9+6D+wALSol9NSo2wN+eOpX8t9E
        a0LphLOE4lasUrAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 56295A3B8E;
        Thu,  8 Jul 2021 23:40:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 37DC0607CD; Fri,  9 Jul 2021 01:40:48 +0200 (CEST)
Date:   Fri, 9 Jul 2021 01:40:48 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool v4 0/4] Extend module EEPROM API
Message-ID: <20210708234048.sz34emqbjhiw5l7z@lion.mk-sys.cz>
References: <1623949504-51291-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="54qsjnwknc6mdzmn"
Content-Disposition: inline
In-Reply-To: <1623949504-51291-1-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--54qsjnwknc6mdzmn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 17, 2021 at 08:05:00PM +0300, Moshe Shemesh wrote:
> Ethtool supports module EEPROM dumps via the `ethtool -m <dev>` command.
> But in current state its functionality is limited - offset and length
> parameters, which are used to specify a linear desired region of EEPROM
> data to dump, is not enough, considering emergence of complex module
> EEPROM layouts such as CMIS.
>=20
> Moreover, CMIS extends the amount of pages that may be accessible by
> introducing another parameter for page addressing - banks. Besides,
> currently module EEPROM is represented as a chunk of concatenated pages,
> where lower 128 bytes of all pages, except page 00h, are omitted. Offset
> and length are used to address parts of this fake linear memory. But in
> practice drivers, which implement get_module_info() and
> get_module_eeprom() ethtool ops still calculate page number and set I2C
> address on their own.
>=20
> This series adds support in `ethtool -m` of dumping an arbitrary page
> specified by page number, bank number and I2C address. Implement netlink
> handler for `ethtool -m` in order to make such requests to the kernel
> and extend CLI by adding corresponding parameters.
> New command line format:
>  ethtool -m <dev> [hex on|off] [raw on|off] [offset N] [length N] [page N=
] [bank N] [i2c N]
>=20
> Netlink infrastructure works on per-page basis and allows dumps of a
> single page at once. But in case user requests human-readable output,
> which currently may require more than one page, userspace can make such
> additional calls to kernel on demand and place pages in a linked list.
> It allows to get pages from cache on demand and pass them to refactored
> SFF decoders.
>=20
> Change Log:
> v3 -> v4:
> - Fixed cmis_show_all() prototype
>=20
> v2 -> v3:
> - Removed spec version from CMIS identifiers by changing 'CMIS4' and 'cmi=
s4' to 'CMIS' and 'cmis' respectively.
>=20
> v1 -> v2:
> - Changed offset defines to specification values.
> - Added default offset value (128) if page number is specified.
> - Fixed return values.
> - Removed page_available()
>=20
>=20
>=20
> Vladyslav Tarasiuk (4):
>   ethtool: Add netlink handler for getmodule (-m)
>   ethtool: Refactor human-readable module EEPROM output for new API
>   ethtool: Rename QSFP-DD identifiers to use CMIS
>   ethtool: Update manpages to reflect changes to getmodule (-m) command
>=20
>  Makefile.am             |   3 +-
>  cmis.c                  | 359 +++++++++++++++++++++++++++++++++++++++++
>  cmis.h                  | 128 +++++++++++++++
>  ethtool.8.in            |  14 ++
>  ethtool.c               |   4 +
>  internal.h              |  12 ++
>  list.h                  |  34 ++++
>  netlink/desc-ethtool.c  |  13 ++
>  netlink/extapi.h        |   2 +
>  netlink/module-eeprom.c | 416 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  qsfp-dd.c               | 333 --------------------------------------
>  qsfp-dd.h               | 125 ---------------
>  qsfp.c                  | 130 ++++++++-------
>  qsfp.h                  |  51 +++---
>  sff-common.c            |   3 +
>  sff-common.h            |   3 +-
>  16 files changed, 1090 insertions(+), 540 deletions(-)
>  create mode 100644 cmis.c
>  create mode 100644 cmis.h
>  create mode 100644 list.h
>  create mode 100644 netlink/module-eeprom.c
>  delete mode 100644 qsfp-dd.c
>  delete mode 100644 qsfp-dd.h

Series applied, thank you.

Michal

--54qsjnwknc6mdzmn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmDnjPkACgkQ538sG/LR
dpXzlwgAh0QPCHVOXon23CTXeocQnFwKpbCYplrf7yNR4D5Ub/Pv/kvFHZLB/L5i
yc3GWjJr19yEEHcgv+6CQIdYhfyjaVMS5e1DRD2X6gqXHo/gkhSb/FgqNkqmQRoW
R/gzuMaHrRAHDskdm1ZSGvq3is4ZLmxbDOQOlsGsVAfAT3EpD20rIBKHNMghvLLG
USFFi7DBLMuvqt34/QUDOO4A3NXLFv44ta5lhsXbw43F1EKBkyg1eBFeX4Wgj6sr
UovP7lLgzyR1YJOn3hPwRzxS77bHiqT8olgfuWHGkYWzSk6Tdqz7VGgg+ksScOJE
wUaXnvCdy/DGuwMbyMPVQIURjf4+cg==
=Unee
-----END PGP SIGNATURE-----

--54qsjnwknc6mdzmn--
